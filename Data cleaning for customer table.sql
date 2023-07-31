/*
Data cleaning for customer table

Skills used: PARSENAME and REPLACE functions, UPDATE and ALTER Commands

*/

-- Break “Adresss” column into Country, Region, City by using PARSENAME and REPLACE functions
ALTER TABLE customer
ADD Country Nvarchar(255)
	, Region Nvarchar(255)
	, City Nvarchar(255);

UPDATE customer
SET Country = PARSENAME(REPLACE(Adresss, '-', '.') , 3)
	, Region = PARSENAME(REPLACE(Adresss, '-', '.') , 2)
	, City = PARSENAME(REPLACE(Adresss, '-', '.') , 1);