USE accidents;

-- Creating data warehouse
DROP PROCEDURE IF EXISTS accident_warehouse;

DELIMITER //

CREATE PROCEDURE accident_warehouse()
BEGIN
	DROP TABLE IF EXISTS accident_analysis;
	CREATE TABLE accident_analysis AS

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
    INNER JOIN weather_types ON accident.weather = weather_types.weather_code

	ORDER BY accident_index;
END //

DELIMITER ;

CALL accident_warehouse();


-- View 1: Average severity and number of accidents by vehicle types.
DROP VIEW IF EXISTS severity_by_types;
CREATE VIEW severity_by_types AS
SELECT VehicleType AS 'Vehicle Type', AVG(Severity) AS 'Average Severity', COUNT(VehicleType) AS 'Number of Accidents'
FROM accident_analysis
GROUP BY 1
ORDER BY 3 desc;

SELECT * FROM severity_by_types;

-- View 2: Average severity and total number of accidents by different types of motorcyles.
DROP VIEW IF EXISTS accidents_by_motorcycles;
CREATE VIEW accidents_by_motorcycles AS
SELECT VehicleType AS 'Vehicle Type', AVG(Severity) AS 'Average Severity', COUNT(VehicleType) AS 'Number of Accidents'
FROM accident_analysis
WHERE VehicleType LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 3 desc;

SELECT * FROM accidents_by_motorcycles;

-- View 3: Accidents by left-hand and right-hand vehicles
DROP VIEW IF EXISTS accidents_by_lefthand;
CREATE VIEW accidents_by_lefthand AS
SELECT 'Left Hand' AS 'Wheel side', AVG(Severity) AS 'Average Severity', COUNT(LeftHand) AS 'Number of Accidents'
FROM accident_analysis
WHERE LeftHand = '2'
UNION
SELECT 'Right hand' AS 'Wheel side', AVG(Severity) AS 'Average Severity', COUNT(LeftHand) AS 'Number of Accidents'
FROM accident_analysis
WHERE LeftHand = '1';

SELECT * FROM accidents_by_lefthand;

-- View 4: Average severity and total number of accidents by gender. 
DROP VIEW IF EXISTS accidents_by_gender;
CREATE VIEW accidents_by_gender AS
SELECT 'Female' AS 'Gender of driver', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE GenderOfDriver = '2'
UNION
SELECT 'Male', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE GenderOfDriver = '1';

SELECT * FROM accidents_by_gender;

-- View 5: Average age, mean severity and total accidents by different age groups.
DROP VIEW IF EXISTS accidents_by_drivers_age;
CREATE VIEW accidents_by_drivers_age AS
SELECT 'Young adults' AS 'Age group', ROUND(AVG(AgeOfDriver)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfDriver < 40
UNION
SELECT 'Middle-aged adults', ROUND(AVG(AgeOfDriver)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfDriver >= 40 AND AgeOfDriver < 60
UNION
SELECT 'Old adults', ROUND(AVG(AgeOfDriver)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfDriver >= 60;

SELECT * FROM accidents_by_drivers_age;

-- View 6: Average age, mean severity and total accidents by different car classifications.
DROP VIEW IF EXISTS accidents_by_cars_age;
CREATE VIEW accidents_by_cars_age AS
SELECT 'Vintage(>85)' AS 'Car classification by years', ROUND(AVG(AgeOfVehicle)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfVehicle >= 85 AND VehicleType = 'Car'
UNION
SELECT 'Antigue(>45)', ROUND(AVG(AgeOfVehicle)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfVehicle > 45 AND AgeOfVehicle <= 85 AND VehicleType = 'Car'
UNION
SELECT 'Classic(>20)', ROUND(AVG(AgeOfVehicle)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfVehicle > 20 AND AgeOfVehicle <= 45 AND VehicleType = 'Car'
UNION
SELECT 'New(<20)', ROUND(AVG(AgeOfVehicle)) AS 'Average age', AVG(Severity) AS 'Average Severity', COUNT(accident_index) AS 'Number of Accidents'
FROM accident_analysis
WHERE AgeOfVehicle <= 20 AND VehicleType = 'Car';

SELECT * FROM accidents_by_cars_age;

-- View 7: Average severity by weather conditions.
SELECT DISTINCT Weather from accident_analysis; 

DROP VIEW IF EXISTS accident_by_weather;
CREATE VIEW accident_by_weather AS
SELECT AVG(Severity) AS 'Average Severity',
    CASE 
        WHEN Weather LIKE 'Fine%'
            THEN 'Fine'
        WHEN  Weather LIKE 'Raining%'
            THEN 'Raining'
		WHEN Weather LIKE 'Snowing%'
			THEN 'Snowing'
		WHEN Weather LIKE 'Fog%'
			THEN 'Fog or mist'
		ELSE 'Other'
    END AS Weather_new   
FROM  accident_analysis
GROUP BY Weather_new
ORDER BY AVG(Severity) desc;

SELECT * FROM accident_by_weather;