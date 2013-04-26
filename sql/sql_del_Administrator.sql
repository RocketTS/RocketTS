DELIMITER //
DROP PROCEDURE IF EXISTS sql_del_Administrator;
CREATE PROCEDURE sql_del_Administrator(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	-- Zuerst wird wieder überprüft ob der User (Administrator) überhaupt im System existiert
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN
		-- Es wird die User_ID benötigt um die korrekte Mitarbeiter_ID und damit die Administrator_ID zu bestimmen
		SELECT User_ID FROM user WHERE Email = p_Email INTO @UID;
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @UID INTO @MID;
		IF @err=0 THEN
		-- Die Mitarbeiter_ID wurde gefunden, welche zwingend Vorraussetzung für die Administratorrechte sind
		-- Der Administrator wird nun aus der administrator-Tabelle gelöscht
		DELETE FROM administrator WHERE Mitarbeiter_ID = @MID;
		SET @ret=1;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END
//
DELIMITER ;