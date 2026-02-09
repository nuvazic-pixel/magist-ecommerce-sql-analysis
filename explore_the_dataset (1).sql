USE magist;


##############################3 Explore The Tables ##############################################

/* 1. How many orders are there in the dataset.
 
The orders table contains a row for each order, so this should be easy to find out!*/

SELECT 
    COUNT(*) AS total_orders
FROM
    orders;

/* 2. Are orders actually delivered? 

Look at the columns in the orders table: one of them is called order_status. 
Most orders seem to be delivered, but some aren’t. 
Find out how many orders are delivered and how many are cancelled, unavailable, 
or in any other status by grouping and aggregating this column.
*/

SELECT 
    order_status,
    COUNT(*) AS total_by_status,
    ROUND(COUNT(*) * 100 / (SELECT 
                    COUNT(*)
                FROM
                    orders),
            2) AS status_percentage
FROM
    orders
GROUP BY order_status;

/*
3. Is Magist having user growth? 

A platform losing users left and right isn’t going to be very useful to us. 
It would be a good idea to check for the number of orders grouped by year and month.
Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.
*/

SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(order_id) AS total_orders_in_month
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_;
    
    /*
4. How many products are there on the products table? 
(Make sure that there are no duplicate products.)
*/

SELECT
    COUNT(DISTINCT product_id) AS total_unique_products
FROM
    products;

/*
5. Which are the categories with the most products? 

Since this is an external database and has been partially anonymized, 
we do not have the names of the products. 
But we do know which categories products belong to. 
This is the closest we can get to knowing what sellers are offering in the Magist marketplace. 
By counting the rows in the products table and grouping them by categories, 
we will know how many products are offered in each category. 
This is not the same as how many products are actually sold by category.
To acquire this insight we will have to combine multiple tables together: 
we’ll do this in the next lesson.
*/

SELECT 
    product_category_name,
    COUNT(DISTINCT product_id) AS total_products,
    ROUND(COUNT(DISTINCT product_id) * 100 / (SELECT 
                    COUNT(DISTINCT product_id)
                FROM
                    products),
            2) AS category_percentage
FROM
    products
GROUP BY product_category_name
ORDER BY total_products DESC;

/*
6. How many of those products were present in actual transactions? 
The products table is a “reference” of all the available products. 
Have all these products been involved in orders? 
Check out the order_items table to find out!
*/

SELECT
	COUNT(DISTINCT product_id) AS number_of_unique_products_sold
FROM
	order_items;

/*
7. What’s the price for the most expensive and cheapest products? 
Sometimes, having a broad range of prices is informative. 
Looking for the maximum and minimum values is also a good way to detect extreme outliers.
*/

SELECT
	MAX(price) AS most_expensive_product,
    MIN(price) AS cheapest_product
FROM
	order_items;

/*
8. What are the highest and lowest payment values? 
Some orders contain multiple products. 
What’s the highest someone has paid for an order? 
Look at the order_payments table and try to find it out.
 */

SELECT
	MAX(payment_value) AS highest_payment_value,
    MIN(payment_value) AS lowest_payment_value
FROM
	order_payments;
    
/* Maximum value of an order */

SELECT
	ROUND(SUM(payment_value),2) AS highest_order_value
FROM
	order_payments
GROUP BY order_id
ORDER BY highest_order_value DESC
LIMIT 1;

##############################3 Further Business Questions ##############################################

/* 0. What categories of tech products does Magist have?*/

/* 'audio' , 'electronics',
        'computer_accessories',
        'computers',
        'table_printing_image',
        'telephony' */

/* 1. How many products of these tech categories have been sold (within the time window of the database snapshot)?*/

SELECT
	COUNT(DISTINCT product_id) AS sold_tech_products
FROM
	products
 		LEFT JOIN
	order_items USING(product_id)
		LEFT JOIN
	orders USING(order_id)
WHERE product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia') AND order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 3367

/* 2. What percentage does that represent from the overall number of products sold?*/

SELECT 
    COUNT(DISTINCT product_id) AS products_sold
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
WHERE
    order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 32729

SELECT 3367/32729;
-- 10.29%

/* 3. What’s the average price of the products being sold?*/

SELECT 
    ROUND(AVG(price), 2) AS avg_product_price
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
WHERE
    order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 120.38

SELECT
	ROUND(AVG(price),2) AS avg_tech_price
FROM
	products
    LEFT JOIN order_items USING(product_id)
    LEFT JOIN orders USING(order_id)
WHERE product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia') AND order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 105.96

/* 4. Are expensive tech products popular?*/

-- total number of products ordered

SELECT
	COUNT(*)
FROM
	order_items;
-- 112650 products ordered in total

-- number of tech products ordered grouped by price level
SELECT 
    CASE
		WHEN price > 200 THEN 'expensive'
        ELSE 'not expensive'
	END AS price_level,
    COUNT(*) AS number_of_products
FROM
    products
        LEFT JOIN
    order_items USING (product_id)
WHERE
    product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia')
GROUP BY price_level
ORDER BY number_of_products;
-- expensive tech products sold: 1459

SELECT ROUND(1459/112650*100,2);
-- only 1.3% of products sold are expensive tech products, therefore they're not popular

/* 5. How many months of data are included in the magist database?*/

SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT MONTH(order_purchase_timestamp)) AS months_in_year
FROM
    orders
GROUP BY order_year;

SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp))
FROM
    orders;
-- 25

/* 6. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?*/
		
SELECT 
    (SELECT 
            COUNT(DISTINCT seller_id)
        FROM
            sellers) AS total_sellers,
    COUNT(DISTINCT seller_id) AS total_tech_sellers,
    ROUND(COUNT(DISTINCT seller_id) * 100 / (SELECT 
                    COUNT(DISTINCT seller_id)
                FROM
                    sellers),
            2) AS tech_sellers_percentage
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia');

/* 7. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?*/

-- amount earned by all sellers
SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
WHERE
    order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 13,494,400.74

-- amount earned by tech sellers

SELECT 
    ROUND(SUM(price), 2) AS total_revenue
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia')
        AND order_status NOT IN ('unavailable' , 'canceled', 'created');
-- 1,664,904.34

-- percentage of revenue by tech sellers
SELECT ROUND(1664904.34/13494400.74 *100,2);
-- 12.34 percent of revenue comes from the sale of tech products

/* 8. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?*/

-- For all sellers

SELECT ROUND(13494400.74/ 3095 / 25,2);
-- 174.40

SELECT ROUND(13494400.74/25,2);
-- 539,776.03


-- For tech sellers
-- total revenue
SELECT 
    ROUND(SUM(price), 2) AS total_tech_revenue
FROM
    order_items
        LEFT JOIN
    orders USING (order_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    order_status NOT IN ('unavailable' , 'canceled', 'created')
        AND product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia');
-- 1,664,904.34

-- monthly income

SELECT ROUND(1664904.34/453/25,2);
-- 147.01

SELECT ROUND(1664904.34/25,2);
-- 66,596.17

/* 9. What’s the average time between the order being placed and the product being delivered?*/
-- delivery estimation:

-- average estimated delivery time of all products
SELECT 
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date,
                    order_purchase_timestamp)),
            2) AS avg_delivery_estimation
FROM
    orders
WHERE
    order_estimated_delivery_date IS NOT NULL;
-- 24.33

-- average delivery time of all products:
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            2) AS avg_delivery_time_days
FROM
    orders
WHERE
    order_delivered_customer_date IS NOT NULL;
-- 12.5 days
    
-- for tech products

-- delivery estimation:
SELECT 
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date,
                    order_purchase_timestamp)),
            2) AS avg_delivery_estimation_tech
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    order_estimated_delivery_date IS NOT NULL
        AND product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia');
-- 24.79

-- delivery time:
SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            2) AS avg_delivery_time_tech
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    products USING (product_id)
WHERE
    order_delivered_customer_date IS NOT NULL
        AND product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia');
-- 13.01

/* 10. How many orders are delivered on time vs orders delivered with a delay?*/

SELECT 
    CASE
        WHEN
            DATEDIFF(order_delivered_customer_date,
                    order_estimated_delivery_date) <= 0
        THEN
            'on time'
        ELSE 'delayed'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS number_of_orders
FROM
    orders
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;
-- delayed orders: 6665 / orders delivered on time: 89805

-- percentage of delayed orders
SELECT ROUND(6665/89805*100,2);
-- 7.42% of orders delayed

/* 11. Is there any pattern for delayed orders, e.g. big products being delayed more often?*/

SELECT
    CASE 
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 100 THEN "> 100 day Delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 7 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 100 THEN "1 week to 100 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 3 AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 7 THEN "4-7 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) >= 1  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 3 THEN "1-3 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) > 0  AND DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) < 1 THEN "less than 1 day delay"
        WHEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) <= 0 THEN 'On time' 
    END AS "delay_range", 
    AVG(product_weight_g) AS weight_avg,
    MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight,
    COUNT(DISTINCT a.order_id) AS orders_count
FROM orders a
LEFT JOIN order_items b
    USING (order_id)
LEFT JOIN products c
    USING (product_id)
WHERE order_estimated_delivery_date IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_status = 'delivered'
GROUP BY delay_range;

/* Some further questions to be answered:
	2. What is the average processing time of orders between approval and delivery to carrier?*/
    
    SELECT
		ROUND(AVG(DATEDIFF(order_delivered_carrier_date,order_approved_at)),2) AS average_order_processing_time
	FROM
		orders
	WHERE order_delivered_carrier_date IS NOT NULL;
    -- 2.7 days
    
    -- for tech products
    SELECT
		ROUND(AVG(DATEDIFF(order_delivered_carrier_date,order_approved_at)),2) AS average_order_processing_time
	FROM
		orders
			LEFT JOIN
		order_items USING(order_id)
			LEFT JOIN
		products USING(product_id)
	WHERE order_delivered_carrier_date IS NOT NULL
    AND product_category_name IN ('audio' , 'eletronicos',
        'informatica_acessorios',
        'pcs',
        'tablets_impressao_imagem',
        'telefonia');
        -- 2.85 days
        
    -- 3. What is the average delivery time the carrier takes to deliver (by region/state/if it is a capital)?
    
    SELECT
          ROUND(AVG(DATEDIFF(order_delivered_customer_date,order_delivered_carrier_date)),2) AS average_carrier_time
	FROM
		orders
	WHERE order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL;
    -- 9.31 days for carrier to deliver on average
    
    -- grouped by region
    SELECT
		CASE
			WHEN state IN('RS', 'SC', 'PR') THEN 'South'
            WHEN state IN('SP', 'RJ', 'MG', 'ES') THEN 'Southeast'
            WHEN state IN('MS', 'MT', 'GO', 'DF') THEN 'Center-West'
            WHEN state IN('AM', 'AC', 'RO', 'RR', 'AP', 'PA', 'TO') THEN 'North'
            ELSE 'Northeast' END AS region,
            COUNT(DISTINCT order_id) AS number_of_orders,
            ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)),2) AS average_carrier_time,
            ROUND(AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)),2) AS average_estimated_delivery
FROM
		orders
			LEFT JOIN
		order_items USING(order_id)
			LEFT JOIN
		customers USING(customer_id)
			LEFT JOIN
		geo ON customers.customer_zip_code_prefix = geo.zip_code_prefix
	WHERE order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL
    GROUP BY region
    ORDER BY number_of_orders DESC;

-- grouped by state

    SELECT 
    state,
    COUNT(DISTINCT order_id) AS number_of_orders,
    ROUND(COUNT(DISTINCT order_id) * 100 / (SELECT 
                    COUNT(DISTINCT order_id)
                FROM
                    orders),
            2) AS percentage_number_of_orders,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_delivered_carrier_date)),
            2) AS average_carrier_time,
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date,
                    order_purchase_timestamp)),
            2) AS average_estimated_delivery
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    customers USING (customer_id)
        LEFT JOIN
    geo ON customers.customer_zip_code_prefix = geo.zip_code_prefix
WHERE
    order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
GROUP BY state
ORDER BY number_of_orders DESC;

/*	Further questions to be analyzed:
     What is the average review rating?
     How many reviews relate to the targeted categories and what's their average rating?
*/
