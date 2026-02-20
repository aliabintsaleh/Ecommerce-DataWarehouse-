/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
*/
/*identify the top-performing products by revenue across regions
by aggregating sales value and ranking products within each regi
*/
WITH product_revenue AS (
  
  SELECT
    c.customer_state AS region,
    p.product_category_name,
    SUM(o.payment_value) AS total_revenue
  FROM analytics.Orders o
 LEFT JOIN analytics.Customers c ON o.customer_key = c.customer_key
 LEFT JOIN analytics.Products p
 ON o.product_id=p.product_id
  GROUP BY c.customer_state, p.product_category_name
)
SELECT
  region,
  product_category_name,
  total_revenue
FROM (
  SELECT
    region,
    product_category_name,
    total_revenue,
    RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS rnk
  FROM product_revenue
) t
WHERE rnk <=3;
--===========================================================================
-- Which categories contribute the most to overall sales?
WITH Category_Sales AS(
SELECT 
p.product_category_name ,
SUM(o.payment_value) AS Total_sales
FROM analytics.Orders o
LEFT JOIN analytics.Products p
ON o.product_id=p.product_id
group by product_category_name
)
SELECT 
product_category_name,
Total_sales,
SUM(Total_sales) OVER() AS Overall_sales
 ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
 FROM Category_Sales
 ORDER BY Total_sales DESC;
