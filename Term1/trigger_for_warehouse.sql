USE accidents;

-- Creating trigger for data warehouse
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (message VARCHAR(300));
TRUNCATE messages;

DROP TRIGGER IF EXISTS after_accident_insert; 

DELIMITER $$

CREATE TRIGGER after_accident_insert
AFTER INSERT
ON accident FOR EACH ROW
BEGIN
	INSERT INTO messages SELECT CONCAT('new accident_index: ', NEW.accident_index);

  	INSERT INTO accident_analysis
	SELECT
	accident.accident_index,
	accident.accident_severity AS 'Severity',
	accident.day_of_the_week AS 'DayOfTheWeek',
    
    vehicles.left_hand AS 'LeftHand',
    vehicles.gender_of_driver AS 'GenderOfDriver',
    vehicles.age_of_driver AS 'AgeOfDriver',
    vehicles.age_of_vehicle AS 'AgeOfVehicle',
    
    vehicle_types.vehicle_type AS 'VehicleType',
    
    weather_types.weather_type AS 'Weather'

	FROM accident
	INNER JOIN vehicles using(accident_index)
	INNER JOIN vehicle_types ON vehicles.vehicle_type = vehicle_types.vehicle_code
    INNER JOIN weather_types ON accident.weather = weather_types.weather_code;
        
END $$

DELIMITER ;

SELECT * FROM accident_analysis ORDER BY accident_index desc;

INSERT INTO vehicles VALUES('2015984141417','9','1','2','26','10');
INSERT INTO accident VALUES('2015984141417','1','7','9');

SELECT * FROM accident_analysis WHERE accident_index='2015984141417';
SELECT * FROM messages;