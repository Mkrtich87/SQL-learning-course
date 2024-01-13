--Lesson5

-- Drop the temporary table
DROP TABLE #tempTable;
-- Create a global temporary table
CREATE TABLE ##tempTable (column1 INT, column2 VARCHAR(50));
-- Insert data into the temporary table
INSERT INTO ##tempTable VALUES (1, 'Value 1'), (2, 'Value 2');
-- Select data from the temporary table
SELECT * FROM ##tempTable;
-- Drop the temporary table
DROP TABLE ##tempTable;
-- Create a temporary table from [Sales].[SalesOrderDetail] and [Sales].[SalesOrderHeader]
--USING
SELECT d.[SalesOrderID], d.[OrderQty], d.[LineTotal],
       h.[OrderDate], h.[ShipDate], h.[AccountNumber]
INTO #tempTable
FROM [Sales].[SalesOrderDetail] AS d
INNER JOIN [Sales].[SalesOrderHeader] AS h ON d.[SalesOrderID] = h.[SalesOrderID];
SELECT OrderQty, LineTotal  FROM #tempTable
WHERE LineTotal > (SELECT AVG(LineTotal) FROM #tempTable)
--Views
/*It's important to note that views are stored database objects,
while CTEs are temporary result sets that exist only for the duration of a single query.
CTEs are typically used when you need to define and reference a temporary result
set within a single query or a series of subsequent queries.*/
CREATE VIEW vDiscountedprices AS
SELECT Name, ListPrice,
IIF(ListPrice > 100, ListPrice * 0.5,
IIF(ListPrice > 50, ListPrice * 0.90, ListPrice)) AS DiscountedPrice
FROM Production.Product
WHERE ListPrice > 0
--SELECTING FROM THE VIEW
SELECT * FROM vDiscountedprices
GO
--DROPPING THE VIEW
DROP VIEW vDiscountedprices
GO
--Creating Indexed View
SELECT * FROM Purchasing.PurchaseOrderDetail
GO
SELECT * FROM [Purchasing].[PurchaseOrderHeader]
GO
CREATE VIEW vpurchasinginfo
WITH SCHEMABINDING
AS
SELECT
    p.[PurchaseOrderID],
	SUM(p.LineTotal) maxtotal,
	w.OrderDate,
	COUNT_BIG(*) as bigcount
			
   FROM
    [Purchasing].[PurchaseOrderDetail] p
INNER JOIN [Purchasing].[PurchaseOrderHeader] w
    ON p.[PurchaseOrderID] = w.[PurchaseOrderID]
GROUP BY p.PurchaseOrderID, w.OrderDate
GO
--Checking from how many tables sql reads we use statistics IO
SET STATISTICS IO ON
SELECT * FROM vpurchasinginfo
GO
DROP VIEW vpurchasinginfo
GO
--This statement materializes the view, making it have a physical existence in the database.
CREATE UNIQUE CLUSTERED INDEX
    ucidx_product_id
ON dbo.vpurchasinginfo(PurchaseOrderID);
CREATE NONCLUSTERED INDEX
    ucidx_product_name
ON vpurchasinginfo(maxtotal);
go
SET STATISTICS IO ON
GO
SELECT *
FROM vpurchasinginfo
   WITH (NOEXPAND)
ORDER BY OrderDate
GO
DROP VIEW vpurchasinginfo
--WINDOW functions
SELECT * FROM HumanResources.Employee
--  Quantity Each type of employee
SELECT HireDate, NationalIDNumber,LoginID, Count(*)
FROM HumanResources.Employee
GROUP BY HireDate, NationalIDNumber, LoginID
SELECT HireDate, NationalIDNumber,LoginID, Count(*) OVER( Partition BY  JobTitle) as qty, JobTitle
FROM HumanResources.Employee
-- Quantity Each type of employee  employees table
SELECT * FROM employees
ORDER BY position
SELECT name, lastname, COUNT(*) OVER (PARTITION BY position)
FROM employees
--first hired employee date according to JobTitle
SELECT HireDate, NationalIDNumber,LoginID,
Count(*) OVER( Partition BY  JobTitle) as qty,
MIN(HireDate) OVER( Partition BY  JobTitle) AS Firsthire, JobTitle
FROM HumanResources.Employee
--ranking window functions:
-- Syntax row number() OVER(ORDR BY column)
SELECT date_hired, name, lastname, position, row_number() OVER (PARTITION BY position ORDER BY date_hired desc) as drndep
FROM employees
SELECT date_hired, name, lastname, position,
row_number() OVER (ORDER BY date_hired desc) as nep,
row_number() OVER (PARTITION BY position ORDER BY date_hired desc) as rdep
FROM employees
WHERE rdep < 3
SELECT HireDate, NationalIDNumber,LoginID,
Count(*) OVER( Partition BY  JobTitle) as qty,
MIN(HireDate) OVER( Partition BY  JobTitle) AS Firsthire, JobTitle
FROM HumanResources.Employee
GO
SELECT SalesOrderID, OrderQty, RANK() OVER (
    PARTITION BY OrderQty
    ORDER BY SalesOrderID DESC
) FROM #tempTable
go
SELECT
    ProductID,
    [ModifiedDate],
    [UnitPriceDiscount],
    ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY SalesAmount DESC) AS RowNum,
    RANK() OVER (PARTITION BY ProductID ORDER BY SalesAmount DESC) AS Rank
FROM Sales.SalesOrderDetail;


WITH schemas_curation AS
  (SELECT sum(CASE
                  WHEN title IS NULL THEN 0
                  WHEN title = '' THEN 0
                  ELSE 1
              END + CASE
                        WHEN description IS NULL THEN 0
                        WHEN description = '' THEN 0
                       ELSE 1
                    END + CASE
                              WHEN steward IS NULL THEN 0
                              WHEN (steward::text LIKE '%{}%'::text) THEN 0
                              WHEN (steward::text LIKE '%{\"\"}%'::text) THEN 0
                              WHEN steward::text = '' THEN 0
                              ELSE 1
                          END + CASE
                                    WHEN data_custodian IS NULL THEN 0
                                    WHEN (data_custodian::text LIKE '%{}%'::text) THEN 0
                                    WHEN (data_custodian::text LIKE '%{\"\"}%'::text) THEN 0
                                    WHEN data_custodian::text = '' THEN 0
                                    ELSE 1
                                END + CASE
                                          WHEN data_owner IS NULL THEN 0
                                          WHEN (data_owner::text LIKE '%{}%'::text) THEN 0
                                          WHEN (data_owner::text LIKE '%{\"\"}%'::text) THEN 0
                                          WHEN data_owner::text = '' THEN 0
                                          ELSE 1
                                      END ) AS complete_schema_count
   FROM rdbms_schemas
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id} )),
tables_curation AS
  (SELECT sum(CASE
                  WHEN title IS NULL THEN 0
                  WHEN title = '' THEN 0
                  ELSE 1
              END + CASE
                        WHEN description IS NULL THEN 0
                        WHEN description = '' THEN 0
                        ELSE 1
                    END + CASE
                              WHEN steward IS NULL THEN 0
                              WHEN (steward::text LIKE '%{}%'::text) THEN 0
                              WHEN (steward::text LIKE '%{\"\"}%'::text) THEN 0
                              WHEN steward::text = '' THEN 0
                              ELSE 1
                          END) AS complete_table_count
   FROM rdbms_tables
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id} )),
columns_curation AS
  (SELECT sum(CASE
                  WHEN title IS NULL THEN 0
                  WHEN title = '' THEN 0
                  ELSE 1
              END + CASE
                        WHEN description IS NULL THEN 0
                        WHEN description = '' THEN 0
                        ELSE 1
                    END + CASE
                              WHEN steward IS NULL THEN 0
                              WHEN (steward::text LIKE '%{}%'::text) THEN 0
                              WHEN (steward::text LIKE '%{\"\"}%'::text) THEN 0
                              WHEN steward::text = '' THEN 0
                              ELSE 1
                          END + CASE
                                    WHEN critical_data_element IS NULL THEN 0
                                    WHEN (critical_data_element::text LIKE '%{}%'::text) THEN 0
                                    WHEN (critical_data_element::text LIKE '%{\"\"}%'::text) THEN 0
                                    WHEN critical_data_element::text = '' THEN 0
                                    ELSE 1
                                END + CASE
                                          WHEN data_sensitivity IS NULL THEN 0
                                          WHEN (data_sensitivity::text LIKE '%{}%'::text) THEN 0
                                          WHEN (data_sensitivity::text LIKE '%{\"\"}%'::text) THEN 0
                                          WHEN data_sensitivity::text = '' THEN 0
                                          ELSE 1
                                      END ) AS complete_column_count
   FROM rdbms_columns
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id})),
schemas_count AS
  (SELECT count(*) AS total_schemas_count
   FROM rdbms_schemas
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id} )),
tables_count AS
  (SELECT count(*) AS total_tables_count
   FROM rdbms_tables
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id})),
columns_count AS
  (SELECT count(*) AS total_columns_count
   FROM rdbms_columns
   WHERE (deleted = FALSE
          AND excluded = FALSE AND ds_id = ${ds_id | default:  1 | help: ds id} AND schema_id = ${schema_id | default:  1 | help: schema id}))
SELECT
    --   coalesce(floor((schemas_curation.complete_schema_count * 100.0)/(schemas_count.total_schemas_count * 5)), 0) AS schemas_curation_percentage,
    --   coalesce(floor((tables_curation.complete_table_count * 100.0)/(tables_count.total_tables_count * 3)), 0) AS table_curation_percentage,
    --   coalesce(floor((columns_curation.complete_column_count * 100.0)/(columns_count.total_columns_count * 5)), 0) AS columns_curation_percentage,
       coalesce(floor(((tables_curation.complete_table_count * 100) + (columns_curation.complete_column_count * 100.0))/((tables_count.total_tables_count * 3) + (columns_count.total_columns_count * 5))), 0) AS schemas_curation_percentage
       --,
    --   coalesce(schemas_curation.complete_schema_count, 0) AS complete_schema_count,
    --   coalesce(schemas_count.total_schemas_count, 0) AS total_schemas_count,
    --   coalesce(tables_curation.complete_table_count, 0) AS complete_table_count,
    --   coalesce(tables_count.total_tables_count, 0) AS total_tables_count,
    --   coalesce(columns_curation.complete_column_count, 0) AS complete_column_count,
    --   coalesce(columns_count.total_columns_count, 0) AS total_columns_count
FROM
     schemas_count,
     tables_count,
     columns_count,
     schemas_curation,
     tables_curation,
     columns_curation