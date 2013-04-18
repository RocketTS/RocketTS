DELIMITER //

DROP PROCEDURE IF EXISTS sql_update_User;
CREATE PROCEDURE sql_update_User(pUser_ID INT,Name_Neu VARCHAR(20),Vorname_Neu VARCHAR(20), Email_Neu VARCHAR(40))

BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @ret=0;
	UPDATE user SET Name=Name_Neu, Vorname=Vorname_Neu, Email=Email_Neu WHERE User_ID=pUser_ID;
	SET @ret=1;
END
//
DELIMITER ;