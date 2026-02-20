/*=======================================================
measures explorations .
=========================================================
KPI:
 To calculate the aggregated metrics.(e.g...avg,sum)
 To identifi trends.
 ========================================================
 */

 -- Find the Total Sales
 SELECT SUM(payment_value) AS Total_sales FROM analytics.Orders
 --find the average selling price
 SELECT avg(price) AS average FROM analytics.Orders
 -- Find the Total number of Orders
SELECT COUNT(order_id) AS total_orders FROM analytics.Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM analytics.Orders
-- Find the total number of products
SELECT COUNT(product_category_name) AS total_products FROM analytics.Products
-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM analytics.Customers
-- Find the total number of customers that has placed an order
SELECT COUNT(distinct customer_key) AS total_customers FROM analytics.Customers

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(payment_value) AS measure_value FROM analytics.Orders
UNION ALL
SELECT 'Average Price', AVG(price) FROM analytics.Orders
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_id) FROM analytics.Orders
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_category_name) FROM analytics.Products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM analytics.Customers ;
