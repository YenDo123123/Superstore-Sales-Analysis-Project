/*
Data exploration

Skills used: Joins, CTE's, Windows Functions, CASE Expression, Aggregate Functions, ROLLUP, Pivot table, Extracting parts of a date, FORMAT function, Date comparison

*/

-- Analyzing sales performance through calculating sales by category 
WITH new_table AS (
	SELECT DISTINCT YEAR(order_date) AS [year]
		, MONTH(order_date) AS [month]
		, category
		, SUM(s.quantity*p.price) OVER (PARTITION BY YEAR(order_date), MONTH(order_date),category ORDER BY YEAR(order_date), MONTH(order_date)) AS quantity_total
	FROM superstore_sales_detail AS s
	JOIN product AS p
	ON s.product_id = p.product_id
)
SELECT [year]
	, [month] 
	, [Furniture], [Office Supplies], [Technology]
FROM new_table
PIVOT (
   SUM (quantity_total)
   FOR category IN ([Furniture], [Office Supplies], [Technology])
) AS pivot_logic
ORDER BY [year], [month];

-- Analyzing YTD sales performance through calculating sales by segment and region
SELECT DISTINCT c.segment
	, c.region
	, SUM (p.price * s.quantity) AS total_sales_of_3_years
	, SUM (CASE WHEN s.updated_order_date > '2019-12-31' THEN p.price * s.quantity END) AS [2020_YTD_sales]
FROM superstore_sales_detail AS s
JOIN product AS p
ON s.product_id = p.product_id
JOIN customer AS c
ON s.customer_id = c.customer_id
GROUP BY c.segment
	, c.region
WITH ROLLUP
ORDER BY
	c.segment
	, c.region;

-- Calculating monthly sales percentage of total of each segment
SELECT DISTINCT c.segment 
	, YEAR (s.order_date) AS [year]
	, MONTH (s.order_date) AS [month]
	, SUM (p.price * s.quantity) OVER (PARTITION BY c.segment , YEAR (s.order_date), MONTH (s.order_date)) AS monthly_sales
	, FORMAT ((SUM (p.price * s.quantity) OVER (PARTITION BY c.segment , YEAR (s.order_date), MONTH (s.order_date)) / SUM (p.price * s.quantity) OVER (PARTITION BY YEAR (s.order_date), MONTH (s.order_date))),'p') AS percentage_of_total
FROM superstore_sales_detail AS s
JOIN product AS p
ON s.product_id = p.product_id
JOIN customer AS c
ON s.customer_id = c.customer_id;

-- Calculating month-over-month revenue growth by segment
WITH CTE_table AS (
	SELECT DISTINCT c.segment 
		, YEAR (s.order_date) AS [year]
		, MONTH (s.order_date) AS [month]
		, SUM (p.price * s.quantity) OVER (PARTITION BY c.segment , YEAR (s.order_date), MONTH (s.order_date)) AS monthly_sales
	FROM superstore_sales_detail AS s
	JOIN product AS p
	ON s.product_id = p.product_id
	JOIN customer AS c
	ON s.customer_id = c.customer_id
) 
SELECT *
	, LAG (monthly_sales) OVER (PARTITION BY segment , [year] ORDER BY segment , [year],[month]) AS previous_month_sales
	, FORMAT ((monthly_sales - LAG (monthly_sales) OVER (PARTITION BY segment , [year] ORDER BY segment , [year], [month])) / LAG (monthly_sales) OVER (PARTITION BY segment , [year] ORDER BY segment , [year],[month]), 'p') AS percent_change
FROM CTE_table;

-- Calculating monthly rolling total sales in 2020 by segment
WITH CTE_table AS (
	SELECT DISTINCT c.segment 
		, MONTH (s.order_date) AS [month]
		, SUM (p.price * s.quantity) OVER (PARTITION BY c.segment , MONTH (s.order_date)) AS monthly_sales 
	FROM superstore_sales_detail AS s
	JOIN product AS p
	ON s.product_id = p.product_id
	JOIN customer AS c
	ON s.customer_id = c.customer_id
	WHERE YEAR (s.order_date) = 2020
) 
SELECT *
	, SUM (monthly_sales) OVER (PARTITION BY segment ORDER BY segment, month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS monthly_rolling_total_sales_2020
FROM CTE_table;

-- Calculating 3-month moving average sales by segment
WITH CTE_table AS (
	SELECT DISTINCT c1.segment
		, YEAR (s.updated_order_date) AS [year]
		, c2.weekofyear AS [week]
		, SUM (p.price * s.quantity) OVER (PARTITION BY c1.segment , YEAR (s.updated_order_date), c2.weekofyear) AS weekly_sales
	FROM superstore_sales_detail AS s
	JOIN product AS p
	ON s.product_id = p.product_id
	JOIN customer AS c1
	ON s.customer_id = c1.customer_id
	JOIN calendar AS c2
	ON s.updated_order_date = c2.date
) 
SELECT * 
	, AVG (weekly_sales) OVER (PARTITION BY segment ORDER BY segment, [year], [week] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sales_3m_ma
FROM CTE_table;