         
create or replace procedure sndb_update_logged_in_data(i_clock_in_id in SNDB_logged_in_data.clock_in_id%type, i_user_logged_id in SNDB_logged_in_data.user_logged_id%type,
i_login_time in SNDB_logged_in_data.login_time%type,
i_logout_time in SNDB_logged_in_data.logout_time%type)
as
j_clock_in_id number;
j_logout_time TIMESTAMP;
user_not_logged_in exception;
k_logout_time timestamp;
j_login_time timestamp;
logout_time_cannot_be_less_than_login_time exception;
logout_time_must_be_greater_than_previous_logout_time exception;
begin
select count(*) into j_clock_in_id from SNDB_logged_in_data a where a.clock_in_id = i_clock_in_id and a.user_logged_id = i_user_logged_id;
if j_clock_in_id is not null then
SELECT a.LOGOUT_TIME into j_logout_time from SNDB_logged_in_data a where a.clock_in_id = i_clock_in_id and a.user_logged_id = i_user_logged_id;
SELECT a.login_time into j_login_time from SNDB_logged_in_data a where a.clock_in_id = i_clock_in_id and a.user_logged_id = i_user_logged_id;
dbms_output.put_line(j_logout_time || 233333333333333);
dbms_output.put_line(j_login_time || 'login time' );
---chceking the table value of logout is null
if j_logout_time is null then
--- if it's null then chceking the entering value shoud be greater than the log in time
if i_logout_time > j_login_time  then
update SNDB_logged_in_data a set a.logout_time = i_logout_time where a.clock_in_id = i_clock_in_id and a.user_logged_id = i_user_logged_id;
dbms_output.put_line('Upadted the logged out time for the user');
else
raise logout_time_cannot_be_less_than_login_time;
end if;
end if;
---checking if the table avlue is not null then
if j_logout_time is not null then
--- previous log out time should be less than the entering one
dbms_output.put_line(j_logout_time || 555555555555555555 || i_logout_time );
if j_logout_time < i_logout_time then 
dbms_output.put_line('mEENU');

update SNDB_logged_in_data a set a.logout_time = i_logout_time where a.clock_in_id = i_clock_in_id and a.user_logged_id = i_user_logged_id;
dbms_output.put_line('Upadted the logged out time for the user');
else
raise logout_time_must_be_greater_than_previous_logout_time;
end if;
end if;
--raise user_not_logged_in;
end if;
If j_clock_in_id is null then 
raise user_not_logged_in;
end if;
dbms_output.put_line(j_login_time || 888888888888888888 || i_logout_time );
----if the table value of logut is not null then
--if j_login_time < i_logout_time then
--raise logout_time_cannot_be_less_than_login_time;
--end if;
--SELECT b.logout_time into k_logout_time from SNDB_logged_in_data b where b.clock_in_id = i_clock_in_id and b.user_logged_id = i_user_logged_id;
dbms_output.put_line(k_logout_time || 155555555555 );
dbms_output.put_line(i_logout_time || 8777777777777777777 );
exception
when user_not_logged_in then
dbms_output.put_line('User is not logged in');
when logout_time_must_be_greater_than_previous_logout_time then
dbms_output.put_line('logout time must be greater than previous logout time for a user');
when logout_time_cannot_be_less_than_login_time then
dbms_output.put_line('logout time cannot be less than login time');
end;


select * from sndb_user_account;
select *  from SNDB_logged_in_data; where clock_in_id = 1;

begin
sndb_update_logged_in_data(1,TO_TIMESTAMP('13-MAY-2022 02:30:33','DD-MON-YY HH24:MI:SS'));
end;


create or replace procedure sndb_update_logged_in_data(i_clock_in_id in SNDB_logged_in_data.clock_in_id%type,
i_logout_time in SNDB_logged_in_data.logout_time%type)
as
j_clock_in_id number;
j_logout_time TIMESTAMP;
user_not_logged_in exception;
k_logout_time timestamp;
logout_time_must_be_greater_than_previous_logout_time exception;
begin
select count(*) into j_clock_in_id from SNDB_logged_in_data a where a.clock_in_id = i_clock_in_id;
if j_clock_in_id is not null then
SELECT a.LOGOUT_TIME into j_logout_time from SNDB_logged_in_data a where a.clock_in_id = i_clock_in_id ;
if j_logout_time is null then
update SNDB_logged_in_data a set a.logout_time = i_logout_time where a.clock_in_id = i_clock_in_id ;
dbms_output.put_line('Upadted the logged out time for the user');
end if;
SELECT b.logout_time into k_logout_time from SNDB_logged_in_data b where b.clock_in_id = i_clock_in_id;
if k_logout_time > i_logout_time then
raise logout_time_must_be_greater_than_previous_logout_time;
end if;
end if;
if j_clock_in_id is null then
raise user_not_logged_in;
end if;
exception
when user_not_logged_in then
dbms_output.put_line('User is not logged in');
when logout_time_must_be_greater_than_previous_logout_time then
dbms_output.put_line('logout time must be greater than previous logout time for a user');
end;

commit;
select * from sndb_addfriend_data;


   -- delete sndb_addfriend_data where friendship_id = 4;
create or replace procedure sndb_update_addfriend_data(i_friendship_id in sndb_addfriend_data.friendship_id%type,
i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, 
i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,
i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type)
as
j_status_id number;
j_logout_time timestamp;
j_approved_time timestamp;
status_id_did_not_change exception;
logout_time_cannot_be_less_than_approved_time exception;
approvedtime_cannot_greater_than_logout_time exception;
logouttime_cannot_be_null exception;
approvedtime_cannot_greater_than_logout_time_value exception;
enteredlogouttime_must_be_greater_than_approved_time exception;
begin
---fecthing table's status id
select a.status_id into j_status_id from sndb_addfriend_data a where a.friendship_id = i_friendship_id;
select d.logout_time into j_logout_time from sndb_addfriend_data d where d.friendship_id = i_friendship_id;
select e.approved_time into j_approved_time from sndb_addfriend_data e where e.friendship_id = i_friendship_id;
if j_logout_time is null then
--check if the table's status is 2 or 3 i.e. rejected or pending
if j_status_id = 1 and i_status_id in (2,3) then
if j_approved_time < i_logout_time then
update SNDB_ADDFRIEND_DATA b set b.status_id = i_status_id, b.approved_time = '' , b.status_updated_time = i_status_updated_time, b.logout_time = i_logout_time  where b.friendship_id = i_friendship_id;
dbms_output.put_line('Updated the user status, approved time, log out time  and status time');
else
raise approvedtime_cannot_greater_than_logout_time;
end if;
end if;
if j_status_id in (2,3) and i_status_id = 1 then
if i_logout_time is not null then
update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = i_approved_time ,c.status_updated_time = i_status_updated_time , c.logout_time = i_logout_time where c.friendship_id = i_friendship_id;
dbms_output.put_line('Updated the user status, approved time ,log out time and status time');
else
raise logouttime_cannot_be_null;
end if;
end if;
end if;
if j_logout_time is not null then
if j_status_id = 1 and i_status_id in (2,3) then
if j_approved_time < i_logout_time then
update SNDB_ADDFRIEND_DATA b set b.status_id = i_status_id, b.approved_time = '' , b.status_updated_time = i_status_updated_time, b.logout_time = i_logout_time  where b.friendship_id = i_friendship_id;
dbms_output.put_line('Updated the user status, approved time, log out time  and status time');
else
raise approvedtime_cannot_greater_than_logout_time_value;
end if;
end if;
if j_status_id in (2,3) and i_status_id = 1 then
update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = i_approved_time ,c.status_updated_time = i_status_updated_time , c.logout_time = i_logout_time where c.friendship_id = i_friendship_id;
dbms_output.put_line('Updated the user status, approved time ,log out time and status time');
end if;
end if;
if j_approved_time is null  and j_status_id in (2,3) then
update SNDB_ADDFRIEND_DATA e set e.status_id = i_status_id, e.approved_time = i_approved_time ,e.status_updated_time = i_status_updated_time , e.logout_time = i_logout_time where e.friendship_id = i_friendship_id;
end if;
if i_approved_time is not null and i_logout_time is not null then
if i_approved_time < i_logout_time then
update SNDB_ADDFRIEND_DATA f set f.approved_time = i_approved_time , f.logout_time = i_logout_time where f.friendship_id = i_friendship_id;
else
raise enteredlogouttime_must_be_greater_than_approved_time;
end if;
end if;
if j_status_id != i_status_id then
update SNDB_ADDFRIEND_DATA g set g.status_id = i_status_id,g.status_updated_time = i_status_updated_time , g.logout_time = i_logout_time where g.friendship_id = i_friendship_id;
end if;
--
--if j_approved_time > i_logout_time then
--raise approvedtime_cannot_greater_than_logout_time;
--end if;
--if j_logout_time is null and j_approved_time is null then

---if the log out time in the table is null and approved time is not null
--if j_logout_time is null and j_approved_time is not null then
--if j_approved_time < i_logout_time then
/*update SNDB_ADDFRIEND_DATA f set f.logout_time = i_logout_time where f.friendship_id = i_friendship_id;
dbms_output.put_line('Updated the user log out time');
else
raise logout_time_cannot_be_less_than_approved_time;
end if;
end if;*/
if j_status_id = i_status_id then
raise status_id_did_not_change;
end if;
exception
when status_id_did_not_change then
dbms_output.put_line('status id entered is same as the value present in the table');
when approvedtime_cannot_greater_than_logout_time then
dbms_output.put_line('logout time cannot be less than approved time');
when approvedtime_cannot_greater_than_logout_time_value then
dbms_output.put_line('logout time cannot be less than approved time');
when enteredlogouttime_must_be_greater_than_approved_time then
dbms_output.put_line('logout time entered cannot be less than entered approved time');
end;

begin
sndb_update_addfriend_data(5,1,current_timestamp+3,current_timestamp+1,current_timestamp);
end;
begin
sndb_update_addfriend_data(5,1,current_timestamp,current_timestamp+1,current_timestamp);
end;
begin
sndb_update_addfriend_data(5,3,'',current_timestamp+1,current_timestamp);
end;
SELECT * FROM sndb_addfriend_data;