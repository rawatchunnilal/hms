-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 06, 2024 at 11:19 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hms`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAllotedTable` (IN `new_allotment_id` INT, IN `student_en` VARCHAR(255))   BEGIN
    IF new_allotment_id IS NULL THEN
        -- If the new allotment_id is NULL, update student_id to NULL
        UPDATE alloted
        SET student_id = NULL
        WHERE student_id = student_en;
    ELSE
        -- If the new allotment_id is not NULL, update student_id to the new value
        UPDATE alloted
        SET student_id = student_en
        WHERE allotment_id = new_allotment_id
        limit 1;

        -- Update the status for the new room
        CALL UpdateRoomStatus(new_allotment_id);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateRoomStatus` (IN `p_allotment_id` INT)   BEGIN
    DECLARE v_current_occupancy INT;
    DECLARE v_capacity INT;
    
    -- Get the capacity of the room
    SELECT `capacity` INTO v_capacity
    FROM `room`
    WHERE `room_id` = (SELECT `room_id` FROM `alloted` WHERE `allotment_id` = p_allotment_id);
    
    -- Get the current occupancy of the room
    SELECT COALESCE(COUNT(`student_id`), 0) INTO v_current_occupancy
    FROM `alloted`
    WHERE `room_id` = (SELECT `room_id` FROM `alloted` WHERE `allotment_id` = p_allotment_id);
    
    -- Update the room status
    IF v_current_occupancy >= v_capacity THEN
        UPDATE `room`
        SET `status` = 'not vacant'
        WHERE `room_id` = (SELECT `room_id` FROM `alloted` WHERE `allotment_id` = p_allotment_id);
    ELSE
        UPDATE `room`
        SET `status` = 'vacant'
        WHERE `room_id` = (SELECT `room_id` FROM `alloted` WHERE `allotment_id` = p_allotment_id);
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `alloted`
--

CREATE TABLE `alloted` (
  `allotment_id` int(11) NOT NULL,
  `student_id` varchar(11) DEFAULT NULL,
  `furniture_id_1` int(10) UNSIGNED NOT NULL,
  `furniture_id_2` int(10) UNSIGNED NOT NULL,
  `furniture_id_3` int(10) UNSIGNED NOT NULL,
  `room_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alloted`
--

INSERT INTO `alloted` (`allotment_id`, `student_id`, `furniture_id_1`, `furniture_id_2`, `furniture_id_3`, `room_id`) VALUES
(1, 'EN123456789', 1, 2, 3, 1),
(2, 'EN21107546', 4, 5, 6, 1),
(3, 'EN21107538 ', 7, 8, 9, 2),
(4, NULL, 10, 11, 12, 2),
(5, NULL, 13, 14, 15, 3),
(6, NULL, 16, 17, 18, 3),
(7, NULL, 19, 20, 21, 4),
(8, NULL, 22, 23, 24, 4),
(9, NULL, 25, 26, 27, 5),
(10, NULL, 28, 29, 30, 5),
(11, 'EN21107546', 31, 32, 33, 6),
(12, 'EN21107546', 34, 35, 36, 6),
(13, NULL, 37, 38, 39, 7),
(14, NULL, 40, 41, 42, 7),
(15, NULL, 43, 44, 45, 8),
(16, NULL, 46, 47, 48, 8),
(17, NULL, 49, 50, 51, 9),
(18, NULL, 52, 53, 54, 9),
(19, NULL, 55, 56, 57, 10),
(20, NULL, 58, 59, 60, 10),
(21, NULL, 61, 62, 63, 11),
(22, NULL, 64, 65, 66, 11),
(23, NULL, 67, 68, 69, 12),
(24, NULL, 70, 71, 72, 12),
(25, NULL, 73, 74, 75, 13),
(26, NULL, 76, 77, 78, 13),
(27, NULL, 79, 80, 81, 14),
(28, NULL, 82, 83, 84, 14),
(29, NULL, 85, 86, 87, 15),
(30, NULL, 88, 89, 90, 15),
(31, NULL, 91, 92, 93, 16),
(32, NULL, 94, 95, 96, 16),
(33, NULL, 97, 98, 99, 17),
(34, NULL, 100, 101, 102, 17),
(35, NULL, 103, 104, 105, 18),
(36, NULL, 106, 107, 108, 18),
(37, NULL, 109, 110, 111, 19),
(38, NULL, 112, 113, 114, 19),
(39, NULL, 115, 116, 117, 20),
(40, NULL, 118, 119, 120, 20),
(41, NULL, 121, 122, 123, 21),
(42, NULL, 124, 125, 126, 21),
(43, NULL, 127, 128, 129, 22),
(44, NULL, 130, 131, 132, 22),
(45, NULL, 133, 134, 135, 23),
(46, NULL, 136, 137, 138, 23),
(47, NULL, 139, 140, 141, 24),
(48, NULL, 142, 143, 144, 24),
(49, NULL, 145, 146, 147, 25),
(50, NULL, 148, 149, 150, 25),
(51, NULL, 151, 152, 153, 26),
(52, NULL, 154, 155, 156, 26),
(53, NULL, 157, 158, 159, 27),
(54, NULL, 160, 161, 162, 27),
(55, NULL, 163, 164, 165, 28),
(56, NULL, 166, 167, 168, 28),
(57, NULL, 169, 170, 171, 29),
(58, NULL, 172, 173, 174, 29),
(59, NULL, 175, 176, 177, 30),
(60, NULL, 178, 179, 180, 30),
(61, NULL, 181, 182, 183, 31),
(62, NULL, 184, 185, 186, 31),
(63, NULL, 187, 188, 189, 32),
(64, NULL, 190, 191, 192, 32),
(65, NULL, 193, 194, 195, 33),
(66, NULL, 196, 197, 198, 33),
(67, NULL, 199, 200, 201, 34),
(68, NULL, 202, 203, 204, 34),
(69, NULL, 205, 206, 207, 35),
(70, NULL, 208, 209, 210, 35),
(71, NULL, 211, 212, 213, 36),
(72, NULL, 214, 215, 216, 36),
(73, NULL, 217, 218, 219, 37),
(74, NULL, 220, 221, 222, 37),
(75, NULL, 223, 224, 225, 38),
(76, NULL, 226, 227, 228, 38),
(77, NULL, 229, 230, 231, 39),
(78, NULL, 232, 233, 234, 39),
(79, NULL, 235, 236, 237, 40),
(80, NULL, 238, 239, 240, 40),
(81, NULL, 241, 242, 243, 41),
(82, NULL, 244, 245, 246, 41),
(83, NULL, 247, 248, 249, 42),
(84, NULL, 250, 251, 252, 42),
(85, NULL, 253, 254, 255, 43),
(86, NULL, 256, 257, 258, 43),
(87, NULL, 259, 260, 261, 44),
(88, NULL, 262, 263, 264, 44),
(89, NULL, 265, 266, 267, 45),
(90, NULL, 268, 269, 270, 45),
(91, NULL, 271, 272, 273, 46),
(92, NULL, 274, 275, 276, 46),
(93, NULL, 277, 278, 279, 47),
(94, NULL, 280, 281, 282, 47),
(95, NULL, 283, 284, 285, 48),
(96, NULL, 286, 287, 288, 48),
(97, NULL, 289, 290, 291, 49),
(98, NULL, 292, 293, 294, 49),
(99, NULL, 295, 296, 297, 50),
(100, NULL, 298, 299, 300, 50),
(101, NULL, 301, 302, 303, 51),
(102, NULL, 304, 305, 306, 51),
(103, NULL, 307, 308, 309, 52),
(104, NULL, 310, 311, 312, 52),
(105, NULL, 313, 314, 315, 53),
(106, NULL, 316, 317, 318, 53),
(107, NULL, 319, 320, 321, 54),
(108, NULL, 322, 323, 324, 54),
(109, NULL, 325, 326, 327, 55),
(110, NULL, 328, 329, 330, 55),
(111, NULL, 331, 332, 333, 56),
(112, NULL, 334, 335, 336, 56),
(113, NULL, 337, 338, 339, 57),
(114, NULL, 340, 341, 342, 57),
(115, NULL, 343, 344, 345, 58),
(116, NULL, 346, 347, 348, 58),
(117, NULL, 349, 350, 351, 59),
(118, NULL, 352, 353, 354, 59),
(119, NULL, 355, 356, 357, 60),
(120, NULL, 358, 359, 360, 60),
(121, NULL, 361, 362, 363, 61),
(122, NULL, 364, 365, 366, 61),
(123, NULL, 367, 368, 369, 62),
(124, NULL, 370, 371, 372, 62),
(125, NULL, 373, 374, 375, 63),
(126, NULL, 376, 377, 378, 63),
(127, NULL, 379, 380, 381, 64),
(128, NULL, 382, 383, 384, 64),
(129, NULL, 385, 386, 387, 65),
(130, NULL, 388, 389, 390, 65),
(131, NULL, 391, 392, 393, 66),
(132, NULL, 394, 395, 396, 66),
(133, NULL, 397, 398, 399, 67),
(134, NULL, 400, 401, 402, 67),
(135, NULL, 403, 404, 405, 68),
(136, NULL, 406, 407, 408, 68),
(137, NULL, 409, 410, 411, 69),
(138, NULL, 412, 413, 414, 69),
(139, NULL, 415, 416, 417, 70),
(140, NULL, 418, 419, 420, 70),
(141, NULL, 421, 422, 423, 71),
(142, NULL, 424, 425, 426, 71),
(143, NULL, 427, 428, 429, 72),
(144, NULL, 430, 431, 432, 72),
(145, NULL, 433, 434, 435, 73),
(146, NULL, 436, 437, 438, 73),
(147, NULL, 439, 440, 441, 74),
(148, NULL, 442, 443, 444, 74),
(149, NULL, 445, 446, 447, 75),
(150, NULL, 448, 449, 450, 75),
(151, NULL, 451, 452, 453, 76),
(152, NULL, 454, 455, 456, 76),
(153, NULL, 457, 458, 459, 77),
(154, NULL, 460, 461, 462, 77),
(155, NULL, 463, 464, 465, 78),
(156, NULL, 466, 467, 468, 78),
(157, NULL, 469, 470, 471, 79),
(158, NULL, 472, 473, 474, 79),
(159, NULL, 475, 476, 477, 80),
(160, NULL, 478, 479, 480, 80),
(161, NULL, 481, 482, 483, 81),
(162, NULL, 484, 485, 486, 81),
(163, NULL, 487, 488, 489, 82),
(164, NULL, 490, 491, 492, 82),
(165, NULL, 493, 494, 495, 83),
(166, NULL, 496, 497, 498, 83),
(167, NULL, 499, 500, 501, 84),
(168, NULL, 502, 503, 504, 84),
(169, NULL, 505, 506, 507, 85),
(170, NULL, 508, 509, 510, 85),
(171, NULL, 511, 512, 513, 86),
(172, NULL, 514, 515, 516, 86),
(173, NULL, 517, 518, 519, 87),
(174, NULL, 520, 521, 522, 87),
(175, NULL, 523, 524, 525, 88),
(176, NULL, 526, 527, 528, 88),
(177, NULL, 529, 530, 531, 89),
(178, NULL, 532, 533, 534, 89),
(179, NULL, 535, 536, 537, 90),
(180, NULL, 538, 539, 540, 90),
(181, NULL, 541, 542, 543, 91),
(182, NULL, 544, 545, 546, 91),
(183, NULL, 547, 548, 549, 92),
(184, NULL, 550, 551, 552, 92),
(185, NULL, 553, 554, 555, 93),
(186, NULL, 556, 557, 558, 93),
(187, NULL, 559, 560, 561, 94),
(188, NULL, 562, 563, 564, 94),
(189, NULL, 565, 566, 567, 95),
(190, NULL, 568, 569, 570, 95),
(191, NULL, 571, 572, 573, 96),
(192, NULL, 574, 575, 576, 96),
(193, NULL, 577, 578, 579, 97),
(194, NULL, 580, 581, 582, 97),
(195, NULL, 583, 584, 585, 98),
(196, NULL, 586, 587, 588, 98),
(197, NULL, 589, 590, 591, 99),
(198, NULL, 592, 593, 594, 99),
(199, NULL, 595, 596, 597, 100),
(200, NULL, 598, 599, 600, 100),
(201, NULL, 601, 602, 603, 101),
(202, NULL, 604, 605, 606, 101),
(203, NULL, 607, 608, 609, 102),
(204, NULL, 610, 611, 612, 102),
(205, NULL, 613, 614, 615, 103),
(206, NULL, 616, 617, 618, 103),
(207, NULL, 619, 620, 621, 104),
(208, NULL, 622, 623, 624, 104),
(209, NULL, 625, 626, 627, 105),
(210, NULL, 628, 629, 630, 105),
(211, NULL, 631, 632, 633, 106),
(212, NULL, 634, 635, 636, 106),
(213, NULL, 637, 638, 639, 107),
(214, NULL, 640, 641, 642, 107),
(215, NULL, 643, 644, 645, 108),
(216, NULL, 646, 647, 648, 108),
(217, NULL, 649, 650, 651, 109),
(218, NULL, 652, 653, 654, 109),
(219, NULL, 655, 656, 657, 110),
(220, NULL, 658, 659, 660, 110),
(221, NULL, 661, 662, 663, 111),
(222, NULL, 664, 665, 666, 111),
(223, NULL, 667, 668, 669, 112),
(224, NULL, 670, 671, 672, 112),
(225, NULL, 673, 674, 675, 113),
(226, NULL, 676, 677, 678, 113),
(227, NULL, 679, 680, 681, 114),
(228, NULL, 682, 683, 684, 114),
(229, NULL, 685, 686, 687, 115),
(230, NULL, 688, 689, 690, 115),
(231, NULL, 691, 692, 693, 116),
(232, NULL, 694, 695, 696, 116),
(233, NULL, 697, 698, 699, 117),
(234, NULL, 700, 701, 702, 117),
(235, NULL, 703, 704, 705, 118),
(236, NULL, 706, 707, 708, 118),
(237, NULL, 709, 710, 711, 119),
(238, NULL, 712, 713, 714, 119),
(239, NULL, 715, 716, 717, 120),
(240, NULL, 718, 719, 720, 120);

-- --------------------------------------------------------

--
-- Table structure for table `attendance_files`
--

CREATE TABLE `attendance_files` (
  `year` int(4) NOT NULL,
  `month` enum('January','February','March','April','May','June','July','August','September','October','November','December') NOT NULL,
  `Date_and_time_of_upload` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `hostel` enum('Boys','Girls') NOT NULL,
  `file` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_files`
--

INSERT INTO `attendance_files` (`year`, `month`, `Date_and_time_of_upload`, `hostel`, `file`) VALUES
(2024, 'February', '2024-05-26 04:48:44', '', '../../Attendance/candidates.csv'),
(2024, 'February', '2024-05-26 05:25:21', '', '../../Attendance/candidates.csv'),
(2024, 'August', '2024-05-26 05:26:12', '', '../../Attendance/candidates.csv'),
(2024, 'January', '2024-05-28 04:43:06', '', '../../Attendance/contacts.csv'),
(2024, 'August', '2024-05-30 06:34:27', '', '../../Attendance/student_attendance.csv'),
(2024, 'November', '2024-05-30 06:37:06', '', '../../Attendance/student_attendance.csv');

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `Application_ID` varchar(20) NOT NULL,
  `Candidate_Name` varchar(60) DEFAULT NULL,
  `Father_Name` varchar(20) DEFAULT NULL,
  `Mobile_No` decimal(10,0) DEFAULT NULL,
  `E_Mail_ID` varchar(100) DEFAULT NULL,
  `Category` enum('General','OBC','SC','ST') DEFAULT NULL,
  `Course_Name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`Application_ID`, `Candidate_Name`, `Father_Name`, `Mobile_No`, `E_Mail_ID`, `Category`, `Course_Name`) VALUES
('EN21107534', 'ADSOD OM ANANT', 'ANANT', 7620186474, 'omadsod831@gmail.com', 'OBC', 'Civil Engineering'),
('EN21107535', 'RAVI SHANKAR YADAV', 'HARI SHANKAR', 2216241234, 'raviyadav123@gmail.com', 'SC', 'Computer Science Engineering'),
('EN21107536', 'ANJALI KUMARI', 'RAJESH YADAV', 9876543210, 'anjali.kumari@example.com', 'General', 'Electrical Engineering'),
('EN21107537', 'RAVI KUMAR', 'YOGESH KUMAR', 8765432109, 'ravikumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107538', 'ANSHIKA SHARMA', 'VIKAS SHARMA', 7654321098, 'anshika.sharma@example.com', 'General', 'Information Technology'),
('EN21107539', 'RITU KUMARI', 'RAJESH KUMAR', 6543210987, 'ritu.kumari@example.com', 'SC', 'Civil Engineering'),
('EN21107540', 'ANURAG KUMAR', 'RAJESH KUMAR', 5432109876, 'anurag.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107541', 'KAVITA SHARMA', 'VIKAS SHARMA', 4321098765, 'kavita.sharma@example.com', 'General', 'Electrical Engineering'),
('EN21107542', 'RAMESH KUMAR', 'RAJESH KUMAR', 3210987654, 'ramesh.kumar@example.com', 'SC', 'Information Technology'),
('EN21107543', 'SUNITA DEVI', 'SURESH KUMAR', 2109876543, 'sunita.devi@example.com', 'OBC', 'Civil Engineering'),
('EN21107544', 'MEENA KUMARI', 'RAJESH KUMAR', 1098765432, 'meena.kumari@example.com', 'General', 'Mechanical Engineering'),
('EN21107545', 'SANJAY YADAV', 'RAJESH YADAV', 1098765432, 'sanjay.yadav@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107546', 'RAJESH KUMAR', 'RAJESH KUMAR', 2109876543, 'rajesh.kumar@example.com', 'SC', 'Electrical Engineering'),
('EN21107547', 'ANIL KUMAR', 'RAJESH KUMAR', 3210987654, 'anil.kumar@example.com', 'General', 'Information Technology'),
('EN21107548', 'GEETA DEVI', 'SURESH KUMAR', 4321098765, 'geeta.devi@example.com', 'SC', 'Civil Engineering'),
('EN21107549', 'VIKAS KUMAR', 'RAJESH KUMAR', 5432109876, 'vikas.kumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107550', 'KAVITA SHARMA', 'VIKAS SHARMA', 6543210987, 'kavita.sharma@example.com', 'General', 'Computer Science Engineering'),
('EN21107551', 'RAHUL KUMAR', 'RAJESH KUMAR', 7654321098, 'rahul.kumar@example.com', 'SC', 'Electrical Engineering'),
('EN21107552', 'MEENU KUMARI', 'RAJESH KUMAR', 8765432109, 'meenu.kumari@example.com', 'OBC', 'Information Technology'),
('EN21107553', 'RAM KUMAR', 'RAJESH KUMAR', 9876543210, 'ram.kumar@example.com', 'General', 'Civil Engineering'),
('EN21107554', 'ANITA YADAV', 'RAJESH YADAV', 1234567890, 'anita.yadav@example.com', 'SC', 'Mechanical Engineering'),
('EN21107555', 'AMIT KUMAR', 'YOGESH KUMAR', 2345678901, 'amit.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107556', 'SUNITA KUMARI', 'SURESH KUMAR', 3456789012, 'sunita.kumari@example.com', 'General', 'Electrical Engineering'),
('EN21107557', 'SANTOSH YADAV', 'HARI SHANKAR', 4567890123, 'santosh.yadav@example.com', 'SC', 'Information Technology'),
('EN21107558', 'SHYAM KUMAR', 'YOGESH KUMAR', 5678901234, 'shyam.kumar@example.com', 'OBC', 'Civil Engineering'),
('EN21107559', 'MANISH KUMAR', 'RAJESH KUMAR', 6789012345, 'manish.kumar@example.com', 'General', 'Mechanical Engineering'),
('EN21107560', 'POOJA SHARMA', 'VIKAS SHARMA', 7890123456, 'pooja.sharma@example.com', 'SC', 'Computer Science Engineering'),
('EN21107561', 'ROHIT KUMAR', 'RAJESH KUMAR', 8901234567, 'rohit.kumar@example.com', 'OBC', 'Electrical Engineering'),
('EN21107562', 'MONIKA KUMARI', 'RAJESH KUMAR', 9012345678, 'monika.kumari@example.com', 'General', 'Information Technology'),
('EN21107563', 'MANOJ KUMAR', 'RAJESH KUMAR', 1234567890, 'manoj.kumar@example.com', 'SC', 'Civil Engineering'),
('EN21107564', 'KIRAN YADAV', 'RAJESH YADAV', 2345678901, 'kiran.yadav@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107565', 'RAJ KUMAR', 'RAJESH KUMAR', 3456789012, 'raj.kumar@example.com', 'General', 'Computer Science Engineering'),
('EN21107566', 'POOJA DEVI', 'SURESH KUMAR', 4567890123, 'pooja.devi@example.com', 'SC', 'Electrical Engineering'),
('EN21107567', 'RAMAN KUMAR', 'RAJESH KUMAR', 5678901234, 'raman.kumar@example.com', 'OBC', 'Information Technology'),
('EN21107568', 'NEHA SHARMA', 'VIKAS SHARMA', 6789012345, 'neha.sharma@example.com', 'General', 'Civil Engineering'),
('EN21107569', 'KARAN KUMAR', 'RAJESH KUMAR', 7890123456, 'karan.kumar@example.com', 'SC', 'Mechanical Engineering'),
('EN21107570', 'DEEPAK KUMAR', 'RAJESH KUMAR', 8901234567, 'deepak.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107571', 'ARTI SHARMA', 'VIKAS SHARMA', 9012345678, 'arti.sharma@example.com', 'General', 'Electrical Engineering'),
('EN21107572', 'ANUJ KUMAR', 'RAJESH KUMAR', 1234567890, 'anuj.kumar@example.com', 'SC', 'Information Technology'),
('EN21107573', 'RAMESH YADAV', 'RAJESH YADAV', 2345678901, 'ramesh.yadav@example.com', 'OBC', 'Civil Engineering'),
('EN21107574', 'KAVITA DEVI', 'SURESH KUMAR', 3456789012, 'kavita.devi@example.com', 'General', 'Mechanical Engineering'),
('EN21107575', 'SANJAY KUMAR', 'RAJESH KUMAR', 4567890123, 'sanjay.kumar@example.com', 'SC', 'Computer Science Engineering'),
('EN21107576', 'PRIYA SHARMA', 'VIKAS SHARMA', 5678901234, 'priya.sharma@example.com', 'OBC', 'Electrical Engineering'),
('EN21107577', 'RAJESH KUMAR', 'RAJESH KUMAR', 6789012345, 'rajesh.kumar@example.com', 'General', 'Information Technology'),
('EN21107578', 'GEETA KUMARI', 'SURESH KUMAR', 7890123456, 'geeta.kumari@example.com', 'SC', 'Civil Engineering'),
('EN21107579', 'VIJAY KUMAR', 'RAJESH KUMAR', 8901234567, 'vijay.kumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107580', 'KAVITA SHARMA', 'VIKAS SHARMA', 9012345678, 'kavita.sharma@example.com', 'General', 'Computer Science Engineering'),
('EN21107534', 'ADSOD OM ANANT', 'ANANT', 7620186474, 'omadsod831@gmail.com', 'OBC', 'Civil Engineering'),
('EN21107535', 'RAVI SHANKAR YADAV', 'HARI SHANKAR', 2216241234, 'raviyadav123@gmail.com', 'SC', 'Computer Science Engineering'),
('EN21107536', 'ANJALI KUMARI', 'RAJESH YADAV', 9876543210, 'anjali.kumari@example.com', 'General', 'Electrical Engineering'),
('EN21107537', 'RAVI KUMAR', 'YOGESH KUMAR', 8765432109, 'ravikumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107538', 'ANSHIKA SHARMA', 'VIKAS SHARMA', 7654321098, 'anshika.sharma@example.com', 'General', 'Information Technology'),
('EN21107539', 'RITU KUMARI', 'RAJESH KUMAR', 6543210987, 'ritu.kumari@example.com', 'SC', 'Civil Engineering'),
('EN21107540', 'ANURAG KUMAR', 'RAJESH KUMAR', 5432109876, 'anurag.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107541', 'KAVITA SHARMA', 'VIKAS SHARMA', 4321098765, 'kavita.sharma@example.com', 'General', 'Electrical Engineering'),
('EN21107542', 'RAMESH KUMAR', 'RAJESH KUMAR', 3210987654, 'ramesh.kumar@example.com', 'SC', 'Information Technology'),
('EN21107543', 'SUNITA DEVI', 'SURESH KUMAR', 2109876543, 'sunita.devi@example.com', 'OBC', 'Civil Engineering'),
('EN21107544', 'MEENA KUMARI', 'RAJESH KUMAR', 1098765432, 'meena.kumari@example.com', 'General', 'Mechanical Engineering'),
('EN21107545', 'SANJAY YADAV', 'RAJESH YADAV', 1098765432, 'sanjay.yadav@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107546', 'RAJESH KUMAR', 'RAJESH KUMAR', 2109876543, 'rajesh.kumar@example.com', 'SC', 'Electrical Engineering'),
('EN21107547', 'ANIL KUMAR', 'RAJESH KUMAR', 3210987654, 'anil.kumar@example.com', 'General', 'Information Technology'),
('EN21107548', 'GEETA DEVI', 'SURESH KUMAR', 4321098765, 'geeta.devi@example.com', 'SC', 'Civil Engineering'),
('EN21107549', 'VIKAS KUMAR', 'RAJESH KUMAR', 5432109876, 'vikas.kumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107550', 'KAVITA SHARMA', 'VIKAS SHARMA', 6543210987, 'kavita.sharma@example.com', 'General', 'Computer Science Engineering'),
('EN21107551', 'RAHUL KUMAR', 'RAJESH KUMAR', 7654321098, 'rahul.kumar@example.com', 'SC', 'Electrical Engineering'),
('EN21107552', 'MEENU KUMARI', 'RAJESH KUMAR', 8765432109, 'meenu.kumari@example.com', 'OBC', 'Information Technology'),
('EN21107553', 'RAM KUMAR', 'RAJESH KUMAR', 9876543210, 'ram.kumar@example.com', 'General', 'Civil Engineering'),
('EN21107554', 'ANITA YADAV', 'RAJESH YADAV', 1234567890, 'anita.yadav@example.com', 'SC', 'Mechanical Engineering'),
('EN21107555', 'AMIT KUMAR', 'YOGESH KUMAR', 2345678901, 'amit.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107556', 'SUNITA KUMARI', 'SURESH KUMAR', 3456789012, 'sunita.kumari@example.com', 'General', 'Electrical Engineering'),
('EN21107557', 'SANTOSH YADAV', 'HARI SHANKAR', 4567890123, 'santosh.yadav@example.com', 'SC', 'Information Technology'),
('EN21107558', 'SHYAM KUMAR', 'YOGESH KUMAR', 5678901234, 'shyam.kumar@example.com', 'OBC', 'Civil Engineering'),
('EN21107559', 'MANISH KUMAR', 'RAJESH KUMAR', 6789012345, 'manish.kumar@example.com', 'General', 'Mechanical Engineering'),
('EN21107560', 'POOJA SHARMA', 'VIKAS SHARMA', 7890123456, 'pooja.sharma@example.com', 'SC', 'Computer Science Engineering'),
('EN21107561', 'ROHIT KUMAR', 'RAJESH KUMAR', 8901234567, 'rohit.kumar@example.com', 'OBC', 'Electrical Engineering'),
('EN21107562', 'MONIKA KUMARI', 'RAJESH KUMAR', 9012345678, 'monika.kumari@example.com', 'General', 'Information Technology'),
('EN21107563', 'MANOJ KUMAR', 'RAJESH KUMAR', 1234567890, 'manoj.kumar@example.com', 'SC', 'Civil Engineering'),
('EN21107564', 'KIRAN YADAV', 'RAJESH YADAV', 2345678901, 'kiran.yadav@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107565', 'RAJ KUMAR', 'RAJESH KUMAR', 3456789012, 'raj.kumar@example.com', 'General', 'Computer Science Engineering'),
('EN21107566', 'POOJA DEVI', 'SURESH KUMAR', 4567890123, 'pooja.devi@example.com', 'SC', 'Electrical Engineering'),
('EN21107567', 'RAMAN KUMAR', 'RAJESH KUMAR', 5678901234, 'raman.kumar@example.com', 'OBC', 'Information Technology'),
('EN21107568', 'NEHA SHARMA', 'VIKAS SHARMA', 6789012345, 'neha.sharma@example.com', 'General', 'Civil Engineering'),
('EN21107569', 'KARAN KUMAR', 'RAJESH KUMAR', 7890123456, 'karan.kumar@example.com', 'SC', 'Mechanical Engineering'),
('EN21107570', 'DEEPAK KUMAR', 'RAJESH KUMAR', 8901234567, 'deepak.kumar@example.com', 'OBC', 'Computer Science Engineering'),
('EN21107571', 'ARTI SHARMA', 'VIKAS SHARMA', 9012345678, 'arti.sharma@example.com', 'General', 'Electrical Engineering'),
('EN21107572', 'ANUJ KUMAR', 'RAJESH KUMAR', 1234567890, 'anuj.kumar@example.com', 'SC', 'Information Technology'),
('EN21107573', 'RAMESH YADAV', 'RAJESH YADAV', 2345678901, 'ramesh.yadav@example.com', 'OBC', 'Civil Engineering'),
('EN21107574', 'KAVITA DEVI', 'SURESH KUMAR', 3456789012, 'kavita.devi@example.com', 'General', 'Mechanical Engineering'),
('EN21107575', 'SANJAY KUMAR', 'RAJESH KUMAR', 4567890123, 'sanjay.kumar@example.com', 'SC', 'Computer Science Engineering'),
('EN21107576', 'PRIYA SHARMA', 'VIKAS SHARMA', 5678901234, 'priya.sharma@example.com', 'OBC', 'Electrical Engineering'),
('EN21107577', 'RAJESH KUMAR', 'RAJESH KUMAR', 6789012345, 'rajesh.kumar@example.com', 'General', 'Information Technology'),
('EN21107578', 'GEETA KUMARI', 'SURESH KUMAR', 7890123456, 'geeta.kumari@example.com', 'SC', 'Civil Engineering'),
('EN21107579', 'VIJAY KUMAR', 'RAJESH KUMAR', 8901234567, 'vijay.kumar@example.com', 'OBC', 'Mechanical Engineering'),
('EN21107580', 'KAVITA SHARMA', 'VIKAS SHARMA', 9012345678, 'kavita.sharma@example.com', 'General', 'Computer Science Engineering'),
('EN21107581', 'ATHARVA WARADE', 'RAMESH WARADE', 7410767476, 'atharvarwarade@gmail.com', 'OBC', 'Computer Science Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `furniture`
--

CREATE TABLE `furniture` (
  `furniture_id` int(10) UNSIGNED NOT NULL,
  `furniture_type` enum('Bed','Chair','Table') NOT NULL,
  `description` text DEFAULT NULL,
  `condition` varchar(20) DEFAULT 'Good'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `furniture`
--

INSERT INTO `furniture` (`furniture_id`, `furniture_type`, `description`, `condition`) VALUES
(1, 'Bed', 'Bed for room 1', 'Good'),
(2, 'Chair', 'Chair for room 1', 'Good'),
(3, 'Table', 'Table for room 1', 'Good'),
(4, 'Bed', 'Bed for room 1', 'Good'),
(5, 'Chair', 'Chair for room 1', 'Good'),
(6, 'Table', 'Table for room 1', 'Good'),
(7, 'Bed', 'Bed for room 2', 'Good'),
(8, 'Chair', 'Chair for room 2', 'Good'),
(9, 'Table', 'Table for room 2', 'Good'),
(10, 'Bed', 'Bed for room 2', 'Good'),
(11, 'Chair', 'Chair for room 2', 'Good'),
(12, 'Table', 'Table for room 2', 'Good'),
(13, 'Bed', 'Bed for room 3', 'Good'),
(14, 'Chair', 'Chair for room 3', 'Good'),
(15, 'Table', 'Table for room 3', 'Good'),
(16, 'Bed', 'Bed for room 3', 'Good'),
(17, 'Chair', 'Chair for room 3', 'Good'),
(18, 'Table', 'Table for room 3', 'Good'),
(19, 'Bed', 'Bed for room 4', 'Good'),
(20, 'Chair', 'Chair for room 4', 'Good'),
(21, 'Table', 'Table for room 4', 'Good'),
(22, 'Bed', 'Bed for room 4', 'Good'),
(23, 'Chair', 'Chair for room 4', 'Good'),
(24, 'Table', 'Table for room 4', 'Good'),
(25, 'Bed', 'Bed for room 5', 'Good'),
(26, 'Chair', 'Chair for room 5', 'Good'),
(27, 'Table', 'Table for room 5', 'Good'),
(28, 'Bed', 'Bed for room 5', 'Good'),
(29, 'Chair', 'Chair for room 5', 'Good'),
(30, 'Table', 'Table for room 5', 'Good'),
(31, 'Bed', 'Bed for room 6', 'Good'),
(32, 'Chair', 'Chair for room 6', 'Good'),
(33, 'Table', 'Table for room 6', 'Good'),
(34, 'Bed', 'Bed for room 6', 'Good'),
(35, 'Chair', 'Chair for room 6', 'Good'),
(36, 'Table', 'Table for room 6', 'Good'),
(37, 'Bed', 'Bed for room 7', 'Good'),
(38, 'Chair', 'Chair for room 7', 'Good'),
(39, 'Table', 'Table for room 7', 'Good'),
(40, 'Bed', 'Bed for room 7', 'Good'),
(41, 'Chair', 'Chair for room 7', 'Good'),
(42, 'Table', 'Table for room 7', 'Good'),
(43, 'Bed', 'Bed for room 8', 'Good'),
(44, 'Chair', 'Chair for room 8', 'Good'),
(45, 'Table', 'Table for room 8', 'Good'),
(46, 'Bed', 'Bed for room 8', 'Good'),
(47, 'Chair', 'Chair for room 8', 'Good'),
(48, 'Table', 'Table for room 8', 'Good'),
(49, 'Bed', 'Bed for room 9', 'Good'),
(50, 'Chair', 'Chair for room 9', 'Good'),
(51, 'Table', 'Table for room 9', 'Good'),
(52, 'Bed', 'Bed for room 9', 'Good'),
(53, 'Chair', 'Chair for room 9', 'Good'),
(54, 'Table', 'Table for room 9', 'Good'),
(55, 'Bed', 'Bed for room 10', 'Good'),
(56, 'Chair', 'Chair for room 10', 'Good'),
(57, 'Table', 'Table for room 10', 'Good'),
(58, 'Bed', 'Bed for room 10', 'Good'),
(59, 'Chair', 'Chair for room 10', 'Good'),
(60, 'Table', 'Table for room 10', 'Good'),
(61, 'Bed', 'Bed for room 11', 'Good'),
(62, 'Chair', 'Chair for room 11', 'Good'),
(63, 'Table', 'Table for room 11', 'Good'),
(64, 'Bed', 'Bed for room 11', 'Good'),
(65, 'Chair', 'Chair for room 11', 'Good'),
(66, 'Table', 'Table for room 11', 'Good'),
(67, 'Bed', 'Bed for room 12', 'Good'),
(68, 'Chair', 'Chair for room 12', 'Good'),
(69, 'Table', 'Table for room 12', 'Good'),
(70, 'Bed', 'Bed for room 12', 'Good'),
(71, 'Chair', 'Chair for room 12', 'Good'),
(72, 'Table', 'Table for room 12', 'Good'),
(73, 'Bed', 'Bed for room 13', 'Good'),
(74, 'Chair', 'Chair for room 13', 'Good'),
(75, 'Table', 'Table for room 13', 'Good'),
(76, 'Bed', 'Bed for room 13', 'Good'),
(77, 'Chair', 'Chair for room 13', 'Good'),
(78, 'Table', 'Table for room 13', 'Good'),
(79, 'Bed', 'Bed for room 14', 'Good'),
(80, 'Chair', 'Chair for room 14', 'Good'),
(81, 'Table', 'Table for room 14', 'Good'),
(82, 'Bed', 'Bed for room 14', 'Good'),
(83, 'Chair', 'Chair for room 14', 'Good'),
(84, 'Table', 'Table for room 14', 'Good'),
(85, 'Bed', 'Bed for room 15', 'Good'),
(86, 'Chair', 'Chair for room 15', 'Good'),
(87, 'Table', 'Table for room 15', 'Good'),
(88, 'Bed', 'Bed for room 15', 'Good'),
(89, 'Chair', 'Chair for room 15', 'Good'),
(90, 'Table', 'Table for room 15', 'Good'),
(91, 'Bed', 'Bed for room 16', 'Good'),
(92, 'Chair', 'Chair for room 16', 'Good'),
(93, 'Table', 'Table for room 16', 'Good'),
(94, 'Bed', 'Bed for room 16', 'Good'),
(95, 'Chair', 'Chair for room 16', 'Good'),
(96, 'Table', 'Table for room 16', 'Good'),
(97, 'Bed', 'Bed for room 17', 'Good'),
(98, 'Chair', 'Chair for room 17', 'Good'),
(99, 'Table', 'Table for room 17', 'Good'),
(100, 'Bed', 'Bed for room 17', 'Good'),
(101, 'Chair', 'Chair for room 17', 'Good'),
(102, 'Table', 'Table for room 17', 'Good'),
(103, 'Bed', 'Bed for room 18', 'Good'),
(104, 'Chair', 'Chair for room 18', 'Good'),
(105, 'Table', 'Table for room 18', 'Good'),
(106, 'Bed', 'Bed for room 18', 'Good'),
(107, 'Chair', 'Chair for room 18', 'Good'),
(108, 'Table', 'Table for room 18', 'Good'),
(109, 'Bed', 'Bed for room 19', 'Good'),
(110, 'Chair', 'Chair for room 19', 'Good'),
(111, 'Table', 'Table for room 19', 'Good'),
(112, 'Bed', 'Bed for room 19', 'Good'),
(113, 'Chair', 'Chair for room 19', 'Good'),
(114, 'Table', 'Table for room 19', 'Good'),
(115, 'Bed', 'Bed for room 20', 'Good'),
(116, 'Chair', 'Chair for room 20', 'Good'),
(117, 'Table', 'Table for room 20', 'Good'),
(118, 'Bed', 'Bed for room 20', 'Good'),
(119, 'Chair', 'Chair for room 20', 'Good'),
(120, 'Table', 'Table for room 20', 'Good'),
(121, 'Bed', 'Bed for room 21', 'Good'),
(122, 'Chair', 'Chair for room 21', 'Good'),
(123, 'Table', 'Table for room 21', 'Good'),
(124, 'Bed', 'Bed for room 21', 'Good'),
(125, 'Chair', 'Chair for room 21', 'Good'),
(126, 'Table', 'Table for room 21', 'Good'),
(127, 'Bed', 'Bed for room 22', 'Good'),
(128, 'Chair', 'Chair for room 22', 'Good'),
(129, 'Table', 'Table for room 22', 'Good'),
(130, 'Bed', 'Bed for room 22', 'Good'),
(131, 'Chair', 'Chair for room 22', 'Good'),
(132, 'Table', 'Table for room 22', 'Good'),
(133, 'Bed', 'Bed for room 23', 'Good'),
(134, 'Chair', 'Chair for room 23', 'Good'),
(135, 'Table', 'Table for room 23', 'Good'),
(136, 'Bed', 'Bed for room 23', 'Good'),
(137, 'Chair', 'Chair for room 23', 'Good'),
(138, 'Table', 'Table for room 23', 'Good'),
(139, 'Bed', 'Bed for room 24', 'Good'),
(140, 'Chair', 'Chair for room 24', 'Good'),
(141, 'Table', 'Table for room 24', 'Good'),
(142, 'Bed', 'Bed for room 24', 'Good'),
(143, 'Chair', 'Chair for room 24', 'Good'),
(144, 'Table', 'Table for room 24', 'Good'),
(145, 'Bed', 'Bed for room 25', 'Good'),
(146, 'Chair', 'Chair for room 25', 'Good'),
(147, 'Table', 'Table for room 25', 'Good'),
(148, 'Bed', 'Bed for room 25', 'Good'),
(149, 'Chair', 'Chair for room 25', 'Good'),
(150, 'Table', 'Table for room 25', 'Good'),
(151, 'Bed', 'Bed for room 26', 'Good'),
(152, 'Chair', 'Chair for room 26', 'Good'),
(153, 'Table', 'Table for room 26', 'Good'),
(154, 'Bed', 'Bed for room 26', 'Good'),
(155, 'Chair', 'Chair for room 26', 'Good'),
(156, 'Table', 'Table for room 26', 'Good'),
(157, 'Bed', 'Bed for room 27', 'Good'),
(158, 'Chair', 'Chair for room 27', 'Good'),
(159, 'Table', 'Table for room 27', 'Good'),
(160, 'Bed', 'Bed for room 27', 'Good'),
(161, 'Chair', 'Chair for room 27', 'Good'),
(162, 'Table', 'Table for room 27', 'Good'),
(163, 'Bed', 'Bed for room 28', 'Good'),
(164, 'Chair', 'Chair for room 28', 'Good'),
(165, 'Table', 'Table for room 28', 'Good'),
(166, 'Bed', 'Bed for room 28', 'Good'),
(167, 'Chair', 'Chair for room 28', 'Good'),
(168, 'Table', 'Table for room 28', 'Good'),
(169, 'Bed', 'Bed for room 29', 'Good'),
(170, 'Chair', 'Chair for room 29', 'Good'),
(171, 'Table', 'Table for room 29', 'Good'),
(172, 'Bed', 'Bed for room 29', 'Good'),
(173, 'Chair', 'Chair for room 29', 'Good'),
(174, 'Table', 'Table for room 29', 'Good'),
(175, 'Bed', 'Bed for room 30', 'Good'),
(176, 'Chair', 'Chair for room 30', 'Good'),
(177, 'Table', 'Table for room 30', 'Good'),
(178, 'Bed', 'Bed for room 30', 'Good'),
(179, 'Chair', 'Chair for room 30', 'Good'),
(180, 'Table', 'Table for room 30', 'Good'),
(181, 'Bed', 'Bed for room 31', 'Good'),
(182, 'Chair', 'Chair for room 31', 'Good'),
(183, 'Table', 'Table for room 31', 'Good'),
(184, 'Bed', 'Bed for room 31', 'Good'),
(185, 'Chair', 'Chair for room 31', 'Good'),
(186, 'Table', 'Table for room 31', 'Good'),
(187, 'Bed', 'Bed for room 32', 'Good'),
(188, 'Chair', 'Chair for room 32', 'Good'),
(189, 'Table', 'Table for room 32', 'Good'),
(190, 'Bed', 'Bed for room 32', 'Good'),
(191, 'Chair', 'Chair for room 32', 'Good'),
(192, 'Table', 'Table for room 32', 'Good'),
(193, 'Bed', 'Bed for room 33', 'Good'),
(194, 'Chair', 'Chair for room 33', 'Good'),
(195, 'Table', 'Table for room 33', 'Good'),
(196, 'Bed', 'Bed for room 33', 'Good'),
(197, 'Chair', 'Chair for room 33', 'Good'),
(198, 'Table', 'Table for room 33', 'Good'),
(199, 'Bed', 'Bed for room 34', 'Good'),
(200, 'Chair', 'Chair for room 34', 'Good'),
(201, 'Table', 'Table for room 34', 'Good'),
(202, 'Bed', 'Bed for room 34', 'Good'),
(203, 'Chair', 'Chair for room 34', 'Good'),
(204, 'Table', 'Table for room 34', 'Good'),
(205, 'Bed', 'Bed for room 35', 'Good'),
(206, 'Chair', 'Chair for room 35', 'Good'),
(207, 'Table', 'Table for room 35', 'Good'),
(208, 'Bed', 'Bed for room 35', 'Good'),
(209, 'Chair', 'Chair for room 35', 'Good'),
(210, 'Table', 'Table for room 35', 'Good'),
(211, 'Bed', 'Bed for room 36', 'Good'),
(212, 'Chair', 'Chair for room 36', 'Good'),
(213, 'Table', 'Table for room 36', 'Good'),
(214, 'Bed', 'Bed for room 36', 'Good'),
(215, 'Chair', 'Chair for room 36', 'Good'),
(216, 'Table', 'Table for room 36', 'Good'),
(217, 'Bed', 'Bed for room 37', 'Good'),
(218, 'Chair', 'Chair for room 37', 'Good'),
(219, 'Table', 'Table for room 37', 'Good'),
(220, 'Bed', 'Bed for room 37', 'Good'),
(221, 'Chair', 'Chair for room 37', 'Good'),
(222, 'Table', 'Table for room 37', 'Good'),
(223, 'Bed', 'Bed for room 38', 'Good'),
(224, 'Chair', 'Chair for room 38', 'Good'),
(225, 'Table', 'Table for room 38', 'Good'),
(226, 'Bed', 'Bed for room 38', 'Good'),
(227, 'Chair', 'Chair for room 38', 'Good'),
(228, 'Table', 'Table for room 38', 'Good'),
(229, 'Bed', 'Bed for room 39', 'Good'),
(230, 'Chair', 'Chair for room 39', 'Good'),
(231, 'Table', 'Table for room 39', 'Good'),
(232, 'Bed', 'Bed for room 39', 'Good'),
(233, 'Chair', 'Chair for room 39', 'Good'),
(234, 'Table', 'Table for room 39', 'Good'),
(235, 'Bed', 'Bed for room 40', 'Good'),
(236, 'Chair', 'Chair for room 40', 'Good'),
(237, 'Table', 'Table for room 40', 'Good'),
(238, 'Bed', 'Bed for room 40', 'Good'),
(239, 'Chair', 'Chair for room 40', 'Good'),
(240, 'Table', 'Table for room 40', 'Good'),
(241, 'Bed', 'Bed for room 41', 'Good'),
(242, 'Chair', 'Chair for room 41', 'Good'),
(243, 'Table', 'Table for room 41', 'Good'),
(244, 'Bed', 'Bed for room 41', 'Good'),
(245, 'Chair', 'Chair for room 41', 'Good'),
(246, 'Table', 'Table for room 41', 'Good'),
(247, 'Bed', 'Bed for room 42', 'Good'),
(248, 'Chair', 'Chair for room 42', 'Good'),
(249, 'Table', 'Table for room 42', 'Good'),
(250, 'Bed', 'Bed for room 42', 'Good'),
(251, 'Chair', 'Chair for room 42', 'Good'),
(252, 'Table', 'Table for room 42', 'Good'),
(253, 'Bed', 'Bed for room 43', 'Good'),
(254, 'Chair', 'Chair for room 43', 'Good'),
(255, 'Table', 'Table for room 43', 'Good'),
(256, 'Bed', 'Bed for room 43', 'Good'),
(257, 'Chair', 'Chair for room 43', 'Good'),
(258, 'Table', 'Table for room 43', 'Good'),
(259, 'Bed', 'Bed for room 44', 'Good'),
(260, 'Chair', 'Chair for room 44', 'Good'),
(261, 'Table', 'Table for room 44', 'Good'),
(262, 'Bed', 'Bed for room 44', 'Good'),
(263, 'Chair', 'Chair for room 44', 'Good'),
(264, 'Table', 'Table for room 44', 'Good'),
(265, 'Bed', 'Bed for room 45', 'Good'),
(266, 'Chair', 'Chair for room 45', 'Good'),
(267, 'Table', 'Table for room 45', 'Good'),
(268, 'Bed', 'Bed for room 45', 'Good'),
(269, 'Chair', 'Chair for room 45', 'Good'),
(270, 'Table', 'Table for room 45', 'Good'),
(271, 'Bed', 'Bed for room 46', 'Good'),
(272, 'Chair', 'Chair for room 46', 'Good'),
(273, 'Table', 'Table for room 46', 'Good'),
(274, 'Bed', 'Bed for room 46', 'Good'),
(275, 'Chair', 'Chair for room 46', 'Good'),
(276, 'Table', 'Table for room 46', 'Good'),
(277, 'Bed', 'Bed for room 47', 'Good'),
(278, 'Chair', 'Chair for room 47', 'Good'),
(279, 'Table', 'Table for room 47', 'Good'),
(280, 'Bed', 'Bed for room 47', 'Good'),
(281, 'Chair', 'Chair for room 47', 'Good'),
(282, 'Table', 'Table for room 47', 'Good'),
(283, 'Bed', 'Bed for room 48', 'Good'),
(284, 'Chair', 'Chair for room 48', 'Good'),
(285, 'Table', 'Table for room 48', 'Good'),
(286, 'Bed', 'Bed for room 48', 'Good'),
(287, 'Chair', 'Chair for room 48', 'Good'),
(288, 'Table', 'Table for room 48', 'Good'),
(289, 'Bed', 'Bed for room 49', 'Good'),
(290, 'Chair', 'Chair for room 49', 'Good'),
(291, 'Table', 'Table for room 49', 'Good'),
(292, 'Bed', 'Bed for room 49', 'Good'),
(293, 'Chair', 'Chair for room 49', 'Good'),
(294, 'Table', 'Table for room 49', 'Good'),
(295, 'Bed', 'Bed for room 50', 'Good'),
(296, 'Chair', 'Chair for room 50', 'Good'),
(297, 'Table', 'Table for room 50', 'Good'),
(298, 'Bed', 'Bed for room 50', 'Good'),
(299, 'Chair', 'Chair for room 50', 'Good'),
(300, 'Table', 'Table for room 50', 'Good'),
(301, 'Bed', 'Bed for room 51', 'Good'),
(302, 'Chair', 'Chair for room 51', 'Good'),
(303, 'Table', 'Table for room 51', 'Good'),
(304, 'Bed', 'Bed for room 51', 'Good'),
(305, 'Chair', 'Chair for room 51', 'Good'),
(306, 'Table', 'Table for room 51', 'Good'),
(307, 'Bed', 'Bed for room 52', 'Good'),
(308, 'Chair', 'Chair for room 52', 'Good'),
(309, 'Table', 'Table for room 52', 'Good'),
(310, 'Bed', 'Bed for room 52', 'Good'),
(311, 'Chair', 'Chair for room 52', 'Good'),
(312, 'Table', 'Table for room 52', 'Good'),
(313, 'Bed', 'Bed for room 53', 'Good'),
(314, 'Chair', 'Chair for room 53', 'Good'),
(315, 'Table', 'Table for room 53', 'Good'),
(316, 'Bed', 'Bed for room 53', 'Good'),
(317, 'Chair', 'Chair for room 53', 'Good'),
(318, 'Table', 'Table for room 53', 'Good'),
(319, 'Bed', 'Bed for room 54', 'Good'),
(320, 'Chair', 'Chair for room 54', 'Good'),
(321, 'Table', 'Table for room 54', 'Good'),
(322, 'Bed', 'Bed for room 54', 'Good'),
(323, 'Chair', 'Chair for room 54', 'Good'),
(324, 'Table', 'Table for room 54', 'Good'),
(325, 'Bed', 'Bed for room 55', 'Good'),
(326, 'Chair', 'Chair for room 55', 'Good'),
(327, 'Table', 'Table for room 55', 'Good'),
(328, 'Bed', 'Bed for room 55', 'Good'),
(329, 'Chair', 'Chair for room 55', 'Good'),
(330, 'Table', 'Table for room 55', 'Good'),
(331, 'Bed', 'Bed for room 56', 'Good'),
(332, 'Chair', 'Chair for room 56', 'Good'),
(333, 'Table', 'Table for room 56', 'Good'),
(334, 'Bed', 'Bed for room 56', 'Good'),
(335, 'Chair', 'Chair for room 56', 'Good'),
(336, 'Table', 'Table for room 56', 'Good'),
(337, 'Bed', 'Bed for room 57', 'Good'),
(338, 'Chair', 'Chair for room 57', 'Good'),
(339, 'Table', 'Table for room 57', 'Good'),
(340, 'Bed', 'Bed for room 57', 'Good'),
(341, 'Chair', 'Chair for room 57', 'Good'),
(342, 'Table', 'Table for room 57', 'Good'),
(343, 'Bed', 'Bed for room 58', 'Good'),
(344, 'Chair', 'Chair for room 58', 'Good'),
(345, 'Table', 'Table for room 58', 'Good'),
(346, 'Bed', 'Bed for room 58', 'Good'),
(347, 'Chair', 'Chair for room 58', 'Good'),
(348, 'Table', 'Table for room 58', 'Good'),
(349, 'Bed', 'Bed for room 59', 'Good'),
(350, 'Chair', 'Chair for room 59', 'Good'),
(351, 'Table', 'Table for room 59', 'Good'),
(352, 'Bed', 'Bed for room 59', 'Good'),
(353, 'Chair', 'Chair for room 59', 'Good'),
(354, 'Table', 'Table for room 59', 'Good'),
(355, 'Bed', 'Bed for room 60', 'Good'),
(356, 'Chair', 'Chair for room 60', 'Good'),
(357, 'Table', 'Table for room 60', 'Good'),
(358, 'Bed', 'Bed for room 60', 'Good'),
(359, 'Chair', 'Chair for room 60', 'Good'),
(360, 'Table', 'Table for room 60', 'Good'),
(361, 'Bed', 'Bed for room 1', 'Good'),
(362, 'Chair', 'Chair for room 1', 'Good'),
(363, 'Table', 'Table for room 1', 'Good'),
(364, 'Bed', 'Bed for room 1', 'Good'),
(365, 'Chair', 'Chair for room 1', 'Good'),
(366, 'Table', 'Table for room 1', 'Good'),
(367, 'Bed', 'Bed for room 2', 'Good'),
(368, 'Chair', 'Chair for room 2', 'Good'),
(369, 'Table', 'Table for room 2', 'Good'),
(370, 'Bed', 'Bed for room 2', 'Good'),
(371, 'Chair', 'Chair for room 2', 'Good'),
(372, 'Table', 'Table for room 2', 'Good'),
(373, 'Bed', 'Bed for room 3', 'Good'),
(374, 'Chair', 'Chair for room 3', 'Good'),
(375, 'Table', 'Table for room 3', 'Good'),
(376, 'Bed', 'Bed for room 3', 'Good'),
(377, 'Chair', 'Chair for room 3', 'Good'),
(378, 'Table', 'Table for room 3', 'Good'),
(379, 'Bed', 'Bed for room 4', 'Good'),
(380, 'Chair', 'Chair for room 4', 'Good'),
(381, 'Table', 'Table for room 4', 'Good'),
(382, 'Bed', 'Bed for room 4', 'Good'),
(383, 'Chair', 'Chair for room 4', 'Good'),
(384, 'Table', 'Table for room 4', 'Good'),
(385, 'Bed', 'Bed for room 5', 'Good'),
(386, 'Chair', 'Chair for room 5', 'Good'),
(387, 'Table', 'Table for room 5', 'Good'),
(388, 'Bed', 'Bed for room 5', 'Good'),
(389, 'Chair', 'Chair for room 5', 'Good'),
(390, 'Table', 'Table for room 5', 'Good'),
(391, 'Bed', 'Bed for room 6', 'Good'),
(392, 'Chair', 'Chair for room 6', 'Good'),
(393, 'Table', 'Table for room 6', 'Good'),
(394, 'Bed', 'Bed for room 6', 'Good'),
(395, 'Chair', 'Chair for room 6', 'Good'),
(396, 'Table', 'Table for room 6', 'Good'),
(397, 'Bed', 'Bed for room 7', 'Good'),
(398, 'Chair', 'Chair for room 7', 'Good'),
(399, 'Table', 'Table for room 7', 'Good'),
(400, 'Bed', 'Bed for room 7', 'Good'),
(401, 'Chair', 'Chair for room 7', 'Good'),
(402, 'Table', 'Table for room 7', 'Good'),
(403, 'Bed', 'Bed for room 8', 'Good'),
(404, 'Chair', 'Chair for room 8', 'Good'),
(405, 'Table', 'Table for room 8', 'Good'),
(406, 'Bed', 'Bed for room 8', 'Good'),
(407, 'Chair', 'Chair for room 8', 'Good'),
(408, 'Table', 'Table for room 8', 'Good'),
(409, 'Bed', 'Bed for room 9', 'Good'),
(410, 'Chair', 'Chair for room 9', 'Good'),
(411, 'Table', 'Table for room 9', 'Good'),
(412, 'Bed', 'Bed for room 9', 'Good'),
(413, 'Chair', 'Chair for room 9', 'Good'),
(414, 'Table', 'Table for room 9', 'Good'),
(415, 'Bed', 'Bed for room 10', 'Good'),
(416, 'Chair', 'Chair for room 10', 'Good'),
(417, 'Table', 'Table for room 10', 'Good'),
(418, 'Bed', 'Bed for room 10', 'Good'),
(419, 'Chair', 'Chair for room 10', 'Good'),
(420, 'Table', 'Table for room 10', 'Good'),
(421, 'Bed', 'Bed for room 11', 'Good'),
(422, 'Chair', 'Chair for room 11', 'Good'),
(423, 'Table', 'Table for room 11', 'Good'),
(424, 'Bed', 'Bed for room 11', 'Good'),
(425, 'Chair', 'Chair for room 11', 'Good'),
(426, 'Table', 'Table for room 11', 'Good'),
(427, 'Bed', 'Bed for room 12', 'Good'),
(428, 'Chair', 'Chair for room 12', 'Good'),
(429, 'Table', 'Table for room 12', 'Good'),
(430, 'Bed', 'Bed for room 12', 'Good'),
(431, 'Chair', 'Chair for room 12', 'Good'),
(432, 'Table', 'Table for room 12', 'Good'),
(433, 'Bed', 'Bed for room 13', 'Good'),
(434, 'Chair', 'Chair for room 13', 'Good'),
(435, 'Table', 'Table for room 13', 'Good'),
(436, 'Bed', 'Bed for room 13', 'Good'),
(437, 'Chair', 'Chair for room 13', 'Good'),
(438, 'Table', 'Table for room 13', 'Good'),
(439, 'Bed', 'Bed for room 14', 'Good'),
(440, 'Chair', 'Chair for room 14', 'Good'),
(441, 'Table', 'Table for room 14', 'Good'),
(442, 'Bed', 'Bed for room 14', 'Good'),
(443, 'Chair', 'Chair for room 14', 'Good'),
(444, 'Table', 'Table for room 14', 'Good'),
(445, 'Bed', 'Bed for room 15', 'Good'),
(446, 'Chair', 'Chair for room 15', 'Good'),
(447, 'Table', 'Table for room 15', 'Good'),
(448, 'Bed', 'Bed for room 15', 'Good'),
(449, 'Chair', 'Chair for room 15', 'Good'),
(450, 'Table', 'Table for room 15', 'Good'),
(451, 'Bed', 'Bed for room 16', 'Good'),
(452, 'Chair', 'Chair for room 16', 'Good'),
(453, 'Table', 'Table for room 16', 'Good'),
(454, 'Bed', 'Bed for room 16', 'Good'),
(455, 'Chair', 'Chair for room 16', 'Good'),
(456, 'Table', 'Table for room 16', 'Good'),
(457, 'Bed', 'Bed for room 17', 'Good'),
(458, 'Chair', 'Chair for room 17', 'Good'),
(459, 'Table', 'Table for room 17', 'Good'),
(460, 'Bed', 'Bed for room 17', 'Good'),
(461, 'Chair', 'Chair for room 17', 'Good'),
(462, 'Table', 'Table for room 17', 'Good'),
(463, 'Bed', 'Bed for room 18', 'Good'),
(464, 'Chair', 'Chair for room 18', 'Good'),
(465, 'Table', 'Table for room 18', 'Good'),
(466, 'Bed', 'Bed for room 18', 'Good'),
(467, 'Chair', 'Chair for room 18', 'Good'),
(468, 'Table', 'Table for room 18', 'Good'),
(469, 'Bed', 'Bed for room 19', 'Good'),
(470, 'Chair', 'Chair for room 19', 'Good'),
(471, 'Table', 'Table for room 19', 'Good'),
(472, 'Bed', 'Bed for room 19', 'Good'),
(473, 'Chair', 'Chair for room 19', 'Good'),
(474, 'Table', 'Table for room 19', 'Good'),
(475, 'Bed', 'Bed for room 20', 'Good'),
(476, 'Chair', 'Chair for room 20', 'Good'),
(477, 'Table', 'Table for room 20', 'Good'),
(478, 'Bed', 'Bed for room 20', 'Good'),
(479, 'Chair', 'Chair for room 20', 'Good'),
(480, 'Table', 'Table for room 20', 'Good'),
(481, 'Bed', 'Bed for room 21', 'Good'),
(482, 'Chair', 'Chair for room 21', 'Good'),
(483, 'Table', 'Table for room 21', 'Good'),
(484, 'Bed', 'Bed for room 21', 'Good'),
(485, 'Chair', 'Chair for room 21', 'Good'),
(486, 'Table', 'Table for room 21', 'Good'),
(487, 'Bed', 'Bed for room 22', 'Good'),
(488, 'Chair', 'Chair for room 22', 'Good'),
(489, 'Table', 'Table for room 22', 'Good'),
(490, 'Bed', 'Bed for room 22', 'Good'),
(491, 'Chair', 'Chair for room 22', 'Good'),
(492, 'Table', 'Table for room 22', 'Good'),
(493, 'Bed', 'Bed for room 23', 'Good'),
(494, 'Chair', 'Chair for room 23', 'Good'),
(495, 'Table', 'Table for room 23', 'Good'),
(496, 'Bed', 'Bed for room 23', 'Good'),
(497, 'Chair', 'Chair for room 23', 'Good'),
(498, 'Table', 'Table for room 23', 'Good'),
(499, 'Bed', 'Bed for room 24', 'Good'),
(500, 'Chair', 'Chair for room 24', 'Good'),
(501, 'Table', 'Table for room 24', 'Good'),
(502, 'Bed', 'Bed for room 24', 'Good'),
(503, 'Chair', 'Chair for room 24', 'Good'),
(504, 'Table', 'Table for room 24', 'Good'),
(505, 'Bed', 'Bed for room 25', 'Good'),
(506, 'Chair', 'Chair for room 25', 'Good'),
(507, 'Table', 'Table for room 25', 'Good'),
(508, 'Bed', 'Bed for room 25', 'Good'),
(509, 'Chair', 'Chair for room 25', 'Good'),
(510, 'Table', 'Table for room 25', 'Good'),
(511, 'Bed', 'Bed for room 26', 'Good'),
(512, 'Chair', 'Chair for room 26', 'Good'),
(513, 'Table', 'Table for room 26', 'Good'),
(514, 'Bed', 'Bed for room 26', 'Good'),
(515, 'Chair', 'Chair for room 26', 'Good'),
(516, 'Table', 'Table for room 26', 'Good'),
(517, 'Bed', 'Bed for room 27', 'Good'),
(518, 'Chair', 'Chair for room 27', 'Good'),
(519, 'Table', 'Table for room 27', 'Good'),
(520, 'Bed', 'Bed for room 27', 'Good'),
(521, 'Chair', 'Chair for room 27', 'Good'),
(522, 'Table', 'Table for room 27', 'Good'),
(523, 'Bed', 'Bed for room 28', 'Good'),
(524, 'Chair', 'Chair for room 28', 'Good'),
(525, 'Table', 'Table for room 28', 'Good'),
(526, 'Bed', 'Bed for room 28', 'Good'),
(527, 'Chair', 'Chair for room 28', 'Good'),
(528, 'Table', 'Table for room 28', 'Good'),
(529, 'Bed', 'Bed for room 29', 'Good'),
(530, 'Chair', 'Chair for room 29', 'Good'),
(531, 'Table', 'Table for room 29', 'Good'),
(532, 'Bed', 'Bed for room 29', 'Good'),
(533, 'Chair', 'Chair for room 29', 'Good'),
(534, 'Table', 'Table for room 29', 'Good'),
(535, 'Bed', 'Bed for room 30', 'Good'),
(536, 'Chair', 'Chair for room 30', 'Good'),
(537, 'Table', 'Table for room 30', 'Good'),
(538, 'Bed', 'Bed for room 30', 'Good'),
(539, 'Chair', 'Chair for room 30', 'Good'),
(540, 'Table', 'Table for room 30', 'Good'),
(541, 'Bed', 'Bed for room 31', 'Good'),
(542, 'Chair', 'Chair for room 31', 'Good'),
(543, 'Table', 'Table for room 31', 'Good'),
(544, 'Bed', 'Bed for room 31', 'Good'),
(545, 'Chair', 'Chair for room 31', 'Good'),
(546, 'Table', 'Table for room 31', 'Good'),
(547, 'Bed', 'Bed for room 32', 'Good'),
(548, 'Chair', 'Chair for room 32', 'Good'),
(549, 'Table', 'Table for room 32', 'Good'),
(550, 'Bed', 'Bed for room 32', 'Good'),
(551, 'Chair', 'Chair for room 32', 'Good'),
(552, 'Table', 'Table for room 32', 'Good'),
(553, 'Bed', 'Bed for room 33', 'Good'),
(554, 'Chair', 'Chair for room 33', 'Good'),
(555, 'Table', 'Table for room 33', 'Good'),
(556, 'Bed', 'Bed for room 33', 'Good'),
(557, 'Chair', 'Chair for room 33', 'Good'),
(558, 'Table', 'Table for room 33', 'Good'),
(559, 'Bed', 'Bed for room 34', 'Good'),
(560, 'Chair', 'Chair for room 34', 'Good'),
(561, 'Table', 'Table for room 34', 'Good'),
(562, 'Bed', 'Bed for room 34', 'Good'),
(563, 'Chair', 'Chair for room 34', 'Good'),
(564, 'Table', 'Table for room 34', 'Good'),
(565, 'Bed', 'Bed for room 35', 'Good'),
(566, 'Chair', 'Chair for room 35', 'Good'),
(567, 'Table', 'Table for room 35', 'Good'),
(568, 'Bed', 'Bed for room 35', 'Good'),
(569, 'Chair', 'Chair for room 35', 'Good'),
(570, 'Table', 'Table for room 35', 'Good'),
(571, 'Bed', 'Bed for room 36', 'Good'),
(572, 'Chair', 'Chair for room 36', 'Good'),
(573, 'Table', 'Table for room 36', 'Good'),
(574, 'Bed', 'Bed for room 36', 'Good'),
(575, 'Chair', 'Chair for room 36', 'Good'),
(576, 'Table', 'Table for room 36', 'Good'),
(577, 'Bed', 'Bed for room 37', 'Good'),
(578, 'Chair', 'Chair for room 37', 'Good'),
(579, 'Table', 'Table for room 37', 'Good'),
(580, 'Bed', 'Bed for room 37', 'Good'),
(581, 'Chair', 'Chair for room 37', 'Good'),
(582, 'Table', 'Table for room 37', 'Good'),
(583, 'Bed', 'Bed for room 38', 'Good'),
(584, 'Chair', 'Chair for room 38', 'Good'),
(585, 'Table', 'Table for room 38', 'Good'),
(586, 'Bed', 'Bed for room 38', 'Good'),
(587, 'Chair', 'Chair for room 38', 'Good'),
(588, 'Table', 'Table for room 38', 'Good'),
(589, 'Bed', 'Bed for room 39', 'Good'),
(590, 'Chair', 'Chair for room 39', 'Good'),
(591, 'Table', 'Table for room 39', 'Good'),
(592, 'Bed', 'Bed for room 39', 'Good'),
(593, 'Chair', 'Chair for room 39', 'Good'),
(594, 'Table', 'Table for room 39', 'Good'),
(595, 'Bed', 'Bed for room 40', 'Good'),
(596, 'Chair', 'Chair for room 40', 'Good'),
(597, 'Table', 'Table for room 40', 'Good'),
(598, 'Bed', 'Bed for room 40', 'Good'),
(599, 'Chair', 'Chair for room 40', 'Good'),
(600, 'Table', 'Table for room 40', 'Good'),
(601, 'Bed', 'Bed for room 41', 'Good'),
(602, 'Chair', 'Chair for room 41', 'Good'),
(603, 'Table', 'Table for room 41', 'Good'),
(604, 'Bed', 'Bed for room 41', 'Good'),
(605, 'Chair', 'Chair for room 41', 'Good'),
(606, 'Table', 'Table for room 41', 'Good'),
(607, 'Bed', 'Bed for room 42', 'Good'),
(608, 'Chair', 'Chair for room 42', 'Good'),
(609, 'Table', 'Table for room 42', 'Good'),
(610, 'Bed', 'Bed for room 42', 'Good'),
(611, 'Chair', 'Chair for room 42', 'Good'),
(612, 'Table', 'Table for room 42', 'Good'),
(613, 'Bed', 'Bed for room 43', 'Good'),
(614, 'Chair', 'Chair for room 43', 'Good'),
(615, 'Table', 'Table for room 43', 'Good'),
(616, 'Bed', 'Bed for room 43', 'Good'),
(617, 'Chair', 'Chair for room 43', 'Good'),
(618, 'Table', 'Table for room 43', 'Good'),
(619, 'Bed', 'Bed for room 44', 'Good'),
(620, 'Chair', 'Chair for room 44', 'Good'),
(621, 'Table', 'Table for room 44', 'Good'),
(622, 'Bed', 'Bed for room 44', 'Good'),
(623, 'Chair', 'Chair for room 44', 'Good'),
(624, 'Table', 'Table for room 44', 'Good'),
(625, 'Bed', 'Bed for room 45', 'Good'),
(626, 'Chair', 'Chair for room 45', 'Good'),
(627, 'Table', 'Table for room 45', 'Good'),
(628, 'Bed', 'Bed for room 45', 'Good'),
(629, 'Chair', 'Chair for room 45', 'Good'),
(630, 'Table', 'Table for room 45', 'Good'),
(631, 'Bed', 'Bed for room 46', 'Good'),
(632, 'Chair', 'Chair for room 46', 'Good'),
(633, 'Table', 'Table for room 46', 'Good'),
(634, 'Bed', 'Bed for room 46', 'Good'),
(635, 'Chair', 'Chair for room 46', 'Good'),
(636, 'Table', 'Table for room 46', 'Good'),
(637, 'Bed', 'Bed for room 47', 'Good'),
(638, 'Chair', 'Chair for room 47', 'Good'),
(639, 'Table', 'Table for room 47', 'Good'),
(640, 'Bed', 'Bed for room 47', 'Good'),
(641, 'Chair', 'Chair for room 47', 'Good'),
(642, 'Table', 'Table for room 47', 'Good'),
(643, 'Bed', 'Bed for room 48', 'Good'),
(644, 'Chair', 'Chair for room 48', 'Good'),
(645, 'Table', 'Table for room 48', 'Good'),
(646, 'Bed', 'Bed for room 48', 'Good'),
(647, 'Chair', 'Chair for room 48', 'Good'),
(648, 'Table', 'Table for room 48', 'Good'),
(649, 'Bed', 'Bed for room 49', 'Good'),
(650, 'Chair', 'Chair for room 49', 'Good'),
(651, 'Table', 'Table for room 49', 'Good'),
(652, 'Bed', 'Bed for room 49', 'Good'),
(653, 'Chair', 'Chair for room 49', 'Good'),
(654, 'Table', 'Table for room 49', 'Good'),
(655, 'Bed', 'Bed for room 50', 'Good'),
(656, 'Chair', 'Chair for room 50', 'Good'),
(657, 'Table', 'Table for room 50', 'Good'),
(658, 'Bed', 'Bed for room 50', 'Good'),
(659, 'Chair', 'Chair for room 50', 'Good'),
(660, 'Table', 'Table for room 50', 'Good'),
(661, 'Bed', 'Bed for room 51', 'Good'),
(662, 'Chair', 'Chair for room 51', 'Good'),
(663, 'Table', 'Table for room 51', 'Good'),
(664, 'Bed', 'Bed for room 51', 'Good'),
(665, 'Chair', 'Chair for room 51', 'Good'),
(666, 'Table', 'Table for room 51', 'Good'),
(667, 'Bed', 'Bed for room 52', 'Good'),
(668, 'Chair', 'Chair for room 52', 'Good'),
(669, 'Table', 'Table for room 52', 'Good'),
(670, 'Bed', 'Bed for room 52', 'Good'),
(671, 'Chair', 'Chair for room 52', 'Good'),
(672, 'Table', 'Table for room 52', 'Good'),
(673, 'Bed', 'Bed for room 53', 'Good'),
(674, 'Chair', 'Chair for room 53', 'Good'),
(675, 'Table', 'Table for room 53', 'Good'),
(676, 'Bed', 'Bed for room 53', 'Good'),
(677, 'Chair', 'Chair for room 53', 'Good'),
(678, 'Table', 'Table for room 53', 'Good'),
(679, 'Bed', 'Bed for room 54', 'Good'),
(680, 'Chair', 'Chair for room 54', 'Good'),
(681, 'Table', 'Table for room 54', 'Good'),
(682, 'Bed', 'Bed for room 54', 'Good'),
(683, 'Chair', 'Chair for room 54', 'Good'),
(684, 'Table', 'Table for room 54', 'Good'),
(685, 'Bed', 'Bed for room 55', 'Good'),
(686, 'Chair', 'Chair for room 55', 'Good'),
(687, 'Table', 'Table for room 55', 'Good'),
(688, 'Bed', 'Bed for room 55', 'Good'),
(689, 'Chair', 'Chair for room 55', 'Good'),
(690, 'Table', 'Table for room 55', 'Good'),
(691, 'Bed', 'Bed for room 56', 'Good'),
(692, 'Chair', 'Chair for room 56', 'Good'),
(693, 'Table', 'Table for room 56', 'Good'),
(694, 'Bed', 'Bed for room 56', 'Good'),
(695, 'Chair', 'Chair for room 56', 'Good'),
(696, 'Table', 'Table for room 56', 'Good'),
(697, 'Bed', 'Bed for room 57', 'Good'),
(698, 'Chair', 'Chair for room 57', 'Good'),
(699, 'Table', 'Table for room 57', 'Good'),
(700, 'Bed', 'Bed for room 57', 'Good'),
(701, 'Chair', 'Chair for room 57', 'Good'),
(702, 'Table', 'Table for room 57', 'Good'),
(703, 'Bed', 'Bed for room 58', 'Good'),
(704, 'Chair', 'Chair for room 58', 'Good'),
(705, 'Table', 'Table for room 58', 'Good'),
(706, 'Bed', 'Bed for room 58', 'Good'),
(707, 'Chair', 'Chair for room 58', 'Good'),
(708, 'Table', 'Table for room 58', 'Good'),
(709, 'Bed', 'Bed for room 59', 'Good'),
(710, 'Chair', 'Chair for room 59', 'Good'),
(711, 'Table', 'Table for room 59', 'Good'),
(712, 'Bed', 'Bed for room 59', 'Good'),
(713, 'Chair', 'Chair for room 59', 'Good'),
(714, 'Table', 'Table for room 59', 'Good'),
(715, 'Bed', 'Bed for room 60', 'Good'),
(716, 'Chair', 'Chair for room 60', 'Good'),
(717, 'Table', 'Table for room 60', 'Good'),
(718, 'Bed', 'Bed for room 60', 'Good'),
(719, 'Chair', 'Chair for room 60', 'Good'),
(720, 'Table', 'Table for room 60', 'Good');

-- --------------------------------------------------------

--
-- Table structure for table `guardian`
--

CREATE TABLE `guardian` (
  `guardian_id` int(10) UNSIGNED NOT NULL,
  `student_id` varchar(11) NOT NULL,
  `guardian_name` varchar(25) NOT NULL,
  `guardian_relation` varchar(15) NOT NULL,
  `guardian_phone` decimal(10,0) NOT NULL,
  `guardian_email` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hostels`
--

CREATE TABLE `hostels` (
  `hostel_id` int(10) UNSIGNED NOT NULL,
  `hostel_name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hostels`
--

INSERT INTO `hostels` (`hostel_id`, `hostel_name`) VALUES
(1, 'BOYS HOSTEL'),
(2, 'GIRLS HOSTEL');

-- --------------------------------------------------------

--
-- Table structure for table `incharges`
--

CREATE TABLE `incharges` (
  `username` varchar(10) NOT NULL,
  `password` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `incharges`
--

INSERT INTO `incharges` (`username`, `password`, `name`) VALUES
('ACCNTBIT01', '789456123', 'Parag Kombe'),
('WARDB01', '123456789', 'Mohan Chauvhan'),
('WARDG01', '987654321', 'Geeta Tiwari');

-- --------------------------------------------------------

--
-- Table structure for table `leave_requests`
--

CREATE TABLE `leave_requests` (
  `EN` varchar(11) NOT NULL,
  `Fullname` varchar(200) NOT NULL,
  `room_id` int(10) DEFAULT NULL,
  `status` enum('Pending','Approved','Cancelled') NOT NULL DEFAULT 'Pending',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` varchar(2000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leave_requests`
--

INSERT INTO `leave_requests` (`EN`, `Fullname`, `room_id`, `status`, `start_date`, `end_date`, `reason`) VALUES
('EN123456789', 'Atharva Warade', 21, 'Approved', '2024-05-10', '2024-05-17', 'tyt'),
('EN21107545', 'SANJAY YADAV', NULL, 'Pending', '2024-05-03', '2024-05-14', 'cvvc'),
('EN21107546', 'RAJESH KUMAR', NULL, 'Pending', '2024-05-18', '2024-05-31', 'm'),
('EN21107547', 'ANIL KUMAR', 45, 'Approved', '2024-05-02', '2024-05-03', 'xyz');

-- --------------------------------------------------------

--
-- Table structure for table `paststudent`
--

CREATE TABLE `paststudent` (
  `EN` varchar(11) NOT NULL,
  `YOA` date NOT NULL,
  `branch` varchar(45) NOT NULL,
  `FName` varchar(25) NOT NULL,
  `MName` varchar(25) DEFAULT NULL,
  `LName` varchar(15) NOT NULL,
  `email` varchar(45) NOT NULL,
  `student_phone` decimal(10,0) NOT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `YOS` decimal(1,0) DEFAULT NULL,
  `Batch` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quit_requests`
--

CREATE TABLE `quit_requests` (
  `EN` varchar(11) NOT NULL,
  `warden_status` enum('Pending','Approved','Canceled') NOT NULL DEFAULT 'Pending',
  `accountant_status` enum('Pending','Approved','Canceled') NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quit_requests`
--

INSERT INTO `quit_requests` (`EN`, `warden_status`, `accountant_status`) VALUES
('EN123456789', 'Approved', 'Approved'),
('EN21107547', 'Pending', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(10) UNSIGNED NOT NULL,
  `hostel_id` int(10) UNSIGNED NOT NULL,
  `room_number` int(11) NOT NULL,
  `capacity` int(10) UNSIGNED NOT NULL,
  `room_type` varchar(25) NOT NULL,
  `status` enum('vacant','not vacant') DEFAULT 'vacant'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_id`, `hostel_id`, `room_number`, `capacity`, `room_type`, `status`) VALUES
(1, 1, 1, 2, 'Dual', 'not vacant'),
(2, 1, 2, 2, 'Dual', 'vacant'),
(3, 1, 3, 2, 'Dual', 'vacant'),
(4, 1, 4, 2, 'Dual', 'vacant'),
(5, 1, 5, 2, 'Dual', 'vacant'),
(6, 1, 6, 2, 'Dual', 'not vacant'),
(7, 1, 7, 2, 'Dual', 'vacant'),
(8, 1, 8, 2, 'Dual', 'vacant'),
(9, 1, 9, 2, 'Dual', 'vacant'),
(10, 1, 10, 2, 'Dual', 'vacant'),
(11, 1, 11, 2, 'Dual', 'vacant'),
(12, 1, 12, 2, 'Dual', 'vacant'),
(13, 1, 13, 2, 'Dual', 'vacant'),
(14, 1, 14, 2, 'Dual', 'vacant'),
(15, 1, 15, 2, 'Dual', 'vacant'),
(16, 1, 16, 2, 'Dual', 'vacant'),
(17, 1, 17, 2, 'Dual', 'vacant'),
(18, 1, 18, 2, 'Dual', 'vacant'),
(19, 1, 19, 2, 'Dual', 'vacant'),
(20, 1, 20, 2, 'Dual', 'vacant'),
(21, 1, 21, 2, 'Dual', 'vacant'),
(22, 1, 22, 2, 'Dual', 'vacant'),
(23, 1, 23, 2, 'Dual', 'vacant'),
(24, 1, 24, 2, 'Dual', 'vacant'),
(25, 1, 25, 2, 'Dual', 'vacant'),
(26, 1, 26, 2, 'Dual', 'vacant'),
(27, 1, 27, 2, 'Dual', 'vacant'),
(28, 1, 28, 2, 'Dual', 'vacant'),
(29, 1, 29, 2, 'Dual', 'vacant'),
(30, 1, 30, 2, 'Dual', 'vacant'),
(31, 1, 31, 2, 'Dual', 'vacant'),
(32, 1, 32, 2, 'Dual', 'vacant'),
(33, 1, 33, 2, 'Dual', 'vacant'),
(34, 1, 34, 2, 'Dual', 'vacant'),
(35, 1, 35, 2, 'Dual', 'vacant'),
(36, 1, 36, 2, 'Dual', 'vacant'),
(37, 1, 37, 2, 'Dual', 'vacant'),
(38, 1, 38, 2, 'Dual', 'vacant'),
(39, 1, 39, 2, 'Dual', 'vacant'),
(40, 1, 40, 2, 'Dual', 'vacant'),
(41, 1, 41, 2, 'Dual', 'vacant'),
(42, 1, 42, 2, 'Dual', 'vacant'),
(43, 1, 43, 2, 'Dual', 'vacant'),
(44, 1, 44, 2, 'Dual', 'vacant'),
(45, 1, 45, 2, 'Dual', 'vacant'),
(46, 1, 46, 2, 'Dual', 'vacant'),
(47, 1, 47, 2, 'Dual', 'vacant'),
(48, 1, 48, 2, 'Dual', 'vacant'),
(49, 1, 49, 2, 'Dual', 'vacant'),
(50, 1, 50, 2, 'Dual', 'vacant'),
(51, 1, 51, 2, 'Dual', 'vacant'),
(52, 1, 52, 2, 'Dual', 'vacant'),
(53, 1, 53, 2, 'Dual', 'vacant'),
(54, 1, 54, 2, 'Dual', 'vacant'),
(55, 1, 55, 2, 'Dual', 'vacant'),
(56, 1, 56, 2, 'Dual', 'vacant'),
(57, 1, 57, 2, 'Dual', 'vacant'),
(58, 1, 58, 2, 'Dual', 'vacant'),
(59, 1, 59, 2, 'Dual', 'vacant'),
(60, 1, 60, 2, 'Dual', 'vacant'),
(61, 2, 1, 2, 'Dual', 'vacant'),
(62, 2, 2, 2, 'Dual', 'vacant'),
(63, 2, 3, 2, 'Dual', 'vacant'),
(64, 2, 4, 2, 'Dual', 'vacant'),
(65, 2, 5, 2, 'Dual', 'vacant'),
(66, 2, 6, 2, 'Dual', 'vacant'),
(67, 2, 7, 2, 'Dual', 'vacant'),
(68, 2, 8, 2, 'Dual', 'vacant'),
(69, 2, 9, 2, 'Dual', 'vacant'),
(70, 2, 10, 2, 'Dual', 'vacant'),
(71, 2, 11, 2, 'Dual', 'vacant'),
(72, 2, 12, 2, 'Dual', 'vacant'),
(73, 2, 13, 2, 'Dual', 'vacant'),
(74, 2, 14, 2, 'Dual', 'vacant'),
(75, 2, 15, 2, 'Dual', 'vacant'),
(76, 2, 16, 2, 'Dual', 'vacant'),
(77, 2, 17, 2, 'Dual', 'vacant'),
(78, 2, 18, 2, 'Dual', 'vacant'),
(79, 2, 19, 2, 'Dual', 'vacant'),
(80, 2, 20, 2, 'Dual', 'vacant'),
(81, 2, 21, 2, 'Dual', 'vacant'),
(82, 2, 22, 2, 'Dual', 'vacant'),
(83, 2, 23, 2, 'Dual', 'vacant'),
(84, 2, 24, 2, 'Dual', 'vacant'),
(85, 2, 25, 2, 'Dual', 'vacant'),
(86, 2, 26, 2, 'Dual', 'vacant'),
(87, 2, 27, 2, 'Dual', 'vacant'),
(88, 2, 28, 2, 'Dual', 'vacant'),
(89, 2, 29, 2, 'Dual', 'vacant'),
(90, 2, 30, 2, 'Dual', 'vacant'),
(91, 2, 31, 2, 'Dual', 'vacant'),
(92, 2, 32, 2, 'Dual', 'vacant'),
(93, 2, 33, 2, 'Dual', 'vacant'),
(94, 2, 34, 2, 'Dual', 'vacant'),
(95, 2, 35, 2, 'Dual', 'vacant'),
(96, 2, 36, 2, 'Dual', 'vacant'),
(97, 2, 37, 2, 'Dual', 'vacant'),
(98, 2, 38, 2, 'Dual', 'vacant'),
(99, 2, 39, 2, 'Dual', 'vacant'),
(100, 2, 40, 2, 'Dual', 'vacant'),
(101, 2, 41, 2, 'Dual', 'vacant'),
(102, 2, 42, 2, 'Dual', 'vacant'),
(103, 2, 43, 2, 'Dual', 'vacant'),
(104, 2, 44, 2, 'Dual', 'vacant'),
(105, 2, 45, 2, 'Dual', 'vacant'),
(106, 2, 46, 2, 'Dual', 'vacant'),
(107, 2, 47, 2, 'Dual', 'vacant'),
(108, 2, 48, 2, 'Dual', 'vacant'),
(109, 2, 49, 2, 'Dual', 'vacant'),
(110, 2, 50, 2, 'Dual', 'vacant'),
(111, 2, 51, 2, 'Dual', 'vacant'),
(112, 2, 52, 2, 'Dual', 'vacant'),
(113, 2, 53, 2, 'Dual', 'vacant'),
(114, 2, 54, 2, 'Dual', 'vacant'),
(115, 2, 55, 2, 'Dual', 'vacant'),
(116, 2, 56, 2, 'Dual', 'vacant'),
(117, 2, 57, 2, 'Dual', 'vacant'),
(118, 2, 58, 2, 'Dual', 'vacant'),
(119, 2, 59, 2, 'Dual', 'vacant'),
(120, 2, 60, 2, 'Dual', 'vacant');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `EN` varchar(11) NOT NULL,
  `Fullname` varchar(200) NOT NULL,
  `email` varchar(45) NOT NULL,
  `DOB` date DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `student_phone` decimal(10,0) NOT NULL,
  `Add_line_1` varchar(2000) NOT NULL,
  `Add_line_2` varchar(2000) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `pincode` int(10) NOT NULL,
  `Father_no` int(12) NOT NULL,
  `Mother_no` int(12) NOT NULL,
  `Gaurdian_no` int(12) NOT NULL,
  `Blood_group` varchar(3) NOT NULL,
  `photo` varchar(100) NOT NULL,
  `YOS` decimal(1,0) DEFAULT NULL,
  `branch` varchar(45) NOT NULL,
  `section` char(1) NOT NULL,
  `Batch` varchar(9) DEFAULT NULL,
  `dateOfStatusChange` date DEFAULT NULL,
  `status` enum('unpaid','paid','paid and approved') DEFAULT 'paid',
  `allotment_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`EN`, `Fullname`, `email`, `DOB`, `gender`, `student_phone`, `Add_line_1`, `Add_line_2`, `city`, `state`, `pincode`, `Father_no`, `Mother_no`, `Gaurdian_no`, `Blood_group`, `photo`, `YOS`, `branch`, `section`, `Batch`, `dateOfStatusChange`, `status`, `allotment_id`) VALUES
('EN123456789', 'Atharva Warade', 'co.2021.arwarade@bitwardha.ac.in', '0000-00-00', 'Male', 7410767476, '', '', '', '', 0, 0, 0, 0, '', '', 9, 'Computer Engineering', '', NULL, '2024-05-01', 'paid and approved', 21),
('EN21107538 ', 'ANSHIKA SHARMA', 'anshika.sharma@example.com', '2024-06-08', 'Male', 7654321098, 'sd', 'zzc', 'asd', 'asd', 555, 5, 5, 0, 'y', '', 1, 'Computer Engineering', 'A', NULL, NULL, 'paid and approved', 45),
('EN21107544', 'MEENA KUMARI', 'meena.kumari@example.com', '2022-07-07', 'Male', 1098765432, 'Snehal Nagar', 'Nagpur', 'Wardha', 'Maharashtra', 442001, 2147483647, 123654789, 2147483647, 'B+', '', 1, 'Electrical Engineering', 'B', NULL, NULL, 'paid and approved', 65),
('EN21107545', 'SANJAY YADAV', 'sanjay.yadav@example.com', '2024-05-10', 'Male', 1098765432, 'Ram nagar', '', 'Wardha', 'Maharshtra', 442001, 2147483647, 2147483647, 0, 'A+', 'EN2110754531556Computer EngineeringAprofile_photo.png', 1, 'Computer Engineering', 'A', NULL, NULL, 'paid and approved', NULL),
('EN21107546', 'RAJESH KUMAR', 'rajesh.kumar@example1.com', '2004-06-11', 'Male', 2109876543, 'Meera Naga', 'Behind Keshav Cit', 'Wardha', 'Maharashtra', 442001, 2147483647, 2147483647, 78, 'O+', 'EN2110754666495Electrical EngineeringAIMG-20220409-WA0013.jpg', 1, 'Electrical Engineering', 'A', NULL, NULL, 'paid and approved', 9),
('EN21107547', 'ANIL KUMAR', 'anil.kumar@example.com', '2024-05-04', 'Male', 3210987654, 'Sai Nagar', 'Wardha', 'Wardha', 'Maaharashtra', 442001, 2147483647, 2147483647, 0, 'A+', 'EN2110754790905Computer EngineeringAHarshal photo (2).jpg', 1, 'Computer Engineering', 'A', NULL, NULL, 'paid and approved', 45),
('EN21107554', 'ANITA YADAV', 'anita.yadav@example.com', '2024-05-10', 'Female', 1234567890, 'Jayant Nagar', 'Gandhi Chowk, Wardha', 'Wardha', 'Maharashtra', 442001, 2147483647, 2147483647, 321456963, 'A+', 'EN2110755430577Mechanical EngineeringBprofile_photo.png', 1, 'Mechanical Engineering', 'B', NULL, NULL, 'paid and approved', NULL),
('EN21107558', 'SHYAM KUMAR', 'shyam.kumar@example.com', '2024-06-08', 'Male', 5678901234, 'Snehal Nagar', 'Wardha', 'Wardha', 'Maharashtra', 442001, 2147483647, 2147483647, 2147483647, 'AB+', '', 1, 'Computer Engineering', 'A', NULL, NULL, 'paid and approved', NULL),
('EN21107578', 'GEETA KUMARI', 'geeta.kumari@example.com', '2003-06-24', 'Female', 7890123456, 'Sai Nagar', 'Wardha', 'Wardha', 'Maharashtra', 442001, 2147483647, 123654789, 2147483647, 'B+', '', 1, 'Civil Engineering', '', NULL, NULL, 'paid and approved', NULL);

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `after_student_room_id_update` AFTER UPDATE ON `student` FOR EACH ROW BEGIN
    IF NEW.allotment_id <> OLD.allotment_id THEN
        -- Check if the new room is vacant
        IF EXISTS (
            SELECT 1
            FROM `room`
            WHERE `room_id` = (SELECT `room_id` FROM `alloted` WHERE `allotment_id` = NEW.allotment_id)
            AND `status` = 'vacant'
        ) THEN
            -- Update the student_id in the alloted table for the new room
            UPDATE `alloted`
            SET `student_id` = NEW.EN
            WHERE `allotment_id` = NEW.allotment_id;

            -- Update the status for the old room
            CALL UpdateRoomStatus(OLD.allotment_id);
            
            -- Update the status for the new room
            CALL UpdateRoomStatus(NEW.allotment_id);
        END IF;
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alloted`
--
ALTER TABLE `alloted`
  ADD PRIMARY KEY (`allotment_id`),
  ADD UNIQUE KEY `furniture_id_1_2` (`furniture_id_1`),
  ADD KEY `furniture_id_1` (`furniture_id_1`),
  ADD KEY `furniture_id_2` (`furniture_id_2`),
  ADD KEY `furniture_id_3` (`furniture_id_3`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `alloted_ibfk_1` (`student_id`);

--
-- Indexes for table `furniture`
--
ALTER TABLE `furniture`
  ADD PRIMARY KEY (`furniture_id`);

--
-- Indexes for table `guardian`
--
ALTER TABLE `guardian`
  ADD PRIMARY KEY (`guardian_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `hostels`
--
ALTER TABLE `hostels`
  ADD PRIMARY KEY (`hostel_id`);

--
-- Indexes for table `incharges`
--
ALTER TABLE `incharges`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `leave_requests`
--
ALTER TABLE `leave_requests`
  ADD PRIMARY KEY (`EN`);

--
-- Indexes for table `paststudent`
--
ALTER TABLE `paststudent`
  ADD PRIMARY KEY (`EN`);

--
-- Indexes for table `quit_requests`
--
ALTER TABLE `quit_requests`
  ADD PRIMARY KEY (`EN`) USING BTREE;

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `fk_hostel_room` (`hostel_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`EN`),
  ADD KEY `fk_allotment_student` (`allotment_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alloted`
--
ALTER TABLE `alloted`
  MODIFY `allotment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT for table `furniture`
--
ALTER TABLE `furniture`
  MODIFY `furniture_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=721;

--
-- AUTO_INCREMENT for table `guardian`
--
ALTER TABLE `guardian`
  MODIFY `guardian_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hostels`
--
ALTER TABLE `hostels`
  MODIFY `hostel_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alloted`
--
ALTER TABLE `alloted`
  ADD CONSTRAINT `alloted_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`EN`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `alloted_ibfk_2` FOREIGN KEY (`furniture_id_1`) REFERENCES `furniture` (`furniture_id`),
  ADD CONSTRAINT `alloted_ibfk_3` FOREIGN KEY (`furniture_id_2`) REFERENCES `furniture` (`furniture_id`),
  ADD CONSTRAINT `alloted_ibfk_4` FOREIGN KEY (`furniture_id_3`) REFERENCES `furniture` (`furniture_id`),
  ADD CONSTRAINT `alloted_ibfk_5` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `guardian`
--
ALTER TABLE `guardian`
  ADD CONSTRAINT `fk_student_guardian` FOREIGN KEY (`student_id`) REFERENCES `student` (`EN`);

--
-- Constraints for table `hostels`
--
ALTER TABLE `hostels`
  ADD CONSTRAINT `hostels_ibfk_1` FOREIGN KEY (`hostel_id`) REFERENCES `room` (`room_id`);

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `fk_allotment_student` FOREIGN KEY (`allotment_id`) REFERENCES `alloted` (`allotment_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
