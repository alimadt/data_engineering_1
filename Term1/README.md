# DE1 Term1: Road Safety in the United Kingdom in 2015
The dataset was derived from The UK Department of Transport [(link)](https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data).
## Operational layer
The data has records on 140056 accidents in the United Kingdom for 2015 (all the data files can be found [here](https://github.com/alimadt/data_engineering_1/blob/master/Term1/data.zip)). The dataset contains two tables: *Accidents* and *Vehicles*. The following 3 variables were chosen from *Accidents.csv* for the analysis: accident_index, accident_severity, day_of_the_week, weather; and 6 variables from *Vehicles.csv*: accident_index, vehicle_type, left_hand, gender_of_driver, age_of_driver, age_vehicle.
Additionally, *vehicle_types.csv* and *weather_types.csv* were created with the help of *Road-Accident-Safety-Data-Guide* for the future matching of the actual categories with their numerical values in the *accident* and *vehicle* tables (Operational layer can be found [here](https://github.com/alimadt/data_engineering_1/blob/master/Term1/road_safety.sql)).
The EER diagram demonstrates the relationship between 4 tables (accident, vehicles, vehicle_types, weather_types).

![EER](https://github.com/alimadt/data_engineering_1/blob/master/Term1/eer.png)

## A brief analytical plan:
- Load the 4 tables: accident, vehicles, vehicle_types, weather_types.
- Create data warehouse *accident_analysis*.
- Generate 7 views for the created *accident_analysis* data warehouse.

![Plan](https://github.com/alimadt/data_engineering_1/blob/master/Term1/analytical_layer.png)

## Analytical layer
*accident_analysis* data warehouse were created for the analytical layer [(link)](https://github.com/alimadt/data_engineering_1/blob/master/Term1/data_warehouse.sql). It includes 4 dimensions: Accident, Vehicles, Vehicle types and Weather types.
![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/accident_analysis.png)

## Data marts
All the views can be found [here](https://github.com/alimadt/data_engineering_1/blob/master/Term1/data_warehouse.sql).
### View 1: Average severity and number of accidents by vehicle types.
This view was created to find out which vehicle types get into accidents more often, it includes following columns: Vehicle type, Average severity, Number of accidents.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view1.png)

As we can see from the generated *severity_by_types* view, cars get into accidents the most, moreover, the average severity index is also quite high. There are 102484 records for this vehicle type,which is 73% of the all observations. 

### View 2: Average severity and total number of accidents by different types of motorcyles.
View 1 also showed that various types of motorcycles become participants in road accidents often too. Therefore, View 2 demonstrates the Average severity and the total Number of accidents for various types of this vehicle.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view2.png)

The table indicates that accidents with 'Motorcycle 125cc and under' and 'Motorcycle over 500 cc' are more common, however, the most severe cases happen with 'Motorcycle 50cc and under'. 

### View 3: Accidents by left-hand and right-hand vehicles.
The following view aims to identify what vehicles with what wheel side tend to get into accidents more often. 

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view3.png)

The vast majority of accident records (99%) are for right-handed vehicles. The result of the generated table is not surprising, as there is left-hand traffic in the UK.

### View 4: Average severity and total number of accidents by gender.
This view demonstrates the accidents by gender. It includes the Average severity and Number of accidents by 2 genders: Female and Male.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view4.png)

The population of the UK above 15 years old (the age when you can apply for a provisional driving license) in 2015 was around 53 million people [(source)](https://statswales.gov.wales/catalogue/population-and-migration/population/estimates/nationallevelpopulationestimates-by-year-age-ukcountry). Gender distribution in the UK is quite symmetrical [(source)](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/bulletins/annualmidyearpopulationestimates/mid2015), denoting that there were around 26,5 million females and 26,5 million males in 2015. In 2015 68% (18 million) of adult women and 80% (21 million) of adult men in the UK had their driver license [(source)](https://www.statista.com/statistics/314886/percentage-of-adults-holding-driving-licences-england/), meaning that out of all 39 million people with license 46% are females and 54% are males.
Despite the almost equal number of women and men who can drive, 66% of accidents had males as drivers.

### View 5: Average age, mean severity and total accidents by different age groups.
View 5 intended to show statistics on accidents by different age groups.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view5.png)

Young adults (people under 40) tend to get into accidents much more often (60% of all cases), and the average severity is also the highest for this age group.

### View 6: Average age, mean severity and total accidents by different car classifications.
As the category 'Car' was the one with the most records the View 6 which aims to show the distribution of accidents and their severity by age classification was created.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view6.png)

73% of cases involved cars which were under 20 years, moreover, the average severity of accidents is also rather high.

### View 7: Average severity by weather conditions.
This view was generated, as weather conditions can be a strong driver for the higher possibility of severe road accident.

![](https://github.com/alimadt/data_engineering_1/blob/master/Term1/pictures%20for%20views/view7.png)

As we can see from the table, weather indeed affects the situation on the road, as 'Snowing', 'Other', and 'Raining' have the most accident cases with high average values of the severity of cases.

## Extra points:
### 1) Materialized view + Event scheduler [(link)](https://github.com/alimadt/data_engineering_1/blob/master/Term1/materialized_view.sql)
For the first step, I created a View that shows the total number of accidents by the days of the week grouped by the severity of the cases. Then I generated a materialized view *accident_severity_by_days_table* and added an event that refreshes this table.

### 2) Trigger for data warehouse [(link)](https://github.com/alimadt/data_engineering_1/blob/master/Term1/trigger_for_warehouse.sql)
I created a trigger which is activated if an insert is executed into *accident* table. Once triggered it will insert a new line into previously generated data warehouse.


