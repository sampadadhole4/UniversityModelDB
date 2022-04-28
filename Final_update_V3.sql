----add_friend Update---
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
/
begin
sndb_update_addfriend_data(1,3,current_timestamp,current_timestamp-1,null);
end;


---group_message_update---
create or replace procedure SNDB_UPDATE_GROUP_MESSAGE(
i_group_message_PRI_id in SNDB_GROUP_MESSAGE.group_message_PRI_id%type,
i_Is_reminder in SNDB_GROUP_MESSAGE.Is_reminder%type,
i_reminder_freq_id in SNDB_GROUP_MESSAGE.reminder_freq_id%type
)
as
j_Next_reminder_date date;
j_Is_reminder varchar2(50);
j_reminder_freq_id number;
reminder_freq_id_cannot_be_null exception;
is_reminder_cannot_be_same exception;
same_freq_id_cannot_be_updated exception;
reminder_id_expiry_date_must_be_greater_than_group_created_date EXCEPTION;
group_message_id_cannot_be_null exception;
j_group_message_created_date date;
is_reminder_freq_is_null exception;
begin
if i_group_message_PRI_id is null then
raise group_message_id_cannot_be_null;
end if;
if i_Is_reminder is null or length(i_Is_reminder) = 0 then
raise is_reminder_freq_is_null;
end if;
IF i_reminder_freq_id is null then
raise reminder_freq_id_cannot_be_null;
end if;
select a.Is_reminder into j_Is_reminder from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.reminder_freq_id into j_reminder_freq_id from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
if j_Is_reminder != i_Is_reminder then
raise is_reminder_cannot_be_same;
end if;

if j_reminder_freq_id != i_reminder_freq_id then
 if i_reminder_freq_id = 1 then
  update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +1, e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
 dbms_output.put_line('upadted reminder freq id of 1 ,next reminder date,is reminder for a group');
  end if;
  
 if i_reminder_freq_id = 2 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +7 , e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
  dbms_output.put_line('upadted reminder freq id of 2 ,next reminder date,is reminder for a group');
 end if;
 
 if i_reminder_freq_id = 3 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +14 ,  e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
dbms_output.put_line('upadted reminder freq id of 3 ,next reminder date,is reminder for a group');
 end if;
 
 if i_reminder_freq_id = 4 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +30 ,e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
 dbms_output.put_line('upadted reminder freq id of 4 ,next reminder date, is reminder for a group');
 end if;
  else
 raise same_freq_id_cannot_be_updated;
 end if;
exception
when same_freq_id_cannot_be_updated then
dbms_output.put_line('same freq id cannot be updated');
when is_reminder_cannot_be_same then
dbms_output.put_line('same is_reminder cannot be updated');
when group_message_id_cannot_be_null then
dbms_output.put_line('group message pri id cannot be null');
when is_reminder_freq_is_null then
dbms_output.put_line('is reminder freq is null');
when reminder_freq_id_cannot_be_null then
dbms_output.put_line('reminder_freq_id_cannot_be_null');
WHEN others then
if sqlcode=-02290 then
dbms_output.put_line('1. reminder_id should be from the following list: ''YES'',''NO''');
end if;
end;
/

begin
SNDB_UPDATE_GROUP_MESSAGE(1,'YES',NULL);
end;
-----logged_in----
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
-----paymentRequest---
create or replace procedure SNDB_UPDATE_payment_request_data(
i_payment_request_id in SNDB_payment_request_data.payment_request_id%type,
i_request_status in SNDB_payment_request_data.request_status%type,
i_request_amount in SNDB_payment_request_data.request_amount%type,
i_payment_description in SNDB_payment_request_data.payment_description%type,
i_payment_date in SNDB_payment_request_data.payment_date%type,i_payment_method 
in SNDB_payment_request_data.payment_method%type)
as
j_request_status varchar2(50);
IS_NULL number;
j_payment_date date;
no_change_in_request_status exception;
payment_date_cannot_be_less_than_previous_transaction exception;
request_status_cannot_be_null exception;
request_ammount_cannot_be_blank exception;
payment_request_id_cannot_be_null exception;
payment_dtae_is_null exception;
payment_method_null exception;
begin
CHECK_NULL(i_payment_request_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE payment_request_id_cannot_be_null;
END IF;
if  i_request_status is null then
raise request_status_cannot_be_null;
end if;
If i_request_amount is null then
raise request_ammount_cannot_be_blank;
end if;
if i_payment_date is null then
raise payment_dtae_is_null;
end if;
if i_payment_method is null then
raise payment_method_null;
end if;
select d.request_status into j_request_status from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;
select d.payment_date into j_payment_date from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;

if j_request_status = i_request_status then
raise no_change_in_request_status;
end if;

if j_request_status != i_request_status then 
update SNDB_payment_request_data e set e.request_status = i_request_status, e.request_amount = i_request_amount,e.payment_description = i_payment_description ,  e.payment_date = i_payment_date where e.payment_request_id = i_payment_request_id;
dbms_output.put_line('request status, amount, payemnt description and payment date is updated');
end if;
--if i_payment_date >= j_payment_date then
--update SNDB_payment_request_data f set f.payment_date = i_payment_date where f.payment_request_id = i_payment_request_id; 
--dbms_output.put_line('payment_date is updated');
--else
--raise payment_date_cannot_be_less_than_previous_transaction;
--end if;

exception
when no_change_in_request_status then
dbms_output.put_line('request status id is same and please ebter the diffrent status id');
--when payment_date_cannot_be_less_than_previous_transaction then
--dbms_output.put_line('payment date cannot be less than previous transaction');
when request_status_cannot_be_null then
dbms_output.put_line('request status cannot be null');
when request_ammount_cannot_be_blank then
dbms_output.put_line('request ammount must have a value');
when payment_request_id_cannot_be_null then
dbms_output.put_line('payment request id must have a value');
when payment_dtae_is_null then
dbms_output.put_line('payment date is null, please enter a date');
when payment_method_null then
dbms_output.put_line('payment method  is null, please enter a payment method');
end;
/

