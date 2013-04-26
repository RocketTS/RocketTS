DELIMITER //
DROP PROCEDURE IF EXISTS sql_update_AccessRights;
CREATE PROCEDURE sql_update_AccessRights(p_User_ID INT, p_alt varchar(20),p_neu varchar(20), p_Level INT, p_Abteilung INT)
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	-- aendern der Zugriffsrechte, nach Gruppe unterschieden
	-- wenn altes Recht = User
	IF (p_alt = "User" && (@err=0)) THEN
		INSERT INTO mitarbeiter VALUES (NULL,p_User_ID,p_Level,p_Abteilung);
	END IF;
	-- Upgrade Mitarbeiter zu Administrator
	IF ((@err=0) && (p_alt = "Mitarbeiter") ) THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		IF (p_neu = "Administrator") THEN
			INSERT INTO administrator VALUES (NULL,@MID);
		END IF;
		UPDATE mitarbeiter SET Level = p_Level, Abteilung_ID = p_Abteilung WHERE Mitarbeiter_ID = @MID;
	END IF;
	-- Degradierung von Admin zu Mitarbeiter
	IF (@err=0) && (p_alt = "Administrator" && p_neu = "Mitarbeiter") THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		DELETE FROM administrator WHERE Mitarbeiter_ID = @MID;
		UPDATE mitarbeiter SET Level = p_Level, Abteilung_ID = p_Abteilung WHERE Mitarbeiter_ID = @MID;
	END IF;
	SET @ret=1;
END //
DELIMITER ;