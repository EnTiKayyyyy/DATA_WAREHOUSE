-- Tạo bảng Dim_Customer
CREATE TABLE Dim_Customer (
    Customer_id INT PRIMARY KEY,
    Customer_name VARCHAR(100),
    Tour VARCHAR(100),
    Port VARCHAR(100),
    City_id INT
);

-- Tạo bảng Dim_Date
CREATE TABLE Dim_Date (
    Date_id INT PRIMARY KEY,
    Date DATE,
    Month INT,
    Quarter INT,
    Year INT
);

-- Tạo bảng Dim_City
CREATE TABLE Dim_City (
    City_id INT PRIMARY KEY,
    City_name VARCHAR(100),
    Office_address VARCHAR(255),
    State VARCHAR(50)
);

-- Tạo bảng Dim_Store
CREATE TABLE Dim_Store (
    Store_id INT PRIMARY KEY,
    Phone_number VARCHAR(15),
    City_id INT,
    FOREIGN KEY (City_id) REFERENCES Dim_City(City_id)
);

-- Tạo bảng Dim_Product
CREATE TABLE Dim_Product (
    Product_id INT PRIMARY KEY,
    Description TEXT,
    Size VARCHAR(50),
    Weight DECIMAL(10, 2),
    Price DECIMAL(10, 2)
);

-- Tạo bảng Fact_Order
CREATE TABLE Fact_Order (
    Date_id INT,
    Customer_id INT,
    Product_id INT,
    Quantity_ordered INT,
    Amount DECIMAL(12, 2),
    PRIMARY KEY (Date_id, Customer_id, Product_id),
    FOREIGN KEY (Date_id) REFERENCES Dim_Date(Date_id),
    FOREIGN KEY (Customer_id) REFERENCES Dim_Customer(Customer_id),
    FOREIGN KEY (Product_id) REFERENCES Dim_Product(Product_id)
);

-- Tạo bảng Fact_Inventory
CREATE TABLE Fact_Inventory (
    Date_id INT,
    Store_id INT,
    Product_id INT,
    Quantity INT,
    PRIMARY KEY (Date_id, Store_id, Product_id),
    FOREIGN KEY (Date_id) REFERENCES Dim_Date(Date_id),
    FOREIGN KEY (Store_id) REFERENCES Dim_Store(Store_id),
    FOREIGN KEY (Product_id) REFERENCES Dim_Product(Product_id)
);
