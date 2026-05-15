create database washing_machine;

create table washing_machine.ws1
(
Price_Indian int,	
Ratings	int,
Brand_Name varchar(15),	
Model_Name	varchar(20),
Washing_Capacity varchar(10),	
Color varchar(15),
Maximum_Spin_Speed varchar(30),
Function_Type varchar(30),
Inbuilt_Heater	varchar(5),
Washing_Method varchar(15)
);

select count(*)
from washing_machine.ws0;

create table washing_machine.washing
like washing_machine.ws0;

insert into washing_machine.washing
select*
from washing_machine.ws0;

select * from washing_machine.washing;

use washing_machine;
select *
from washing;
 -- •	What are the distinct brands available in the dataset?
 select distinct Brand_Name
 from washing;
 
 -- •	What is the average price of washing machines brands?
 select Brand_Name, round(avg(Price_Indian), 2) as brands_avg_price
 from washing
 group by Brand_Name;
 
 -- •	How many models have an inbuilt heater?
 select Count(*) as Have_inbuilt_heater
 from washing
 where Inbuilt_Heater = 'Yes';
 
 -- •	What are the different washing methods listed?
 select distinct Washing_Method
 from washing;
 
 -- •	What is the maximum spin speed recorded in the dataset
SELECT MAX(CAST(REPLACE(Maximum_Spin_Speed, ' RPM', '') AS UNSIGNED)) AS Max_Spin_Speed
FROM washing;

-- •	What is the average rating by brand?
select Brand_Name, round(avg(Ratings),2) as avg_rating
from washing
group by Brand_Name
order by avg_rating desc;

-- •	What is the average price grouped by washing capacity?
select Washing_Capacity, round(avg(Price_Indian),2) as avg_price_capacity
from washing
group by Washing_Capacity
order by Washing_Capacity asc;

-- •	Which function type has the highest average price?
select Function_Type, round(avg(Price_Indian),2) as avg_price
from washing
group by Function_Type
order by avg_price desc
limit 1;
-- •	What are the top 5 cheapest models with spin speed above 1200?
select distinct Model_Name, Price_Indian, Maximum_Spin_Speed
from washing
where Maximum_Spin_Speed > 1200
order by Price_Indian asc;

-- •	Which color of washing machine appears most frequently?
SELECT Color, COUNT(*) AS Color_Count
FROM washing
GROUP BY Color
ORDER BY Color_Count DESC
LIMIT 1;

-- •	Which brand offers the best value for money (lowest price per kg capacity)?
SELECT 
    Brand_Name,
    Model_Name,
    Washing_Capacity,
    Price_Indian,
    ROUND(Price_Indian / Washing_Capacity, 2) AS price_per_kg
FROM washing
ORDER BY price_per_kg ASC
LIMIT 1;

-- •	Which models combine high ratings with low price (top 3)?
SELECT 
    (SELECT AVG(Price_Indian) 
     FROM washing 
     WHERE Inbuilt_Heater = 'Yes') AS avg_price_with_heater,
    (SELECT AVG(Ratings) 
     FROM washing 
     WHERE Inbuilt_Heater = 'Yes') AS avg_rating_with_heater,
    (SELECT AVG(Price_Indian) 
     FROM washing 
     WHERE Inbuilt_Heater = 'No') AS avg_price_without_heater,
    (SELECT AVG(Ratings) 
     FROM washing 
     WHERE Inbuilt_Heater = 'No') AS avg_rating_without_heater;
     
-- •	Which washing method (Front Load vs Top Load) has better average ratings?
SELECT 
    Function_Type,
    AVG(Ratings) AS avg_rating
FROM washing
GROUP BY Function_Type
ORDER BY avg_rating DESC 
limit 1;

-- •	Which brand has the widest range of models across different capacities?
select  distinct Brand_Name, Model_Name,
 Sum(Washing_Capacity) as widest_range
from washing
group by Brand_Name, Model_Name
order by Brand_Name desc, Model_Name desc;

-- •	Rank brands by both average rating and average price to identify premium vs budget players.
SELECT 
    Brand_Name,
    AVG(Ratings) AS avg_rating,
    AVG(Price_Indian) AS avg_price,
    RANK() OVER (ORDER BY AVG(Ratings) DESC) AS rating_rank,
    RANK() OVER (ORDER BY AVG(Price_Indian) DESC) AS price_rank
FROM washing
GROUP BY Brand_Name
ORDER BY price_rank desc, avg_rating desc;


