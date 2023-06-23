--##############################################################################################################################
/*
                                                                                                        ,*                       
                           ,**************,                                                           *******                    
                        ******        .******                                                        .*******                    
                      ******  ******   *******                                                          ***                      
                     *****  .******    *******   ******* ****     **** *******     .***  *******     ****.                       
                     ****  .******   ******** ******* ********  .******* ******   ******** *****,   ******                       
                           ******  *******   ******   *******  .******   ******  *******  ,*****,  ******                        
                          ************      ******   *******   ******   ******. ******    ******  ******                         
                         ***********       ******   .******   ******   ******* ******.   ******  ******   **                     
                        ************       ******  *******  *******   ******  *******  ******* .******  ***                      
                        ****** ******      ******.***************** ****************. *******************                        
                        *****   ******      ******* ****** ***************.  *****,*********    .*****                           
                                 ********       **         *****            ******                                               
                                  **************,         *****.           ******                                                
                                      *****,              *****            *****                                                 
*/
--##############################################################################################################################
--## SQL TEST INTRODUCTION #####################################################################################################
--##############################################################################################################################

--==============================================================================================================================
--==== DISCLAIMER ==============================================================================================================
--==============================================================================================================================
/*
	This test is intended to evaluate your SQL skills and analytical capabilities.

	UDF functions are not allowed. Loop functions are also prohibited.
	The use of multi-stament queries, the creation of temporary tables, the commmon table expression and subqueries are allowed, 
	however, the last one is less desirable.
	
	We will evaluete not only the results set, but the query itself. SQL good pratices are welcome.

    Once your first query run, you will have 48h to finish the test, having your access revoked after that time.

    **** The server wharehouse is programmed to be suspendend 10min after there is no activity due costs reduction ****
*/

--==============================================================================================================================
--==== INSTRUCTIONS ============================================================================================================
--==============================================================================================================================
/*
    You may answer as many questios as you want and feel more comfortable working on. Even if you don't think you will achieve
    the objective of the question, your script and logic will considered an effort. 
    
    Run your answers on the worksheets RESULT_<YOUR_USER>, this file wiil be saved whenever you run a query. Be sure to review 
    it before you close the Snowflake UI, or you may risk losing the test.

    You can also check the Snowflake reference at: https://docs.snowflake.com/en/reference.
    
*/
-- RUN THE FOLLOWING COMMANDS BEFORE YOU START THE QUERY:
    
    USE DATABASE TEST_DB;
    USE ROLE TESTER_ROLE;

--==============================================================================================================================
--==== TABLES LIST =============================================================================================================
--==============================================================================================================================
	
    ----------------------------------------------------------------------------------------------------------------------------
    -- SHOPPER LIST TABLE ------------------------------------------------------------------------------------------------------
	
        SELECT * FROM TEST_DB.TEST_DATA.SHOPPERS;
	/*
	 	Description: contains the list of the shoppers.
	 	
	 	Columns:
		[SHOPPER_ID]: .........	Unique identification of the shopper, is an INTERGER data type.
	*/
    
	----------------------------------------------------------------------------------------------------------------------------
	-- SHOPPER LOG TABLE -------------------------------------------------------------------------------------------------------
	
        SELECT * FROM TEST_DB.TEST_DATA.SHOPPERS_LOG;
	/*
	 	Description: contains the record for each time a shopper made connection. The timestamps fields
	 	are in UTC-0 timezone, the local timezone by IANA standard is 'America/Costa_Rica'.
	 	
	 	Columns:	 	
		[LOG_ID]: .............	Unique identification of the record, is an INTERGER data type; 
		[SHOPPER_ID]: .........	Identification of the shopper, is an INTERGER data type;
		[PHYSICAL_STORE_ID]: ..	Identification of the store, is an INTERGER data type;
		[ACTIVATED_AT_UTC]: ...	Time record when the shopper connected, in UTC-0 timezone, 
								is a TIMESTAMP data type;
		[DEACTIVATED_AT_UTC]: .	Time record when the shopper disconnected, in UTC-0 timezone, 
								is a TIMESTAMP data type.
	*/

    ----------------------------------------------------------------------------------------------------------------------------
	-- SHOPPER SHIFTS TABLE ----------------------------------------------------------------------------------------------------
    
        SELECT * FROM TEST_DB.TEST_DATA.SHOPPERS_SHIFTS;
	/*
		Description: contains the programmed shifts for each shopper. The timestamps fields
	 	are in UTC-0 timezone, the local timezone by IANA standard is 'America/Costa_Rica'.
		
		Columns:
		[SHOPPER_ID]: .........	Identification of the shopper, is an INTERGER data type;
		[PROGRAMMED_SHITFS] ...	Contains the programmed shit for each day,
								is a semi-estructurarted data type, in JSON format.
	*/

    ----------------------------------------------------------------------------------------------------------------------------
	-- ORDERS TABLE ------------------------------------------------------------------------------------------------------------
	
        SELECT * FROM TEST_DB.TEST_DATA.ORDERS;
	/*
		Description: contains the orders done by shopper during the analysed period.
		
		Columns:
		[ORDER_ID]:  ..........	Unique identifier of the order, is an INTERGER data type;
		[PHYSICAL_STORE_ID]: ..	Identification of the store, is an INTERGER data type;
		[SHOPPER_ID]: .........	Identification of the shopper, is an INTERGER data type;
		[STARTED_AT_LOCAL]: ...	Date and hour when the order started begin to be worked on, is a TIMESTAMP data type and the
                                timezone is in the local time;
		[FINISHED_AT_LOCAL]: ..	Date and hour when the order finished being worked on, is a TIMESTAMP data type and the 
                                timezone is in the local time;
		[HAS_DEFECT]: .........	This filed means if the order presents a defect reported by user, is a BOOLEAN data type.
	*/

    ----------------------------------------------------------------------------------------------------------------------------
	-- STORES TABLE ------------------------------------------------------------------------------------------------------------
	
        SELECT * FROM TEST_DB.TEST_DATA.STORES;
	/*
	 	Description: is the list of the physical stores on sample data
	 	
	 	Columns:
	 	[PHYSICAL_STORE_ID]: ..	Unique identifier of the store, is an INTERGER data type;
	 	[STORE_NAME]: .........	The name of the store, is a STRING data type;
	 	[BRAND_ID]: ...........	Identification of the brand of the store, is an INTERGER data type;.
	*/

    ----------------------------------------------------------------------------------------------------------------------------
	-- BRANDS TABLE ------------------------------------------------------------------------------------------------------------
	    
        SELECT * FROM TEST_DB.TEST_DATA.BRANDS;
	/*
		Description: is the list of the stores brands
		
		Columns:
		[BRAND_ID]: ...........	Unique identifier of a store brand, is an INTERGER data type;
		[BRAND_NAME]: .........	Name of the store brand,  is a STRING data type;
	*/

--##############################################################################################################################

--##############################################################################################################################
/*
                                                                                                        ,*                       
                           ,**************,                                                           *******                    
                        ******        .******                                                        .*******                    
                      ******  ******   *******                                                          ***                      
                     *****  .******    *******   ******* ****     **** *******     .***  *******     ****.                       
                     ****  .******   ******** ******* ********  .******* ******   ******** *****,   ******                       
                           ******  *******   ******   *******  .******   ******  *******  ,*****,  ******                        
                          ************      ******   *******   ******   ******. ******    ******  ******                         
                         ***********       ******   .******   ******   ******* ******.   ******  ******   **                     
                        ************       ******  *******  *******   ******  *******  ******* .******  ***                      
                        ****** ******      ******.***************** ****************. *******************                        
                        *****   ******      ******* ****** ***************.  *****,*********    .*****                           
                                 ********       **         *****            ******                                               
                                  **************,         *****.           ******                                                
                                      *****,              *****            *****                                                 
*/
--##############################################################################################################################
--## SQL QUESTIONS #############################################################################################################
--##############################################################################################################################
	
--==============================================================================================================================
--==== QUESTION 1 ==============================================================================================================
--==============================================================================================================================
	/*
		Create an Orders and Shoppers summary table, including the following columns: 
		  [MONTH_REF]: the month based on the day of referece;
		 ,[WEEK_REF]: the week based on the day of reference and starting by mondays;
		 ,[DATE_REF]: the day of reference, based when the order was worked on [STARTED_AT_LOCAL];
		 ,[STORE_NAME]: the name of the store;
		 ,[STORE_BRAND]: the name of the brand;
		 ,[QTY_ORDERS]: total of orders made;
		 ,[QTY_SHOPPERS]: number of unique shopper that made longon at the store on that specific date;
 	*/

-- ANSWER 1 ////////////////////BETTER ANSWER

    USE DATABASE TEST_DB;
    USE ROLE TESTER_ROLE;

-- Create the Orders and Shoppers summary table

-- Create the Orders and Shoppers summary table

SELECT
    DATE_TRUNC('MONTH', o.STARTED_AT_LOCAL) AS MONTH_REF,
    DATE_TRUNC('WEEK', o.STARTED_AT_LOCAL) AS WEEK_REF,
    DATE_TRUNC('DAY', o.STARTED_AT_LOCAL) AS DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME AS STORE_BRAND,
    COUNT(DISTINCT o.ORDER_ID) AS QTY_ORDERS,
    COUNT(DISTINCT o.SHOPPER_ID) AS QTY_SHOPPERS
FROM
    TEST_DB.TEST_DATA.ORDERS o
    JOIN TEST_DB.TEST_DATA.STORES s ON o.PHYSICAL_STORE_ID = s.PHYSICAL_STORE_ID
    JOIN TEST_DB.TEST_DATA.BRANDS b ON s.BRAND_ID = b.BRAND_ID
    JOIN TEST_DB.TEST_DATA.SHOPPERS_LOG sl ON o.SHOPPER_ID = sl.SHOPPER_ID
WHERE
    sl.ACTIVATED_AT_UTC <= o.FINISHED_AT_LOCAL
    AND (sl.DEACTIVATED_AT_UTC IS NULL OR sl.DEACTIVATED_AT_UTC >= o.STARTED_AT_LOCAL)
GROUP BY
    MONTH_REF,
    WEEK_REF,
    DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME;

-- ANSWER 2

WITH OrderCounts AS (
  SELECT
    DATE_TRUNC('month', o.STARTED_AT_LOCAL) AS MONTH_REF,
    DATE_TRUNC('week', o.STARTED_AT_LOCAL) AS WEEK_REF,
    DATE_TRUNC('day', o.STARTED_AT_LOCAL) AS DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME AS STORE_BRAND,
    COUNT(DISTINCT o.ORDER_ID) AS QTY_ORDERS
  FROM
    TEST_DB.TEST_DATA.ORDERS o
    JOIN TEST_DB.TEST_DATA.STORES s ON o.PHYSICAL_STORE_ID = s.PHYSICAL_STORE_ID
    JOIN TEST_DB.TEST_DATA.BRANDS b ON s.BRAND_ID = b.BRAND_ID
  GROUP BY
    MONTH_REF,
    WEEK_REF,
    DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME
),

ShopperCounts AS (
  SELECT
    DATE_TRUNC('month', o.STARTED_AT_LOCAL) AS MONTH_REF,
    DATE_TRUNC('week', o.STARTED_AT_LOCAL) AS WEEK_REF,
    DATE_TRUNC('day', o.STARTED_AT_LOCAL) AS DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME AS STORE_BRAND,
    COUNT(DISTINCT o.SHOPPER_ID) AS QTY_SHOPPERS
  FROM
    TEST_DB.TEST_DATA.ORDERS o
    JOIN TEST_DB.TEST_DATA.STORES s ON o.PHYSICAL_STORE_ID = s.PHYSICAL_STORE_ID
    JOIN TEST_DB.TEST_DATA.BRANDS b ON s.BRAND_ID = b.BRAND_ID
  GROUP BY
    MONTH_REF,
    WEEK_REF,
    DATE_REF,
    s.STORE_NAME,
    b.BRAND_NAME
)

SELECT
  oc.MONTH_REF,
  oc.WEEK_REF,
  oc.DATE_REF,
  oc.STORE_NAME,
  oc.STORE_BRAND,
  oc.QTY_ORDERS,
  sc.QTY_SHOPPERS
FROM
  OrderCounts oc
  JOIN ShopperCounts sc ON oc.MONTH_REF = sc.MONTH_REF
    AND oc.WEEK_REF = sc.WEEK_REF
    AND oc.DATE_REF = sc.DATE_REF
    AND oc.STORE_NAME = sc.STORE_NAME
    AND oc.STORE_BRAND = sc.STORE_BRAND;



--==============================================================================================================================
--==== QUESTION 2 ==============================================================================================================
--==============================================================================================================================
	/*
 		For each day as row, fetch the shopper with highest Defect Rate. Considering the orders with 
 		defect and the total number of order done by the shopper.
 		
 		The rational for Defect rate is: [# orders with defect]/[# total orders]
 		
 		[DATE_REF]: the day of reference, based when the order was worked on [STARTED_AT_LOCAL];
 		[SHOPPER_ID]: the identification of the shoppe;
 		[TOTAL_ORDERS]: number of orders done by the shopper;
 		[DEFECT_RATE]: in percentual, rounded to two decimals.
	*/


-- ANSWER 1

-- try

WITH ShopperOrders AS (
    SELECT
        DATE_TRUNC('day', o.STARTED_AT_LOCAL) AS DATE_REF,
        o.SHOPPER_ID,
        COUNT(*) AS TOTAL_ORDERS,
        COUNT(CASE WHEN o.HAS_DEFECT = TRUE THEN 1 END) AS DEFECT_ORDERS
    FROM
        TEST_DB.TEST_DATA.ORDERS o
    GROUP BY
        DATE_REF,
        o.SHOPPER_ID
),

ShopperDefectRate AS (
    SELECT
        DATE_REF,
        SHOPPER_ID,
        TOTAL_ORDERS,
        DEFECT_ORDERS,
        ROUND((DEFECT_ORDERS * 100.0) / TOTAL_ORDERS, 2) AS DEFECT_RATE
    FROM
        ShopperOrders
),

MaxDefectRate AS (
    SELECT
        DATE_REF,
        MAX(DEFECT_RATE) AS DEFECT_RATE
    FROM
        ShopperDefectRate
    GROUP BY
        DATE_REF
)

SELECT
    sd.DATE_REF,
    sd.SHOPPER_ID,
    sd.TOTAL_ORDERS,
    sd.DEFECT_RATE
FROM ShopperDefectRate sd
JOIN MaxDefectRate md ON sd.DATE_REF = md.DATE_REF AND sd.DEFECT_RATE = md.DEFECT_RATE;

 -- ANSWER 2 ////////////////////BETTER ANSWER

--SELECTED ANSWER
  
WITH ShopperOrders AS (
    SELECT
        DATE_TRUNC('day', o.STARTED_AT_LOCAL) AS DATE_REF,
        o.SHOPPER_ID,
        COUNT(*) AS TOTAL_ORDERS,
        COUNT(CASE WHEN o.HAS_DEFECT = TRUE THEN 1 END) AS DEFECT_ORDERS,
        ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('day', o.STARTED_AT_LOCAL) ORDER BY (COUNT(CASE WHEN o.HAS_DEFECT = TRUE THEN 1 END))::FLOAT / COUNT(*)) AS DEFECT_RANK
    FROM
        TEST_DB.TEST_DATA.ORDERS o
    GROUP BY
        DATE_REF,
        o.SHOPPER_ID
), 

MaxDefectRate AS (
    SELECT
        DATE_REF,
        MAX(DEFECT_RANK) AS MAX_DEFECT_RANK
    FROM
        ShopperOrders
    GROUP BY
        DATE_REF
)

SELECT
    so.DATE_REF,
    so.SHOPPER_ID,
    so.TOTAL_ORDERS,
    ROUND((so.DEFECT_ORDERS * 100.0) / so.TOTAL_ORDERS, 2) AS DEFECT_RATE
FROM
    ShopperOrders so
    JOIN MaxDefectRate md ON so.DATE_REF = md.DATE_REF AND so.DEFECT_RANK = md.MAX_DEFECT_RANK;

--==============================================================================================================================
--==== QUESTION 3 ==============================================================================================================
--==============================================================================================================================
	/*
		Each shopper has a programmed shift available in the SHOPPERS_SHIFTS table. We need to understand the adherence of the 
		shopper connection to the programmed time. This means that only the connected time within the programmed shift wil be 
		counted as valid. If a shopper connects 10 minutes earlier, these 10 minutes are not valid for the  adherence ratio, 
		likewise when the disconnection is after the end of the shift. If a shopper was scheduled to work and there is no time 
		connected, the adherence is 0.
		
		To calculate the adhrence ratio, you have to calculate the total programmed time for the shift and the total valid 
		connected time.
		
		Adherence ratio = [total valid connected time] / [total programmed time].
		
		Build a table calculating for each shopper the adhrence ratio per day.
		
		To keep in mind: the programmed shift is a JSON object.
	*/


-- Write query to inspect the structure of the JSON object  
SELECT * FROM SHOPPERS_SHIFTS LIMIT 5

-- Try a Query to extract information from JSON object 
SELECT
    PARSE_JSON(GET(PROGRAMMED_SHITFS, '2023-03-10')) AS SHIFT_INFO,
    PARSE_JSON(GET(PROGRAMMED_SHITFS, '2023-03-10')):starts_at_utc::timestamp_ntz AS starts_at_utc,
    PARSE_JSON(GET(PROGRAMMED_SHITFS, '2023-03-10')):ends_at_utc::timestamp_ntz AS ends_at_utc
FROM SHOPPERS_SHIFTS
LIMIT 3;

-- Try a Query to flatten array objects (https://docs.snowflake.com/en/user-guide/json-basics-tutorial-flatten)
SELECT
    DATE_TRUNC('day', sl.ACTIVATED_AT_UTC) AS DATE_REF,
    PARSE_JSON(shift_info.value):physical_store_id AS physical_store_id,
    PARSE_JSON(shift_info.value):starts_at_utc::timestamp_ntz AS starts_at_utc,
    PARSE_JSON(shift_info.value):ends_at_utc::timestamp_ntz AS ends_at_utc
FROM
    TEST_DB.TEST_DATA.SHOPPERS_LOG sl
INNER JOIN
    TEST_DB.TEST_DATA.SHOPPERS_SHIFTS ss ON sl.SHOPPER_ID = ss.SHOPPER_ID
CROSS JOIN
    LATERAL FLATTEN(INPUT => PARSE_JSON(TO_VARCHAR(ss.PROGRAMMED_SHITFS))) shift_info
WHERE
    shift_info.key = DATE_TRUNC('day', sl.ACTIVATED_AT_UTC)
  
--SELECTED ANSWER
WITH ShopperAdherence AS (
    SELECT
        DATE_TRUNC('day', sl.ACTIVATED_AT_UTC) AS DATE_REF,
        sl.SHOPPER_ID,
        sl.PHYSICAL_STORE_ID,
        sl.ACTIVATED_AT_UTC,
        sl.DEACTIVATED_AT_UTC,
        PARSE_JSON(TO_VARCHAR(ss.PROGRAMMED_SHITFS)) AS PROGRAMMED_SHITFS,
        PARSE_JSON(shift_info.value):physical_store_id AS physical_store_id_from_json,
        PARSE_JSON(shift_info.value):starts_at_utc::timestamp_ntz AS starts_at_utc,
        PARSE_JSON(shift_info.value):ends_at_utc::timestamp_ntz AS ends_at_utc
    FROM
        TEST_DB.TEST_DATA.SHOPPERS_LOG sl
    INNER JOIN
        TEST_DB.TEST_DATA.SHOPPERS_SHIFTS ss ON sl.SHOPPER_ID = ss.SHOPPER_ID
    CROSS JOIN
        LATERAL FLATTEN(INPUT => PARSE_JSON(TO_VARCHAR(ss.PROGRAMMED_SHITFS))) shift_info
    WHERE
        shift_info.key = DATE_TRUNC('day', sl.ACTIVATED_AT_UTC)
),

ShopperAdherenceSummary AS (
    SELECT
        DATE_REF,
        SHOPPER_ID,
        SUM(
            CASE
                WHEN ACTIVATED_AT_UTC < starts_at_utc OR DEACTIVATED_AT_UTC > ends_at_utc THEN 0
                WHEN ACTIVATED_AT_UTC > ends_at_utc OR DEACTIVATED_AT_UTC < starts_at_utc THEN 0
                WHEN ACTIVATED_AT_UTC < starts_at_utc AND DEACTIVATED_AT_UTC > ends_at_utc THEN DATEDIFF('minute', starts_at_utc, ends_at_utc)
                WHEN ACTIVATED_AT_UTC < starts_at_utc THEN DATEDIFF('minute', starts_at_utc, DEACTIVATED_AT_UTC)
                WHEN DEACTIVATED_AT_UTC > ends_at_utc THEN DATEDIFF('minute', ACTIVATED_AT_UTC, ends_at_utc)
                ELSE DATEDIFF('minute', ACTIVATED_AT_UTC, DEACTIVATED_AT_UTC)
            END
        ) AS VALID_CONNECTED_TIME,
        SUM(DATEDIFF('minute', starts_at_utc, ends_at_utc)) AS TOTAL_PROGRAMMED_TIME
    FROM
        ShopperAdherence
    GROUP BY
        DATE_REF,
        SHOPPER_ID
)

SELECT
    DATE_REF,
    SHOPPER_ID,
    CASE
        WHEN TOTAL_PROGRAMMED_TIME = 0 THEN 0
        ELSE ROUND((VALID_CONNECTED_TIME) / TOTAL_PROGRAMMED_TIME, 2)
    END AS ADHERENCE_RATIO
FROM
    ShopperAdherenceSummary;

--==============================================================================================================================
--==== QUESTION 4 ==============================================================================================================
--==============================================================================================================================
	/*
		Each order has the start and the finish time that has been worked on, wich we call workload time. In addition, each
		shopper has the connected time during the day. We need to analyse the productive time ratio for each shopper. This 
		ratio is calculated by total workload time divided by the total connected time.
		
		To stay on mind, orders can be worked simultaneously, that means the overlaping orders share an amount of workload time
		with each other and must be considered once.
		
		Based on that, build a reporting showing per each store the productive time ratio per day as a column, rounded to two 
		decimals.
	*/

WITH OrderWorkload AS (
    SELECT
        o.PHYSICAL_STORE_ID,
        DATE_TRUNC('day', o.STARTED_AT_LOCAL) AS DATE_REF,
        SUM(DATEDIFF('second', o.STARTED_AT_LOCAL, o.FINISHED_AT_LOCAL)) AS WORKLOAD_TIME
    FROM
        TEST_DB.TEST_DATA.ORDERS o
    GROUP BY
        o.PHYSICAL_STORE_ID,
        DATE_REF
),

ShopperConnectedTime AS (
    SELECT
        sl.PHYSICAL_STORE_ID,
        DATE_TRUNC('day', sl.ACTIVATED_AT_UTC) AS DATE_REF,
        SUM(DATEDIFF('second', sl.ACTIVATED_AT_UTC, sl.DEACTIVATED_AT_UTC)) AS CONNECTED_TIME
    FROM
        TEST_DB.TEST_DATA.SHOPPERS_LOG sl
    GROUP BY
        sl.PHYSICAL_STORE_ID,
        DATE_REF
),

StoreProductiveTimeRatio AS (
    SELECT
        o.PHYSICAL_STORE_ID,
        o.DATE_REF,
        ROUND((SUM(o.WORKLOAD_TIME)) / s.CONNECTED_TIME, 2) AS PRODUCTIVE_TIME_RATIO
    FROM
        OrderWorkload o
        JOIN ShopperConnectedTime s ON o.PHYSICAL_STORE_ID = s.PHYSICAL_STORE_ID AND o.DATE_REF = s.DATE_REF
    GROUP BY
        o.PHYSICAL_STORE_ID,
        o.DATE_REF,
        s.CONNECTED_TIME
)

SELECT
    s.PHYSICAL_STORE_ID,
    spr.DATE_REF,
    spr.PRODUCTIVE_TIME_RATIO
FROM
    TEST_DB.TEST_DATA.STORES s
    LEFT JOIN StoreProductiveTimeRatio spr ON s.PHYSICAL_STORE_ID = spr.PHYSICAL_STORE_ID
ORDER BY
    s.PHYSICAL_STORE_ID,
    spr.DATE_REF;