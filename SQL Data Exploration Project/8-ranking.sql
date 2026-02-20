/*
===============================================================================
Ranking Analysis
===============================================================================
KPI:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
		SELECT 
		TOP 5 
		p.product_category_name,
		SUM(o.payment_value) AS  Total_revenue
		FROM analytics.orders o LEFT JOIN
		analytics.Products p
		ON o.product_id=p.product_id
		GROUP BY product_category_name
		ORDER BY Total_revenue DESC
-- Complex but Flexibly Ranking Using Window Functions

		SELECT*
		FROM(SELECT p.product_category_name,
		SUM(o.payment_value) AS  Total_revenue,
		RANK()OVER (ORDER BY SUM(o.payment_value) DESC) AS Ranked_products
		FROM analytics.orders o LEFT JOIN
		analytics.Products p
		ON o.product_id=p.product_id
		GROUP BY product_category_name) AS RANK_PRODUCT
		WHERE Ranked_products<= 5

-- What are the 5 worst-performing products in terms of sales?

      SELECT 
		TOP 5 
		p.product_category_name,
		SUM(o.payment_value) AS  Total_revenue
		FROM analytics.orders o LEFT JOIN
		analytics.Products p
		ON o.product_id=p.product_id
		GROUP BY product_category_name
		ORDER BY Total_revenue 
-- Find the top 10 customers who have generated the highest revenue
	SELECT TOP 10
		c.customer_ID,
		SUM(o.payment_value) AS total_revenue
		FROM analytics.Orders o LEFT JOIN 
		analytics.Customers c
		ON O.customer_key=C.customer_key
		GROUP BY customer_ID
		ORDER BY total_revenue DESC

-- The 5 customers with the fewest orders placed
    SELECT TOP 5
		c.customer_ID,
		COUNT ( DISTINCT o.order_id) AS total_orders
		FROM analytics.Orders o LEFT JOIN 
		analytics.Customers c
		ON O.customer_key=C.customer_key
		GROUP BY customer_ID
		ORDER BY total_orders DESC
