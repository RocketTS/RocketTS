DELIMITER //
USE rocket;
DROP PROCEDURE IF EXISTS sql_create_Ticket;
CREATE PROCEDURE sql_create_Ticket(p_Email varchar(40), p_Betreff varchar(40), p_Message text, p_AID INT, p_PID INT, p_IP varchar(20), p_OS varchar(20))
BEGIN
	-- Zuerst wird �berpr�ft ob der User, welcher ein Ticket erstellen will �berhaupt existiert
	SELECT sql_exist_User(p_Email) INTO @exist;
	IF @exist = 1 THEN
		-- Die User_ID wird gebraucht um diese in die Tickettabelle mit einzutragen
		SELECT User_ID FROM user WHERE Email=p_Email INTO @uid;
		-- Der Timestamp wird gebraucht um die Verkn�pfung zwischen Ticket und Nachricht herzustellten
		SET @timestamp = now();
		INSERT INTO ticket (Ersteller, Erstelldatum, Betreff, Auswahlkriterien_ID, Prioritaet_ID, IP_Adresse, Betriebssystem) values (@uid, @timestamp, p_Betreff, p_AID, p_PID, p_IP, p_OS);
		SELECT Name	   FROM user WHERE Email=p_Email INTO @uName;
		SELECT Vorname FROM user WHERE Email=p_Email INTO @uVorname;
		SELECT CONCAT (@uName, ' ', @uVorname) INTO @Fullname;
		-- Generiert einen String mit "Vorname Nachname"
		SELECT Ticket_ID FROM ticket WHERE Erstelldatum=@timestamp INTO @TicketID;
		-- Trage die Nachricht in die message-Tabelle ein
		INSERT INTO message (Ersteller, Erstelldatum, Inhalt) values (@Fullname, @timestamp, p_Message);
		SELECT Message_ID FROM message WHERE Erstelldatum=@timestamp INTO @MessageID;
		-- Verkn�pfe das erstellte Ticket mit der dazugeh�rigen Nachricht in der tm-Tabelle
		INSERT INTO tm (Ticket_ID, Message_ID) values (@TicketID, @MessageID);
		SET @ret=1;
	ELSE
		SET @ret=0;
	END IF;
END //
DELIMITER ;