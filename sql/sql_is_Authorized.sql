DELIMITER //
USE rocket
DROP PROCEDURE IF EXISTS sql_is_Authorized;
CREATE PROCEDURE sql_is_Authorized(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;		
		SELECT Bearbeiter FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid;
		-- testet ob Mitarbeiter berechtigt, da Bearbeiter
		IF @mid = @bid THEN		
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;