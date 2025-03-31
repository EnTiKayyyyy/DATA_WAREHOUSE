-- Tạo Data Warehouse (DW)
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Tạo bảng DimDate
CREATE TABLE DimDate (
    DateKey       INT          NOT NULL,  -- Surrogate key
    FullDate      DATE         NOT NULL,
    Year          INT          NOT NULL,
    Quarter       TINYINT      NOT NULL,
    Month         TINYINT      NOT NULL,
    Day           TINYINT      NOT NULL,
    CONSTRAINT PK_DimDate PRIMARY KEY (DateKey)
);

-- Tạo bảng DimCustomer
CREATE TABLE DimCustomer (
    CustomerKey   INT          IDENTITY(1,1) NOT NULL,
    MaKH          INT          NULL,         -- Mã KH gốc
    TenKH         NVARCHAR(100) NULL,
    LoaiKhach     NVARCHAR(50)  NULL,        -- du lịch, bưu điện, hoặc cả hai
    HuongDanVien  NVARCHAR(100) NULL,
    DiaChiBuuDien NVARCHAR(200) NULL,
    MaThanhPho    INT          NULL,
    -- ... các thuộc tính khác
    CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerKey)
);

-- Tạo bảng DimCity
CREATE TABLE DimCity (
    CityKey       INT          IDENTITY(1,1) NOT NULL,
    MaThanhPho    INT          NOT NULL,
    DiaChiVP      NVARCHAR(200) NULL,
    CONSTRAINT PK_DimCity PRIMARY KEY (CityKey)
);

-- Tạo bảng DimStore
CREATE TABLE DimStore (
    StoreKey      INT         IDENTITY(1,1) NOT NULL,
    MaCuaHang     INT         NOT NULL,
    SoDienThoai   VARCHAR(20) NULL,
    CityKey       INT         NOT NULL,    -- Liên kết DimCity
    CONSTRAINT PK_DimStore PRIMARY KEY (StoreKey),
    CONSTRAINT FK_Store_CityKey
        FOREIGN KEY (CityKey) REFERENCES DimCity(CityKey)
);

-- Tạo bảng DimProduct
CREATE TABLE DimProduct (
    ProductKey    INT         IDENTITY(1,1) NOT NULL,
    MaMH          INT         NOT NULL,    -- Mã MH gốc
    MoTa          NVARCHAR(200) NOT NULL,
    KichCo        NVARCHAR(50) NULL,
    TrongLuong    DECIMAL(10,2) NULL,
    Gia           DECIMAL(12,2) NULL,
    CONSTRAINT PK_DimProduct PRIMARY KEY (ProductKey)
);

-- Tạo FactOrders (Chi tiết đơn hàng)
CREATE TABLE FactOrders (
    FactOrderKey  INT         IDENTITY(1,1) NOT NULL,
    DateKey       INT         NOT NULL,
    CustomerKey   INT         NOT NULL,
    ProductKey    INT         NOT NULL,
    StoreKey      INT         NOT NULL,
    -- Thông tin số lượng, giá
    SoLuongDat    INT         NOT NULL,
    GiaDat        DECIMAL(12,2) NOT NULL,
    -- Tùy chọn: cột tính sẵn, vd: ThanhTien = SoLuongDat * GiaDat
    CONSTRAINT PK_FactOrders PRIMARY KEY (FactOrderKey),
    CONSTRAINT FK_FactOrders_DateKey FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactOrders_CustomerKey FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    CONSTRAINT FK_FactOrders_ProductKey FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),
    CONSTRAINT FK_FactOrders_StoreKey FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey)
);

-- Tạo FactInventory (Tồn kho)
CREATE TABLE FactInventory (
    FactInventoryKey INT       IDENTITY(1,1) NOT NULL,
    DateKey       INT         NOT NULL,
    StoreKey      INT         NOT NULL,
    ProductKey    INT         NOT NULL,
    SoLuongTon    INT         NOT NULL,
    CONSTRAINT PK_FactInventory PRIMARY KEY (FactInventoryKey),
    CONSTRAINT FK_FactInventory_DateKey FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    CONSTRAINT FK_FactInventory_StoreKey FOREIGN KEY (StoreKey) REFERENCES DimStore(StoreKey),
    CONSTRAINT FK_FactInventory_ProductKey FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey)
);
GO
