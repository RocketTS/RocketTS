DELIMITER //
USE rocket
DROP PROCEDURE IF EXISTS sql_close_Ticket;
CREATE PROCEDURE sql_close_Ticket(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		-- Auslesen der User_ID, Mitarbeiter_ID und des Bearbeiters
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;

		-- Wenn Mitarbeiter glich dem Bearbeiter 
		IF @mid = @bid THEN	
			-- schliesst das Ticket in der Datenbank
			UPDATE ticket SET Status="Geschlossen" WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;