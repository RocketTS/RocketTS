DROP VIEW IF EXISTS view_newTickets;
DELIMITER //
CREATE VIEW view_newTickets AS
	SELECT T.Ticket_ID, T.Ersteller, T.Erstelldatum, T.Betreff, T.Auswahlkriterien_ID, T.Prioritaet_ID, T.IP_Adresse, T.Betriebssystem, T.Status
	FROM ticket T	
//	
DELIMITER ;