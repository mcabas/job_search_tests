-- 1

SELECT
    ci.Name
FROM
    city AS ci
INNER JOIN country AS co
    ON ci.CountryCode = co.CountryCode
INNER JOIN countrylanguage AS cl
    ON co.CountryCode = cl.CountryCode
WHERE 
    co.Continent = 'Africa' AND
    (ci.Population >= 100000 AND ci.Population <= 1000000) 
    AND (cl.Language = 'Spanish' OR cl.Language = 'French')

-- 2

SELECT
	AVG(ci.Population) AS promedio_habitantes,
	COUNT(ci.Name) AS no_ciudades
FROM
	city AS ci
INNER JOIN country AS co
	ON ci.CountryCode = co.CountryCode
WHERE co.Continent = 'America'
GROUP BY co.CountryCode

--3

SELECT
	Name
FROM country
WHERE LifeExpectancy IN (SELECT MAX(LifeExpectancy) AS max_LifeExpectancy FROM country)
GROUP BY Continent


