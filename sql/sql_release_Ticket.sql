DELIMITER //
USE rocket
DROP PROCEDURE IF EXISTS sql_release_Ticket;
CREATE PROCEDURE sql_release_Ticket(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;
		IF @mid = @bid THEN	
			-- gibt Ticket wieder frei
			UPDATE ticket SET Status="Neu", Bearbeiter="" WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;