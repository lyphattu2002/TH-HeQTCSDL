--Câu 1--

CREATE PROCEDURE InsertHangsx
    @mahangsx VARCHAR(10),
    @tenhang NVARCHAR(50),
    @diachi NVARCHAR(50),
    @sodt VARCHAR(20),
    @email VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        RAISERROR('Tên hãng sản xuất đã tồn tại trong CSDL', 16, 1)
        RETURN
    END

    INSERT INTO Hangsx (mahangsx, tenhang, diachi, sodt, email)
    VALUES (@mahangsx, @tenhang, @diachi, @sodt, @email)
END

EXEC InsertHangsx 'H01', 'Samsung', 'Korea', '011-08271717', 'ss@gmail.com.kr'

--Câu 2--

CREATE PROCEDURE ThemSanpham
    @masp VARCHAR(10),
    @mahangsx VARCHAR(10),
    @tensp NVARCHAR(50),
    @soluong INT,
    @mausac NVARCHAR(20),
    @giaban INT,
    @donvitinh NVARCHAR(20),
    @mota NVARCHAR(200)
AS
BEGIN
    IF EXISTS (SELECT * FROM sanpham WHERE masp = @masp)
    BEGIN
        UPDATE sanpham 
        SET mahangsx = @mahangsx, tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota 
        WHERE masp = @masp
        PRINT 'Đã cập nhật thông tin sản phẩm có mã ' + @masp
    END
    ELSE
    BEGIN
        INSERT INTO sanpham (masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
        PRINT 'Đã thêm sản phẩm có mã ' + @masp
    END
END

EXEC ThemSanpham 'SP01', 'H02', 'F1 Plus', 100, 'Xám', 7000000, 'Chiếc', 'Hàng cận cảo cấp';

--Câu 3--

CREATE PROCEDURE XoaHangsx 
    @tenhang nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        -- Xóa các sản phẩm có liên quan đến hãng sx bị xóa
        DELETE FROM Sanpham WHERE masp = @tenhang
        
        -- Xóa hãng sx
        DELETE FROM Hangsx WHERE tenhang = @tenhang
        
        PRINT 'Đã xóa hãng sản xuất ' + @tenhang
    END
    ELSE
    BEGIN
        PRINT 'Không tìm thấy hãng sản xuất ' + @tenhang + '. Không thực hiện được xóa!'
    END
END

EXEC XoaHangsx 'ABC'

--Câu 4--

CREATE PROCEDURE sp_NhapNhanVien
    @manv VARCHAR(10),
    @tennv NVARCHAR(50),
    @gioitinh NVARCHAR(3),
    @diachi NVARCHAR(100),
    @sodt VARCHAR(20),
    @email NVARCHAR(50),
    @phong NVARCHAR(50),
    @flag BIT
AS
BEGIN
    IF @flag = 0
    BEGIN
        UPDATE Nhanvien
        SET tennv = @tennv,
            gioitinh = @gioitinh,
            diachi = @diachi,
            sodt = @sodt,
            email = @email,
            phong = @phong
        WHERE manv = @manv;
    END
    ELSE
    BEGIN
        IF EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
        BEGIN
            RAISERROR('Mã nhân viên đã tồn tại!', 16, 1);
            RETURN;
        END
        INSERT INTO Nhanvien (manv, tennv, gioitinh, diachi, sodt, email, phong)
        VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong);
    END
END

EXEC sp_NhapNhanVien 'NV001', 'Nguyen Van A', 'Nam', '123 ABC', '0987654321', 'nv.a@gmail.com', 'Kinh doanh', 1

--Câu 5--

CREATE PROCEDURE ThemNhap (@sohd INT, @masp CHAR(5), @manv CHAR(5), @ngaynhap DATE, @soluongN INT, @donggiaN MONEY)
AS
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng Sanpham'
        RETURN
    END
    
    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không?
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng Nhanvien'
        RETURN
    END
    
    -- Kiểm tra xem sohd đã tồn tại trong bảng Nhap hay chưa?
    IF EXISTS (SELECT * FROM Nhap WHERE sohdn = @sohd)
    BEGIN
        -- Cập nhật bảng Nhap theo sohdn
        UPDATE Nhap
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @donggiaN
        WHERE sohdn = @sohd
        PRINT 'Đã cập nhật dữ liệu bảng Nhap thành công'
    END
    ELSE
    BEGIN
        -- Thêm mới bằng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohd, @masp, @manv, @ngaynhap, @soluongN, @donggiaN)
        PRINT 'Đã thêm mới dữ liệu bảng Nhap thành công'
    END
END

EXEC ThemNhap 1, 1, 1, '2022-03-05', 10, 10000
EXEC ThemNhap 123, 'SP001', 'NV001', '2022-04-07', 10, 1500000.0

--Câu 6--

CREATE PROCEDURE ThemXuat
    @sohdX varchar(10),
    @masp varchar(10),
    @manv varchar(10),
    @ngayxuat date,
    @soluongX int
AS
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng sanpham hay không
    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại!'
        RETURN
    END
    
    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại!'
        RETURN
    END
    
    -- Kiểm tra soluongX có lớn hơn số lượng tồn kho hay không
    IF @soluongX > (SELECT soluong FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Số lượng xuất lớn hơn số lượng tồn kho!'
        RETURN
    END
    
    -- Kiểm tra sohdX đã tồn tại trong bảng Xuat hay chưa
    IF EXISTS (SELECT sohdX FROM Xuat WHERE sohdX = @sohdX)
    BEGIN
        UPDATE Xuat
        SET masp = @masp,
            manv = @manv,
            ngayxuat = @ngayxuat,
            soluongX = @soluongX
        WHERE sohdX = @sohdX
        PRINT 'Cập nhật thành công!'
    END
    ELSE
    BEGIN
        INSERT INTO Xuat(sohdX, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdX, @masp, @manv, @ngayxuat, @soluongX)
        PRINT 'Thêm mới thành công!'
    END
END

EXEC ThemXuat 'X001', 'SP001', 'NV001', '2023-04-07', 50

--Câu 7--

CREATE PROCEDURE XoaNhanvien
    @manv varchar(10)
AS
BEGIN
    -- Kiểm tra xem mã nhân viên đã tồn tại trong bảng Nhanvien hay chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng Nhanvien'
        RETURN
    END
    
    BEGIN TRANSACTION
    
    -- Xóa bảng Nhap
    DELETE FROM Nhap WHERE manv = @manv
    
    -- Xóa bảng Xuat
    DELETE FROM Xuat WHERE manv = @manv
    
    -- Xóa bảng Nhanvien
    DELETE FROM Nhanvien WHERE manv = @manv
    
    -- Commit transaction
    COMMIT TRANSACTION
    
    PRINT 'Xóa nhân viên thành công'
END

EXEC XoaNhanvien @manv = 'NV001'

--Câu 8--

CREATE PROCEDURE XoaSanpham
    @masp INT
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại hay không
    IF NOT EXISTS(SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại'
        RETURN
    END
    
    -- Xóa dòng dữ liệu liên quan trong bảng Nhap
    DELETE FROM Nhap WHERE masp = @masp
    
    -- Xóa dòng dữ liệu liên quan trong bảng Xuat
    DELETE FROM Xuat WHERE masp = @masp
    
    -- Xóa sản phẩm trong bảng Sanpham
    DELETE FROM Sanpham WHERE masp = @masp
    
    PRINT 'Xóa sản phẩm thành công'
END

EXEC XoaSanpham @masp = 1

