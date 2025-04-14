-- Database Creation for Representative Office
CREATE DATABASE RepresentativeOffice;
GO

USE RepresentativeOffice;
GO

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CityID INT NOT NULL,
    FirstOrderDate DATE
);

-- Tourist Customer Table
CREATE TABLE TouristCustomer (
    CustomerID INT,
    TourGuide VARCHAR(100),
    TimeStamp DATETIME,
    PRIMARY KEY (CustomerID, TimeStamp),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Mail Order Customer Table
CREATE TABLE MailOrderCustomer (
    CustomerID INT,
    PostalAddress VARCHAR(200),
    TimeStamp DATETIME,
    PRIMARY KEY (CustomerID, TimeStamp),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
