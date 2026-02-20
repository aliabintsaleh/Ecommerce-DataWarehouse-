/*
===============================================================================
Product Report
===============================================================================
*/
IF OBJECT_ID('analytics.product_report','V') IS NOT NULL 
DROP VIEW analytics.product_report
GO
CREATE VIEW analytics.product_report AS
WITH core_columns AS(
SELECT 
o.order_id,
o.customer_key,
o.order_purchase_timestamp,
o.order_approved_at,
o.price,
o.payment_value,
o.payment_Tybe,
p.product_id,
p.product_category_name,
p.product_volume
FROM analytics.Orders o
LEFT JOIN analytics.Products p
ON o.product_id= p.product_id
WHERE order_approved_at IS NOT NULL
),
product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT 
	product_id,
	product_category_name,
	product_volume,
    DATEDIFF(MONTH, MIN(order_approved_at), MAX(order_approved_at)) AS lifespan,
    MAX(order_approved_at) AS last_sale_date,
    COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(payment_value) AS total_sales
	
FROM core_columns
GROUP BY 
	product_id,
	product_category_name,
	product_volume
	)
	SELECT 
	product_id,
	product_category_name,
	product_volume,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 1000 THEN 'High-Performer'
		WHEN total_sales >= 500 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_customers,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations 

