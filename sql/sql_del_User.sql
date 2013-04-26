DELIMITER //
DROP PROCEDURE IF EXISTS sql_del_User;
CREATE PROCEDURE sql_del_User(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	-- Zuerst wird wieder überprüft ob der User überhaupt im System existiert
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		-- Es wird die User_ID benötigt um eine korrekte Löschung in der Tabelle user vorzunehmen
		SELECT User_ID FROM user WHERE Email = p_Email INTO @UID;
		IF @err=0 THEN
		DELETE FROM user WHERE User_ID = @UID;
		SET @ret=1;
		END IF;
	ELSE
		SET @ret=0;
	END IF;
	
END
//
DELIMITER ;