-- GROUP BY--
-- Overall 395 Row
SELECT * FROM [Production].[ProductListPriceHistory]
GO
-- 293 rows  ProductID
SELECT ProductID FROM [Production].[ProductListPriceHistory]
GROUP BY ProductID
GO
--120 rows when grouping by ListPrice
SELECT ListPrice FROM [Production].[ProductListPriceHistory]
GROUP BY ListPrice
GO
-- 387 Rows ProductID + ListPrice
SELECT ProductID, ListPrice FROM [Production].[ProductListPriceHistory]
GROUP BY ProductID, ListPrice
GO
-- the columns are sorted according to their order in group by from left to right
SELECT ListPrice, ProductID FROM [Production].[ProductListPriceHistory]
GROUP BY ListPrice, ProductID
GO
--another example
--504 rows
SELECT * FROM Production.Product
GO
-- 6 rows after group by
SELECT ReorderPoint
FROM [Production].[Product]
GROUP BY ReorderPoint
GO
--Aggregate functions COUNT, SUM, MIN, MAX, AVG
--Count--
SELECT * FROM [Sales].[SpecialOffer]
GO
--Checking how many rows
SELECT COUNT(*) FROM [Sales].[SpecialOffer]
GO
SELECT * FROM Sales.Customer;
GO
--Checking how many rows where TerritoryID = 4
SELECT COUNT(*) AS TotalRows FROM Sales.Customer
WHERE TerritoryID = 4
GO
--Checking if 4696 number was right in count function by checking number of rows
SELECT *  FROM Sales.Customer
WHERE TerritoryID = 4
GO
--counting rows not null values 211 values for size counted checked in excel
SELECT count(Size) as Size_Number FROM Production.Product;
GO
--In overal 504 rows
SELECT * FROM Production.Product;
GO
--Count
 SELECT * FROM [Purchasing].[Vendor]
 GO
SELECT Name, CreditRating, COUNT(*) AS Ratings_By_Company
FROM [Purchasing].[Vendor]
GROUP BY Name, CreditRating;
GO
--Checking if our code works correctly, if Victory bkes has rating of 5
SELECT   Name, CreditRating FROM [Purchasing].[Vendor]
WHERE Name = 'Victory Bikes'
 GO
 --How Many companies have credit rating 1,2,3,4
10:41
SELECT CreditRating, COUNT(*) AS Ratings_By_Company
FROM [Purchasing].[Vendor]
GROUP BY CreditRating;
GO
--SUM--
SELECT SUM(TotalDue) as Total sales FROM Sales.salesorderheader
GO
SELECT SUM(TaxAmt) Tax_Amount FROM Sales.salesorderheader
GO
--31465 rows checking total due according to customer id granular level
SELECT CustomerID, TotalDue FROM Sales.salesorderheader
ORDER BY Customerid
-- GROUP BY + SUM (we see summirzed info on total list price by customer)
SELECT customerid, SUM(TotalDue) AS TotalListPrice_by_Customer
FROM sales.salesorderheader
GROUP BY customerid
ORDER BY customerid
GO
--Average Due by customer
SELECT customerid, AVG(TotalDue) AS TotalListPrice_by_Customer
FROM sales.salesorderheader
GROUP BY customerid
ORDER BY customerid
GO
--Selecting same columns manually to calculate average manually on excel
SELECT customerid, TotalDue FROM Sales.SalesOrderHeader
ORDER BY CustomerID
GO
--Minimum Run together with one higher comand to check if it finds minimum DUE
SELECT customerid, MIN(TotalDue) AS TotalListPrice_by_Customer
FROM sales.salesorderheader
GROUP BY customerid
ORDER BY customerid
GO
--MAX Run together with two positions higher command to check if it finds minimum DUE
SELECT customerid, MAX(TotalDue) AS TotalListPrice_by_Customer
FROM sales.salesorderheader
GROUP BY customerid
ORDER BY customerid
GO
--Having
SELECT Color, count(Size) as Size_Number FROM Production.Product
GROUP BY Color
HAVING count(Size) > 30
GO
SELECT * FROM Production.Product;
GO
GO
-- Having with MIN
SELECT CardType, MIN(ExpYear) FROM [Sales].[CreditCard]
GROUP BY CardType
HAVING MIN(ExpYear) > 2004
-- HAVING Advance example )(Take ProductID = 710 to check in excel with the next command)
SELECT ProductID, COUNT(ProductID) as NumberIDs, SUM(OrderQty*UnitPrice) AS TotalSales FROM [Sales].[SalesOrderDetail]
GROUP BY ProductID
ORDER BY ProductID
GO
--Checking if SUM and Count work
SELECT ProductID, OrderQty, UnitPrice FROM [Sales].[SalesOrderDetail]
WHERE ProductID = 710
ORDER BY ProductID
GO
--Difference between where and having
SELECT CountryRegionCode, Name, SUM(SalesYTD) FROM [Sales].[SalesTerritory]
WHERE Name != 'Northwest'
GROUP BY CountryRegionCode, Name, SalesYTD
HAVING SUM(SalesYTD) > 1000000
GO
--DISTINCT
SELECT LastName FROM [Person].[Person]
GO
SELECT DISTINCT LastName FROM [Person].[Person]
GO
USE Test

-- LEFT, LEN, RIGHT, REVERSE
CREATE TABLE City_State
(
 ID INT PRIMARY KEY,
 State VARCHAR(255),
 City VARCHAR(255),
 Name VARCHAR(255),
 Passport Varchar(255),
 Country_Capital_Population VARCHAR (255),
 Folder VARCHAR (255)
);
DROP TABLE City_State
INSERT INTO City_State(ID, State, City, Name, Passport, Country_Capital_Population, Folder)
VALUES
 (1, 'Alabama', 'Montgomery-City', 'Smith, John', 'AB123456', 'United States: Washington, D.C. - 693972','/mydocuments/'),
 (2, 'Arizona', 'Phoenix-City', 'Johnson, Lisa', 'CD234567', 'United States : Phoenix - 1660272','/localdisk/'),
 (3, 'California', 'Sacramento-City', 'Williams, Robert', 'EF345678', 'United States : Sacramento - 525166','/program_files/'),
 (4, 'Colorado', 'Denver-City', 'Brown, Sarah', 'GH456789', 'United States : Denver - 727211','/downolads/'),
 (5, 'Connecticut', 'Hartford-City', 'Davis, Michael', 'IJ567890', 'United States : Hartford - 122587','/system/'),
 (6, 'Delaware', 'Dover-City', 'Anderson, Jennifer', 'KL678901', 'United States : Dover - 38366','/lcaldiskF/'),
 (7, 'Florida', 'Tallahassee-City', 'Thomas, Jessica', 'MN789012', 'United States : Tallahassee - 194500','/FAT/'),
 (8, 'Georgia', 'Atlanta-City', 'Wilson, David', 'OP890123', 'United States : Atlanta - 506811','/lcaldiskF/'),
 (9, 'Hawaii', 'Honolulu-City', 'Martinez, Maria', 'QR901234', 'United States : Honolulu - 347397','/programdata/'),
 (10, 'Idaho', 'Boise-City', 'Taylor, Christopher', 'ST012345', 'United States : Boise - 228959','/sql/'),
 (11, 'Illinois', 'Springfield-City', 'Lee, Laura', 'UV123456', 'United States : Springfield - 116250','/lcaldiskF/'),
 (12, 'Indiana', 'Indianapolis-City', 'Garcia, Daniel', 'WX234567', 'United States : Indianapolis - 876384','/lcaldiskF/'),
 (13, 'Iowa', 'Des Moines-City', 'Lopez, Melissa', 'YZ345678', 'United States : Des Moines - 217891','/lcaldiskF/'),
 (14, 'Kansas', 'Topeka-City', 'Harris, Amanda', 'AB456789', 'United States : Topeka - 126808','/lcaldiskF/'),
 (15, 'Kentucky', 'Frankfort-City', 'Jackson, Matthew', 'CD567890', 'United States : Frankfort - 27741','/jTD/'),
 (16, 'Louisiana', 'Baton Rouge-City', 'Allen, Stephanie', 'EF678901', 'United States : Baton Rouge - 221599','/games/'),
 (17, 'Maine', 'Augusta-City', 'Turner, Timothy', 'GH789012', 'United States : Augusta - 18982','/drivers/'),
 (18, 'Maryland', 'Annapolis-City', 'White, Elizabeth', 'IJ890123', 'United States : Annapolis - 39369','/ondrive/'),
 (19, 'Massachusetts', 'Boston-City', 'Clark, Richard', 'KL901234', 'United States : Boston - 692600','/drive/'),
 (20, 'Michigan', 'Lansing-City', 'Lewis, Samantha', 'MN012345', 'United States : Lansing - 119128','/materials/')
 GO
 --LEFT--
SELECT LEFT(State, 2) FROM City_State
GO
--LEN--
SELECT LEN(City) FROM City_State
GO
--LEFT combined with LEN--
 /*In this specific case, the LEFT function is applied to the City column, and the number of characters to extract is calculated by subtracting 5 from the length of the City string using the LEN function. */
SELECT LEFT(City, LEN(City)-5) FROM City_State
GO
--CHARINDEX Returns the position of a substring in a string
SELECT CHARINDEX('-', City) AS hyphen_index FROM City_State
GO
SELECT CHARINDEX('YZ', Passport) FROM City_State
 GO
 --LEFT combined with CHARINDEX to use delimiter as cutoff finds the place of hyphen and removes -1 not to iclude it CHARINDEX('-', City) - 1)
SELECT LEFT(City, CHARINDEX('-', City) - 1) AS Substring
FROM City_State;
GO
-- another Delimiter LEFT combined with CHARINDEX to use delimiter as cutoff
SELECT LEFT(Country_Capital_Population, CHARINDEX(':', Country_Capital_Population) - 1) AS Substring
FROM City_State;
GO
-- RIGHT
SELECT RIGHT(Country_Capital_Population, 7) FROM City_State
GO
-- RIGHT with charindex and lenght to get clean population numbers
SELECT RIGHT([Country_Capital_Population],LEN([Country_Capital_Population]) - CHARINDEX('-', [Country_Capital_Population]))
FROM City_State
GO
-- Reverse with string
SELECT REVERSE('New York') as revers_string
GO
--reverse column
SELECT REVERSE(Name) FROM City_State
GO
-- LEFT REVERSE
SELECT LEFT(REVERSE(Name),4) FROM City_State
GO
-- FORMAT - formats numeric and date data types, C-currency, D-Date, F-Full Date and time, G-general dat and time,
SELECT FORMAT(5000.65,'C') AS formattedtomoney
GO
USE AdventureWorks2019
GO
SELECT * FROM [Sales].[SalesOrderDetail]
--FORMAT U-Universal UTC
SELECT FORMAT(ModifiedDate,'U') as UTC_date
FROM [Sales].[SalesOrderDetail]
GO
/* 'D': The 'D' format specifier is used to format a date value as a short date string.
The exact format depends on the regional settings of the system.*/
SELECT FORMAT(ModifiedDate,'D') as Date
FROM [Sales].[SalesOrderDetail]
GO

--RAND generates a random decimal between 0 and 1
SELECT RAND() as random_number
--RAND, CEILING as random integer +1 is to get 1-9 range of integer instead of 0-9
SELECT FLOOR(RAND() * 10) AS random_integer;
GO
--If you want to create a random integer
SELECT FLOOR(RAND() * 10) + 1 AS random_integer;
GO
--CONVERT, CAST
/*CAST: The CAST function is used to explicitly convert one data type to another.
It allows you to convert a value from one data type to another compatible data type.*/
--Syntax CAST(expression AS data_type), CAST ( expression AS target_type [ ( length ) ] )
--if you have unrecognised date column you can cast it to date time
SELECT CAST('2019-03-14' AS DATETIME) result
GO
--Lets check our table we used for date from parts
ALTER TABLE My_Date
ADD SalesDate VARCHAR(50)
GO
UPDATE My_Date
SET SalesDate = CONCAT_WS('-', Year, Month, Day);
SELECT * FROM My_Date
SELECT CAST(SalesDate as datetime) FROM My_Date
 GO
-- If you want to permanently change data type
 ALTER TABLE My_Date
ALTER COLUMN Date Date
GO
SELECT * from My_Date
GO
--Other examples
SELECT UnitPrice FROM Sales.SalesOrderDetail
GO
--Casting a Numeric Value: Unit price is Money to decimal Rounded
SELECT CAST(UnitPrice AS DECIMAL(10,1)) AS Price
FROM Sales.SalesOrderDetail;
GO
--Casting a Numeric Value: Unit price is Money to INT Rounded
SELECT CAST(UnitPrice AS INT) AS Price
FROM Sales.SalesOrderDetail;
GO
--OrderQty Small int to Big int
SELECT CAST(OrderQty AS BIGINT) AS BigOrd
FROM Sales.SalesOrderDetail;
GO

--CarrierTrackingNumber Nvarchar(25) to CHAR(9) truncates it to 9 characters
--Run with the command below
SELECT CAST([CarrierTrackingNumber] AS CHAR(9)) AS Price
FROM Sales.SalesOrderDetail;
GO
--Run with the command above
SELECT [CarrierTrackingNumber] FROM Sales.SalesOrderDetail;
GO
/*From Data Type          To Data Type    Behavior
numeric             numeric             Round
numeric             int         Truncate
numeric             money Round
money int         Round
money numeric             Round
float     int         Truncate
float     numeric             Round
float     datetime           Round
datetime           int         Round*/
/*CONVERT: The CONVERT function has a slightly more complex syntax
and allows for additional options.The format is:
CONVERT(data_type, expression, [style]).*/
--Convert is more usable for date/time data
SELECT CONVERT(VARCHAR(10), OrderDate, 101) AS OrderDate
FROM Sales.SalesOrderHeader
GO
SELECT CONVERT(VARCHAR(10), OrderDate, 111) AS OrderDate
FROM Sales.SalesOrderHeader
GO
SELECT OrderDate FROM Sales.SalesOrderHeader
GO
-- PI value
SELECT PI() AS pi_value;
GO
-- RADIANS function is used to convert an angle value from degrees to radians
SELECT RADIANS(90) AS angle_in_radians;
GO
SELECT RADIANS(180) AS angle_in_radians;
GO
SELECT RADIANS(360) AS angle_in_radians;
GO
-- DEGREES
SELECT DEGREES(6) AS degrees
--CONVERT, CAST
SELECT CONVERT(DECIMAL(10,5),RADIANS(360)) AS angle_in_radians;
GO
SELECT CAST(RADIANS(360) AS DECIMAL(10,5)) AS angle_in_radians;
GO
--Radians = Degrees * (π / 180)
SELECT CAST(360 AS DECIMAL(18, 15)) * (PI() / 180) AS angle_in_radians;
 --ROUND function is used to round a numeric value to a specified number of decimal places.
-- Syntax ROUND(number, decimal_places)
SELECT ROUND(3.14159, 2) AS rounded_value;
GO
SELECT ROUND(CAST(360 AS DECIMAL(18, 15)) * (PI() / 180),2) AS angle_in_radians;
GO
--Rounding Standard cost from Production.Product
SELECT StandardCost FROM [Production].[Product]
WHERE StandardCost > 0
GO
SELECT ROUND(StandardCost, 1) AS rounded_value
FROM Production.Product
WHERE StandardCost > 0
GO
--VAR, VARP, STDV, STDVP
SELECT VAR([TotalDue]) AS variance
FROM [Sales].[SalesOrderHeader];
GO
--Variance of Population
SELECT VARP([TotalDue]) AS population_variance
FROM [Sales].[SalesOrderHeader];
GO
SELECT STDEV([TotalDue]) AS standard_deviation
FROM [Sales].[SalesOrderHeader];
GO
SELECT STDEVP([TotalDue]) AS population_standard_deviation
FROM [Sales].[SalesOrderHeader];
GO
 SELECT MIN(TotalDue) AS Minmum, MAX(TotalDue) AS Maximum, AVG(TotalDue) AS Average, VAR(TotalDue) AS Varianc, STDEV(TotalDue) AS Standard_Deviation
 FROM [Sales].[SalesOrderHeader];
 GO
 --IIF
--Returns a value if a condition is TRUE, or another value if a condition is FALSE
--IIF(condition, value_if_true, value_if_false)
SELECT OrderQty, IIF(OrderQty > 10, 'High', 'Low') AS QuantityCategory
FROM Sales.SalesOrderDetail;
GO
SELECT * FROM [Sales].[CurrencyRate]
GO
SELECT CurrencyRateDate, ToCurrencyCode,
IIF(ToCurrencyCode = 'AUD', 'Yes', 'No')
FROM [Sales].[CurrencyRate]
GO
SELECT * FROM [Sales].[CurrencyRate]
GO
SELECT CurrencyRateDate, ToCurrencyCode,
IIF(ToCurrencyCode IN ('AUD', 'CAD', 'CNY'), 'Yes', 'No')
FROM [Sales].[CurrencyRate]
GO
-- discount you want to give according to price
SELECT Name, ListPrice,
IIF(ListPrice > 100, ListPrice * 0.5,
IIF(ListPrice > 50, ListPrice * 0.90, ListPrice)) AS DiscountedPrice
FROM Production.Product
WHERE ListPrice > 0
GO
SELECT * FROM Production.Product
GO
--Thank youeck the ongoing tasks and conversations.