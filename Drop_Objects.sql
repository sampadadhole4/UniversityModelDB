SET SERVEROUTPUT ON;
DECLARE
  CURSOR table_cur
  IS
    SELECT 
        *
    FROM 
        config_table;
    tab_name varchar2(50);
    drop_sql varchar2(100);
    row_count number(10):= 0;
  BEGIN
  FOR i IN table_cur
  LOOP
      tab_name:= i.table_name;  
          SELECT count(*) into row_count FROM user_tables where table_name = tab_name;
       IF(row_count > 0)
        THEN
            drop_sql:= 'DROP TABLE ' || tab_name || ' CASCADE CONSTRAINTS PURGE'; 
            EXECUTE IMMEDIATE drop_sql;
            DBMS_OUTPUT.PUT_LINE('TABLE '|| tab_name || ' DROPPED');
         END IF;
      END LOOP;
  EXECUTE IMMEDIATE 'DROP TABLE CONFIG_TABLE';
  dbms_output.put_line( 'ALL TABLES DROPPED AND PURGED');
END;
/

------------Drop triggers---------
declare
  cursor Drop_Triggers is
    select *
      from user_objects
     where object_type in ('TRIGGER');
begin
 for x in Drop_Triggers loop
   execute immediate('drop '||x.object_type||' '||x.object_name);
   dbms_output.put_line('Dropped trigger : ' || x.object_name);
 end loop;
end;


-----------Drop Package and package body--------------
declare
  cursor Drop_Package_PackageBody is
    select *
      from user_objects
     where object_type in ('PACKAGE','PACKAGE BODY');
begin
  for x in Drop_Package_PackageBody loop
   execute immediate('drop '||x.object_type||' '||x.object_name);
   dbms_output.put_line('Dropped : ' ||x.object_name);
     end loop;
end;

------------------ Drop View and Sequence---------------
declare
  cursor Drop_View_Sequence is
    select *
      from user_objects
     where object_type in ('VIEW','SEQUENCE');
begin
  for x in Drop_View_Sequence loop
   execute immediate('drop '||x.object_type||' '||x.object_name);
   dbms_output.put_line('Dropped : ' ||x.object_name);
     end loop;
end;
