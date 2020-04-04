-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1:3306
-- 生成日期： 2020-04-04 15:23:55
-- 服务器版本： 10.4.10-MariaDB
-- PHP 版本： 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `finstagram`
--

-- --------------------------------------------------------

--
-- 表的结构 `belongto`
--

DROP TABLE IF EXISTS `belongto`;
CREATE TABLE IF NOT EXISTS `belongto` (
  `username` varchar(32) NOT NULL,
  `groupName` varchar(32) NOT NULL,
  `groupCreator` varchar(32) NOT NULL,
  PRIMARY KEY (`username`,`groupName`,`groupCreator`),
  KEY `groupName` (`groupName`,`groupCreator`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `belongto`
--

INSERT INTO `belongto` (`username`, `groupName`, `groupCreator`) VALUES
('hz1704', 'eagle', 'sl1234');

-- --------------------------------------------------------

--
-- 表的结构 `follow`
--

DROP TABLE IF EXISTS `follow`;
CREATE TABLE IF NOT EXISTS `follow` (
  `follower` varchar(32) NOT NULL,
  `followee` varchar(32) NOT NULL,
  `followStatus` int(11) DEFAULT NULL,
  PRIMARY KEY (`follower`,`followee`),
  KEY `followee` (`followee`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `follow`
--

INSERT INTO `follow` (`follower`, `followee`, `followStatus`) VALUES
('hz1704', 'yl5680', 1),
('yl5680', 'hz1704', 1),
('francmeister', 'hz1704', 1),
('francmeister', 'sl1234', 1),
('francmeister', 'yl5680', 0);

-- --------------------------------------------------------

--
-- 替换视图以便查看 `following`
-- （参见下面的实际视图）
--
DROP VIEW IF EXISTS `following`;
CREATE TABLE IF NOT EXISTS `following` (
`username` varchar(32)
);

-- --------------------------------------------------------

--
-- 表的结构 `friendgroup`
--

DROP TABLE IF EXISTS `friendgroup`;
CREATE TABLE IF NOT EXISTS `friendgroup` (
  `groupName` varchar(32) NOT NULL,
  `groupCreator` varchar(32) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`groupName`,`groupCreator`),
  KEY `groupCreator` (`groupCreator`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `friendgroup`
--

INSERT INTO `friendgroup` (`groupName`, `groupCreator`, `description`) VALUES
('eagle', 'sl1234', 'cyka');

-- --------------------------------------------------------

--
-- 替换视图以便查看 `mygroup`
-- （参见下面的实际视图）
--
DROP VIEW IF EXISTS `mygroup`;
CREATE TABLE IF NOT EXISTS `mygroup` (
`groupName` varchar(32)
,`groupCreator` varchar(32)
);

-- --------------------------------------------------------

--
-- 表的结构 `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `username` varchar(32) NOT NULL,
  `password` varchar(64) DEFAULT NULL,
  `firstName` varchar(32) DEFAULT NULL,
  `lastName` varchar(32) DEFAULT NULL,
  `email` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `person`
--

INSERT INTO `person` (`username`, `password`, `firstName`, `lastName`, `email`) VALUES
('hz1704', 'blyat', 'HN', 'Z', 'hz1704@nyu.edu'),
('yl5680', 'cyka', 'YC', 'L', 'yl5680'),
('sl1234', 'ccc', 'SC', 'L', 'sl1234@nyu.edu'),
('francmeister', '123', 'franc', 'meister', 'fm123');

-- --------------------------------------------------------

--
-- 表的结构 `photo`
--

DROP TABLE IF EXISTS `photo`;
CREATE TABLE IF NOT EXISTS `photo` (
  `pID` int(11) NOT NULL AUTO_INCREMENT,
  `postingDate` datetime DEFAULT NULL,
  `filePath` varchar(255) DEFAULT NULL,
  `allFollowers` int(11) DEFAULT NULL,
  `caption` varchar(1000) DEFAULT NULL,
  `poster` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`pID`),
  KEY `poster` (`poster`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `photo`
--

INSERT INTO `photo` (`pID`, `postingDate`, `filePath`, `allFollowers`, `caption`, `poster`) VALUES
(1, '2020-03-25 00:00:00', '111', 1, 'cyka', 'yl5680'),
(2, '2020-03-10 00:00:00', '1111', 1, 'asdfasdfa', 'sl1234'),
(7, '2020-03-31 20:59:08', 'c:\\\\guishi123123123', 1, 'asdfasdfa', 'hz1704'),
(4, '2020-03-31 16:20:15', 'c:\\\\guishi123', 1, 'shenmolian123', 'abc'),
(5, '2020-03-31 20:40:12', 'c:\\\\guishi12345', 1, 'shentouguilian', 'hz1704'),
(6, '2020-03-31 20:42:32', 'c:\\\\777', 1, 'clearlove', 'hz1704');

-- --------------------------------------------------------

--
-- 表的结构 `reactto`
--

DROP TABLE IF EXISTS `reactto`;
CREATE TABLE IF NOT EXISTS `reactto` (
  `username` varchar(32) NOT NULL,
  `pID` int(11) NOT NULL,
  `reactionTime` datetime DEFAULT NULL,
  `comment` varchar(1000) DEFAULT NULL,
  `emoji` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`username`,`pID`),
  KEY `pID` (`pID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 替换视图以便查看 `relation`
-- （参见下面的实际视图）
--
DROP VIEW IF EXISTS `relation`;
CREATE TABLE IF NOT EXISTS `relation` (
`username` varchar(32)
);

-- --------------------------------------------------------

--
-- 表的结构 `sharedwith`
--

DROP TABLE IF EXISTS `sharedwith`;
CREATE TABLE IF NOT EXISTS `sharedwith` (
  `pID` int(11) NOT NULL,
  `groupName` varchar(32) NOT NULL,
  `groupCreator` varchar(32) NOT NULL,
  PRIMARY KEY (`pID`,`groupName`,`groupCreator`),
  KEY `groupName` (`groupName`,`groupCreator`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- 转存表中的数据 `sharedwith`
--

INSERT INTO `sharedwith` (`pID`, `groupName`, `groupCreator`) VALUES
(2, 'eagle', 'sl1234');

-- --------------------------------------------------------

--
-- 表的结构 `tag`
--

DROP TABLE IF EXISTS `tag`;
CREATE TABLE IF NOT EXISTS `tag` (
  `pID` int(11) NOT NULL,
  `username` varchar(32) NOT NULL,
  `tagStatus` int(11) DEFAULT NULL,
  PRIMARY KEY (`pID`,`username`),
  KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 视图结构 `following`
--
DROP TABLE IF EXISTS `following`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `following`  AS  (select `follow`.`followee` AS `username` from (`person` join `follow`) where `person`.`username` = 'francmeister' and `follow`.`follower` = 'francmeister' and `follow`.`followStatus` = 1) ;

-- --------------------------------------------------------

--
-- 视图结构 `mygroup`
--
DROP TABLE IF EXISTS `mygroup`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `mygroup`  AS  (select `belongto`.`groupName` AS `groupName`,`belongto`.`groupCreator` AS `groupCreator` from (`person` join `belongto` on(`person`.`username` = `belongto`.`username`)) where `person`.`username` = 'francmeister') ;

-- --------------------------------------------------------

--
-- 视图结构 `relation`
--
DROP TABLE IF EXISTS `relation`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `relation`  AS  (select `follow`.`followee` AS `username` from (`person` join `follow`) where `person`.`username` = 'francmeister' and `follow`.`follower` = 'francmeister') ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
