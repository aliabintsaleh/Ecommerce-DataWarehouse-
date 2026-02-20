/* ===========================================
  Change Over Time Analysis.
==============================================
KPI:
To track change over time ,trend,growth.
===============================================
*/
-- Analyse sales performance over time
-- Quick Date Functions
		SELECT 
		YEAR(order_approved_at) AS Order_year,
		MONTH(order_approved_at) AS Order_month,
		SUM(payment_value) as Total_revenue,
		COUNT(DISTINCT(customer_key) )AS Total_customers,
		COUNT(DISTINCT product_id) AS unique_products_sold
		FROM analytics.Orders
		WHERE order_approved_at IS NOT NULL
		GROUP BY YEAR(order_approved_at),
		MONTH(order_approved_at)
		ORDER BY  YEAR(order_approved_at),
		MONTH(order_approved_at)
