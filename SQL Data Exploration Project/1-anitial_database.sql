/*=================================================================
Create Database And Schema
===================================================================
This script create new database named 'DA_Ecommeric' after chcking if it already exists .
If the databse exists,it is dropped and recreated.Additionally create new schema named 'analytics'.
*/
--===================================================================
USE master;
GO
--Drop and recreate the'DA_Ecommeric' database----
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DA_Ecommeric')
BEGIN
ALTER DATABASE DA_Ecommeric SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DA_Ecommeric;
END;
GO
---------Create DA_Ecommeric database---------
--============================================
		CREATE DATABASE DA_Ecommeric;
		GO


		USE DA_Ecommeric;
		GO
		--Create schemas---
		CREATE SCHEMA analytics;
		GO 
		CREATE TABLE analytics.Customers(
			customer_key INT ,
			customer_id NVARCHAR(50),
			customer_zip_code_prefix INT,
			customer_city NVARCHAR(50),
			customer_state NVARCHAR(50) 
			);
		GO
		CREATE TABLE analytics.Products(
		   product_key INT,
		   product_id NVARCHAR(50),
		   product_category_name NVARCHAR(50),
		   product_weight_g INT ,
		   product_length_cm INT,
		   product_height_cm INT,
		   product_width_cm INT
		   );
		GO
		CREATE TABLE analytics.Orders(
		order_id NVARCHAR(50),
		customer_key INT,
		product_id NVARCHAR(50),
		seller_id NVARCHAR(50),
		order_purchase_timestamp DATE,
		order_approved_at DATE,
		price INT,
		shipping_charges INT,
		payment_installment INT,
		payment_Sequential INT,
		payment_Tybe NVARCHAR(50),
		payment_value INT
		);
		GO
		
