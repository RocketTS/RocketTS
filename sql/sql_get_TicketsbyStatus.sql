DELIMITER //
DROP PROCEDURE IF EXISTS sql_get_TicketsbyStatus;
CREATE PROCEDURE sql_get_TicketsbyStatus(p_Email varchar(40), p_Status varchar(20))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SELECT Mitarbeiter_ID,Level FROM mitarbeiter WHERE User_ID=@uid INTO @mid, @level;
		-- bei Status 'Neu' wird anderes Selektiert als bei 'in Bearbeitung' und 'Geschlossen'
		IF p_Status = 'Neu' THEN
			SELECT * FROM view_newTickets WHERE Status=p_Status AND Prioritaet_ID = @level;
		ELSE
			SELECT * FROM view_Tickets WHERE Bearbeiter=@mid AND Status=p_Status AND Prioritaet_ID = @level;
		END IF;	
	END IF;	
END //
DELIMITER ;