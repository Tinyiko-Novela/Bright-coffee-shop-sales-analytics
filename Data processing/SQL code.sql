-----------------------
--Overview of the data
-----------------------
SELECT*
FROM projects.default.project_1
LIMIT 10;

-----------------------------
--Number of transactions
--149116 transactions
----------------------------
SELECT COUNT(transaction_id)
FROM projects.default.project_1;

-----------------------------
--Store locations
--Lower Manhattan,Hell's Kitchen & Astoria
----------------------------
SELECT DISTINCT(store_location)
FROM projects.default.project_1;

-----------------------------
--Total number of transactions
--214470-sum
--149116-count
----------------------------
SELECT SUM(transaction_qty) AS sum,
COUNT(transaction_id) AS count
FROM projects.default.project_1;

-----------------------------
--Price range of products
--Least expensive product=0.8
--Most expensive product=45
----------------------------
SELECT MIN(unit_price) AS min_price,
MAX(unit_price) AS max_price
FROM projects.default.project_1;

-----------------------------
--Transaction dates
--Minimum date: 2023-01-01
--Maximum date: 2023-06-30
----------------------------
SELECT MIN(transaction_date) AS first_purchase_date,
MAX(transaction_date) AS last_purchase_date
FROM projects.default.project_1;

-----------------------------
--Products category
--Coffee,Tea, Drinking Chocolate, Bakery, Flavours, Loose Tea, Coffee beans, Packaged Chocolate, Branded
----------------------------
SELECT DISTINCT(product_category)
FROM projects.default.project_1;

-----------------------------
--Products type
-- 29 product types
----------------------------
SELECT DISTINCT(product_type)
FROM projects.default.project_1;

-----------------------------
--Products detail
-- 80 different types of details
----------------------------
SELECT DISTINCT(product_detail)
FROM projects.default.project_1;

-----------------------------
--Total revenue
-- 698812.33
----------------------------
SELECT ROUND(SUM(transaction_qty*unit_price),2 )AS total_revenue
FROM projects.default.project_1;

-----------------------------
--Creating time buckets
----------------------------
SELECT *,
CASE
WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '07:00' AND '09:00' THEN "early morning"
WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00' AND '12:00' THEN "late morning"
WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00' AND '15:00' THEN "early afternoon"
WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00' AND '18:00' THEN "late afternoon"
WHEN date_format(transaction_time, 'HH:mm:ss') >'18:00' THEN "late afternoon"
END AS time_buckets
FROM projects.default.project_1;

-----------------------------
--Converting time formats
----------------------------
SELECT date_format(transaction_time, 'HH:mm') as time_of_purchase
FROM projects.default.project_1

-----------------------------
--Revenue per product group
----------------------------
SELECT ROUND(SUM(transaction_qty*unit_price) )AS revenue_per_category, product_category
FROM projects.default.project_1
GROUP BY product_category
ORDER BY revenue_per_category DESC;

-----------------------------
--Sales per product
----------------------------
SELECT SUM(transaction_qty )AS total_sales, product_type
FROM projects.default.project_1
GROUP BY product_type
ORDER BY total_sales DESC;

-----------------------------
--consumer preferences
----------------------------
SELECT SUM(transaction_qty )AS sales_per_product, product_detail
FROM projects.default.project_1
GROUP BY product_detail
ORDER BY sales_per_product DESC;

-----------------------------
--Revenue per product group
----------------------------
SELECT ROUND(SUM(transaction_qty*unit_price) )AS revenue_per_store, store_location
FROM projects.default.project_1
GROUP BY store_location
ORDER BY revenue_per_store DESC;

----------------------------
--Main code
---------------------------
SELECT 
    transaction_id,
    transaction_date,
    Dayname(transaction_date) AS day_name,
    Monthname(transaction_date) AS Month_name,
    Dayofmonth(transaction_date) AS day_of_month,
    date_format(transaction_time, 'HH:mm:ss') AS time_of_purchase,
    SUM(transaction_qty*unit_price) AS revenue_per_day,
     COUNT(DISTINCT product_id) number_of_products,
     COUNT(DISTINCT store_id) number_of_stores,
     SUM(transaction_qty) AS total_number_of_sales,
     product_category,
 CASE
    WHEN SUM(transaction_qty*unit_price)<=50 THEN 'low sales'
    WHEN SUM(transaction_qty*unit_price) BETWEEN 50 AND 200  THEN 'moderate sales'
    ELSE 'High sales'
  END AS sales_category,
CASE
    WHEN Dayname(transaction_date)IN('Sat','Sun') THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_of_week,
CASE
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '08:59:59' THEN "early morning"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN "late morning"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN "early afternoon"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00:00' AND '18:00:00' THEN "late afternoon"
    WHEN date_format(transaction_time, 'HH:mm:ss') >'18:00:00' THEN "Evening"
  END AS time_buckets,
  store_location,
    product_type
FROM projects.default.project_1
GROUP BY 
transaction_id,
transaction_date,
Dayname(transaction_date),
Monthname(transaction_date),
store_location,
product_category,
 product_type,
date_format(transaction_time, 'HH:mm:ss'),
CASE
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '08:59:59' THEN "early morning"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN "late morning"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN "early afternoon"
    WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '15:00:00' AND '18:00:00' THEN "late afternoon"
    WHEN date_format(transaction_time, 'HH:mm:ss') >'18:00:00' THEN "Evening"
  END,
  CASE
    WHEN Dayname(transaction_date)IN('Sat','Sun') THEN 'Weekend'
    ELSE 'Weekday'
    END
