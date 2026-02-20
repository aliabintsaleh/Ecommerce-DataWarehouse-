  /*====================================================
========QUALITY CHACKS================================
THis script perform various quality checks for data consistency,accuracy,
and standarization across the core layer.It includes checks for :
	-Null or duplicate primary key .
	-Unwanted spaces in string field.
	-Data standarization and consistency.
	-Invalid date range and orders.
	-Data consistency between rlaited field.


Usage Notes:
    - Run these checks after data loading core Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
--=============================================================================
-- Checking 'core.Customers'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

	SELECT 
	customer_id,COUNT(*)
	FROM staging.Customers
	GROUP BY customer_id
	HAVING COUNT(*)>1 or customer_id IS NULL

	-- Check for Unwanted Spaces
	-- Expectation: No Results
	SELECT customer_id
	FROM staging.Customers
	WHERE
	customer_id!=TRIM(customer_id)
	OR customer_zip_code_prefix!=TRIM(customer_zip_code_prefix)
	OR customer_city!=TRIM(customer_city)
	OR customer_state!=TRIM(customer_state)
	------------------------------------------------------
	---Data Standardization & Consistency
	SELECT DISTINCT 
	 customer_city
	FROM staging.Customers
	WHERE customer_city is null
	----Data Standardization & Consistency
	SELECT DISTINCT 
	 customer_zip_code_prefix 
	FROM staging.Customers
	WHERE customer_zip_code_prefix is null
	----Data Standardization & Consistency
	SELECT DISTINCT 
	 customer_state 
	FROM staging.Customers
	WHERE customer_state is null

	---Normalize customer's state---

	SELECT
		customer_state,
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
		END AS customer_state_name
	FROM staging.Customers;

--====================================================================
-- Checking 'core.Products'
-- ====================================================================
-- Check for NULLs or Negative Values in weight_g
	-- Expectation: No Results
SELECT 
	order_id,COUNT(*)
	FROM staging.Orders
	GROUP BY order_id
	HAVING COUNT(*)>1 or order_id IS NULL
	-- Check for Unwanted Spaces
	-- Expectation: No Results
	SELECT 
		product_id
	FROM staging.Products
	WHERE product_id!= TRIM(product_id);

	--Check for Unwanted Spaces
	-- Expectation: No Results
	SELECT 
		product_category_name
	FROM staging.Products
	WHERE product_category_name!= TRIM(product_category_name);


	-- Check for NULLs or Negative Values in weight_g
	-- Expectation: No Results
	SELECT 
		*
	FROM staging.Products
	WHERE product_width_cm< 0 OR product_width_cm IS NULL
	OR product_height_cm< 0 OR product_height_cm IS NULL
	OR product_weight_g <0 OR  product_weight_g IS NULL
	OR product_length_cm <0 OR product_length_cm IS NULL
	;

	-- Data Standardization & Consistency
	SELECT DISTINCT (product_category_name)
	FROM staging.Products
	-------------------
	SELECT *
	FROM staging.Products
	WHERE product_id='Ph7gx9xXX1Y1'
	
	--check null,s value--
	SELECT 
		*
	FROM staging.Products
	WHERE product_category_name IS NULL;

	--handlling the missing values--
	SELECT COALESCE(product_category_name , 'unknown') AS product_category_name
	FROM staging.Products;


---------------------------------------------
--Check for Unwanted Spaces
-- Expectation: No Results
	SELECT 
		* 
	FROM staging.OrderItems
	WHERE order_id!= TRIM(order_id) 
	   OR product_id != TRIM(product_id) 
	   OR seller_id != TRIM(seller_id);

	 -- Check for NULLs or Negative Values in price and shipping_charges
	-- Expectation: No Results
	SELECT 
		price,
		shipping_charges
	FROM staging.OrderItems
	WHERE price<0 OR price IS NULL 
	OR shipping_charges<0 OR shipping_charges IS NULL
-----------------------------------------
-- Check for NULLs or Duplicates in Primary Key
	-- Expectation: No Results

	SELECT 
	order_id,COUNT(*)
	FROM staging.Orders
	GROUP BY order_id
	HAVING COUNT(*)>1 or order_id IS NULL
---------------------------------
-- ===============================================================
-- Check for Invalid Date Orders ( order_purchase_timestamp > order_approved_at Dates)
-- Expectation: No Results
	SELECT 
		*
	FROM staging.Orders
	WHERE order_purchase_timestamp>order_approved_at 
		------------------------------------------------------------
		SELECT
	 DISTINCT(payment_Type)
		 FROM staging.Payments
	 SELECT
	 DISTINCT(payment_Sequential)
		 FROM staging.Payments

	-- Check for NULLs or Negative Values in payment_Sequential
	-- Expectation: No Results
	SELECT 
		payment_Sequential
	FROM staging.Payments
	WHERE payment_Sequential<0 OR payment_Sequential IS NULL 
	-- Check for NULLs or Negative Values inpayment_installment 
	-- Expectation: No Results
	SELECT 
		payment_installment
	FROM staging.Payments
	WHERE payment_installment<0 OR payment_installment IS NULL 

	-- Check for NULLs or Negative Values inpayment_installment 
	-- Expectation: No Results
	SELECT 
		payment_value
	FROM staging.Payments
	WHERE payment_value<0 OR payment_value IS NULL 
