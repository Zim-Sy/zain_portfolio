# US Household Income Data Cleaning

SELECT * FROM US_Project.USHouseholdIncome;
SELECT * FROM US_Project.ushouseholdincome_statistics;

SELECT COUNT(id)
FROM US_Project.USHouseholdIncome;

SELECT COUNT(id)
FROM US_Project.ushouseholdincome_statistics;

-- Identify id Duplicates from 'USHouseholdIncome'
SELECT id, COUNT(id)
FROM USHouseholdIncome
GROUP BY id
HAVING COUNT(id) > 1 ;

-- Selecting id Duplicates from 'USHouseholdIncome' (windows function metbod)
SELECT *
FROM 
	(SELECT row_id, id,
    ROW_NUMBER() OVER(PARTITION BY id) as row_num
    FROM USHouseholdIncome
    ) as duplicates
WHERE row_num > 1;

-- Removing id Duplicates
DELETE FROM USHouseholdIncome
WHERE row_id IN
(
	SELECT row_id
	FROM 
		(SELECT row_id, id,
		ROW_NUMBER() OVER(PARTITION BY id ) as row_num
		FROM USHouseholdIncome
		) as duplicates
	WHERE row_num > 1
);

-- Identify id Duplicates from 'ushouseholdincome_statistics' (none found)
SELECT id, COUNT(id)
FROM ushouseholdincome_statistics
GROUP BY id
HAVING COUNT(id) > 1 ;

-- Looking for Stae_names to standardize
-- Note: all 'lower case' state names do not show up and is considered the same as state name with proper capitalization
SELECT State_name, COUNT(State_name)
FROM USHouseholdIncome
GROUP BY State_name;

-- Updating State name 'georia' to Georgia
UPDATE USHouseholdIncome
SET State_name = 'Georgia'
WHERE State_name = 'georia';


-- Updating Stae Name 'alabama' to 'Alabama'
UPDATE USHouseholdIncome
SET State_name = 'Alabama'
WHERE State_name = 'alabama';


-- Confirming Null Value found in 'place' with city 'Vinemount'
SELECT *
FROM USHouseholdIncome
WHERE County = 'Autauga County'
ORDER BY row_id ;

-- Updating Null value in Place to 'Autaugaville'
UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE 
	County = 'Autauga County' AND 
    City = 'Vinemont';


-- Looking for Duplicates under 'Type' field (Noticed 'Borough' and 'Boroughs')
SELECT Type, COUNT(Type)
FROM USHouseholdIncome
GROUP BY Type;

-- Converting 'Boroughs' to 'Borough' under 'Type' field
UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs';


