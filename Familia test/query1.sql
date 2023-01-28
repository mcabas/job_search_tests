--SQL Test
--You were given a data set containing the ranking of the top 250 global retailers. 
--You are asked to answer the following questions both in SQL and Python. 

--For SQL: write the queries that you used to answer each question and add 
--an image of the results. 

--1. Describe the steps you took to have data ready to complete the test.

--create table cos2017
CREATE TABLE cos2017
(rank integer,
name varchar,
country_of_origin varchar,
retail_revenue NUMERIC,
parent_company_revenue NUMERIC,
parent_company_net_income NUMERIC,
dominant_operational_format varchar,
countries_of_operation integer,
retail_revenue_cagr NUMERIC
);

--create table cos2018
CREATE TABLE cos2018
(rank integer,
name varchar,
country_of_origin varchar,
retail_revenue NUMERIC,
parent_company_revenue NUMERIC,
parent_company_net_income NUMERIC,
dominant_operational_format varchar,
countries_of_operation integer,
retail_revenue_cagr NUMERIC
);

--create table cos2019
CREATE TABLE cos2019
(rank integer,
name varchar,
country_of_origin varchar,
retail_revenue NUMERIC,
parent_company_revenue NUMERIC,
parent_company_net_income NUMERIC,
dominant_operational_format varchar,
countries_of_operation integer,
retail_revenue_cagr NUMERIC
);

--Step 4. Refresh Database
--Step 5. Go to the cos2017 table and click to open import/export, in options select import, and look for the cos2017.csv file in downloads, update header as ‘yes’ and delimiter as ‘;’, then go to the columns tab and validate that the 9 columns are selected.
--Step 6. Click on OK.
--Step 7. Repeat steps 4-6 for the cos2018.csv  and cos2019.csv files.

--2. Which are the retailers that got to be included in the TOP 10 for 2017, 2018 and 2019?

--cos2017
select name, retail_revenue
from cos2017
order by retail_revenue desc
limit 10
--cos2018
select name, retail_revenue
from cos2018
order by retail_revenue desc
limit 10
--cos2019
select name, retail_revenue
from cos2019
order by retail_revenue desc
limit 10

--3. Get a list of the retailers that are included in the TOP 20 in 2017 and 2019, broken down in alphabetical order. 

SELECT
  name, retail_revenue
from (SELECT name, retail_revenue FROM cos2017
	UNION ALL
	SELECT name, retail_revenue FROM cos2019
  	order by retail_revenue desc, name asc
	limit 20) AS cos2017_2019
order by name asc
limit 20

--4. List the top 15 retailers with the highest retail revenue cagr in 2018

select name, retail_revenue_cagr
from cos2018
WHERE retail_revenue_cagr IS NOT NULL
order by retail_revenue_cagr desc
limit 15

--5. What is the average retail revenue of retailers in 2017?
select AVG(retail_revenue)
from cos2017

--6. Get the top 5 retailers by market share of retail revenue for retailer with presence in at least 10 countries.

SELECT
  name, retail_revenue, countries_of_operation
from (SELECT name, retail_revenue, countries_of_operation FROM cos2017
	UNION
	SELECT name, retail_revenue, countries_of_operation FROM cos2018
	UNION
	SELECT name, retail_revenue, countries_of_operation FROM cos2019
  	order by retail_revenue desc
	) AS cos2017_2018_2019
where countries_of_operation >= 10
order by retail_revenue desc
limit 5

--7. Which is the % of retailers in the ranking of 2019 that sell in 
--	more than 5 countries?

SELECT (SUM(CASE WHEN countries_of_operation > 5 THEN 1 ELSE 0 END)*100) / (SELECT COUNT(*) FROM cos2019) as percentage
FROM cos2019


-- Investigate queries

--1
SELECT COUNT(*) FROM cos2019
--2
SELECT (SUM(CASE WHEN countries_of_operation > 5 THEN 1 ELSE 0 END)) AS more_than_5 FROM cos2019
--3
SELECT name, countries_of_operation
FROM cos2019
WHERE countries_of_operation > 5
ORDER BY countries_of_operation DESC

--8. Who is the retailer present in more countries in 2019 that also
--	has a revenue higher than the average revenue of all retailers in 2019?

WITH avg_revenue AS (
    SELECT AVG(retail_revenue) as avg_revenue
    FROM cos2019
)
SELECT name, countries_of_operation, retail_revenue
FROM cos2019, avg_revenue
WHERE retail_revenue > avg_revenue AND countries_of_operation = (SELECT MAX(countries_of_operation) FROM cos2019)

--subquery option

SELECT name, countries_of_operation, retail_revenue
FROM cos2019
WHERE retail_revenue > (SELECT AVG(retail_revenue) FROM cos2019) AND countries_of_operation = (SELECT MAX(countries_of_operation) FROM cos2019)

--9. How many retailers have a retail revenue cagr higher than 5%, 
-- 	list them grouping them per year and in descendent order.

SELECT 	year,
		COUNT(*) as count_retailers,
		name,
		retail_revenue_cagr
FROM (
  SELECT '2017' as year, name, retail_revenue_cagr
  FROM cos2017
  WHERE (retail_revenue_cagr*100) > 5
  UNION
  SELECT '2018' as year, name, retail_revenue_cagr
  FROM cos2018
  WHERE (retail_revenue_cagr*100)  > 5
  UNION
  SELECT '2019' as year, name, retail_revenue_cagr
  FROM cos2019
  WHERE (retail_revenue_cagr*100)  > 5
) as retailers_cagr
GROUP BY year, name, retail_revenue_cagr
ORDER BY year, count_retailers DESC, retail_revenue_cagr DESC;


--10. Identify records with nulls in any variable.

--for cos2017
SELECT *
FROM cos2017
WHERE 	rank IS NULL OR
		name IS NULL OR 
		country_of_origin IS NULL OR
		retail_revenue IS NULL OR 
		parent_company_revenue IS NULL OR 
		parent_company_net_income IS NULL OR 
		dominant_operational_format IS NULL OR 
		countries_of_operation IS NULL OR 
		retail_revenue_cagr IS NULL;

--Also, the query can be applied to other tables as well, cos2018 and cos2019.
SELECT *
FROM cos2019
WHERE 	rank IS NULL OR
		name IS NULL OR 
		country_of_origin IS NULL OR
		retail_revenue IS NULL OR 
		parent_company_revenue IS NULL OR 
		parent_company_net_income IS NULL OR 
		dominant_operational_format IS NULL OR 
		countries_of_operation IS NULL OR 
		retail_revenue_cagr IS NULL;

--11. Create a variable to segment retailers by their retail revenue cagr:
-- a.	<0,03 alias A
-- b.	0,031-0,069 alias B
-- c.	>0,07 alias C

SELECT name, retail_revenue_cagr,
CASE
    WHEN retail_revenue_cagr < 0.03 THEN 'A'
    WHEN retail_revenue_cagr BETWEEN 0.031 AND 0.069 THEN 'B'
    WHEN retail_revenue_cagr > 0.07 THEN 'C'
    ELSE 'Not defined'
END as revenue_cagr_segment
FROM cos2017

--Also, the query can be applied to other tables as well, cos2018 and cos2019.

SELECT name, retail_revenue_cagr,
CASE
    WHEN retail_revenue_cagr < 0.03 THEN 'A'
    WHEN retail_revenue_cagr BETWEEN 0.031 AND 0.069 THEN 'B'
    WHEN retail_revenue_cagr > 0.07 THEN 'C'
    ELSE 'Not defined'
END as revenue_cagr_segment
FROM cos2019

-- END OF THE SQL TEST
