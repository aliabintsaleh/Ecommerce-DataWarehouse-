/*=======================================================
Store procedure:Load core layer(from staging to core)
=========================================================
 This stored procedure perform ETL(extract,transform,load)process
 and populate the core schema tables from staging schema.
 Actions performs:
 -Truncate core tables.
 -Insert transformed and cleaned data from staging into core tables.
 Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC core.load_core;
===============================================================================
*/

	CREATE OR ALTER PROCEDURE core.load_core AS
	BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
		SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Core Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Tables';
		PRINT '------------------------------------------------';
		-- Loading core.Customers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: core.Customeers';
		TRUNCATE TABLE core.Customers;
			PRINT '>> Inserting Data Into: core.Customers';
	 INSERT INTO core.Customers(
	 customer_id,
	 customer_zip_code_prefix,
	 customer_city,
	 customer_state

	 )
	 SELECT 
	 customer_id,
	 customer_zip_code_prefix,
	 customer_city,
	 CASE customer_state
				WHEN 'AC' THEN 'Acre'
				WHEN 'AL' THEN 'Alagoas'
				WHEN 'AM' THEN 'Amazonas'
				WHEN 'AP' THEN 'Amapá'
				WHEN 'BA' THEN 'Bahia'
				WHEN 'CE' THEN 'Ceará'
				WHEN 'DF' THEN 'Distrito Federal'
				WHEN 'ES' THEN 'Espírito Santo'
				WHEN 'GO' THEN 'Goiás'
				WHEN 'MA' THEN 'Maranhão'
				WHEN 'MG' THEN 'Minas Gerais'
				WHEN 'MS' THEN 'Mato Grosso do Sul'
				WHEN 'MT' THEN 'Mato Grosso'
				WHEN 'PA' THEN 'Pará'
				WHEN 'PB' THEN 'Paraíba'
				WHEN 'PE' THEN 'Pernambuco'
				WHEN 'PI' THEN 'Piauí'
				WHEN 'PR' THEN 'Paraná'
				WHEN 'RJ' THEN 'Rio de Janeiro'
				WHEN 'RN' THEN 'Rio Grande do Norte'
				WHEN 'RO' THEN 'Rondônia'
				WHEN 'RR' THEN 'Roraima'
				WHEN 'RS' THEN 'Rio Grande do Sul'
				WHEN 'SC' THEN 'Santa Catarina'
				WHEN 'SE' THEN 'Sergipe'
				WHEN 'SP' THEN 'São Paulo'
				WHEN 'TO' THEN 'Tocantins'
				ELSE 'Unknown'
			END AS customer_state_name ---Normalize customer's state---
			FROM staging.Customers
			;
			SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
		-- Loading core.OrderItems---
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: core.OrderItems';
		TRUNCATE TABLE core.OrderItems;
			PRINT '>> Inserting Data Into: core.OrderItems';
			INSERT INTO core.OrderItems(
			order_id,
			product_id,
			seller_id,
			price,
			shipping_charges
			)
			
			SELECT 
			
			order_id,
			product_id,
			seller_id,
			price,
			shipping_charges
			FROM staging.OrderItems;
			------------------------------------
			SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		-----------------------------------------
		-- Loading core.Orders---
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: core.Orders';
		TRUNCATE TABLE core.Orders;
			PRINT '>> Inserting Data Into: core.Orders';
			INSERT INTO core.Orders(
			order_id,
			customer_id,
			order_purchase_timestamp,
			order_approved_at
			)
			SELECT 
			order_id,
			customer_id,
			order_purchase_timestamp,
			order_approved_at
			FROM staging.Orders;
			-------------------------------------------------------------
		SET @end_time = GETDATE();
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';
					-----------------------------------------
					-- Loading core.Payment---
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: core.Payments';
		TRUNCATE TABLE core.Payments;
			PRINT '>> Inserting Data Into: core.Payments';
			INSERT INTO core.Payments(
			order_id,
			payment_Sequential,
			payment_Type,
			payment_installment,
			payment_value
			)
			SELECT 
			order_id,
			payment_Sequential,
			payment_Type,
			payment_installment,
			payment_value
			FROM staging.Payments
			-------------------------------------------------------------
		SET @end_time = GETDATE();
				PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>> -------------';
	------------------------------------
	-- Loading core.Products
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: core.Products';
		TRUNCATE TABLE core.Products;
			PRINT '>> Inserting Data Into: core.Products';
			INSERT INTO core.Products(
			product_id,
			product_category_name,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm)
			SELECT 
			product_id,
			COALESCE(product_category_name , 'unknown') AS product_category_name,
			ISNULL(product_weight_g,0) AS product_weight_g,
			ISNULL(product_length_cm,0) AS product_length_cm,
			ISNULL(product_height_cm,0) AS product_height_cm,
			ISNULL(product_width_cm,0) AS product_width_cm
			FROM
			(SELECT *,
			ROW_NUMBER()OVER(PARTITION BY product_id ORDER BY product_id) as RN
			FROM staging.Products
			WHERE product_id IS NOT NULL
			)t
			WHERE RN=1
			SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		------------------------------------------------------
		
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Core Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

		END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
	END



	EXEC core.load_core;