--------------------VIEW--------------------
-- 1) View Menu chung (dành cho sale, kho, khách)
CREATE OR REPLACE VIEW V_MENU AS
SELECT MAMONAN, TENMONAN, LOAI, GIATIEN
FROM MONAN;

-- 2) View Thông tin voucher khách đang có (sale & khách)
CREATE OR REPLACE VIEW V_CUSTOMER_VOUCHERS AS
SELECT kv.MAKH, k.TENKH, kv.MAGG, v.SOTIEN AS GIATRI
FROM KH_VOUCHER kv
         JOIN KHACHHANG k ON kv.MAKH = k.MAKH
         JOIN VOUCHER v   ON kv.MAGG = v.MAGG;

-- 3) View Đơn giao hàng (sale & tài xế)
CREATE OR REPLACE VIEW V_DELIVERY_ORDERS AS
SELECT d.MADH, d.MAKH, k.TENKH, d.MATX, t.TENTX, d.THANHTIEN, d.HINHTHUCTT
FROM DON_DELIVERY d
         JOIN KHACHHANG k ON d.MAKH = k.MAKH
         JOIN TAIXE t     ON d.MATX = t.MATX;

-- 4) View Đơn ăn tại chỗ (sale)
CREATE OR REPLACE VIEW V_DINEIN_ORDERS AS
SELECT d.MADH, d.MAKH, k.TENKH, d.SOBAN, d.THANHTIEN, d.HINHTHUCTT
FROM DON_DINEIN d
         JOIN KHACHHANG k ON d.MAKH = k.MAKH;

--5) View Chi tiết món trong đơn (dùng chung sale & tài xế)
CREATE OR REPLACE VIEW V_ORDER_DETAILS AS
SELECT COALESCE(hd_deli.MADH, hd_di.MADH) AS MADH,
       COALESCE(hd_deli.MAMONAN, hd_di.MAMONAN) AS MAMONAN,
       COALESCE(hd_deli.SOLUONG, hd_di.SOLUONG) AS SOLUONG,
       m.TENMONAN, m.LOAI, m.GIATIEN
FROM MONAN m
         LEFT JOIN HOADONCHITIET_DELI hd_deli ON m.MAMONAN = hd_deli.MAMONAN
         LEFT JOIN HOADONCHITIET_DINEIN hd_di ON m.MAMONAN = hd_di.MAMONAN;
CREATE OR REPLACE VIEW V_ALL_ORDER_DETAILS AS
SELECT
    MADH,
    MAMONAN,
    TENMONAN,
    LOAI_MON,
    DON_GIA,
    'DELIVERY' AS LOAI_DON
FROM V_DELIVERY_ORDER_DETAILS

UNION ALL

SELECT
    MADH,
    MAMONAN,
    TENMONAN,
    LOAI_MON,
    DON_GIA,
    'DINEIN' AS LOAI_DON
FROM V_DINEIN_ORDER_DETAILS;



CREATE OR REPLACE VIEW V_DELIVERY_ORDER_DETAILS AS
SELECT
    hd.MADH,
    hd.MAMONAN,
    m.TENMONAN,
    m.LOAI      AS LOAI_MON,
    hd.SOLUONG,
    m.GIATIEN   AS DON_GIA
FROM HOADONCHITIET_DELI hd
         JOIN MONAN m ON hd.MAMONAN = m.MAMONAN
;

CREATE OR REPLACE VIEW V_DINEIN_ORDER_DETAILS AS
SELECT
    hd.MADH,
    hd.MAMONAN,
    m.TENMONAN,
    m.LOAI      AS LOAI_MON,
    hd.SOLUONG,
    m.GIATIEN   AS DON_GIA
FROM HOADONCHITIET_DINEIN hd
         JOIN MONAN m ON hd.MAMONAN = m.MAMONAN
;
--------------------------Xem table--------------------------------------

-- Select * FROM MONAN;--các mon an va thong tin ve mon an
-- SELECT * FROM KHACHHANG;--cac thong tin khach hang, diem tich luy
-- SELECT * FROM VOUCHER;-- ma voucher voi gia tri
-- SELECT * FROM KH_VOUCHER;-- ket noi ma khach hang voi ma voucher, khach nao cung co
-- SELECT * FROM TAIXE;-- thong tin tai xe kem MADVVC
-- SELECT * FROM DON_DELIVERY;-- gom ma don hang, ma khach hang, ma tai xe, tong gia don, hinh thuc thanh toan
-- SELECT * FROM DON_DINEIN;-- gom ma don hang, ma khach hang, so ban, tong gia don, hinh thuc thanh toan
-- SELECT * FROM HOADONCHITIET_DELI;--madon+mamon
-- SELECT * FROM HOADONCHITIET_DINEIN;--tuong tu

--------------------------Check View--------------------------------------

--
SELECT *FROM V_DELIVERY_ORDERS;--thong tin lien quan den don hang (bao gom khach va shipper)
SELECT *FROM V_DELIVERY_ORDER_DETAILS;
SELECT *FROM V_DINEIN_ORDERS;--thong tin lien quan den don hang dung tai quan (bao gom khach + so ban)
SELECT *FROM V_DINEIN_ORDER_DETAILS;
SELECT *FROM V_CUSTOMER_VOUCHERS;--thong tin ma giam gia khach dang co
SELECT *FROM V_MENU;--mon an
SELECT *FROM V_ALL_ORDER_DETAILS;--In thong tin chi tiet chung khi ket hop bang mon an voi 2 bang details kia-----CAN NHAC BO
---se khong co 3 view TAIXE, MONAN, VOUCHER



--kiem tra cac view hien co
--SELECT VIEW_NAME FROM USER_VIEWS;

SELECT MADH, TEN_KHACH_HANG, TEN_TAI_XE, THANHTIEN
FROM V_DELIVERY_ORDERS
WHERE HINH_THUC_THANH_TOAN = 'CASH';

SELECT MADH, SO_BAN, TEN_KHACH_HANG, THANHTIEN
FROM V_DINEIN_ORDERS
WHERE SO_BAN >= 5;

SELECT TEN_DON_VI_VC, SUM(THANHTIEN) AS DOANH_THU
FROM V_DELIVERY_ORDERS
GROUP BY TEN_DON_VI_VC
ORDER BY DOANH_THU DESC;

SELECT d.LOAI_MON, COUNT(*) AS SO_LUONG
FROM (
         SELECT LOAI_MON FROM V_DELIVERY_ORDER_DETAILS
         UNION ALL
         SELECT LOAI_MON FROM V_DINEIN_ORDER_DETAILS
     ) d
GROUP BY d.LOAI_MON;

SELECT
    o.MADH,
    o.TEN_KHACH_HANG,
    od.TENMONAN,
    od.DON_GIA
FROM V_DELIVERY_ORDERS o
         JOIN V_DELIVERY_ORDER_DETAILS od
              ON o.MADH = od.MADH
ORDER BY o.MADH;

------------------------GRANT PHAN QUYEN----------------------------------------------------------------
GRANT SELECT ON KH_VOUCHER TO DUY_ADMIN;--cap quyen dung select cho user

-- 1) SALE_ROLE: cần nhìn menu, voucher, tất cả đơn + chi tiết đơn
GRANT SELECT ON V_MENU               TO SALE_ROLE;
GRANT SELECT ON V_CUSTOMER_VOUCHERS  TO SALE_ROLE;
GRANT SELECT ON V_DELIVERY_ORDERS    TO SALE_ROLE;
GRANT SELECT ON V_DINEIN_ORDERS      TO SALE_ROLE;
GRANT SELECT ON V_ALL_ORDER_DETAILS  TO SALE_ROLE;

-- 2) WAREHOUSE_ROLE: chỉ quản lý menu
GRANT SELECT ON V_MENU TO WAREHOUSE_ROLE;

-- 3) DRIVER_ROLE: chỉ xem đơn giao và chi tiết món
GRANT SELECT ON V_DELIVERY_ORDERS TO DRIVER_ROLE;
GRANT SELECT ON V_ALL_ORDER_DETAILS   TO DRIVER_ROLE;

-- 4) CUSTOMER_ROLE: chỉ xem menu & voucher của mình
GRANT SELECT ON V_MENU              TO CUSTOMER_ROLE;
GRANT SELECT ON V_CUSTOMER_VOUCHERS TO CUSTOMER_ROLE;
--------------------FUNCTION-----------------------------------------------------------------------------------------
--Tính tổng tiền của một đơn hàng (dine-in hoặc delivery)
CREATE OR REPLACE FUNCTION TINH_TONGTIEN_DELIVERY(p_MADH VARCHAR2) RETURN NUMBER IS
    v_TONG NUMBER := 0;
BEGIN
    SELECT SUM(MA.GIATIEN)
    INTO v_TONG
    FROM HOADONCHITIET_DELI HD
             JOIN MONAN MA ON HD.MAMONAN = MA.MAMONAN
    WHERE HD.MADH = p_MADH;

    RETURN v_TONG;
END;
--EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0

--Câu kiêm tra:
-- Giả sử có đơn hàng MADH = 'D001'
SELECT TINH_TONGTIEN_DELIVERY('D001') FROM DUAL;



--Tinh tổng tiền đơn hàng chuẩn bị giao hàng


--Kiểm tra khách hàng có được giảm giá không =>trả về số tiền giảm giá (nếu có voucher).

--Xem tat ca function dang ton tai
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION';


--------------------PACKAGE------------------------------------------------------------------------
--Cộng điểm thưởng khi mua hàng
CREATE OR REPLACE PACKAGE PKG_KHACHHANG AS
FUNCTION TINH_DIEM(p_TONGTIEN NUMBER) RETURN NUMBER;
PROCEDURE CAPNHAT_DIEM(p_MAKH VARCHAR2, p_TONGTIEN NUMBER);
END PKG_KHACHHANG;

CREATE OR REPLACE PACKAGE BODY PKG_KHACHHANG AS
    FUNCTION TINH_DIEM(p_TONGTIEN NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN FLOOR(p_TONGTIEN / 10000); -- Mỗi 10k được 1 điểm
    END;

    PROCEDURE CAPNHAT_DIEM(p_MAKH VARCHAR2, p_TONGTIEN NUMBER) IS
    BEGIN
        UPDATE KHACHHANG
        SET DIEMTL = DIEMTL + TINH_DIEM(p_TONGTIEN)
        WHERE MAKH = p_MAKH;
    END;
END PKG_KHACHHANG;

--Lệnh kiểm tra
-- Tính điểm với số tiền 253000
SELECT PKG_KHACHHANG.TINH_DIEM(253000) FROM DUAL; -- → 25 điểm

--cập nhật điểm
BEGIN
    PKG_KHACHHANG.CAPNHAT_DIEM('KH01', 120000);
END;


--Xem tat ca package dang ton tai
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PACKAGE';


--------------------PROCEDURE--------------------------------------------------------------------
--Liệt kê các thủ tục hiện có trong schema.
SELECT object_name, status
FROM user_objects
WHERE object_type = 'PROCEDURE';
--thêm món vào đơn hàng
CREATE OR REPLACE PROCEDURE ThemMonVaoDonDineIn(p_MADH VARCHAR2, p_MAMON VARCHAR2)
    IS
BEGIN
    INSERT INTO HOADONCHITIET_DINEIN(MADH, MAMONAN)
    VALUES (p_MADH, p_MAMON);

    COMMIT;
END;

--check
BEGIN
    ThemMonVaoDonDineIn('DI01', 'M01');
END;


--Thực hiện cộng điểm: Thêm đơn hàng mới và cập nhật điểm thưởng tự động thông qua nhiều bước: tạo đơn hàng, thêm chi tiết món ăn, cập nhật điểm.
CREATE OR REPLACE PROCEDURE THEM_DON_DELIVERY(
    p_MADH VARCHAR2,
    p_MAKH VARCHAR2,
    p_MATX VARCHAR2,
    p_HINHTHUCTT VARCHAR2,
    p_MANGMONAN SYS.ODCIVARCHAR2LIST
) IS
    v_TONG NUMBER := 0;
BEGIN
    -- Tính tổng tiền
    FOR i IN 1 .. p_MANGMONAN.COUNT LOOP
            SELECT GIATIEN INTO v_TONG FROM MONAN WHERE MAMONAN = p_MANGMONAN(i);
            INSERT INTO HOADONCHITIET_DELI VALUES (p_MADH, p_MANGMONAN(i));
        END LOOP;

    -- Lưu đơn hàng
    INSERT INTO DON_DELIVERY VALUES (p_MADH, p_MAKH, p_MATX, v_TONG, p_HINHTHUCTT);

    -- Cập nhật điểm thưởng
    PKG_KHACHHANG.CAPNHAT_DIEM(p_MAKH, v_TONG);
END;


--check
DECLARE
    v_monan SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('M01', 'M02', 'M03');
BEGIN
    THEM_DON_DELIVERY('D100', 'KH01', 'TX01', 'TIENMAT', v_monan);
END;


--Xem tat ca procedure dang ton tai
--SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE';

--xem chi tiet cai nao do
--SELECT OBJECT_NAME, PROCEDURE_NAME FROM USER_PROCEDURES WHERE OBJECT_TYPE = 'PACKAGE';

Drop procedure ThemMonVaoDonDineIn
--------------------TRIGGER---------------------------------------------------------------------------------
---Tính tổng tiền trong hóa đơn khi thêm món mới vào
CREATE OR REPLACE TRIGGER TRG_UPDATE_TONGTIEN_DELIVERY
    AFTER INSERT ON HOADONCHITIET_DELI
    FOR EACH ROW
BEGIN
    UPDATE DON_DELIVERY
    SET THANHTIEN = (
        SELECT SUM(MA.GIATIEN)
        FROM HOADONCHITIET_DELI HD
                 JOIN MONAN MA ON HD.MAMONAN = MA.MAMONAN
        WHERE HD.MADH = :NEW.MADH
    )
    WHERE MADH = :NEW.MADH;
END;

--check
-- Thêm món mới vào đơn hàng → Trigger sẽ tự cập nhật tổng tiền
INSERT INTO HOADONCHITIET_DELI (MADH, MAMONAN)
VALUES ('D001', 'M02');

-- Kiểm tra lại tổng tiền
SELECT * FROM DON_DELIVERY WHERE MADH = 'D001';




--Kiểm tra định dạng số điện thoại đúng chưa (10 chữ số)
CREATE OR REPLACE TRIGGER TRG_VALIDATE_SDT_KH
    BEFORE INSERT ON KHACHHANG
    FOR EACH ROW
BEGIN
    IF LENGTH(:NEW.SDT) != 10 OR NOT REGEXP_LIKE(:NEW.SDT, '^\d{10}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Số điện thoại không hợp lệ!');
    END IF;
END;

--check đúng
INSERT INTO KHACHHANG (MAKH, TENKH, SDT, DIEMTL)
VALUES ('KH99', 'Nam', '0938123456', 0);
--check sai
-- Dữ liệu sai định dạng, sẽ gây lỗi trigger
INSERT INTO KHACHHANG (MAKH, TENKH, SDT, DIEMTL)
VALUES ('KH98', 'SaiSDT', '09381A4566', 0);




--Ghi lại nhật ký hóa đơn bị xóa
CREATE TABLE LOG_XOA_HOADON (
     ID_LOG NUMBER GENERATED ALWAYS AS IDENTITY,
     MADH VARCHAR2(5),
     NGAYXOA DATE,
     LYDO VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_Log_Xoa_HoaDonDinein
    BEFORE DELETE ON DON_DINEIN
    FOR EACH ROW
BEGIN
    INSERT INTO LOG_XOA_HOADON(MADH, NGAYXOA, LYDO)
    VALUES (:OLD.MADH, SYSDATE, 'Xóa đơn ăn tại chỗ');
END;

--check
DELETE FROM DON_DINEIN WHERE MADH = 'DI01';

-- Xem log
SELECT * FROM LOG_XOA_HOADON;


--Xem tat ca trigger dang ton tai
SELECT TRIGGER_NAME FROM USER_TRIGGERS;


--xem toàn bộ các object đang có trong schema (bao gồm luôn table, index,...):
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;


