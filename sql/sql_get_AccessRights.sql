DELIMITER //
DROP PROCEDURE IF EXISTS sql_get_AccessRights;
CREATE PROCEDURE sql_get_AccessRights(p_Email varchar(40))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
	-- Ueberpruefung ob Benutzer ueberhaupt existiert
	SELECT User_ID FROM user WHERE Email = p_Email INTO @uid;
	
	IF (@uid >= 1) && (@err=0) THEN	
		-- Benutzer existiert in der Usertabelle => User-Rechte
		SET @ret="User";
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = @uid INTO @mid;
		IF (@mid >= 1) && (@err=0) THEN
			-- Benutzer existiert in der Mitarbeitertabelle => Mitarbeiter-Rechte
			SELECT Administrator_ID FROM administrator WHERE Mitarbeiter_ID = @mid INTO @aid;
			IF (@aid >= 1) && (@err=0)THEN
				-- Benutzer existiert in der Admintabelle => Admin-Rechte
				SET @ret="Administrator";
			ELSE
				SET @ret="Mitarbeiter";
			END IF;
		END IF;
	ELSE
		SET @ret="None";
	END IF;
END //
DELIMITER ;