DELIMITER //
DROP PROCEDURE IF EXISTS sql_update_AccessRights;
CREATE PROCEDURE sql_update_AccessRights(p_User_ID INT, p_alt varchar(20),p_neu varchar(20))
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @err=1;
	SET @err=0;
		
	IF (p_alt = "User" && (@err=0)) THEN
		INSERT INTO mitarbeiter VALUES (NULL,p_User_ID,1,99);
	END IF;
	
	IF ((@err=0) && (p_alt = "Mitarbeiter" || p_neu="Administrator") ) THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		INSERT INTO administrator VALUES (NULL,@MID);
	END IF;
		
	IF (@err=0) && (p_alt = "Administrator") THEN
		SELECT Mitarbeiter_ID FROM mitarbeiter WHERE User_ID = p_User_ID INTO @MID;
		DELETE FROM administrator WHERE Mitarbeiter_ID = @MID;
	END IF;
	SET @ret=1;
END
//
DELIMITER ;