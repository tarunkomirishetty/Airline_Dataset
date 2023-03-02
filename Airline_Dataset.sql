set sql_mode="";
show databases;
create database ait_580_project;
use ait_580_project;
show tables;
create table afi(recno integer, Year numeric, Month text,   StatesAffected text, Category numeric, Central_Pressure numeric, MaxWind numeric,Name text);
create table afi(tbl text, Year numeric, quarter integer, mkt_fare numeric,
 citymarketid_1 text, citymarketid_2 text, city1 text, 
 city2 text, carairlinerid text, car text, carpax numeric, 
 carpaxshare numeric, caravgshare numeric,
 fareinc_min numeric, fareinc_minpaxsh numeric,
 fareinc_max numeric, fare_inc_maxsh numeric,
 Geocoded_City1 text, Geocoded_City2 text, tbl5pk text);
 show variables like '%secure%';
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airfare Information.csv' into table afi fields terminated by '|' lines terminated by '\n' ignore 1 rows;
select * from afi;
select year,avg(mkt_fare) as avg_mkt_fare,count(car) as count_car,
            sum(carpax) as sum_passengers from afi where Year between 2012 and 2022
            group by year ;
select quarter,avg(mkt_fare) as avg_mkt_fare,count(car) as count_car,
            sum(carpax) as sum_passengers from afi group by quarter;
select car,count(car) as count from afi group by car order by count desc limit 5;
select car,count(carpax) as countofPassengers from afi 
group by car order by countofPassengers desc limit 5;
select * from latlong;
select a.city1,b.lat as lat1,b.long as long1 from afi as a 
left join latlong as b on a.city1=b.city;
