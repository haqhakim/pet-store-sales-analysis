--join sales+customers

SELECT
sales.transaction_id,
sales.transaction_date,
sales.customer_id,
customers.contact_name,
customers.vip_customer_flag,
sales.product_id,
sales.quantity,
sales.total_amount

FROM `pet_store.sales` sales

LEFT JOIN `pet_store.customers` customers
ON sales.customer_id = customers.customer_id;

--join sales+products
SELECT
sales.transaction_id,
sales.transaction_date,
sales.customer_id,
customers.contact_name,
customers.vip_customer_flag,
products.product_name,
products.category_name,
sales.quantity,
sales.total_amount

FROM `pet_store.sales` sales

LEFT JOIN `pet_store.customers` customers
ON sales.customer_id = customers.customer_id

LEFT JOIN `pet_store.products` products
ON sales.product_id = products.product_id;

--master sales table
SELECT
CONCAT(
CAST(sales.transaction_id AS STRING),'_',
COALESCE(CAST(sales.customer_id AS STRING),'guest'),'_',
CAST(sales.transaction_date AS STRING)
) AS transaction_key,

sales.transaction_id,
sales.transaction_date,
sales.transaction_type,

sales.customer_id,
customers.contact_name,
customers.vip_customer_flag,

sales.product_id,
products.product_name,
products.category_name,

sales.quantity,
sales.total_amount

FROM `pet_store.sales` sales

LEFT JOIN `pet_store.customers` customers
ON sales.customer_id = customers.customer_id

LEFT JOIN `pet_store.products` products
ON sales.product_id = products.product_id;

--Setelah join kita harus cek apakah ada data yang gagal join.
SELECT *
FROM `pet_store.sales` sales
LEFT JOIN `pet_store.products` products
ON sales.product_id = products.product_id
WHERE products.product_id IS NULL;
--0 berarti tidak ada yg gagal join

--Cek customer yang tidak match
SELECT *
FROM `pet_store.sales` sales
LEFT JOIN `pet_store.customers` customers
ON sales.customer_id = customers.customer_id
WHERE customers.customer_id IS NULL;
-- yang ada berarti mereka adalah walkin customers

--table baru supaya analisis lebih cepat.
CREATE OR REPLACE TABLE `pet_store.master_sales` AS

SELECT

CONCAT(
CAST(sales.transaction_id AS STRING),'_',
COALESCE(CAST(sales.customer_id AS STRING),'guest'),'_',
CAST(sales.transaction_date AS STRING)
) AS transaction_key,

sales.transaction_id,
sales.transaction_date,
sales.transaction_type,

sales.customer_id,
customers.contact_name,
customers.vip_customer_flag,

sales.product_id,
products.product_name,
products.category_name,

sales.quantity,
sales.total_amount

FROM `pet_store.sales` sales

LEFT JOIN `pet_store.customers` customers
ON sales.customer_id = customers.customer_id

LEFT JOIN `pet_store.products` products
ON sales.product_id = products.product_id;

--Cek Struktur Master Table
SELECT *
FROM `pet_store.master_sales`
LIMIT 10;

--Pastikan jumlah row tidak berubah dari tabel sales.
SELECT COUNT(*) 
FROM `pet_store.sales`;
--jumlah row masih sama dengan tabel sales
