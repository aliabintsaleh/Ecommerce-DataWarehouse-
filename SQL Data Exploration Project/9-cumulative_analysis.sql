/* ===========================================================
Cumulative analysis.
==========================================================
KPI:
 Track performance over time cumulatively.
 ===========================================================
 */
 -- Calculate the total sales per month 
-- and the running total of sales over time 

		SELECT 
		Order_date,
		Total_sales,
		SUM(Total_sales)OVER(ORDER BY Order_date) AS Toatal_runing_sales,
		AVG(avg_price)OVER(ORDER BY Order_date) AS moving_avg_price
		FROM(
			SELECT 
			DATETRUNC(YEAR, order_approved_at) AS Order_date,
			SUM(payment_value) AS Total_sales,
			AVG(price) As avg_price
			FROM analytics.Orders
			WHERE order_approved_at IS NOT NULL
			GROUP BY DATETRUNC(YEAR, order_approved_at)
			)t
