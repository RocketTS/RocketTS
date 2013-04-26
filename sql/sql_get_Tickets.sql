DELIMITER //
DROP PROCEDURE IF EXISTS sql_get_Tickets;
CREATE PROCEDURE sql_get_Tickets(p_Email varchar(40))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		-- Auslesen der Tickets fuer Ersteller
		SELECT Ticket_ID, Erstelldatum, BETREFF, Status FROM ticket WHERE Ersteller=@uid;
	END IF;	
END //
DELIMITER ;