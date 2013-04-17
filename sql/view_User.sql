DROP VIEW IF EXISTS view_User;
DELIMITER //
CREATE VIEW view_User AS
	SELECT User_ID, Name, Vorname, Email, Passwort,SESSION_ID,CALL sql_get_AccessRights(Email) from user;
//	
DELIMITER ;