
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

