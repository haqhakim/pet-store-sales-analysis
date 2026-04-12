# Pet Store Sales Analysis (BigQuery SQL)
> This project demonstrates a complete data analysis workflow using Google BigQuery, starting from raw transactional data to Exploratory Data Analysis (EDA). The goal of this project is to clean, validate, and analyze sales data to generate useful business insights.

## Project Overview
In this project, I use a dummy dataset from a pet store containing 3 tables:
1. Sales
2. Customers
3. Products

The analysis includes:
- Data cleaning and validation
- Handling missing values
- Detecting duplicate transactions
- Building a master analytical table
- Performing Exploratory Data Analysis (EDA)

**All queries were written using Google BigQuery SQL.**

## Tools
1. Google BigQuery - Data Storage and SQL Analysis
2. SQL (Standard SQL) - Data Cleaning and Analysis

## Steps
### Load Dataset into BigQuery
As mentioned above, the tables in this project are Sales, Customers, and Products. Detail column of each tables are:
1. Sales: transaction_id, transaction_date, customer_id, product_id, quantity, total_amount
2. Customers: customer_id, contact_name, vip_customer_flag
3. Products: product_id, product_name, category

### Data Cleaning

**Check Missing Values**
```sql
SELECT
COUNT(*) AS total_rows,
COUNTIF(customer_id IS NULL) AS missing_customer_id,
COUNTIF(transaction_type IS NULL) AS missing_transaction_type,
COUNTIF(transaction_id IS NULL) AS missing_transaction_id,
COUNTIF(transaction_date IS NULL) AS missing_transaction_date,
COUNTIF(product_id IS NULL) AS missing_product_id,
COUNTIF(quantity IS NULL) AS missing_quantity,
COUNTIF(total_amount IS NULL) AS missing_total_amount
FROM `pet_store.sales`;
```
