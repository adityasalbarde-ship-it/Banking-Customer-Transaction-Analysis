-- =========================================
-- PROJECT 2: BANKING CUSTOMER & TRANSACTION ANALYSIS
-- 02 - DATA CLEANING & PREPARATION
-- =========================================

-- Cleaning Step 1A: Check Invalid DOB Values

SELECT 
    CustomerDOB,
    COUNT(*) AS record_count
FROM bank_transactions
WHERE CustomerDOB IN ('nan', '1/1/1800')
GROUP BY CustomerDOB;

-- Cleaning Step 1B: Create Cleaned Table

CREATE TABLE bank_transactions_clean AS
SELECT *
FROM bank_transactions;

-- Cleaning Step 1C: Verify Cleaned Table

SELECT COUNT(*) AS clean_table_rows
FROM bank_transactions_clean;


SET SQL_SAFE_UPDATES = 0;

-- Cleaning Step 2: Replace invalid DOB values

UPDATE bank_transactions_clean
SET CustomerDOB = NULL
WHERE CustomerDOB IN ('nan', '1/1/1800');

-- Verify invalid DOB values were cleaned

SELECT 
    CustomerDOB,
    COUNT(*) AS record_count
FROM bank_transactions_clean
WHERE CustomerDOB IN ('nan', '1/1/1800')
GROUP BY CustomerDOB;

-- current gender distribution in the cleaned table

SELECT 
    CustGender,
    COUNT(*) AS record_count
FROM bank_transactions_clean
GROUP BY CustGender
ORDER BY record_count DESC;


--   Cleaning Step 3 — Convert blank gender to NULL

UPDATE bank_transactions_clean
SET CustGender = NULL
WHERE TRIM(CustGender) = '';

-- Cleaning Step 4 — Clean blank locations

UPDATE bank_transactions_clean
SET CustLocation = NULL
WHERE TRIM(CustLocation) = '';

-- Cleaning Step 5 — Handle the unusual T gender
SELECT *
FROM bank_transactions_clean
WHERE CustGender = 'T';

-- Cleaning Step 5.1 — Convert T to NULL

UPDATE bank_transactions_clean
SET CustGender = NULL
WHERE CustGender = 'T';

-- Cleaning Step 6 — Prepare Transaction Date
SELECT 
    TransactionDate,
    COUNT(*) AS record_count
FROM bank_transactions_clean
GROUP BY TransactionDate
ORDER BY TransactionDate
LIMIT 10;

-- Cleaning Step 6 — Create a proper DATE column
ALTER TABLE bank_transactions_clean
ADD COLUMN TransactionDate_clean DATE;

SET SQL_SAFE_UPDATES = 0;

-- Cleaning Step 6B — Convert text dates to real dates
 UPDATE bank_transactions_clean
SET TransactionDate_clean = STR_TO_DATE(TransactionDate, '%e/%c/%y');

SELECT 
    COUNT(*) AS converted_dates
FROM bank_transactions_clean
WHERE TransactionDate_clean IS NOT NULL;

-- Cleaning Step 6C — Verify the actual date range

SELECT 
    MIN(TransactionDate_clean) AS earliest_date,
    MAX(TransactionDate_clean) AS latest_date
FROM bank_transactions_clean;

-- Cleaning Step 7 — Convert Transaction Time
ALTER TABLE bank_transactions_clean
ADD COLUMN TransactionTime_clean TIME;

-- Cleaning Step 7B — Convert the numeric time to SQL time

UPDATE bank_transactions_clean
SET TransactionTime_clean =
    STR_TO_DATE(LPAD(TransactionTime, 6, '0'), '%H%i%s');
    
    SELECT 
    COUNT(*) AS converted_times
FROM bank_transactions_clean
WHERE TransactionTime_clean IS NOT NULL;

-- Cleaning Step 7C — Verify the time range

SELECT 
    MIN(TransactionTime_clean) AS earliest_time,
    MAX(TransactionTime_clean) AS latest_time
FROM bank_transactions_clean;

-- Standardize Customer Location
SELECT 
    CustLocation,
    COUNT(*) AS record_count
FROM bank_transactions_clean
WHERE CustLocation IS NOT NULL
GROUP BY CustLocation
ORDER BY record_count DESC
LIMIT 10;

-- Cleaning Step 8 — Check transaction amounts

SELECT 
    COUNT(*) AS total_rows,
    COUNT(`TransactionAmount (INR)`) AS amount_present
FROM bank_transactions_clean;

SELECT 
    COUNT(*) AS zero_amount_transactions
FROM bank_transactions_clean
WHERE `TransactionAmount (INR)` = 0;

-- Cleaning Step 9 — Check account balance
SELECT 
    COUNT(*) AS zero_balance_records
FROM bank_transactions_clean
WHERE CustAccountBalance = 0;

-- Cleaning Step 10 — Check remaining missing values
SELECT
    COUNT(*) AS total_rows,
    COUNT(CustomerID) AS customerid_present,
    COUNT(CustAccountBalance) AS balance_present,
    COUNT(TransactionDate_clean) AS date_present,
    COUNT(TransactionTime_clean) AS time_present,
    COUNT(`TransactionAmount (INR)`) AS amount_present
FROM bank_transactions_clean;