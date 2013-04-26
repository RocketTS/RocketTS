DELIMITER //
DROP TRIGGER IF EXISTS tr_ticket_updateBearbeiter_before_mitarbeiter_delete;
CREATE TRIGGER tr_ticket_updateBearbeiter_before_mitarbeiter_delete
	BEFORE DELETE ON mitarbeiter
FOR EACH ROW	
	BEGIN
		SELECT Name,Vorname FROM user WHERE User_ID = OLD.User_ID INTO @n,@v;
		-- setzt bei geschlossenen Tickets den Bearbeiter auf Namen, wenn Mitarbeiter geloescht wird
		UPDATE ticket SET Bearbeiter=CONCAT(@n,' ',@v) WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='Geschlossen';
		-- setzt Ticket auf neu, wenn waehrend Bearbeitung der Mitarbeiter geloescht wird
		UPDATE ticket SET Bearbeiter="", Status='Neu' WHERE Bearbeiter = OLD.Mitarbeiter_ID AND Status='in Bearbeitung';	
	END; //	
DELIMITER ;

