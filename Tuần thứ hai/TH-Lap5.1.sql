--Thực hành số 5--
--Câu1--
SELECT dbo.LayTenHangSX('SP01')
--Câu2--
SELECT dbo.f_TongGiaTriNhap('2018', '2022') AS TongGiaTriNhap;
--Câu3--
SELECT dbo.f_TongSoLuongThayDoi('Galaxy Note11', '2022') AS TongSoLuongThayDoi;
--Câu4--
SELECT dbo.f_TongGiaTriNhapn('2022-01-01', '2022-03-31') AS TongGiaTriNhapn;
--Câu5--
SELECT dbo.f_TongGiaTriXuat('H02', '2022') AS TongGiaTriXuat;
--Câu6--
SELECT * FROM f_ThongKeNhanVienMoiPhong('Kế toán')
--Câu7--
SELECT [dbo].[f_SanPhamXuatTrongNgay]('Samsung', '12-12-2020') as 'sản phẩm sản xuất trong ngày'
--Câu8--
SELECT dbo.SoDienThoaiCuaNV('X02')
--Câu9--
SELECT [dbo].[f_ThongKeSoLuongThayDoiNhapXuat]('Galaxy Note11', 2020) AS TongNhapXuat;
--Câu10--
SELECT [dbo].[f_ThongKeSoluongSanphamHangsx]('OPPO') AS 'Tổng số lượng sản phẩm của hãng'
