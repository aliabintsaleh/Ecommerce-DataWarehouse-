/*
===============================================================
DDL Script: Create staging tables 
===============================================================
This script create tables into'staging' schema,dropping existing tables
if they already exists.
Run this script to re-define the DDL structure of the 'staging'tables.
===============================================================
*/

IF OBJECT_ID('staging.Customer','u')IS NOT NULL
 DROP TABLE staging.Customer;
 GO

	CREATE TABLE staging.Customer(
		customer_id               NVARCHAR(500) ,
		customer_zip_code_prefix  INT,
		customer_city             NVARCHAR(500),
		customer_state            NVARCHAR(500),
	);
GO

IF OBJECT_ID('staging.Product','u')IS NOT NULL
 DROP TABLE staging.Product;
 GO

	CREATE TABLE staging.Product(
		product_id              NVARCHAR(50) ,
		product_category_name   NVARCHAR(50),
		product_weight_g        INT,
		product_length_cm       INT,
		product_height_cm       INT,
		product_width_cm        INT,
	);
GO
	IF OBJECT_ID('staging.Orders','u')IS NOT NULL
	 DROP TABLE staging.Orders;
	 GO
	CREATE TABLE staging.Orders(
		order_id                  NVARCHAR(50) ,
		customer_id               NVARCHAR(50),
		order_purchase_timestamp  DATE,
		order_approved_at         DATE,
	);

GO
	IF OBJECT_ID('staging.OrderItems','u')IS NOT NULL
	 DROP TABLE staging.OrderItems;
	 GO
	CREATE TABLE staging.OrderItems(
		order_id                 NVARCHAR(50),
		product_id               NVARCHAR(50),
		seller_id                NVARCHAR(50),
		price                    INT,
		shipping_charges         INT,
	);

GO
	IF OBJECT_ID('staging.Payments','u')IS NOT NULL
	 DROP TABLE staging.Payments;
	 GO
	CREATE TABLE staging.Payments(
	order_id                   NVARCHAR(50),
	payment_Sequential         INT,
	payment_type               NVARCHAR(50),
	payment_installment        INT,
	payment_value              INT,
	);