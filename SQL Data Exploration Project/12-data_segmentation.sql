/*
===============================================================================
Data Segmentation & Classification
===============================================================================
KPI:
-To group data for better understanding and analysis.
-To support segmentation across customers, products, and regions.
==============================================================================
*/

/*Segment products based on weight and size, 
then count the number of products in each segment.
*/
WITH vw_product_segmentation AS
	(SELECT 
		  product_key,
		  product_category_name,
		  product_width_cm,
		  product_volume,
		  CASE
			WHEN product_weight_g < 500 THEN 'Light'
			WHEN product_weight_g BETWEEN 500 AND 2000 THEN 'Medium'
			ELSE 'Heavy'
		  END AS weight_segment,

		  CASE
			WHEN (product_volume) < 1000 THEN 'Small'
			WHEN (product_volume) BETWEEN 1000 AND 10000 THEN 'Medium'
			ELSE 'Large'
		  END AS size_segment
	FROM analytics.Products
		 )
	SELECT
		weight_segment,
		size_segment,
		COUNT(product_key) AS total_products
	FROM vw_product_segmentation
	GROUP BY  weight_segment,size_segment
	ORDER BY total_products DESC;
		  --===================================================
		  /* Segment customers by lifespan and spending level
		  (VIP, Regular, New) and count customers per segment */
		  WITH Customers_Segmentations AS (
		  SELECT 
		  c.customer_key,
		  SUM(o.payment_value) AS total_spending,
		  MIN(o.order_approved_at) AS First_order ,
		  MAX(o.order_approved_at) AS last_order,
		  DATEDIFF(month, MIN(order_approved_at), MAX(order_approved_at)) AS lifespan
		  FROM analytics.Orders o
		  LEFT JOIN 
		  analytics.Customers c
		  ON c.customer_key =o.customer_key
		  GROUP BY c.customer_key
		  )
		  SELECT 
		  customer_segment,
		  COUNT( customer_key) AS Total_customers
		  FROM(
		  SELECT
		  customer_key,
		  CASE 
		  WHEN total_spending >1000AND lifespan>=12 THEN 'VIP'
		  WHEN total_spending <= 1000 AND lifespan >=12 THEN 'Regular'
		  ELSE 'NEW'
		  END AS customer_segment
		  FROM Customers_Segmentations
		  ) AS segmented_customers
		  GROUP BY customer_segment
		  ORDER BY Total_customers DESC;
