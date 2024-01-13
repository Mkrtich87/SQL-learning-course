-- Creating Database--
CREATE DATABASE Analytics_Database
GO
USE Analytics_Database
go			
-- Creating new Schema--
CREATE SCHEMA Finance
go
CREATE SCHEMA Risk
go
--Creating New Table--
/*Syntax CREATE TABLE table_name (
    column1 datatype constraints,
    column2 datatype constraints,
    ...
);*/
CREATE TABLE Risk.Employee
(first_name varchar(50),
last_name varchar(50),
birthdate date,
id_number INT))
go
SELECT * FROM Risk.Employee
go
--Inserting rows in to a new table--
/*INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);*/
INSERT INTO Risk.Employee([first_name], [last_name],[birthdate],[id_number])
VALUES('Khachik', 'Shahnazayan', '10-01-2020', 1)
GO
INSERT INTO Risk.Employee([first_name], [last_name],[birthdate],[id_number])
VALUES('Vaspur', 'Engibaryan', '10-01-2020', 2),
('Tanya', 'Hovhannisyan', '10-01-2020', 3),
('Kirakos', 'Buniatyan', '10-01-2020', 4)
GO
/*UPDATE table_name
SET column1 = value1, column2 = value2,...
WHERE condtion*/
UPDATE Risk.Employee
SET first_name = 'Vaxinak', last_name = 'Arzumanyan', birthdate = '1960-03-20'
WHERE id_number = 1
GO
--Adding new column to table
/* ALTER TABLE table_name,
ADD Column_name , data_type
DROP Column_name , data_type*/
ALTER TABLE RIsk.Employee
ADD Email VArchar (50)
GO
UPDATE Risk.Employee
SET Email = 'Aviatrans@gmail.com'
WHERE first_name = 'Vaxinak'
GO
SELECT * from Risk.Employee
GO
UPDATE Risk.Employee
SET Email = 'Avianca@gmail.com'
WHERE id_number = 3
GO
-- Constraints--
-- Unique--
/*ALTER TABLE Table_Name
ADD CONSTRAINT Constraint_name UNIQUE ([Column-Name])*/
ALTER TABLE Risk.Employee
ADD CONSTRAINT UC_ID UNIQUE ([id_number])
GO
DELETE FROM RIsk.Employee
WHERE id_number = 1
GO
-- Primary key, Not Null
CREATE TABLE Finance.Sales
(Category_name VARCHAR(50),
Product_name VARCHAR (50) NOT NULL,
Sales_date DATE,
id_number INT,
PRIMARY KEY (id_number))
GO
INSERT INTO Finance.Sales(Category_name,Product_name,Sales_date,id_number)
VALUES('Tires', 'NULL','2022-10-01', 2)
SELECT * FROM Finance.Sales
GO
-- Adding IDENTITY, UNIQUE--
CREATE TABLE Sales
(Category_name VARCHAR(50),
Product_name VARCHAR (50),
Sales_date DATE,
Serial_number INT UNIQUE,
Id_number INT PRIMARY KEY IDENTITY)
GO
INSERT INTO Sales
VALUES('Apparel','T_Shirt', '2022-06-11', 251586618),
('Electronics', 'Recorder', '2022-07-11', 55131318),
('Home_Appliences','Gas_Stove','2023-07-06', 558931318)
GO
SELECT *FROM Sales
-- Identity with two step starting from 10--
CREATE TABLE Cars(
Product_name VARCHAR (50),
Sales_date DATE,
Serial_number INT UNIQUE,
Id_number INT PRIMARY KEY IDENTITY(10,2))
GO
INSERT INTO Cars(Product_name, Sales_date,Serial_number)
VALUES('Sony', '10-01-2020', 25),
('Sony', '10-01-2020', 15)
GO
SELECT * FROM Cars
GO
-- Creating table with CHECK, DEFAULT
CREATE TABLE Users(
User_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
age INT CHECK (age >=18),
hire_date DATE DEFAULT GETDATE())
GO
INSERT INTO Users(User_id,first_name, last_name,age)
VALUES(1,'Vanik','Arsenyan',18)
GO
SELECT * FROM Users
GO
-- EXEC sp_rename 'my_table.old_column', 'new_column', 'COLUMN'
EXEC sp_rename 'Users', 'Employees'
GO
EXEC sp_rename 'Employees.last_name', 'Surname', 'COLUMN'
GO
SELECT * FROM Employees
/*SELECT *, Cloumn_Name1, Column_Name2 .....
FROM  Table_Name
WHERE Condition*/
INSERT INTO Finance.Sales(Category_name,Product_name,Sales_date,id_number)
VALUES('Tires', 'Yokohama','2022-10-01', 3),
('Electronics', 'SmartPhone','2022-10-01', 4),
('Home', 'Gast_stove','2022-10-01', 5),
('Camping', 'Tent','2022-10-01', 6)
SELECT [Product_name], id_number FROM Finance.Sales
-- AND, IS NOT NULL, OR
SELECT * FROM Finance.Sales
WHERE Category_name = 'Electronics' and id_number =  115815386
go
SELECT * FROM Finance.Sales
WHERE Category_name = 'Electronics' OR id_number =  115815386
go
SELECT * FROM Risk.Employee
WHERE Email IS NOT NULL
go
DROP TABLE Sales
DROP TABLE Finance.Sales
DROP TABLE Employee
DROP TABLE Risk.Employee
DROP TABLE employees
DROP SCHEMA FInance
DROP SCHEMA Risk
DROP DATABASE [My_Database]
GO
--WHERE IN,  BETWEEN
USE AdventureWorks2019
GO
SELECT * FROM HumanResources.Employee
GO
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle IN ('Design Engineer', 'Research and Development Manager', 'Production Technician - WC60')
GO
SELECT LoginID, BirthDate, JobTitle FROM HumanResources.Employee
WHERE BirthDate > '1984-11-20' AND BirthDate < '1986-11-08'
ORDER BY BirthDate ASC
GO
SELECT LoginID, BirthDate, JobTitle FROM HumanResources.Employee
WHERE BirthDate BETWEEN '1984-11-20' AND '1986-11-08'
ORDER BY BirthDate ASC
--between includes both dates >< doesn't--
GO
-- with other columns--
SELECT * FROM [Sales].[SalesPerson]
WHERE  SalesQuota >= 250000
GO
--LIKE Operator Wildcards--
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle LIKE 'Design%'
GO
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle LIKE '%Technician'
GO
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle LIKE '%Assurance%'
GO
--third sumbol 9 and whatever comes after that
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE NationalIDNumber LIKE '__9%'
GO
--Starts with P and ends with 0--
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle LIKE 'P%0'
GO
--Starts with B or D--
SELECT LoginID, NationalIDNumber, JobTitle FROM HumanResources.Employee
WHERE JobTitle LIKE '[BD]%'
GO
--Starts with b-f and ends with whatever--
SELECT * FROM [Purchasing].[Vendor]
WHERE  Name LIKE '[b-f]%'
GO
-- Doesn't with b-f and ends with whatever--
SELECT * FROM [Purchasing].[Vendor]
WHERE  Name LIKE '[^b-f]%'
GO
SELECT * FROM [Person].[EmailAddress]
WHERE  EmailAddress LIKE '[c-f]%'
GO
--More wild cards--
-- ESCAPE Character--
--SELECT * FROM tablename WHERE column LIKE 'pattern' ESCAPE 'escape_character'--
CREATE TABLE Many_Symbols
(Column1 VARCHAR(50),
Column2 VARCHAR(50))
GO
INSERT INTO Many_Symbols(Column1, Column2)
VALUES('abc25%kdj', 'lfkfkfk'),
('cdetest', '125487[]'),
('cdetest50', '125487')
GO
SELECT * FROM Many_Symbols
GO
SELECT * FROM Many_Symbols
WHERE Column1 LIKE '[a-z]%!%%' ESCAPE '!'
GO
--Example difference between AB_@  AB@  AB__@
--INDEX Clustered and non Clustered
 -- Dropping Clustered index--
/*  when pk ALTER TABLE Sales.SalesOrderDetail
DROP CONSTRAINT [IX_SalesOrderDetail_SalesOrderID];*/
CREATE DATABASE Test
USE Test
-- Create the table
CREATE TABLE Printers_Sold (
  id INT,
  make VARCHAR(255),
  model VARCHAR(255),
  year INT
);
-- Insert 20 rows of information
INSERT INTO Printers_Sold (id, make, model, year)
VALUES
  (1, 'HP', 'OfficeJet Pro 9025', 2022),
  (2, 'Canon', 'PIXMA MX922', 2021),
  (3, 'Epson', 'Expression Premium XP-7100', 2020),
  (4, 'Brother', 'HL-L2380DW', 2020),
  (5, 'Xerox', 'WorkCentre 6515', 2022),
  (6, 'Dell', 'C2660dn', 2021),
  (7, 'Samsung', 'SL-M2020W', 2020),
  (8, 'Lexmark', 'MC3224dwe', 2021),
  (9, 'Konica Minolta', 'magicolor 4695MF', 2022),
  (10, 'Ricoh', 'SP C261SFNw', 2020),
  (11, 'HP', 'LaserJet Pro M404dw', 2022),
  (12, 'Canon', 'imageCLASS MF743Cdw', 2021),
  (13, 'Epson', 'WorkForce WF-2750', 2020),
  (14, 'Brother', 'MFC-J995DW', 2022),
  (15, 'Xerox', 'VersaLink C405', 2021),
  (16, 'Dell', 'E514dw', 2020),
  (17, 'Samsung', 'Xpress M2835DW', 2022),
  (18, 'Lexmark', 'B2236dw', 2021),
  (19, 'Konica Minolta', 'bizhub C458', 2020),
  (20, 'Ricoh', 'SP 311DNw', 2022);
  -- Creating CLustered index
CREATE CLUSTERED INDEX IX_SalesOrderDetail_ID
ON Printers_Sold (id);
GO
DROP  INDEX IX_SalesOrderDetail_ID
ON Printers_Sold;
GO
DROP TABLE Printers_Sold
GO
DROP DATABASE Test
GO
USE AdventureWorks2019
SELECT * FROM Production.Product
-- Creating a non-clustered index
CREATE NONCLUSTERED INDEX IX_Product_Name_Sales_rowguid
ON Production.Product (rowguid);
GO
--Maintaing the index
ALTER INDEX  IX_Product_Name_Sales_rowguid ON Production.Product REORGANIZE;
--Dropping the index
DROP INDEX [IX_Product_Name_Sales_rowguid]
ON Production.Product
GO
SELECT * FROM
[Production].[Product]
GO
--TOP and ORDER BY__
SELECT TOP 15 SalesOrderID, OrderQty
FROM [Sales].[SalesOrderDetail]
ORDER BY OrderQty DESC
GO
SELECT TOP 20 ProductID, Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;
GO
SELECT TOP 10 BusinessEntityID, RateChangeDate, Rate
FROM [HumanResources].[EmployeePayHistory]
ORDER BY Rate DESC;
GO
-- SQL Server OFFSET FETCH--
SELECT BusinessEntityID, RateChangeDate, Rate
FROM [HumanResources].[EmployeePayHistory]
ORDER BY Rate DESC
OFFSET 10 ROWS
GO
SELECT BusinessEntityID, RateChangeDate, Rate
FROM [HumanResources].[EmployeePayHistory]
ORDER BY Rate DESC
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY;
GO
--No Difference between first and next
SELECT BusinessEntityID, RateChangeDate, Rate
FROM [HumanResources].[EmployeePayHistory]
ORDER BY Rate DESC
OFFSET 10 ROWS
FETCH FIRST 5 ROWS ONLY;
GO
-- SELECT INTO--
SELECT ProductID, Name, ListPrice, SellStartDate
INTO dbo.NewTable
FROM Production.Product;
GO
SELECT * FROM dbo.NewTable;
GO
DROP TABLE dbo.NewTable
GO
--When you try to move only table structure--
SELECT ProductID, Name, ListPrice, SellStartDate
INTO dbo.NewTable
FROM Production.Product
WHERE ProductID = 1000
GO
SELECT * FROM Production.Product
GO
-- When you try to move to new database--
CREATE DATABASE Test
GO
SELECT ProductID, Name, ListPrice, SellStartDate
INTO Test.dbo.NewTable
FROM Production.Product
WHERE ProductID = 1000
GO
DROP DATABASE Test
GO