CREATE ROLE PDB_ADMIN_ROLE;--Tạo một role (vai trò) mới tên là PDB_ADMIN_ROLE.Role là cách nhóm các quyền lại để dễ cấp phát cho user.
--SELECT role FROM dba_roles WHERE role = 'PDB_ADMIN_ROLE';

GRANT CREATE SESSION TO PDB_ADMIN_ROLE;--Cho phép user có role này kết nối vào CSDL Oracle.
GRANT CREATE USER TO PDB_ADMIN_ROLE;--Cho phép tạo user mới trong hệ thống.
GRANT ALTER USER TO PDB_ADMIN_ROLE;--Cho phép thay đổi thông tin user (đổi mật khẩu, quyền,...).
--GRANT DROP USER TO PDB_ADMIN_ROLE; --Cho phép xóa user khỏi hệ thống.

--Cap 1 so quyen tao doi tuong
GRANT CREATE TABLE TO PDB_ADMIN_ROLE;
GRANT CREATE VIEW TO PDB_ADMIN_ROLE;
GRANT CREATE SEQUENCE TO PDB_ADMIN_ROLE;
GRANT CREATE PROCEDURE TO PDB_ADMIN_ROLE;
GRANT CREATE TRIGGER TO PDB_ADMIN_ROLE;
GRANT CREATE SYNONYM TO PDB_ADMIN_ROLE;

--Cap quyen duoc cap quyen
GRANT GRANT ANY OBJECT PRIVILEGE TO PDB_ADMIN_ROLE;--Cho phép cấp quyền trên đối tượng (table, view, procedure,...) cho user khác.
GRANT GRANT ANY PRIVILEGE TO PDB_ADMIN_ROLE;--Cho phép cấp bất kỳ quyền hệ thống nào cho user khác.

--Cap quyen duoc truy van
GRANT SELECT ANY TABLE TO PDB_ADMIN_ROLE;--Cho phép truy vấn tất cả bảng trong toàn bộ CSDL
GRANT SELECT_CATALOG_ROLE TO PDB_ADMIN_ROLE;--Cho phép truy vấn dữ liệu hệ thống, như danh sách user, bảng hệ thống,...


--Kiem tra danh sach cac quyen
SELECT *
FROM role_sys_privs
WHERE role = 'PDB_ADMIN_ROLE';

GRANT PDB_ADMIN_ROLE TO DUY_ADMIN; -- Gán role PDB_ADMIN_ROLE cho user DUY_ADMIN – từ nay DUY_ADMIN có tất cả quyền đã cấp cho role.