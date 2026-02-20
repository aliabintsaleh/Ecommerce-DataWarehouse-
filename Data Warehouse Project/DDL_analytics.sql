/*===================================================================
Create analytics views.
=====================================================================
this script creates views for the analytics layer in the datawarehouse.
The analytics layer represents the final dimention and fact tables.

Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
--===========================================================
 --=========== CREATE Dimention customers====================
 --===========================================================
 IF OBJECT_ID('analytics.Customers', 'V') IS NOT NULL
    DROP VIEW analytics.Customers;
GO
		CREATE VIEW analytics.Customers AS
		SELECT 
		ROW_NUMBER() OVER(ORDER BY c.customer_id) AS customer_key, 
		c.customer_id,
		c.customer_zip_code_prefix,
		c.customer_city,
		c.customer_state
		FROM core.Customers c
		
		GO
--========================================================================
--Create dimention product ===============================================
--========================================================================
IF OBJECT_ID('analytics.Products', 'V') IS NOT NULL
    DROP VIEW analytics.Products;
GO
			CREATE VIEW analytics.Products AS
			SELECT
			ROW_NUMBER() OVER(ORDER BY p.product_id)AS product_key,
			p.product_id,
			p.product_category_name,
			p.product_weight_g,
			p.product_length_cm,
			p.product_height_cm,
			p.product_width_cm
			
			FROM core.Products p;
		
			GO
--===========================================================================
--- =============================================================================
-- Create Fact Table: analytics.Orders
-- =============================================================================
IF OBJECT_ID('analytics.Orders', 'V') IS NOT NULL
    DROP VIEW analytics.Orders;
GO
CREATE VIEW analytics.Orders AS
SELECT 
o.order_id,
c.customer_key,
t.product_id,
t.seller_id,
o.order_purchase_timestamp,
o.order_approved_at,
t.price,
t.shipping_charges,
p.payment_installment,
p.payment_Sequential,
p.payment_Type,
p.payment_value
FROM core.Orders o
LEFT JOIN analytics.Customers c
ON o.customer_id=c.customer_id
LEFT JOIN core.OrderItems t
ON o.order_id=t.order_id
LEFT JOIN core.Payments p
ON o.order_id=p.order_id

GO
 

 