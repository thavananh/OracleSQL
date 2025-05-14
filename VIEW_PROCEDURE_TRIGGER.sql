
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


