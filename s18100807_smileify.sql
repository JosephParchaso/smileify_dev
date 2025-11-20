-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 21, 2025 at 05:08 AM
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
-- Database: `s18100807_smileify`
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
  `date_created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment_services`
--

INSERT INTO `appointment_services` (`appointment_services_id`, `appointment_transaction_id`, `service_id`, `date_created`) VALUES
(4, 4, 2, '2025-11-20 22:35:52'),
(5, 4, 5, '2025-11-20 22:35:52'),
(6, 5, 2, '2025-11-20 23:10:33'),
(7, 5, 3, '2025-11-20 23:10:33'),
(8, 5, 4, '2025-11-20 23:10:33'),
(9, 6, 1, '2025-11-21 00:51:46'),
(10, 7, 1, '2025-11-21 01:08:28'),
(11, 7, 3, '2025-11-21 01:08:28'),
(12, 7, 19, '2025-11-21 01:08:28'),
(13, 8, 1, '2025-11-21 01:08:30'),
(14, 8, 3, '2025-11-21 01:08:30'),
(15, 8, 19, '2025-11-21 01:08:30'),
(16, 9, 3, '2025-11-21 02:17:20'),
(17, 10, 2, '2025-11-21 02:25:35'),
(18, 10, 8, '2025-11-21 02:25:35'),
(19, 11, 1, '2025-11-21 02:46:18'),
(20, 12, 1, '2025-11-21 04:58:37');

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

--
-- Dumping data for table `appointment_transaction`
--

INSERT INTO `appointment_transaction` (`appointment_transaction_id`, `user_id`, `branch_id`, `dentist_id`, `appointment_date`, `appointment_time`, `notes`, `date_created`, `date_updated`, `status`, `reminder_sent`) VALUES
(1, 5, 1, 1, '2025-11-24', '09:00:00', '', '2025-11-19 11:16:06', NULL, 'Booked', 0),
(2, 6, 1, 1, '2025-11-24', '09:00:00', '', '2025-11-19 11:16:08', NULL, 'Booked', 0),
(3, 7, 1, 1, '2025-11-26', '10:00:00', '', '2025-11-19 11:18:41', NULL, 'Booked', 0),
(4, 12, 1, 2, '2025-11-24', '10:00:00', '', '2025-11-20 14:35:52', NULL, 'Booked', 0),
(5, 13, 1, 2, '2025-11-24', '14:00:00', '', '2025-11-20 15:10:33', '2025-11-21 04:55:13', 'Cancelled', 0),
(6, 14, 1, 2, '2025-11-28', '15:00:00', 'qasds', '2025-11-20 16:51:46', NULL, 'Booked', 0),
(7, 15, 3, 5, '2025-12-25', '15:00:00', '', '2025-11-20 17:08:28', NULL, 'Booked', 0),
(8, 16, 3, 5, '2025-12-25', '15:00:00', '', '2025-11-20 17:08:30', NULL, 'Booked', 0),
(9, 12, 3, 8, '2025-11-22', '09:00:00', '', '2025-11-20 18:17:20', NULL, 'Booked', 0),
(10, 13, 3, 6, '2025-12-02', '10:30:00', '', '2025-11-20 18:25:35', NULL, 'Booked', 0),
(11, 13, 4, 3, '2025-11-21', '09:00:00', '', '2025-11-20 18:46:18', NULL, 'Booked', 0),
(12, 13, 1, 2, '2025-11-21', '13:30:00', '', '2025-11-20 20:58:37', '2025-11-21 05:00:52', 'Completed', 0);

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branch_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `map_url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`branch_id`, `name`, `address`, `phone_number`, `status`, `date_created`, `date_updated`, `map_url`) VALUES
(1, 'Babag 2, Lapu-Lapu City', '2nd Floor RM Arcade, Babag 2, Lapu-Lapu City', '0927350583', 'Active', '2025-11-19 18:52:35', '2025-11-20 18:47:26', 'https://maps.app.goo.gl/8okHqFg5fRn4xMyV6'),
(2, 'Pusok, Lapu-Lapu City', 'Modejar Building (Room 306), City Hall Road, Pusok, Lapu-Lapu City', '0927350583', 'Active', '2025-11-19 18:58:01', '2025-11-20 18:47:42', 'https://maps.app.goo.gl/EUQVQkys2wSabHwKA'),
(3, 'Pakna-an, Mandaue City (Main Branch)', 'Jayme Street, Zone Ube, Pakna-an, Mandaue City', '0927350583', 'Active', '2025-11-20 18:37:28', '2025-11-20 18:50:51', 'https://maps.app.goo.gl/pMai2KSgVv3hj1tZA'),
(4, 'Pajo, Lapu-Lapu City', '2nd Floor Godinez Building, Punta Rizal Street, Pajo, Lapu-Lapu City', '0927350583', 'Active', '2025-11-20 18:46:18', '2025-11-20 18:47:33', 'https://maps.app.goo.gl/8TbnC52Wrs5HymMBA'),
(5, 'Cordova', 'Poblacion, Cordova, Cebu', '9123456789', 'Active', '2025-11-21 04:05:19', '2025-11-21 04:05:19', 'https://www.google.com/maps/place/Poblacion,+Cordova,+Cebu/@10.250377,123.9515707,15z/data=!3m1!4b1!4m6!3m5!1s0x33a99af518835cd9:0x9b54201fef660c0b!8m2!3d10.2511434!4d123.9513093!16s%2Fg%2F11f0wls8th?entry=ttu&g_ep=EgoyMDI1MTExNy4wIKXMDSoASAFQAw%3D%3D');

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

--
-- Dumping data for table `branch_promo`
--

INSERT INTO `branch_promo` (`branch_promo_id`, `branch_id`, `promo_id`, `status`, `start_date`, `end_date`) VALUES
(1, 1, 1, 'Active', NULL, NULL),
(2, 4, 1, 'Active', NULL, NULL),
(3, 3, 1, 'Active', NULL, NULL),
(4, 2, 1, 'Active', NULL, NULL),
(5, 1, 2, 'Active', '2025-11-20', '2026-01-05'),
(6, 4, 2, 'Active', '2025-11-20', '2026-01-05'),
(7, 3, 2, 'Active', '2025-11-20', '2026-01-05'),
(8, 2, 2, 'Active', '2025-11-20', '2026-01-05'),
(9, 1, 3, 'Active', '2025-12-31', '2026-01-30'),
(10, 4, 3, 'Active', '2025-12-31', '2026-01-30'),
(11, 3, 3, 'Active', '2025-12-31', '2026-01-30'),
(12, 2, 3, 'Active', '2025-12-31', '2026-01-30');

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

--
-- Dumping data for table `branch_service`
--

INSERT INTO `branch_service` (`branch_services_id`, `branch_id`, `service_id`, `status`, `date_created`, `date_updated`) VALUES
(41, 1, 1, 'Active', '2025-11-20 18:49:42', '2025-11-20 18:49:42'),
(42, 2, 1, 'Active', '2025-11-20 18:49:42', '2025-11-20 18:49:42'),
(43, 3, 1, 'Active', '2025-11-20 18:49:42', '2025-11-20 18:49:42'),
(44, 4, 1, 'Active', '2025-11-20 18:49:42', '2025-11-20 18:49:42'),
(45, 1, 2, 'Active', '2025-11-20 18:49:52', '2025-11-20 18:49:52'),
(46, 2, 2, 'Active', '2025-11-20 18:49:52', '2025-11-20 18:49:52'),
(47, 3, 2, 'Active', '2025-11-20 18:49:52', '2025-11-20 18:49:52'),
(48, 4, 2, 'Active', '2025-11-20 18:49:52', '2025-11-20 18:49:52'),
(49, 1, 3, 'Active', '2025-11-20 18:50:06', '2025-11-20 18:50:06'),
(50, 2, 3, 'Active', '2025-11-20 18:50:06', '2025-11-20 18:50:06'),
(51, 3, 3, 'Active', '2025-11-20 18:50:06', '2025-11-20 18:50:06'),
(52, 4, 3, 'Active', '2025-11-20 18:50:06', '2025-11-20 18:50:06'),
(53, 1, 4, 'Active', '2025-11-20 18:50:13', '2025-11-20 18:50:13'),
(54, 2, 4, 'Active', '2025-11-20 18:50:13', '2025-11-20 18:50:13'),
(55, 3, 4, 'Active', '2025-11-20 18:50:13', '2025-11-20 18:50:13'),
(56, 4, 4, 'Active', '2025-11-20 18:50:13', '2025-11-20 18:50:13'),
(57, 1, 5, 'Active', '2025-11-20 18:50:28', '2025-11-20 18:50:28'),
(58, 2, 5, 'Active', '2025-11-20 18:50:28', '2025-11-20 18:50:28'),
(59, 3, 5, 'Active', '2025-11-20 18:50:28', '2025-11-20 18:50:28'),
(60, 4, 5, 'Active', '2025-11-20 18:50:28', '2025-11-20 18:50:28'),
(61, 1, 6, 'Active', '2025-11-20 18:51:13', '2025-11-20 18:51:13'),
(62, 2, 6, 'Active', '2025-11-20 18:51:13', '2025-11-20 18:51:13'),
(63, 3, 6, 'Active', '2025-11-20 18:51:13', '2025-11-20 18:51:13'),
(64, 4, 6, 'Active', '2025-11-20 18:51:13', '2025-11-20 18:51:13'),
(65, 1, 7, 'Active', '2025-11-20 18:51:19', '2025-11-20 18:51:19'),
(66, 2, 7, 'Active', '2025-11-20 18:51:19', '2025-11-20 18:51:19'),
(67, 3, 7, 'Active', '2025-11-20 18:51:19', '2025-11-20 18:51:19'),
(68, 4, 7, 'Active', '2025-11-20 18:51:19', '2025-11-20 18:51:19'),
(69, 1, 8, 'Active', '2025-11-20 18:51:28', '2025-11-20 18:51:28'),
(70, 2, 8, 'Active', '2025-11-20 18:51:28', '2025-11-20 18:51:28'),
(71, 3, 8, 'Active', '2025-11-20 18:51:28', '2025-11-20 18:51:28'),
(72, 4, 8, 'Active', '2025-11-20 18:51:28', '2025-11-20 18:51:28'),
(73, 1, 9, 'Active', '2025-11-20 18:51:59', '2025-11-20 18:51:59'),
(74, 2, 9, 'Active', '2025-11-20 18:51:59', '2025-11-20 18:51:59'),
(75, 3, 9, 'Active', '2025-11-20 18:51:59', '2025-11-20 18:51:59'),
(76, 4, 9, 'Active', '2025-11-20 18:51:59', '2025-11-20 18:51:59'),
(77, 1, 10, 'Active', '2025-11-20 18:52:04', '2025-11-20 18:52:04'),
(78, 2, 10, 'Active', '2025-11-20 18:52:04', '2025-11-20 18:52:04'),
(79, 3, 10, 'Active', '2025-11-20 18:52:04', '2025-11-20 18:52:04'),
(80, 4, 10, 'Active', '2025-11-20 18:52:04', '2025-11-20 18:52:04'),
(81, 1, 11, 'Active', '2025-11-20 18:52:12', '2025-11-20 18:52:12'),
(82, 2, 11, 'Active', '2025-11-20 18:52:12', '2025-11-20 18:52:12'),
(83, 3, 11, 'Active', '2025-11-20 18:52:12', '2025-11-20 18:52:12'),
(84, 4, 11, 'Active', '2025-11-20 18:52:12', '2025-11-20 18:52:12'),
(85, 1, 12, 'Active', '2025-11-20 18:54:33', '2025-11-20 18:54:33'),
(86, 2, 12, 'Active', '2025-11-20 18:54:33', '2025-11-20 18:54:33'),
(87, 3, 12, 'Active', '2025-11-20 18:54:33', '2025-11-20 18:54:33'),
(88, 4, 12, 'Active', '2025-11-20 18:54:33', '2025-11-20 18:54:33'),
(89, 1, 13, 'Active', '2025-11-20 18:54:54', '2025-11-20 18:54:54'),
(90, 2, 13, 'Active', '2025-11-20 18:54:54', '2025-11-20 18:54:54'),
(91, 3, 13, 'Active', '2025-11-20 18:54:54', '2025-11-20 18:54:54'),
(92, 4, 13, 'Active', '2025-11-20 18:54:54', '2025-11-20 18:54:54'),
(93, 1, 14, 'Active', '2025-11-20 18:55:03', '2025-11-21 03:19:23'),
(94, 2, 14, 'Active', '2025-11-20 18:55:03', '2025-11-20 18:55:03'),
(95, 3, 14, 'Active', '2025-11-20 18:55:03', '2025-11-20 18:55:03'),
(96, 4, 14, 'Active', '2025-11-20 18:55:03', '2025-11-20 18:55:03'),
(97, 1, 15, 'Active', '2025-11-20 18:55:18', '2025-11-20 18:55:18'),
(98, 2, 15, 'Active', '2025-11-20 18:55:18', '2025-11-20 18:55:18'),
(99, 3, 15, 'Active', '2025-11-20 18:55:18', '2025-11-20 18:55:18'),
(100, 4, 15, 'Active', '2025-11-20 18:55:18', '2025-11-20 18:55:18'),
(101, 1, 16, 'Active', '2025-11-20 18:55:24', '2025-11-20 18:55:24'),
(102, 2, 16, 'Active', '2025-11-20 18:55:24', '2025-11-20 18:55:24'),
(103, 3, 16, 'Active', '2025-11-20 18:55:24', '2025-11-20 18:55:24'),
(104, 4, 16, 'Active', '2025-11-20 18:55:24', '2025-11-20 18:55:24'),
(105, 1, 17, 'Active', '2025-11-20 18:55:33', '2025-11-20 18:55:33'),
(106, 2, 17, 'Active', '2025-11-20 18:55:33', '2025-11-20 18:55:33'),
(107, 3, 17, 'Active', '2025-11-20 18:55:33', '2025-11-20 18:55:33'),
(108, 4, 17, 'Active', '2025-11-20 18:55:33', '2025-11-20 18:55:33'),
(109, 1, 18, 'Active', '2025-11-20 18:55:42', '2025-11-20 18:55:42'),
(110, 2, 18, 'Active', '2025-11-20 18:55:42', '2025-11-20 18:55:42'),
(111, 3, 18, 'Active', '2025-11-20 18:55:42', '2025-11-20 18:55:42'),
(112, 4, 18, 'Active', '2025-11-20 18:55:42', '2025-11-20 18:55:42'),
(113, 1, 19, 'Active', '2025-11-20 18:55:48', '2025-11-20 18:55:48'),
(114, 2, 19, 'Active', '2025-11-20 18:55:48', '2025-11-20 18:55:48'),
(115, 3, 19, 'Active', '2025-11-20 18:55:48', '2025-11-20 18:55:48'),
(116, 4, 19, 'Active', '2025-11-20 18:55:48', '2025-11-20 18:55:48'),
(117, 1, 20, 'Active', '2025-11-21 03:42:39', '2025-11-21 03:42:39'),
(118, 4, 20, 'Active', '2025-11-21 03:42:39', '2025-11-21 03:42:39'),
(119, 3, 20, 'Active', '2025-11-21 03:42:39', '2025-11-21 03:42:39'),
(120, 2, 20, 'Active', '2025-11-21 03:42:39', '2025-11-21 03:42:39');

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
  `status` enum('Available','Unavailable') DEFAULT 'Available',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `branch_supply`
--

INSERT INTO `branch_supply` (`branch_supplies_id`, `branch_id`, `supply_id`, `quantity`, `reorder_level`, `expiration_date`, `status`, `date_created`, `date_updated`) VALUES
(1, 1, 1, 100, 3, '2028-12-30', 'Available', '2025-11-21 04:28:55', '2025-11-21 04:28:55');

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

--
-- Dumping data for table `dental_prescription`
--

INSERT INTO `dental_prescription` (`prescription_id`, `appointment_transaction_id`, `admin_user_id`, `drug`, `route`, `frequency`, `dosage`, `duration`, `quantity`, `instructions`, `date_created`, `date_updated`) VALUES
(1, 5, 8, 'Multivitamins', NULL, '1', '500', '30 days', '30', '', '2025-11-20 20:53:43', '2025-11-21 04:54:29'),
(2, 12, 8, 'Multivitamins', NULL, '1', '500mg', '30', '30', '', '2025-11-20 21:00:48', '2025-11-21 05:00:48');

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

--
-- Dumping data for table `dental_transaction`
--

INSERT INTO `dental_transaction` (`dental_transaction_id`, `appointment_transaction_id`, `dentist_id`, `admin_user_id`, `promo_id`, `promo_name`, `promo_type`, `promo_value`, `payment_method`, `cashless_receipt`, `total`, `additional_payment`, `notes`, `medcert_status`, `medcert_receipt`, `fitness_status`, `diagnosis`, `remarks`, `medcert_notes`, `medcert_requested_date`, `medcert_request_payment`, `date_created`, `date_updated`, `prescription_downloaded`) VALUES
(1, 5, 2, 8, NULL, NULL, NULL, NULL, 'Cash', NULL, 1600.00, 0.00, 'a', 'None', NULL, '', '', '', NULL, NULL, NULL, '2025-11-20 20:43:59', '2025-11-21 04:44:53', 0),
(2, 12, 9, 8, 2, 'Christmas Dental Promo', 'fixed', 200.00, 'Cash', NULL, 0.00, 0.00, '', 'Requested', '/images/payments/medcert_payments/2_iway.png', '', '', '', NULL, '2025-11-21 05:07:00', NULL, '2025-11-20 20:59:40', '2025-11-21 05:07:00', 1);

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
  `quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dental_transaction_services`
--

INSERT INTO `dental_transaction_services` (`id`, `dental_transaction_id`, `service_id`, `service_name`, `service_price`, `quantity`) VALUES
(1, 1, 2, 'Check Up/Consultation', 200.00, 1),
(2, 1, 3, 'Cleaning', 700.00, 1),
(3, 1, 4, 'Tooth Filling', 700.00, 1),
(4, 2, 2, 'Check Up/Consultation', 200.00, 1);

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

--
-- Dumping data for table `dental_vital`
--

INSERT INTO `dental_vital` (`vitals_id`, `appointment_transaction_id`, `admin_user_id`, `body_temp`, `pulse_rate`, `respiratory_rate`, `blood_pressure`, `height`, `weight`, `is_swelling`, `is_bleeding`, `is_sensitive`, `date_created`, `date_updated`) VALUES
(1, 5, 8, 36.0, 70, 12, '100/80', 162.00, 57.00, 'No', 'No', 'Yes', '2025-11-20 20:47:16', '2025-11-21 04:51:06'),
(2, 12, 8, 36.0, 70, 12, '100', 162.00, 57.00, 'No', 'No', 'Yes', '2025-11-20 21:00:29', '2025-11-21 05:00:29');

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
  `date_updated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dentist`
--

INSERT INTO `dentist` (`dentist_id`, `last_name`, `middle_name`, `first_name`, `gender`, `date_of_birth`, `date_of_birth_iv`, `date_of_birth_tag`, `email`, `contact_number`, `contact_number_iv`, `contact_number_tag`, `license_number`, `license_number_iv`, `license_number_tag`, `date_started`, `status`, `signature_image`, `profile_image`, `date_created`, `date_updated`) VALUES
(1, 'Achas', '', 'Joshua', 'Male', '9SW4Lvebsmc9Hg==', '33r9KDbvUyH+0b2X', 'DBglFlDeuFQq2ccDj366YQ==', 'josephparchaso@gmail.com', 'wwoSirwrLsdr5Q==', 'bx12+8J51ybH1CQo', '4SwJU/GUjuxIkyY6IOIN2g==', 'U+yVgU6CW44=', 'SsDwS8lsJTm09oNN', '1TY0OphtfE3G33PbFGbhRg==', '2025-11-20', 'Active', '1_achas_signature.png', NULL, '2025-11-19 11:11:41', '2025-11-20 23:55:29'),
(2, 'Solante', '', 'Ben', 'Male', 'gpw8aQ8LSl/q/Q==', 'TeB0i9+ESI12sQ+G', 'ujLAVCOK9okOaRqXQbz2QA==', '18102727@usc.edu.ph', 'GYZtJYl3FfPCew==', 'g8de3RMrIt4GAG0r', 'CQBqr6coa8J9EXyPYhClyA==', '0ZysY05ibQ==', '2XNw5ml0JrsRfUdl', 'tqSaiKQSi3GbE6hCA3hq1A==', '2025-11-21', 'Active', '2_solante_signature.png', '2_solante_profile.jpg', '2025-11-20 11:33:55', NULL),
(3, 'Hernandez', '', 'Jaime', 'Female', 'obNjBdYMfbqaFw==', 'YOTkIfT7so84Ms5u', 'UWs+sgIhQ+5s5qkHWn3Qcw==', '18102727@usc.edu.ph', 'S9A0Egf9vBY8rw==', '459/jffWdtFmcTm4', 'WxTB9bMIlPXrm7/rDnwODw==', 'r64GnY0=', 'L9B3dgBFtaHqjzYJ', '234mTF8YrczMlTZQRH6fKA==', '2025-11-21', 'Active', '3_hernandez_signature.png', '3_hernandez_profile.jpg', '2025-11-20 11:45:33', '2025-11-20 19:58:52'),
(4, 'Perez', '', 'Vince', 'Male', 'Y/tgB8+8POC+KA==', 'd/DsuP7MWVSKuZO+', '/rp890jwyWMg6Vb4glbGmA==', '18102727@usc.edu.ph', 'rx9gJAkvMbddew==', 'nso08Nr6IUsI+M2K', 'xEHb+5St+0iRY4hybvdfoA==', 'q7dIK9Y=', 'WPls6UX8D5EILBOD', 'DTeKylmLmx1nb93yqkm+Cw==', '2025-11-21', 'Active', '4_perez_signature.jpg', '4_perez_profile.jpg', '2025-11-20 12:03:43', '2025-11-20 23:56:32'),
(5, 'Domiggo', '', 'Cedric', 'Male', 'SYYPOlUsS6w9zw==', 'pNRlzT9HS2bixdUt', '49vni0J/T/ckZmX8jKzdVQ==', '18102727@usc.edu.ph', '2xM0fxA66JWLjg==', 'mNvC0E8eX1/AI+H0', '7sYyRSDU+sYssSvPW0RW0g==', 'W1xegjAa', '0W05rcYjeU+tnbfO', 'EnLF8zA+qS6H9ORxoYfHxA==', '2025-11-21', 'Active', '5_domiggo_signature.webp', '5_domiggo_profile.webp', '2025-11-20 12:06:42', NULL),
(6, 'Alonzo', '', 'Love', 'Female', 'LSMMcbQqERB0YA==', '7TVfpX6w7VcI75X9', 'pIWC5cjF22BoqoIOQsPLeA==', '18102727@usc.edu.ph', 'sqmHvEkYoawBzA==', 'fR3drubbk5WnNj87', 't2H2AdIdpzkRYJuulGsqww==', 'DzCbDUrVXw==', 'WT1J4VhsBXxRGeAD', 'XpOB9Npv9rrOFITNyASSBQ==', '2025-11-21', 'Active', '6_alonzo_signature.png', '6_alonzo_profile.jpg', '2025-11-20 12:11:09', '2025-11-20 23:57:02'),
(7, 'Asuncion', '', 'Ryan', 'Male', '0YsUgVkXQznh/Q==', '3wjFIsF8qg2ouQ5i', 'FnwA6ezzMbNDvp8FY677DA==', '18102727@usc.edu.ph', 'JUErQ6Y9fWjxCg==', 'M18423HCcCJF+YAO', 'HD6CC+/CvLvB+CUcXXxe6g==', 'yfha6QwBYVE=', '6dsbHZIzyayAEP8A', 'hPBWiLL6uD4/FmCMcHmZ/g==', '2025-11-21', 'Active', '7_asuncion_signature.png', '7_asuncion_profile.jpg', '2025-11-20 12:17:15', '2025-11-20 23:57:22'),
(8, 'Arriesgado', '', 'Irish', 'Female', 'ZihsXo7hRYUE5w==', 'xuBmrzGCr/dWYtFb', 'bJnVEBzw0MAzL+y8ysFH8Q==', '18102727@usc.edu.ph', 'S/vNIbnL0SxH5w==', '5gEuiWmojjnxpN2+', 'xqbopYBJLWUOEnMwi/bavw==', '6H+Dn2jJ', 'pg/caLh3aN7Ue2Wx', 'f62sCFwX8qGupu7m3sWhVw==', '2025-11-21', 'Active', '8_arriesgado_signature.png', '8_arriesgado_profile.jpg', '2025-11-20 12:28:34', '2025-11-20 23:57:44'),
(9, 'Smith', '', 'Jane', 'Male', 'X7ajLnDPOSULhw==', 'L6ZRAKOHNwQFnsrF', '+cnNNWj6QvcJ44HWIycErg==', 'lizbetheastwood@gmail.com', 'jFx1qtj1DJf6tQ==', 't/kp+808g2gvrwxG', 'y/mkyk4G3tZnW7/C1/qNTQ==', '53KPUt4jtmpuMQ==', 'tgUQUamVrxmH6U67', 'WW1gYMsJzhydnUQ/sR1P+Q==', '2025-12-01', 'Active', NULL, '9_smith_profile.jpg', '2025-11-20 19:35:56', '2025-11-21 03:38:13');

-- --------------------------------------------------------

--
-- Table structure for table `dentist_branch`
--

CREATE TABLE `dentist_branch` (
  `dentist_branch_id` int(11) NOT NULL,
  `dentist_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dentist_branch`
--

INSERT INTO `dentist_branch` (`dentist_branch_id`, `dentist_id`, `branch_id`) VALUES
(3, 2, 1),
(4, 2, 2),
(5, 3, 1),
(6, 3, 4),
(10, 4, 4),
(11, 4, 3),
(12, 4, 2),
(13, 5, 1),
(14, 5, 3),
(15, 6, 3),
(16, 6, 2),
(17, 7, 1),
(18, 7, 4),
(19, 7, 3),
(20, 7, 2),
(21, 1, 1),
(22, 1, 2),
(23, 1, 3),
(24, 1, 4),
(25, 8, 3),
(26, 9, 1),
(27, 9, 4),
(28, 9, 3),
(29, 9, 2);

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

--
-- Dumping data for table `dentist_schedule`
--

INSERT INTO `dentist_schedule` (`schedule_id`, `dentist_id`, `day`, `branch_id`, `start_time`, `end_time`) VALUES
(25, 2, 'Monday', 1, '09:00:00', '16:30:00'),
(26, 2, 'Tuesday', 2, '09:00:00', '16:30:00'),
(27, 2, 'Wednesday', 1, '09:00:00', '16:30:00'),
(28, 2, 'Thursday', 1, '09:00:00', '16:30:00'),
(29, 2, 'Friday', 1, '09:00:00', '16:30:00'),
(30, 2, 'Saturday', 1, '09:00:00', '16:30:00'),
(49, 3, 'Monday', 4, '09:00:00', '16:30:00'),
(50, 3, 'Tuesday', 4, '09:00:00', '16:30:00'),
(51, 3, 'Wednesday', 4, '09:00:00', '16:30:00'),
(52, 3, 'Thursday', 4, '09:00:00', '16:30:00'),
(53, 3, 'Friday', 4, '09:00:00', '16:30:00'),
(54, 3, 'Saturday', 4, '09:00:00', '12:30:00'),
(61, 5, 'Monday', 3, '09:00:00', '16:30:00'),
(62, 5, 'Tuesday', 1, '09:00:00', '16:30:00'),
(63, 5, 'Wednesday', 3, '09:00:00', '16:30:00'),
(64, 5, 'Thursday', 3, '09:00:00', '16:30:00'),
(65, 5, 'Friday', 3, '09:00:00', '16:30:00'),
(91, 1, 'Monday', 1, '09:00:00', '16:30:00'),
(92, 1, 'Tuesday', 2, '09:00:00', '16:30:00'),
(93, 1, 'Wednesday', 1, '09:00:00', '16:30:00'),
(94, 1, 'Thursday', 1, '09:00:00', '16:30:00'),
(95, 1, 'Saturday', 3, '09:00:00', '16:30:00'),
(96, 4, 'Monday', 4, '09:00:00', '16:30:00'),
(97, 4, 'Tuesday', 4, '09:00:00', '16:30:00'),
(98, 4, 'Wednesday', 2, '09:00:00', '16:30:00'),
(99, 4, 'Thursday', 2, '09:00:00', '16:30:00'),
(100, 4, 'Saturday', 3, '13:00:00', '16:30:00'),
(101, 6, 'Monday', 2, '09:00:00', '16:30:00'),
(102, 6, 'Tuesday', 3, '09:00:00', '16:30:00'),
(103, 6, 'Wednesday', 2, '09:00:00', '16:30:00'),
(104, 6, 'Thursday', 2, '09:00:00', '16:30:00'),
(105, 6, 'Friday', 2, '09:00:00', '16:30:00'),
(118, 7, 'Monday', 2, '09:00:00', '16:30:00'),
(119, 7, 'Tuesday', 1, '09:00:00', '16:30:00'),
(120, 7, 'Wednesday', 4, '09:00:00', '16:30:00'),
(121, 7, 'Thursday', 4, '09:00:00', '16:30:00'),
(122, 7, 'Friday', 4, '09:00:00', '16:30:00'),
(123, 7, 'Saturday', 4, '09:00:00', '16:30:00'),
(136, 8, 'Monday', 3, '09:00:00', '16:30:00'),
(137, 8, 'Tuesday', 3, '09:00:00', '16:30:00'),
(138, 8, 'Wednesday', 3, '09:00:00', '16:30:00'),
(139, 8, 'Thursday', 3, '09:00:00', '16:30:00'),
(140, 8, 'Friday', 3, '09:00:00', '16:30:00'),
(141, 8, 'Saturday', 3, '09:00:00', '16:30:00'),
(146, 9, 'Monday', 1, '09:00:00', '16:30:00'),
(147, 9, 'Wednesday', 3, '09:00:00', '16:30:00'),
(148, 9, 'Friday', 2, '09:00:00', '16:30:00'),
(149, 9, 'Saturday', 4, '09:00:00', '16:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `dentist_service`
--

CREATE TABLE `dentist_service` (
  `dentist_services_id` int(11) NOT NULL,
  `dentist_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dentist_service`
--

INSERT INTO `dentist_service` (`dentist_services_id`, `dentist_id`, `service_id`) VALUES
(2, 1, 1),
(3, 1, 2),
(4, 1, 3),
(5, 1, 4),
(6, 1, 5),
(7, 1, 6),
(8, 1, 7),
(9, 1, 8),
(10, 1, 9),
(11, 1, 10),
(12, 1, 11),
(13, 1, 12),
(14, 1, 13),
(15, 1, 14),
(16, 1, 15),
(17, 1, 16),
(18, 1, 17),
(19, 1, 18),
(20, 1, 19),
(21, 2, 12),
(22, 2, 9),
(23, 2, 8),
(24, 2, 2),
(25, 2, 3),
(26, 2, 1),
(27, 2, 17),
(28, 2, 15),
(29, 2, 7),
(30, 2, 14),
(31, 2, 13),
(32, 2, 18),
(33, 2, 16),
(34, 2, 10),
(35, 2, 11),
(36, 2, 5),
(37, 2, 4),
(38, 2, 19),
(39, 2, 6),
(40, 3, 12),
(41, 3, 9),
(42, 3, 8),
(43, 3, 2),
(44, 3, 3),
(45, 3, 1),
(46, 3, 17),
(47, 3, 15),
(48, 3, 7),
(49, 3, 14),
(50, 3, 13),
(51, 3, 18),
(52, 3, 16),
(53, 3, 10),
(54, 3, 11),
(55, 3, 5),
(56, 3, 4),
(57, 3, 19),
(58, 3, 6),
(59, 4, 12),
(60, 4, 9),
(61, 4, 8),
(62, 4, 2),
(63, 4, 3),
(64, 4, 1),
(65, 4, 17),
(66, 4, 15),
(67, 4, 7),
(68, 4, 14),
(69, 4, 13),
(70, 4, 18),
(71, 4, 16),
(72, 4, 10),
(73, 4, 11),
(74, 4, 5),
(75, 4, 4),
(76, 4, 19),
(77, 4, 6),
(78, 5, 12),
(79, 5, 9),
(80, 5, 8),
(81, 5, 2),
(82, 5, 3),
(83, 5, 1),
(84, 5, 17),
(85, 5, 15),
(86, 5, 7),
(87, 5, 14),
(88, 5, 13),
(89, 5, 18),
(90, 5, 16),
(91, 5, 10),
(92, 5, 11),
(93, 5, 5),
(94, 5, 4),
(95, 5, 19),
(96, 5, 6),
(97, 6, 12),
(98, 6, 9),
(99, 6, 8),
(100, 6, 2),
(101, 6, 3),
(102, 6, 1),
(103, 6, 17),
(104, 6, 15),
(105, 6, 7),
(106, 6, 14),
(107, 6, 13),
(108, 6, 18),
(109, 6, 16),
(110, 6, 10),
(111, 6, 11),
(112, 6, 5),
(113, 6, 4),
(114, 6, 19),
(115, 6, 6),
(116, 7, 12),
(117, 7, 9),
(118, 7, 8),
(119, 7, 2),
(120, 7, 3),
(121, 7, 1),
(122, 7, 17),
(123, 7, 15),
(124, 7, 7),
(125, 7, 14),
(126, 7, 13),
(127, 7, 18),
(128, 7, 16),
(129, 7, 10),
(130, 7, 11),
(131, 7, 5),
(132, 7, 4),
(133, 7, 19),
(134, 7, 6),
(135, 8, 12),
(136, 8, 9),
(137, 8, 8),
(138, 8, 2),
(139, 8, 3),
(140, 8, 1),
(141, 8, 17),
(142, 8, 15),
(143, 8, 7),
(144, 8, 14),
(145, 8, 13),
(146, 8, 18),
(147, 8, 16),
(148, 8, 10),
(149, 8, 11),
(150, 8, 5),
(151, 8, 4),
(152, 8, 19),
(153, 8, 6),
(154, 9, 12),
(155, 9, 9),
(156, 9, 8),
(157, 9, 2),
(158, 9, 3),
(159, 9, 1),
(160, 9, 17),
(161, 9, 15),
(162, 9, 7),
(163, 9, 14),
(164, 9, 13),
(165, 9, 18),
(166, 9, 16),
(167, 9, 10),
(168, 9, 11),
(169, 9, 5),
(170, 9, 4),
(171, 9, 19),
(172, 9, 6);

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

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `message`, `is_read`, `date_created`) VALUES
(1, 4, 'Your password was changed successfully on November 19, 2025, 7:05 pm. If this wasn’t you, please contact clinic immediately.', 1, '2025-11-19 11:05:34'),
(2, 5, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-19 11:16:06'),
(3, 5, 'Your appointment on 2025-11-24 at 09:00 was successfully booked!', 0, '2025-11-19 11:16:06'),
(4, 6, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-19 11:16:08'),
(5, 6, 'Your appointment on 2025-11-24 at 09:00 was successfully booked!', 0, '2025-11-19 11:16:08'),
(6, 7, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-19 11:18:41'),
(7, 7, 'Your appointment on 2025-11-26 at 10:00 was successfully booked!', 0, '2025-11-19 11:18:41'),
(8, 8, 'Your admin account has been created. Branch Assignment: Babag 2, Lapu-Lapu City. Username: Juban_J', 1, '2025-11-20 11:20:13'),
(9, 9, 'Your admin account has been created. Branch Assignment: Pajo, Lapu-Lapu City. Username: Benetiz_A', 0, '2025-11-20 11:23:11'),
(10, 10, 'Your admin account has been created. Branch Assignment: Pakna-an, Mandaue City (Main Branch). Username: Narciso_A', 0, '2025-11-20 11:25:41'),
(11, 11, 'Your admin account has been created. Branch Assignment: Pusok, Lapu-Lapu City. Username: Marcelo_R', 0, '2025-11-20 11:35:30'),
(12, 12, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-20 14:35:52'),
(13, 12, 'Your appointment on 2025-11-24 at 10:00 was successfully booked!', 0, '2025-11-20 14:35:52'),
(14, 13, 'Welcome to Smile-ify! Your account was successfully created.', 1, '2025-11-20 15:10:33'),
(15, 13, 'Your appointment on 2025-11-24 at 14:00 was successfully booked!', 1, '2025-11-20 15:10:33'),
(16, 14, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-20 16:51:46'),
(17, 14, 'Your appointment on 2025-11-28 at 15:00 was successfully booked!', 0, '2025-11-20 16:51:46'),
(18, 12, 'Your password was changed successfully on November 21, 2025, 1:00 am. If this wasn’t you, please contact clinic immediately.', 0, '2025-11-20 17:00:01'),
(19, 14, 'Your password was changed successfully on November 21, 2025, 1:05 am. If this wasn’t you, please contact clinic immediately.', 0, '2025-11-20 17:05:34'),
(20, 15, 'Welcome to Smile-ify! Your account was successfully created.', 1, '2025-11-20 17:08:28'),
(21, 15, 'Your appointment on 2025-12-25 at 15:00 was successfully booked!', 1, '2025-11-20 17:08:28'),
(22, 16, 'Welcome to Smile-ify! Your account was successfully created.', 0, '2025-11-20 17:08:30'),
(23, 16, 'Your appointment on 2025-12-25 at 15:00 was successfully booked!', 0, '2025-11-20 17:08:30'),
(24, 15, 'Your password was changed successfully on November 21, 2025, 1:35 am. If this wasn’t you, please contact clinic immediately.', 0, '2025-11-20 17:35:34'),
(25, 13, 'Your password was changed successfully on November 21, 2025, 1:56 am. If this wasn’t you, please contact the clinic immediately.', 1, '2025-11-20 17:56:13'),
(26, 12, 'Your appointment on 2025-11-22 at 09:00 was successfully booked!', 0, '2025-11-20 18:17:20'),
(27, 13, 'Your appointment on 2025-12-02 at 10:30 was successfully booked!', 1, '2025-11-20 18:25:35'),
(28, 13, 'Your password was changed successfully on November 21, 2025, 2:34 am. If this wasn’t you, please contact the clinic immediately.', 1, '2025-11-20 18:34:58'),
(29, 13, 'Your email was successfully updated to lizbetheastwood@yahoo.com on November 21, 2025, 2:42 am. If this wasn’t you, please contact the clinic immediately.', 1, '2025-11-20 18:42:18'),
(30, 13, 'Your email was successfully updated to lizbetheastwood@gmail.com on November 21, 2025, 2:43 am. If this wasn’t you, please contact the clinic immediately.', 1, '2025-11-20 18:43:41'),
(31, 13, 'Your appointment on 2025-11-21 at 09:00 was successfully booked!', 1, '2025-11-20 18:46:18'),
(32, 3, 'The service High Impact Denture (base price) in Babag 2, Lapu-Lapu City was set to Inactive.', 1, '2025-11-20 19:19:15'),
(33, 3, 'The service High Impact Denture (base price) in Babag 2, Lapu-Lapu City was set to Active.', 1, '2025-11-20 19:19:23'),
(34, 17, 'Your admin account has been created. Branch Assignment: Babag 2, Lapu-Lapu City. Username: Doe_J', 0, '2025-11-20 19:26:42'),
(35, 13, 'Your appointment (November 24, 2025 at 2:00 PM) has been cancelled.', 1, '2025-11-20 20:55:13'),
(36, 13, 'Your appointment on 2025-11-21 at 13:30 was successfully booked!', 1, '2025-11-20 20:58:37'),
(37, 13, 'Your appointment (November 21, 2025 at 1:30 PM) has been marked as completed. Thank you for visiting!', 1, '2025-11-20 21:00:52'),
(38, 4, 'Patient #13 Eloise Iway has requested a Dental Certificate for transaction #2', 0, '2025-11-20 21:07:00'),
(39, 8, 'Patient #13 Eloise Iway has requested a Dental Certificate for transaction #2', 1, '2025-11-20 21:07:00'),
(40, 17, 'Patient #13 Eloise Iway has requested a Dental Certificate for transaction #2', 0, '2025-11-20 21:07:00');

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

--
-- Dumping data for table `promo`
--

INSERT INTO `promo` (`promo_id`, `name`, `image_path`, `description`, `discount_type`, `discount_value`, `date_created`, `date_updated`) VALUES
(1, 'Senior Citizen Discount', '/images/promos/promo_1.jpg', '60+ age', 'percentage', 20.00, '2025-11-20 19:11:59', '2025-11-20 19:11:59'),
(2, 'Christmas Dental Promo', '/images/promos/promo_2.png', '', 'fixed', 200.00, '2025-11-20 19:16:05', '2025-11-20 19:16:05'),
(3, 'New Year Sale', NULL, '', 'percentage', 20.00, '2025-11-21 03:50:50', '2025-11-21 03:52:15');

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

--
-- Dumping data for table `qr_payment`
--

INSERT INTO `qr_payment` (`id`, `file_name`, `file_path`, `uploaded_at`) VALUES
(1, 'qr_payment.png', '/images/qr/qr_payment.png', '2025-11-20 20:02:11');

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

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`service_id`, `name`, `price`, `duration_minutes`, `date_created`, `date_updated`, `requires_xray`) VALUES
(1, 'Dental Certificate', 150, 0, '2025-11-20 18:28:52', '2025-11-20 18:49:42', 0),
(2, 'Check Up/Consultation', 200, 15, '2025-11-20 18:21:54', '2025-11-20 18:49:52', 0),
(3, 'Cleaning', 700, 45, '2025-11-20 18:22:17', '2025-11-20 18:50:06', 0),
(4, 'Tooth Filling', 700, 60, '2025-11-20 18:22:36', '2025-11-20 18:50:13', 0),
(5, 'Tooth Extraction', 700, 30, '2025-11-20 18:23:29', '2025-11-20 18:50:28', 0),
(6, 'Wisdom Tooth Extraction', 1600, 90, '2025-11-20 18:23:53', '2025-11-20 18:51:13', 0),
(7, 'Fluoride Application', 500, 15, '2025-11-20 18:24:09', '2025-11-20 18:51:19', 0),
(8, 'Braces (Simple)', 40000, 120, '2025-11-20 18:25:27', '2025-11-20 18:51:28', 0),
(9, 'Braces (Complicated)', 70000, 120, '2025-11-20 18:25:42', '2025-11-20 18:51:59', 0),
(10, 'Retainer (Plain)', 4000, 30, '2025-11-20 18:26:24', '2025-11-20 18:52:04', 0),
(11, 'Retainer w/ Pontic', 4000, 45, '2025-11-20 18:26:44', '2025-11-20 18:52:12', 0),
(12, 'Aligner', 100000, 45, '2025-11-20 18:27:01', '2025-11-20 18:54:33', 0),
(13, 'Ordinary Denture (base price)', 1900, 60, '2025-11-20 18:27:56', '2025-11-20 18:54:54', 0),
(14, 'High Impact Denture (base price)', 4000, 60, '2025-11-20 18:28:22', '2025-11-21 03:19:23', 0),
(15, 'Flexible Denture (base price)', 12000, 60, '2025-11-20 18:29:38', '2025-11-20 18:55:18', 0),
(16, 'Porcelain Crown', 14000, 120, '2025-11-20 18:30:29', '2025-11-20 18:55:24', 0),
(17, 'Emax Crown', 15000, 120, '2025-11-20 18:30:42', '2025-11-20 18:55:33', 0),
(18, 'PFM Crown', 7000, 120, '2025-11-20 18:31:05', '2025-11-20 18:55:42', 0),
(19, 'Veneer', 15000, 120, '2025-11-20 18:31:22', '2025-11-20 18:55:48', 0),
(20, 'Oral Surgery', 150000, 120, '2025-11-21 03:42:39', '2025-11-21 03:43:49', 1);

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

--
-- Dumping data for table `service_supplies`
--

INSERT INTO `service_supplies` (`id`, `service_id`, `branch_id`, `supply_id`, `quantity_used`, `date_created`, `date_updated`) VALUES
(1, 12, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(2, 9, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(3, 8, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(4, 3, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(5, 17, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(6, 15, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(7, 7, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(8, 14, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(9, 20, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(10, 13, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(11, 18, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(12, 16, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(13, 10, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(14, 11, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(15, 5, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(16, 4, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(17, 19, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55'),
(18, 6, 1, 1, '0', '2025-11-20 20:28:55', '2025-11-21 04:28:55');

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

--
-- Dumping data for table `supply`
--

INSERT INTO `supply` (`supply_id`, `name`, `description`, `category`, `unit`) VALUES
(1, 'Gloves', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_xrays`
--

CREATE TABLE `transaction_xrays` (
  `xray_id` int(11) NOT NULL,
  `dental_transaction_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `password` varchar(255) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `date_of_birth` varchar(255) DEFAULT NULL,
  `date_of_birth_iv` text DEFAULT NULL,
  `date_of_birth_tag` text DEFAULT NULL,
  `email` varchar(50) NOT NULL,
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
  `date_updated` datetime DEFAULT NULL,
  `force_logout` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `last_name`, `middle_name`, `first_name`, `gender`, `date_of_birth`, `date_of_birth_iv`, `date_of_birth_tag`, `email`, `contact_number`, `contact_number_iv`, `contact_number_tag`, `address`, `address_iv`, `address_tag`, `role`, `branch_id`, `date_started`, `status`, `date_created`, `date_updated`, `force_logout`) VALUES
(3, 'smileify_owner', '$2y$10$ztP9PxeWoQ1xebbhT0ztneZF//6oHiDQMjxLHb8jDxOR/mbCFY07y', 'Arriesgado', NULL, 'Irish', 'Male', 'dpFnPzlFUzy54A==', 'RcZbZyejRp4dSJlj', 'I+SiyQJElPq3RGEpy0JKpw==', 'josephparchaso@gmail.com', 'dIG/JWw8OxS7+Cw=', 'f+vA6QnRdnPORrZN', 'hxq4sxxR8zWZfdUh37KX7g==', NULL, NULL, NULL, 'owner', NULL, '2025-11-19', 'Active', '2025-11-18 16:24:36', NULL, 0),
(4, 'Potot_R', '$2y$10$AHkfLSKgjSUI/EdSvwkf8ORV51ch4nW4G0P.nJgI4jLooX273USE2', 'Potot', 'Travero', 'Rixielie', 'Male', 'RyRYccuXmYFSkQ==', 'md9KB1cF773cRmfC', '4LD5nRNuJo1W+ZmMLzbh3w==', '18102727@usc.edu.ph', 'rUxFAwCeceu1vQ==', 'GYD4S15mO0Z80tQt', 'NtgvbNMSCPRboi5mplXgXg==', 'YDRAWm+x7TnnKhpyZQ==', 'yeH0qllgFui+B+G2', '6PQeqkQMnKEDOAJWB3boPw==', 'admin', 1, '2025-11-20', 'Inactive', '2025-11-19 11:03:01', '2025-11-20 19:21:10', 1),
(5, 'Castillo_A', '$2y$10$RhbUsibDKWIWyN0EUQ/CA.iQgV3Rdj23VtBbOMAhqVQpmorH7KrVe', 'Castillo', 'Potot', 'Athena', 'Female', 'I/9n2u5r5XcZxw==', 'jx14VxEtWd3nP+fJ', 'oHfUbubiWK6o2yG6mZg7tA==', '18102727@usc.edu.ph', 'OhKRvWL+V+kj3A==', 'AaQ4MyZc0Q8dFP+U', 'EW68ZRTAILc6TZd23z3xtg==', NULL, NULL, NULL, 'patient', 1, NULL, 'Inactive', '2025-11-19 11:16:06', '2025-11-19 19:19:44', 0),
(6, 'Castillo_A1', '$2y$10$GD9/KqAiQwulPzQyzfy7DeqIiBrEJLqBYqva7HnTsj/pUIsPsCkgu', 'Castillo', 'Potot', 'Athena', 'Female', 'AMIXwTnVAVznyQ==', 'Xvu1UMb9tcWy4jDm', 'jLPfl2fJ/iVLO6CzuksjxQ==', '18102727@usc.edu.ph', 'NquQqNZAsVaD1g==', 'gpDvHJ1rmd2QrNBz', '1QSDqVAz8kFyCGtzD55pXw==', NULL, NULL, NULL, 'patient', 1, NULL, 'Active', '2025-11-19 11:16:08', NULL, 0),
(7, 'Castillo_A2', '$2y$10$ol1lkJC3jP0dZJgl17ZPn.ACG1fzSx./5IUBtPxzHvolkuLHUOY8u', 'Castillo', 'Potot', 'Andrei', 'Male', 'UFlqlalBgFVsSQ==', 'OZPnRFSbJi8PUMKW', 'MPA5HseUQM3ylH+bSP+Wlw==', 'theartp1@gmail.com', 'TWcAhvqxqMRuOQ==', 'rcJ4d24lyRKFiY54', '2j3yKXZ0MeWiHVMt+9ICSg==', NULL, NULL, NULL, 'patient', 1, NULL, 'Active', '2025-11-19 11:18:41', NULL, 0),
(8, 'Juban_J', '$2y$10$Ml8o3zZKL26bnt7FotL3we1F/l6ceWugbIY3RYIho7zHH8UXfeMg2', 'Juban', '', 'Jay Marie', 'Female', 'W6gKRmdOedtgMw==', 'xvWwRpJ+7C1P89jT', '3J26tQybCTquA0epsbA3eg==', '18102727@usc.edu.ph', '2NA6GcZzf2twqA==', 'gHkDZU7Pg5M8awYE', 'nEneWyOoOKT2yAePPMNM4A==', 'SZXFY3SyXbWu4+JKK1x4DGxR75TV', '0kwaIQiCYXKhD+DI', 'O4LCjCWXFsFUvfU/yiIXog==', 'admin', 1, '2025-11-21', 'Active', '2025-11-20 11:20:13', NULL, 0),
(9, 'Benetiz_A', '$2y$10$7EzcfeVMnq7CjbkDU0/3G.Ot4ylMtifZ/GM7gXfkeDRSrBAAtZVPe', 'Benetiz', '', 'Aaron', 'Male', '++uCZISsBX3MNA==', 'WAKcRG+qo1Tfccqr', 'w7FPkjIVsoo9/6zjBu1nOg==', '18102727@usc.edu.ph', 'RXNk/LoWKpbN4w==', 'h8Bg22zwsSqMlXd5', 'Wyp+FWsmm3MHe+5agA7hVQ==', 'f5jGFyvjmaNg6piG6Op3jcoyqUEr', '9fCRtqSRZI9cx0d7', '9SZI1F9/H+c73nrZutsyzQ==', 'admin', 4, '2025-11-21', 'Active', '2025-11-20 11:23:11', NULL, 0),
(10, 'Narciso_A', '$2y$10$BS6Ia9L2r7bvFYENocT1TuCGLW1sHWk4NZHNjE3QUiDo7q0X9sbra', 'Narciso', '', 'Angel', 'Female', 'WYY7zpBvUtVpog==', 'cPgPoHeLBrcTYWNG', '60B8gS78N231wsgcgskkUw==', '18102727@usc.edu.ph', 'hLGthgQF1CbMKg==', 'Za1wjW6BRDZp0X/O', 'MA/eRlOINePH7yIKmTY6gg==', 'LToBiPzyPnyFok6MUgG2k9FGhc138g==', '+XUjckIyj33tiU5p', 'h+33wC9t7jgaLdszUBlqxQ==', 'admin', 3, '2025-11-21', 'Active', '2025-11-20 11:25:41', NULL, 0),
(11, 'Marcelo_R', '$2y$10$SrXzvZ2.2W3F4ooriduFHuCa0xjS28HV7F7NA1O8xbPiu9ewoYLfq', 'Marcelo', '', 'Riley', 'Female', 'yFoSOEuqlpr1+w==', 'geFTPDmws5uVGhQw', 'mKMKcxlD1bh2mGXiV3tO4Q==', '18102727@usc.edu.ph', 'kSo6ZNzyyu2BwA==', 'a+zjtSDJbiFQD0JQ', 'EzxAPii2TsJ3j2xEMc+nXg==', 'SRp61TbqJ9mXtLptMVmXqtwRZfdQoi/8', 'IRRuKAaRve8lmeMR', 'DFyQJHAyXaXWa693gjcmdg==', 'admin', 2, '2025-11-21', 'Active', '2025-11-20 11:35:30', NULL, 0),
(12, 'Castillo_A3', '$2y$10$glwI4cvfn67yt858U0XAlemZ744ji0PZVn2S8p68c7xNsWBmE.8C2', 'Castillo', '', 'Athena', 'Female', 't/QAioZmH+m6bQ==', '+Hm2XAC29jHjhfZx', 'MmRzKIz7s9ScaeoQaDKd/g==', '18102727@usc.edu.ph', 'hcXs7F8piBTu0g==', 'jJU+36E1NFsw37ew', 'FemV2mGOiH6CHCI3EQqFpA==', NULL, NULL, NULL, 'patient', 1, NULL, 'Active', '2025-11-20 14:35:52', '2025-11-21 02:17:20', 0),
(13, 'Iway_E', '$2y$10$XPpE.CmrHLzsb2FOllR1zeqhy9fCfk0wzPr4mXPI04xKJaC1qkOb.', 'Iway', '', 'Eloise', 'Female', '08M8TEFRPQfPfA==', 'PkACFZ3rEqQ275cZ', '/56SrkYSpIRCOwrDBZOUGQ==', 'lizbetheastwood@gmail.com', '8BCXtJSAJGXbog==', '2/wJGe6+nWrf2Hib', 'H9cEm8Q6ajPk5m8voSoWXA==', 'jx7SqFmQ0TxO1E8bUOkjfWFRMZCyR4I=', '+HNEhlmNTbQZbslF', '4hXaKBIOlzKSwhENgqsoNQ==', 'patient', 1, NULL, 'Active', '2025-11-20 15:10:33', '2025-11-21 04:58:37', 0),
(14, 'PAT_Y', '$2y$10$SjFarcchEzBVS144rkEYze8GVi.XOKm3xN3R1YU7vrYEBkm4TUtOy', 'PAT', 'RTAVERO', 'YEAH', 'Female', 'lz1ENqTUfzJs1Q==', 'LGK1FvvE49MK56vF', 'LrD4w0CyJwchgmzYIyVWfg==', 'annapotot27@gmail.com', 'g5GC7ICl0AUlSQ==', 'dsvktXn1vFCTf3Fs', 'DoXTO6bUZbCbq70jN9UkGA==', NULL, NULL, NULL, 'patient', 1, NULL, 'Active', '2025-11-20 16:51:46', NULL, 0),
(15, 'Summers_D', '$2y$10$d9PZS1r/4yhsFdsLcmBdVexf4KR/SKoLtBQNVSaKc26UlCVeNkibm', 'Summers', '', 'Dazey', 'Female', 'wESYnW5+GItr3Q==', 'm1Fv28agWgxfNVcs', 'QyuX5snhAW4gdjxsegmo3A==', 'dazeyyuh@gmail.com', 'LRQsKMTgym5E7g==', 'rmlt7kQRybkK3D7J', 'DoJZhH+2GR0Ul8XCORUtAQ==', NULL, NULL, NULL, 'patient', 3, NULL, 'Active', '2025-11-20 17:08:28', NULL, 0),
(16, 'Summers_D1', '$2y$10$HomQVF321N8qYw6dHDCnNOnoIll.nhuYwJZzPoFgZgLA.R.UaWvuK', 'Summers', '', 'Dazey', 'Female', 'XHgFVLLnOBreRA==', '+JcIO85FD4Rm8qHD', 'Y9u+NkR/p8EZUWOi6PES1w==', 'dazeyyuh@gmail.com', 'H0/aHHYnfQwhMQ==', 'TDBocMfSK4Z628c4', 't/0PKCSzSGwEimpF6uiReQ==', NULL, NULL, NULL, 'patient', 3, NULL, 'Active', '2025-11-20 17:08:30', NULL, 0),
(17, 'Doe_J', '$2y$10$1qpsFUswvumFK56y.BnlbO3QlRjLBKxdvmeBq99QaGtUarqSbxnn6', 'Doe', '', 'Jane', 'Female', 'amfETNkDGekewQ==', 'begSNFHAbLDBe8GB', 'bUm3uN9yGRB78FF3lpoHdg==', 'lizbetheastwood@gmail.com', 'rk6pIZaVPOJJbA==', '18I8Ac1Xp9z1ltRW', '5jtvKA6beos3WIV8KwGBXQ==', '9veUhYjP+qQa5TdYxYOFR8Q2oyc/', 'Ta4SaYv9fv0zCxnz', 'mtd6GK9z9+EpYIVEQuOHqQ==', 'admin', 1, '2025-11-24', 'Active', '2025-11-20 19:26:42', '2025-11-21 03:28:04', 1);

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
-- Indexes for table `transaction_xrays`
--
ALTER TABLE `transaction_xrays`
  ADD PRIMARY KEY (`xray_id`),
  ADD KEY `dental_transaction_id` (`dental_transaction_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `index_username_unique` (`username`),
  ADD KEY `fk_users_branch` (`branch_id`);

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
  MODIFY `appointment_services_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `appointment_transaction`
--
ALTER TABLE `appointment_transaction`
  MODIFY `appointment_transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `branch`
--
ALTER TABLE `branch`
  MODIFY `branch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `branch_announcements`
--
ALTER TABLE `branch_announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `branch_promo`
--
ALTER TABLE `branch_promo`
  MODIFY `branch_promo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `branch_service`
--
ALTER TABLE `branch_service`
  MODIFY `branch_services_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT for table `branch_supply`
--
ALTER TABLE `branch_supply`
  MODIFY `branch_supplies_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `dental_prescription`
--
ALTER TABLE `dental_prescription`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `dental_tips`
--
ALTER TABLE `dental_tips`
  MODIFY `tip_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dental_transaction`
--
ALTER TABLE `dental_transaction`
  MODIFY `dental_transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `dental_transaction_services`
--
ALTER TABLE `dental_transaction_services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `dental_vital`
--
ALTER TABLE `dental_vital`
  MODIFY `vitals_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `dentist`
--
ALTER TABLE `dentist`
  MODIFY `dentist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `dentist_branch`
--
ALTER TABLE `dentist_branch`
  MODIFY `dentist_branch_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `dentist_schedule`
--
ALTER TABLE `dentist_schedule`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT for table `dentist_service`
--
ALTER TABLE `dentist_service`
  MODIFY `dentist_services_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `promo`
--
ALTER TABLE `promo`
  MODIFY `promo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `qr_payment`
--
ALTER TABLE `qr_payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `service`
--
ALTER TABLE `service`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `service_supplies`
--
ALTER TABLE `service_supplies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `supply`
--
ALTER TABLE `supply`
  MODIFY `supply_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `transaction_xrays`
--
ALTER TABLE `transaction_xrays`
  MODIFY `xray_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

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
-- Constraints for table `transaction_xrays`
--
ALTER TABLE `transaction_xrays`
  ADD CONSTRAINT `transaction_xrays_ibfk_1` FOREIGN KEY (`dental_transaction_id`) REFERENCES `dental_transaction` (`dental_transaction_id`),
  ADD CONSTRAINT `transaction_xrays_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
