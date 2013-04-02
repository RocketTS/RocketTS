-- phpMyAdmin SQL Dump
-- version 3.3.7deb7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 02. April 2013 um 17:18
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `abteilung`
--

INSERT INTO `abteilung` (`Abteilung_ID`, `Abteilungsname`) VALUES
(1, 'First Level Support');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auswahlkriterien`
--

CREATE TABLE IF NOT EXISTS `auswahlkriterien` (
  `Auswahlkriterien_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Kategorie` varchar(40) NOT NULL,
  PRIMARY KEY (`Auswahlkriterien_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `auswahlkriterien`
--

INSERT INTO `auswahlkriterien` (`Auswahlkriterien_ID`, `Kategorie`) VALUES
(1, 'test');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

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
(18, 'Dorsch Thomas', '2013-04-01 17:35:44', 'April, April,\r\n\r\nder weiß nicht was er will.\r\n\r\nNun seht, nun seht,\r\n\r\nwie’s draußen stürmt und weht.\r\n\r\nOh weh, oh weh,\r\n\r\njetzt fällt schon wieder Schnee.\r\n\r\nZum Schluss ein wenig Sonnenschein,\r\n\r\nden lassen wir zum Fenster rein.');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `mitarbeiter`
--

CREATE TABLE IF NOT EXISTS `mitarbeiter` (
  `Mitarbeiter_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Vorname` varchar(20) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Passwort` varchar(100) NOT NULL,
  `Adresse` varchar(100) NOT NULL,
  `Level` int(11) NOT NULL,
  `Abteilung_ID` int(11) NOT NULL,
  PRIMARY KEY (`Mitarbeiter_ID`),
  KEY `Abteilung_ID_idx` (`Abteilung_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `mitarbeiter`
--

INSERT INTO `mitarbeiter` (`Mitarbeiter_ID`, `Name`, `Vorname`, `Email`, `Passwort`, `Adresse`, `Level`, `Abteilung_ID`) VALUES
(1, 'admin', 'admin', 'admin@rocket.de', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'Musteradresse', 1, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `prioritaet`
--

CREATE TABLE IF NOT EXISTS `prioritaet` (
  `Prioritaet_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Wichtigkeit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Prioritaet_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `prioritaet`
--

INSERT INTO `prioritaet` (`Prioritaet_ID`, `Wichtigkeit`) VALUES
(1, 'test');

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
  PRIMARY KEY (`Ticket_ID`),
  KEY `Ersteller_idx` (`Ersteller`),
  KEY `Auswahlkriterien_ID_idx` (`Auswahlkriterien_ID`),
  KEY `Prioritaet_ID_idx` (`Prioritaet_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Daten für Tabelle `ticket`
--

INSERT INTO `ticket` (`Ticket_ID`, `Ersteller`, `Erstelldatum`, `Betreff`, `Auswahlkriterien_ID`, `Prioritaet_ID`, `IP_Adresse`, `Betriebssystem`) VALUES
(1, 29, '2013-03-21 15:45:09', 'Testbetreff', 1, 1, '192.168.251.130', 'MSWin32'),
(2, 26, '2013-03-21 22:21:22', 'Betreff', 1, 1, '192.168.0.0', 'GENTOO'),
(3, 27, '2013-03-21 23:59:27', 'erstes ticket', 1, 1, '10.8.0.6', 'MSWin32'),
(4, 27, '2013-03-22 00:02:11', 'Und jetzt nochmal!', 1, 1, '10.8.0.6', 'MSWin32'),
(5, 29, '2013-03-22 12:50:02', 'Test', 1, 1, '10.8.0.6', 'MSWin32'),
(6, 27, '2013-03-22 15:22:44', 'asdf', 1, 1, '10.8.0.6', 'MSWin32'),
(7, 27, '2013-03-22 15:31:59', 'gergerg', 1, 1, '10.8.0.6', 'MSWin32'),
(8, 28, '2013-03-29 20:50:34', '', 1, 1, '10.8.0.6', 'MSWin32'),
(9, 28, '2013-03-29 20:52:16', '', 1, 1, '10.8.0.6', 'MSWin32'),
(10, 32, '2013-03-30 19:00:05', 'Programmierproblem', 1, 1, '10.8.0.6', 'MSWin32'),
(11, 32, '2013-03-30 19:00:36', 'Programmierv2', 1, 1, '10.8.0.6', 'MSWin32'),
(12, 32, '2013-03-30 21:29:09', 'Programmierv2', 1, 1, '10.8.0.6', 'MSWin32'),
(13, 29, '2013-03-31 16:06:25', 'Testticket', 1, 1, '192.168.251.130', 'MSWin32');

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
(2, 1),
(3, 2),
(4, 3),
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
(11, 10),
(12, 11),
(13, 12);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=33 ;

--
-- Daten für Tabelle `user`
--

INSERT INTO `user` (`User_ID`, `Name`, `Vorname`, `Email`, `Passwort`, `SESSION_ID`) VALUES
(1, 'TEST', 'TEST', 'test@test.test', 'testtesttest', '12341234123412342134'),
(2, 'Hi', 'Hi', 'hi@hi.hi', 'HiHi', NULL),
(19, 'maltenberger', 'julian', 'julian', 'ce0fee7e61f9c74f1110f0e5940a80b4f059f189217d0c3d26bb41960d4bf597', NULL),
(21, 'bin', 'Ich', 'neu@neu.de', 'b1688cbab7e2c8ad7cf619047e25eed6c9e344ed970badcdacd0e9ec73b08626', NULL),
(24, 'ho', 'hey', 'letsgo', '4cf6829aa93728e8f3c97df913fb1bfa95fe5810e2933a05943f8312a98d9cf2', NULL),
(25, 'f', 'asdf', 'f', '252f10c83610ebca1a059c0bae8255eba2f95be4d1d7bcfa89d7248a82d9f111', NULL),
(26, 'd', 'f', 'Email', '454349e422f05297191ead13e21d3db520e5abef52055e4964b82fb213f593a1', NULL),
(27, 'a', 'a', 'a', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', '9e933fdfca5f160c6d27c4ab8c6c2fb3'),
(28, 'z', 'z', 'z', '594e519ae499312b29433b7dd8a97ff068defcba9755b6d5d00e84c524d67b06', '3b03a079b42c966f4ca0ea8a01b67493'),
(29, 'Nagel', 'Matthias', 'matthias@keros.org', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'fdb1ca46d88075cc5b55606f4b397494'),
(30, 'box', 'drop', 'box', '454349e422f05297191ead13e21d3db520e5abef52055e4964b82fb213f593a1', NULL),
(31, 'endlich', 'Jah', 'gehts', '3702fc1866630796050c50e9c829bd32fde7cc4c883f28e3e4ca430307c485b0', NULL),
(32, 'Dorsch', 'Thomas', 'thomas.dorsch@gmx.org', '6239d0089e8b4c879268953cb52447e79805122aee3729460d683fd6924764a8', '315081579cb74447f63792c98a264a78');

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
-- Struktur des Views `view_tickets`
--
DROP TABLE IF EXISTS `view_tickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_tickets` AS select `T`.`Ticket_ID` AS `Ticket_ID`,`T`.`Ersteller` AS `Ersteller`,`T`.`Erstelldatum` AS `Erstelldatum`,`T`.`Betreff` AS `Betreff`,`T`.`Auswahlkriterien_ID` AS `Auswahlkriterien_ID`,`T`.`Prioritaet_ID` AS `Prioritaet_ID`,`T`.`IP_Adresse` AS `IP_Adresse`,`T`.`Betriebssystem` AS `Betriebssystem` from `ticket` `T`;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `mitarbeiter`
--
ALTER TABLE `mitarbeiter`
  ADD CONSTRAINT `Abteilung_ID` FOREIGN KEY (`Abteilung_ID`) REFERENCES `abteilung` (`Abteilung_ID`) ON DELETE NO ACTION ON UPDATE CASCADE;

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
