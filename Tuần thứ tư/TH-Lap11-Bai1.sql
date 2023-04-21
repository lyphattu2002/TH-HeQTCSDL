--Tạo bảng--

--Bài 1--

CREATE TABLE Khoa (
Makhoa nchar(10) PRIMARY KEY,
Tenkhoa nvarchar(50) NOT NULL,
Dienthoai nvarchar(20)
);

CREATE TABLE Lop (
Malop nchar(10) PRIMARY KEY,
Tenlop nvarchar(50) NOT NULL,
Khoa nchar(10) NOT NULL,
Hedt nvarchar(20) NOT NULL,
Namnhaphoc int NOT NULL,

FOREIGN KEY (Khoa) REFERENCES Khoa(Makhoa)
);

ALTER TABLE Lop
ADD Makhoa INT;

--Câu 1--

CREATE PROCEDURE sp_InsertKhoa
    @makhoa NVARCHAR(10),
    @tenkhoa NVARCHAR(50),
    @dienthoai NVARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KHOA WHERE Tenkhoa = @tenkhoa)
    BEGIN
        PRINT 'Tên khoa đã tồn tại.'
    END
    ELSE
    BEGIN
        INSERT INTO KHOA (Makhoa, Tenkhoa, Dienthoai)
        VALUES (@makhoa, @tenkhoa, @dienthoai)
        PRINT 'Thêm khoa thành công.'
    END
END

EXEC sp_InsertKhoa 'CNTT', 'Khoa Công nghệ thông tin', '0901234567'

EXEC sp_InsertKhoa 'KT', 'Khoa Kỹ thuật', '0909876543'

--Câu 2--

CREATE PROCEDURE ThemLop 
    @Malop CHAR(10), 
    @Tenlop NVARCHAR(50),
    @Khoa NVARCHAR(50),
    @Hedt NVARCHAR(50),
    @Namnhaphoc INT,
    @Makhoa CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra tên lớp đã tồn tại hay chưa
    IF EXISTS(SELECT 1 FROM Lop WHERE Tenlop = @Tenlop)
    BEGIN
        RAISERROR('Tên lớp đã tồn tại!', 16, 1);
        RETURN;
    END

    -- Kiểm tra xem makhoa đã tồn tại trong bảng Khoa hay không
    IF NOT EXISTS(SELECT 1 FROM Khoa WHERE Makhoa = @Makhoa)
    BEGIN
        RAISERROR('Mã khoa không tồn tại!', 16, 1);
        RETURN;
    END
    
    -- Thêm dữ liệu vào bảng Lop
    INSERT INTO Lop (Malop, Tenlop, Khoa, Hedt, Namnhaphoc ) 
    VALUES (@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa);
    
    PRINT 'Thêm lớp thành công!'
END

EXEC ThemLop 'L01', 'Lớp 01', 'Khoa CNTT', 'Đại học', 2022, 'K01';

--Câu 3--

CREATE PROCEDURE sp_InsertKhoa_CheckExists
    @MaKhoa VARCHAR(10),
    @TenKhoa NVARCHAR(100),
    @DienThoai VARCHAR(20),
    @Exists BIT OUTPUT
AS
BEGIN
    IF EXISTS (SELECT * FROM KHOA WHERE TenKhoa = @TenKhoa)
    BEGIN
        SET @Exists = 0
        RETURN
    END
    
    INSERT INTO KHOA(MaKhoa, TenKhoa, DienThoai)
    VALUES (@MaKhoa, @TenKhoa, @DienThoai)
    
    SET @Exists = 1
END
DECLARE @Exists BIT
EXEC sp_InsertKhoa_CheckExists 'K01', N'Khoa A', '0123456789', @Exists OUTPUT
IF @Exists = 1
BEGIN
    PRINT 'Thêm khoa thành công!'
END
ELSE
BEGIN
    PRINT N'Tên khoa đã tồn tại !'
END

--Câu 4--

CREATE PROCEDURE sp_InsertLop
    @MaLop VARCHAR(10),
    @TenLop NVARCHAR(50),
    @Khoa NVARCHAR(10),
    @HeDT NVARCHAR(50),
    @NamNhapHoc INT,
    @MaKhoa VARCHAR(10)
AS
BEGIN
    -- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0
    IF EXISTS (SELECT 1 FROM Lop WHERE Tenlop = @TenLop)
    BEGIN
        RETURN 0
    END

    -- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì trả về 1
    IF NOT EXISTS (SELECT 1 FROM Khoa WHERE Makhoa = @MaKhoa)
    BEGIN
        RETURN 1
    END

    -- Nếu đầy đủ thông tin thì cho nhập và trả về 2
    INSERT INTO Lop(Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
    VALUES(@MaLop, @TenLop, @Khoa, @HeDT, @NamNhapHoc, @MaKhoa)
    
    RETURN 2
END
DECLARE @Result INT

EXEC @Result = sp_InsertLop 'L09', N'Lớp 9', 'K09', N'DH', 2021, 'K09'

IF @Result = 0
BEGIN
    PRINT N'Tên lớp đã có trước đó'
END
ELSE IF @Result = 1
BEGIN
    PRINT N'Mã khoa không tồn tại'
END
ELSE IF @Result = 2
BEGIN
    PRINT N'Nhập dữ liệu thành công'
END