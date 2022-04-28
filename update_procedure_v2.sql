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

create or replace procedure sndb_update_addfriend_data(i_friendship_id in sndb_addfriend_data.friendship_id%type,
i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, 
i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,
i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type)
AS
j_status_id NUMBER;
j_logout_time TIMESTAMP;
j_approved_time TIMESTAMP;
status_id_did_not_change EXCEPTION;
j_status_updated_time TIMESTAMP;
logouttime_needs_to_be_greater_than_status_upadted_time EXCEPTION;
logouttime_must_be_grater_than_staus_upadted_time EXCEPTION;
status_upadted_time_cannot_be_less_than_approved_time exception;
BEGIN
select a.status_id into j_status_id from sndb_addfriend_data a where a.friendship_id = i_friendship_id;
select d.logout_time into j_logout_time from sndb_addfriend_data d where d.friendship_id = i_friendship_id;
select e.approved_time into j_approved_time from sndb_addfriend_data e where e.friendship_id = i_friendship_id;
select f.status_updated_time into j_status_updated_time from sndb_addfriend_data f where f.friendship_id = i_friendship_id;

IF j_status_id = i_status_id THEN
raise status_id_did_not_change;
end if;

IF i_status_id IN (2,3) THEN
update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = null ,  c.status_updated_time = i_status_updated_time where c.friendship_id = i_friendship_id;

if i_logout_time >= i_status_updated_time then
update SNDB_ADDFRIEND_DATA c set c.logout_time = i_logout_time where c.friendship_id = i_friendship_id;
else raise logouttime_needs_to_be_greater_than_status_upadted_time;
end if;

end if;

if i_status_id in (1) then
update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = i_approved_time where c.friendship_id = i_friendship_id;

if i_status_updated_time >= i_approved_time then
update SNDB_ADDFRIEND_DATA c set c.status_updated_time = i_status_updated_time where c.friendship_id = i_friendship_id;
else raise status_upadted_time_cannot_be_less_than_approved_time;
end if;

if i_logout_time >=i_status_updated_time then 
update SNDB_ADDFRIEND_DATA c set c.logout_time = i_logout_time where c.friendship_id = i_friendship_id;
else raise logouttime_must_be_grater_than_staus_upadted_time;
end if;

end if;


EXCEPTION
when status_id_did_not_change then
dbms_output.put_line('status id entered is same as the value present in the table');
when logouttime_needs_to_be_greater_than_status_upadted_time then
dbms_output.put_line('logouttime needs to be greater than status upadted time');
when status_upadted_time_cannot_be_less_than_approved_time then
dbms_output.put_line('status upadted time cannot be less than approved time');
when logouttime_must_be_grater_than_staus_upadted_time then
dbms_output.put_line('logouttime must be greater than staus upadted time');
END;
/

create or replace procedure SNDB_UPDATE_payment_request_data(
i_payment_request_id in SNDB_payment_request_data.payment_request_id%type,
i_request_status in SNDB_payment_request_data.request_status%type,
i_request_amount in SNDB_payment_request_data.request_amount%type,
i_payment_description in SNDB_payment_request_data.payment_description%type,
i_payment_date in SNDB_payment_request_data.payment_date%type,i_payment_method 
in SNDB_payment_request_data.payment_method%type)
as
j_request_status varchar2(50);
j_payment_date date;
no_change_in_request_status exception;
payment_date_cannot_be_less_than_previous_transaction exception;
begin
select d.request_status into j_request_status from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;
select d.payment_date into j_payment_date from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;

if j_request_status = i_request_status then
raise no_change_in_request_status;
end if;

if j_request_status != i_request_status then 
update SNDB_payment_request_data e set e.request_status = i_request_status, e.request_amount = i_request_amount,e.payment_description = i_payment_description where e.payment_request_id = i_payment_request_id;
dbms_output.put_line('request status, amount, payemnt description is updated');
end if;
if i_payment_date >= j_payment_date then
update SNDB_payment_request_data f set f.payment_date = i_payment_date where f.payment_request_id = i_payment_request_id; 
dbms_output.put_line('payment_date is updated');
else
raise payment_date_cannot_be_less_than_previous_transaction;
end if;

exception
when no_change_in_request_status then
dbms_output.put_line('request status id is same and please ebter the diffrent status id');
when payment_date_cannot_be_less_than_previous_transaction then
dbms_output.put_line('payment date cannot be less than previous transaction');
end;
/

create or replace procedure SNDB_UPDATE_GROUP_MESSAGE( i_group_message_PRI_id in SNDB_GROUP_MESSAGE.group_message_PRI_id%type
,i_subject in SNDB_GROUP_MESSAGE.subject%type,
i_group_message_content in SNDB_GROUP_MESSAGE.group_message_content%type,
i_Is_reminder in SNDB_GROUP_MESSAGE.Is_reminder%type,
i_Next_reminder_date in SNDB_GROUP_MESSAGE.Next_reminder_date%type,
i_reminder_freq_id in SNDB_GROUP_MESSAGE.reminder_freq_id%type,
i_reminder_expiry_date in SNDB_GROUP_MESSAGE.reminder_expiry_date%type,
i_group_message_status in SNDB_GROUP_MESSAGE.group_message_status%type)
as
j_Next_reminder_date date;
j_Is_reminder varchar2(50);
j_reminder_freq_id number;
is_reminder_cannot_be_same exception;
same_freq_id_cannot_be_updated exception;
j_group_message_status varchar2(50);
same_group_message_status EXCEPTION;
begin
select a.Is_reminder into j_Is_reminder from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.Next_reminder_date into j_Next_reminder_date from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.reminder_freq_id into j_reminder_freq_id from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.group_message_status into j_group_message_status from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
Update SNDB_GROUP_MESSAGE a set a.subject = i_subject,a.group_message_content= i_group_message_content where a.group_message_PRI_id = i_group_message_PRI_id;
dbms_output.put_line('subject and message_conetnt of the group is updated');
if j_Is_reminder != i_Is_reminder then
update SNDB_GROUP_MESSAGE b set b.Is_reminder = i_Is_reminder where b.group_message_PRI_id = i_group_message_PRI_id;
else raise is_reminder_cannot_be_same;
end if;
if j_group_message_status != i_group_message_status then
update SNDB_GROUP_MESSAGE b set b.group_message_status = i_group_message_status where b.group_message_PRI_id = i_group_message_PRI_id;
else raise same_group_message_status;
end if;
if j_reminder_freq_id != i_reminder_freq_id then
 if i_reminder_freq_id = 1 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +1 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 2 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +7 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 3 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +14 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 4 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +30 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 else raise same_freq_id_cannot_be_updated;
 end if;
exception
when same_freq_id_cannot_be_updated then
dbms_output.put_line('same freq id cannot be updated');
when is_reminder_cannot_be_same then
dbms_output.put_line('same is_reminder cannot be updated');
when same_group_message_status then
dbms_output.put_line('same group message status cannot be updated');
end;
/





create or replace procedure sndb_update_addfriend_data(i_friendship_id in sndb_addfriend_data.friendship_id%type,
i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, 
i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,
i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type)
AS
j_status_id NUMBER;
j_logout_time TIMESTAMP;
j_approved_time TIMESTAMP;
status_id_did_not_change EXCEPTION;
j_status_updated_time TIMESTAMP;
logouttime_needs_to_be_greater_than_status_upadted_time EXCEPTION;
logouttime_must_be_grater_than_staus_upadted_time EXCEPTION;
status_upadted_time_cannot_be_less_than_approved_time exception;
status_upadted_time_and_logout_time_cannot_be_less_than_approved_time exception;
BEGIN
select a.status_id into j_status_id from sndb_addfriend_data a where a.friendship_id = i_friendship_id;
select d.logout_time into j_logout_time from sndb_addfriend_data d where d.friendship_id = i_friendship_id;
select e.approved_time into j_approved_time from sndb_addfriend_data e where e.friendship_id = i_friendship_id;
select f.status_updated_time into j_status_updated_time from sndb_addfriend_data f where f.friendship_id = i_friendship_id;

IF j_status_id = i_status_id THEN
raise status_id_did_not_change;
end if;

IF i_status_id IN (2,3) THEN
--update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = null ,  c.status_updated_time = i_status_updated_time where c.friendship_id = i_friendship_id;
--DBMS_OUTPUT.put_line('upadted status id,approved time and satus updated time for the user1111111111111111');
if i_logout_time >= i_status_updated_time then
update SNDB_ADDFRIEND_DATA c set c.logout_time = i_logout_time 
, c.status_id = i_status_id, c.approved_time = null ,  c.status_updated_time = i_status_updated_time
where c.friendship_id = i_friendship_id;
--DBMS_OUTPUT.put_line('upadted status id,approved time and satus updated time, log out time for the user2222222222222222222222');
else raise logouttime_needs_to_be_greater_than_status_upadted_time;
end if;

end if;

if i_status_id in (1) then
--update SNDB_ADDFRIEND_DATA c set c.status_id = i_status_id, c.approved_time = i_approved_time where c.friendship_id = i_friendship_id;
DBMS_OUTPUT.put_line('upadted status id,approved time for the user');
if i_status_updated_time >= i_approved_time then
--update SNDB_ADDFRIEND_DATA c set c.status_updated_time = i_status_updated_time where c.friendship_id = i_friendship_id;
DBMS_OUTPUT.put_line('upadted satus updation time for the user');
DBMS_OUTPUT.put_line( 'i_logout_time' || i_logout_time || 'i_status_updated_time ' || i_status_updated_time|| 1111111111111111155555 || ' ' ||i_approved_time);
--else raise status_upadted_time_cannot_be_less_than_approved_time;
DBMS_OUTPUT.put_line( 'i_logout_time' || i_logout_time || 'i_status_updated_time ' || i_status_updated_time);
if i_logout_time >=i_status_updated_time then 

DBMS_OUTPUT.put_line( 'i_logout_time' || i_logout_time || 'i_status_updated_time ' || i_status_updated_time|| 333333333333333333333);
DBMS_OUTPUT.put_line(11111111111111);
update SNDB_ADDFRIEND_DATA c set c.logout_time = i_logout_time ,  c.status_id = i_status_id, 
c.approved_time = i_approved_time ,c.status_updated_time = i_status_updated_time where c.friendship_id = i_friendship_id;
DBMS_OUTPUT.put_line('upadted status id, approved time , status upadted time and log out time for the user444444444444444444');
else raise logouttime_must_be_grater_than_staus_upadted_time;
end if;
else raise status_upadted_time_cannot_be_less_than_approved_time;
end if;
end if;
if i_status_id = 1 and i_status_updated_time < i_approved_time and i_logout_time < i_status_updated_time then
raise status_upadted_time_and_logout_time_cannot_be_less_than_approved_time;
end if;
EXCEPTION
when status_id_did_not_change then
dbms_output.put_line('status id entered is same as the value present in the table');
when logouttime_needs_to_be_greater_than_status_upadted_time then
dbms_output.put_line('logouttime needs to be greater than status upadted time');
when status_upadted_time_cannot_be_less_than_approved_time then
dbms_output.put_line('status upadted time cannot be less than approved time');
when logouttime_must_be_grater_than_staus_upadted_time then
dbms_output.put_line('logouttime must be greater than staus upadted time  ');
END;
/