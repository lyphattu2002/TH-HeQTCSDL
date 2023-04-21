-- Câu 1--

CREATE TRIGGER trg_Nhap_CheckConstraints
ON Nhap
AFTER INSERT
AS
BEGIN
    DECLARE @masp NVARCHAR(10)
    DECLARE @manv NVARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN
    FROM inserted
    
    -- Kiểm tra masp có trong bảng Sanpham chưa
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Lỗi: masp không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra manv có trong bảng Nhanvien chưa
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Lỗi: manv không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Lỗi: soluongN và dongiaN phải lớn hơn 0', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng sản phẩm trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong + @soluongN
    WHERE masp = @masp
END

-- Câu 2--

CREATE TRIGGER checkXuat
ON Xuat
AFTER INSERT
AS
BEGIN
    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = (SELECT masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = (SELECT manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Kiểm tra ràng buộc dữ liệu
    DECLARE @soluongX INT
    SELECT @soluongX = soluongX FROM inserted
    
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = (SELECT masp FROM inserted)
    
    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Cập nhật số lượng trong bảng Sanpham
    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = (SELECT masp FROM inserted)
END

-- Câu 3--

CREATE TRIGGER updateSoluongXoaPhieuXuat
ON Xuat
AFTER DELETE
AS
BEGIN
    -- Cập nhật số lượng hàng trong bảng Sanpham tương ứng với sản phẩm đã xuất
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong + deleted.soluongX
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END

-- Câu 4--

CREATE TRIGGER cap_nhat_so_luong_xuat
ON Xuat
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR ('Cannot update more than one record at a time', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    
    DECLARE @soluongX INT, @soluong INT;
    SELECT @soluongX = i.soluongX, @soluong = s.soluong
    FROM inserted i
    JOIN Sanpham s ON i.masp = s.masp;

    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR ('Cannot update quantity, quantity in Xuat table is greater than quantity in Sanpham table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    
    UPDATE Sanpham SET soluong = soluong - @soluongX WHERE masp IN (SELECT masp FROM inserted);
    UPDATE Xuat SET soluongX = @soluongX WHERE sohdx IN (SELECT sohdx FROM inserted);
END;

--Câu 5--

CREATE TRIGGER cap_nhat_so_luong_nhap
ON Nhap
AFTER UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        PRINT 'Khong the cap nhat so luong nhap vi co nhieu hon mot ban ghi duoc cap nhat'
        ROLLBACK
    END
    ELSE
    BEGIN
        UPDATE Sanpham
        SET soluong = soluong + (SELECT soluongN FROM inserted) - (SELECT soluongN FROM deleted)
        WHERE masp = (SELECT masp FROM inserted)
    END
END


--Câu 6--

CREATE TRIGGER trigger_xoa_phieu_nhap
ON Nhap
AFTER DELETE
AS
BEGIN
    DECLARE @maSP nchar(10), @soLuong INT;

    -- Lấy thông tin sản phẩm và số lượng trước khi xóa phiếu nhập
    SELECT @maSP = d.masp, @soLuong = d.soluongN 
    FROM deleted d 
    INNER JOIN Sanpham s ON d.masp = s.masp;

    -- Cập nhật lại số lượng trong bảng Sanpham
    UPDATE Sanpham SET soluong = soluong - @soLuong WHERE masp = @maSP;
END;
