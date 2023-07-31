-- CLEANING DATA: "C:\Users\LENOVO\OneDrive\Máy tính\Project\data cleaning anh Maz.docx" 
-- quality data meaning: Accuracy (The degree to which the data is close to the true values.), Completeness (The degree to which all required data is known.), Consistency (The degree to which the data is consistent, within the same data set or across multiple data sets.), Uniformity
-- *Khong phai luc nao cũng theo thu tu nay*
-- Step 1: Inspection: Detect unexpected, incorrect, and inconsistent data.
-- Data profiling: A summary statistics about the data, called data profiling, is really helpful to give a general idea about the quality of the data.
-- Visualizations: By analyzing and visualizing the data using statistical methods such as mean, standard deviation, range, or quantiles, one can find values that are unexpected and thus erroneous.
-- For example, by visualizing the average income across the countries, one might see there are some outliers (link has an image). Some countries have people who earn much more than anyone else. Those outliers are worth investigating and are not necessarily incorrect data.
-- Step 2: Cleaning: incorrect data is either removed, corrected, or imputed.
-- Step 2.1. Irrelevant data - Delete Unused Columns https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Data%20Cleaning%20Portfolio%20Project%20Queries.sql
-- Step 2.2. Duplicate https://campus.datacamp.com/courses/cleaning-data-in-postgresql-databases/data-cleaning-basics?ex=11
-- (will do) => CHECK PRIMARY KEY CÓ BỊ LẶP KHÔNG
-- 3. Data convention (Number, Date, Unix Timestamp)
-- 4. Syntax Error (remove white spaces, pad strings, fix types) => group by to graph a bar plot is the best way
-- 5. Missing values (xem kỹ)
-- 6. outliers
-- 7. Normalization & scale data
-- Step 3: Verifying: After cleaning, the results are inspected to verify correctness.
-- Step 4: Reporting: A report about the changes made and the quality of the currently stored data is recorded.


-- [NOT YET] Standardize string https://campus.datacamp.com/courses/cleaning-data-in-postgresql-databases/data-cleaning-basics?ex=11
	-- OR Breaking out Address into Individual Columns (Address, City, State) https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Data%20Cleaning%20Portfolio%20Project%20Queries.sql
	-- AND Change Y and N to Yes and No in "Sold as Vacant" field https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Data%20Cleaning%20Portfolio%20Project%20Queries.sql
-- Standardize Date Format
Select CONVERT(Date,order_date) AS updated_order_date, CONVERT(Date,ship_date) AS updated_ship_date
From [projects].[dbo].[superstore]

Update [projects].[dbo].[superstore]
SET order_date = CONVERT(Date,order_date) 
	, ship_date = CONVERT(Date,ship_date)

-- [NOT YET] Converting Data https://campus.datacamp.com/courses/cleaning-data-in-postgresql-databases/data-cleaning-basics?ex=11

-- https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Data%20Cleaning%20Portfolio%20Project%20Queries.sql
-- Missing: OR Populate Property Address data https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Data%20Cleaning%20Portfolio%20Project%20Queries.sql
-- [NOT YET] Transforming Data https://campus.datacamp.com/courses/cleaning-data-in-postgresql-databases/data-cleaning-basics?ex=11 

---------------------------------------------
-- DATA EXPLORATION
-- Aggregating Time Series Data https://campus.datacamp.com/courses/time-series-analysis-in-sql-server/aggregating-time-series-data?ex=2
-- Answering Time Series Questions with Window Functions -> 
-- LỖI Break out a date into year, month & select distinct values & Aggregating Time Series Data & Using CTE, window function and pivot table to analyse promotion effectiveness
WITH promotion_table AS (
	SELECT DISTINCT YEAR ([order_date]) AS order_year
		, MONTH([order_date]) AS order_month
		, promo
		, SUM (sales) OVER (PARTITION BY YEAR ([order_date]), MONTH([order_date]) ORDER BY YEAR ([order_date]), MONTH([order_date])) AS sum_sales
	FROM [projects].[dbo].[superstore]
) 
SELECT order_year
	, order_month
	, [Bookcases], [Chairs], [Labels], [Storage], [Furnishings], [Art], [Phones], [Binders],[Appliances], [Paper], [Accessories], [Envelopes], [Fasteners], [Machines], [Copiers]
FROM 
( SELECT order_year, order_month, promo, sum_sales
FROM promotion_table) AS new_table
PIVOT 
( SUM (sum_sales))
FOR promo IN ([Bookcases], [Chairs], [Labels], [Storage], [Furnishings], [Art], [Phones], [Binders],[Appliances], [Paper], [Accessories], [Envelopes], [Fasteners], [Machines], [Copiers]) AS new_table2