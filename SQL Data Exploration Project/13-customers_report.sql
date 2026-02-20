/*
=============================================================
Customer Report
=============================================================
 This report consolidates key customer metrics and behaviors
--===========================================================
=============================================================*/
IF OBJECT_ID('analytics.report_customers', 'V') IS NOT NULL
    DROP VIEW analytics.report_customers;
GO
CREATE VIEW analytics.report_customers AS
WITH core_column AS
(
SELECT 
o.order_id,
o.product_id,
o.payment_Tybe,
o.order_purchase_timestamp,
o.order_approved_at,
o.payment_value,
c.customer_key,
c.customer_city,
c.customer_state
FROM analytics.Orders o
LEFT JOIN analytics.Customers c
ON o.customer_key=c.customer_key
WHERE order_approved_at IS NOT NULL
)
, Customer_Segmentations AS(
SELECT 
customer_key,
customer_state,
payment_Tybe,
order_purchase_timestamp,
order_approved_at,
    COUNT(DISTINCT order_id) AS total_orders,
	SUM(payment_value) AS total_sales,
	COUNT(DISTINCT product_id) AS total_products,
	MAX(order_approved_at) AS last_order_date,
	DATEDIFF(month, MIN(order_approved_at), MAX(order_approved_at)) AS lifespan
	FROM core_column
	GROUP BY 
	customer_key,
 customer_state,
 payment_Tybe,
order_purchase_timestamp,
order_approved_at
 )
 SELECT 
  customer_key,
 customer_state,
 CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
 
 CASE
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 0 THEN 'Same Day'
        WHEN DATEDIFF(DAY, order_purchase_timestamp, order_approved_at) = 1 THEN '1 Day'
        ELSE '2+ Days'
    END AS processing_order_date,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_products
lifespan,
-- Compuate average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_value,
-- Compuate average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END AS avg_monthly_spend
FROM Customer_Segmentations


