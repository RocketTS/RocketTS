DELIMITER //
DROP TRIGGER IF EXISTS tr_ticket_updateBearbeiter_before_mitarbeiter_delete;
CREATE TRIGGER tr_ticket_updateBearbeiter_before_mitarbeiter_delete
	BEFORE DELETE ON mitarbeiter
	
FOR EACH ROW	
	BEGIN
		SELECT Name,Vorname FROM user WHERE User_ID = OLD.User_ID INTO @n,@v;
		UPDATE ticket SET Bearbeiter=CONCAT(@n,' ',@v) WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='Geschlossen';
		UPDATE ticket SET Bearbeiter="", Status='Neu' WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='in Bearbeitung';	
	END;//
		
DELIMITER ;

