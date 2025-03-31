/*
-------------------------------------------------------
Initial Data Review and Cleaning for FP&A Assessment
-------------------------------------------------------

Objective:
This script performs an initial exploration and cleanup of the `auc_drop_data` table 
to prepare it for analysis and visualization (in Tableau). The dataset contains 
Account Under Custody (AuC) values broken down by entity, account type, and asset 
type (Fiat or Crypto) for January and February 2025.

Key Steps:
1. Load and explore the data
2. Check for missing or duplicate entries
3. Inspect structure and unique value distributions
4. Add a human-readable month name for clarity
5. Remove invalid rows to ensure data integrity

Summary of Initial Observations:
- No missing values were found in any of the critical columns
- No duplicate records were found
- The dataset covers only the year 2025
- Two months present: January (1) and February (2)
- There are 5 distinct entities (A,B,C,D,E)
- Two account types were found: 'retail' and 'corpo'
- Two balance types were found: 'fiat' and 'crypto'

Final Output:
A clean and structured dataset ready for visual analysis in Tableau to investigate movements in AuC.
*/


SELECT * 
FROM Bitstamp.auc_drop_data;

-- Preview the first 25 rows to understand structure and sample values
SELECT * 
FROM auc_drop_data
LIMIT 25;

-- Inspect the structure of the table: column names and data types
DESCRIBE auc_drop_data;

-- Check for NULL (missing) values in each relevant column
SELECT 
  SUM(year IS NULL)                
	AS year_nulls,
  SUM(month IS NULL)              
	AS month_nulls,
  SUM(entity IS NULL)             
	AS entity_nulls,
  SUM(client_id IS NULL)          
	AS client_id_nulls,
  SUM(account_type_name IS NULL)  
	AS account_type_name_nulls,
  SUM(type IS NULL)               
	AS type_nulls,
  SUM(balance_usd IS NULL)        
	AS balance_usd_nulls
FROM auc_drop_data;

-- Identify potential duplicate records based on all core columns
SELECT year, month, entity, client_id, account_type_name, type, balance_usd, COUNT(*) AS duplicate_count
FROM auc_drop_data
GROUP BY year, month, entity, client_id, account_type_name, type, balance_usd
HAVING COUNT(*) > 1;

-- Review the distinct years in the dataset
SELECT DISTINCT year 
FROM auc_drop_data;

-- Review the distinct months in the dataset
SELECT DISTINCT month 
FROM auc_drop_data;

-- Review the distinct entities present
SELECT DISTINCT entity 
FROM auc_drop_data;

-- Review the distinct account type names
SELECT DISTINCT account_type_name 
FROM auc_drop_data;

-- Review the distinct types of balances
SELECT DISTINCT type 
FROM auc_drop_data;

-- Add a new column for readable month names
ALTER TABLE auc_drop_data 
ADD COLUMN month_name VARCHAR(20);

-- Populate the new month_name column
UPDATE auc_drop_data
SET month_name = CASE month
    WHEN 1 THEN 'January'
    WHEN 2 THEN 'February'
    ELSE 'Unknown'
END;

-- Clean the dataset: remove rows with missing key data (none found in this case)
DELETE FROM auc_drop_data 
WHERE client_id IS NULL 
   OR entity IS NULL 
   OR balance_usd IS NULL;

-- Recheck the cleaned dataset (should now be ready for analysis)
SELECT * 
FROM Bitstamp.auc_drop_data;
