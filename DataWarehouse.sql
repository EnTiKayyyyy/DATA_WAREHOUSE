-- 1. Create Data Warehouse Database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

-- 2. Create Dimension Tables

CREATE TABLE Dim_Store (
    StoreID INT PRIMARY KEY,
    CityID INT,
    CityName VARCHAR(100),
    State VARCHAR(100),
    Phone VARCHAR(20),
    OfficeAddress VARCHAR(200)
);

CREATE TABLE Dim_Product (
    ProductID INT PRIMARY KEY,
    Description VARCHAR(200),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Price DECIMAL(10,2)
);

CREATE TABLE Dim_Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    CityName VARCHAR(100),
    State VARCHAR(100),
    IsTourist BIT,
    IsRegular BIT,
    FirstOrderDate DATE
);

CREATE TABLE Dim_Date (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    DayOfWeek VARCHAR(10)
);

-- 3. Create Fact Tables

CREATE TABLE Fact_Inventory (
    StoreID INT,
    ProductID INT,
    DateID INT,
    QuantityInStock INT,
    PRIMARY KEY (StoreID, ProductID, DateID),
    FOREIGN KEY (StoreID) REFERENCES Dim_Store(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_Order (
    OrderID INT,
    CustomerID INT,
    DateID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Dim_Customer(CustomerID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

CREATE TABLE Fact_OrderDetail (
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

-- Populate Dim_Date (Sample for one year)
INSERT INTO Dim_Date (DateID, FullDate, Day, Month, Year, Quarter, DayOfWeek)
SELECT 
    ROW_NUMBER() OVER (ORDER BY a.number) AS DateID,
    DATEADD(day, a.number, '2024-01-01') AS FullDate,
    DAY(DATEADD(day, a.number, '2024-01-01')) AS Day,
    MONTH(DATEADD(day, a.number, '2024-01-01')) AS Month,
    YEAR(DATEADD(day, a.number, '2024-01-01')) AS Year,
    DATEPART(quarter, DATEADD(day, a.number, '2024-01-01')) AS Quarter,
    DATENAME(weekday, DATEADD(day, a.number, '2024-01-01')) AS DayOfWeek
FROM master..spt_values a
WHERE a.number < 365;

-- Populate Dim_Store
INSERT INTO Dim_Store (StoreID, CityID, CityName, State, Phone, OfficeAddress)
SELECT 
    s.StoreID,
    s.CityID,
    ro.CityName,
    ro.State,
    s.Phone,
    ro.OfficeAddress
FROM Sales.dbo.Store s
JOIN Sales.dbo.RepresentativeOffice ro ON s.CityID = ro.CityID;

-- Populate Dim_Product
INSERT INTO Dim_Product (ProductID, Description, Size, Weight, Price)
SELECT 
    ProductID,
    Description,
    Size,
    Weight,
    Price
FROM Sales.dbo.Product;

-- Populate Dim_Customer
INSERT INTO Dim_Customer (CustomerID, CustomerName, CityName, State, IsTourist, IsRegular, FirstOrderDate)
SELECT 
    c.CustomerID,
    c.CustomerName,
    ro.CityName,
    ro.State,
    CASE WHEN EXISTS (SELECT 1 FROM RepresentativeOffice.dbo.TouristCustomer tc WHERE tc.CustomerID = c.CustomerID) THEN 1 ELSE 0 END AS IsTourist,
    CASE WHEN EXISTS (SELECT 1 FROM RepresentativeOffice.dbo.MailOrderCustomer mc WHERE mc.CustomerID = c.CustomerID) THEN 1 ELSE 0 END AS IsRegular,
    c.FirstOrderDate
FROM RepresentativeOffice.dbo.Customer c
JOIN Sales.dbo.RepresentativeOffice ro ON c.CityID = ro.CityID;

-- Populate Fact_Inventory
INSERT INTO Fact_Inventory (StoreID, ProductID, DateID, QuantityInStock)
SELECT 
    i.StoreID,
    i.ProductID,
    (SELECT DateID FROM Dim_Date WHERE FullDate = CAST(i.TimeStamp AS DATE)) AS DateID,
    i.QuantityInStock
FROM Sales.dbo.Inventory i
WHERE EXISTS (SELECT 1 FROM Dim_Date WHERE FullDate = CAST(i.TimeStamp AS DATE));

-- Populate Fact_Order
INSERT INTO Fact_Order (OrderID, CustomerID, DateID, OrderDate, TotalAmount)
SELECT 
    o.OrderID,
    o.CustomerID,
    (SELECT DateID FROM Dim_Date WHERE FullDate = o.OrderDate) AS DateID,
    o.OrderDate,
    (SELECT SUM(od.QuantityOrdered * od.UnitPrice) 
     FROM Sales.dbo.OrderDetail od 
     WHERE od.OrderID = o.OrderID) AS TotalAmount
FROM Sales.dbo.`Order` o
WHERE EXISTS (SELECT 1 FROM Dim_Date WHERE FullDate = o.OrderDate);

-- Populate Fact_OrderDetail
INSERT INTO Fact_OrderDetail (OrderID, ProductID, QuantityOrdered, UnitPrice, OrderTime)
SELECT 
    od.OrderID,
    od.ProductID,
    od.QuantityOrdered,
    od.UnitPrice,
    od.TimeStamp
FROM Sales.dbo.OrderDetail od;

-- 5. OLAP Queries for Business Requirements

-- Query 1: All stores with product details
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
CREATE VIEW OrderCustomerView AS
SELECT 
    o.OrderID,
    c.CustomerName,
    o.OrderDate
FROM Fact_Order o
JOIN Dim_Customer c ON o.CustomerID = c.CustomerID;

-- Query 3: Stores selling products ordered by customers
CREATE VIEW StoreOrderedProductView AS
SELECT DISTINCT
    s.StoreID,
    s.CityName,
    s.Phone
FROM Dim_Store s
JOIN Fact_Inventory i ON s.StoreID = i.StoreID
JOIN Fact_OrderDetail od ON i.ProductID = od.ProductID;

-- Query 4: Store offices with inventory above threshold
CREATE PROCEDURE GetStoresWithHighInventory
    @Threshold INT
AS
BEGIN
    SELECT 
        s.OfficeAddress,
        s.CityName,
        s.State,
        i.ProductID,
        i.QuantityInStock
    FROM Dim_Store s
    JOIN Fact_Inventory i ON s.StoreID = i.StoreID
    WHERE i.QuantityInStock > @Threshold;
END;
GO

-- Query 5: Order details with store information
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
CREATE VIEW CustomerLocationView AS
SELECT 
    CustomerName,
    CityName,
    State
FROM Dim_Customer;

-- Query 7: Inventory levels for specific product in specific city
CREATE PROCEDURE GetProductInventoryByCity
    @ProductID INT,
    @CityName VARCHAR(100)
AS
BEGIN
    SELECT 
        s.StoreID,
        s.CityName,
        i.QuantityInStock
    FROM Fact_Inventory i
    JOIN Dim_Store s ON i.StoreID = s.StoreID
    WHERE i.ProductID = @ProductID 
    AND s.CityName = @CityName;
END;
GO

-- Query 8: Order details with all information
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
JOIN Fact_Inventory i ON p.ProductID = i.ProductID
JOIN Dim_Store s ON i.StoreID = s.StoreID;

-- Query 9: Customer type classification
CREATE VIEW CustomerTypeView AS
SELECT 
    CustomerName,
    CASE WHEN IsTourist = 1 THEN 'Tourist' ELSE '' END AS Tourist,
    CASE WHEN IsRegular = 1 THEN 'Regular' ELSE '' END AS Regular,
    CASE WHEN IsTourist = 1 AND IsRegular = 1 THEN 'Both' ELSE '' END AS Both
FROM Dim_Customer
WHERE IsTourist = 1 OR IsRegular = 1;

-- 6. Data Validation Views
CREATE VIEW InventoryValidation AS
SELECT 
    StoreID,
    ProductID,
    QuantityInStock
FROM Fact_Inventory
WHERE QuantityInStock < 0;

CREATE VIEW OrderValidation AS
SELECT 
    o.OrderID,
    COUNT(od.OrderID) as DetailCount
FROM Fact_Order o
LEFT JOIN Fact_OrderDetail od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING COUNT(od.OrderID) = 0;
