CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;

-- 1. country table
CREATE TABLE country (
CID VARCHAR(10) PRIMARY KEY,
Country VARCHAR(100) UNIQUE
);
select* from country;

-- 2. emission_3 table
CREATE TABLE emission_3 (
country VARCHAR(100),
energy_type VARCHAR(50),
year INT,
emission INT,
per_capita_emission DOUBLE,
FOREIGN KEY (country) REFERENCES country(Country)
);
select * from emission_3;
-- 3. population table
CREATE TABLE population (
countries VARCHAR(100),
year INT,
Value DOUBLE,
FOREIGN KEY (countries) REFERENCES country(Country)
);
select*from population;
-- 4. production table
CREATE TABLE production (
country VARCHAR(100),
energy VARCHAR(50),
year INT,
production INT,
FOREIGN KEY (country) REFERENCES country(Country)
);
select*from production;
-- 5. gdp_3 table
CREATE TABLE gdp_3 (
Country VARCHAR(100),
year INT,
Value DOUBLE,
FOREIGN KEY (Country) REFERENCES country(Country)
);
select*from gdp_3;
-- 6. consumption table
CREATE TABLE consumption (
country VARCHAR(100),
energy VARCHAR(50),
year INT,
consumption INT,
FOREIGN KEY (country) REFERENCES country(Country)
);
select * from consumption;
show tables;

SELECT MIN(year), MAX(year) FROM population;

SELECT MIN(year), MAX(year) FROM gdp_3;

SELECT MIN(year), MAX(year) FROM consumption;

SELECT MIN(year), MAX(year) FROM production;

SELECT MIN(year), MAX(year) FROM emission_3;

/*1.What is the total emission per country for the most recent year available?*/
select country,sum(emission) as total_emission 
from emission_3 
where year=(select max(year) from emission_3) 
group by country 
order by total_emission desc;

/*2.What are the top 5 countries by GDP in the most recent year?*/
select country,year, value as gdp from gdp_3 
where year=(select max(year) from gdp_3) 
order by gdp desc limit 5;

/*3.Compare energy production and consumption by country and year*/
select p.country, p.energy, p.year,
p.production, c.consumption 
from production p join consumption c on
p.country=c.country and 
p.energy=c.energy and
p.year=c.year;

/*4.Which energy types contribute most to emissions across all countries?*/
select*from emission_3;
select energy_type,sum(emission) as most_emissions 
from emission_3 
group by energy_type 
order by most_emissions desc;

/*5.How have global emissions changed year over year?*/
select year,sum(emission) as total_emissions from emission_3 group by year order by total_emissions;

/*6.What is the trend in GDP for each country over given years?*/
select * from gdp_3;
select country,year,value as GDP FROM gdp_3 order by country,year;

/*7.How has population growth affected total emissions in each country?*/
select p.countries as country,
p.year,
p.value as population,
sum(e.emission) as total_emission 
from population p join emission_3 e
on p.countries=e.country and
p.year=e.year
group by p.countries, p.year,p.value 
order by p.countries,p.year;

/*8.Has energy consumption increased or decreased over the years for major economies?*/
select c.country, c.year, sum(c.consumption) as total_consumption from consumption c 
where c.country in (select country from gdp_3 
where year=(Select max(year)from gdp_3)
order by value desc)
group by country, year
order by country,year;

/*9.What is the average yearly change in emissions per capita for each country?*/
WITH yearly_change AS (
    SELECT
        country,
        year,
        per_capita_emission,
        per_capita_emission -
        LAG(per_capita_emission) OVER (
            PARTITION BY country
            ORDER BY year
        ) AS yearly_change
    FROM emission_3
)
SELECT
    country,
    AVG(yearly_change) AS avg_yearly_change
FROM yearly_change
GROUP BY country
ORDER BY avg_yearly_change;

-- Ratio & Per Capita Analysis

/*11.What is the emission-to-GDP ratio for each country by year?*/
select g.country,g.year,sum( e.emission)/g.value as emission_to_gdp_ratio
from gdp_3 g join emission_3 e 
on g.country=e.country and
g.year=e.year
group by g.country,g.year,g.value
order by g.country,g.year limit 8;

/*12.What is the energy consumption per capita for each country over the last decade?*/
SELECT
    c.country,
    c.year,
    SUM(c.consumption) / p.Value AS consumption_per_capita
FROM consumption c
JOIN population p
    ON c.country = p.countries
    AND c.year = p.year
WHERE c.year >= (
    SELECT MAX(year) - 9
    FROM consumption
)
GROUP BY c.country, c.year, p.Value
ORDER BY c.country, c.year;

/*13. How does energy production per capita vary across countries?*/
SELECT
    pr.country,
    pr.year,
    SUM(pr.production) / p.Value AS production_per_capita
FROM production pr
JOIN population p
    ON pr.country = p.countries
    AND pr.year = p.year
GROUP BY pr.country, pr.year, p.Value
ORDER BY pr.year,production_per_capita DESC 
limit 9;

/*14. Which countries have the highest energy consumption relative to GDP?*/
SELECT
    c.country,
    c.year,
    SUM(c.consumption) / g.Value AS consumption_to_gdp
FROM consumption c
JOIN gdp_3 g
    ON c.country = g.Country
    AND c.year = g.year
GROUP BY c.country, c.year, g.Value
ORDER BY consumption_to_gdp DESC
limit 8;

/*15.What is the correlation between GDP growth and energy production growth?*/
WITH gdp_growth AS
(
    SELECT
        Country,
        year,
        Value,
        ((Value - LAG(Value) OVER
        (PARTITION BY Country ORDER BY year))
        / LAG(Value) OVER
        (PARTITION BY Country ORDER BY year)) * 100
        AS gdp_growth
    FROM gdp_3
)
SELECT *
FROM gdp_growth;

-- Global Comparisons
-- What are the top 10 countries by population and how do their emissions compare?
SELECT
    p.countries AS country,
    p.Value AS population,
    SUM(e.emission) AS total_emission
FROM population p
JOIN emission_3 e
    ON p.countries = e.country
    AND p.year = e.year
WHERE p.year = (SELECT MAX(year) FROM population)
GROUP BY p.countries, p.Value
ORDER BY population DESC
LIMIT 10;
-- Which countries have improved (reduced) their per capita emissions the most over the last decade?

-- What is the global share (%) of emissions by country?
SELECT
    country,
    SUM(emission) AS total_emission,
    SUM(emission) /
    (
        SELECT SUM(emission)
        FROM emission_3
        WHERE year = (SELECT MAX(year) FROM emission_3)
    ) * 100 AS global_share
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY global_share DESC;

/*.What is the global average GDP, emission, and population by year?*/
SELECT
    year,
    AVG(gdp) AS avg_gdp,
    AVG(emission) AS avg_emission,
    AVG(population) AS avg_population
FROM
(
    SELECT
        g.year,
        g.Country,
        g.Value AS gdp,
        e.emission,
        p.Value AS population
    FROM gdp_3 g
    JOIN emission_3 e
        ON g.Country = e.country
        AND g.year = e.year
    JOIN population p
        ON g.Country = p.countries
        AND g.year = p.year
) x
GROUP BY year
ORDER BY year;
