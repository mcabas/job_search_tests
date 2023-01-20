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

--Which are the retailers that got to be included in the TOP 10 for 2017, 2018 and 2019?

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

--Get a list of the retailers that are included in the TOP 20 in 2017 and 2019, broken down in alphabetical order. 

SELECT
  name, retail_revenue
from (SELECT name, retail_revenue FROM cos2017
	UNION ALL
	SELECT name, retail_revenue FROM cos2019
  	order by retail_revenue desc, name asc
	limit 20) AS cos2017_2019
order by name asc
limit 20

--List the top 15 retailers with the highest retail revenue cagr in 2018

select name, retail_revenue_cagr
from cos2018
WHERE retail_revenue_cagr IS NOT NULL
order by retail_revenue_cagr desc
limit 15

--What is the average retail revenue of retailers in 2017?
select AVG(retail_revenue)
from cos2017

--Get the top 5 retailers by market share of retail revenue for retailer with presence in at least 10 countries.

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

--

