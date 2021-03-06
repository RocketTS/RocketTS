DELIMITER //
DROP PROCEDURE IF EXISTS sql_insert_User;
CREATE PROCEDURE sql_insert_User(p_Name varchar(20), p_Vorname varchar(20), p_Email varchar(40), p_Passwort varchar(100))
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 0 THEN	
		-- legt einen neuen Benutzer an
		INSERT INTO user (Name, Vorname, Email, Passwort) values (p_Name, p_Vorname, p_Email, p_Passwort);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;