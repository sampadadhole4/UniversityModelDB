create or replace procedure sndb_update_logged_in_data(i_user_logged_id in SNDB_logged_in_data.user_logged_id%type,
i_logout_time in SNDB_logged_in_data.logout_time%type)
as
j_logout_time timestamp;
j_login_time timestamp;
j_user_logged_id number;
user_id_not_logged_in exception;
logout_time_must_be_greater_than_login_time exception;
begin
select (user_logged_id) into j_user_logged_id
  from ( select a.user_logged_id
              , row_number() over ( order by a.user_logged_id desc ) as row_num
           from SNDB_logged_in_data a ) ; 
select (LOGOUT_TIME) into j_logout_time
  from ( select a.LOGOUT_TIME
              , row_number() over ( order by a.user_logged_id desc ) as row_num
           from SNDB_logged_in_data a ) ; 
select (login_time) into j_login_time
  from ( select a.login_time
              , row_number() over ( order by a.user_logged_id desc ) as row_num
           from SNDB_logged_in_data a ) ; 
if j_user_logged_id is null then 
raise user_id_not_logged_in;
else
if  j_logout_time is null then
if  i_logout_time >j_login_time  then
update SNDB_logged_in_data a set a.logout_time = i_logout_time where a.user_logged_id = i_user_logged_id ;
else
raise logout_time_must_be_greater_than_login_time;
end if;
end if;
end if;
exception
when user_id_not_logged_in then
dbms_output.put_line('user id not logged in');
when logout_time_must_be_greater_than_login_time then
dbms_output.put_line('logout time must be greater than login time for a user');
end;
/