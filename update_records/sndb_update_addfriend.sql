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
frienship_id_is_null exception;
status_id_is_null exception;
begin
---fecthing table's status id
if i_friendship_id is null
then raise frienship_id_is_null;
end if;
if i_status_id is null
then raise status_id_is_null ;
end if;
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
when frienship_id_is_null then
dbms_output.put_line('frienship id must not be null');
when status_id_is_null then
dbms_output.put_line('status id is must not be null');
end;

begin
sndb_update_addfriend_data(4,3,current_timestamp,current_timestamp-1,null);
end;