DELIMITER //
DROP PROCEDURE IF EXISTS sql_del_Message;
CREATE PROCEDURE sql_del_Message(p_MessageID INT)
BEGIN
	-- Procedure nur zu administrativer Verwendung bestimmt!!
	-- entfernt zuerst Tupel mit Fremdschluesselbeziehung
	DELETE FROM tm WHERE Message_ID = p_MessageID;
	-- danach die eigentliche Nachricht
	DELETE FROM message WHERE Message_ID = p_MessageID;
END //
DELIMITER ;