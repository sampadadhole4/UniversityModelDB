-- create user dataoperations identified by Spring_Team5;
-- --grant all privileges to tester23;
-- grant create any table to dataoperations  with admin option;
-- GRANT UNLIMITED TABLESPACE TO dataoperations;
-- grant connect,resource to dataoperations with admin option;
-- GRANT create session TO dataoperations with admin option;
-- grant create any view to dataoperations with admin option;
-- grant create any trigger to dataoperations with admin option;
-- grant create user to dataoperations with admin option;
-- GRANT DROP USER TO dataoperations;
-- grant EXECUTE any procedure TO dataoperations with admin option;
-- grant CREATE PUBLIC SYNONYM to dataoperations ;




-- SELECT * FROM session_privs
-- ORDER BY privilege;

-- --inside_admin
-- create user
-- GRANT CREATE SESSION TO photoanalyst
-- GRANT SELECT ON sndb_photo_data TO photoanalyst
-- GRANT EXECUTE ANY PROCEDURE TO dataanalyst
-- GRANT select on sndb_photo_data TO dataanalyst
-- CREATE OR REPLACE PUBLIC SYNONYM sndb_photo_data for dataoperations.sndb_photo_data;