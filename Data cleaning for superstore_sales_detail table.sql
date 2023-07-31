/*
Data cleaning for superstore_sales_detail table

Skills used: CTE's, Window functions, Converting data types, CASE Expression, UPDATE and ALTER Commands

*/

-- Remove Duplicates by using CTE and ROW_NUMBER() function
WITH duplicate_table AS (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY order_id, product_id ORDER BY order_id, product_id) -1 AS duplicate
	FROM superstore_sales_detail
)
DELETE FROM duplicate_table
WHERE duplicate > 0;

-- Standardize Date Format by using CONVERT function
ALTER TABLE superstore_sales_detail
Add updated_ship_date DATE
	, updated_order_date DATE;

UPDATE superstore_sales_detail
SET updated_ship_date = CONVERT(DATE,ship_date)
	, updated_order_date = CONVERT (DATE, order_date)