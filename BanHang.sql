-- Database Creation for Sales
CREATE DATABASE Sales;

USE Sales;

-- Representative Office Table
CREATE TABLE RepresentativeOffice (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL,
    OfficeAddress VARCHAR(200),
    State VARCHAR(100),
    TimeStamp DATETIME
);

-- Store Table
CREATE TABLE Store (
    StoreID INT PRIMARY KEY,
    CityID INT,
    Phone VARCHAR(20),
    TimeStamp DATETIME,
    FOREIGN KEY (CityID) REFERENCES RepresentativeOffice(CityID)
);

-- Product Table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    Description VARCHAR(200),
    Size VARCHAR(50),
    Weight DECIMAL(10,2),
    Price DECIMAL(10,2),
    TimeStamp DATETIME
);

-- Inventory Table
CREATE TABLE Inventory (
    StoreID INT,
    ProductID INT,
    QuantityInStock INT NOT NULL,
    TimeStamp DATETIME,
    PRIMARY KEY (StoreID, ProductID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Order Table
CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES RepresentativeOffice.Customer(CustomerID)
);

-- Order Detail Table
CREATE TABLE OrderDetail (
    OrderID INT,
    ProductID INT,
    QuantityOrdered INT NOT NULL,
    UnitPrice DECIMAL(10,2),
    TimeStamp DATETIME,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
