-- =========================================
-- PROJECT 2: BANKING CUSTOMER & TRANSACTION ANALYSIS
-- 04 - SQL ANALYSIS
-- =========================================

USE banking_analysis;

-- Analysis 1 — Total and Average Transaction Amount

SELECT
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean;

-- Analysis 2 — Transaction Volume by Month
SELECT
    TransactionMonth,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value
FROM bank_transactions_clean
GROUP BY TransactionMonth
ORDER BY TransactionMonth;

-- Analysis 3 —  Unique Customer Count

SELECT
    COUNT(DISTINCT CustomerID) AS unique_customers
FROM bank_transactions_clean;

-- Analysis 4 — Top Customers by Transaction Count

SELECT
    CustomerID,
    COUNT(*) AS transaction_count
FROM bank_transactions_clean
GROUP BY CustomerID
ORDER BY transaction_count DESC
LIMIT 10;

-- Analysis 5 — How many customers made 1, 2, 3... transactions?

SELECT
    transaction_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS transaction_count
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_transactions
GROUP BY transaction_count
ORDER BY transaction_count;

-- Analysis 6 — Transaction Value by Category

SELECT
    TransactionCategory,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY TransactionCategory
ORDER BY total_transaction_value DESC;

-- Analysis 7 — Gender-wise Transaction Performance

SELECT
    COALESCE(CustGender, 'Unknown') AS gender,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY CustGender
ORDER BY total_transaction_value DESC;

-- Analysis 8 — Location performance

SELECT
    CustLocation AS location,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
WHERE CustLocation IS NOT NULL
GROUP BY CustLocation
ORDER BY total_transaction_value DESC
LIMIT 10;

-- Analysis 9: Top Customers by Total Transaction Value

SELECT
    CustomerID,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY CustomerID
ORDER BY total_transaction_value DESC
LIMIT 10;

-- Analysis 10: One-Time vs Repeat Customers

SELECT
    CASE
        WHEN transaction_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS transaction_count
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_transactions
GROUP BY customer_type
ORDER BY customer_count DESC;

-- Analysis 11: Transaction Activity by Time of Day

SELECT
    CASE
        WHEN HOUR(TransactionTime_clean) < 6 THEN 'Night'
        WHEN HOUR(TransactionTime_clean) < 12 THEN 'Morning'
        WHEN HOUR(TransactionTime_clean) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY time_period
ORDER BY transaction_count DESC;

-- Analysis 12: Transaction Value by Day of Month

SELECT
    DAY(TransactionDate_clean) AS day_of_month,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY day_of_month
ORDER BY total_transaction_value DESC;

-- Analysis 13: High-Value Transaction Analysis

SELECT
    CASE
        WHEN `TransactionAmount (INR)` > 100000 THEN 'Above ₹1 Lakh'
        ELSE '₹1 Lakh or Below'
    END AS transaction_group,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY transaction_group
ORDER BY total_transaction_value DESC;

-- Analysis 14: Transaction Amount Distribution

SELECT
    CASE
        WHEN `TransactionAmount (INR)` < 500 THEN 'Below ₹500'
        WHEN `TransactionAmount (INR)` < 1000 THEN '₹500 - ₹999'
        WHEN `TransactionAmount (INR)` < 5000 THEN '₹1,000 - ₹4,999'
        WHEN `TransactionAmount (INR)` < 10000 THEN '₹5,000 - ₹9,999'
        WHEN `TransactionAmount (INR)` < 50000 THEN '₹10,000 - ₹49,999'
        WHEN `TransactionAmount (INR)` < 100000 THEN '₹50,000 - ₹99,999'
        ELSE '₹1 Lakh+'
    END AS amount_range,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY amount_range
ORDER BY MIN(`TransactionAmount (INR)`);

-- Analysis 15: Top Customers by Total Spending

SELECT
    CustomerID,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_spending,
    AVG(`TransactionAmount (INR)`) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY CustomerID
ORDER BY total_spending DESC
LIMIT 10;

-- Analysis 16: Customers with Total Spending Above ₹1 Lakh

SELECT
    COUNT(*) AS high_spending_customers
FROM (
    SELECT
        CustomerID,
        SUM(`TransactionAmount (INR)`) AS total_spending
    FROM bank_transactions_clean
    GROUP BY CustomerID
    HAVING SUM(`TransactionAmount (INR)`) > 100000
) AS customer_spending;

-- Analysis 17: One-Time vs Repeat Customer Spending

SELECT
    CASE
        WHEN transaction_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count,
    SUM(total_spending) AS total_customer_spending,
    AVG(total_spending) AS average_customer_spending
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS transaction_count,
        SUM(`TransactionAmount (INR)`) AS total_spending
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_summary
GROUP BY customer_type
ORDER BY total_customer_spending DESC;


-- Analysis 18: Repeat Customer Rate

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN transaction_count > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS transaction_count
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_transactions;

-- Analysis 19: Average Transactions per Customer

SELECT
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT CustomerID),
        2
    ) AS average_transactions_per_customer
FROM bank_transactions_clean;


-- Analysis 20: Customer Spending Segmentation

SELECT
    CASE
        WHEN total_spending < 1000 THEN 'Low Spender'
        WHEN total_spending < 5000 THEN 'Medium Spender'
        WHEN total_spending < 10000 THEN 'High Spender'
        ELSE 'Very High Spender'
    END AS spending_segment,
    COUNT(*) AS customer_count,
    SUM(total_spending) AS total_segment_spending,
    AVG(total_spending) AS average_customer_spending
FROM (
    SELECT
        CustomerID,
        SUM(`TransactionAmount (INR)`) AS total_spending
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_spending
GROUP BY spending_segment
ORDER BY total_segment_spending DESC;

-- Analysis 21: Customer Spending Segment Distribution

SELECT
    spending_segment,
    customer_count,
    ROUND(
        100.0 * customer_count / SUM(customer_count) OVER (),
        2
    ) AS customer_percentage
FROM (
    SELECT
        CASE
            WHEN total_spending < 1000 THEN 'Low Spender'
            WHEN total_spending < 5000 THEN 'Medium Spender'
            WHEN total_spending < 10000 THEN 'High Spender'
            ELSE 'Very High Spender'
        END AS spending_segment,
        COUNT(*) AS customer_count
    FROM (
        SELECT
            CustomerID,
            SUM(`TransactionAmount (INR)`) AS total_spending
        FROM bank_transactions_clean
        GROUP BY CustomerID
    ) AS customer_spending
    GROUP BY spending_segment
) AS segment_summary
ORDER BY customer_percentage DESC;

-- Analysis 22: Average Customer Spending by Segment

SELECT
    CASE
        WHEN total_spending < 1000 THEN 'Low Spender'
        WHEN total_spending < 5000 THEN 'Medium Spender'
        WHEN total_spending < 10000 THEN 'High Spender'
        ELSE 'Very High Spender'
    END AS spending_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spending), 2) AS average_customer_spending
FROM (
    SELECT
        CustomerID,
        SUM(`TransactionAmount (INR)`) AS total_spending
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_spending
GROUP BY spending_segment
ORDER BY average_customer_spending DESC;


-- Analysis 23: Customer Spending vs Transaction Frequency

SELECT
    transaction_count,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spending), 2) AS average_customer_spending
FROM (
    SELECT
        CustomerID,
        COUNT(*) AS transaction_count,
        SUM(`TransactionAmount (INR)`) AS total_spending
    FROM bank_transactions_clean
    GROUP BY CustomerID
) AS customer_summary
GROUP BY transaction_count
ORDER BY transaction_count;

-- Analysis 24: Transaction Value by Gender and Spending Category

SELECT
    COALESCE(CustGender, 'Unknown') AS gender,
    TransactionCategory,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    ROUND(AVG(`TransactionAmount (INR)`), 2) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY
    CustGender,
    TransactionCategory
ORDER BY
    gender,
    total_transaction_value DESC;
    
    
    -- Analysis 25: Monthly Active Customers and Spending

SELECT
    TransactionMonth,
    COUNT(DISTINCT CustomerID) AS active_customers,
    COUNT(*) AS transaction_count,
    SUM(`TransactionAmount (INR)`) AS total_transaction_value,
    ROUND(AVG(`TransactionAmount (INR)`), 2) AS average_transaction_amount
FROM bank_transactions_clean
GROUP BY TransactionMonth
ORDER BY TransactionMonth;