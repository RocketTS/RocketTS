DELIMITER //
DROP FUNCTION IF EXISTS sql_valid_Login;
CREATE FUNCTION sql_valid_Login(u varchar(40), p varchar(100)) RETURNS BOOL
BEGIN
	DECLARE v INT;
	DECLARE r BOOL;
	-- Benutzerauthentifizierung
	SELECT COUNT(EMail) INTO v FROM user WHERE EMail=u AND Passwort=p;
	IF v=1 THEN 
		SET r = TRUE;
	ELSE
		SET r = FALSE;
	END IF;
	-- liefert booleschen Wert
	RETURN r;
END //
DELIMITER ;