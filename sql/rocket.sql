-- phpMyAdmin SQL Dump
-- version 3.3.7deb7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 25. April 2013 um 22:20
-- Server Version: 5.1.66
-- PHP-Version: 5.3.3-7+squeeze14

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `rocket`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `abteilung`
--

CREATE TABLE IF NOT EXISTS `abteilung` (
  `Abteilung_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Abteilungsname` varchar(40) NOT NULL,
  PRIMARY KEY (`Abteilung_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=100 ;

--
-- Daten für Tabelle `abteilung`
--

INSERT INTO `abteilung` (`Abteilung_ID`, `Abteilungsname`) VALUES
(1, 'First Level Support'),
(2, 'Second Level Support'),
(3, 'Perl Programmierung'),
(99, 'Default-Abteilung');

--
-- Trigger `abteilung`
--
DROP TRIGGER IF EXISTS `tr_mitarbeiter_updateAbteilung_before_abteilung_delete`;
DELIMITER //
CREATE TRIGGER `tr_mitarbeiter_updateAbteilung_before_abteilung_delete` BEFORE DELETE ON `abteilung`
 FOR EACH ROW BEGIN
		UPDATE mitarbeiter SET Abteilung_ID = 99 WHERE Abteilung_ID = OLD.Abteilung_ID;
	END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `administrator`
--

CREATE TABLE IF NOT EXISTS `administrator` (
  `Administrator_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Mitarbeiter_ID` int(11) NOT NULL,
  PRIMARY KEY (`Administrator_ID`),
  KEY `Mitarbeiter_ID_idx` (`Mitarbeiter_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `administrator`
--

INSERT INTO `administrator` (`Administrator_ID`, `Mitarbeiter_ID`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auswahlkriterien`
--

CREATE TABLE IF NOT EXISTS `auswahlkriterien` (
  `Auswahlkriterien_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Kategorie` varchar(40) NOT NULL,
  PRIMARY KEY (`Auswahlkriterien_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Daten für Tabelle `auswahlkriterien`
--

INSERT INTO `auswahlkriterien` (`Auswahlkriterien_ID`, `Kategorie`) VALUES
(1, 'Funktionstest'),
(2, 'Hardware'),
(3, 'Software'),
(4, 'Datenbank'),
(5, 'PERL'),
(6, 'Andre');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `Message_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ersteller` varchar(20) NOT NULL,
  `Erstelldatum` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Inhalt` text NOT NULL,
  PRIMARY KEY (`Message_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=56 ;

--
-- Daten für Tabelle `message`
--

INSERT INTO `message` (`Message_ID`, `Ersteller`, `Erstelldatum`, `Inhalt`) VALUES
(1, 'd f', '2013-03-21 22:21:22', 'Die nachricht ist nicht lange'),
(2, 'a a', '2013-03-21 23:59:27', 'kein problem! :D'),
(3, 'a a', '2013-03-22 00:02:11', 'Yeah!'),
(4, 'Nagel Matthias', '2013-03-22 12:50:02', 'Hallo'),
(5, 'a a', '2013-03-22 15:22:44', 'asdfsadfsadf'),
(6, 'a a', '2013-03-22 15:31:59', 'dfdsfbsgn'),
(7, 'z z', '2013-03-29 20:50:34', 'Von Version 2 :D\r\n\r\nEINwandfrei'),
(8, 'z z', '2013-03-29 20:52:16', 'Version 2 yeah!'),
(9, 'Dorsch Thomas', '2013-03-30 19:00:05', 'Hallo,\r\n\r\nhabe ein massives Problem mit Perl.\r\n\r\nWie kann ich aus einer Datenbank mehrere Results importieren??\r\n\r\nmfg'),
(10, 'Dorsch Thomas', '2013-03-30 19:00:36', 'Und der zweite Text\r\n\r\n\r\n\r\nmit viel leerzeichen, mal schauen wie das in der\r\n\r\n\r\n\r\n\r\n\r\ndatenbank aussieht :('),
(11, 'Dorsch Thomas', '2013-03-30 21:29:09', 'Und der zweite Text\r\n\r\n\r\n\r\nmit viel leerzeichen, mal schauen wie das in der\r\n\r\n\r\n\r\n\r\n\r\ndatenbank aussieht :('),
(12, 'Nagel Matthias', '2013-03-31 16:06:25', 'Nachrichtentext'),
(13, 'Nagel Matthias', '2013-04-01 16:50:24', 'Erste Antwort'),
(14, 'Nagel Matthias', '2013-04-01 16:52:13', 'Zweite Antwort diesmal etwas längerer Text ...'),
(15, 'Nagel Matthias', '2013-04-01 17:27:04', 'April, April,'),
(16, 'Nagel Matthias', '2013-04-01 17:27:42', 'April, April,'),
(17, 'Nagel Matthias', '2013-04-01 17:32:51', 'ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt'),
(18, 'Dorsch Thomas', '2013-04-01 17:35:44', 'April, April,\r\n\r\nder weiß nicht was er will.\r\n\r\nNun seht, nun seht,\r\n\r\nwie’s draußen stürmt und weht.\r\n\r\nOh weh, oh weh,\r\n\r\njetzt fällt schon wieder Schnee.\r\n\r\nZum Schluss ein wenig Sonnenschein,\r\n\r\nden lassen wir zum Fenster rein.'),
(19, 'Dorsch Thomas', '2013-04-04 17:58:02', 'erste antwort'),
(20, 'Dorsch Thomas', '2013-04-04 18:01:36', 'zweite antwort :D'),
(21, 'Dorsch Thomas', '2013-04-04 18:01:41', 'zweite antwort :D'),
(22, 'Dorsch Thomas', '2013-04-04 18:01:45', 'zweite antwort :D'),
(23, 'Dorsch Thomas', '2013-04-04 18:02:34', '3. Antwort, hoffentlich ohne bug!'),
(24, 'Dorsch Thomas', '2013-04-04 18:02:38', '3. Antwort, hoffentlich ohne bug!'),
(25, 'Dorsch Thomas', '2013-04-04 18:04:42', '4. versuch'),
(26, 'Dorsch Thomas', '2013-04-04 18:04:46', '4. versuch'),
(27, 'Dorsch Thomas', '2013-04-04 18:04:51', '4. versuch'),
(28, 'Dorsch Thomas', '2013-04-04 18:06:37', '5. versuch'),
(29, 'Dorsch Thomas', '2013-04-04 18:06:44', '5. versuch'),
(30, 'Dorsch Thomas', '2013-04-04 18:09:21', '6.'),
(31, 'Dorsch Thomas', '2013-04-04 18:09:54', '6.'),
(32, 'Dorsch Thomas', '2013-04-04 18:10:01', '6.'),
(33, 'Dorsch Thomas', '2013-04-04 18:10:49', '7'),
(34, 'Dorsch Thomas', '2013-04-04 18:10:56', '7'),
(35, 'Dorsch Thomas', '2013-04-04 18:13:20', '8'),
(36, 'Dorsch Thomas', '2013-04-04 18:13:37', 'Jetzt gehts!'),
(37, 'Dorsch Thomas', '2013-04-04 20:03:03', 'Das ist die frage?'),
(38, 'Dorsch Thomas', '2013-04-04 20:03:38', 'Und hier die Antwort :)'),
(39, 'Dorsch Thomas', '2013-04-06 17:25:19', 'hallo'),
(40, 'Nagel Matthias', '2013-04-08 12:25:59', 'antworttt'),
(41, 'Dorsch Thomas', '2013-04-09 12:49:50', 'Hallo Thomas'),
(42, 'Nagel Matthias', '2013-04-09 13:10:01', 'Hurra'),
(43, 'Nagel Matthias', '2013-04-09 13:18:02', '...'),
(44, 'Test Mitarbeiter', '2013-04-09 14:59:21', 'Antwort des Mitarbeiters'),
(45, 'Test Mitarbeiter', '2013-04-09 15:30:06', ''),
(46, 'Test Mitarbeiter', '2013-04-09 15:31:22', ''),
(47, 'Dorsch Thomas', '2013-04-09 15:46:58', 'asdf'),
(48, 'Dorsch Thomas', '2013-04-09 16:41:08', 'Auswahlkriterium sollte 1 sein, richtig?\r\nBzw als Anzeige "test"\r\n\r\nmfg'),
(49, 'Hi Hi', '2013-04-11 13:02:56', 'TestNachricht'),
(50, 'ho hey', '2013-04-11 13:36:01', 'asdfasdf Nachricht vor löschung'),
(51, 'd f', '2013-04-11 13:37:22', 'Antwort vor Löschung'),
(52, 'f asdf', '2013-04-11 13:46:54', 'Test MA_delete nach Geschlossenem Ticket'),
(53, 'Dorsch Thomas', '2013-04-12 12:20:09', 'HILFE!! :('),
(54, 'Test Mitarbeiter', '2013-04-12 12:23:50', 'aber da ist doch alles richtig?!'),
(55, 'Test Mitarbeiter', '2013-04-20 19:44:01', 'Antwort Mitarbeiter');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mitarbeiter`
--

CREATE TABLE IF NOT EXISTS `mitarbeiter` (
  `Mitarbeiter_ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_ID` int(11) NOT NULL,
  `Level` int(11) NOT NULL,
  `Abteilung_ID` int(11) NOT NULL,
  PRIMARY KEY (`Mitarbeiter_ID`),
  KEY `Abteilung_ID_idx` (`Abteilung_ID`),
  KEY `User_ID_idx` (`User_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Daten für Tabelle `mitarbeiter`
--

INSERT INTO `mitarbeiter` (`Mitarbeiter_ID`, `User_ID`, `Level`, `Abteilung_ID`) VALUES
(2, 34, 1, 1),
(3, 33, 1, 99);

--
-- Trigger `mitarbeiter`
--
DROP TRIGGER IF EXISTS `tr_ticket_updateBearbeiter_before_mitarbeiter_delete`;
DELIMITER //
CREATE TRIGGER `tr_ticket_updateBearbeiter_before_mitarbeiter_delete` BEFORE DELETE ON `mitarbeiter`
 FOR EACH ROW BEGIN
		SELECT Name,Vorname FROM user WHERE User_ID = OLD.User_ID INTO @n,@v;
		UPDATE ticket SET Bearbeiter=CONCAT(@n,' ',@v) WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='Geschlossen';
		UPDATE ticket SET Bearbeiter="", Status='Neu' WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='in Bearbeitung';	
	END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `prioritaet`
--

CREATE TABLE IF NOT EXISTS `prioritaet` (
  `Prioritaet_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Wichtigkeit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Prioritaet_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Daten für Tabelle `prioritaet`
--

INSERT INTO `prioritaet` (`Prioritaet_ID`, `Wichtigkeit`) VALUES
(1, 'Sehr hoch'),
(2, 'Hoch'),
(3, 'Normal');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ticket`
--

CREATE TABLE IF NOT EXISTS `ticket` (
  `Ticket_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Ersteller` int(11) NOT NULL,
  `Erstelldatum` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Betreff` varchar(40) NOT NULL,
  `Auswahlkriterien_ID` int(11) NOT NULL,
  `Prioritaet_ID` int(11) NOT NULL,
  `IP_Adresse` varchar(20) DEFAULT NULL,
  `Betriebssystem` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL DEFAULT 'Neu',
  `Bearbeiter` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`Ticket_ID`),
  KEY `Ersteller_idx` (`Ersteller`),
  KEY `Auswahlkriterien_ID_idx` (`Auswahlkriterien_ID`),
  KEY `Prioritaet_ID_idx` (`Prioritaet_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Daten für Tabelle `ticket`
--

INSERT INTO `ticket` (`Ticket_ID`, `Ersteller`, `Erstelldatum`, `Betreff`, `Auswahlkriterien_ID`, `Prioritaet_ID`, `IP_Adresse`, `Betriebssystem`, `Status`, `Bearbeiter`) VALUES
(1, 29, '2013-04-12 00:37:06', 'Testbetreff', 1, 2, '192.168.251.130', 'MSWin32', 'in Bearbeitung', '2'),
(2, 1, '2013-04-11 14:38:05', 'Betreff', 1, 1, '192.168.0.0', 'GENTOO', 'Geschlossen', 'f asdf'),
(3, 27, '2013-04-23 20:41:55', 'erstes ticket', 1, 1, '10.8.0.6', 'MSWin32', 'in Bearbeitung', '3'),
(4, 27, '2013-04-20 19:44:17', 'Und jetzt nochmal!', 1, 1, '10.8.0.6', 'MSWin32', 'Geschlossen', '3'),
(5, 29, '2013-04-03 01:29:59', 'Test', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(6, 27, '2013-04-09 13:08:09', 'asdf', 1, 1, '10.8.0.6', 'MSWin32', 'Geschlossen', '3'),
(7, 27, '2013-04-03 01:29:59', 'gergerg', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(8, 28, '2013-04-03 01:29:59', '', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(9, 28, '2013-04-03 01:29:59', '', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(10, 32, '2013-04-03 01:29:59', 'Programmierproblem', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(11, 32, '2013-04-09 16:33:19', 'Programmierv2', 1, 3, '10.8.0.6', 'MSWin32', 'in Bearbeitung', '3'),
(12, 32, '2013-04-03 01:29:59', 'Programmierv2', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', ''),
(13, 29, '2013-04-16 15:17:10', 'Testticket', 1, 1, '192.168.251.130', 'MSWin32', 'Geschlossen', '3'),
(14, 32, '2013-04-04 20:03:03', 'Neues Ticket mit Antworten', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', NULL),
(15, 29, '2013-04-09 13:10:01', 'Mein neues Ticket', 1, 1, '192.168.251.130', 'MSWin32', 'Neu', NULL),
(16, 29, '2013-04-09 13:18:02', 'Test OS', 1, 1, '192.168.251.130', 'MSWin32', 'Neu', NULL),
(17, 32, '2013-04-09 15:46:58', 'asdf', 1, 1, '10.8.0.6', 'MSWin32', 'Neu', NULL),
(18, 32, '2013-04-09 16:41:08', 'Ticket mit Auswahlkriterum', 1, 3, '10.8.0.6', 'MSWin32', 'Neu', NULL),
(19, 1, '2013-04-11 13:07:51', 'Test Trigger UserDel', 1, 3, '192.168.251.130', 'MSWin32', 'Neu', NULL),
(20, 1, '2013-04-11 13:40:29', 'Ticket vor der Löschung', 1, 3, '10.8.0.6', 'MSWin32', 'Neu', ''),
(21, 32, '2013-04-12 12:22:51', 'Ich kann nicht programmieren', 6, 3, '10.8.0.6', 'MSWin32', 'in Bearbeitung', '3');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tm`
--

CREATE TABLE IF NOT EXISTS `tm` (
  `Ticket_ID` int(11) NOT NULL,
  `Message_ID` int(11) NOT NULL,
  PRIMARY KEY (`Ticket_ID`,`Message_ID`),
  KEY `Ticket_ID_idx` (`Ticket_ID`),
  KEY `Message_ID_idx` (`Message_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `tm`
--

INSERT INTO `tm` (`Ticket_ID`, `Message_ID`) VALUES
(1, 45),
(2, 1),
(2, 46),
(2, 52),
(3, 2),
(4, 3),
(4, 55),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9),
(10, 12),
(10, 13),
(10, 14),
(10, 15),
(10, 16),
(10, 17),
(10, 18),
(10, 19),
(10, 20),
(10, 21),
(10, 22),
(10, 23),
(10, 24),
(10, 25),
(10, 26),
(10, 27),
(10, 28),
(10, 29),
(10, 30),
(10, 31),
(10, 32),
(10, 33),
(10, 34),
(10, 35),
(10, 36),
(10, 41),
(11, 10),
(11, 44),
(12, 11),
(13, 12),
(13, 40),
(14, 37),
(14, 38),
(14, 39),
(15, 42),
(16, 43),
(17, 47),
(18, 48),
(19, 49),
(20, 50),
(20, 51),
(21, 53),
(21, 54);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `User_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Vorname` varchar(20) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Passwort` varchar(100) NOT NULL,
  `SESSION_ID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=38 ;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`User_ID`, `Name`, `Vorname`, `Email`, `Passwort`, `SESSION_ID`) VALUES
(1, 'Gelöscht', 'Gelöscht', 'no@user.more', 'testtesttest', '12341234123412342134'),
(21, 'bin', 'Ich', 'neu@neu.de', 'b1688cbab7e2c8ad7cf619047e25eed6c9e344ed970badcdacd0e9ec73b08626', NULL),
(27, 'a', 'a', 'a', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', '9e933fdfca5f160c6d27c4ab8c6c2fb3'),
(28, 'z', 'z', 'z', '594e519ae499312b29433b7dd8a97ff068defcba9755b6d5d00e84c524d67b06', '3b03a079b42c966f4ca0ea8a01b67493'),
(29, 'Nagel', 'Matthias', 'matthias@keros.org', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', ''),
(30, 'box', 'drop', 'box', '454349e422f05297191ead13e21d3db520e5abef52055e4964b82fb213f593a1', NULL),
(31, 'endlich', 'Jah', 'gehts', '3702fc1866630796050c50e9c829bd32fde7cc4c883f28e3e4ca430307c485b0', NULL),
(32, 'Dorsch', 'Thomas', 'thomas.dorsch@gmx.org', 'c635cdf58c87215f2aada0208b85c307daff7a74827d92c1820d07dd7514bc26', '8aa9230d097808630aee7dd9ecdd88c1'),
(33, 'Test', 'Mitarbeiter', 'ma@rocket.de', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', ''),
(34, 'Test', 'Admin', 'admin@rocket.de', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'f327f866782edfaecce77f4fdd6eaf23'),
(37, 'testu', 'testu', 'testu', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '');

--
-- Trigger `user`
--
DROP TRIGGER IF EXISTS `tr_ticket_updateErsteller_before_user_delete`;
DELIMITER //
CREATE TRIGGER `tr_ticket_updateErsteller_before_user_delete` BEFORE DELETE ON `user`
 FOR EACH ROW BEGIN
		UPDATE ticket SET Ersteller=1 WHERE Ersteller = OLD.User_ID;
	END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `view_newTickets`
--
CREATE TABLE IF NOT EXISTS `view_newTickets` (
`Ticket_ID` int(11)
,`Email` varchar(40)
,`Erstelldatum` timestamp
,`Betreff` varchar(40)
,`Auswahlkriterien_ID` int(11)
,`Prioritaet_ID` int(11)
,`IP_Adresse` varchar(20)
,`Betriebssystem` varchar(20)
,`Status` varchar(20)
);
-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `view_tickets`
--
CREATE TABLE IF NOT EXISTS `view_tickets` (
`Ticket_ID` int(11)
,`Ersteller` int(11)
,`Erstelldatum` timestamp
,`Betreff` varchar(40)
,`Auswahlkriterien_ID` int(11)
,`Prioritaet_ID` int(11)
,`IP_Adresse` varchar(20)
,`Betriebssystem` varchar(20)
);
-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `view_Tickets`
--
CREATE TABLE IF NOT EXISTS `view_Tickets` (
`Ticket_ID` int(11)
,`Email` varchar(40)
,`Erstelldatum` timestamp
,`Betreff` varchar(40)
,`Auswahlkriterien_ID` int(11)
,`Prioritaet_ID` int(11)
,`IP_Adresse` varchar(20)
,`Betriebssystem` varchar(20)
,`Status` varchar(20)
,`Bearbeiter` varchar(40)
);
-- --------------------------------------------------------

--
-- Struktur des Views `view_newTickets`
--
DROP TABLE IF EXISTS `view_newTickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_newTickets` AS select `T`.`Ticket_ID` AS `Ticket_ID`,`U`.`Email` AS `Email`,`T`.`Erstelldatum` AS `Erstelldatum`,`T`.`Betreff` AS `Betreff`,`T`.`Auswahlkriterien_ID` AS `Auswahlkriterien_ID`,`T`.`Prioritaet_ID` AS `Prioritaet_ID`,`T`.`IP_Adresse` AS `IP_Adresse`,`T`.`Betriebssystem` AS `Betriebssystem`,`T`.`Status` AS `Status` from (`ticket` `T` join `user` `U`) where (`T`.`Ersteller` = `U`.`User_ID`);

-- --------------------------------------------------------

--
-- Struktur des Views `view_tickets`
--
DROP TABLE IF EXISTS `view_tickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_tickets` AS select `T`.`Ticket_ID` AS `Ticket_ID`,`T`.`Ersteller` AS `Ersteller`,`T`.`Erstelldatum` AS `Erstelldatum`,`T`.`Betreff` AS `Betreff`,`T`.`Auswahlkriterien_ID` AS `Auswahlkriterien_ID`,`T`.`Prioritaet_ID` AS `Prioritaet_ID`,`T`.`IP_Adresse` AS `IP_Adresse`,`T`.`Betriebssystem` AS `Betriebssystem` from `ticket` `T`;

-- --------------------------------------------------------

--
-- Struktur des Views `view_Tickets`
--
DROP TABLE IF EXISTS `view_Tickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_Tickets` AS select `T`.`Ticket_ID` AS `Ticket_ID`,`U`.`Email` AS `Email`,`T`.`Erstelldatum` AS `Erstelldatum`,`T`.`Betreff` AS `Betreff`,`T`.`Auswahlkriterien_ID` AS `Auswahlkriterien_ID`,`T`.`Prioritaet_ID` AS `Prioritaet_ID`,`T`.`IP_Adresse` AS `IP_Adresse`,`T`.`Betriebssystem` AS `Betriebssystem`,`T`.`Status` AS `Status`,`T`.`Bearbeiter` AS `Bearbeiter` from (`ticket` `T` join `user` `U`) where (`T`.`Ersteller` = `U`.`User_ID`);

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `administrator`
--
ALTER TABLE `administrator`
  ADD CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`Mitarbeiter_ID`) REFERENCES `mitarbeiter` (`Mitarbeiter_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `mitarbeiter`
--
ALTER TABLE `mitarbeiter`
  ADD CONSTRAINT `Abteilung_ID` FOREIGN KEY (`Abteilung_ID`) REFERENCES `abteilung` (`Abteilung_ID`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `User_ID` FOREIGN KEY (`User_ID`) REFERENCES `user` (`User_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints der Tabelle `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `Auswahlkriterien_ID` FOREIGN KEY (`Auswahlkriterien_ID`) REFERENCES `auswahlkriterien` (`Auswahlkriterien_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Ersteller` FOREIGN KEY (`Ersteller`) REFERENCES `user` (`User_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Prioritaet_ID` FOREIGN KEY (`Prioritaet_ID`) REFERENCES `prioritaet` (`Prioritaet_ID`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `tm`
--
ALTER TABLE `tm`
  ADD CONSTRAINT `Message_ID` FOREIGN KEY (`Message_ID`) REFERENCES `message` (`Message_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Ticket_ID` FOREIGN KEY (`Ticket_ID`) REFERENCES `ticket` (`Ticket_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_answer_Ticket`(p_Email varchar(40), p_TicketID INT, p_Message text)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SET @timestamp = now();
		SELECT Name	   FROM user WHERE Email=p_Email INTO @uName;
		SELECT Vorname FROM user WHERE Email=p_Email INTO @uVorname;
		SELECT CONCAT (@uName, ' ', @uVorname) INTO @Fullname;
		INSERT INTO message (Ersteller, Erstelldatum, Inhalt) values (@Fullname, @timestamp, p_Message);
		SELECT Message_ID FROM message WHERE Erstelldatum=@timestamp INTO @MessageID;
		INSERT INTO tm (Ticket_ID, Message_ID) values (p_TicketID, @MessageID);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_assume_Ticket`(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		
		UPDATE ticket SET Status="in Bearbeitung", Bearbeiter=@mid WHERE Ticket_ID=p_TicketID;
		
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_change_Email`(p_Name varchar(50), p_newEmail varchar(40))
BEGIN
	SELECT sql_exist_User(p_Name) INTO @exist;
	IF @exist = 1 THEN	
		UPDATE user SET Email=p_newEmail WHERE Email = p_Name;
		SELECT Email from user  WHERE Email = p_newEmail into @passwd;
		IF @passwd = p_newEmail THEN
		SET @ret=1;
		ELSE
		SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_change_Password`(p_Name varchar(50), p_newPassword varchar(80))
BEGIN
	SELECT sql_exist_User(p_Name) INTO @exist;
	IF @exist = 1 THEN	
		UPDATE user SET Passwort=p_newPassword WHERE Email = p_Name;
		SELECT Passwort from user  WHERE Email = p_Name into @passwd;
		IF @passwd = p_newPassword THEN
		SET @ret=1;
		ELSE
		SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_close_Ticket`(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;

		IF @mid = @bid THEN	
			UPDATE ticket SET Status="Geschlossen" WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_create_Ticket`(p_Email varchar(40), p_Betreff varchar(40), p_Message text, p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SET @timestamp = now();
		INSERT INTO ticket (Ersteller, Erstelldatum, Betreff, Auswahlkriterien_ID, Prioritaet_ID, IP_Adresse, Betriebssystem) values (@uid, @timestamp, p_Betreff, p_AID, p_PID, p_IP, p_OS);
		SELECT Name	   FROM user WHERE Email=p_Email INTO @uName;
		SELECT Vorname FROM user WHERE Email=p_Email INTO @uVorname;
		SELECT CONCAT (@uName, ' ', @uVorname) INTO @Fullname;
		SELECT Ticket_ID FROM ticket WHERE Erstelldatum=@timestamp INTO @TicketID;
		INSERT INTO message (Ersteller, Erstelldatum, Inhalt) values (@Fullname, @timestamp, p_Message);
		SELECT Message_ID FROM message WHERE Erstelldatum=@timestamp INTO @MessageID;
		INSERT INTO tm (Ticket_ID, Message_ID) values (@TicketID, @MessageID);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_del_Administrator`(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email = p_Email INTO @UID;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @UID INTO @MID;
		IF @err=0 THEN
		DELETE FROM administrator WHERE Mitarbeiter_ID = @MID;
		SET @ret=1;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_del_Message`(p_MessageID INT)
BEGIN	
	DELETE FROM tm WHERE Message_ID = p_MessageID;
	DELETE FROM message WHERE Message_ID = p_MessageID;
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_del_Mitarbeiter`(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email = p_Email INTO @UID;
		IF @err=0 THEN
		DELETE FROM mitarbeiter WHERE User_ID = @UID;
		DELETE FROM user WHERE User_ID = @UID;
		SET @ret=1;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_del_User`(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email = p_Email INTO @UID;
		IF @err=0 THEN
		DELETE FROM user WHERE User_ID = @UID;
		SET @ret=1;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_forward_Ticket`(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter,Prioritaet_ID FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid,@prio;
		SET @prio = @prio - 1;
		IF @mid = @bid THEN	
			UPDATE ticket SET Status="Neu", Bearbeiter="", Prioritaet_ID=@prio WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_get_AccessRights`(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	SELECT User_ID FROM user WHERE Email = p_Email INTO @uid;
	
	
	IF (@uid >= 1) && (@err=0) THEN	
		SET @ret="User";
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		IF (@mid >= 1) && (@err=0) THEN
			SELECT Administrator_ID FROM administrator WHERE Mitarbeiter_ID = @mid INTO @aid;
			IF (@aid >= 1) && (@err=0)THEN
				SET @ret="Administrator";
			ELSE
				SET @ret="Mitarbeiter";
			END IF;
		END IF;
	ELSE
		SET @ret="None";
	END IF;
	
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_get_Messages_from_Ticket`(p_TicketID INT)
BEGIN
	SELECT Ersteller, Erstelldatum, Inhalt FROM message, tm where tm.Ticket_ID = p_TicketID AND tm.Message_ID = message.Message_ID;
END$$

CREATE DEFINER=`thomas`@`%` PROCEDURE `sql_get_Tickets`(p_Email varchar(40))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Ticket_ID, Erstelldatum, BETREFF, Status FROM ticket WHERE Ersteller=@uid;
	END IF;	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_get_TicketsbyStatus`(p_Email varchar(40), p_Status varchar(20))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID,Level FROM mitarbeiter WHERE User_ID=@uid INTO @mid, @level;
		
		IF p_Status = 'Neu' THEN
			SELECT * FROM view_newTickets WHERE Status=p_Status AND Prioritaet_ID = @level;
		ELSE
			SELECT * FROM view_Tickets WHERE Bearbeiter=@mid AND Status=p_Status AND Prioritaet_ID = @level;
		END IF;	
	END IF;	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_insert_Ticket`(p_Email varchar(40), p_Betreff varchar(40), p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		INSERT INTO ticket (Ersteller, Erstelldatum, Betreff, Auswahlkriterien_ID, Prioritaet_ID, IP_Adresse, Betriebssystem) values (@uid, now(), p_Betreff, p_AID, p_PID, p_IP, p_OS);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_insert_Tickets`(p_Email varchar(40), p_Betreff varchar(40), p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 0 THEN	
		INSERT INTO user (Ersteller, Erstelldatum, Betreff, Auswahlkriterien_ID, Prioritaet_ID, IP_Adresse, Betriebssystem) 
		values ((SELECT User_ID FROM user WHERE Email=p_Email), now(), p_Betreff, p_AID, p_PID, p_IP, p_OS);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_insert_User`(p_Name varchar(20), p_Vorname varchar(20), p_Email varchar(40), p_Passwort varchar(100))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 0 THEN	
		INSERT INTO user (Name, Vorname, Email, Passwort) values (p_Name, p_Vorname, p_Email, p_Passwort);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_is_Authorized`(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;
		
		IF @mid = @bid THEN		
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_release_Ticket`(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;

		IF @mid = @bid THEN	
			UPDATE ticket SET Status="Neu", Bearbeiter="" WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_update_AccessRights`(p_User_ID INT, p_alt varchar(20),p_neu varchar(20))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
		
	IF (p_alt = "User" && (@err=0)) THEN
		INSERT INTO mitarbeiter VALUES (NULL,p_User_ID,1,99);
	END IF;
	
	IF ((@err=0) && (p_alt = "Mitarbeiter" || p_neu="Administrator") ) THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		INSERT INTO administrator VALUES (NULL,@MID);
	END IF;
		
	IF (@err=0) && (p_alt = "Administrator") THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		DELETE FROM administrator WHERE Mitarbeiter_ID = @MID;
	END IF;
	SET @ret=1;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `sql_update_User`(pUser_ID INT,Name_Neu VARCHAR(20),Vorname_Neu VARCHAR(20), Email_Neu VARCHAR(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @ret=0;
	UPDATE user SET Name=Name_Neu, Vorname=Vorname_Neu, Email=Email_Neu WHERE User_ID=pUser_ID;
	SET @ret=1;
END$$

--
-- Funktionen
--
CREATE DEFINER=`root`@`%` FUNCTION `sql_exist_User`(u varchar(40)) RETURNS tinyint(1)
BEGIN
	DECLARE v INT;
	DECLARE r BOOL;
	SELECT COUNT(EMail) INTO v FROM user WHERE EMail=u;
	IF v=1 THEN 
		SET r = TRUE;
	ELSE
		SET r = FALSE;
	END IF;
	
	RETURN r;
END$$

CREATE DEFINER=`root`@`%` FUNCTION `sql_valid_Login`(u varchar(40), p varchar(100)) RETURNS tinyint(1)
BEGIN
	DECLARE v INT;
	DECLARE r BOOL;
	SELECT COUNT(EMail) INTO v FROM user WHERE EMail=u AND Passwort=p;
	IF v=1 THEN 
		SET r = TRUE;
	ELSE
		SET r = FALSE;
	END IF;
	
	RETURN r;
END$$

DELIMITER ;
