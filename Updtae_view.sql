create or replace function checkPhoneNumberFormat(i_Phone_number in number)
return number
is
begin
if length(i_Phone_number) = 10 then
return 1;
else 
return 0;
end if;
end checkPhoneNumberFormat;
/

create or replace function Check_isnumeric(i_string in varchar2)
return number
is
i_num number;
begin
i_num:=To_Number(i_string);
return 1;

exception
when others then
return 0;
end Check_isnumeric;
/


create or replace procedure SNDB_update_View_Student_details (i_User_ID in View_Student_details.User_ID%type, 
i_Phone_Number in View_Student_details.Phone_Number%type , i_Course_Name in View_Student_details.Course_Name%type)
as
j_phone_number number;
phone_num_macthes exception;
phone_num_should_be_number exception;
phone_num_should_be_length10 exception;
j_Course_Name varchar2(50);
begin
select a.Phone_Number into j_phone_number from view_student_details a where a.User_ID = i_User_ID;
select a.Course_Name into j_Course_Name from view_student_details a where a.User_ID = i_User_ID;

if j_phone_number != i_Phone_Number then
if checkPhoneNumberFormat(i_Phone_Number) = 0 then
raise phone_num_should_be_length10;
end if;
 if Check_isnumeric(i_Phone_Number)=1 then
--if i_Phone_Number in CHECK(REGEXP_LIKE(PHONE_NUMBER,''^[0-9]{10}$'')) then
update View_Student_details e set e.Phone_Number = i_Phone_Number where e.User_ID = i_User_ID;
dbms_output.put_line('Updated the phone number');
else raise phone_num_should_be_number;
end if;

end if;

if j_Course_Name != i_Course_Name then
update View_Student_details f set f.Course_Name = i_Course_Name where f.User_ID = i_User_ID;
dbms_output.put_line('Updated the course name');
end if;
exception
when phone_num_should_be_number then
dbms_output.put_line('phone number should be numeric value');
when phone_num_should_be_length10 then
dbms_output.put_line('phone number cannot have less than 10 digits');

end;
/

CREATE OR REPLACE FUNCTION GET_LOGGEDIN_USER_ID 
RETURN varchar2 
IS
L_USER_ID varchar2(50);
BEGIN
    SELECT USERNAME 
        INTO L_USER_ID
            FROM 
            all_users 
            WHERE USERNAME = (SELECT USER FROM DUAL);
    RETURN L_USER_ID;
END GET_LOGGEDIN_USER_ID;
/