-- =========================================
-- PROJECT 2: BANKING CUSTOMER & TRANSACTION ANALYSIS
-- 03 - FEATURE ENGINEERING / ANALYSIS PREPARATION
-- =========================================

USE banking_analysis;
-- Step 1 — Create Transaction Month
ALTER TABLE bank_transactions_clean
ADD COLUMN TransactionMonth VARCHAR(7);

SET SQL_SAFE_UPDATES = 0;

-- Step 2 — Fill the Transaction Month
UPDATE bank_transactions_clean
SET TransactionMonth = DATE_FORMAT(TransactionDate_clean, '%Y-%m');

-- Step 3 — Verify whether it completed
SELECT COUNT(*) AS populated_months
FROM bank_transactions_clean
WHERE TransactionMonth IS NOT NULL;

-- Step 4 — Check the monthly distribution
SELECT 
    TransactionMonth,
    COUNT(*) AS transaction_count
FROM bank_transactions_clean
GROUP BY TransactionMonth
ORDER BY TransactionMonth;

 -- Step 5 — Create Transaction Amount Category
 ALTER TABLE bank_transactions_clean
ADD COLUMN TransactionCategory VARCHAR(20);


SET SQL_SAFE_UPDATES = 0;


-- Step 6 — Assign categories
UPDATE bank_transactions_clean
SET TransactionCategory =
    CASE
        WHEN `TransactionAmount (INR)` < 1000 THEN 'Small'
        WHEN `TransactionAmount (INR)` <= 10000 THEN 'Medium'
        WHEN `TransactionAmount (INR)` <= 50000 THEN 'Large'
        ELSE 'Very Large'
    END;

-- Step 7 — Verify the categories
SELECT COUNT(*) AS categorized_rows
FROM bank_transactions_clean
WHERE TransactionCategory IS NOT NULL;

-- Step 8 — Check the category distribution
SELECT
    TransactionCategory,
    COUNT(*) AS transaction_count
FROM bank_transactions_clean
GROUP BY TransactionCategory
ORDER BY transaction_count DESC;

-- Step 9 — One final preparation field

ALTER TABLE bank_transactions_clean
ADD COLUMN TransactionYear INT;

SET SQL_SAFE_UPDATES = 0;

-- Step 10 — Populate Transaction Year
UPDATE bank_transactions_clean
SET TransactionYear = YEAR(TransactionDate_clean);

-- Step 11 — Verify Transaction Year
SELECT COUNT(*) AS populated_years
FROM bank_transactions_clean
WHERE TransactionYear IS NOT NULL;

-- Step 12 — Verify the year
SELECT
    TransactionYear,
    COUNT(*) AS transaction_count
FROM bank_transactions_clean
GROUP BY TransactionYear
ORDER BY TransactionYear;



