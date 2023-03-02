-- Test: STAFFING ABROAD | SQL Data Analyst process technical questions

-- Q1

-- 1. Create tables

--create table application table and merchant table

CREATE TABLE application_table
(applicationid integer,
merchantid integer,
applicationdate timestamp
);

CREATE TABLE merchant_table
(merchantid integer,
businessname varchar
);

-- 2. import data into the tables
--Step 1. Refresh Database
--Step 2. Go to the application_table table and click to open import/export, in options select import, and look for the application_table.csv file in downloads, update header as ‘yes’ and delimiter as ‘,’, then go to the columns tab and validate that all columns are selected.
--Step 3. Click on OK.
--Step 4. Repeat steps for the merchant_table.csv.

-- 3. Question: Please construct SQL queries to answer the two questions below:

-- 3.1. how many applications were receives from each merchant between 2019-10-28 and 2019-10-31?

SELECT 	COUNT(*) AS Number_of_applications,
		merchantid 
FROM application_table
WHERE applicationdate > '2019-10-28 00:00:00' AND applicationdate < '2019-10-31 00:00:00'
GROUP BY merchantid

-- 3.2. what are the top three merchant names by applications received between 2019-10-28 and 2019-10-31?

SELECT 	COUNT(*) AS Number_of_applications,
		me.businessname	
FROM application_table AS ap
INNER JOIN merchant_table AS me ON ap.merchantid = me.merchantid
WHERE applicationdate > '2019-10-28 00:00:00' AND applicationdate < '2019-10-31 00:00:00'
GROUP BY me.businessname
ORDER BY Number_of_applications DESC
LIMIT 3

-- Q2

-- 1. Create Loan_status table

CREATE TABLE loan_status
(loannumber integer,
ach_yn integer,
daysonfile integer,
reportdate timestamp
);

-- 2. import data into the tables
--Step 1. Refresh Database
--Step 2. Go to the loan_status table and click to open import/export, in options select import, and look for the loan_status.csv file in downloads, update header as ‘yes’ and delimiter as ‘,’, then go to the columns tab and validate that all columns are selected.
--Step 3. Click on OK.

-- Here is a table containing ACH status of loans from 10-24-2019 to 10-31-2019. “ach_yn” is the flag for
-- the daily ACH status of a loan (1 = Yes, 0 = No). “ach_yn” = 1 means the borrower has an active
-- automatic payment on that day.

-- 	• When “ach_yn” changes from 0 to 1 between two consecutive days, the loan has enrolled in
--		ACH (enrollment).
--	• When “ach_yn” changes from 1 to 0 between two consecutive days, the loan has stopped
--		enrolling in ACH.

--	Question: Please construct SQL queries to answer the two questions below::
-- 		• how many enrollments happened within this time period (10-24-2019 to 10-31-2019)?

WITH CTE_Loan AS (
	SELECT 	loannumber,
			reportdate,
			ach_yn,
			daysonfile,
			CASE WHEN ach_yn - lag(ach_yn) over (PARTITION BY loannumber order by loannumber, reportdate) > 0 
					AND daysonfile - lag(daysonfile) over (PARTITION BY loannumber order by loannumber, reportdate) = 1 THEN 'enrolled in ACH'
				 WHEN ach_yn < 0 
			 		AND daysonfile - lag(daysonfile) over (PARTITION BY loannumber order by loannumber, reportdate) = 1 THEN 'stopped enrolling in ACH'
			 	ELSE 'No changes' 
			END AS ach_enroll_status
		
	FROM loan_status
	WHERE reportdate >= '2019-10-24 00:00:00' AND reportdate <= '2019-10-31 00:00:00'
	GROUP BY reportdate, ach_yn, daysonfile, loannumber
	ORDER BY loannumber, reportdate
)
SELECT COUNT(*) AS Number_of_enrollments
FROM CTE_Loan 
WHERE ach_enroll_status = 'enrolled in ACH'

--		• how many enrollments happened in each day (“reportdate”) between 10-24-2019 to 10-31-
--		2019?

WITH CTE_Loan AS (
	SELECT 	loannumber,
			reportdate,
			ach_yn,
			daysonfile,
			CASE WHEN ach_yn - lag(ach_yn) over (PARTITION BY loannumber order by loannumber, reportdate) > 0 
					AND daysonfile - lag(daysonfile) over (PARTITION BY loannumber order by loannumber, reportdate) = 1 THEN 'enrolled in ACH'
				 WHEN ach_yn < 0 
			 		AND daysonfile - lag(daysonfile) over (PARTITION BY loannumber order by loannumber, reportdate) = 1 THEN 'stopped enrolling in ACH'
			 	ELSE 'No changes' 
			END AS ach_enroll_status
		
	FROM loan_status
	WHERE reportdate >= '2019-10-24 00:00:00' AND reportdate <= '2019-10-31 00:00:00'
	GROUP BY reportdate, ach_yn, daysonfile, loannumber
	ORDER BY loannumber, reportdate
)
SELECT 	reportdate,
		CASE WHEN ach_enroll_status = 'enrolled in ACH' THEN +1 
		ELSE 0
		END AS Number_of_enrollments

FROM CTE_Loan 
GROUP BY reportdate, ach_enroll_status
ORDER BY reportdate