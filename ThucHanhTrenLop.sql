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
