--cek apakah ada data kosong
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


--ternyata ada, cek ada berapa data yang kosong tersebut
SELECT
COUNT(*) AS total_transactions,
COUNTIF(customer_id IS NULL) AS missing_customer
FROM `pet_store.sales`;
--ada 9615 transaksi yang tidak ada customernya, 

--lihat itu berapa persen dari total transaksi
SELECT
ROUND(
  (COUNT(*) - COUNT(customer_id))*100.0/COUNT(*),2
) AS missing_percentage
FROM `pet_store.sales`;
--4,43% yang kosong customer_id nya. masih dalam tahap wajar, sehingga kita akan biarkan row yang kosong tersebut

--cek apakah hanya terjadi di transaksi tertentu
SELECT
transaction_type,
COUNT(*) AS total,
COUNT(customer_id) AS with_customer,
COUNT(*) - COUNT(customer_id) AS missing_customer
FROM `pet_store.sales`
GROUP BY transaction_type;
-- hanya terjadi di tipe transaksi retail. These records were retained as they likely represent walk-in customers who completed purchases without registering an account.

--sekarang akan kita cek apakah ada transaksi yang duplikat
SELECT transaction_id, COUNT(*)
FROM `pet_store.sales`
GROUP BY transaction_id
HAVING COUNT(*) > 1;
--ternyata ada banyak transaction_id yang duplikat, 

--identifikasi dulu duplikatnya
SELECT
transaction_id,
COUNT(*) AS duplicate_count
FROM `pet_store.sales`
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--Coba cek detail salah satu transaction_id, kenapa dia duplikat
SELECT *
FROM `pet_store.sales`
WHERE transaction_id = 15838236;
--During data validation, it was discovered that several transaction_id values were associated with multiple customers and transaction dates. This indicates that the transaction_id field was not globally unique and could represent multiple separate transactions. To resolve this issue, a new transaction key was created using a composite identifier combining transaction_id, customer_id, and transaction_date. This ensured accurate transaction counting and prevented aggregation errors in downstream analysis.

--cek lagi apakah banyak yg seperti ini
SELECT
transaction_id,
COUNT(DISTINCT customer_id) AS customers,
COUNT(DISTINCT transaction_date) AS dates
FROM `pet_store.sales`
GROUP BY transaction_id
HAVING customers > 1
OR dates > 1;
--karna muncul banyak row → berarti transaction_id tidak reliable, 

--buat transaction_key sebagai unique transaction baru
SELECT *,
CONCAT(
transaction_id,'_',
COALESCE(CAST(customer_id AS STRING),'guest'),'_',
transaction_date
) AS transaction_key
FROM `pet_store.sales`;

--Setelah transaction_key dibuat biasanya analyst langsung validate uniqueness.
SELECT
COUNT(*) AS total_rows,
COUNT(DISTINCT transaction_key) AS unique_transaction_keys
FROM (
SELECT
CONCAT(
CAST(transaction_id AS STRING),'_',
COALESCE(CAST(customer_id AS STRING),'guest'),'_',
CAST(transaction_date AS STRING)
) AS transaction_key
FROM `pet_store.sales`
);
--ternyata tidak unik, dari total 217107 row, hanya ada 124835 yang unik

--Cek apakah ini memang product-level rows
SELECT
transaction_key,
COUNT(*) AS items_in_transaction
FROM (
SELECT
CONCAT(
CAST(transaction_id AS STRING),'_',
COALESCE(CAST(customer_id AS STRING),'guest'),'_',
CAST(transaction_date AS STRING)
) AS transaction_key
FROM `pet_store.sales`
)
GROUP BY transaction_key
ORDER BY items_in_transaction DESC
LIMIT 10;
--After creating a composite transaction_key, it was observed that the number of unique transaction keys was smaller than the total number of rows. This indicates that the dataset is structured at the line-item level, where a single transaction can contain multiple products. Therefore, the transaction_key represents a unique transaction, while each row represents an individual product purchased within that transaction.

--Validate True Duplicate Rows Sekarang kita cek apakah ada row yang benar-benar duplikat.
SELECT
customer_id,
transaction_id,
product_id,
transaction_date,
quantity,
total_amount,
COUNT(*) AS duplicate_count
FROM `pet_store.sales`
GROUP BY
customer_id,
transaction_id,
product_id,
transaction_date,
quantity,
total_amount
HAVING COUNT(*) > 1;
--hasil 0, data is clean

--Check apakah product_id ada yang NULL
SELECT
  COUNT(*) AS null_product_id
FROM `pet_store.sales`
WHERE product_id IS NULL;
--0 artinya tidak ada data rusak

--Check jumlah produk unik
SELECT
  COUNT(DISTINCT product_id) AS unique_products
FROM `pet_store.sales`;
--ada 21 product

--Check Negative Values
SELECT *
FROM `pet_store.sales`
WHERE quantity <= 0
OR total_amount <= 0
OR product_id <= 0;
--tidak ada yang negative
