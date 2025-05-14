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