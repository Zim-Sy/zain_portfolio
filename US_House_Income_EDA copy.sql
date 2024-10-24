# US Household Income Exploratory Data Analysis

SELECT * 
FROM US_Project.USHouseholdIncome;

SELECT * 
FROM US_Project.ushouseholdincome_statistics;


SELECT State_Name, County, City, ALand, AWAter
FROM USHouseholdIncome;

-- Taking the SUM of AreaLand and AreaWater for each State --

-- 1) Top Ten AreaLand by State
SELECT 
	RANK() OVER(ORDER BY SUM(ALand)DESC) as Total_ALand_Ranked,
	State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY SUM(ALand) DESC LIMIT 10;

-- 2) Top Ten AreaWater by State
SELECT 
	RANK() OVER(ORDER BY SUM(AWater)DESC) as Total_AWater_Ranked,
	State_Name, SUM(ALand), SUM(AWater)
FROM USHouseholdIncome
GROUP BY State_Name
ORDER BY SUM(AWater) DESC LIMIT 10;


-- Checking for Null Values to exclude in EDA (No Null values found)
SELECT *
FROM USHouseholdIncome inc
RIGHT JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE inc.id is NULL;

-- Checking for 0 value to exclude in EDA 
SELECT *
FROM USHouseholdIncome inc
RIGHT JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean = 0 AND Median = 0;

-- Excluding stats where mean = 0 and median = 0 from EDA
SELECT *
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0;


SELECT inc.State_Name, County, Type, `Primary`, Mean, Median
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0;

-- Inspecting the Average mean and median from each state --
-- Finding Top 10 Highest and Lowest Average mean and median from each state --

-- 1) Top 10 Higest Mean income for each State
SELECT RANK() OVER(ORDER BY ROUND(AVG(Mean)) DESC) Highest_Mean_Ranked,
	inc.State_Name, ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name
ORDER BY ROUND(AVG(Mean)) DESC
LIMIT 10;

-- 2) Top 10 Lowest Mean income for each State
SELECT RANK() OVER(ORDER BY ROUND(AVG(Mean)) ASC) as Lowest_Mean_Ranked,
	inc.State_Name, ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name
ORDER BY ROUND(AVG(Mean)) ASC
LIMIT 10;

-- 3) Top 10 Higest Median income for each State
SELECT RANK() OVER(ORDER BY ROUND(AVG(Median)) DESC) as Highest_Median_Ranked,
	inc.State_Name, ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name
ORDER BY ROUND(AVG(Median)) DESC
LIMIT 10;

-- 4) Top 10 Lowest Median income for each State
SELECT RANK() OVER(ORDER BY ROUND(AVG(Median)) ASC) as Lowest_Median_Ranked,
	inc.State_Name, ROUND(AVG(Mean)), ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name
ORDER BY ROUND(AVG(Median)) ASC
LIMIT 10;

-- Finding Top Highest and Lowest Average mean and median for each Type --

-- 1) Ranked Mean income for each Type (Seperated by Sufficient and Insufficient sample sizes)
SELECT 
    RANK() OVER(
        PARTITION BY 
        CASE
            WHEN COUNT(Type) > 99 THEN "RELIABLE"
            WHEN COUNT(Type) < 99 THEN "Not enough data to be reliable"
        END
        ORDER BY ROUND(AVG(Mean)) DESC
    ) AS Highest_Mean_Ranked,
    Type, 
    COUNT(Type) AS Sample_Size, 
    ROUND(AVG(Mean)) AS Avg_Mean, 
    ROUND(AVG(Median)) AS Avg_Median,
    CASE
        WHEN COUNT(Type) > 99 THEN "RELIABLE"
        WHEN COUNT(Type) < 99 THEN "Not enough data to be reliable"
    END AS Sample_Size_Validity
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
    ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY Type
ORDER BY Sample_Size_Validity DESC, ROUND(AVG(Mean)) DESC;

-- 2) Ranked Median income for each Type (Seperated by Sufficient and Insufficient sample sizes)
SELECT 
    RANK() OVER(
        PARTITION BY 
        CASE
            WHEN COUNT(Type) > 99 THEN "RELIABLE"
            WHEN COUNT(Type) < 99 THEN "Not enough data to be reliable"
        END
        ORDER BY ROUND(AVG(Median)) DESC
    ) AS Highest_Mean_Ranked,
    Type, 
    COUNT(Type) AS Sample_Size, 
    ROUND(AVG(Mean)) AS Avg_Mean, 
    ROUND(AVG(Median)) AS Avg_Median,
    CASE
        WHEN COUNT(Type) > 99 THEN "RELIABLE"
        WHEN COUNT(Type) < 99 THEN "Not enough data to be reliable"
    END AS Sample_Size_Validity
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
    ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY Type
ORDER BY Sample_Size_Validity DESC, ROUND(AVG(Median)) DESC;

-- Inspecting Average mean and median for each City --

-- 1) Top 25 Higest Mean income for each City
SELECT RANK() OVER(ORDER BY ROUND(AVG(Mean)) DESC) Highest_Mean_Ranked,
	inc.State_Name, inc.City, ROUND(AVG(Mean))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name, inc.City
ORDER BY ROUND(AVG(Mean)) DESC
LIMIT 20
;

-- 2) Top Higest Median income for each City
SELECT RANK() OVER(ORDER BY ROUND(AVG(Median)) DESC) Highest_Mean_Ranked,
	inc.State_Name, inc.City, ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name, inc.City
ORDER BY ROUND(AVG(Median)) DESC
;

-- 3)  Lowest Median income for each City Ranked
SELECT RANK() OVER(ORDER BY ROUND(AVG(Median)) ASC) Highest_Mean_Ranked,
	inc.State_Name, inc.City, ROUND(AVG(Median))
FROM USHouseholdIncome inc
INNER JOIN ushouseholdincome_statistics stat
	ON inc.id = stat.id
WHERE Mean > 0 AND Median > 0
GROUP BY inc.State_Name, inc.City
ORDER BY ROUND(AVG(Median)) ASC
LIMIT 1000
;




