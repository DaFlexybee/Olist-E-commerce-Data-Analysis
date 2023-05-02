/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	TOP 4 *
FROM [New_project].[dbo].[olist_customers_dataset]

SELECT TOP 4 *
FROM [New_project].[dbo].[olist_geolocation_dataset]

SELECT TOP 4 *
  FROM [New_project].[dbo].[olist_order_items_dataset]


SELECT TOP 4 *
  FROM [New_project].[dbo].[olist_order_payments_dataset]
  
SELECT TOP 4 *
FROM [New_project].[dbo].[olist_order_reviews_dataset]


SELECT TOP 4 *
  FROM [New_project].[dbo].[olist_orders_dataset]

SELECT  TOP 4 *
  FROM [New_project].[dbo].[olist_products_dataset]

SELECT TOP 4 *
  FROM [New_project].[dbo].[olist_sellers_dataset]

SELECT TOP 4 *
  FROM [New_project].[dbo].[product_category_name_translation]


=====================================================================================================
-- WE BEGIN BY CLEANING THROUGH EACH TABLE
-- 1. To clean customer table

--To capitalize the customer_city column
UPDATE [New_project].[dbo].[olist_customers_dataset]
SET customer_city = UPPER(SUBSTRING(customer_city, 1, 1)) + LOWER(SUBSTRING(customer_city, 2, LEN(customer_city)))

----To change the naming convention of customer states from short to long
UPDATE [New_project].[dbo].[olist_customers_dataset]
SET customer_state = 
CASE customer_state
    WHEN 'AC' THEN 'Acre'
    WHEN 'AL' THEN 'Alagoas'
    WHEN 'AP' THEN 'Amapa'
    WHEN 'AM' THEN 'Amazonas'
    WHEN 'BA' THEN 'Bahia'
    WHEN 'CE' THEN 'Ceara'
    WHEN 'DF' THEN 'Distrito Federal'
    WHEN 'ES' THEN 'Espirito Santo'
    WHEN 'GO' THEN 'Goias'
    WHEN 'MA' THEN 'Maranhao'
    WHEN 'MT' THEN 'Mato Grosso'
    WHEN 'MS' THEN 'Mato Grosso do Sul'
    WHEN 'MG' THEN 'Minas Gerais'
    WHEN 'PA' THEN 'Para'
    WHEN 'PB' THEN 'Paraiba'
    WHEN 'PR' THEN 'Parana'
    WHEN 'PE' THEN 'Pernambuco'
    WHEN 'PI' THEN 'Piaui'
    WHEN 'RJ' THEN 'Rio de Janeiro'
    WHEN 'RN' THEN 'Rio Grande do Norte'
    WHEN 'RS' THEN 'Rio Grande do Sul'
    WHEN 'RO' THEN 'Rondonia'
    WHEN 'RR' THEN 'Roraima'
    WHEN 'SC' THEN 'Santa Catarina'
    WHEN 'SP' THEN 'Sao Paulo'
    WHEN 'SE' THEN 'Sergipe'
    WHEN 'TO' THEN 'Tocantins'
END;


-- 2. To clean geolocation table
SELECT TOP 4*
FROM [New_project].[dbo].[olist_geolocation_dataset]


-- there are rows that exist as poá instead of poa so we fix it
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = TRANSLATE(geolocation_city, 'áãçéíóúôâêõ', 'aaceiouoaeo')
WHERE geolocation_city LIKE '%[áãçéíóúôâêõ]%';

--some rows have apostrophe in them while some dont and belong to same name, for example (olho d'agua grande and olho dagua grande) and many more
--so it will not shrew our results while grouping by city
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = REPLACE(geolocation_city, '''', '')
WHERE geolocation_city LIKE '%''%';

--There is a row that appear to have ... in the begining like (...arraial do cabo), we will remove the ...

UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = SUBSTRING(geolocation_city, 4, LEN(geolocation_city))
WHERE LEFT(geolocation_city, 3) = '...';

--There is another row that appear to have * in the begining like (* cidade), we will remove the *

UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = SUBSTRING(geolocation_city, 2, LEN(geolocation_city))
WHERE LEFT(geolocation_city, 1) = '*';

--There is another row that appear to have 4o.  in the begining like (4o. centenario), we will remove the 4o.
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = STUFF(geolocation_city, 1, 4, '')
WHERE LEFT(geolocation_city, 4) = '4o. ';

--There is another row that appear to have repeated like rio de janeiro, rio de janeiro, brasil, we will extract and retain 1 of them
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = SUBSTRING(geolocation_city, 1, CHARINDEX('rio de janeiro', geolocation_city) + LEN('rio de janeiro') - 1)
WHERE CHARINDEX('rio de janeiro', geolocation_city) > 0;

--There is another row that appear to have z-3  towards the end like (colonia z-3), we will remove the z-3.
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = LEFT(geolocation_city, LEN(geolocation_city) - 3)
WHERE geolocation_city LIKE '%z-3';

--There is another row that appear to have something like sao joao do pau d%26apos%3balho
-- d%26apos%3balho shows its a form of encoding hence removing whats used to encode it.
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = REPLACE(REPLACE(geolocation_city, '%26apos%3B', ''''), '%26', '&')
WHERE geolocation_city LIKE '%sao joao do pau d%';

--there are some space in between the result hence we remove the space in between them
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = REPLACE(geolocation_city, ' ', '')
WHERE geolocation_city LIKE '%d alho%';

--to capitalize the column
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_city = UPPER(SUBSTRING(geolocation_city, 1, 1)) + LOWER(SUBSTRING(geolocation_city, 2, LEN(geolocation_city)))

--To change the naming convention of geolocation states from short to long
UPDATE [New_project]..[olist_geolocation_dataset]
SET geolocation_state = 
CASE geolocation_state
    WHEN 'AC' THEN 'Acre'
    WHEN 'AL' THEN 'Alagoas'
    WHEN 'AP' THEN 'Amapa'
    WHEN 'AM' THEN 'Amazonas'
    WHEN 'BA' THEN 'Bahia'
    WHEN 'CE' THEN 'Ceara'
    WHEN 'DF' THEN 'Distrito Federal'
    WHEN 'ES' THEN 'Espirito Santo'
    WHEN 'GO' THEN 'Goias'
    WHEN 'MA' THEN 'Maranhao'
    WHEN 'MT' THEN 'Mato Grosso'
    WHEN 'MS' THEN 'Mato Grosso do Sul'
    WHEN 'MG' THEN 'Minas Gerais'
    WHEN 'PA' THEN 'Para'
    WHEN 'PB' THEN 'Paraiba'
    WHEN 'PR' THEN 'Parana'
    WHEN 'PE' THEN 'Pernambuco'
    WHEN 'PI' THEN 'Piaui'
    WHEN 'RJ' THEN 'Rio de Janeiro'
    WHEN 'RN' THEN 'Rio Grande do Norte'
    WHEN 'RS' THEN 'Rio Grande do Sul'
    WHEN 'RO' THEN 'Rondonia'
    WHEN 'RR' THEN 'Roraima'
    WHEN 'SC' THEN 'Santa Catarina'
    WHEN 'SP' THEN 'Sao Paulo'
    WHEN 'SE' THEN 'Sergipe'
    WHEN 'TO' THEN 'Tocantins'
END;


-- i might have to drop both geolocation_lat and geolocation_lng columns as i wont be needing them for my analysis


--3. TO clean order item table let us check what and what will be needed
SELECT TOP 4*
 FROM [New_project].[dbo].[olist_order_items_dataset]

 --just to split the shipping limit date column and round the price and freight value columns into  deciamal place
 --To split the shipping limit date column
ALTER TABLE [New_project].[dbo].[olist_order_items_dataset] ADD shipping_limit_datee DATE
ALTER TABLE [New_project].[dbo].[olist_order_items_dataset] ADD shipping_limit_time TIME

UPDATE [New_project].[dbo].[olist_order_items_dataset] 
SET shipping_limit_datee = CONVERT(DATE, shipping_limit_date),
    shipping_limit_time = CAST(FORMAT(shipping_limit_date, 'hh:mm:ss') AS TIME)

--drop previous shipping_limit_date column
ALTER TABLE [New_project].[dbo].[olist_order_items_dataset]
DROP COLUMN shipping_limit_date 

--TO ROUND PRICE AND FREIGHT VALUE COLUMN UP TO 2 DECIMAL PLACES
--FOR PRICE
UPDATE [New_project].[dbo].[olist_order_items_dataset]
SET price = ROUND(price, 2)

--FOR FREIGHT VALUE
UPDATE [New_project].[dbo].[olist_order_items_dataset]
SET freight_value = ROUND(freight_value, 2)


--4. TO CLEAN THE ORDER PAYMENTS TABLE
--Only thing to do is round paymenr value up by 2 decimal point
UPDATE [New_project].[dbo].[olist_order_payments_dataset]
SET payment_value = ROUND(payment_value, 2)


--5. TO CLEAN ORDERS TABLE
--We split all time stamp columns into seperate date and time
SELECT TOP 4 *
FROM [New_project].[dbo].[olist_orders_dataset]

--ADDING NEW TABLES

ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_purchase_date DATE
ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_purchase_time TIME

ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_approved_date DATE
ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_approved_time TIME

ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_delivered_to_carrier_date DATE
ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_delivered_to_carrier_time TIME

ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_delivered_to_customer_date DATE
ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_delivered_to_customer_time TIME

ALTER TABLE [New_project].[dbo].[olist_orders_dataset] ADD order_estimateddelivery_date DATE

--POPULATE order_purchase_date and time
UPDATE [New_project].[dbo].[olist_orders_dataset]
SET order_purchase_date = CONVERT(DATE, order_purchase_timestamp),
    order_purchase_time = CAST(FORMAT(order_purchase_timestamp, 'hh:mm:ss') AS TIME)

--POPULATE order_approved_date and time
UPDATE [New_project].[dbo].[olist_orders_dataset]
SET order_approved_date = CONVERT(DATE, order_approved_at),
    order_approved_time = CAST(FORMAT(order_approved_at, 'hh:mm:ss') AS TIME)

--POPULATE order_delivered_to_carrier_date and time
UPDATE [New_project].[dbo].[olist_orders_dataset]
SET order_delivered_to_carrier_date = CONVERT(DATE, order_delivered_carrier_date),
    order_delivered_to_carrier_time = CAST(FORMAT(order_delivered_carrier_date, 'hh:mm:ss') AS TIME)

--POPULATE order_delivered_to_customer_date and time
UPDATE [New_project].[dbo].[olist_orders_dataset]
SET order_delivered_to_customer_date = CONVERT(DATE, order_delivered_customer_date),
    order_delivered_to_customer_time = CAST(FORMAT(order_delivered_customer_date, 'hh:mm:ss') AS TIME)

--POPULATE order_estimateddelivery_date
UPDATE [New_project].[dbo].[olist_orders_dataset]
SET order_estimateddelivery_date = CONVERT(DATE, order_estimated_delivery_date)

--DROP OLD COLUMNS
ALTER TABLE [New_project].[dbo].[olist_orders_dataset]
DROP COLUMN order_purchase_timestamp 

ALTER TABLE [New_project].[dbo].[olist_orders_dataset]
DROP COLUMN order_approved_at 

ALTER TABLE [New_project].[dbo].[olist_orders_dataset]
DROP COLUMN order_delivered_carrier_date 

ALTER TABLE [New_project].[dbo].[olist_orders_dataset]
DROP COLUMN order_delivered_customer_date 

ALTER TABLE [New_project].[dbo].[olist_orders_dataset]
DROP COLUMN order_estimated_delivery_date 


--6. TO CLEAN PRODUCT TABLE
-- OUR PRODUCT Category name is in spanish and we will need it in english
SELECT *
FROM [New_project].[dbo].[olist_products_dataset]

ALTER TABLE [New_project].[dbo].[olist_products_dataset] ADD Product_category NVARCHAR(50) ;

--Populate the new column with categoryname in english

UPDATE  [New_project].[dbo].[olist_products_dataset]
SET Product_category = t2.product_category_name_in_english
FROM [New_project].[dbo].[olist_products_dataset] t1
JOIN [New_project].[dbo].[product_category_name_translation] t2 ON t1.product_category_name = t2.product_category_name;

--Check for Null
SELECT DISTINCT Product_category, product_category_name
FROM [New_project].[dbo].[olist_products_dataset] 
GROUP BY Product_category, product_category_name

----They are 1. pc_gamer 2. portateis_cozinha_e_preparadores_de_alimentos and 3. the Null record from the Products table
--lets insert the actuall translation into our null columns
INSERT INTO [New_project].[dbo].[product_category_name_translation] (product_category_name, product_category_name_in_english)
VALUES ('pc_gamer', 'gaming_pc');

INSERT INTO [New_project].[dbo].[product_category_name_translation] (product_category_name, product_category_name_in_english)
VALUES ('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparators');

INSERT INTO [New_project].[dbo].[product_category_name_translation] (product_category_name, product_category_name_in_english)
VALUES ('N/A', 'N/A');

--Confirm changes
SELECT top 4 *
FROM [New_project].[dbo].[olist_products_dataset] 
where product_category like '%portable%'


--Drop old product category name column
ALTER TABLE  [New_project].[dbo].[olist_products_dataset]
DROP COLUMN product_category_name 


--7. TO CLEAN SELLERS TABLE
SELECT top 4 *
  FROM [New_project].[dbo].[olist_sellers_dataset]
  --WE ONLY NEED TO CAPITALIZE SELLER CITY COLUMN

UPDATE [New_project].[dbo].[olist_sellers_dataset]
SET seller_city= UPPER(SUBSTRING(seller_city, 1, 1)) + LOWER(SUBSTRING(seller_city, 2, LEN(seller_city))) 

----To change the naming convention of Seller states from short to long
UPDATE [New_project].[dbo].[olist_sellers_dataset]
SET seller_state = 
CASE seller_state
    WHEN 'AC' THEN 'Acre'
    WHEN 'AL' THEN 'Alagoas'
    WHEN 'AP' THEN 'Amapa'
    WHEN 'AM' THEN 'Amazonas'
    WHEN 'BA' THEN 'Bahia'
    WHEN 'CE' THEN 'Ceara'
    WHEN 'DF' THEN 'Distrito Federal'
    WHEN 'ES' THEN 'Espirito Santo'
    WHEN 'GO' THEN 'Goias'
    WHEN 'MA' THEN 'Maranhao'
    WHEN 'MT' THEN 'Mato Grosso'
    WHEN 'MS' THEN 'Mato Grosso do Sul'
    WHEN 'MG' THEN 'Minas Gerais'
    WHEN 'PA' THEN 'Para'
    WHEN 'PB' THEN 'Paraiba'
    WHEN 'PR' THEN 'Parana'
    WHEN 'PE' THEN 'Pernambuco'
    WHEN 'PI' THEN 'Piaui'
    WHEN 'RJ' THEN 'Rio de Janeiro'
    WHEN 'RN' THEN 'Rio Grande do Norte'
    WHEN 'RS' THEN 'Rio Grande do Sul'
    WHEN 'RO' THEN 'Rondonia'
    WHEN 'RR' THEN 'Roraima'
    WHEN 'SC' THEN 'Santa Catarina'
    WHEN 'SP' THEN 'Sao Paulo'
    WHEN 'SE' THEN 'Sergipe'
    WHEN 'TO' THEN 'Tocantins'
END;

================================================================================================================================
--NOW BACK TO BUSINESS TASK
--1: What is the total revenue generated by Olist, and how has it changed over time?
-- Total revenue generated by Olist
SELECT ROUND(SUM(payment_value), 2) as "Total Revenue" 
FROM [New_project].[dbo].[olist_orders_dataset] ood
INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON ood.order_id = oop.order_id
WHERE ood.order_status != 'canceled' and ood.order_status != 'created' 

---How has it changed over time
SELECT YEAR(order_purchase_date) as Year,  DATEPART(QUARTER, order_purchase_date) AS Revenue_Quarter, ROUND(SUM(payment_value), 2) as Total_revenue 
FROM [New_project].[dbo].[olist_orders_dataset] ood
INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON ood.order_id = oop.order_id
WHERE ood.order_status != 'canceled' and ood.order_status != 'created' 
GROUP BY YEAR(order_purchase_date), DATEPART(QUARTER, order_purchase_date)
ORDER BY Year, Revenue_Quarter

--2: How many orders were placed on Olist, and how does this vary by month or season?
--How many orders were placed on Olist
SELECT COUNT(order_id) as Number_of_orders
FROM [New_project].[dbo].[olist_orders_dataset]
WHERE order_status != 'created'

-- how does this vary by month or season
SELECT YEAR(order_purchase_date) as Year, DATEPART(QUARTER, order_purchase_date) AS Order_Quarter, COUNT(*) as Number_of_orders
FROM [New_project].[dbo].[olist_orders_dataset]
WHERE order_status != 'created'
GROUP BY YEAR(order_purchase_date), DATEPART(QUARTER, order_purchase_date)
ORDER BY Year, Order_Quarter

--3: What are the most popular product categories on Olist, and how do their sales volumes compare to each other? 

SELECT op.product_category AS product_category, ROUND(SUM(oop.payment_value),2) AS total_sales_volume
FROM [New_project].[dbo].[olist_orders_dataset] ood
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON ood.order_id = oop.order_id
	INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON ood.order_id = oi.order_id
	INNER JOIN [New_project].[dbo].[olist_products_dataset] op ON oi.product_id = op.product_id 
WHERE order_status !='canceled'
GROUP BY op.product_category
ORDER BY total_sales_volume DESC;

--4: What is the average order value (AOV) on Olist, and how does this vary by product category or payment method?
SELECT  ROUND(AVG(oop.payment_value),2) AS Average_order_value
FROM [New_project].[dbo].[olist_orders_dataset] ood
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON ood.order_id = oop.order_id
	INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON ood.order_id = oi.order_id
	INNER JOIN [New_project].[dbo].[olist_products_dataset] op ON oi.product_id = op.product_id 
WHERE order_status !='canceled'
ORDER BY  average_order_value DESC;

SELECT  oop.payment_type AS Payment_method, ROUND(AVG(oop.payment_value),2) AS Average_order_value, COUNT(DISTINCT oop.order_id) AS Number_of_Orders
FROM [New_project].[dbo].[olist_orders_dataset] ood
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON ood.order_id = oop.order_id
	INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON ood.order_id = oi.order_id
	INNER JOIN [New_project].[dbo].[olist_products_dataset] op ON oi.product_id = op.product_id 
WHERE order_status !='canceled'
GROUP BY  oop.payment_type
ORDER BY  average_order_value DESC;


-- 5: How many sellers are active on Olist, and how does this number change over time?

--Going further by showing the seller first and last order and how many products had been listed by each of these sellers
SELECT DATEPART(YEAR, o.order_purchase_date) AS Active_year,
	COUNT(DISTINCT os.seller_id) AS Number_of_active_sellers, 
	COUNT(DISTINCT o.order_id) AS num_orders, 
	MIN(o.order_purchase_date) AS first_order,
	MAX(o.order_purchase_date) AS last_order,
	  COUNT(DISTINCT op.product_id) AS num_products_listed,
	 ROUND(SUM(payment_value), 2) AS total_revenue
FROM [New_project].[dbo].[olist_orders_dataset] o
   JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON o.order_id = oi.order_id
   JOIN [New_project].[dbo].[olist_sellers_dataset] os ON oi.seller_id = os.seller_id
   JOIN [New_project].[dbo].[olist_products_dataset] op ON oi.product_id = op.product_id
   JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON o.order_id = oop.order_id
WHERE o.order_status != 'canceled'
GROUP BY DATEPART(YEAR, o.order_purchase_date) 
HAVING DATEDIFF(MONTH, MIN(o.order_purchase_date), MAX(o.order_purchase_date)) >= 3 ---Using 3 momths threshold(Every seller must have had 3 months in between there first and last order to be counted among those who are active)
ORDER BY num_orders DESC;

-- 6: What is the distribution of seller ratings on Olist, and how does this impact sales performance?
--Showing ths distribution of the score rating
SELECT review_score, COUNT(DISTINCT o.order_id) AS num_orders, ROUND(SUM(payment_value), 2) AS total_revenue,
ROUND(SUM(payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue
FROM [New_project].[dbo].[olist_order_reviews_dataset] oor
	INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oor.order_id = o.order_id
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oor.order_id = oop.order_id
	INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON oor.order_id = oi.order_id
GROUP BY  review_score 
ORDER BY 1 DESC;

--Showing how these ratings are distributed among the sellers
SELECT seller_id, review_score, COUNT(review_score) AS review_count, COUNT(DISTINCT o.order_id) AS num_orders, ROUND(SUM(payment_value), 2) AS total_revenue
FROM [New_project].[dbo].[olist_order_reviews_dataset] oor
	INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oor.order_id = o.order_id
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oor.order_id = oop.order_id
	INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON oor.order_id = oi.order_id
GROUP BY seller_id, review_score 
ORDER BY 3 DESC;

---To further show how many reviews these sellers has including number of orders and the total review they generate
SELECT seller_id, review_score, COUNT(review_score) AS review_count, COUNT(DISTINCT o.order_id) AS num_orders,
ROUND(SUM(payment_value), 2) AS total_revenue, ROUND(SUM(payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue
FROM [New_project].[dbo].[olist_order_reviews_dataset] oor
INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oor.order_id = o.order_id
INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oor.order_id = oop.order_id
INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON oor.order_id = oi.order_id
GROUP BY seller_id, review_score
ORDER BY 3 DESC;


-- 7: How many customers have made repeated purchases on Olist, and what percentage of total sales do they account for?
--Those customers with repeated purchases and how much they have spent individualy
SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS OrderCount, ROUND(SUM(payment_value), 2) AS total_spent
FROM [New_project].[dbo].[olist_orders_dataset] o
	INNER JOIN [New_project].[dbo].[olist_customers_dataset] c ON o.customer_id = c.customer_id
	INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON o.order_id = oop.order_id
GROUP BY c.customer_unique_id
HAVING    COUNT(DISTINCT o.order_id) > 1
ORDER BY  2 DESC;
---
--- This shows the percentage of repeated customers compare to toal number of customers they do have
WITH repeated_customers AS (
    SELECT c.customer_unique_id, 
        COUNT(DISTINCT o.order_id) AS OrderCount, 
        ROUND(SUM(payment_value), 2) AS total_spent
    FROM [New_project].[dbo].[olist_orders_dataset] o
			INNER JOIN [New_project].[dbo].[olist_customers_dataset] c ON o.customer_id = c.customer_id
			INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON o.order_id = oop.order_id
    GROUP BY c.customer_unique_id
    HAVING   COUNT(DISTINCT o.order_id) > 1
)
SELECT COUNT(DISTINCT rc.customer_unique_id) AS num_repeated_customers,
    ROUND(SUM(rc.total_spent) / (SELECT SUM(payment_value) FROM [New_project].[dbo].[olist_order_payments_dataset]), 2) * 100 AS repeated_customer_sales_percentage
FROM   repeated_customers rc;

-- Approximately 6% of the repeated customers account for the total sales for Olist
--indicating a very low repeated_customers percentage. This show us that about 94% of the customers that 
-- purchased products are first timers and Olist doesnt have a good customer retention rate.

-- 8: What is the average customer rating for products sold on Olist, and how does this impact sales performance?

---This shows the rating distrbutuon, total number of products that have received these ratings and how much they've generated

--This further show how it impact sales performance
SELECT op.product_category, review_score, AVG(review_score) AS review_count, COUNT(DISTINCT o.order_id) AS num_orders,
ROUND(SUM(payment_value), 2) AS total_revenue, ROUND(SUM(payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue
FROM [New_project].[dbo].[olist_order_reviews_dataset] oor
INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oor.order_id = o.order_id
INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oor.order_id = oop.order_id
INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON oor.order_id = oi.order_id
INNER JOIN [New_project].[dbo].[olist_products_dataset] op ON oi.product_id = op.product_id 
WHERE o.order_status != 'canceled' and o.order_status != 'created' 
GROUP BY op.product_category, review_score
ORDER BY 5 DESC;
--
--9 What is the average order cancellation rate on Olist, and how does this impact seller performance?.

--This shows the rate at which orders get cancled, number of cancled orders, how much lost to cancletaion and the number of sellers with cancled orders
SELECT ROUND(CAST(COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) AS FLOAT) / COUNT(*) * 100, 2) AS cancellation_rate,
    COUNT(DISTINCT oi.order_id) AS num_orders,
	ROUND(SUM(payment_value), 2) AS "Amount lost",
    COUNT(DISTINCT oi.seller_id) AS num_sellers
FROM	[New_project].[dbo].[olist_order_items_dataset] oi
		INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oi.order_id = o.order_id
		INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oi.order_id = oop.order_id

--This shows the sellers with cancled orders, the rate and the number of orders that they have had to cancle, showing there performance

SELECT  s.seller_id,
    ROUND(CAST(COUNT(CASE WHEN o.order_status = 'canceled' THEN 1 END) AS FLOAT) / COUNT(o.order_id) * 100, 2) AS cancellation_rate,
    COUNT(DISTINCT o.order_id) AS num_orders
FROM [New_project].[dbo].[olist_orders_dataset] o
    INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON o.order_id = oi.order_id
    INNER JOIN [New_project].[dbo].[olist_sellers_dataset] s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY cancellation_rate DESC;

--10 What are the top-selling products on Olist, and how have their sales trends changed over time?

SELECT p.Product_category, 
    ROUND(SUM(payment_value), 2) AS total_sales_generated, 
    COUNT(DISTINCT oi.order_id) AS num_orders, 
    YEAR(o.order_purchase_date) AS order_year, 
    DATEPART(QUARTER, o.order_purchase_date) AS order_Quarter
FROM [New_project].[dbo].[olist_order_items_dataset] oi 
    INNER JOIN [New_project].[dbo].[olist_products_dataset] p ON oi.product_id = p.product_id
	INNER JOIN [New_project].[dbo].[olist_orders_dataset] o ON oi.order_id = o.order_id
	  INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] oop ON oi.order_id = oop.order_id
GROUP BY p.Product_category, 
    YEAR(o.order_purchase_date), 
    DATEPART(QUARTER, o.order_purchase_date) 
ORDER BY total_sales_generated DESC;

--11: Which payment methods are most commonly used by Olist customers, and how does this
--vary by product category or geographic region?
--A. Total count of orders by each payment type
SELECT payment_type, COUNT(DISTINCT order_id) AS num_orders
FROM [New_project].[dbo].[olist_order_payments_dataset]
GROUP BY payment_type
ORDER BY num_orders DESC;

--B. For each product category
SELECT p.product_category, op.payment_type, COUNT(DISTINCT oi.order_id) AS num_orders
FROM [New_project].[dbo].[olist_order_items_dataset] oi
JOIN [New_project].[dbo].[olist_products_dataset] p ON oi.product_id = p.product_id
JOIN [New_project].[dbo].[olist_order_payments_dataset] op ON oi.order_id = op.order_id
GROUP BY p.product_category, op.payment_type
ORDER BY num_orders DESC;

--C. By geographic region
SELECT g.geolocation_city, op.payment_type, COUNT(DISTINCT o.order_id) AS num_orders
FROM [New_project].[dbo].[olist_orders_dataset] o
JOIN [New_project].[dbo].[olist_customers_dataset] c ON o.customer_id = c.customer_id
JOIN [New_project].[dbo].[olist_geolocation_dataset] g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN [New_project].[dbo].[olist_order_payments_dataset] op ON o.order_id = op.order_id
GROUP BY g.geolocation_city, op.payment_type
ORDER BY 3 DESC;

--12.  How do customer reviews and ratings affect sales and product performance on Olist?

SELECT	CASE 
		WHEN review_score = 5 THEN 'Excellent'
		WHEN review_score = 4 THEN 'Very Good'
		WHEN review_score = 3 THEN 'Good'
		WHEN review_score = 2 THEN 'Bad'
		WHEN review_score = 1 THEN 'Very Bad'
	END AS rating, 
	COUNT(p.product_id) AS no_products, 
	ROUND(SUM(op.payment_value),2) AS total_rev, 
	ROUND(SUM(op.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue
FROM [New_project].[dbo].[olist_orders_dataset] o
INNER JOIN [New_project].[dbo].[olist_order_reviews_dataset] r ON o.order_id = r.order_id
INNER JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON o.order_id = oi.order_id
INNER JOIN [New_project].[dbo].[olist_order_payments_dataset] op ON o.order_id = op.order_id
INNER JOIN [New_project].[dbo].[olist_products_dataset] p ON oi.product_id = p.product_id
WHERE order_status != 'canceled' AND order_approved_date IS NOT NULL
GROUP BY review_score
ORDER BY avg_revenue;

--DEDUCTION
/*
According to the results of our query, customers purchased the majority of products with very good or excellent ratings, 
as evidenced by the fact that the number of 'Excellent rated' products purchased within the two-year period was the highest, 
with a total of 66,315 products. On the other end of the scale (negative feedback),
The number of products purchased was small in comparison to the overall average. The sales performance for the excellent rated goods, 
on the other hand, was poor, with an average revenue of $186.88. Low-rated goods, on the other hand, performed better in terms of sales. 
This could be because low-rated products are more expensive, whereas highly rated products are less expensive.

*/

--13: Which product categories have the highest profit margins on Olist, and how can the
--company increase profitability across different categories?

-- We are not sure what the actual cost price is for those products hence we use the price given for calculation 
--which amounts for payment value minus the freight price to calculate profit margin
SELECT p.product_category AS category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_shipping_costs,
    ROUND(SUM(payment_value), 2) AS total_payments_received,
    ROUND(SUM(payment_value - oi.freight_value), 2) AS total_profit,
    ROUND(((SUM(payment_value- oi.freight_value)) / SUM(oi.price)) * 100, 2) AS percentage_profit_margin
FROM [New_project].[dbo].[olist_orders_dataset] o
    JOIN [New_project].[dbo].[olist_order_items_dataset] oi ON o.order_id = oi.order_id
    JOIN [New_project].[dbo].[olist_sellers_dataset] s ON oi.seller_id = s.seller_id
	JOIN [New_project].[dbo].[olist_order_payments_dataset] op ON o.order_id = op.order_id
    JOIN [New_project].[dbo].[olist_products_dataset] p ON oi.product_id = p.product_id
GROUP BY  p.product_category
ORDER BY 6 DESC;




