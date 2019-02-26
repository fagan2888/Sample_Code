-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 28, 2017 at 03:48 AM
-- Server version: 5.6.35
-- PHP Version: 7.1.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `Tools4Rent`
--
CREATE DATABASE IF NOT EXISTS `Tools4Rent` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `Tools4Rent`;

-- --------------------------------------------------------

--
-- Table structure for table `Accessory`
--

CREATE TABLE `Accessory` (
	  `accessory_description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Accessory`
--

INSERT INTO `Accessory` (`accessory_description`) VALUES
('8.9V Li-ion Battery'),
('8.9V NiMH Battery'),
('9.0V Li-ion Battery'),
('cord'),
('Drill Acces1'),
('Drill Acces2'),
('Drill Acces3'),
('Generator Acce1'),
('Generator Acce2'),
('Mixer Acce1'),
('Mixer Acce2'),
('Monitor'),
('Sander Acce1'),
('Sander Acce2'),
('Saw 1'),
('Saw 2'),
('Saw Acce1');

-- --------------------------------------------------------

--
-- Table structure for table `AirCompressor`
--

CREATE TABLE `AirCompressor` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `tank_size` int(16) NOT NULL,
	  `pressure_rating` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `AirCompressor`
--

INSERT INTO `AirCompressor` (`tool_id`, `tank_size`, `pressure_rating`) VALUES
(20, 3, '0.500'),
(25, 2, '1.800');

-- --------------------------------------------------------

--
-- Table structure for table `Clerk`
--

CREATE TABLE `Clerk` (
	  `clerk_id` int(16) UNSIGNED NOT NULL,
	  `hire_date` date DEFAULT NULL,
	  `home_area_code` varchar(3) DEFAULT NULL,
	  `home_phone_number` varchar(7) DEFAULT NULL,
	  `home_phone_extension` varchar(4) DEFAULT NULL,
	  `treet` varchar(100) NOT NULL,
	  `city` varchar(100) NOT NULL,
	  `state` varchar(2) NOT NULL,
	  `zip_code` varchar(10) NOT NULL,
	  `username` varchar(50) NOT NULL,
	  `first_name` varchar(50) NOT NULL,
	  `middle_name` varchar(50) NOT NULL,
	  `last_name` varchar(50) NOT NULL,
	  `email` varchar(250) NOT NULL,
	  `password` varchar(60) NOT NULL DEFAULT '111111'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Clerk`
--

INSERT INTO `Clerk` (`clerk_id`, `hire_date`, `home_area_code`, `home_phone_number`, `home_phone_extension`, `treet`, `city`, `state`, `zip_code`, `username`, `first_name`, `middle_name`, `last_name`, `email`, `password`) VALUES
(9, '2017-11-25', NULL, NULL, NULL, '', '', '', '', 'feng@tools4rent.com', 'Feng', '', 'Wang', 'feng@tools4rent.com', '123456'),
(7, '2017-11-24', NULL, NULL, NULL, '', '', '', '', 'hongyu@tools4rent.com', 'Hongyu', '', 'Zhou', 'hongyu@tools4rent.com', '123456'),
(8, '2017-11-23', NULL, NULL, NULL, '', '', '', '', 'shijie@tools4rent.com', 'Shijie', '', 'Shi', 'shijie@tools4rent.com', '123456'),
(6, '2017-11-23', NULL, NULL, NULL, '', '', '', '', 'test@tools4rent.com', 'TestF', '', 'TestL', 'test@tools4rent.com', '123456'),
(10, '2017-11-25', NULL, NULL, NULL, '', '', '', '', 'tianyu@tools4rent.com', 'Yu', '', 'Tian', 'tianyu@tools4rent.com', '123456');

-- --------------------------------------------------------

--
-- Table structure for table `Customer`
--

CREATE TABLE `Customer` (
	  `customer_id` int(16) UNSIGNED NOT NULL,
	  `work_area_code` varchar(3) DEFAULT NULL,
	  `work_phone_number` varchar(7) DEFAULT NULL,
	  `work_phone_extension` varchar(4) DEFAULT NULL,
	  `home_area_code` varchar(3) DEFAULT NULL,
	  `home_phone_number` varchar(7) DEFAULT NULL,
	  `home_phone_extension` varchar(4) DEFAULT NULL,
	  `cell_area_code` varchar(3) DEFAULT NULL,
	  `cell_phone_number` varchar(7) DEFAULT NULL,
	  `cell_phone_extension` varchar(4) DEFAULT NULL,
	  `primary_area_code` varchar(3) NOT NULL,
	  `primary_phone_number` varchar(7) NOT NULL,
	  `primary_phone_extension` varchar(4) DEFAULT NULL,
	  `name_on_card` varchar(50) NOT NULL,
	  `card_number` varchar(16) NOT NULL,
	  `cvv` varchar(3) NOT NULL,
	  `exp_month` varchar(15) NOT NULL,
	  `exp_year` varchar(4) NOT NULL,
	  `street` varchar(100) NOT NULL,
	  `city` varchar(100) NOT NULL,
	  `state` varchar(2) NOT NULL,
	  `zip_code` varchar(10) NOT NULL,
	  `username` varchar(50) NOT NULL,
	  `first_name` varchar(50) NOT NULL,
	  `middle_name` varchar(50) DEFAULT NULL,
	  `last_name` varchar(50) NOT NULL,
	  `email` varchar(250) NOT NULL,
	  `password` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Customer`
--

INSERT INTO `Customer` (`customer_id`, `work_area_code`, `work_phone_number`, `work_phone_extension`, `home_area_code`, `home_phone_number`, `home_phone_extension`, `cell_area_code`, `cell_phone_number`, `cell_phone_extension`, `primary_area_code`, `primary_phone_number`, `primary_phone_extension`, `name_on_card`, `card_number`, `cvv`, `exp_month`, `exp_year`, `street`, `city`, `state`, `zip_code`, `username`, `first_name`, `middle_name`, `last_name`, `email`, `password`) VALUES
(3, NULL, NULL, NULL, '214', '6624202', NULL, '214', '6624202', NULL, '214', '6624202', NULL, 'Feng', '111777988', '123', '2', '2020', '5349 Amesbury Driver', 'Dallas', 'TX', '75206', 'feng@gmail.com', 'Feng ', '', 'Wang', 'feng@gmail.com', '123456'),
(2, NULL, NULL, NULL, '214', '6624202', NULL, '214', '6624202', NULL, '214', '6624202', NULL, 'Shijie', '111777988', '123', '2', '2020', '5349 Amesbury Driver', 'Dallas', 'TX', '75206', 'shijie@gmail.com', 'Shijie ', '', 'Shi', 'shijie@gmail.com', '123456'),
(4, NULL, NULL, NULL, '214', '6624202', NULL, '214', '6624202', NULL, '214', '6624202', NULL, 'Tianyu', '111777988', '123', '2', '2020', '5349 Amesbury Driver', 'Dallas', 'TX', '75206', 'tianyu@gmail.com', 'Yu ', '', 'Tian', 'tianyu@gmail.com', '123456'),
(1, NULL, NULL, NULL, '214', '6624202', NULL, '214', '6624202', NULL, '214', '6624202', NULL, 'Hongyu', '111222333', '123', '5', '2019', '5349 Amesbury Driver', 'Dallas', 'TX', '75206', 'zhouhongyu9310@gmail.com', 'Hongyu ', '', 'Zhou', 'zhouhongyu9310@gmail.com', '123456');

-- --------------------------------------------------------

--
-- Table structure for table `Digger`
--

CREATE TABLE `Digger` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `blade_width` decimal(10,3) NOT NULL,
	  `blade_length` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Digger`
--

INSERT INTO `Digger` (`tool_id`, `blade_width`, `blade_length`) VALUES
(10, '23.250', '11.375');

-- --------------------------------------------------------

--
-- Table structure for table `Drill`
--

CREATE TABLE `Drill` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `adjustable` varchar(5) NOT NULL,
	  `mintorque` decimal(10,1) NOT NULL,
	  `maxtorque` decimal(10,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Drill`
--

INSERT INTO `Drill` (`tool_id`, `adjustable`, `mintorque`, `maxtorque`) VALUES
(17, 'True', '100.0', '0.0'),
(22, 'True', '300.0', '0.0');

-- --------------------------------------------------------

--
-- Table structure for table `Garden`
--

CREATE TABLE `Garden` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `handle_material` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Garden`
--

INSERT INTO `Garden` (`tool_id`, `handle_material`) VALUES
(10, 'Iron'),
(11, 'Iron'),
(12, 'Metal'),
(13, 'Nick'),
(14, 'Metal');

-- --------------------------------------------------------

--
-- Table structure for table `Generator`
--

CREATE TABLE `Generator` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `power_rating` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Generator`
--

INSERT INTO `Generator` (`tool_id`, `power_rating`) VALUES
(27, '4.000');

-- --------------------------------------------------------

--
-- Table structure for table `Gun`
--

CREATE TABLE `Gun` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `gauge_rating` int(16) NOT NULL,
	  `capacity` int(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Gun`
--

INSERT INTO `Gun` (`tool_id`, `gauge_rating`, `capacity`) VALUES
(8, 20, 90);

-- --------------------------------------------------------

--
-- Table structure for table `Hammer`
--

CREATE TABLE `Hammer` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `anti_vibration` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Hammer`
--

INSERT INTO `Hammer` (`tool_id`, `anti_vibration`) VALUES
(9, 'False');

-- --------------------------------------------------------

--
-- Table structure for table `Hand`
--

CREATE TABLE `Hand` (
	  `tool_id` int(16) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Hand`
--

INSERT INTO `Hand` (`tool_id`) VALUES
(1),
(3),
(4),
(5),
(6),
(7),
(8),
(9);

-- --------------------------------------------------------

--
-- Table structure for table `Ladder`
--

CREATE TABLE `Ladder` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `step_cout` int(16) DEFAULT NULL,
	  `weight_capacity` int(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Ladder`
--

INSERT INTO `Ladder` (`tool_id`, `step_cout`, `weight_capacity`) VALUES
(15, 4, 30),
(16, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `Mixer`
--

CREATE TABLE `Mixer` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `motor_rating` decimal(10,3) NOT NULL,
	  `drum_size` decimal(10,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Mixer`
--

INSERT INTO `Mixer` (`tool_id`, `motor_rating`, `drum_size`) VALUES
(21, '5.250', '2.2'),
(26, '5.250', '1.1');

-- --------------------------------------------------------

--
-- Table structure for table `Pair`
--

CREATE TABLE `Pair` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `accessory_quantity` int(16) NOT NULL,
	  `accessory_description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Pair`
--

INSERT INTO `Pair` (`tool_id`, `accessory_quantity`, `accessory_description`) VALUES
(2, 4, '8.9V Li-ion Battery'),
(23, 4, '8.9V Li-ion Battery'),
(22, 3, '8.9V NiMH Battery'),
(24, 3, '9.0V Li-ion Battery'),
(20, 3, 'cord'),
(17, 3, 'Drill Acces1'),
(22, 3, 'Drill Acces1'),
(17, 3, 'Drill Acces2'),
(22, 4, 'Drill Acces2'),
(17, 4, 'Drill Acces3'),
(22, 1, 'Drill Acces3'),
(27, 3, 'Generator Acce1'),
(27, 6, 'Generator Acce2'),
(21, 4, 'Mixer Acce1'),
(21, 1, 'Mixer Acce2'),
(20, 2, 'Monitor'),
(25, 2, 'Monitor'),
(19, 3, 'Sander Acce1'),
(19, 4, 'Sander Acce2'),
(2, 3, 'Saw 1'),
(2, 4, 'Saw 2'),
(23, 4, 'Saw Acce1');

-- --------------------------------------------------------

--
-- Table structure for table `Pliers`
--

CREATE TABLE `Pliers` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `adjustable` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Pliers`
--

INSERT INTO `Pliers` (`tool_id`, `adjustable`) VALUES
(5, 'True'),
(7, 'False');

-- --------------------------------------------------------

--
-- Table structure for table `Power`
--

CREATE TABLE `Power` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `volt_rating` decimal(10,1) NOT NULL,
	  `amp_rating` decimal(10,1) NOT NULL,
	  `min_rpm_rating` int(16) NOT NULL,
	  `max_rpm_rating` int(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Power`
--

INSERT INTO `Power` (`tool_id`, `volt_rating`, `amp_rating`, `min_rpm_rating`, `max_rpm_rating`) VALUES
(2, '8.9', '300.0', 4900, 0),
(17, '120.0', '300.0', 400, 500),
(18, '220.0', '31200.0', 400, 300),
(19, '240.0', '0.3', 300, 0),
(20, '240.0', '400.0', 400, 0),
(21, '120.0', '31.0', 400, 0),
(22, '8.9', '400.0', 300, 0),
(23, '8.9', '10.4', 400, 0),
(24, '9.0', '0.0', 300, 0),
(25, '120.0', '0.4', 400, 0),
(26, '220.0', '1000.0', 300, 0),
(27, '220.0', '400.0', 400, 500);

-- --------------------------------------------------------

--
-- Table structure for table `Pruner`
--

CREATE TABLE `Pruner` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `blade_material` varchar(50) NOT NULL,
	  `blade_length` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Pruner`
--

INSERT INTO `Pruner` (`tool_id`, `blade_material`, `blade_length`) VALUES
(11, 'Metal', '3.500');

-- --------------------------------------------------------

--
-- Table structure for table `Purchase`
--

CREATE TABLE `Purchase` (
	  `purchase_id` int(16) UNSIGNED NOT NULL,
	  `cur_date` date NOT NULL,
	  `customer_username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Rakes`
--

CREATE TABLE `Rakes` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `tine_count` int(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Rakes`
--

INSERT INTO `Rakes` (`tool_id`, `tine_count`) VALUES
(12, 3);

-- --------------------------------------------------------

--
-- Table structure for table `Ratchet`
--

CREATE TABLE `Ratchet` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `drive_size` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Ratchet`
--

INSERT INTO `Ratchet` (`tool_id`, `drive_size`) VALUES
(4, '0.750');

-- --------------------------------------------------------

--
-- Table structure for table `Reservation`
--

CREATE TABLE `Reservation` (
	  `reservation_id` int(16) UNSIGNED NOT NULL,
	  `start_date` date NOT NULL,
	  `end_date` date NOT NULL,
	  `customer_username` varchar(50) NOT NULL,
	  `pickup_clerk` varchar(50) DEFAULT NULL,
	  `dropoff_clerk` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Reservation`
--

INSERT INTO `Reservation` (`reservation_id`, `start_date`, `end_date`, `customer_username`, `pickup_clerk`, `dropoff_clerk`) VALUES
(1, '2017-11-01', '2017-11-10', 'zhouhongyu9310@gmail.com', 'test@tools4rent.com', 'test@tools4rent.com'),
(2, '2017-10-01', '2017-10-12', 'zhouhongyu9310@gmail.com', 'hongyu@tools4rent.com', 'test@tools4rent.com'),
(3, '2017-11-02', '2017-11-10', 'zhouhongyu9310@gmail.com', 'hongyu@tools4rent.com', 'test@tools4rent.com'),
(4, '2017-11-01', '2017-11-02', 'zhouhongyu9310@gmail.com', 'test@tools4rent.com', 'test@tools4rent.com'),
(5, '2017-11-26', '2017-11-27', 'zhouhongyu9310@gmail.com', 'test@tools4rent.com', 'test@tools4rent.com'),
(6, '2017-11-27', '2017-11-29', 'zhouhongyu9310@gmail.com', 'hongyu@tools4rent.com', 'tianyu@tools4rent.com'),
(7, '2017-11-28', '2017-11-29', 'zhouhongyu9310@gmail.com', 'tianyu@tools4rent.com', 'feng@tools4rent.com'),
(8, '2017-11-30', '2017-12-01', 'zhouhongyu9310@gmail.com', 'feng@tools4rent.com', 'shijie@tools4rent.com'),
(9, '2017-11-01', '2017-11-09', 'feng@gmail.com', 'shijie@tools4rent.com', 'shijie@tools4rent.com'),
(10, '2017-10-05', '2017-10-20', 'feng@gmail.com', 'feng@tools4rent.com', 'shijie@tools4rent.com'),
(11, '2017-10-18', '2017-11-26', 'feng@gmail.com', 'hongyu@tools4rent.com', 'tianyu@tools4rent.com'),
(12, '2017-11-01', '2017-11-03', 'shijie@gmail.com', 'tianyu@tools4rent.com', 'feng@tools4rent.com'),
(13, '2017-10-05', '2017-10-06', 'shijie@gmail.com', 'tianyu@tools4rent.com', 'feng@tools4rent.com'),
(14, '2017-10-18', '2017-10-27', 'shijie@gmail.com', 'feng@tools4rent.com', 'shijie@tools4rent.com'),
(15, '2017-11-01', '2017-11-08', 'tianyu@gmail.com', 'hongyu@tools4rent.com', 'tianyu@tools4rent.com'),
(16, '2017-11-25', '2017-11-28', 'tianyu@gmail.com', 'hongyu@tools4rent.com', 'tianyu@tools4rent.com'),
(17, '2017-11-16', '2017-11-28', 'tianyu@gmail.com', 'shijie@tools4rent.com', 'shijie@tools4rent.com');

-- --------------------------------------------------------

--
-- Table structure for table `ReservationTool`
--

CREATE TABLE `ReservationTool` (
	  `reservation_id` int(16) UNSIGNED NOT NULL,
	  `tool_id` int(16) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ReservationTool`
--

INSERT INTO `ReservationTool` (`reservation_id`, `tool_id`) VALUES
(1, 1),
(2, 1),
(6, 1),
(1, 2),
(2, 2),
(4, 3),
(7, 3),
(4, 4),
(6, 4),
(13, 4),
(5, 5),
(7, 5),
(10, 5),
(5, 6),
(13, 6),
(14, 6),
(15, 6),
(5, 7),
(12, 7),
(14, 7),
(5, 8),
(7, 8),
(10, 8),
(12, 8),
(11, 9),
(13, 9),
(10, 10),
(12, 10),
(16, 10),
(10, 11),
(15, 11),
(17, 11),
(9, 12),
(6, 13),
(8, 13),
(11, 13),
(13, 13),
(9, 14),
(14, 14),
(9, 15),
(14, 15),
(17, 16),
(3, 17),
(17, 17),
(3, 18),
(16, 18),
(3, 19),
(16, 19),
(3, 20),
(3, 21),
(3, 22),
(17, 22),
(3, 23),
(3, 25),
(8, 25),
(3, 26),
(6, 26),
(8, 26),
(3, 27);

-- --------------------------------------------------------

--
-- Table structure for table `Sander`
--

CREATE TABLE `Sander` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `dust_bag` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Sander`
--

INSERT INTO `Sander` (`tool_id`, `dust_bag`) VALUES
(19, 'True'),
(24, 'True');

-- --------------------------------------------------------

--
-- Table structure for table `Saw`
--

CREATE TABLE `Saw` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `blade_size` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Saw`
--

INSERT INTO `Saw` (`tool_id`, `blade_size`) VALUES
(2, '3.375'),
(18, '4.375'),
(23, '2.125');

-- --------------------------------------------------------

--
-- Table structure for table `Screwdriver`
--

CREATE TABLE `Screwdriver` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `screw_size` int(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Screwdriver`
--

INSERT INTO `Screwdriver` (`tool_id`, `screw_size`) VALUES
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `Service`
--

CREATE TABLE `Service` (
	  `service_id` int(16) UNSIGNED NOT NULL,
	  `start_date` date NOT NULL,
	  `end_date` date NOT NULL,
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `request_clerk_username` varchar(50) NOT NULL,
	  `repair_cost` decimal(10,2) DEFAULT NULL,
	  `fix_now` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Socket`
--

CREATE TABLE `Socket` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `drive_size` decimal(10,3) NOT NULL,
	  `sae_size` decimal(10,3) NOT NULL,
	  `deepsockect` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Socket`
--

INSERT INTO `Socket` (`tool_id`, `drive_size`, `sae_size`, `deepsockect`) VALUES
(3, '0.375', '0.500', 'True');

-- --------------------------------------------------------

--
-- Table structure for table `Step`
--

CREATE TABLE `Step` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `pail_shelf` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Step`
--

INSERT INTO `Step` (`tool_id`, `pail_shelf`) VALUES
(15, 'True');

-- --------------------------------------------------------

--
-- Table structure for table `Straight`
--

CREATE TABLE `Straight` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `rubber_feet` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Straight`
--

INSERT INTO `Straight` (`tool_id`, `rubber_feet`) VALUES
(16, '');

-- --------------------------------------------------------

--
-- Table structure for table `Striking`
--

CREATE TABLE `Striking` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `head_weight` decimal(10,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Striking`
--

INSERT INTO `Striking` (`tool_id`, `head_weight`) VALUES
(14, '23.1');

-- --------------------------------------------------------

--
-- Table structure for table `TooForSale`
--

CREATE TABLE `TooForSale` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `marked_clerk_name` varchar(50) NOT NULL,
	  `purchase_id` int(16) DEFAULT NULL,
	  `sale_id` int(16) UNSIGNED NOT NULL,
	  `sale_price` decimal(10,2) DEFAULT NULL,
	  `for_sale_date` date NOT NULL,
	  `sale_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Tool`
--

CREATE TABLE `Tool` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `type` varchar(20) NOT NULL,
	  `power_source` varchar(20) NOT NULL,
	  `sub_type` varchar(50) NOT NULL,
	  `sub_option` varchar(50) NOT NULL,
	  `width` decimal(10,3) NOT NULL,
	  `length` decimal(10,3) NOT NULL,
	  `weight` decimal(10,2) NOT NULL,
	  `manufacturer` varchar(50) NOT NULL,
	  `material` varchar(50) DEFAULT NULL,
	  `purchase_price` decimal(10,2) DEFAULT NULL,
	  `current_status` varchar(20) NOT NULL,
	  `rental_times` int(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Tool`
--

INSERT INTO `Tool` (`tool_id`, `type`, `power_source`, `sub_type`, `sub_option`, `width`, `length`, `weight`, `manufacturer`, `material`, `purchase_price`, `current_status`, `rental_times`) VALUES
(1, 'Hand', 'manual', 'Screwdriver', 'philips', '13.500', '13.500', '13.00', 'Philips', 'Iron', '11.00', '', 0),
(2, 'Power', 'DC', 'Saw', 'circular', '12.250', '39.000', '13.00', 'SawIron', 'Iron', '131.00', '', 0),
(3, 'Hand', 'manual', 'Socket', 'deep', '1.250', '2.000', '0.77', 'SocketBig', 'Copper', '14.00', '', 0),
(4, 'Hand', 'manual', 'Ratchet', 'adjustable', '11.125', '40.500', '13.00', 'Iron', 'Iron', '15.00', '', 0),
(5, 'Hand', 'manual', 'Pliers', 'needle', '3.375', '49.500', '11.00', '2', 'Iron', '13.00', '', 0),
(6, 'Hand', 'manual', 'Wrench', 'cresent', '12.125', '4.125', '13.00', 'WrenchSuper', 'Iron', '4.52', '', 0),
(7, 'Hand', 'manual', 'Pliers', 'needle', '31.250', '21.375', '12.00', 'PliersBig', 'Copper', '13.00', '', 0),
(8, 'Hand', 'manual', 'Gun', 'staple', '12.250', '32.375', '11.00', 'Iron', 'Copper', '19.07', '', 0),
(9, 'Hand', 'manual', 'Hammer', 'sledge', '4.250', '5.250', '21.00', 'HammerSupper', 'Copper', '31.47', '', 0),
(10, 'Garden', 'manual', 'Digger', 'faltshovel', '159.000', '13.375', '21.00', 'Iron', 'Iron', '23.00', '', 0),
(11, 'Garden', 'manual', 'Pruner', 'sheer', '13.375', '2.375', '13.00', 'PrunerSuper', 'Copper', '13.89', '', 0),
(12, 'Garden', 'manual', 'Rakes', 'rock', '13.375', '21.250', '31.00', 'Rakeeees', 'Iron', '31.45', '', 0),
(13, 'Garden', 'manual', 'Wheelbarrows', '1wheel', '27.000', '5.125', '13.10', 'Iron', 'Metal', '18.01', '', 0),
(14, 'Garden', 'manual', 'Striking', 'barpry', '2.250', '34.375', '13.00', 'Striking!!', 'Iron', '131.23', '', 0),
(15, 'Ladder', 'manual', 'Step', 'folding', '3.125', '4.500', '3.10', 'Ladder!', 'Tree', '41.00', '', 0),
(16, 'Ladder', 'manual', 'Straight', 'rigid', '4.125', '87.000', '2.10', 'Ladder_myself!', 'Wood', '21.42', '', 0),
(17, 'Power', 'AC', 'Drill', 'driver', '13.125', '14.375', '21.00', 'Iron', 'Mtal', '31.00', '', 0),
(18, 'Power', 'AC', 'Saw', 'reciprocating', '13.375', '31.250', '12.00', '3', 'Iron', '13.00', '', 0),
(19, 'Power', 'AC', 'Sander', 'sheet', '39.000', '4.500', '13.00', 'Sanderbyme', 'Iron', '31.00', '', 0),
(20, 'Power', 'AC', 'AirCompressor', 'reciprocating', '43.500', '25.500', '21.00', 'Iron', 'Metal', '31.00', '', 0),
(21, 'Power', 'AC', 'Mixer', 'concrete', '160.500', '41.500', '11.00', 'Menufactory', '23', '10.28', '', 0),
(22, 'Power', 'DC', 'Drill', 'driver', '3.250', '1.375', '11.00', 'DrillDC', 'Plastic', '10.22', '', 0),
(23, 'Power', 'DC', 'Saw', 'circular', '3.125', '1.375', '0.40', 'Sanderbyme', 'Plastic', '30.01', '', 0),
(24, 'Power', 'DC', 'Sander', 'sheet', '4.375', '5.250', '13.00', 'SuperSander', 'Copper', '51.01', '', 0),
(25, 'Power', 'Gaspower', 'AirCompressor', 'reciprocating', '3.125', '51.000', '1.00', 'HumanLife', 'Plastic', '31.00', '', 0),
(26, 'Power', 'Gaspower', 'Mixer', 'concrete', '3.250', '4.125', '3.10', 'Mixer', 'Mixer', '31.00', '', 0),
(27, 'Power', 'Gaspower', 'Generator', 'electric', '13.125', '31.125', '31.00', 'Generator', '', '103.00', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `Wheelbarrows`
--

CREATE TABLE `Wheelbarrows` (
	  `tool_id` int(16) UNSIGNED NOT NULL,
	  `bin_material` varchar(50) NOT NULL,
	  `bin_volume` decimal(10,1) DEFAULT NULL,
	  `wheel_count` int(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Wheelbarrows`
--

INSERT INTO `Wheelbarrows` (`tool_id`, `bin_material`, `bin_volume`, `wheel_count`) VALUES
(13, 'Nick', '31.0', 3);

-- --------------------------------------------------------

--
-- Table structure for table `Wrench`
--

CREATE TABLE `Wrench` (
	  `tool_id` int(16) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Wrench`
--

INSERT INTO `Wrench` (`tool_id`) VALUES
(6);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Accessory`
--
ALTER TABLE `Accessory`
  ADD PRIMARY KEY (`accessory_description`);

--
-- Indexes for table `AirCompressor`
--
ALTER TABLE `AirCompressor`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Clerk`
--
ALTER TABLE `Clerk`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `clerk_id` (`clerk_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `Customer`
--
ALTER TABLE `Customer`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `customer_id` (`customer_id`);

--
-- Indexes for table `Digger`
--
ALTER TABLE `Digger`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Drill`
--
ALTER TABLE `Drill`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Garden`
--
ALTER TABLE `Garden`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Generator`
--
ALTER TABLE `Generator`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Gun`
--
ALTER TABLE `Gun`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Hammer`
--
ALTER TABLE `Hammer`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Hand`
--
ALTER TABLE `Hand`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Ladder`
--
ALTER TABLE `Ladder`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Mixer`
--
ALTER TABLE `Mixer`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Pair`
--
ALTER TABLE `Pair`
  ADD PRIMARY KEY (`tool_id`,`accessory_quantity`,`accessory_description`),
  ADD KEY `pair_ibfk_2` (`accessory_description`);

--
-- Indexes for table `Pliers`
--
ALTER TABLE `Pliers`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Power`
--
ALTER TABLE `Power`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Pruner`
--
ALTER TABLE `Pruner`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Purchase`
--
ALTER TABLE `Purchase`
  ADD PRIMARY KEY (`purchase_id`,`customer_username`),
  ADD KEY `customer_username` (`customer_username`);

--
-- Indexes for table `Rakes`
--
ALTER TABLE `Rakes`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Ratchet`
--
ALTER TABLE `Ratchet`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Reservation`
--
ALTER TABLE `Reservation`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `reservation_ibfk_1` (`customer_username`),
  ADD KEY `reservation_ibfk_2` (`pickup_clerk`),
  ADD KEY `reservation_ibfk_3` (`dropoff_clerk`);

--
-- Indexes for table `ReservationTool`
--
ALTER TABLE `ReservationTool`
  ADD PRIMARY KEY (`reservation_id`,`tool_id`),
  ADD KEY `tool_id` (`tool_id`);

--
-- Indexes for table `Sander`
--
ALTER TABLE `Sander`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Saw`
--
ALTER TABLE `Saw`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Screwdriver`
--
ALTER TABLE `Screwdriver`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Service`
--
ALTER TABLE `Service`
  ADD PRIMARY KEY (`service_id`),
  ADD KEY `tool_id` (`tool_id`),
  ADD KEY `request_clerk_username` (`request_clerk_username`);

--
-- Indexes for table `Socket`
--
ALTER TABLE `Socket`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Step`
--
ALTER TABLE `Step`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Straight`
--
ALTER TABLE `Straight`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Striking`
--
ALTER TABLE `Striking`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `TooForSale`
--
ALTER TABLE `TooForSale`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `tool_id` (`tool_id`),
  ADD KEY `marked_clerk_name` (`marked_clerk_name`);

--
-- Indexes for table `Tool`
--
ALTER TABLE `Tool`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Wheelbarrows`
--
ALTER TABLE `Wheelbarrows`
  ADD PRIMARY KEY (`tool_id`);

--
-- Indexes for table `Wrench`
--
ALTER TABLE `Wrench`
  ADD PRIMARY KEY (`tool_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Clerk`
--
ALTER TABLE `Clerk`
  MODIFY `clerk_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `Customer`
--
ALTER TABLE `Customer`
  MODIFY `customer_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `Purchase`
--
ALTER TABLE `Purchase`
  MODIFY `purchase_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `Reservation`
--
ALTER TABLE `Reservation`
  MODIFY `reservation_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `Service`
--
ALTER TABLE `Service`
  MODIFY `service_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `TooForSale`
--
ALTER TABLE `TooForSale`
  MODIFY `sale_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `Tool`
--
ALTER TABLE `Tool`
  MODIFY `tool_id` int(16) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `AirCompressor`
--
ALTER TABLE `AirCompressor`
  ADD CONSTRAINT `aircompressor_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Digger`
--
ALTER TABLE `Digger`
  ADD CONSTRAINT `digger_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Garden` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Drill`
--
ALTER TABLE `Drill`
  ADD CONSTRAINT `drill_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Garden`
--
ALTER TABLE `Garden`
  ADD CONSTRAINT `garden_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Generator`
--
ALTER TABLE `Generator`
  ADD CONSTRAINT `generator_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Gun`
--
ALTER TABLE `Gun`
  ADD CONSTRAINT `gun_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Hammer`
--
ALTER TABLE `Hammer`
  ADD CONSTRAINT `hammer_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Hand`
--
ALTER TABLE `Hand`
  ADD CONSTRAINT `hand_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Ladder`
--
ALTER TABLE `Ladder`
  ADD CONSTRAINT `ladder_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Mixer`
--
ALTER TABLE `Mixer`
  ADD CONSTRAINT `mixer_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Pair`
--
ALTER TABLE `Pair`
  ADD CONSTRAINT `pair_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pair_ibfk_2` FOREIGN KEY (`accessory_description`) REFERENCES `Accessory` (`accessory_description`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Pliers`
--
ALTER TABLE `Pliers`
  ADD CONSTRAINT `pliers_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Power`
--
ALTER TABLE `Power`
  ADD CONSTRAINT `power_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Pruner`
--
ALTER TABLE `Pruner`
  ADD CONSTRAINT `pruner_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Garden` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Purchase`
--
ALTER TABLE `Purchase`
  ADD CONSTRAINT `purchase_ibfk_1` FOREIGN KEY (`customer_username`) REFERENCES `Customer` (`username`);

--
-- Constraints for table `Rakes`
--
ALTER TABLE `Rakes`
  ADD CONSTRAINT `rakes_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Garden` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Ratchet`
--
ALTER TABLE `Ratchet`
  ADD CONSTRAINT `ratchet_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Reservation`
--
ALTER TABLE `Reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`customer_username`) REFERENCES `Customer` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`pickup_clerk`) REFERENCES `Clerk` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`dropoff_clerk`) REFERENCES `Clerk` (`username`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ReservationTool`
--
ALTER TABLE `ReservationTool`
  ADD CONSTRAINT `reservationtool_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `Reservation` (`reservation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservationtool_ibfk_2` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Sander`
--
ALTER TABLE `Sander`
  ADD CONSTRAINT `sander_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Saw`
--
ALTER TABLE `Saw`
  ADD CONSTRAINT `saw_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Power` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Screwdriver`
--
ALTER TABLE `Screwdriver`
  ADD CONSTRAINT `screwdriver_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Service`
--
ALTER TABLE `Service`
  ADD CONSTRAINT `service_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_ibfk_2` FOREIGN KEY (`request_clerk_username`) REFERENCES `Clerk` (`username`);

--
-- Constraints for table `Socket`
--
ALTER TABLE `Socket`
  ADD CONSTRAINT `socket_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Step`
--
ALTER TABLE `Step`
  ADD CONSTRAINT `step_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Ladder` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Straight`
--
ALTER TABLE `Straight`
  ADD CONSTRAINT `straight_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Ladder` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Striking`
--
ALTER TABLE `Striking`
  ADD CONSTRAINT `striking_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Garden` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `TooForSale`
--
ALTER TABLE `TooForSale`
  ADD CONSTRAINT `tooforsale_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Tool` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tooforsale_ibfk_2` FOREIGN KEY (`marked_clerk_name`) REFERENCES `Clerk` (`username`);

--
-- Constraints for table `Wheelbarrows`
--
ALTER TABLE `Wheelbarrows`
  ADD CONSTRAINT `wheelbarrows_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Garden` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Wrench`
--
ALTER TABLE `Wrench`
  ADD CONSTRAINT `wrench_ibfk_1` FOREIGN KEY (`tool_id`) REFERENCES `Hand` (`tool_id`) ON DELETE CASCADE ON UPDATE CASCADE;

