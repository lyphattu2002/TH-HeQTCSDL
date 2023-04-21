--Thực hành số 2--
--Câu1--
CREATE VIEW v_Sanpham AS
SELECT masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota FROM Sanpham;

CREATE VIEW v_Hangsx AS
SELECT mahangsx, tenhang, diachi, sodt, email FROM Hangsx;

CREATE VIEW v_Nhanvien AS
SELECT manv, tennv, gioitinh, diachi, sodt, email, phong FROM Nhanvien;

CREATE VIEW v_Nhap AS
SELECT sohdn, masp, manv, ngaynhap, soluongN, dongiaN FROM Nhap;

CREATE VIEW v_Xuat AS
SELECT sohdx, masp, manv, ngayxuat, soluongX FROM Xuat;

--Câu2--

CREATE VIEW v_SanPham_GiamDanGiaBan AS
SELECT TOP 100 PERCENT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota
FROM Sanpham sp
INNER JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
ORDER BY sp.giaban DESC;

--Câu3--

CREATE VIEW v_SanPham_Samsung AS
SELECT sp.masp, sp.tensp, hs.tenhang, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota
FROM Sanpham sp
INNER JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
WHERE hs.tenhang = 'samsung';

--Câu4--

CREATE VIEW v_NhanVien_Nu_KeToan AS
SELECT manv, tennv, gioitinh, diachi, sodt, email, phong
FROM Nhanvien
WHERE gioitinh = 'Nữ' AND phong = 'Kế toán';

--Câu5--

CREATE VIEW v_PhieuNhap AS
SELECT pn.sohdn, sp.masp, sp.tensp, hs.tenhang, pn.soluongN, pn.dongiaN, pn.soluongN*pn.dongiaN AS tiennhap, sp.mausac, sp.donvitinh, pn.ngaynhap, nv.tennv, nv.phong
FROM Nhap pn
INNER JOIN Sanpham sp ON sp.masp = pn.masp
INNER JOIN Hangsx hs ON hs.mahangsx = sp.mahangsx
INNER JOIN Nhanvien nv ON nv.manv = pn.manv
WHERE hs.tenhang LIKE '%samsung%' AND nv.gioitinh = 'Nữ' AND nv.phong = 'Kế toán'

--Câu6--

CREATE VIEW v_PhieuXuat_Thang10_2018 AS
SELECT TOP 100 PERCENT X.sohdx, X.masp, S.tensp, H.tenhang, X.soluongX, S.giaban, X.soluongX*S.giaban AS tienxuat, S.mausac, S.donvitinh, X.ngayxuat, N.tennv, N.phong
FROM Xuat X
INNER JOIN Sanpham S ON X.masp = S.masp
INNER JOIN Hangsx H ON S.mahangsx = H.mahangsx
INNER JOIN Nhanvien N ON X.manv = N.manv
WHERE MONTH(X.ngayxuat) = 10 AND YEAR(X.ngayxuat) = 2018
ORDER BY X.sohdx ASC;

--Câu7--

CREATE VIEW v_HoaDonNhap_Samsung_2017 AS
SELECT N.sohdn, N.masp, S.tensp, N.soluongN, N.dongiaN, N.ngaynhap, NV.tennv, NV.phong
FROM Nhap N
INNER JOIN Sanpham S ON N.masp = S.masp
INNER JOIN Hangsx H ON S.mahangsx = H.mahangsx
INNER JOIN Nhanvien NV ON N.manv = NV.manv
WHERE YEAR(N.ngaynhap) = 2017 AND H.tenhang = 'samsung';

--Câu8--

CREATE VIEW v_Top10HDXuat_2018 AS
SELECT TOP 10 X.sohdx, X.masp, S.tensp, X.soluongX, S.giaban, X.soluongX*S.giaban AS tienxuat, X.ngayxuat, N.tennv, N.phong
FROM Xuat X
INNER JOIN Sanpham S ON X.masp = S.masp
INNER JOIN Nhanvien N ON X.manv = N.manv
WHERE YEAR(X.ngayxuat) = 2018
ORDER BY X.soluongX DESC;

--Câu9--

CREATE VIEW v_Top10SanPhamGiaCao AS
SELECT *
FROM (
  SELECT ROW_NUMBER() OVER (ORDER BY giaban DESC) AS RowNum, *
  FROM Sanpham
) AS T
WHERE RowNum <= 10;

--Câu10--

CREATE VIEW v_Sanpham_Giaban_100000_500000 AS
SELECT *
FROM Sanpham
WHERE mahangsx = 'samsung' AND giaban BETWEEN 100000 AND 500000;

--Câu11--

CREATE VIEW v_TongTienNhap_Samsung_2018 AS
SELECT SUM(N.dongiaN * N.soluongN) AS TongTienNhap
FROM Nhap N
INNER JOIN Sanpham S ON N.masp = S.masp
INNER JOIN Hangsx H ON S.mahangsx = H.mahangsx
WHERE H.tenhangsx = 'samsung' AND YEAR(N.ngaynhap) = 2018;

--Câu12--

CREATE VIEW v_TongTienXuat_02092018 AS
SELECT SUM(X.soluongX * S.giaban) AS tongtien, N.tennv, N.phong
FROM Xuat X
INNER JOIN Sanpham S ON X.masp = S.masp
INNER JOIN Nhanvien N ON X.manv = N.manv
WHERE X.ngayxuat = '2018-09-02'
GROUP BY N.tennv, N.phong;

--Câu13--

CREATE VIEW v_TienNhapCaoNhat_2018 AS
SELECT TOP 1 sohdn, ngaynhap
FROM Nhap
WHERE YEAR(ngaynhap) = 2018
ORDER BY dongiaN * soluongN DESC;

--Câu14--

CREATE VIEW v_Top10MatHang_Nam2019 AS
SELECT TOP 10 masp, SUM(soluongN) AS TongSoLuong
FROM Nhap
WHERE YEAR(ngaynhap) = 2019
GROUP BY masp
ORDER BY TongSoLuong DESC;

--Câu15--

CREATE VIEW v_Sanpham_Samsung_NV01 AS
SELECT Sanpham.masp, Sanpham.tensp
FROM Sanpham
JOIN Nhap ON Sanpham.masp = Nhap.masp
JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
JOIN Nhanvien ON Nhap.manv = Nhanvien.manv
WHERE Hangsx.tenhang = 'Samsung' AND Nhanvien.manv = 'NV01';

--Câu16--

CREATE VIEW v_ThongTinXuatSP02_NhanVienNV02 AS
SELECT n.sohdn, n.masp, n.soluongN, n.ngaynhap
FROM Nhap n
JOIN Xuat x ON n.sohdn = x.sohdx AND n.masp = x.masp
WHERE n.masp = 'SP02' AND x.manv = 'NV02';

--Câu17--

CREATE VIEW v_Xuat_SP02_03022020 AS
SELECT Nhanvien.manv, Nhanvien.tennv
FROM Xuat
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
INNER JOIN Nhanvien ON Xuat.manv = Nhanvien.manv
WHERE Xuat.ngayxuat = '2020-02-03' AND Sanpham.masp = 'SP02'

--Thực hành số 3--
--Câu1--

CREATE VIEW v_SoluongLoaiSP AS
SELECT Hangsx.mahangsx, Hangsx.tenhang, COUNT(Sanpham.masp) AS soluongloai
FROM Sanpham
INNER JOIN Hangsx ON Sanpham.mahangsx = Hangsx.mahangsx
GROUP BY Hangsx.mahangsx, Hangsx.tenhang;

--Câu2--

CREATE VIEW v_TongTienNhap_2018 AS
SELECT Sanpham.masp, Sanpham.tensp, SUM(Nhap.soluongN*Nhap.dongiaN) AS TongTienNhap
FROM Sanpham JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2018
GROUP BY Sanpham.masp, Sanpham.tensp;

--Câu3--

CREATE VIEW v_SanPhamXuat2018Samsung AS
SELECT sp.masp, sp.tensp, SUM(x.soluongX) as tongxuat
FROM Sanpham sp
JOIN Xuat x ON sp.masp = x.masp
JOIN Nhanvien nv ON x.manv = nv.manv
JOIN Hangsx hs ON sp.mahangsx = hs.mahangsx
WHERE YEAR(x.ngayxuat) = 2018 AND hs.tenhang = 'Samsung'
GROUP BY sp.masp, sp.tensp
HAVING SUM(x.soluongX) > 10000;

--Câu4--

CREATE VIEW v_SoLuongNamTheoPhongBan AS 
SELECT Nhanvien.phong, COUNT(*) AS SoLuongNhanVienNam
FROM Nhanvien
WHERE Nhanvien.gioitinh = N'Nam'
GROUP BY Nhanvien.phong;

--Câu5--

CREATE VIEW v_TongSoLuongNhapHangsx AS
SELECT Hangsx.tenhang, SUM(Nhap.soluongN) AS TongSoLuongNhap
FROM Hangsx
INNER JOIN Sanpham ON Hangsx.mahangsx = Sanpham.mahangsx
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
WHERE YEAR(Nhap.ngaynhap) = 2018
GROUP BY Hangsx.tenhang

--Câu6--

CREATE VIEW v_TongTienXuatTheoNhanVien AS 
SELECT Nhanvien.tennv, SUM(Xuat.soluongX * Sanpham.giaban) AS TongTienXuat
FROM Nhanvien
INNER JOIN Xuat ON Nhanvien.manv = Xuat.manv
INNER JOIN Sanpham ON Xuat.masp = Sanpham.masp
WHERE YEAR(Xuat.ngayxuat) = 2018
GROUP BY Nhanvien.tennv

--Câu7--

CREATE VIEW v_TongTienNhapTheoNhanVien AS
SELECT Nhanvien.tennv, SUM(Nhap.soluongN * Nhap.dongiaN) AS TongTienNhap
FROM Nhanvien
INNER JOIN Nhap ON Nhanvien.manv = Nhap.manv
WHERE YEAR(Nhap.ngaynhap) = 2018 AND MONTH(Nhap.ngaynhap) = 8
GROUP BY Nhanvien.tennv
HAVING SUM(Nhap.soluongN * Nhap.dongiaN) > 100000;

--Câu8--

CREATE VIEW v_SanPhamChuaBan AS 
SELECT Sanpham.masp, Sanpham.tensp, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
LEFT JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE Xuat.masp IS NULL;

--Câu9--

CREATE VIEW v_SanPhamNhapXuat2018 AS
SELECT Sanpham.masp, Sanpham.tensp, Sanpham.soluong, Sanpham.mausac, Sanpham.giaban, Sanpham.donvitinh, Sanpham.mota
FROM Sanpham
INNER JOIN Nhap ON Sanpham.masp = Nhap.masp
INNER JOIN Xuat ON Sanpham.masp = Xuat.masp
WHERE YEAR(Nhap.ngaynhap) = 2018 AND YEAR(Xuat.ngayxuat) = 2018;

--Câu10--

CREATE VIEW v_ThongKeNhapXuatNhanVien AS 
SELECT n.manv, n.tennv, COUNT(DISTINCT x.sohdx) AS solanxuat, COUNT(DISTINCT p.sohdn) AS solannhap 
FROM Nhanvien n 
JOIN Nhap p ON n.manv = p.manv 
LEFT JOIN Xuat x ON n.manv = x.manv 
WHERE x.manv IS NOT NULL 
GROUP BY n.manv, n.tennv 

--Câu11--

CREATE VIEW v_NhanVienChuaGiaoDich
AS
SELECT n.manv, n.tennv
FROM Nhanvien n
LEFT JOIN Nhap ON n.manv = Nhap.manv
LEFT JOIN Xuat ON n.manv = Xuat.manv
WHERE Nhap.manv IS NULL AND Xuat.manv IS NULL;































