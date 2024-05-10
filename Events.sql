USE MIMI;

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS eguneroPremiumMugaEvent;

DELIMITER //
CREATE EVENT IF NOT EXISTS eguneroPremiumMugaEvent
ON SCHEDULE
    EVERY 1 DAY
    STARTS CURRENT_TIMESTAMP
DO
BEGIN
    CALL premiumMugaProcedure();
END //
DELIMITER ;
SHOW EVENTS;
SELECT * FROM information_schema.events WHERE event_name = 'eguneroPremiumMugaEvent';
