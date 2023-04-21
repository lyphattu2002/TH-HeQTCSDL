--Câu 1--

--Để thực hiện các yêu cầu trên, ta có thể sử dụng các câu lệnh SQL sau:

--a: Thêm dữ liệu cho bảng NhanVien:--

select * from Nhanvien

INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES ('NV005', 'Nguyen Van An', 'Nam', 'Ha Noi', '0987654321', 'nva@example.com', 'Vat Tu')

--Thực hiện full backup:--

--qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak--

BACKUP DATABASE [qlBANHANG1] TO DISK= 'qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak' WITH INIT

--b. Thêm dữ liệu cho bảng NhanVien:--

INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES ('NV002', 'Tran Thi Bac', 'Nu', 'Ho Chi Minh', '0123456789', 'ttb@example.com', 'Ke toan')

--Thực hiện different backup:--

--qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak--

BACKUP DATABASE [qlBANHANG1] TO DISK = 'qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak' WITH DIFFERENTIAL

--c. Thêm dữ liệu cho bảng NhanVien:--

INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES ('NV003', 'Le Van Luyen', 'Nam', 'Da Nang', '0912345678', 'lvc@example.com', 'Thu Kho')

--Thực hiện log backup lần 1:--

--qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak--

BACKUP LOG [qlBANHANG1] TO DISK = 'qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak' WITH INIT

--d. Thêm dữ liệu cho bảng NhanVien:--

INSERT INTO NhanVien (manv, tennv, gioitinh, diachi, sodt, email, phong)
VALUES ('NV004', 'Pham Thi Huong', 'Nu', 'Hai Phong', '0987654321', 'ptd@example.com', 'Giam doc  fake')

--Thực hiện log backup lần 2, sử dụng lại tên file đã tạo ở lần 1:--

--qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak--

BACKUP LOG [qlBANHANG1] TO DISK = 'qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak' WITH NOINIT

--Câu 2--

--b:

restore database [qlBANHANG1] from disk = 'qlBANHANG1_LogBackup_2023-04-14_13-39-58.bak' With NoRecovery

SELECT name, physical_name
FROM sys.master_files
WHERE database_id = DB_ID('qlBANHANG1')

--C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\qlBANHANG1.mdf
--C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\qlBANHANG1_log.ldf