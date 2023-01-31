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

-- Q2

-- 1. Create Loan_status table

CREATE TABLE loan_status
(loannumber integer,
ach_yn integer,
daysonfile integer,
reportdate timestamp
);

-- 2. import data into the tables