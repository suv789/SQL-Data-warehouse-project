-- Check For Nulls OR Duplicate in Primary Key
-- Expectation: No Result
SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

---- Check for Nagitive Number or NULL values
---- Expectaion: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost <1 OR prd_cost IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
	FROM silver.crm_prd_info
WHERE prd_nm !=TRIM(prd_nm);

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;

--- Data Standardization Consistency

SELECT DISTINCT cst_gendr
FROM silver.crm_cust_info;

-- Check For Invalid Dates
SELECT
NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8;

-- check data consistency : Between Sales, Quantity, price
-- sales = Quantity * Price
-- Values must not be Null, Zero or Nagative
	SELECT DISTINCT
		sls_sales,
		sls_quantity,
		CASE
			WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != ABS(sls_price) * sls_quantity
				THEN  ABS(sls_price) * sls_quantity
			ELSE sls_sales
		END AS sls_sales,
		CASE WHEN sls_price IS NULL OR sls_price <= 0
			THEN sls_sales / NULLIF(sls_quantity,0)
		ELSE sls_price
		END AS sls_price

	FROM bronze.crm_sales_details
	WHERE sls_sales != sls_quantity * sls_price;

-- --Identify Out-of-Range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();
