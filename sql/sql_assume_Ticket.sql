DELIMITER //
USE rocket
DROP PROCEDURE IF EXISTS sql_assume_Ticket;
CREATE PROCEDURE sql_assume_Ticket(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		-- Auslesen der User_ID und Mitarbeiter_ID
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		
		-- setzt Ticket in Status "in Bearbeitung"
		UPDATE ticket SET Status="in Bearbeitung", Bearbeiter=@mid WHERE Ticket_ID=p_TicketID;
		
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END
//
DELIMITER ;