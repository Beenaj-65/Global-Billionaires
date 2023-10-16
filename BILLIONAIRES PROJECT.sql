--First we have to create a table called billionaires

CREATE TABLE billionaires(
	rank INT,
	finalWorth INT,
	category TEXT,
	personName TEXT,
	age	INT,
	country TEXT,
	city TEXT,
	source TEXT,
	industries TEXT,
	countryOfCitizenship TEXT,
	organization TEXT,
	selfMade TEXT,
	status TEXT,
	gender VARCHAR (2),
	birthDate TIMESTAMP,
	lastName TEXT,
	firstName TEXT,
	title TEXT,
	date TIMESTAMP,
	state TEXT,
	residenceStateRegion TEXT,
	birthYear INT,
	birthMonth INT,
	birthDay INT,
	cpi_country	FLOAT,
	cpi_change_country FLOAT,
	gdp_country MONEY,
	gross_tertiary_education_enrollment	FLOAT,
	gross_primary_education_enrollment_country FLOAT,
	life_expectancy_country FLOAT,
	tax_revenue_country_country	FLOAT,
	total_tax_rate_country FLOAT,
	population_country FLOAT,
	latitude_country DOUBLE PRECISION,
	longitude_country DOUBLE PRECISION
);

-- to ensure all the data was fully loaded using PSQL
SELECT * FROM billionaires;

-- to generate top 10 billionaires
SELECT
	personName,
	finalWorth
FROM
	billionaires
ORDER BY
	2 DESC
LIMIT 10;	


--to determine the average age of billionaires
SELECT
	CEIL(AVG (age)) AS average_age
FROM
	billionaires;

-- to determine the number of billionaires present per country
SELECT
	country, 
	latitude_country,
	longitude_country,
	COUNT(*) AS count_of_billionaires
FROM
	billionaires
WHERE country IS NOT NULL AND latitude_country IS NOT NULL AND longitude_country IS NOT NULL
GROUP BY
	country, latitude_country, longitude_country
ORDER BY
	count_of_billionaires DESC;
	
	
--to determine billionaire distribution by gender
SELECT
	gender,
	COUNT(*) AS count_of_billionairesbygender
FROM
	billionaires
WHERE gender IS NOT NULL	
GROUP BY
	gender;


--billionaires distribution by industry
SELECT
	industries, 
	COUNT(*) AS count_of_billionaires
FROM
	billionaires
GROUP BY
	industries
ORDER BY
	count_of_billionaires DESC;

--billionaires by source	

SELECT
	source, 
	COUNT(*) AS count_of_billionaires
FROM
	billionaires
GROUP BY
	source
ORDER BY
	count_of_billionaires DESC
LIMIT 10;


--to determine correlation between finalworth and country gdp
SELECT CORR(finalWorth, gdp_country::NUMERIC) AS correlation FROM billionaires;


/*Top Industries in Each Country, to identify the top industry (category) 
in terms of the highest total final worth for each country using CTE */

WITH ranked_categories AS (
	SELECT 
	country, 
	category, 
	SUM(finalWorth)	AS total_worth,
	ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(finalWorth) DESC) AS category_rank
	FROM
	billionaires
	GROUP BY
	country, category) 
SELECT country, category, total_worth
FROM ranked_categories
WHERE category_rank = 1
ORDER BY total_worth DESC
LIMIT 15;

--to determine youngest and oldest billionaire:
SELECT MAX(age) FROM billionaires
SELECT MIN(age) FROM billionaires

--Age Distribution of Billionaires by gender:
SELECT gender,
       width_bucket(age, 10, 110, 5) AS age_group,
       COUNT(*) AS count
FROM billionaires
WHERE age IS NOT NULL
GROUP BY gender, age_group
ORDER BY gender, age_group;

--to detrmine the wealth origin of billionaires
SELECT
	selfMade,
	COUNT(*) AS total_billionairesnotselfmade
FROM
	billionaires
GROUP BY
	selfMade;

-- to determine the richest billionaire
SELECT
	personName,
	finalWorth
FROM
	billionaires
ORDER BY
	2 DESC
LIMIT 1;