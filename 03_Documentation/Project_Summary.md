# Banking Customer & Transaction Analysis

## Project Overview

This project analyzes customer and transaction data from a banking dataset containing more than **1 million transactions**.

The main objective was to use **SQL** to clean the data, prepare it for analysis, identify customer and transaction patterns, and generate meaningful business insights.

## Dataset

* **Transactions:** 1,048,567
* **Unique Customers:** 884,265
* **Time Period:** August 1, 2016 – October 21, 2016
* **Transaction Value:** Approximately ₹165.08 crore

## Tools Used

* MySQL
* MySQL Workbench
* SQL
* CSV dataset

## Project Workflow

### 1. Database Setup

Created the `banking_analysis` database and configured the environment for importing the dataset.

### 2. Data Import

Created the `bank_transactions` table and imported the CSV dataset into MySQL.

### 3. Data Quality Checking

Checked the dataset for:

* Duplicate transaction IDs
* NULL values
* Blank values
* Invalid dates
* Invalid customer birth dates
* Unusual transaction amounts
* Unusual account balances
* Invalid or unexpected gender values

### 4. Data Cleaning

Created a cleaned version of the dataset and handled issues such as:

* Invalid `CustomerDOB` values
* Blank gender values
* Unknown gender values
* Blank customer locations
* Text transaction dates
* Numeric transaction times

Transaction dates and times were converted into proper SQL `DATE` and `TIME` formats.

### 5. Feature Engineering

Created additional analytical fields including:

* `TransactionMonth`
* `TransactionCategory`
* `TransactionYear`

These fields made the dataset easier to analyze by month, transaction size, and year.

### 6. SQL Analysis

Performed analysis covering:

* Overall transaction performance
* Monthly transaction activity
* Unique customers
* Customer transaction frequency
* Customer spending
* One-time vs repeat customers
* Customer spending segments
* Transaction amount distribution
* High-value transactions
* Location performance
* Gender-based analysis
* Time-of-day activity
* Customer transaction frequency vs spending

## Key Findings

* **16.24%** of customers were repeat customers.
* **83.76%** of customers made only one transaction.
* Repeat customers had a higher average spending per customer than one-time customers.
* Low and Medium Spenders represented approximately **93.13%** of customers.
* A small number of high-value transactions contributed substantial transaction value.
* Mumbai recorded the highest transaction volume and total transaction value among the locations analyzed.
* Evening had the highest transaction count, while afternoon had the highest total transaction value.
* Customers with more transactions generally had higher total spending within this dataset.

## SQL Concepts Demonstrated

The project used and practiced:

* `SELECT`
* `WHERE`
* `DISTINCT`
* `ORDER BY`
* `GROUP BY`
* `HAVING`
* Aggregate functions
* `CASE WHEN`
* `COALESCE`
* Subqueries
* `COUNT(DISTINCT)`
* Date and time functions
* Window functions
* Data cleaning and transformation

## Project Outcome

This project demonstrates the ability to take a large raw dataset, perform data quality checks and cleaning, transform the data, conduct customer and transaction analysis, and convert SQL results into business-oriented insights.

The project focuses on practical SQL skills relevant to **Data Analyst internship and entry-level analyst roles**.

## Important Note

The transaction categories and customer spending segments used in this project were created for analytical purposes and are not official banking classifications.

The dataset covers a limited historical period, and October 2016 contains only partial-month data. Therefore, the results should be interpreted within the scope of the available dataset.
