CREATE DATABASE BanHang;
GO

USE BanHang;
GO

-- Bảng Văn phòng đại diện
CREATE TABLE VanPhongDaiDien (
    MaThanhPho    INT           NOT NULL,
    TenThanhPho   NVARCHAR(100) NOT NULL,
    DiaChiVP      NVARCHAR(200) NULL,
    ThoiGian      DATETIME      NULL,
    CONSTRAINT PK_VanPhongDaiDien PRIMARY KEY (MaThanhPho)
);

-- Bảng Cửa hàng
CREATE TABLE CuaHang (
    MaCuaHang     INT           NOT NULL,
    MaThanhPho    INT           NOT NULL,
    SoDienThoai   VARCHAR(20)   NULL,
    ThoiGian      DATETIME      NULL,
    CONSTRAINT PK_CuaHang PRIMARY KEY (MaCuaHang),
    CONSTRAINT FK_CuaHang_MaThanhPho 
        FOREIGN KEY (MaThanhPho) REFERENCES VanPhongDaiDien(MaThanhPho)
);


-- Bảng Mặt hàng
CREATE TABLE MatHang (
    MaMH          INT            NOT NULL,
    MoTa          NVARCHAR(200)  NOT NULL,
    KichCo        NVARCHAR(50)   NULL,
    TrongLuong    DECIMAL(10,2)  NULL,
    Gia           DECIMAL(12,2)  NULL,
    ThoiGian      DATETIME       NULL,
    CONSTRAINT PK_MatHang PRIMARY KEY (MaMH)
);

-- Bảng Mặt hàng được lưu trữ (kho)
CREATE TABLE MatHangDuocLuuTru (
    MaCuaHang     INT           NOT NULL,
    MaMH          INT           NOT NULL,
    SoLuong       INT           NOT NULL,
    ThoiGian      DATETIME      NULL,
    CONSTRAINT PK_MatHangDuocLuuTru PRIMARY KEY (MaCuaHang, MaMH),
    CONSTRAINT FK_MatHangDuocLuuTru_MaCuaHang
        FOREIGN KEY (MaCuaHang) REFERENCES CuaHang(MaCuaHang),
    CONSTRAINT FK_MatHangDuocLuuTru_MaMH
        FOREIGN KEY (MaMH) REFERENCES MatHang(MaMH)
);

-- Bảng Đơn đặt hàng
CREATE TABLE DonDatHang (
    MaDon         INT           NOT NULL,
    NgayDatHang   DATETIME      NOT NULL,
    MaKH          INT           NOT NULL,  -- Khách hàng thuộc DB VanPhongDaiDien
    CONSTRAINT PK_DonDatHang PRIMARY KEY (MaDon)
    -- Có thể khai báo thêm khóa ngoại liên DB (tùy vào công cụ hỗ trợ), hoặc để tham chiếu logic
);

-- Bảng Mặt hàng được đặt (chi tiết đơn hàng)
CREATE TABLE MatHangDuocDat (
    MaDon         INT           NOT NULL,
    MaMH          INT           NOT NULL,
    SoLuongDat    INT           NOT NULL,
    GiaDat        DECIMAL(12,2) NOT NULL,  -- Giá bán tại thời điểm đặt
    ThoiGian      DATETIME      NULL,
    CONSTRAINT PK_MatHangDuocDat PRIMARY KEY (MaDon, MaMH),
    CONSTRAINT FK_MatHangDuocDat_MaDon
        FOREIGN KEY (MaDon) REFERENCES DonDatHang(MaDon),
    CONSTRAINT FK_MatHangDuocDat_MaMH
        FOREIGN KEY (MaMH) REFERENCES MatHang(MaMH)
);
