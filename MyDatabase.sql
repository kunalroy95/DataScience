--Create database and tables
CREATE DATABASE SalesExtended
GO
USE SalesExtended
GO
CREATE TABLE Customers(
         CustomerID int,
		 CustomerFirstName varchar(50),
		 CustomerLastName varchar(50),
		 CustomerEmail varchar(60)
	)
	GO
	
	INSERT INTO Customers VALUES (1, 'Bill', 'Gates', 'bill@msn.com')
	INSERT INTO Customers  VALUES (2, 'Larry', 'Ellison', 'larry@oracle.com')
	INSERT INTO Customers  VALUES (3, 'Sally', 'Struthers', 'sally@abc.com')
	INSERT INTO Customers  VALUES (4, 'Joe', 'Smith', 'joe.smith@gmail.com')
	INSERT INTO Customers  VALUES (5, 'Kim', 'Lee', 'kimlee@gmail.com')
	INSERT INTO Customers  VALUES (6, 'Andrew', 'Henson', 'andrew7@certifiednetworks.com')
	INSERT INTO Customers  VALUES (7, 'Zander', 'Henson', 'zander7@certifiednetworks.com')
	INSERT INTO Customers  VALUES (8, 'Dave', 'Henson', 'dhenson@certifiednetworks.com')
	INSERT INTO Customers  VALUES (9, 'Chrissy', 'Guzman', 'cece@gmail.com')
	GO

select * from Customers

	CREATE TABLE Products(
	      ProductID int IDENTITY,
		  ProductName varchar(50),
		  ProductMSRP money
		  )
		  GO
		  
		  INSERT Products VALUES ('Chair', 49.99)
		  INSERT Products VALUES ('Monitor', 101.99)
		  INSERT Products VALUES ('Desk', 99.99)
		  INSERT Products VALUES ('Guitar', 499.99)
		  INSERT Products VALUES ('Bass', 1099.99)
		  INSERT Products VALUES ('Drums', 1029.99)
		  INSERT Products VALUES ('BBQ', 399.99)
		  INSERT Products VALUES ('Lawn Darts', 19.99)
		  INSERT Products VALUES ('Sprinkler', 9.99)
		  GO

		  select * from Products

		  CREATE TABLE Orders (  
		  OrderID int identity,  
		  OrderDate datetime,  
		  CustomerID int)
		  GO
		  
		  CREATE TABLE OrderDetails (
		   OrderDetailID int identity,
		   OrderID int,  
		   ProductID int,  
		   Quantity int,  
		   UnitPrice money)
		   GO
		   
		   --Order 1
		   DECLARE @orderid int = 0
		   DECLARE @CustomerID int = 1
		   
		   INSERT INTO Orders VALUES('10/31/2019', @CustomerID)
		   
		   select @orderid = @@IDENTITY
		   
		   INSERT OrderDetails VALUES(@orderid, 1, 10, 49.99)
		   INSERT OrderDetails VALUES(@orderid, 2, 1, 101.99)
		   GO
		   
		   --order 2
		   
		   DECLARE @orderid int = 0
		   DECLARE @CustomerID int = 9
		   
		   INSERT INTO Orders VALUES('11/1/2019', @CustomerID)
		   
		   select @orderid = @@IDENTITY
		   
		   INSERT OrderDetails VALUES(@orderid, 1, 10, 49.99)
		   INSERT OrderDetails VALUES(@orderid, 4, 1, 499.99)
		   GO
		   
		   --order 3
		   DECLARE @orderid int = 0
		   DECLARE @CustomerID int = 7
		   
		   INSERT INTO Orders VALUES('1/1/2020', @CustomerID)
		   
		   select @orderid = @@IDENTITY
		   
		   INSERT OrderDetails VALUES(@orderid, 1, 10, 49.99)
		   INSERT OrderDetails VALUES(@orderid, 2, 1, 101.99)
		   GO
		   
		   --order 3
		   DECLARE @orderid int = 0
		   DECLARE @CustomerID int = 2
		   
		   INSERT INTO Orders VALUES('2/1/2020', @CustomerID)
		   
		   select @orderid = @@IDENTITY
		   
		   INSERT OrderDetails VALUES(@orderid, 1, 10, 49.99)
		   INSERT OrderDetails VALUES(@orderid, 2, 1, 101.99)
		   GO
		   
		   --reports--Business question: how much has Bill spent?
		   
		   SELECT   
		      CustomerEmail,  
			  Sum(UnitPrice * quantity) as TotalSpending,
			  Sum(quantity) as TotalUnits
			  FROM OrderDetails od
			  INNER JOIN orders o  
			   ON o.OrderID = od.OrderID
			  INNER JOIN customers c  
			   ON o.CustomerID = c.CustomerID
			  INNER JOIN products p  
			   ON od.ProductID = p.ProductID
			   WHERE c.CustomerID = 1
			   GROUP BY CustomerEmail
			   
			   --CustomerEmail   TotalSpending--bill@msn.com    601.89

			   --DISTINCT keyword
			   
			   SELECT DISTINCT customerid FROM orders

			   --list the top 3 best selling products
			   
			   SELECT TOP 3  
			     p.ProductID, 
				 p.ProductName, 
				 Sum(Quantity) AS TotalUnits
				FROM products p
				LEFT JOIN OrderDetails od  
				  ON p.ProductID = od.ProductID
				  GROUP BY p.ProductID, ProductName
				  ORDER BY TotalUnits DESC

--1 Chair	40
--2	Monitor	3
--4	Guitar	1

--create an SQL script to add a new row to the Products table using a loop.  Use
-- variables for each column.

DECLARE @loop int = 0
WHILE @loop < 100
BEGIN  
  SELECT @loop += 1  
  
  DECLARE @productname varchar(50) = 'test'  
  DECLARE @ProductMSRP money = 99.99  
  
  INSERT INTO Products VALUES(@productname, @ProductMSRP)
  
  END

  SELECT * FROM Products

--More select statements
SELECT *
FROM orderdetails
WHERE orderid = 1
ORDER BY quantity ASC 

-- Select top 2
SELECT TOP 2 *
FROM Products
ORDER BY ProductID DESC

-- Create Views

create view BasicJoin
as
select   
o.OrderID,  
OrderDate,  
ustomerID,  
OrderDetailID,  
ProductID,  
Quantity,  
UnitPrice
from orders o
inner join OrderDetails od
on o.orderid = od.OrderID  

select *, dbo.GetCustomerEmail(customerid) as email  
from BasicJoin
			   
