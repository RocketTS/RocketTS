-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 28. Feb 2013 um 11:15
-- Server Version: 5.5.25a
-- PHP-Version: 5.4.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `auswahlkriterien`
--

CREATE TABLE IF NOT EXISTS `auswahlkriterien` (
  `Auswahlkriterien_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Kategorie` varchar(40) NOT NULL,
  PRIMARY KEY (`Auswahlkriterien_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `message`
--

CREATE TABLE IF NOT EXISTS `message` (
  `Message_ID` int(11) NOT NULL,
  `Ersteller` varchar(20) NOT NULL,
  `Erstelldatum` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Inhalt` text NOT NULL,
  PRIMARY KEY (`Message_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `prioritaet`
--

CREATE TABLE IF NOT EXISTS `prioritaet` (
  `Prioritaet_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Wichtigkeit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Prioritaet_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
  `Ticketcol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Ticket_ID`),
  KEY `Ersteller_idx` (`Ersteller`),
  KEY `Auswahlkriterien_ID_idx` (`Auswahlkriterien_ID`),
  KEY `Prioritaet_ID_idx` (`Prioritaet_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

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
  ADD CONSTRAINT `Ersteller` FOREIGN KEY (`Ersteller`) REFERENCES `user` (`User_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Auswahlkriterien_ID` FOREIGN KEY (`Auswahlkriterien_ID`) REFERENCES `auswahlkriterien` (`Auswahlkriterien_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Prioritaet_ID` FOREIGN KEY (`Prioritaet_ID`) REFERENCES `prioritaet` (`Prioritaet_ID`) ON UPDATE CASCADE;

--
-- Constraints der Tabelle `tm`
--
ALTER TABLE `tm`
  ADD CONSTRAINT `Ticket_ID` FOREIGN KEY (`Ticket_ID`) REFERENCES `ticket` (`Ticket_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Message_ID` FOREIGN KEY (`Message_ID`) REFERENCES `message` (`Message_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
