# DE1 Term1: Road Safety in the United Kingdom in 2015
The dataset was derived from The UK Department of Transport [(link)](https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data).
## Operational layer
The data has records on 140056 accidents in the United Kingdom for 2015. The dataset contains two tables: *Accidents* and *Vehicles*. The following 3 variables were chosen from *Accidents.csv* for the analysis: accident_index, accident_severity, day_of_the_week, weather; and 6 variables from *Vehicles.csv*: accident_index, vehicle_type, left_hand, gender_of_driver, age_of_driver, age_vehicle.
Additionally, *vehicle_types.csv* and *weather_types.csv* were created with the help of *Road-Accident-Safety-Data-Guide* for the future matching of the actual categories with their numerical values in the *accident* and *vehicle* tables.
The EER diagram demonstrates the relationship between 4 tables (accident, vehicles, vehicle_types, weather_types).

![EER](https://github.com/alimadt/data_engineering_1/blob/master/Term1/eer.png)
