--INTESRECT, EXCEPT
--except is good when trying to compare two tables
-- We can check previous query with except. Same 72 rows are returned
SELECT p.Name, p.ProductID
FROM Production.Product p
WHERE NOT EXISTS (
    SELECT *
    FROM Production.ProductInventory i
    WHERE p.ProductID = i.ProductID)
GO
SELECT ProductID
FROM Production.Product p
EXCEPT
SELECT ProductID
FROM Production.ProductInventory
GO
--Finding out which ages are missing in the second table
--using order by
SELECT age
FROM Employees
EXCEPT
SELECT age
FROM management
ORDER BY age
GO
-- it returns distinct rows not columns
-- it checks the combination of two columns
SELECT lastname, age
FROM Employees
SELECT lastname, age
FROM management
ORDER BY age
GO
SELECT lastname, age
FROM Employees
EXCEPT
SELECT lastname, age
FROM management
ORDER BY age
GO
--Finding out which names are different in the second table Johnson 32 is the only one that is present in table management
SELECT name
FROM Employees
EXCEPT
SELECT name
FROM management;
GO
--checking which names are existing in both tables
SELECT name
FROM Employees
INTERSECT
SELECT name
FROM management;
GO
/*We can find out there are products that where not sold when comparing
SELECT * FROM Production.Product
SELECT * FROM  Sales.SalesOrderDetail*/
SELECT * FROM Production.Product
SELECT * FROM  Sales.SalesOrderDetail
GO
SELECT
    ProductID
FROM
    Production.Product
EXCEPT
SELECT
    ProductID
FROM
    Sales.SalesOrderDetail;
GO
--We can check the names of products that are not currently sold
SELECT ProductID, Name FROM Production.Product
WHERE ProductID IN (346,	1,	369,	
532,	413,	358,	323,	398,	
534,	447,	321,	403,	495,	
348,	847,	385,	376,	746,	
520,	381,	829,	481,	361,	
408,	331,	380,	812,	318,	363,	
329,	3,	535,	427,	508,	437,	320,	419,	
901,	517,	349,	480,	737,	453,	451,	845
)
--There are no sold items that are missing in Production.Product table
SELECT
    ProductID
FROM
    Sales.SalesOrderDetail
EXCEPT
SELECT
    ProductID
FROM
    Production.Product
GO
--INTERSECT
SELECT
    ProductID
FROM
    Production.Product
INTERSECT
SELECT
    ProductID
FROM
    Sales.SalesOrderDetail;
GO
-- 504 rows of ProductID  of which there are 238 WorkOrders
SELECT ProductID
FROM Production.Product
INTERSECT
SELECT ProductID
FROM Production.WorkOrder ;
--the intersect allows to find if the managers in employee table
--get the same salary as in managers table
SELECT position, salary
FROM employees
INTERSECT
SELECT position, salary
FROM management
SELECT * FROM employees
SELECT * FROM management
--Creating Stored Procedure
CREATE PROCEDURE  EmployeeSalaryhistory
AS
BEGIN
SELECT E.LoginID, P.Rate FROM  [HumanResources].[Employee] AS E
INNER JOIN [HumanResources].EmployeePayHistory AS P
ON E.BusinessEntityID = P.BusinessEntityID
END


EXEC EmployeeSalaryhistory
GO
--Alter Stored Procedure or do it with the help of UI
ALTER PROCEDURE EmployeeSalaryhistory
AS
BEGIN
SELECT TOP 10 E.LoginID, P.Rate FROM  [HumanResources].[Employee] AS E
INNER JOIN [HumanResources].EmployeePayHistory AS P
ON E.BusinessEntityID = P.BusinessEntityID
END
GO
DROP PROCEDURE EmployeeSalaryhistory;
--Stored Porcedures with paramaters: adding a parameter of the list price
CREATE PROCEDURE uspFindProducts (@min_list_price AS DECIMAL)
AS
BEGIN
    SELECT
        Name,
        ListPrice
    FROM
        Production.Product
    WHERE
        ListPrice >= @min_list_price
    ORDER BY
        ListPrice;
END;
GO
--executing the stored procedure will return all the list prices bigger than parameter
EXEC uspFindProducts 50
GO
--Alter Procedure with adding parameter @prefered_colour AS VARCHAR(50)
ALTER PROCEDURE [dbo].[uspFindProducts](@min_list_price AS DECIMAL, @prefered_colour AS VARCHAR(50))
AS
BEGIN
    SELECT
        Name, Color,
        ListPrice
    FROM
        Production.Product
    WHERE
        ListPrice >= @min_list_price
		AND Color = @prefered_colour
    ORDER BY
        ListPrice;
END;
EXEC uspFindProducts 50, Black
GO
DROP PROCEDURE uspFindProducts
SELECT * FROM Production.Product
GO
--CTE Common Table Expressions allows you to define a temporary named result set
--let's asume each employee has a manager with the same id
	WITH employee_manager AS (
    SELECT e.name AS employee_name, e.lastname AS employee_lastname, m.name AS manager_name, m.lastname AS manager_lastname
    FROM employees e
    LEFT JOIN management m ON e.employee_id = m.manager_id
)
SELECT employee_name, employee_lastname, manager_name, manager_lastname
FROM employee_manager;
--LESSON 14
--Making CTE from older subqueries to use those again
--Finding product names that have no inventory
--in the cte the number and name of the columns should be the same as in expression
WITH exhausted_inventory (Name, ProductID)
AS
(SELECT p.Name, p.ProductID
FROM Production.Product p
WHERE NOT EXISTS (
    SELECT *
    FROM Production.ProductInventory i
    WHERE p.ProductID = i.ProductID))
SELECT * FROM exhausted_inventory
WHERE Name LIKE '%Mountain%'
GO
--multiple cte's in one code block helps to make the code easier to understand
--in here we are creating two cte one from inventory another from sales
--we find out how many do we have of expensive product and how many have been sold
WITH inventory_stack
AS
(SELECT ProductID, Quantity, LocationID
    FROM Production.ProductInventory),
expensive_products
AS
(SELECT ProductID, OrderQty, UnitPrice FROM [Sales].[SalesOrderDetail]
WHERE UnitPrice > 1000)
SELECT TOP 100 i.Quantity, i.LocationID, e.OrderQty, e.UnitPrice FROM inventory_stack i
INNER JOIN expensive_products  e
ON i.ProductID=e.ProductID
--recursive CTE
WITH number_sequence (n) AS (
    -- Anchor member
    SELECT 1 as n
    UNION ALL
    -- Recursive member
    SELECT n + 1
    FROM number_sequence
    WHERE n < 10
)
SELECT n
FROM number_sequence;
-- recursive Factorial
--n! =n*(n-1)! or (n+1)n!
	WITH ctefatorial as
	(SELECT 1 AS n, 1 AS fact --anchor part
	UNION ALL
	SELECT n+1, (n+1) * fact --recursive part
	FROM ctefatorial
	WHERE n<5) --termination check
	SELECT n, fact FROM ctefatorial --calling
-- Another case of recursive CTE looping weekdays
WITH cte_numbers(n, weekday)
AS (
    SELECT
        0,
        DATENAME(DW, 0)
    UNION ALL
    SELECT
        n + 1,
        DATENAME(DW, n + 1)
    FROM
        cte_numbers
    WHERE n < 6
)
SELECT n,
    weekday
FROM
    cte_numbers;
--Case statements
/*CASE case_value
WHEN when_value THEN statement_list
[WHEN when_value THEN statement_list] …
[ELSE statement_list]
END CASE*/
-- order quantity big or small
SELECT TOP 1000 [SalesOrderDetailID], OrderQty,

CASE
   
WHEN OrderQty > 3 THEN 'The quantity is greater than 3'
   
WHEN OrderQty = 3 THEN 'The quantity is 3'
   
ELSE 'The quantity is under 3'
END
AS QuantityText

FROM [Sales].[SalesOrderDetail]
--CASE Statement With aggregate functions ORDER BY Clause
SELECT  StateProvinceID,
CASE
WHEN COUNT(Person.Address.City) > 20 THEN 'manycandidates'
ELSE 'need more promotion'
END As persons_by_province
FROM  [AdventureWorks2019].[Person].[Address]
GROUP BY StateProvinceID
--Advanced case
--Retrieving employees with their hire date and department
--WITH JOIN
SELECT e.BusinessEntityID, e.NationalIDNumber, e.LoginID, e.Jobtitle, e.HireDate,  d.EndDate as enddate,  tenureinyears =
CASE	
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))>= 5 THEN '5+'
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))>= 3 THEN '3-4'
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))= 1 THEN '1-2'
   ELSE 'Less Than Year'
END
FROM HumanResources.Employee e
LEFT JOIN HumanResources.EmployeeDepartmentHistory D
ON d.BusinessEntityID=e.BusinessEntityID
GO
-- selecting the one's who are still workig by selecting only the rows where end date is null
SELECT e.BusinessEntityID, e.NationalIDNumber, e.LoginID, e.Jobtitle, e.HireDate,  d.EndDate as enddate,  tenureinyears =
CASE	
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))>= 5 THEN '5+'
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))>= 3 THEN '3-4'
   WHEN DATEDIFF(YEAR, HireDate, DateADD(year,-9,GETDATE()))= 1 THEN '1-2'
   ELSE 'Less Than Year'
END
FROM HumanResources.Employee e
LEFT JOIN HumanResources.EmployeeDepartmentHistory D
ON d.BusinessEntityID=e.BusinessEntityID
WHERE d.EndDate IS NULL

SELECT ProductID, OrderQty, UnitPrice,
CASE
    WHEN OrderQty > 1 THEN lineTotal
	ELSE UnitPrice
END AS total
from Sales.SalesOrderDetail
SELECT ProductID, OrderQty, UnitPrice, LineTotal
from Sales.SalesOrderDetail
GO
--opposite case
SELECT ProductID, OrderQty, UnitPrice,
CASE
    WHEN OrderQty > 1 THEN UnitPrice
	ELSE LineTotal
END AS total
from Sales.SalesOrderDetail
GO
--tempoary table
-- Create a local temporary table
CREATE TABLE #tempTable (column1 INT, column2 VARCHAR(50));
-- Insert data into the temporary table
INSERT INTO #tempTable VALUES (1, 'Value 1'), (2, 'Value 2');
-- Select data from the temporary table
SELECT * FROM #tempTable;
