/*
Data cleaning for product table

Skills used: CASE Expression, Aggregate Functions, TRIM() function, UPDATE and ALTER Commands

*/

-- Fix typos errors in category names by trimming and replacing names with syntax errors by using COUNT DISTINCT and CASE functions
UPDATE product
SET category = TRIM (category);

SELECT DISTINCT category 
	, COUNT (*)
FROM product
GROUP BY category;

UPDATE product
SET category = 
	( CASE 
		WHEN (category = 'Office Suppliess') THEN 'Office Supplies'
		WHEN (category = 'Tech nology') THEN 'Technology'
		WHEN (category = 'Furniturer') THEN 'Furniture'
		END) 
WHERE category IN ('Office Suppliess', 'Tech nology', 'Furniturer');
