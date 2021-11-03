Select * from sqling;
SELECT * FROM `sql cleaning project`;


-- Change Date Format to Date/Time and back to Date Only
-- SQL Alter Table

alter table sqling
MODIFY `Document Date` datetime;

alter table sqling
MODIFY `Document Date` date;

-- Populate Owner Data

SELECT * from `sql cleaning project`
WHERE `Owner Name` ='';

SET SQL_SAFE_UPDATES = 0;
UPDATE `sql cleaning project` SET `Owner Name`= "Unknown"
WHERE `Owner Name` ='';

SELECT * FROM `sql cleaning project`;

-- Breaking Address into separate columns
-- Street
SElect substring_index(address,',',1) as street
FROM 
`sql cleaning project`;

-- City, State
SElect substring_index(substring_index(address,',',-1),' ',-1) as State
FROM 
`sql cleaning project`;

SElect substring_index(substring_index(address,',',-1),' ',2) as City
FROM 
`sql cleaning project`;

-- Update table to add new columns and update with information

ALTER Table `sql cleaning project`
ADD Street text
AFTER `Address`;

SET SQL_SAFE_UPDATES = 0;
UPDATE `sql cleaning project` SET `Street`= substring_index(address,',',1);

-- Add City column and data

ALTER Table `sql cleaning project`
ADD City text
AFTER `Street`;
UPDATE `sql cleaning project` SET `City`= substring_index(substring_index(address,',',-1),' ',2);


-- Add State column and data

ALTER Table `sql cleaning project`
ADD State text
AFTER `City`;
UPDATE `sql cleaning project` SET `State`=substring_index(substring_index(address,',',-1),' ',-1);

-- Change to Y or N 

SELECT `sold as vacant`,
CASE when `sold as vacant`="Yes" THEN "Y" 
WHEN `sold as vacant`="No" THEN "N" 
ELSE `sold as vacant`
END
FROM `sql cleaning project`;

UPDATE `sql cleaning project` SET `sold as vacant`= CASE when `sold as vacant`="Yes" THEN "Y" 
	WHEN `sold as vacant`="No" THEN "N" 
	ELSE `sold as vacant`
END ;

-- Remove duplicates

-- Created table to house unique account numbers
create table portfolioproject.ciclean like portfolioproject.sqling;

-- Made Customer Number the unique ID
Alter table portfolioproject.ciclean ADD UNIQUE(`customer number`(25));

-- Removed duplicates of Account Number
INSERT IGNORE INTO portfolioproject.ciclean SELECT * FROM portfolioproject.sqling;

SEleCT * from ciclean;

-- Delete Unused Columns
SELECT * FROM ciclean;

ALTER TABLE ciclean
DROP COLUMN MyUnknownColumn;

ALTER TABLE ciclean
DROP COLUMN `ï»¿SOP Type`,
DROP COLUMN `Unit COst`;


