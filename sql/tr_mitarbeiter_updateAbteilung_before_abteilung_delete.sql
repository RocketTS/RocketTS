DELIMITER //
DROP TRIGGER IF EXISTS tr_mitarbeiter_updateAbteilung_before_abteilung_delete;
CREATE TRIGGER tr_mitarbeiter_updateAbteilung_before_abteilung_delete
	BEFORE DELETE ON abteilung
	
FOR EACH ROW	
	BEGIN
		UPDATE mitarbeiter SET Abteilung_ID = 99 WHERE Abteilung_ID = OLD.Abteilung_ID;
	END;//
		
DELIMITER ;

