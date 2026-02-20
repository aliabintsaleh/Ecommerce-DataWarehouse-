

/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================

**KPI:**

* To evaluate performance over time.
* To identify top performers.
* To track annual trends and growth.
============================================================================
/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

*/
		WITH yearly_products_sales AS(
		SELECT 
		YEAR(o.order_approved_at) AS order_year,
		p.product_category_name ,
		SUM(o.payment_value) AS Current_sales
		FROM analytics.Orders o
		LEFT JOIN analytics.Products p
		ON o.product_id=p.product_id
		WHERE o.order_approved_at IS NOT NULL
		GROUP BY YEAR(o.order_approved_at),p.product_category_name 
		)
		SELECT 
		order_year,
		product_category_name,
		Current_sales,
		AVG(Current_sales)OVER(PARTITION BY product_category_name) AS Avg_sales,
		Current_sales-AVG(Current_sales)OVER(PARTITION BY product_category_name)AS Diff_avg,
		CASE 
		WHEN Current_sales-AVG(Current_sales)OVER(PARTITION BY product_category_name)>0 THEN 'Above Avg'
		WHEN Current_sales-AVG(Current_sales)OVER(PARTITION BY product_category_name)<0 THEN  'Below Avg'
		ELSE 'AVG'
		END AS avg_change,
		 -- Year-over-Year Analysis
		 LAG(Current_sales)OVER (PARTITION  BY product_category_name ORDER BY order_year) AS prev_year_sales,
		 Current_sales-LAG(Current_sales)OVER (PARTITION  BY product_category_name ORDER BY order_year) AS diff_py,
		 CASE 
		 WHEN Current_sales-LAG(Current_sales)OVER (PARTITION BY product_category_name ORDER BY order_year) >0 THEN  'Increase'
		 WHEN Current_sales-LAG(Current_sales)OVER (PARTITION  BY product_category_name ORDER BY order_year) <0 THEN  'Decrease'
		  ELSE 'No Change'
		  END  AS prev_year_Change
		  FROM yearly_products_sales
ORDER BY product_category_name, order_year
---==========================================
--Calculate processing time in days 
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) AS processing_day
FROM analytics.Orders
WHERE order_approved_at IS NOT NULL;
--==========================================
--Percentage of orders approved on the same day
SELECT
    100.0 * (SUM(CASE 
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 0 
        THEN 1 ELSE 0 END) )/ COUNT(*) AS same_day_approval_pct
FROM analytics.Orders
WHERE order_approved_at IS NOT NULL;
--=================================================
--===================================
	--Average Payment Approval Days
	SELECT
    payment_Tybe,
    COUNT(*) AS total_orders,
    AVG(DATEDIFF(DAY, order_purchase_timestamp, order_approved_at)) AS avg_approval_days
FROM analytics.Orders 
WHERE order_approved_at IS NOT NULL
GROUP BY payment_Tybe
ORDER BY avg_approval_days;
--==============================================
--% Same-Day Approved Orders Base On Payment_method
SELECT
    payment_Tybe,
    100.0 * SUM(CASE 
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) > 1
        THEN 1 ELSE 0 
    END) / COUNT(*) AS delayed_pct
FROM analytics.Orders

WHERE order_approved_at IS NOT NULL
GROUP BY payment_Tybe;
--================================================
--Numbers Of Orders That is Not Approved base on patment methods
SELECT
    payment_Tybe,
    COUNT(*) AS not_approved_orders
FROM analytics.Orders

WHERE order_approved_at IS NULL
GROUP BY payment_Tybe
--==============================================
--Payment Method with Highest Delay
--Sort orders by payment approval speed
--==============================================
SELECT
    payment_Tybe,
    CASE
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 0 THEN 'Same Day'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 1 THEN '1 Day'
        ELSE '2+ Days'
    END AS processing_category,
    COUNT(*) AS total_orders
FROM analytics.Orders
WHERE order_approved_at IS NOT NULL
GROUP BY
    payment_Tybe,
    CASE
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 0 THEN 'Same Day'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 1 THEN '1 Day'
        ELSE '2+ Days'
    END
	ORDER BY total_orders DESC;
--==================================================


