USE accidents;

-- View for Accidents by the Day of the week
DROP VIEW IF EXISTS accident_severity_by_days;
CREATE VIEW accident_severity_by_days AS
SELECT 'Monday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '2'
GROUP BY Severity
UNION
SELECT 'Tuesday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '3'
GROUP BY Severity
UNION
SELECT 'Wednesday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '4'
GROUP BY Severity
UNION
SELECT 'Thursday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '5'
GROUP BY Severity
UNION
SELECT 'Friday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '6'
GROUP BY Severity
UNION
SELECT 'Saturday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '7'
GROUP BY Severity
UNION
SELECT 'Sunday' AS DayOfTheWeek, count(accident_index) AS NumberOfAccidents, accident_severity AS Severity
FROM accident
WHERE day_of_the_week = '1'
GROUP BY Severity
ORDER BY Severity DESC;


-- Materialized View
DROP TABLE IF EXISTS accident_severity_by_days_table;
CREATE TABLE accident_severity_by_days_table AS
	SELECT * FROM accident_severity_by_days;
    
SELECT * FROM accident_severity_by_days_table;


-- Stored procedure for updating the materialized view with event scheduler
-- (1) Stored procedure
DROP PROCEDURE IF EXISTS refresh_accident_by_day;

Delimiter //

CREATE PROCEDURE refresh_accident_by_day()
BEGIN
	TRUNCATE TABLE accident_severity_by_days_table;
	INSERT INTO accident_severity_by_days_table
	SELECT * FROM accident_severity_by_days;
END //
Delimiter ;

CALL refresh_accident_by_day();
SELECT * FROM accident_severity_by_days_table;

-- (2) Event scheduler

DROP TABLE IF EXISTS mess;
CREATE TABLE mess (message VARCHAR(300));
TRUNCATE mess;

SET GLOBAL event_scheduler = ON;
SHOW VARIABLES LIKE "event_scheduler";

Delimiter $$

CREATE EVENT refresh_accident_by_days
ON SCHEDULE EVERY 1 HOUR
STARTS current_timestamp
ENDS current_timestamp + INTERVAL 5 HOUR
DO
	BEGIN
		INSERT mess SELECT concat('event:',NOW());
        CALL refresh_accident_by_days();
	END $$
Delimiter ;

SELECT * FROM mess;
SHOW EVENTS;
DROP EVENT IF EXISTS refresh_accident_by_days;