DROP SCHEMA IF EXISTS accidents;
CREATE SCHEMA accidents;
USE accidents;

-- Vehicles
DROP TABLE IF EXISTS vehicles;
CREATE TABLE vehicles(
	accident_index VARCHAR(13),
    vehicle_type VARCHAR(50),
    left_hand VARCHAR(1),
    gender_of_driver VARCHAR(1),
    age_of_driver INT,
    age_of_vehicle INT,
    PRIMARY KEY(accident_index)
);

TRUNCATE vehicles;
show variables like "secure_file_priv";
SET GLOBAL local_infile= 'on';
show variables like "local_infile";

LOAD DATA LOCAL INFILE 'C:\\Users\\Admin\\Desktop\\DE1\\Term_1\\Vehicles.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @col3, @dummy, @col4, @col5, @dummy, @dummy, @dummy, @col6, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2, left_hand=@col3, gender_of_driver=@col4, age_of_driver=@col5, age_of_vehicle=@col6; 


-- Accidents
DROP TABLE IF EXISTS accident;
CREATE TABLE accident(
	accident_index VARCHAR(13),
    accident_severity INT,
    day_of_the_week INT,
    weather INT,
    PRIMARY KEY(accident_index)
);

TRUNCATE accident;
show variables like "secure_file_priv";
SET GLOBAL local_infile= 'on';
show variables like "local_infile";

LOAD DATA LOCAL INFILE 'C:\\Users\\Admin\\Desktop\\DE1\\Term_1\\Accidents.csv'
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @col3, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @col4, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2, day_of_the_week=@col3, weather=@col4;


-- Vehicle types
DROP TABLE IF EXISTS vehicle_types;
CREATE TABLE vehicle_types(
	vehicle_code INT,
    vehicle_type VARCHAR(50),
	PRIMARY KEY(vehicle_code)
);

TRUNCATE vehicle_types;
show variables like "secure_file_priv";
SET GLOBAL local_infile= 'on';
show variables like "local_infile";

LOAD DATA LOCAL INFILE 'C:\\Users\\Admin\\Desktop\\DE1\\Term_1\\vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Weather
DROP TABLE IF EXISTS weather_types;
CREATE TABLE weather_types(
	weather_code INT,
    weather_type VARCHAR(50),
    PRIMARY KEY(weather_code)
);

TRUNCATE weather_types;
show variables like "secure_file_priv";
SET GLOBAL local_infile= 'on';
show variables like "local_infile";

LOAD DATA LOCAL INFILE 'C:\\Users\\Admin\\Desktop\\DE1\\Term1\\weather_types.csv'
INTO TABLE weather_types
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
