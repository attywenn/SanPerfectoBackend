-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 19, 2026 at 11:19 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barangay_health_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`admin_id`, `user_id`, `surname`, `firstname`, `middlename`, `created_at`, `updated_at`) VALUES
(1, 2, 'POCONG', 'WENCY', 'HERRERA', '2026-03-10 09:36:33', '2026-03-10 09:36:33');

-- --------------------------------------------------------

--
-- Table structure for table `diseases`
--

CREATE TABLE `diseases` (
  `disease_id` int(11) NOT NULL,
  `disease_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `file_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `purpose` enum('profile_image','patient_identity') NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `storage_name` varchar(255) NOT NULL,
  `storage_path` varchar(500) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `size_bytes` bigint(20) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`file_id`, `user_id`, `purpose`, `original_name`, `storage_name`, `storage_path`, `mime_type`, `size_bytes`, `uploaded_at`) VALUES
(2, 3, 'profile_image', 'taylor_updf.jpeg', '1773139608813_88c62df836df8_taylor_updf.jpeg', '/uploads/1773139608813_88c62df836df8_taylor_updf.jpeg', 'image/jpeg', 42027, '2026-03-10 10:46:48'),
(3, 3, 'profile_image', 'sp.jpg', '1773139622313_a9fdf1d525abc_sp.jpg', '/uploads/1773139622313_a9fdf1d525abc_sp.jpg', 'image/jpeg', 229723, '2026-03-10 10:47:02'),
(4, 3, 'profile_image', 'ChatGPT Image Jan 8, 2026, 12_42_33 PM.png', '1773139681605_4dad066b6bd12_ChatGPT_Image_Jan_8__2026__12_42_33_PM.png', '/uploads/1773139681605_4dad066b6bd12_ChatGPT_Image_Jan_8__2026__12_42_33_PM.png', 'image/png', 1569790, '2026-03-10 10:48:01'),
(5, 3, 'profile_image', 'taylor_updf.jpeg', '1773139845819_7d34fdf13f3ad_taylor_updf.jpeg', '/uploads/1773139845819_7d34fdf13f3ad_taylor_updf.jpeg', 'image/jpeg', 42027, '2026-03-10 10:50:45');

-- --------------------------------------------------------

--
-- Table structure for table `health_workers`
--

CREATE TABLE `health_workers` (
  `worker_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `health_workers`
--

INSERT INTO `health_workers` (`worker_id`, `user_id`, `surname`, `firstname`, `middlename`, `created_at`, `updated_at`) VALUES
(1, 4, 'Ambatukam', 'Rogelio', 'Monsod', '2026-03-10 10:11:06', '2026-03-10 10:11:06'),
(2, 5, 'Khamenei', 'Ali', NULL, '2026-03-11 03:39:26', '2026-03-11 03:39:26'),
(3, 6, 'Khamenei', 'Mojtad', 'Ayatollah', '2026-03-11 03:41:33', '2026-03-11 03:41:33');

-- --------------------------------------------------------

--
-- Table structure for table `medications`
--

CREATE TABLE `medications` (
  `medication_id` int(11) NOT NULL,
  `medication_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_inventory`
--

CREATE TABLE `medicine_inventory` (
  `inventory_id` int(11) NOT NULL,
  `medication_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `address` text NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `user_id`, `surname`, `firstname`, `middlename`, `date_of_birth`, `address`, `contact_number`, `created_at`, `updated_at`) VALUES
(2, 3, 'Pocong', 'Wency', 'Herrera', '2005-07-04', 'Marikina', '09070257442', '2026-03-10 09:41:21', '2026-03-10 09:41:21');

-- --------------------------------------------------------

--
-- Table structure for table `patient_diseases`
--

CREATE TABLE `patient_diseases` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `disease_id` int(11) DEFAULT NULL,
  `diagnosed_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_medications`
--

CREATE TABLE `patient_medications` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `medication_id` int(11) DEFAULT NULL,
  `dosage` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patient_verifications`
--

CREATE TABLE `patient_verifications` (
  `verification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `submitted_file_id` int(11) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_by_user_id` int(11) DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('patient','health_worker','admin') NOT NULL,
  `created_by_user_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `role`, `created_by_user_id`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'admin', 'wnciplays@gmail.com', '$2a$12$tJOjXz.2UiGWqIIMEPExKe3XH8kcPKrEIwXWn5mTKbhxb0XAMpP3O', 'admin', NULL, 1, '2026-03-10 09:35:56', '2026-03-10 09:35:56'),
(3, 'attywenn', NULL, '$2b$10$dKwOOTv2dkDh3E1VbN5sVuS/lwOUY9HeLcPqvxIfAG5AUkGa6M.uO', 'patient', NULL, 1, '2026-03-10 09:41:21', '2026-03-10 10:44:20'),
(4, 'dr_ambatukam', 'pocong.w.bscs@gmail.com', '$2b$10$9YNUPncCAUO8d/EdHxUet.T/M1iXcV7jz4ZIoVALbzliWE4qmQ2ee', 'health_worker', 2, 1, '2026-03-10 10:11:06', '2026-03-10 10:11:06'),
(5, 'ayatollah', 'ayatollah@gmail.com', '$2b$10$P424aqUZ4l9XF.xtYy3caOUonB68mHxQT4DqqqaGp/q6IsuWi68u.', 'health_worker', 2, 1, '2026-03-11 03:39:26', '2026-03-11 03:39:26'),
(6, 'ali', 'iran_is_great@gmail.com', '$2b$10$01VtGZ2Z/Sxe/VQyfXwhkuwDRjRgaAi8V5HN9Bo3BGMDKb9cwLfkG', 'health_worker', 2, 1, '2026-03-11 03:41:33', '2026-03-11 03:41:33');

-- --------------------------------------------------------

--
-- Table structure for table `user_security_questions`
--

CREATE TABLE `user_security_questions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `question_no` tinyint(4) NOT NULL,
  `question_text` varchar(255) NOT NULL,
  `answer_hash` varchar(255) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_security_questions`
--

INSERT INTO `user_security_questions` (`id`, `user_id`, `question_no`, `question_text`, `answer_hash`, `is_required`, `updated_at`) VALUES
(1, 2, 1, 'PIN 1', '1234', 1, '2026-03-10 09:37:35'),
(2, 2, 2, 'PIN 2', 'abc123', 1, '2026-03-10 09:38:01'),
(3, 2, 3, 'PIN 3', 'perfect', 0, '2026-03-10 09:38:17'),
(4, 4, 1, 'PIN 1', '$2b$10$dUf6cVj/CsnMp1oCd1L7qe1TE5ZvF2wXaiIWAc0gy7w0mFzFR6o5e', 1, '2026-03-10 10:11:06'),
(5, 5, 1, 'What is your staff security keyword?', '$2b$10$niWx2vy4ubPs6FXrCmGSb.VrWSHwDxQKlkthNMoJhpY4/Haen9Zxq', 1, '2026-03-11 03:39:26'),
(6, 6, 1, 'What is your staff security keyword?', '$2b$10$4TukJnL9426UD6nTJS.rlevzcZUQH8D.AKCe6/GjHYnWMKvVHZ0RK', 1, '2026-03-11 03:41:33');

-- --------------------------------------------------------

--
-- Table structure for table `worker_attendance_logs`
--

CREATE TABLE `worker_attendance_logs` (
  `attendance_id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `time_in` datetime NOT NULL,
  `time_out` datetime DEFAULT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `location_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `uq_admins_user_id` (`user_id`);

--
-- Indexes for table `diseases`
--
ALTER TABLE `diseases`
  ADD PRIMARY KEY (`disease_id`),
  ADD UNIQUE KEY `disease_name` (`disease_name`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`file_id`),
  ADD KEY `idx_files_user_purpose` (`user_id`,`purpose`);

--
-- Indexes for table `health_workers`
--
ALTER TABLE `health_workers`
  ADD PRIMARY KEY (`worker_id`),
  ADD UNIQUE KEY `uq_health_workers_user_id` (`user_id`);

--
-- Indexes for table `medications`
--
ALTER TABLE `medications`
  ADD PRIMARY KEY (`medication_id`),
  ADD UNIQUE KEY `medication_name` (`medication_name`);

--
-- Indexes for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `medication_id` (`medication_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD UNIQUE KEY `uq_patients_user_id` (`user_id`),
  ADD KEY `idx_patients_dob` (`date_of_birth`);

--
-- Indexes for table `patient_diseases`
--
ALTER TABLE `patient_diseases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `disease_id` (`disease_id`);

--
-- Indexes for table `patient_medications`
--
ALTER TABLE `patient_medications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `medication_id` (`medication_id`);

--
-- Indexes for table `patient_verifications`
--
ALTER TABLE `patient_verifications`
  ADD PRIMARY KEY (`verification_id`),
  ADD UNIQUE KEY `uq_patient_verification_user` (`user_id`),
  ADD KEY `fk_patient_verifications_file` (`submitted_file_id`),
  ADD KEY `fk_patient_verifications_reviewer` (`reviewed_by_user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `uq_users_email` (`email`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_created_by` (`created_by_user_id`);

--
-- Indexes for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_question_no` (`user_id`,`question_no`);

--
-- Indexes for table `worker_attendance_logs`
--
ALTER TABLE `worker_attendance_logs`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `fk_attendance_worker` (`worker_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `diseases`
--
ALTER TABLE `diseases`
  MODIFY `disease_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `file_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `health_workers`
--
ALTER TABLE `health_workers`
  MODIFY `worker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `medications`
--
ALTER TABLE `medications`
  MODIFY `medication_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `patient_diseases`
--
ALTER TABLE `patient_diseases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_medications`
--
ALTER TABLE `patient_medications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patient_verifications`
--
ALTER TABLE `patient_verifications`
  MODIFY `verification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `worker_attendance_logs`
--
ALTER TABLE `worker_attendance_logs`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `files`
--
ALTER TABLE `files`
  ADD CONSTRAINT `fk_files_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `health_workers`
--
ALTER TABLE `health_workers`
  ADD CONSTRAINT `fk_health_workers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  ADD CONSTRAINT `medicine_inventory_ibfk_1` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `fk_patients_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `patient_diseases`
--
ALTER TABLE `patient_diseases`
  ADD CONSTRAINT `patient_diseases_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `patient_diseases_ibfk_2` FOREIGN KEY (`disease_id`) REFERENCES `diseases` (`disease_id`);

--
-- Constraints for table `patient_medications`
--
ALTER TABLE `patient_medications`
  ADD CONSTRAINT `patient_medications_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
  ADD CONSTRAINT `patient_medications_ibfk_2` FOREIGN KEY (`medication_id`) REFERENCES `medications` (`medication_id`);

--
-- Constraints for table `patient_verifications`
--
ALTER TABLE `patient_verifications`
  ADD CONSTRAINT `fk_patient_verifications_file` FOREIGN KEY (`submitted_file_id`) REFERENCES `files` (`file_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_patient_verifications_reviewer` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_patient_verifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user_security_questions`
--
ALTER TABLE `user_security_questions`
  ADD CONSTRAINT `fk_user_security_questions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `worker_attendance_logs`
--
ALTER TABLE `worker_attendance_logs`
  ADD CONSTRAINT `fk_attendance_worker` FOREIGN KEY (`worker_id`) REFERENCES `health_workers` (`worker_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
