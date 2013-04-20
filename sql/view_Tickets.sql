DROP VIEW IF EXISTS view_Tickets;
DELIMITER //
CREATE VIEW view_Tickets AS	
	SELECT T.Ticket_ID, U.Email, T.Erstelldatum, T.Betreff, T.Auswahlkriterien_ID, T.Prioritaet_ID, T.IP_Adresse, T.Betriebssystem, T.Status, T.Bearbeiter
	FROM ticket T, user U
	WHERE T.Ersteller = U.User_ID
//	
DELIMITER ;