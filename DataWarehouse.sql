-- 1. Create Data Warehouse Database
CREATE DATABASE IF NOT EXISTS DataWarehouse;
USE DataWarehouse;

-- 2. Create Dimension Tables

CREATE TABLE IF NOT EXISTS Dim_Store (
    StoreID INT PRIMARY KEY,
    CityID INT,
    CityName VARCHAR(100),
    State VARCHAR(100),
    Phone VARCHAR(20),
    OfficeAddress VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS Dim_Product (
    ProductID INT PRIMARY KEY,
    Description VARCHAR(200),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Dim_Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CityName VARCHAR(100),
    State VARCHAR(100),
    IsTourist BOOLEAN,
    IsRegular BOOLEAN,
    FirstOrderDate DATE
);

CREATE TABLE IF NOT EXISTS Dim_Date (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    DayOfWeek VARCHAR(10)
);

-- 3. Create Fact Tables

CREATE TABLE IF NOT EXISTS Fact_Inventory (
    StoreID INT,
    ProductID INT,
    DateID INT,
    QuantityInStock INT,
    PRIMARY KEY (StoreID, ProductID, DateID),
    FOREIGN KEY (StoreID) REFERENCES Dim_Store(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE IF NOT EXISTS Fact_Order (
    OrderID INT,
    CustomerID INT,
    DateID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Dim_Customer(CustomerID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE IF NOT EXISTS Fact_OrderDetail (
    OrderID INT,
    ProductID INT,
    QuantityOrdered INT,
    UnitPrice DECIMAL(10,2),
    OrderTime DATETIME,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Fact_Order(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID)
);

-- 4. ETL Process (Extract, Transform, Load)

-- Disable foreign key checks to allow truncation
SET FOREIGN_KEY_CHECKS = 0;

-- Truncate all tables to ensure clean data load
TRUNCATE TABLE Fact_OrderDetail;
TRUNCATE TABLE Fact_Order;
TRUNCATE TABLE Fact_Inventory;
TRUNCATE TABLE Dim_Date;
TRUNCATE TABLE Dim_Customer;
TRUNCATE TABLE Dim_Product;
TRUNCATE TABLE Dim_Store;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Populate Dim_Date (Sample for one year using recursive CTE)
WITH RECURSIVE date_sequence AS (
    SELECT 1 AS n, '2024-01-01' AS FullDate
    UNION ALL
    SELECT n + 1, DATE_ADD(FullDate, INTERVAL 1 DAY)
    FROM date_sequence
    WHERE n < 365
)
SELECT 
    n AS DateID,
    FullDate,
    DAY(FullDate) AS Day,
    MONTH(FullDate) AS Month,
    YEAR(FullDate) AS Year,
    QUARTER(FullDate) AS Quarter,
    DAYNAME(FullDate) AS DayOfWeek
FROM date_sequence;

-- Populate Dim_Store
INSERT INTO Dim_Store (StoreID, CityID, CityName, State, Phone, OfficeAddress)
SELECT 
    s.StoreID,
    s.CityID,
    ro.CityName,
    ro.State,
    s.Phone,
    ro.OfficeAddress
FROM Sales.Store s
JOIN Sales.RepresentativeOffice ro ON s.CityID = ro.CityID;

-- Populate Dim_Product
INSERT INTO Dim_Product (ProductID, Description, Size, Weight, Price)
SELECT 
    ProductID,
    Description,
    Size,
    Weight,
    Price
FROM Sales.Product;

-- Populate Dim_Customer
INSERT INTO Dim_Customer (CustomerID, CustomerName, CityName, State, IsTourist, IsRegular, FirstOrderDate)
SELECT 
    c.CustomerID,
    c.CustomerName,
    ro.CityName,
    ro.State,
    CASE WHEN EXISTS (SELECT 1 FROM RepresentativeOffice.TouristCustomer tc WHERE tc.CustomerID = c.CustomerID) THEN 1 ELSE 0 END AS IsTourist,
    CASE WHEN EXISTS (SELECT 1 FROM RepresentativeOffice.MailOrderCustomer mc WHERE mc.CustomerID = c.CustomerID) THEN 1 ELSE 0 END AS IsRegular,
    c.FirstOrderDate
FROM RepresentativeOffice.Customer c
JOIN Sales.RepresentativeOffice ro ON c.CityID = ro.CityID;

-- Populate Fact_Inventory
INSERT INTO Fact_Inventory (StoreID, ProductID, DateID, QuantityInStock)
SELECT 
    i.StoreID,
    i.ProductID,
    (SELECT DateID FROM Dim_Date WHERE FullDate = DATE(i.TimeStamp)) AS DateID,
    i.QuantityInStock
FROM Sales.Inventory i
WHERE EXISTS (SELECT 1 FROM Dim_Date WHERE FullDate = DATE(i.TimeStamp));

-- Populate Fact_Order
INSERT INTO Fact_Order (OrderID, CustomerID, DateID, OrderDate, TotalAmount)
SELECT 
    o.OrderID,
    o.CustomerID,
    (SELECT DateID FROM Dim_Date WHERE FullDate = o.OrderDate) AS DateID,
    o.OrderDate,
    (SELECT SUM(od.QuantityOrdered * od.UnitPrice) 
     FROM Sales.OrderDetail od 
     WHERE od.OrderID = o.OrderID) AS TotalAmount
FROM Sales.`Order` o
WHERE EXISTS (SELECT 1 FROM Dim_Date WHERE FullDate = o.OrderDate);

-- Populate Fact_OrderDetail
INSERT INTO Fact_OrderDetail (OrderID, ProductID, QuantityOrdered, UnitPrice, OrderTime)
SELECT 
    od.OrderID,
    od.ProductID,
    od.QuantityOrdered,
    od.UnitPrice,
    od.TimeStamp
FROM Sales.OrderDetail od;

-- 5. OLAP Queries for Business Requirements

-- Query 1: All stores with product details
DROP VIEW IF EXISTS StoreProductView;
CREATE VIEW StoreProductView AS
SELECT 
    s.StoreID,
    s.CityName,
    s.State,
    s.Phone,
    p.Description,
    p.Size,
    p.Weight,
    p.Price
FROM Dim_Store s
JOIN Fact_Inventory i ON s.StoreID = i.StoreID
JOIN Dim_Product p ON i.ProductID = p.ProductID;

-- Query 2: All orders with customer names
DROP VIEW IF EXISTS OrderCustomerView;
CREATE VIEW OrderCustomerView AS
SELECT 
    o.OrderID,
    c.CustomerName,
    o.OrderDate
FROM Fact_Order o
JOIN Dim_Customer c ON o.CustomerID = c.CustomerID;

-- Query 3: Stores selling products ordered by customers
DROP VIEW IF EXISTS StoreOrderedProductView;
CREATE VIEW StoreOrderedProductView AS
SELECT DISTINCT
    s.StoreID,
    s.CityName,
    s.Phone
FROM Dim_Store s
JOIN Fact_Inventory i ON s.StoreID = i.StoreID
JOIN Fact_OrderDetail od ON i.ProductID = od.ProductID;

-- Query 4: Store offices with inventory above threshold
DROP PROCEDURE IF EXISTS GetStoresWithHighInventory;
DELIMITER //
CREATE PROCEDURE GetStoresWithHighInventory (IN Threshold INT)
BEGIN
    SELECT 
        s.OfficeAddress,
        s.CityName,
        s.State,
        i.ProductID,
        i.QuantityInStock
    FROM Dim_Store s
    JOIN Fact_Inventory i ON s.StoreID = i.StoreID
    WHERE i.QuantityInStock > Threshold;
END //
DELIMITER ;

-- Query 5: Order details with store information
DROP VIEW IF EXISTS OrderDetailsView;
CREATE VIEW OrderDetailsView AS
SELECT 
    o.OrderID,
    p.Description,
    s.StoreID,
    s.CityName
FROM Fact_Order o
JOIN Fact_OrderDetail od ON o.OrderID = od.OrderID
JOIN Dim_Product p ON od.ProductID = p.ProductID
JOIN Fact_Inventory i ON p.ProductID = i.ProductID
JOIN Dim_Store s ON i.StoreID = s.StoreID;

-- Query 6: Customer locations
DROP VIEW IF EXISTS CustomerLocationView;
CREATE VIEW CustomerLocationView AS
SELECT 
    CustomerName,
    CityName,
    State
FROM Dim_Customer;

-- Query 7: Inventory levels for specific product in specific city
DROP PROCEDURE IF EXISTS GetProductInventoryByCity;
DELIMITER //
CREATE PROCEDURE GetProductInventoryByCity (IN ProductID INT, IN CityName VARCHAR(100))
BEGIN
    SELECT 
        s.StoreID,
        s.CityName,
        i.QuantityInStock
    FROM Fact_Inventory i
    JOIN Dim_Store s ON i.StoreID = s.StoreID
    WHERE i.ProductID = ProductID 
    AND s.CityName = CityName;
END //
DELIMITER ;

-- Query 8: Order details with all information
DROP VIEW IF EXISTS FullOrderDetailsView;
CREATE VIEW FullOrderDetailsView AS
SELECT 
    o.OrderID,
    od.QuantityOrdered,
    c.CustomerName,
    s.StoreID,
    s.CityName,
    p.Description
FROM Fact_Order o
JOIN Fact_OrderDetail od ON o.OrderID = od.OrderID
JOIN Dim_Customer c ON o.CustomerID = c.CustomerID
JOIN Dim_Product p ON od.ProductID = p.ProductID
JOIN Fact_Inventory i ON p.ProductID = p.ProductID
JOIN Dim_Store s ON i.StoreID = s.StoreID;

-- Query 9: Customer type classification
DROP VIEW IF EXISTS CustomerTypeView;
CREATE VIEW CustomerTypeView AS
SELECT 
    CustomerName,
    CASE WHEN IsTourist = 1 THEN 'Tourist' ELSE '' END AS Tourist,
    CASE WHEN IsRegular = 1 THEN 'Regular' ELSE '' END AS Regular,
    CASE WHEN IsTourist = 1 AND IsRegular = 1 THEN 'Both' ELSE '' END AS `Both`
FROM Dim_Customer
WHERE IsTourist = 1 OR IsRegular = 1;

-- 6. Data Validation Views
DROP VIEW IF EXISTS InventoryValidation;
CREATE VIEW InventoryValidation AS
SELECT 
    StoreID,
    ProductID,
    QuantityInStock
FROM Fact_Inventory
WHERE QuantityInStock < 0;

DROP VIEW IF EXISTS OrderValidation;
CREATE VIEW OrderValidation AS
SELECT 
    o.OrderID,
    COUNT(od.OrderID) AS DetailCount
FROM Fact_Order o
LEFT JOIN Fact_OrderDetail od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING COUNT(od.OrderID) = 0;

-- 7. Verify ETL Results
SELECT 'Dim_Date' AS TableName, COUNT(*) AS RowCount FROM Dim_Date;
SELECT 'Dim_Store' AS TableName, COUNT(*) AS RowCount FROM Dim_Store;
SELECT 'Dim_Product' AS TableName, COUNT(*) AS RowCount FROM Dim_Product;
SELECT 'Dim_Customer' AS TableName, COUNT(*) AS RowCount FROM Dim_Customer;
SELECT 'Fact_Inventory' AS TableName, COUNT(*) AS RowCount FROM Fact_Inventory;
SELECT 'Fact_Order' AS TableName, COUNT(*) AS RowCount FROM Fact_Order;
SELECT 'Fact_OrderDetail' AS TableName, COUNT(*) AS RowCount FROM Fact_OrderDetail;
