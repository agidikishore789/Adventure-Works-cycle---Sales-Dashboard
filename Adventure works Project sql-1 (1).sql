create database excelr;
use excelr;

# TO view tables #
SELECT * FROM sales1;
SELECT * FROM Product1;
SELECT * FROM dimcustomer1;
SELECT * FROM dimdate1;
SELECT * FROM dimsalesterritory1;

# Q1 (Simple Select) Display the first 10 rows from the SALES table #
SELECT SalesOrderNumber, Sales, Profit
FROM SALES1
LIMIT 10;

# Q2 (Filter) Display the SalesOrderNumber, SalesAmount, and Profit for all sales made in the year 2012 where the profit was greater than 1000 #
SELECT SalesOrderNumber, Sales, Profit
FROM SALES1
WHERE Year = 2012 AND Profit > 1000;

# Q3 (Join) Display each sales order number along with its corresponding sales territory region by joining the SALES table with the DimSalesTerritory table #

SELECT s.SalesOrderNumber, t.SalesTerritoryRegion
FROM SALES1 s
JOIN dimsalesterritory1 t ON s.SalesTerritoryKey = s.SalesTerritoryKey;

                                # OR #
# (Left Join) Display each sales territory region along with the sales order number and sales amount, ensuring that all territories are included even if they have no sales #                                 
SELECT t.SalesTerritoryRegion, s.SalesOrderNumber, s.Sales
FROM dimsalesterritory1 t
LEFT JOIN sales1 s ON s.SalesTerritoryKey = s.SalesTerritoryKey;

# Q4 (Sorting [ORDER BY]) Display list of all customer names in alphabetical order #
SELECT FirstName
FROM dimcustomer1
ORDER BY FirstName ASC;

# Q5 (Aggregation [GROUP BY]) Display Total Sales per year #
SELECT Year, SUM(Sales) AS TotalSales
FROM SALES1
GROUP BY Year;

# Q6 (Subqueries) Display the sales order number and sales amount for the orders with the maximum amount #
SELECT SalesOrderNumber, Sales
FROM SALES1
WHERE Sales = (SELECT MAX(Sales) FROM SALES1);

# Q7 (Windows) Write a query to rank sales orders by profit within each year #
SELECT s.SalesOrderNumber, s.Year, s.Profit,
       RANK() OVER (PARTITION BY s.Year ORDER BY s.Profit DESC) AS ProfitRank
FROM SALES1 s;

                                                        # OR #
# Write a query to rank customers by their total sales amount #                        
SELECT c.FirstName, 
       SUM(Sales) AS TotalSales,
       RANK() OVER (ORDER BY SUM(Sales) DESC) AS SalesRank
FROM SALES1 s
JOIN dimcustomer1 c ON s.CustomerKey = s.CustomerKey
GROUP BY c.FirstName;

# Q8 (Trigger) Write a trigger on the Sales table that logs the old and new SalesAmount whenever a row is updated #
CREATE TABLE Sales_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    Customerkey INT,
    ActionType VARCHAR(10),
    ActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OldValue TEXT,
    NewValue TEXT
);

INSERT INTO Sales1 (CustomerKey, ProductKey, Sales)
VALUES (60399,7777, 1500);
SELECT * FROM Sales1;

SET SQL_SAFE_UPDATES = 0;   # To disable safe update #

UPDATE Sales1 
SET Sales = 999 
WHERE CustomerKey = 60399;
SELECT * FROM Sales1;

DELETE FROM Sales1 WHERE CustomerKey = 60399;
SELECT * FROM Sales1;   

