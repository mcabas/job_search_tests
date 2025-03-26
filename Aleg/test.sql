---- STEP 1. import tables
---- create tables on Alegra DB.

CREATE TABLE historico_plan (
    idcompany int PRIMARY KEY,  
    registrationDate date,
    planName varchar(50),
    paymentFrequency float,  
    lastPaidPlan varchar(50),
    firstPaymentDate date,
    retirementDate date,
    avgMonInvoices int,
    avgMonBilling int,
    users float,  
    downloadReports float, 
    helpRequests float  
);

CREATE TABLE company (
    idcompany int PRIMARY KEY,  
    country varchar(50),
    channel varchar(50),
    profile varchar(50)
);

select * from historico_plan;

select * from company;

---- STEP 2. perform data quality validations
---- Check for Null Values

SELECT
    COUNT(*) AS total_rows,
    COUNT(idcompany) AS non_null_idcompany,
    COUNT(registrationDate) AS non_null_registrationDate,
    COUNT(planName) AS non_null_planName,
    COUNT(paymentFrequency) AS non_null_paymentFrequency,
    COUNT(lastPaidPlan) AS non_null_lastPaidPlan,
    COUNT(firstPaymentDate) AS non_null_firstPaymentDate,
    COUNT(retirementDate) AS non_null_retirementDate,
    COUNT(avgMonInvoices) AS non_null_avgMonInvoices,
    COUNT(avgMonBilling) AS non_null_avgMonBilling,
    COUNT(users) AS non_null_users,
    COUNT(downloadReports) AS non_null_downloadReports,
    COUNT(helpRequests) AS non_null_helpRequests
FROM historico_plan;

SELECT
    COUNT(*) AS total_rows,
    COUNT(idcompany) AS non_null_column1,
    COUNT(country) AS non_null_country,
    COUNT(channel) AS non_null_channel,
    COUNT(profile) AS non_null_profile
    -- Add all columns you want to check
FROM company;

---- Check for Duplicates

SELECT idcompany, COUNT(*)
FROM historico_plan
GROUP BY idcompany
HAVING COUNT(*) > 1;

SELECT idcompany, COUNT(*)
FROM company
GROUP BY idcompany
HAVING COUNT(*) > 1;

---- Validate Referential Integrity

SELECT *
FROM historico_plan
WHERE idcompany NOT IN (SELECT idcompany FROM company);

---- Validate Data Consistency

SELECT *
FROM historico_plan
WHERE retirementDate < registrationDate;

---- STEP 2. Analyze Data
---- Perform Join

select *
from company c
inner join historico_plan h
on c.idcompany = h.idcompany; --- both tables as 1:1 relation

---- 1

WITH plan_prices AS (
    SELECT
        planName,
        CASE
            WHEN planName = 'pyme' THEN 20
            WHEN planName = 'pro' THEN 40
            WHEN planName = 'plus' THEN 80
            ELSE 0
        END AS plan_price
    FROM historico_plan
    GROUP BY planName
),
active_companies AS (
    SELECT
        c.idcompany,
        h.planName,
        h.firstPaymentDate,
        h.retirementDate,
        h.paymentFrequency,
        pp.plan_price
    FROM company c
    INNER JOIN historico_plan h ON c.idcompany = h.idcompany
    INNER JOIN plan_prices pp ON h.planName = pp.planName
    WHERE h.planName != 'consulta'  -- Excluir el plan "consulta"
),
monthly_mrr AS (
    SELECT
		ac.planName,
        DATE_TRUNC('month', generate_series) AS month,
        COUNT(DISTINCT ac.idcompany) AS total_companies,
        SUM(ac.plan_price / ac.paymentFrequency) AS mrr
    FROM generate_series(
        (SELECT MIN(firstPaymentDate) FROM active_companies),
        (SELECT MAX(firstPaymentDate) FROM active_companies),
        '1 month'::interval
    ) AS generate_series
    LEFT JOIN active_companies ac
        ON generate_series >= ac.firstPaymentDate
        AND (ac.retirementDate IS NULL OR generate_series <= ac.retirementDate)
    GROUP BY month, planName
    ORDER BY month, planName
)
SELECT
	planName,
    month,
    total_companies,
	--mrr,
    ROUND(mrr::numeric,2) as mrr
FROM monthly_mrr;

---- 2

WITH active_companies AS (
    SELECT
        c.idcompany,
        c.country,
        h.planName,
        h.firstPaymentDate,
        h.retirementDate,
        h.paymentFrequency,
        h.avgMonInvoices,
        h.avgMonBilling,
        h.users,
        h.downloadReports,
        h.helpRequests,
        c.channel,
        c.profile,
        CASE
            WHEN h.planName = 'pyme' THEN 10
            WHEN h.planName = 'pro' THEN 20
            WHEN h.planName = 'plus' THEN 30
            ELSE 0
        END AS plan_price
    FROM company c
    INNER JOIN historico_plan h ON c.idcompany = h.idcompany
    WHERE h.planName != 'consulta'  -- Excluir el plan "consulta"
),
monthly_mrr AS (
    SELECT
        DATE_TRUNC('month', generate_series) AS month,
        ac.country,
        COUNT(DISTINCT ac.idcompany) AS total_companies,
        SUM(ac.plan_price / ac.paymentFrequency) AS mrr
    FROM generate_series(
        (SELECT MIN(firstPaymentDate) FROM active_companies),
        (SELECT MAX(firstPaymentDate) FROM active_companies),
        '1 month'::interval
    ) AS generate_series
    LEFT JOIN active_companies ac
        ON generate_series >= ac.firstPaymentDate
        AND (ac.retirementDate IS NULL OR generate_series <= ac.retirementDate)
    GROUP BY month, ac.country
),
market_performance AS (
    SELECT
        country,
        COUNT(DISTINCT idcompany) AS total_companies,
        SUM(plan_price / paymentFrequency) AS total_mrr,
        AVG(avgMonInvoices) AS avg_invoices,
        AVG(avgMonBilling) AS avg_billing,
        AVG(users) AS avg_users,
        AVG(downloadReports) AS avg_downloads,
        AVG(helpRequests) AS avg_help_requests,
        COUNT(CASE WHEN retirementDate IS NOT NULL THEN 1 END) * 1.0 / COUNT(*) AS churn_rate,
        MAX(firstPaymentDate) AS last_acquisition_date
    FROM active_companies
    GROUP BY country
)
SELECT
    mp.country,
    mp.total_companies,
    mp.total_mrr,
    mp.avg_invoices,
    mp.avg_billing,
    mp.avg_users,
    mp.avg_downloads,
    mp.avg_help_requests,
    mp.churn_rate,
    mp.last_acquisition_date,
    mm.mrr_growth
FROM market_performance mp
LEFT JOIN (
    SELECT
        country,
        (MAX(mrr) - (MIN(mrr)) / NULLIF(MIN(mrr), 0)) AS mrr_growth
    FROM monthly_mrr
    GROUP BY country
) mm ON mp.country = mm.country
ORDER BY total_mrr DESC;

---- 3

WITH cohortes AS (
    SELECT
        idcompany,
        DATE_TRUNC('month', registrationDate) AS cohort_month,
        DATE_TRUNC('month', retirementDate) AS retirement_month
    FROM historico_plan
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT idcompany) AS total_companies
    FROM cohortes
    GROUP BY cohort_month
),
retention_data AS (
    SELECT
        c.cohort_month,
        DATE_TRUNC('month', generate_series) AS month,
        COUNT(DISTINCT c.idcompany) AS retained_companies
    FROM generate_series(
        (SELECT MIN(cohort_month) FROM cohortes),
        (SELECT MAX(cohort_month) FROM cohortes),
        '1 month'::interval
    ) AS generate_series
    LEFT JOIN cohortes c
        ON generate_series >= c.cohort_month
        AND (c.retirement_month IS NULL OR generate_series <= c.retirement_month)
    GROUP BY c.cohort_month, month
)
SELECT
    rd.cohort_month,
    rd.month,
    cs.total_companies,
    rd.retained_companies,
    (rd.retained_companies * 1.0 / cs.total_companies) * 100 AS retention_rate
FROM retention_data rd
LEFT JOIN cohort_size cs ON rd.cohort_month = cs.cohort_month
ORDER BY rd.cohort_month, rd.month;