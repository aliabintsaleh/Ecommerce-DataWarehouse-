/*========================================
Dimentions explorations.
==========================================
To explore the dimentions tables.
--========================================
*/
--=========================================
--RETREVE ALL UNIQUE CITES IN CUSTOMER'S COLUMN.
SELECT DISTINCT 
--customer_city,
customer_state
FROM analytics.Customers
ORDER BY 
customer_state
--===========================================
--retreve all  unique poduct'scategory.
SELECT DISTINCT 
product_category_name
FROM analytics.Products
ORDER BY product_category_name
--===========================================


