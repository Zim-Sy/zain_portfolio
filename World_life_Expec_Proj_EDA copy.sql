# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;

-- Lowest and Highest Life expectancy of each country
SELECT 
	Country,
    MIN(Lifeexpectancy),
    MAX(Lifeexpectancy),
    ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS Life_Increase_Over_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_Over_15_Years ASC
;


-- Lowest, Highest, and Average Life expectancy each year
SELECT Year,
	MIN(Lifeexpectancy),
    MAX(Lifeexpectancy),
	ROUND(AVG(Lifeexpectancy),2)
FROM world_life_expectancy
WHERE Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year
;

-- corralation between life expectancy and other fields
-- corralation between life expectancy and GDP
SELECT *
FROM world_life_expectancy
;

		-- Tableau(good for corralations) could be used here...
SELECT Country,  
	ROUND(AVG(Lifeexpectancy),1) as life_exp, 
	ROUND(AVG(GDP),1) as GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

-- giving catagories via case statement for GDP & LifeExp correlation 
SELECT 
CASE
	WHEN GDP >= 1500 THEN 1
    ELSE 0
END as High_GDP_Count
FROM world_life_expectancy
ORDER BY GDP
;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) as High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) as High_GDP_Life_Exp,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE 0 END) wrong_method,

SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) as Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) as Low_GDP_Life_Exp

FROM world_life_expectancy
ORDER BY GDP
;

-- corralation between life expectancy and status
SELECT *
FROM world_life_expectancy
;
SELECT Status, ROUND(AVG(Lifeexpectancy), 1), COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;

-- corralation between life expectancy and BMI
SELECT Country, ROUND(AVG(Lifeexpectancy), 1) as Life_Exp, ROUND(AVG(BMI), 1) as BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

-- corralation between life expectancy and Adult Mortality
SELECT Country, Year, Lifeexpectancy, AdultMortality,
	SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) as rolling_total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;




