# Energy Consumption & Emissions Analysis using MySQL

## Project Overview
This project focuses on analyzing global energy consumption, energy production, GDP, population, and carbon emissions across different countries and years using **MySQL**.

The objective is to explore energy-related trends, identify major contributors to carbon emissions, compare energy production and consumption, and understand the relationship between economic growth, population, and energy usage.

## Objectives
- Analyze country-wise carbon emissions and identify major emission contributors.
- Compare energy production and consumption across countries and years.
- Examine GDP and population trends in relation to energy usage.
- Calculate per-capita energy consumption and emissions.
- Identify changes in energy consumption and emission patterns over time.

## Database Structure
The project uses six interconnected tables:

| Table Name | Description |
|---|---|
| Country | Country IDs and country names |
| Emission | Energy types, yearly emissions and per-capita emissions |
| Population | Country-wise population data |
| Production | Energy production by country and year |
| GDP | Country-wise GDP data |
| Consumption | Energy consumption by country and year |

## SQL Concepts Used
- Database creation and table relationships
- Primary Keys and Foreign Keys
- INNER JOIN and multi-table JOINs
- Aggregate Functions (SUM, AVG, MAX)
- GROUP BY and ORDER BY
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions (LAG)
- Filtering and sorting using WHERE and LIMIT
- Per-capita and ratio calculations

## Key Business Questions Explored
1. Which countries have the highest carbon emissions?
2. Which energy sources contribute most to total emissions?
3. How do energy production and consumption compare across countries?
4. How have global emissions changed over the years?
5. What are the GDP trends across different countries?
6. How does population relate to total emissions?
7. How has energy consumption changed in major economies?
8. What is the average yearly change in per-capita emissions?
9. What is the energy consumption per capita across countries?
10. Which countries have the highest energy consumption relative to GDP?

## Key Insights & Findings

- **Coal and Coke:** Recorded approximately 63,945 MMtonnes of emissions, making it the largest contributor in the analyzed dataset.
- **Petroleum and Other Liquids:** Contributed approximately 47,297 MMtonnes of emissions.
- **Natural Gas:** Accounted for approximately 31,469 MMtonnes of emissions.
- **United States:** Energy consumption ranged between 106 and 112 units from 2020 to 2023.
- **United Kingdom:** Energy consumption ranged between 7 and 8 units during the same period.

*Note: Emission figures represent the analyzed dataset period. Energy consumption units should be interpreted according to the source dataset.*

## Tools & Technologies
- **Database:** MySQL
- **Query Language:** SQL
- **Environment:** MySQL Workbench

## Project Workflow
1. Created the database and six relational tables.
2. Established table relationships using foreign keys.
3. Explored the datasets and examined available year ranges.
4. Developed SQL queries to answer analytical questions.
5. Applied joins, aggregations, subqueries and window functions.
6. Interpreted query results to identify meaningful insights.

## Conclusion
This project provided practical experience in relational database management and SQL-based data analysis. It helped develop skills in querying multiple datasets, performing comparative analysis, identifying trends, and extracting insights from structured data.
