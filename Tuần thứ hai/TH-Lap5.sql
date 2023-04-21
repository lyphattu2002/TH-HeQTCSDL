--Thực hành số 5--
--Câu1--

CREATE FUNCTION LayTenHangSX (@masp CHAR(10))
RETURNS VARCHAR(50)
AS
BEGIN
  DECLARE @tenhangsx VARCHAR(50)
  SELECT @tenhangsx = Hangsx.tenhang
  FROM Hangsx
  INNER JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
  WHERE Sanpham.masp = @masp

  RETURN @tenhangsx
END

--Câu2--

CREATE FUNCTION f_TongGiaTriNhap(@namx INT, @namy INT)
RETURNS INT
AS
BEGIN
    DECLARE @tongGiaTriNhap INT;
    SELECT @tongGiaTriNhap = SUM(soluongN * dongiaN)
    FROM Nhap
    WHERE YEAR(ngaynhap) >= @namx AND YEAR(ngaynhap) <= @namy;
    RETURN @tongGiaTriNhap;
END

--Câu3--

CREATE FUNCTION f_TongSoLuongThayDoi (@tenSP NVARCHAR(50), @namNhapXuat INT)
RETURNS INT
AS
BEGIN
    DECLARE @soLuongNhap INT
    DECLARE @soLuongXuat INT
    DECLARE @tongSoLuong INT
    
    SELECT @soLuongNhap = SUM(soluongN)
    FROM Nhap
    WHERE masp = (SELECT masp FROM Sanpham WHERE tensp = @tenSP)
        AND YEAR(ngaynhap) = @namNhapXuat
    
    SELECT @soLuongXuat = SUM(soluongX)
    FROM Xuat
    WHERE masp = (SELECT masp FROM Sanpham WHERE tensp = @tenSP)
        AND YEAR(ngayxuat) = @namNhapXuat
        
    SET @tongSoLuong = COALESCE(@soLuongNhap, 0) - COALESCE(@soLuongXuat, 0)
    
    RETURN @tongSoLuong
END

--Câu4--

CREATE FUNCTION f_TongGiaTriNhapn(@ngayx DATE, @ngayy DATE)
RETURNS MONEY
AS 
BEGIN
    DECLARE @tongGiaTri MONEY;
    SELECT @tongGiaTri = SUM(dbo.Nhap.soluongN * dbo.Nhap.dongiaN)
    FROM dbo.Nhap
    WHERE dbo.Nhap.ngaynhap >= @ngayx AND dbo.Nhap.ngaynhap <= @ngayy;
    RETURN @tongGiaTri;
END;

--Câu5--

CREATE FUNCTION f_TongGiaTriXuat(@tenHang NVARCHAR(20), @nam INT)
RETURNS MONEY
AS
BEGIN
  DECLARE @tongGiaTriXuat MONEY;
  SELECT @tongGiaTriXuat = SUM(S.giaban * X.soluongX)
  FROM Xuat X
  JOIN Sanpham S ON X.masp = S.masp
  JOIN Hangsx H ON S.mahangsx = H.mahangsx
  WHERE H.tenhang = @tenHang AND YEAR(X.ngayxuat) = @nam;
  RETURN @tongGiaTriXuat;
END;

--Câu6--

CREATE FUNCTION f_ThongKeNhanVienMoiPhong(@tenPhong NVARCHAR(30))
RETURNS TABLE
AS
RETURN
    SELECT phong, COUNT(manv) AS soLuongNhanVien
    FROM Nhanvien
    WHERE phong = @tenPhong
    GROUP BY phong;

--Câu7--

CREATE FUNCTION f_SanPhamXuatTrongNgay(@ten_sp NVARCHAR(20), @ngay_xuat DATE)
RETURNS INT
AS
BEGIN
  DECLARE @so_luong_xuat INT
  SELECT @so_luong_xuat = SUM(soluongX)
  FROM Xuat x JOIN Sanpham sp ON x.masp = sp.masp
  WHERE sp.tensp = @ten_sp AND x.ngayxuat = @ngay_xuat
  RETURN @so_luong_xuat
END

--Câu8--

CREATE FUNCTION SoDienThoaiCuaNV(@InvoiceNumber NCHAR(10))
RETURNS NVARCHAR(20)
AS
BEGIN
  DECLARE @EmployeePhone NVARCHAR(20)
  SELECT @EmployeePhone = Nhanvien.sodt
  FROM Nhanvien
  INNER JOIN Xuat ON Nhanvien.manv = Xuat.manv
  WHERE Xuat.sohdx = @InvoiceNumber
  RETURN @EmployeePhone
END

--Câu9--

CREATE FUNCTION f_ThongKeSoLuongThayDoiNhapXuat(@tenSP NVARCHAR(20), @nam INT)
RETURNS INT
AS
BEGIN
  DECLARE @tongNhapXuat INT;
  SET @tongNhapXuat = (
SELECT COALESCE(SUM(nhap.soluongN), 0) + COALESCE(SUM(xuat.soluongX), 0) AS tongSoLuong
    FROM Sanpham sp
    LEFT JOIN Nhap nhap ON sp.masp = nhap.masp
    LEFT JOIN Xuat xuat ON sp.masp = xuat.masp
    WHERE sp.tensp = @tenSP AND YEAR(nhap.ngaynhap) = @nam AND YEAR(xuat.ngayxuat) = @nam
  );
  RETURN @tongNhapXuat;
END;

--Câu10--

CREATE FUNCTION f_ThongKeSoluongSanphamHangsx(@tenhang NVARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @soluong INT;

    SELECT @soluong = SUM(soluong)
    FROM Sanpham sp JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
    WHERE hs.tenhang = @tenhang;

    RETURN @soluong;
END;
