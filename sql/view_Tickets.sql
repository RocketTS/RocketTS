DROP VIEW IF EXISTS view_Tickets;
DELIMITER //
CREATE VIEW view_Tickets AS
	SELECT * FROM ticket	
//	
DELIMITER ;