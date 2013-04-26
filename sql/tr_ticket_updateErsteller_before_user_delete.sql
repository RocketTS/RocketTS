DELIMITER //
DROP TRIGGER IF EXISTS tr_ticket_updateErsteller_before_user_delete;
CREATE TRIGGER tr_ticket_updateErsteller_before_user_delete
	BEFORE DELETE ON user
FOR EACH ROW	
	BEGIN
		-- setzt Ersteller auf Dummy-User falls dieser geloescht wird
		UPDATE ticket SET Ersteller=1 WHERE Ersteller = OLD.User_ID;
	END; //
DELIMITER ;

