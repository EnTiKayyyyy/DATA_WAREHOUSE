-- Tạo CSDL VanPhongDaiDien
CREATE DATABASE VanPhongDaiDien;
GO

USE VanPhongDaiDien;
GO

-- Bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH              INT           NOT NULL,
    TenKH             NVARCHAR(100) NOT NULL,
    MaThanhPho        INT           NOT NULL,
    NgayDatHangDauTien DATE         NULL,
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH)
);

-- Bảng Khách hàng du lịch
CREATE TABLE KhachHangDuLich (
    MaKH              INT           NOT NULL,
    HuongDanVien      NVARCHAR(100) NOT NULL,
    ThoiGian          DATETIME      NULL,
    CONSTRAINT PK_KhachHangDuLich PRIMARY KEY (MaKH),
    CONSTRAINT FK_KhachHangDuLich_MaKH 
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng Khách hàng bưu điện
CREATE TABLE KhachHangBuuDien (
    MaKH              INT           NOT NULL,
    DiaChiBuuDien     NVARCHAR(200) NOT NULL,
    ThoiGian          DATETIME      NULL,
    CONSTRAINT PK_KhachHangBuuDien PRIMARY KEY (MaKH),
    CONSTRAINT FK_KhachHangBuuDien_MaKH 
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

