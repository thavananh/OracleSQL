----------------------------------------Main Procedure-------------------------------------------

--Liệt kê các thủ tục hiện có trong schema.
SELECT object_name, status FROM user_objects WHERE object_type = 'PROCEDURE';

--Them khach hang
CREATE OR REPLACE PROCEDURE insertCustomer(
    p_makh IN VARCHAR2,
    p_tenkh IN VARCHAR2,
    p_sdt IN VARCHAR2
)
    IS
BEGIN
    INSERT INTO KHACHHANG(MAKH, TENKH, SDT)
    VALUES (p_makh, p_tenkh, p_sdt);
END;

--Them mon an
CREATE OR REPLACE PROCEDURE insertDish(
    p_mamonan IN VARCHAR2,
    p_tenmonan IN VARCHAR2,
    p_loai IN VARCHAR2,
    p_giatien IN NUMBER
)
    IS
BEGIN
    INSERT INTO MONAN(MAMONAN, TENMONAN, LOAI, GIATIEN)
    VALUES (p_mamonan, p_tenmonan, p_loai, p_giatien);
END;

--Thêm món vào đơn giao hàng
CREATE OR REPLACE PROCEDURE insertDeliveryOrderDetail(
    p_madh IN VARCHAR2,
    p_mamonan IN VARCHAR2,
    p_soluong IN NUMBER
)
    IS
BEGIN
    INSERT INTO HOADONCHITIET_DELI(MADH, MAMONAN, SOLUONG)
    VALUES (p_madh, p_mamonan, p_soluong);
END;

--Thêm món vào đơn tại chỗ
CREATE OR REPLACE PROCEDURE insertDineinOrderDetail(
    p_madh IN VARCHAR2,
    p_mamonan IN VARCHAR2,
    p_soluong IN NUMBER
)
    IS
BEGIN
    INSERT INTO HOADONCHITIET_DINEIN(MADH, MAMONAN, SOLUONG)
    VALUES (p_madh, p_mamonan, p_soluong);
END;

--Thêm đơn hàng giao (header)
-- CREATE OR REPLACE PROCEDURE insertDeliveryOrder(
--     p_madh IN VARCHAR2,
--     p_makh IN VARCHAR2,
--     p_ngaylap IN DATE,
--     p_trangthai IN VARCHAR2
-- )
--     IS
-- BEGIN
--     INSERT INTO DON_DELIVERY(MADH, MAKH, NGAYLAP, TRANGTHAI)
--     VALUES (p_madh, p_makh, p_ngaylap, p_trangthai);
-- END;
-- --Thêm đơn tại chỗ (header)
-- CREATE OR REPLACE PROCEDURE insertDineinOrder(
--     p_madh IN VARCHAR2,
--     p_makh IN VARCHAR2,
--     p_ngaylap IN DATE,
--     p_trangthai IN VARCHAR2
-- )
--     IS
-- BEGIN
--     INSERT INTO HOADON_DineIn(MADH, MAKH, NGAYLAP, TRANGTHAI)
--     VALUES (p_madh, p_makh, p_ngaylap, p_trangthai);
-- END;


-- --Thêm nhân viên (Sale / Tài xế / Kho)
-- CREATE OR REPLACE PROCEDURE insertStaff(
--     p_manv IN VARCHAR2,
--     p_tennv IN VARCHAR2,
--     p_vitri IN VARCHAR2 -- ví dụ: 'SALE', 'TAIXE', 'KHO'
-- )
--     IS
-- BEGIN
--     INSERT INTO NHANVIEN(MANV, TENNV, VITRI)
--     VALUES (p_manv, p_tennv, p_vitri);
-- END;

--Thêm món vào đơn giao hàng
CREATE OR REPLACE PROCEDURE insertDeliveryOrderDetail(
    p_madh IN VARCHAR2,
    p_mamonan IN VARCHAR2,
    p_soluong IN NUMBER
)
IS
BEGIN
    INSERT INTO HOADONCHITIET_DELI(MADH, MAMONAN, SOLUONG)
    VALUES (p_madh, p_mamonan, p_soluong);
END;

--Thêm món vào đơn tại chỗ
CREATE OR REPLACE PROCEDURE insertDineinOrderDetail(
    p_madh IN VARCHAR2,
    p_mamonan IN VARCHAR2,
    p_soluong IN NUMBER
)
    IS
BEGIN
    INSERT INTO HOADONCHITIET_DINEIN(MADH, MAMONAN, SOLUONG)
    VALUES (p_madh, p_mamonan, p_soluong);
END;


-- --thêm món vào đơn hàng
-- CREATE OR REPLACE PROCEDURE ThemMonVaoDonDineIn(p_MADH VARCHAR2, p_MAMON VARCHAR2)
--     IS
-- BEGIN
--     INSERT INTO HOADONCHITIET_DINEIN(MADH, MAMONAN)
--     VALUES (p_MADH, p_MAMON);
--
--     COMMIT;
-- END;
--
-- --check
-- BEGIN
--     ThemMonVaoDonDineIn('DI01', 'M01');
-- END;


--Thực hiện cộng điểm: Thêm đơn hàng mới và cập nhật điểm thưởng tự động thông qua nhiều bước: tạo đơn hàng, thêm chi tiết món ăn, cập nhật điểm.
-- CREATE OR REPLACE PROCEDURE THEM_DON_DELIVERY(
--     p_MADH VARCHAR2,
--     p_MAKH VARCHAR2,
--     p_MATX VARCHAR2,
--     p_HINHTHUCTT VARCHAR2,
--     p_MANGMONAN SYS.ODCIVARCHAR2LIST
-- ) IS
--     v_TONG NUMBER := 0;
-- BEGIN
--     -- Tính tổng tiền
--     FOR i IN 1 .. p_MANGMONAN.COUNT LOOP
--             SELECT GIATIEN INTO v_TONG FROM MONAN WHERE MAMONAN = p_MANGMONAN(i);
--             INSERT INTO HOADONCHITIET_DELI VALUES (p_MADH, p_MANGMONAN(i));
--         END LOOP;
--
--     -- Lưu đơn hàng
--     INSERT INTO DON_DELIVERY VALUES (p_MADH, p_MAKH, p_MATX, v_TONG, p_HINHTHUCTT);
--
--     -- Cập nhật điểm thưởng
--     PKG_KHACHHANG.CAPNHAT_DIEM(p_MAKH, v_TONG);
-- END;


--check
-- DECLARE
--     v_monan SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('M01', 'M02', 'M03');
-- BEGIN
--     THEM_DON_DELIVERY('D100', 'KH01', 'TX01', 'TIENMAT', v_monan);
-- END;


--Xem tat ca procedure dang ton tai
--SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE';

--xem chi tiet cai nao do
--SELECT OBJECT_NAME, PROCEDURE_NAME FROM USER_PROCEDURES WHERE OBJECT_TYPE = 'PACKAGE';



---------------------------------Ôn procedure--------------------------------------
create table userxyz(
                        id number(10) primary key,
                        name varchar2(100)
);

--Tạo thủ tục insertUser, nhận id và name để chèn vào bảng userxyz.
create or replace procedure "insertUser"(id in number, name in varchar2)
    IS
BEGIN
    insert into USERXYZ values (id, name);
end;

--drop procedure "insertUser";

--Liệt kê các thủ tục hiện có trong schema.
SELECT object_name, status
FROM user_objects
WHERE object_type = 'PROCEDURE';

--Gọi thủ tục để thêm người dùng
BEGIN
    "insertUser"(12345, 'Nguyen Van J');
    dbms_output.put_line('succesfully');
end;

select * from userxyz;
--Tao thu tuc xoa nguoi dung
create or replace procedure "deleteUser"(id_input in number)
    IS
BEGIN
    delete from USERXYZ WHERE id=id_input;
end;

BEGIN
    "deleteUser"(1234);
    dbms_output.put_line('succesfully');
end;

BEGIN
    "deleteUser"(1);
    dbms_output.put_line('succesfully');
end;

INSERT INTO userxyz (id, name) VALUES (1, 'Alice');
INSERT INTO userxyz (id, name) VALUES (2, 'Bob');
INSERT INTO userxyz (id, name) VALUES (3, 'Charlie');
INSERT INTO userxyz (id, name) VALUES (4, 'Diana');
INSERT INTO userxyz (id, name) VALUES (5, 'Ethan');
INSERT INTO userxyz (id, name) VALUES (6, 'Fiona');
INSERT INTO userxyz (id, name) VALUES (7, 'George');
INSERT INTO userxyz (id, name) VALUES (8, 'Hannah');
INSERT INTO userxyz (id, name) VALUES (9, 'Ivan');
INSERT INTO userxyz (id, name) VALUES (10, 'Julia');

--tao Thủ tục process_user để in ra toàn bộ người dùng
create or replace procedure "process_user"
    is
    CURSOR user_cursor is select id, name from USERXYZ;
begin
    for item in user_cursor loop
            dbms_output.PUT_LINE('User ID:' || item.id);
            dbms_output.PUT_LINE('User Name:' || item.name);
        end loop;
end;

--SET SERVEROUTPUT ON;/
BEGIN
    "process_user"();
    dbms_output.put_line('succesfully');
end;
--mo output console moi thay