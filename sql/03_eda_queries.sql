--Total revenue seluruh toko.
SELECT
SUM(total_amount) AS total_revenue
FROM `pet_store.master_sales`;
--ada total 367192093,65

--Revenue per Year
SELECT
EXTRACT(YEAR FROM transaction_date) AS year,
SUM(total_amount) AS revenue
FROM `pet_store.master_sales`
GROUP BY year
ORDER BY year;

--Revenue by Category
SELECT
category_name,
SUM(total_amount) AS revenue
FROM `pet_store.master_sales`
GROUP BY category_name
ORDER BY revenue DESC;

--Top Selling Products
SELECT
product_name,
SUM(quantity) AS total_units_sold
FROM `pet_store.master_sales`
GROUP BY product_name
ORDER BY total_units_sold DESC
LIMIT 10;

--Customer Type Analysis
SELECT
transaction_type,
SUM(total_amount) AS revenue,
COUNT(DISTINCT transaction_key) AS transactions
FROM `pet_store.master_sales`
GROUP BY transaction_type;

--VIP vs Non VIP Spending
SELECT
vip_customer_flag,
SUM(total_amount) AS revenue,
COUNT(DISTINCT customer_id) AS customers
FROM `pet_store.master_sales`
GROUP BY vip_customer_flag;
