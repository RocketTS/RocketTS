DELIMITER //
DROP PROCEDURE IF EXISTS sql_answer_Ticket;
CREATE PROCEDURE sql_answer_Ticket(p_Email varchar(40), p_TicketID INT, p_Message text)
BEGIN
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN	
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		SET @timestamp = now();
		-- Auslesen des Vor- und Nachnamens und Zusammensetzung zum String
		SELECT Name	   FROM user WHERE Email=p_Email INTO @uName;
		SELECT Vorname FROM user WHERE Email=p_Email INTO @uVorname;
		SELECT CONCAT (@uName, ' ', @uVorname) INTO @Fullname;
		-- Erzeugt neue Nachricht in der Datenbank
		INSERT INTO message (Ersteller, Erstelldatum, Inhalt) values (@Fullname, @timestamp, p_Message);
		-- ermittelt Message_ID der erzeugten Nachricht per Timestamp
		SELECT Message_ID FROM message WHERE Erstelldatum=@timestamp INTO @MessageID;
		-- stellt Verknüpfung zwischen Ticket und neuer Nachricht her
		INSERT INTO tm (Ticket_ID, Message_ID) values (p_TicketID, @MessageID);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
	
END
//
DELIMITER ;