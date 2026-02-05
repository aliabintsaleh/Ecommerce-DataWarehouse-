/*
===============================================================
DDL Script: Create Core tables 
===============================================================
This script create tables into'core' schema,dropping existing tables
if they already exists.
Run this script to re-define the DDL structure of the 'Core'tables.
===============================================================
*/

IF OBJECT_ID('core.Customer','u')IS NOT NULL
 DROP TABLE core.Customer;
 GO

	CREATE TABLE core.Customer(
		customer_id               NVARCHAR(500) ,
		customer_zip_code_prefix  INT,
		customer_city             NVARCHAR(500),
		customer_state            NVARCHAR(500),
		dwh_create_date    DATETIME2 DEFAULT GETDATE()
	);
GO

IF OBJECT_ID('core.Product','u')IS NOT NULL
 DROP TABLE core.Product;
 GO

	CREATE TABLE core.Product(
		product_id              NVARCHAR(50) ,
		product_category_name   NVARCHAR(50),
		product_weight_g        INT,
		product_length_cm       INT,
		product_height_cm       INT,
		product_width_cm        INT,
		dwh_create_date    DATETIME2 DEFAULT GETDATE()
	);
GO
	IF OBJECT_ID('core.Orders','u')IS NOT NULL
	 DROP TABLE core.Orders;
	 GO
	CREATE TABLE core.Orders(
		order_id                  NVARCHAR(50) ,
		customer_id               NVARCHAR(50),
		order_purchase_timestamp  DATE,
		order_approved_at         DATE,
		dwh_create_date    DATETIME2 DEFAULT GETDATE()
	);

GO
	IF OBJECT_ID('core.OrderItems','u')IS NOT NULL
	 DROP TABLE core.OrderItems;
	 GO
	CREATE TABLE core.OrderItems(
		order_id                 NVARCHAR(50),
		product_id               NVARCHAR(50),
		seller_id                NVARCHAR(50),
		price                    INT,
		shipping_charges         INT,
		dwh_create_date    DATETIME2 DEFAULT GETDATE()
	);

GO
	IF OBJECT_ID('core.Payments','u')IS NOT NULL
	 DROP TABLE core.Payments;
	 GO
	CREATE TABLE core.Payments(
	order_id                   NVARCHAR(50),
	payment_Sequential         INT,
	payment_type               NVARCHAR(50),
	payment_installment        INT,
	payment_value              INT,
	dwh_create_date    DATETIME2 DEFAULT GETDATE()
	);