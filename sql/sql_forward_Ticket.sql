DELIMITER //
USE rocket
DROP PROCEDURE IF EXISTS sql_forward_Ticket;
CREATE PROCEDURE sql_forward_Ticket(p_Email varchar(40), p_TicketID INT)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		-- Auslesen notwendiger Werte aus der Datenbank
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		SELECT Bearbeiter,Prioritaet_ID FROM ticket WHERE Ticket_ID = p_TicketID INTO @bid,@prio;
		-- Dekrementieren der Prioritaet zum Weiterleiten
		SET @prio = @prio - 1;
		IF @mid = @bid THEN	
			-- aendern des Status
			UPDATE ticket SET Status="Neu", Bearbeiter="", Prioritaet_ID=@prio WHERE Ticket_ID=p_TicketID;
			SET @ret=1;
		ELSE
			SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;