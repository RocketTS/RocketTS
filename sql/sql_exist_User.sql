DELIMITER //
DROP FUNCTION IF EXISTS sql_exist_User;
CREATE FUNCTION sql_exist_User(u varchar(40)) RETURNS BOOL
BEGIN
	DECLARE v INT;
	DECLARE r BOOL;
	-- prueft ob User existiert, liefert 1 bei TRUE
	SELECT COUNT(EMail) INTO v FROM user WHERE EMail=u;
	IF v=1 THEN 
		SET r = TRUE;
	ELSE
		SET r = FALSE;
	END IF;
	RETURN r;
END //
DELIMITER ;