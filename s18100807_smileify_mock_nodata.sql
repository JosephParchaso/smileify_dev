-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 11, 2025 at 09:11 AM
-- Server version: 10.11.14-MariaDB-0+deb12u2
-- PHP Version: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `s18100807_smileify_mock`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `announcement_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `type` enum('General','Closed') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_services`
--

CREATE TABLE `appointment_services` (
  `appointment_services_id` int(11) NOT NULL,
  `appointment_transaction_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointment_transaction`
--

CREATE TABLE `appointment_transaction` (
  `appointment_transaction_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `dentist_id` int(11) DEFAULT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `notes` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL,
  `status` enum('Booked','Completed','Cancelled') NOT NULL,
  `reminder_sent` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branch_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `map_url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `branch_announcements`
--

CREATE TABLE `branch_announcements` (
  `id` int(11) NOT NULL,
  `announcement_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `branch_promo`
--

CREATE TABLE `branch_promo` (
  `branch_promo_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `promo_id` int(11) NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `branch_service`
--

CREATE TABLE `branch_service` (
  `branch_services_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `service_id` int(11) NOT NULL,
  `status` enum('Active','Inactive') NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `branch_supply`
--

CREATE TABLE `branch_supply` (
  `branch_supplies_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `supply_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 0,
  `reorder_level` int(11) DEFAULT 0,
  `expiration_date` date DEFAULT NULL,
  `status` enum('Available','Out of Stock') DEFAULT 'Available',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dental_prescription`
--

CREATE TABLE `dental_prescription` (
  `prescription_id` int(11) NOT NULL,
  `appointment_transaction_id` int(11) NOT NULL,
  `admin_user_id` int(11) DEFAULT NULL,
  `drug` varchar(255) NOT NULL,
  `route` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `dosage` varchar(50) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `quantity` varchar(50) NOT NULL,
  `instructions` text DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dental_tips`
--

CREATE TABLE `dental_tips` (
  `tip_id` int(11) NOT NULL,
  `tip_text` varchar(255) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dental_transaction`
--

CREATE TABLE `dental_transaction` (
  `dental_transaction_id` int(11) NOT NULL,
  `appointment_transaction_id` int(11) NOT NULL,
  `dentist_id` int(11) NOT NULL,
  `admin_user_id` int(11) DEFAULT NULL,
  `promo_id` int(11) DEFAULT NULL,
  `promo_name` varchar(255) DEFAULT NULL,
  `promo_type` enum('percentage','fixed') DEFAULT NULL,
  `promo_value` decimal(10,2) DEFAULT NULL,
  `payment_method` enum('Cash','Cashless') NOT NULL,
  `cashless_receipt` varchar(255) DEFAULT NULL,
  `xray_file` varchar(255) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL,
  `additional_payment` decimal(10,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `medcert_status` enum('None','Requested','Eligible','Issued','Expired') NOT NULL,
  `medcert_receipt` varchar(255) DEFAULT NULL,
  `fitness_status` varchar(255) DEFAULT NULL,
  `diagnosis` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `medcert_notes` text DEFAULT NULL,
  `medcert_requested_date` datetime DEFAULT NULL,
  `medcert_request_payment` decimal(10,2) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL,
  `prescription_downloaded` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dental_transaction_services`
--

CREATE TABLE `dental_transaction_services` (
  `id` int(11) NOT NULL,
  `dental_transaction_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `service_price` decimal(10,2) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `additional_payment` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dental_vital`
--

CREATE TABLE `dental_vital` (
  `vitals_id` int(11) NOT NULL,
  `appointment_transaction_id` int(11) NOT NULL,
  `admin_user_id` int(11) DEFAULT NULL,
  `body_temp` decimal(4,1) DEFAULT NULL,
  `pulse_rate` int(11) DEFAULT NULL,
  `respiratory_rate` int(11) DEFAULT NULL,
  `blood_pressure` varchar(10) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `is_swelling` enum('Yes','No') NOT NULL,
  `is_bleeding` enum('Yes','No') NOT NULL,
  `is_sensitive` enum('Yes','No') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dentist`
--

CREATE TABLE `dentist` (
  `dentist_id` int(11) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `date_of_birth` varchar(255) NOT NULL,
  `date_of_birth_iv` text DEFAULT NULL,
  `date_of_birth_tag` text DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `contact_number` varchar(255) NOT NULL,
  `contact_number_iv` text DEFAULT NULL,
  `contact_number_tag` text DEFAULT NULL,
  `license_number` varchar(255) NOT NULL,
  `license_number_iv` text DEFAULT NULL,
  `license_number_tag` text DEFAULT NULL,
  `date_started` date DEFAULT NULL,
  `status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `signature_image` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dentist_branch`
--

CREATE TABLE `dentist_branch` (
  `dentist_branch_id` int(11) NOT NULL,
  `dentist_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dentist_schedule`
--

CREATE TABLE `dentist_schedule` (
  `schedule_id` int(11) NOT NULL,
  `dentist_id` int(11) NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dentist_service`
--

CREATE TABLE `dentist_service` (
  `dentist_services_id` int(11) NOT NULL,
  `dentist_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(4) DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `promo`
--

CREATE TABLE `promo` (
  `promo_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `discount_type` enum('percentage','fixed') NOT NULL DEFAULT 'percentage',
  `discount_value` decimal(10,2) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `qr_payment`
--

CREATE TABLE `qr_payment` (
  `id` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service`
--

CREATE TABLE `service` (
  `service_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `price` double NOT NULL,
  `duration_minutes` int(11) NOT NULL DEFAULT 45,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `requires_xray` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_supplies`
--

CREATE TABLE `service_supplies` (
  `id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `supply_id` int(11) NOT NULL,
  `quantity_used` varchar(50) NOT NULL DEFAULT '1.00',
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supply`
--

CREATE TABLE `supply` (
  `supply_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `guardian_id` int(11) DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `date_of_birth` varchar(255) DEFAULT NULL,
  `date_of_birth_iv` text DEFAULT NULL,
  `date_of_birth_tag` text DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `contact_number_iv` text DEFAULT NULL,
  `contact_number_tag` text DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `address_iv` text DEFAULT NULL,
  `address_tag` text DEFAULT NULL,
  `role` enum('owner','admin','patient') NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `date_started` date DEFAULT NULL,
  `status` enum('Active','Inactive') NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp(),
  `force_logout` tinyint(1) DEFAULT 0,
  `owner_flag` tinyint(1) GENERATED ALWAYS AS (case when `role` = 'owner' then 1 else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`announcement_id`);

--
-- Indexes for table `appointment_services`
--
ALTER TABLE `appointment_services`
  ADD PRIMARY KEY (`appointment_services_id`),
  ADD KEY `appointment_transaction_id` (`appointment_transaction_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `appointment_transaction`
--
ALTER TABLE `appointment_transaction`
  ADD PRIMARY KEY (`appointment_transaction_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `branch_id` (`branch_id`),
  ADD KEY `dentist_id` (`dentist_id`);

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indexes for table `branch_announcements`
--
ALTER TABLE `branch_announcements`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `announcement_id` (`announcement_id`,`branch_id`),
  ADD KEY `fk_branch_announcements_branch` (`branch_id`);

--
-- Indexes for table `branch_promo`
--
ALTER TABLE `branch_promo`
  ADD PRIMARY KEY (`branch_promo_id`),
  ADD KEY `promo_id` (`promo_id`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `branch_service`
--
ALTER TABLE `branch_service`
  ADD PRIMARY KEY (`branch_services_id`),
  ADD KEY `fk_branch` (`branch_id`),
  ADD KEY `fk_service` (`service_id`);

--
-- Indexes for table `branch_supply`
--
ALTER TABLE `branch_supply`
  ADD PRIMARY KEY (`branch_supplies_id`),
  ADD KEY `supply_id` (`supply_id`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `dental_prescription`
--
ALTER TABLE `dental_prescription`
  ADD PRIMARY KEY (`prescription_id`),
  ADD KEY `appointment_transaction_id` (`appointment_transaction_id`),
  ADD KEY `fk_prescription_admin` (`admin_user_id`);

--
-- Indexes for table `dental_tips`
--
ALTER TABLE `dental_tips`
  ADD PRIMARY KEY (`tip_id`);

--
-- Indexes for table `dental_transaction`
--
ALTER TABLE `dental_transaction`
  ADD PRIMARY KEY (`dental_transaction_id`),
  ADD KEY `appointment_transaction_id` (`appointment_transaction_id`),
  ADD KEY `dentist_id` (`dentist_id`),
  ADD KEY `fk_dental_transaction_promo` (`promo_id`),
  ADD KEY `fk_dental_transaction_admin` (`admin_user_id`);

--
-- Indexes for table `dental_transaction_services`
--
ALTER TABLE `dental_transaction_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dental_transaction_id` (`dental_transaction_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `dental_vital`
--
ALTER TABLE `dental_vital`
  ADD PRIMARY KEY (`vitals_id`),
  ADD KEY `appointment_transaction_id` (`appointment_transaction_id`),
  ADD KEY `fk_vital_admin` (`admin_user_id`);

--
-- Indexes for table `dentist`
--
ALTER TABLE `dentist`
  ADD PRIMARY KEY (`dentist_id`);

--
-- Indexes for table `dentist_branch`
--
ALTER TABLE `dentist_branch`
  ADD PRIMARY KEY (`dentist_branch_id`),
  ADD KEY `dentist_id` (`dentist_id`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `dentist_id` (`dentist_id`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `dentist_service`
--
ALTER TABLE `dentist_service`
  ADD PRIMARY KEY (`dentist_services_id`),
  ADD KEY `dentist_id` (`dentist_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `promo`
--
ALTER TABLE `promo`
  ADD PRIMARY KEY (`promo_id`);

--
-- Indexes for table `qr_payment`
--
ALTER TABLE `qr_payment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`service_id`);

--
-- Indexes for table `service_supplies`
--
ALTER TABLE `service_supplies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_service_supplies_service` (`service_id`),
  ADD KEY `fk_service_supplies_supply` (`supply_id`),
  ADD KEY `fk_service_supplies_branch` (`branch_id`);

--
-- Indexes for table `supply`
--
ALTER TABLE `supply`
  ADD PRIMARY KEY (`supply_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `index_username_unique` (`username`),
  ADD UNIQUE KEY `unique_owner` (`owner_flag`),
  ADD KEY `fk_users_branch` (`branch_id`),
  ADD KEY `fk_guardian_user` (`guardian_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `announcement_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_services`
--
ALTER TABLE `appointment_services`
  MODIFY `appointment_services_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointment_transaction`
--
ALTER TABLE `appointment_transaction`
  MODIFY `appointment_transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `branch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch_announcements`
--
ALTER TABLE `branch_announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch_promo`
--
ALTER TABLE `branch_promo`
  MODIFY `branch_promo_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch_service`
--
ALTER TABLE `branch_service`
  MODIFY `branch_services_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch_supply`
--
ALTER TABLE `branch_supply`
  MODIFY `branch_supplies_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_prescription`
--
ALTER TABLE `dental_prescription`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_tips`
--
ALTER TABLE `dental_tips`
  MODIFY `tip_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_transaction`
--
ALTER TABLE `dental_transaction`
  MODIFY `dental_transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_transaction_services`
--
ALTER TABLE `dental_transaction_services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_vital`
--
ALTER TABLE `dental_vital`
  MODIFY `vitals_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dentist`
--
ALTER TABLE `dentist`
  MODIFY `dentist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dentist_branch`
--
ALTER TABLE `dentist_branch`
  MODIFY `dentist_branch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dentist_service`
--
ALTER TABLE `dentist_service`
  MODIFY `dentist_services_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promo`
--
ALTER TABLE `promo`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `qr_payment`
--
ALTER TABLE `qr_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_supplies`
--
ALTER TABLE `service_supplies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supply`
--
ALTER TABLE `supply`
  MODIFY `supply_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment_services`
--
ALTER TABLE `appointment_services`
  ADD CONSTRAINT `appointment_services_ibfk_1` FOREIGN KEY (`appointment_transaction_id`) REFERENCES `appointment_transaction` (`appointment_transaction_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointment_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE;

--
-- Constraints for table `appointment_transaction`
--
ALTER TABLE `appointment_transaction`
  ADD CONSTRAINT `appointment_transaction_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `appointment_transaction_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`),
  ADD CONSTRAINT `appointment_transaction_ibfk_4` FOREIGN KEY (`dentist_id`) REFERENCES `dentist` (`dentist_id`);

--
-- Constraints for table `branch_announcements`
--
ALTER TABLE `branch_announcements`
  ADD CONSTRAINT `fk_branch_announcements_announcement` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`announcement_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_branch_announcements_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `branch_promo`
--
ALTER TABLE `branch_promo`
  ADD CONSTRAINT `branch_promo_ibfk_1` FOREIGN KEY (`promo_id`) REFERENCES `promo` (`promo_id`),
  ADD CONSTRAINT `branch_promo_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`);

--
-- Constraints for table `branch_service`
--
ALTER TABLE `branch_service`
  ADD CONSTRAINT `fk_branch` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_service` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE;

--
-- Constraints for table `branch_supply`
--
ALTER TABLE `branch_supply`
  ADD CONSTRAINT `branch_supply_ibfk_1` FOREIGN KEY (`supply_id`) REFERENCES `supply` (`supply_id`),
  ADD CONSTRAINT `branch_supply_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`);

--
-- Constraints for table `dental_prescription`
--
ALTER TABLE `dental_prescription`
  ADD CONSTRAINT `dental_prescription_ibfk_1` FOREIGN KEY (`appointment_transaction_id`) REFERENCES `appointment_transaction` (`appointment_transaction_id`),
  ADD CONSTRAINT `fk_prescription_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `dental_transaction`
--
ALTER TABLE `dental_transaction`
  ADD CONSTRAINT `dental_transaction_ibfk_1` FOREIGN KEY (`appointment_transaction_id`) REFERENCES `appointment_transaction` (`appointment_transaction_id`),
  ADD CONSTRAINT `dental_transaction_ibfk_2` FOREIGN KEY (`dentist_id`) REFERENCES `dentist` (`dentist_id`),
  ADD CONSTRAINT `fk_dental_transaction_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dental_transaction_promo` FOREIGN KEY (`promo_id`) REFERENCES `promo` (`promo_id`) ON DELETE SET NULL;

--
-- Constraints for table `dental_transaction_services`
--
ALTER TABLE `dental_transaction_services`
  ADD CONSTRAINT `dental_transaction_services_ibfk_1` FOREIGN KEY (`dental_transaction_id`) REFERENCES `dental_transaction` (`dental_transaction_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `dental_transaction_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`);

--
-- Constraints for table `dental_vital`
--
ALTER TABLE `dental_vital`
  ADD CONSTRAINT `dental_vital_ibfk_1` FOREIGN KEY (`appointment_transaction_id`) REFERENCES `appointment_transaction` (`appointment_transaction_id`),
  ADD CONSTRAINT `fk_vital_admin` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `dentist_branch`
--
ALTER TABLE `dentist_branch`
  ADD CONSTRAINT `dentist_branch_ibfk_1` FOREIGN KEY (`dentist_id`) REFERENCES `dentist` (`dentist_id`),
  ADD CONSTRAINT `dentist_branch_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`);

--
-- Constraints for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  ADD CONSTRAINT `dentist_schedule_ibfk_1` FOREIGN KEY (`dentist_id`) REFERENCES `dentist` (`dentist_id`),
  ADD CONSTRAINT `dentist_schedule_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branch` (`branch_id`);

--
-- Constraints for table `dentist_service`
--
ALTER TABLE `dentist_service`
  ADD CONSTRAINT `dentist_service_ibfk_1` FOREIGN KEY (`dentist_id`) REFERENCES `dentist` (`dentist_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `dentist_service_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_guardian_user` FOREIGN KEY (`guardian_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
