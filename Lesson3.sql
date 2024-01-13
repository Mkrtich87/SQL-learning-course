--Advanced SQL -------------------

USE AdventureWorks2019
GO
--Subqueries
--subqueries with aggregated functions
SELECT * FROM Sales.SalesOrderDetail
--finding all the products with price higher than average price
SELECT ProductID, OrderQty, UnitPrice
FROM Sales.SalesOrderDetail
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Sales.SalesOrderDetail)
SELECT [CarrierTrackingNumber]  FROM Sales.SalesOrderDetail
-- Finding CarrierTracking number of the cheapest products bigger then 50
SELECT [CarrierTrackingNumber], [UnitPrice]
FROM [Sales].[SalesOrderDetail]
WHERE UnitPrice IN (SELECT MIN(UnitPrice) FROM [Sales].[SalesOrderDetail]
WHERE UnitPrice >=50)
GO
--Checking: should not be able to find anything more expensive than 50 dolars
SELECT [CarrierTrackingNumber], [UnitPrice]
FROM [Sales].[SalesOrderDetail]
WHERE [UnitPrice]>=50
ORDER BY UnitPrice
GO
--different result wile trying to use grouping
--as having considers the minimum unit price within each group defined by CarrierTrackingNumber
-- CarrierTrackingNumber doesn't repeat it is groupped)
SELECT [CarrierTrackingNumber], UnitPrice
FROM Sales.SalesOrderDetail
WHERE [CarrierTrackingNumber] IS NOT NULL
GROUP BY [CarrierTrackingNumber], UnitPrice
HAVING UnitPrice BETWEEN MIN(UnitPrice) AND 50
ORDER BY [CarrierTrackingNumber]
GO
SELECT CarrierTrackingNumber, UnitPrice FROM Sales.SalesOrderDetail
WHERE  CarrierTrackingNumber IS NOT NULL
--Trying to compare Average Price with each of the product prices
--Example: trying to get average Unit price with group by: fails
SELECT * FROM Sales.SalesOrderDetail
--Cannot get average for each Product ID
SELECT ProductID, UnitPrice, AVG(UnitPrice) averageprice FROM Sales.SalesOrderDetail
GROUP BY ProductID, UnitPrice
ORDER BY ProductID ASC
--comparing unit price with average of every product
SELECT ProductID, UnitPrice, (SELECT AVG(UnitPrice) as averageprice FROM Sales.SalesOrderDetail)
FROM Sales.SalesOrderDetail
ORDER BY ProductID
GO
--with the window function that calculates average for each Product id groupping 707, 708...
SELECT ProductID, UnitPrice,
       AVG(UnitPrice) OVER (PARTITION BY ProductID ORDER BY ProductID)
   AS averageunitprice
FROM Sales.SalesOrderDetail
ORDER BY ProductID
GO
--same can be done with minimum
SELECT [CarrierTrackingNumber], UnitPrice, (SELECT MIN(UnitPrice) FROM Sales.SalesOrderDetail) FROM
Sales.SalesOrderDetail
--find products with most stock levels
SELECT * FROM Production.product
SELECT ProductID, SafetyStockLevel, Name, ListPrice FROM Production.product
WHERE SafetyStockLevel IN (SELECT MAX(SafetyStockLevel) FROM Production.product)
--avoiding  Joins
--finding Customers  who have purchased stuff in June
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail
--using order date from Sales.SalesOrderHeader and [ProductID], [UnitPrice] from Sales.SalesOrderDetail
SELECT [ProductID], [UnitPrice] FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN (SELECT SalesOrderID FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2011-06-01' AND '2011-06-30')
--same with join
SELECT o.ProductID, o.UnitPrice, h.OrderDate FROM Sales.SalesOrderDetail o
INNER JOIN [Sales].[SalesOrderHeader] h
ON O.SalesOrderID = h.SalesOrderID
WHERE h.OrderDate BETWEEN '2011-06-01' AND '2011-06-30'
GO
-- trying to find employee whos rate is more than 100 USD per hour to fire them
--no pay in employee table
SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [HumanResources].[EmployeePayHistory]
-- subquery case
SELECT [NationalIDNumber], [JobTitle] FROM [HumanResources].[Employee]
WHERE [BusinessEntityID] = ( SELECT [BusinessEntityID] FROM [HumanResources].[EmployeePayHistory] WHERE Rate > 100)
SELECT [NationalIDNumber], [JobTitle], (SELECT Rate FROM [HumanResources].[EmployeePayHistory]
WHERE Rate > 100)  FROM [HumanResources].[Employee]
WHERE [BusinessEntityID] IN  (SELECT BusinessEntityID FROM [HumanResources].[EmployeePayHistory]
WHERE Rate > 100)
--joning tables
SELECT e.[NationalIDNumber], e.[JobTitle],p.Rate  FROM [HumanResources].[Employee] as e
INNER JOIN [HumanResources].[EmployeePayHistory] p
ON e.[BusinessEntityID]= p.[BusinessEntityID]
WHERE Rate > 100
--Correlated Subqueries Are the queries where inner query is executed for each outer query row
--AVG Retrieve products by color along with their average list prices:
--Average is calculated for each colour type
SELECT P.Color, p.ProductID, p.Name, p.ListPrice,
    (SELECT AVG(ListPrice)
     FROM Production.Product
     WHERE Color = p.Color) AS AvgColorListPrice
FROM Production.Product p
GO
-- if we get rid of WHERE Color = p.Color we get Average calcualted for the whole dataset, in cases of correlated above
-- Average is calculated for each colour type
SELECT P.Color, p.ProductID, p.Name, p.ListPrice,
    (SELECT AVG(ListPrice)
     FROM Production.Product
     ) AS AvgColorListPrice
FROM Production.Product p
GO
-- how many products we have sold?
--How many of each type of products we have sold?
select SUM(OrderQty) FROM Sales.SalesOrderDetail
--finding out total quantity sold by each productid
SELECT
  p.ProductID,
  p.Name AS ProductName,
  (
    SELECT SUM(od.OrderQty)
    FROM Sales.SalesOrderDetail AS od
    JOIN Sales.SalesOrderHeader AS oh ON od.SalesOrderID = oh.SalesOrderID
    WHERE od.ProductID = p.ProductID
  ) AS TotalQuantitySold
FROM Production.Product AS p;
--checking if the calculation was right
SELECT ProductID, SUM(OrderQty) FROM Sales.SalesOrderDetail
WHERE ProductID = 879
GROUP BY ProductID

-- if we get rid of WHERE od.ProductID = p.ProductID aka don't run  it for each product id wit will bring overall qty repatead
SELECT
  p.ProductID,
  p.Name AS ProductName,
  (
    SELECT SUM(od.OrderQty)
    FROM Sales.SalesOrderDetail AS od
    JOIN Sales.SalesOrderHeader AS oh ON od.SalesOrderID = oh.SalesOrderID
  ) AS TotalQuantitySold
FROM Production.Product AS p;
--checking sum of OrderQty
select SUM(OrderQty) FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
--EXISTS, ANY, ALL
--EXISTS
--To check those operators let's create two tables employees and management
CREATE TABLE employees (
  employee_id INT PRIMARY KEY IDENTITY,
  name VARCHAR(50),
  lastname VARCHAR(50),
  position VARCHAR(50),
  age INT,
  salary DECIMAL(10, 2),
  date_hired DATE
);
INSERT INTO employees (name, lastname, position, age, salary, date_hired)
VALUES
  ('John', 'Doe', 'Manager', 35, 5000.00, '2020-01-01'),
  ('Jane', 'Smith', 'Assistant', 28, 3000.00, '2021-03-15'),
  ('Michael', 'Johnson', 'Developer', 32, 4000.00, '2019-07-10'),
  ('Sarah', 'Williams', 'Analyst', 31, 3500.00, '2022-02-28'),
  ('David', 'Brown', 'Designer', 29, 3800.00, '2020-09-10'),
  ('Jennifer', 'Davis', 'Assistant', 27, 2800.00, '2021-06-05'),
  ('Robert', 'Jones', 'Developer', 33, 4200.00, '2018-12-20'),
  ('Laura', 'Miller', 'Manager', 36, 5500.00, '2017-11-15'),
  ('Daniel', 'Wilson', 'Designer', 30, 4000.00, '2023-01-10'),
  ('Emily', 'Anderson', 'Analyst', 26, 3200.00, '2022-08-03'),
  ('Matthew', 'Taylor', 'Developer', 34, 4500.00, '2019-04-12'),
  ('Olivia', 'Clark', 'Assistant', 29, 2900.00, '2020-03-27'),
  ('Christopher', 'Thomas', 'Manager', 37, 6000.00, '2018-06-18'),
  ('Ava', 'Hall', 'Analyst', 25, 3100.00, '2021-09-22'),
  ('Andrew', 'White', 'Designer', 31, 4200.00, '2019-02-09'),
  ('Sophia', 'Walker', 'Developer', 33, 4700.00, '2020-07-16'),
  ('James', 'Green', 'Assistant', 27, 2700.00, '2021-04-08'),
  ('Mia', 'Baker', 'Manager', 38, 5700.00, '2017-09-25'),
  ('Ethan', 'Harris', 'Designer', 32, 4100.00, '2022-01-18'),
  ('Isabella', 'Moore', 'Analyst', 24, 3000.00, '2022-11-30')
;
-- Create the "management" table
CREATE TABLE management (
  manager_id INT PRIMARY KEY IDENTITY,
  name VARCHAR(50),
  lastname VARCHAR(50),
  position VARCHAR(50),
  age INT,
  salary DECIMAL(10, 2),
  date_hired DATE
);
-- Insert data into the "management" table
INSERT INTO management (name, lastname, position, age, salary, date_hired)
VALUES
  ('Adam', 'Smith', 'Senior Manager', 40, 7000.00, '2018-05-01'),
  ('Emily', 'Davis', 'Director', 45, 8000.00, '2017-02-20'),
  ('Daniel', 'Wilson', 'Manager', 38, 5500.00, '2019-10-05'),
  ('Jessica', 'Brown', 'Assistant Manager', 35, 5000.00, '2020-07-12'),
  ('Benjamin', 'Johnson', 'Senior Analyst', 32, 4500.00, '2021-04-18'),
  ('Sophia', 'Anderson', 'Senior Manager', 41, 7500.00, '2016-11-15'),
  ('Andrew', 'Taylor', 'Director', 46, 8500.00, '2015-08-22'),
  ('Oliver', 'Miller', 'Manager', 39, 6000.00, '2020-01-10'),
  ('Abigail', 'Wilson', 'Assistant Manager', 36, 5500.00, '2021-06-07'),
  ('Emma', 'Johnson', 'Senior Analyst', 33, 5000.00, '2019-03-23'),
  ('William', 'Davis', 'Senior Manager', 42, 8000.00, '2017-10-18'),
  ('Sophie', 'Brown', 'Director', 47, 9000.00, '2014-07-25'),
  ('Alexander', 'Anderson', 'Manager', 40, 6500.00, '2018-02-11'),
  ('Isabella', 'Taylor', 'Assistant Manager', 37, 6000.00, '2019-09-17'),
  ('James', 'Miller', 'Senior Analyst', 34, 5500.00, '2020-06-23'),
  ('Charlotte', 'Wilson', 'Senior Manager', 43, 8500.00, '2016-03-20'),
  ('Ethan', 'Johnson', 'Director', 48, 9500.00, '2013-12-27'),
  ('Mia', 'Davis', 'Manager', 41, 7000.00, '2017-07-14'),
  ('Liam', 'Brown', 'Assistant Manager', 38, 6500.00, '2018-12-20'),
  ('Olivia', 'Anderson', 'Senior Analyst', 35, 6000.00, '2020-09-26')
;
SELECT * FROM employees
SELECT * FROM management
--Retrieve all employees who have a salary greater than ANY manager's salary.
--The smallest salary in Managers table is 4500 Benjamin	Johnson id 5
--which means any salary in employees table bigger than 4500 will be retrieved
SELECT e.name, e.lastname, e.salary
FROM employees e
WHERE e.salary > ANY (SELECT m.salary FROM management m);
GO
--Retrieve all employees who have a manager in the management table with the same age.
--The SELECT 1 statement serves as a placeholder to indicate that we
--are only interested in whether a matching row exists or not
SELECT e.name, e.lastname, E.age
FROM employees e
WHERE EXISTS (SELECT 1 FROM management m WHERE m.age = e.AGE);
GO
--Opposite table to know which managers have the same age
SELECT m.name, m.lastname, m.age
FROM management m
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.age = m.AGE);
GO
--Retrieve all employees who does have a manager in the management table with the same ag
SELECT e.name, e.lastname, E.age
FROM employees e
WHERE NOT EXISTS (SELECT 1 FROM management m WHERE m.age = e.AGE);
GO
--Retrieve all managers whose salary is greater than all employee salaries.
--The highest salary in employees table is 6000 Christopher	Thomas number 13
SELECT m.name, m.lastname, m.salary
FROM management m
WHERE m.salary > ALL (SELECT e.salary FROM employees e);
GO

SELECT * FROM Production.Product
SELECT * FROM Production.ProductInventory
--Finding product names that have no inventory
SELECT p.Name, p.ProductID
FROM Production.Product p
WHERE NOT EXISTS (
    SELECT *
    FROM Production.ProductInventory i
    WHERE p.ProductID = i.ProductID)
GO
--to check if I am right I am trying to find ProductID's fro previous query in here
SELECT * FROM  Production.ProductInventory
WHERE ProductID BETWEEN 903 AND 906
GO