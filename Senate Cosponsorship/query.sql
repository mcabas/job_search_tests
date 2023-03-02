-- Create table congress full

-- This file can be run via  $ sqlite3; .read 114_congress_prep.sql

--.mode csv
--.import 114_congress_full.csv congress_full

CREATE TABLE cosponsors AS
  SELECT DISTINCT
    sponsor.bill_number AS bill_number,
    sponsor.name AS sponsor_name,
    sponsor.state AS sponsor_state,
    cosponsor.name AS cosponsor_name,
    cosponsor.state AS cosponsor_state
  FROM congress_full sponsor
  JOIN congress_full cosponsor
    ON sponsor.bill_number = cosponsor.bill_number
    AND sponsor.sponsor = 'TRUE'
    AND cosponsor.original_cosponsor = 'TRUE'
    AND sponsor.bill_number LIKE 's%'
    AND cosponsor.bill_number LIKE 's%'
;

--DROP TABLE congress_full;

--.save 114_congress_small.db

-- check tables

SELECT *
FROM cosponsors
LIMIT 5

--- https://selectstarsql.com/questions.html#senate_cosponsorship
--- interview question

---Senate Cosponsorship Dataset. Authored by: Kao

---In this section, we introduce a new dataset from the 114th session of Congress 
---(2015-2016) compiled by James Fowler and others. I reworked the dataset to allow us 
---to study cosponsoring relationships between senators.

---The senator who introduces the bill is called the “sponsor”. Other senators can show 
---their support by cosponsoring the bill. Cosponsors at the time of introduction are called 
---“original cosponsors” (Source). Each row of the table shows the bill, the sponsor, an 
---original cosponsor, and the states the senators represent. Note that there can be multiple
---cosponsors of a bill.

-- 0. Have a look at the dataset.
-- At 15K rows, it's a little larger than the Texas dataset so best to avoid printing everything out.

SELECT * 
FROM cosponsors 
LIMIT 3

-- 1. Find the most networked senator. That is, the one with the most mutual cosponsorships.
-- A mutual cosponsorship refers to two senators who have each cosponsored a bill sponsored
-- by the other. Even if a pair of senators have cooperated on many bills, the relationship 
-- still counts as one.

SELECT
  cosponsor_1.cosponsor_name AS senator_1,
  COUNT(*) AS mutual_cosponsorships
FROM cosponsors AS cosponsor_1
JOIN cosponsors AS cosponsor_2
  ON cosponsor_1.bill_number = cosponsor_2.bill_number
  AND cosponsor_1.cosponsor_name != cosponsor_2.cosponsor_name
GROUP BY cosponsor_1.cosponsor_name, cosponsor_2.cosponsor_name
ORDER BY COUNT(*) DESC
LIMIT 3;

-- 2. Now find the most networked senator from each state. 
-- If multiple senators tie for top, show both. Return columns corresponding to state, 
-- senator and mutual cosponsorship count.

SELECT c.cosponsor_state AS state, c.cosponsor_name AS senator, COUNT(DISTINCT c2.cosponsor_name) AS mutual_cosponsorships
FROM cosponsors c
JOIN (
    SELECT cosponsor_state, MAX(mutual_cosponsorships) AS max_mutual_cosponsorships
    FROM (
        SELECT cosponsor1.cosponsor_state, cosponsor1.cosponsor_name, COUNT(DISTINCT cosponsor2.cosponsor_name) AS mutual_cosponsorships
        FROM cosponsors AS cosponsor1
        JOIN cosponsors AS cosponsor2 ON cosponsor1.bill_number = cosponsor2.bill_number
                                     AND cosponsor1.cosponsor_name != cosponsor2.cosponsor_name
                                     AND cosponsor1.cosponsor_state = cosponsor2.cosponsor_state
                                     AND cosponsor1.sponsor_name != cosponsor2.cosponsor_name
        GROUP BY cosponsor1.cosponsor_state, cosponsor1.cosponsor_name
    )
    GROUP BY cosponsor_state
) m ON c.cosponsor_state = m.cosponsor_state
   AND COUNT(DISTINCT c.cosponsor_name, c.sponsor_name) = m.max_mutual_cosponsorships
GROUP BY c.cosponsor_state, c.cosponsor_name
ORDER BY c.cosponsor_state, mutual_cosponsorships DESC;

-- 3. Find the senators who cosponsored but didn't sponsor bills.
--this is working
SELECT DISTINCT cosponsor_name
FROM cosponsors
WHERE cosponsor_name NOT IN (SELECT sponsor_name
	  FROM cosponsors)
LIMIT 5

