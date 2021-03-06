DELIMITER //
DROP PROCEDURE IF EXISTS sql_get_Messages_from_Ticket;
CREATE PROCEDURE sql_get_Messages_from_Ticket(p_TicketID INT)
BEGIN
	-- holt alle Nachrichten eines Tickets aus der Datenbank
	SELECT Ersteller, Erstelldatum, Inhalt FROM message, tm where tm.Ticket_ID = p_TicketID AND tm.Message_ID = message.Message_ID;
END //
DELIMITER ;