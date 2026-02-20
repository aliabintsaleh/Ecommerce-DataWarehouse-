--=====================================================
	
		TRUNCATE TABLE analytics.Customers;
		GO
		--=========================================================
		--INSERT DATA INTO Customer table---
		INSERT INTO analytics.Customers(
		    customer_key ,
			customer_id ,
			customer_zip_code_prefix ,
			customer_city ,
			customer_state 
			)
			SELECT 
			customer_key ,
			customer_id ,
			customer_zip_code_prefix ,
			customer_city ,
			customer_state
			FROM E_commerc_Wharehouse.analytics.Customers;
			GO
			--=====================================================
			TRUNCATE TABLE analytics.Products;
			GO
			--===================================================
			--Insert into Product table----
			INSERT INTO analytics.Products(
           
			   product_key ,
			   product_id,
			   product_category_name ,
			   product_weight_g  ,
			   product_length_cm ,
			   product_height_cm ,
			   product_width_cm 
		   ) 
		   SELECT 
		   
			   product_key ,
			   product_id,
			   product_category_name ,
			   product_weight_g  ,
			   product_length_cm ,
			   product_height_cm ,
			   product_width_cm 
			  FROM E_commerc_Wharehouse.analytics.Products;
			GO


			TRUNCATE TABLE analytics.Orders;
			GO
			--===================================================
			--Insert into Orders table----
			INSERT INTO analytics.Orders(
			order_id ,
			customer_key ,
			product_id ,
			seller_id,
			order_purchase_timestamp ,
			order_approved_at ,
			price ,
			shipping_charges ,
			payment_installment,
			payment_Sequential ,
			payment_Tybe ,
			payment_value )

		   SELECT 
		    order_id ,
			customer_key ,
			product_id ,
			seller_id,
			order_purchase_timestamp ,
			order_approved_at ,
			price ,
			shipping_charges ,
			payment_installment,
			payment_Sequential ,
			payment_Type,
			payment_value
			FROM E_commerc_Wharehouse.analytics.Orders;
			
		



