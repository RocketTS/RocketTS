DELIMITER //
DROP PROCEDURE IF EXISTS sql_change_Email;
CREATE PROCEDURE sql_change_Email(p_Name varchar(50), p_newEmail varchar(40))
BEGIN
	-- Überprüfe wieder, ob der Benutzer dessen Email geändert werden soll existiert
	SELECT sql_exist_User(p_Name) INTO @exist;
	IF @exist = 1 THEN	
		-- Falls er existiert, führe das Email-Update der User-Tabelle durch
		UPDATE user SET Email=p_newEmail WHERE Email = p_Name;
		SELECT Email from user  WHERE Email = p_newEmail into @passwd;
		-- Nun wird überprüft ob die neue Email tatsächlich gesetzt wurde
		IF @passwd = p_newEmail THEN
		SET @ret=1;
		ELSE
		SET @ret=0;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END
//
DELIMITER ;