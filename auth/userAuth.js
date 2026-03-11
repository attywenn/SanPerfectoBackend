import express from "express"
import mysql from "mysql2/promise"
import cors from "cors"
import bcrypt from "bcryptjs"
import jwt from "jsonwebtoken"
import multer from "multer"
import path from "path"
import fs from "fs"
import { fileURLToPath } from "url"

const app = express()

app.use(cors())
app.use(express.json())

let db

const JWT_SECRET = process.env.JWT_SECRET || "dev-change-this-secret"
const JWT_EXPIRES_IN = "1h"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const UPLOAD_DIR = path.join(__dirname, "..", "uploads")
fs.mkdirSync(UPLOAD_DIR, { recursive: true })

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, UPLOAD_DIR),
  filename: (_req, file, cb) => {
    const safeBase = path
      .basename(file.originalname)
      .replace(/[^a-zA-Z0-9._-]/g, "_")
    cb(null, `${Date.now()}_${Math.random().toString(16).slice(2)}_${safeBase}`)
  }
})

const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 } // 5MB
})

app.use("/uploads", express.static(UPLOAD_DIR))

function signToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN })
}

function authRequired(req, res, next) {
  const header = req.headers.authorization || ""
  const token = header.startsWith("Bearer ") ? header.slice(7) : null
  if (!token) return res.status(401).json({ success: false, message: "Missing token" })
  try {
    req.auth = jwt.verify(token, JWT_SECRET)
    return next()
  } catch {
    return res.status(401).json({ success: false, message: "Invalid token" })
  }
}

function requireRole(roles) {
  return (req, res, next) => {
    if (!req.auth?.role || !roles.includes(req.auth.role)) {
      return res.status(403).json({ success: false, message: "Forbidden" })
    }
    return next()
  }
}

/* 

server status endpoint
 
*/

app.get("/", (req, res) => {
  res.json({ message: "Server running" })
})

/*
  LOGIN ENDPOINT
  - Expects:
    - patient: { username, password, dob, role:'patient' }
    - health_worker: { username, password, role:'health_worker' }
    - admin: { username|email, password, role:'admin', q1, q2, q3 } (DOB not required)
  - Uses bcrypt + JWT
*/

app.post("/api/login", async (req, res) => {
  try {
    const { username, email, password, dob, role, q1, q2, q3 } = req.body

    if (!password || !role) {
      return res.json({ success: false, message: "Password and role are required" })
    }

    let sql
    let params

    if (role === "patient") {
      if (!username || !dob) {
        return res.json({ success: false, message: "Username, password, DOB and role are required" })
      }
      sql = `
        SELECT 
          u.user_id,
          u.username,
          u.password_hash,
          u.role,
          p.date_of_birth
        FROM users u
        INNER JOIN patients p ON p.user_id = u.user_id
        WHERE u.username = ? AND u.role = ? AND p.date_of_birth = ?
      `
      params = [username, role, dob]
    } else if (role === "health_worker") {
      if (!username) {
        return res.json({ success: false, message: "Username, password and role are required" })
      }
      sql = `
        SELECT 
          u.user_id,
          u.username,
          u.password_hash,
          u.role
        FROM users u
        WHERE u.username = ? AND u.role = ?
      `
      params = [username, role]
    } else if (role === "admin") {
      const identifier = username || email
      if (!identifier) {
        return res.json({ success: false, message: "Username or email is required for admin login" })
      }
      if (!q1 || !q2 || !q3) {
        return res.json({ success: false, message: "Admin security answers are required" })
      }

      sql = `
        SELECT 
          u.user_id,
          u.username,
          u.email,
          u.password_hash,
          u.role
        FROM users u
        WHERE (u.username = ? OR u.email = ?) AND u.role = 'admin'
      `
      params = [identifier, identifier]
    } else {
      return res.json({ success: false, message: "Invalid role" })
    }

    const [rows] = await db.query(sql, params)

    if (rows.length === 0) {
      return res.json({
        success: false,
        message:
          role === "patient"
            ? "User not found or wrong birthdate for this patient"
            : "User not found for the selected role"
      })
    }

    const user = rows[0]

    const passwordMatch = await bcrypt.compare(password, user.password_hash)
    if (!passwordMatch) {
      return res.json({
        success: false,
        message: "Wrong password"
      })
    }

    if (role === "admin") {
      // Developer-provided fixed 3 security answers (step 2).
      // Later you can store hashed answers in user_security_questions.
      if (
        String(q1).trim() !== "1234" ||
        String(q2).trim() !== "abc123" ||
        String(q3).trim() !== "perfect"
      ) {
        return res.json({ success: false, message: "Wrong admin security answers" })
      }
    }

    const token = signToken({
      userId: user.user_id,
      username: user.username,
      role: user.role
    })

    res.json({
      success: true,
      message: "Login successful",
      user: {
        id: user.user_id,
        username: user.username,
        role: user.role
      },
      token
    })
  } catch (error) {
    console.error("Login error:", error)
    res.json({
      success: false,
      message: "Server error"
    })
  }
})

/*
  PATIENT REGISTRATION ENDPOINT
  - Expects patient info, creates user + patient rows
*/

app.post(
  "/api/register/patient",
  upload.fields([
    { name: "profileImage", maxCount: 1 },
    { name: "identityImage", maxCount: 1 }
  ]),
  async (req, res) => {
  try {
    const {
      username,
      password,
      surname,
      firstname,
      middlename,
      dob,
      address,
      contactNumber
    } = req.body

    if (
      !username ||
      !password ||
      !surname ||
      !firstname ||
      !dob ||
      !address ||
      !contactNumber
    ) {
      return res.json({
        success: false,
        message:
          "Username, password, surname, firstname, DOB, address and contact number are required"
      })
    }

    const [existing] = await db.query(
      "SELECT user_id FROM users WHERE username = ?",
      [username]
    )

    if (existing.length > 0) {
      return res.json({
        success: false,
        message: "Username is already taken"
      })
    }

    const passwordHash = await bcrypt.hash(password, 10)

    const [userResult] = await db.query(
      "INSERT INTO users (username, password_hash, role) VALUES (?, ?, 'patient')",
      [username, passwordHash]
    )

    const userId = userResult.insertId

    await db.query(
      `INSERT INTO patients 
        (user_id, surname, firstname, middlename, date_of_birth, address, contact_number)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [
        userId,
        surname,
        firstname,
        middlename || null,
        dob,
        address,
        contactNumber
      ]
    )

    const profileFile = req.files?.profileImage?.[0] || null
    const identityFile = req.files?.identityImage?.[0] || null

    let profileFileId = null
    let identityFileId = null

    if (profileFile) {
      const [r] = await db.query(
        `INSERT INTO files 
          (user_id, purpose, original_name, storage_name, storage_path, mime_type, size_bytes)
         VALUES (?, 'profile_image', ?, ?, ?, ?, ?)`,
        [
          userId,
          profileFile.originalname,
          profileFile.filename,
          `/uploads/${profileFile.filename}`,
          profileFile.mimetype,
          profileFile.size
        ]
      )
      profileFileId = r.insertId
    }

    if (identityFile) {
      const [r] = await db.query(
        `INSERT INTO files 
          (user_id, purpose, original_name, storage_name, storage_path, mime_type, size_bytes)
         VALUES (?, 'patient_identity', ?, ?, ?, ?, ?)`,
        [
          userId,
          identityFile.originalname,
          identityFile.filename,
          `/uploads/${identityFile.filename}`,
          identityFile.mimetype,
          identityFile.size
        ]
      )
      identityFileId = r.insertId

      await db.query(
        `INSERT INTO patient_verifications (user_id, status, submitted_file_id)
         VALUES (?, 'pending', ?)`,
        [userId, identityFileId]
      )
    }

    res.json({
      success: true,
      message: "Patient registered successfully",
      uploads: {
        profileImageFileId: profileFileId,
        identityImageFileId: identityFileId
      }
    })
  } catch (error) {
    console.error("Patient registration error:", error)
    res.json({
      success: false,
      message: "Server error"
    })
  }
});

// Stats endpoint: admin/health_worker can see patient and health worker counts
app.get(
  "/api/stats/summary",
  authRequired,
  requireRole(["admin", "health_worker"]),
  async (_req, res) => {
    try {
      const [[patientRows], [hwRows]] = await Promise.all([
        db.query("SELECT COUNT(*) AS patient_count FROM users WHERE role='patient'"),
        db.query("SELECT COUNT(*) AS health_worker_count FROM users WHERE role='health_worker'")
      ])
      res.json({
        success: true,
        patientCount: patientRows?.[0]?.patient_count ?? 0,
        healthWorkerCount: hwRows?.[0]?.health_worker_count ?? 0
      })
    } catch (error) {
      console.error("Stats summary error:", error)
      res.json({ success: false, message: "Server error" })
    }
  }
);


// Admin-only: create health worker account
app.post(
  "/api/admin/health-workers",
  authRequired,
  requireRole(["admin"]),
  async (req, res) => {
    try {
      const {
        username,
        email,
        password,
        surname,
        firstname,
        middlename,
        securityQuestionText,
        securityAnswer
      } = req.body

      if (
        !username ||
        !password ||
        !surname ||
        !firstname ||
        !securityQuestionText ||
        !securityAnswer
      ) {
        return res.json({
          success: false,
          message: "Username, password, name and 1 security question are required"
        })
      }

      const [existing] = await db.query(
        "SELECT user_id FROM users WHERE username = ? OR (email IS NOT NULL AND email = ?)",
        [username, email || null]
      )
      if (existing.length > 0) {
        return res.json({ success: false, message: "Username/email already exists" })
      }

      const passwordHash = await bcrypt.hash(password, 10)
      const [userResult] = await db.query(
        "INSERT INTO users (username, email, password_hash, role, created_by_user_id) VALUES (?, ?, ?, 'health_worker', ?)",
        [username, email || null, passwordHash, req.auth.userId]
      )
      const userId = userResult.insertId

      await db.query(
        "INSERT INTO health_workers (user_id, surname, firstname, middlename) VALUES (?, ?, ?, ?)",
        [userId, surname, firstname, middlename || null]
      )

      const answerHash = await bcrypt.hash(String(securityAnswer), 10)
      await db.query(
        `INSERT INTO user_security_questions (user_id, question_no, question_text, answer_hash, is_required)
         VALUES (?, 1, ?, ?, 1)`,
        [userId, securityQuestionText, answerHash]
      )

      res.json({ success: true, message: "Health worker account created" })
    } catch (error) {
      console.error("Create health worker error:", error)
      res.json({ success: false, message: "Server error" })
    }
  }
);

// Get current user's basic profile (all roles)
app.get("/api/profile", authRequired, async (req, res) => {
  try {
    const userId = req.auth.userId
    const [rows] = await db.query(
      "SELECT user_id, username, email, role FROM users WHERE user_id = ?",
      [userId]
    )
    if (rows.length === 0) {
      return res.json({ success: false, message: "User not found" })
    }
    const user = rows[0]

    const [fileRows] = await db.query(
      `SELECT storage_path 
       FROM files 
       WHERE user_id = ? AND purpose = 'profile_image' 
       ORDER BY uploaded_at DESC 
       LIMIT 1`,
      [userId]
    )
    const profileImageUrl = fileRows[0]?.storage_path || null

    res.json({
      success: true,
      user: {
        id: user.user_id,
        username: user.username,
        email: user.email,
        role: user.role,
        profileImageUrl
      }
    })
  } catch (error) {
    console.error("Get profile error:", error)
    res.json({ success: false, message: "Server error" })
  }
})

// Change password (all roles)
app.post("/api/profile/password", authRequired, async (req, res) => {
  try {
    const userId = req.auth.userId
    const { currentPassword, newPassword } = req.body

    if (!currentPassword || !newPassword) {
      return res.json({
        success: false,
        message: "Current password and new password are required"
      })
    }

    const [rows] = await db.query(
      "SELECT password_hash FROM users WHERE user_id = ?",
      [userId]
    )
    if (rows.length === 0) {
      return res.json({ success: false, message: "User not found" })
    }

    const ok = await bcrypt.compare(currentPassword, rows[0].password_hash)
    if (!ok) {
      return res.json({ success: false, message: "Current password is incorrect" })
    }

    const newHash = await bcrypt.hash(newPassword, 10)
    await db.query("UPDATE users SET password_hash = ? WHERE user_id = ?", [
      newHash,
      userId
    ])

    res.json({ success: true, message: "Password updated successfully" })
  } catch (error) {
    console.error("Change password error:", error)
    res.json({ success: false, message: "Server error" })
  }
})

// Update profile picture (all roles)
app.post(
  "/api/profile/avatar",
  authRequired,
  upload.single("avatar"),
  async (req, res) => {
    try {
      const userId = req.auth.userId
      const file = req.file
      if (!file) {
        return res.json({ success: false, message: "No file uploaded" })
      }

      const [r] = await db.query(
        `INSERT INTO files 
          (user_id, purpose, original_name, storage_name, storage_path, mime_type, size_bytes)
         VALUES (?, 'profile_image', ?, ?, ?, ?, ?)`,
        [
          userId,
          file.originalname,
          file.filename,
          `/uploads/${file.filename}`,
          file.mimetype,
          file.size
        ]
      )

      res.json({
        success: true,
        message: "Profile picture updated",
        fileId: r.insertId,
        url: `/uploads/${file.filename}`
      })
    } catch (error) {
      console.error("Update avatar error:", error)
      res.json({ success: false, message: "Server error" })
    }
  }
);

/*

SERVER STARTUP AND DATABASE CONNECTION

*/

async function startServer() {
  try {
    db = await mysql.createConnection({
      host: "127.0.0.1",
      user: "root",
      password: "",
      database: "barangay_health_system"
    })

    console.log("Database connected")

    app.listen(3000, () => {
      console.log("Server running on port 3000")
    })
  } catch (error) {
    console.error("Connection failed:", error)
    process.exit(1)
  }
}

startServer()