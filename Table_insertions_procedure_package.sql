
CREATE OR REPLACE PACKAGE INSERTIONS
    AS    
        PROCEDURE CHECK_NULL (I_FIELD IN CHAR, IS_NULL OUT NUMBER);
        PROCEDURE ADD_ROLES(i_ROLE_NAME in SNDB_user_roles_data.role_name%type, i_ROLE_DESCRIPTION in sndb_user_roles_data.role_description%TYPE);
        PROCEDURE ADD_USER_LOGIN(i_username in SNDB_user_login.username%type, i_password in SNDB_user_login.password%TYPE, i_user_type in SNDB_user_login.user_type%TYPE);
        PROCEDURE ADD_GENDER_DATA(i_name in SNDB_gender_data.name%type);
        PROCEDURE SNDB_ADD_user_account(I_user_id in SNDB_user_account.user_id%type, I_first_name in SNDB_user_account.first_name%type,I_last_name in SNDB_user_account.last_name%type,I_email_id in SNDB_user_account.email_id%type,I_phone_number IN SNDB_user_account.phone_number%type, I_university_name IN SNDB_user_account.university_name%type, I_college_name IN SNDB_user_account.college_name%type,I_course_name in SNDB_user_account.course_name%type,I_gender_id in SNDB_user_account.gender_id%type,I_dob in SNDB_user_account.dob%type,I_otp in SNDB_user_account.otp%type,I_created_at in SNDB_user_account.created_at%type );
        PROCEDURE SNDB_ADD_PHOTO_DATA(i_user_account_id in SNDB_USER_PHOTO_DATA.user_account_id%type,i_photo_link in SNDB_USER_PHOTO_DATA.photo_link%type, i_time_added in SNDB_USER_PHOTO_DATA.time_added%type,i_photo_visibility in SNDB_USER_PHOTO_DATA.photo_visibility%type);
        PROCEDURE SNDB_ADD_POST_DATA(i_subject in SNDB_POST_DATA.subject%type,i_content in SNDB_POST_DATA.content%type,i_user_id in SNDB_POST_DATA.user_id%type);
        PROCEDURE SNDB_ADD_votes_data(i_post_id in SNDB_votes_data.post_id%type,i_upcount in SNDB_votes_data.upcount%type,i_downcount in SNDB_votes_data.downcount%type);
        PROCEDURE SNDB_ADD_logged_in_data(i_user_logged_id in SNDB_logged_in_data.user_logged_id%type,i_login_time in SNDB_logged_in_data.login_time%type,i_logout_time in SNDB_logged_in_data.logout_time%type);
        PROCEDURE SNDB_ADD_STATUS_DATA(i_status_type in SNDB_STATUS.status_type%type);
        PROCEDURE SNDB_ADD_FRIEND_DATA(i_requester_id in SNDB_ADDFRIEND_DATA.requester_id%type,i_addressee_id in SNDB_ADDFRIEND_DATA.addressee_id%type,i_created_datetime in SNDB_ADDFRIEND_DATA.created_datetime%type,i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,i_Status_comment in SNDB_ADDFRIEND_DATA.Status_comment%type,i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type);
        PROCEDURE SNDB_ADD_SNDB_conversation_data(I_conversation_id in SNDB_conversation_data.conversation_id%type,I_conversation_initiated_id in SNDB_conversation_data.conversation_initiated_id%type,I_conversation_started in SNDB_conversation_data.conversation_started%type,I_conversation_ended in SNDB_conversation_data.conversation_ended%type,I_participant_id in SNDB_conversation_data.participant_id%type);
        procedure SNDB_ADD_GROUP(i_group_name in sndb_group.group_name%type,i_created_date in sndb_group.created_date%type, i_is_group_active in sndb_group.is_group_active%type);
        PROCEDURE SNDB_ADD_message_data(i_messsage_content in SNDB_message_data.messsage_content%type,i_message_timestamp in SNDB_message_data.message_timestamp%type,i_conversation_id in SNDB_message_data.conversation_id%type,i_from_message_id in SNDB_message_data.from_message_id%type,i_to_message_id in SNDB_message_data.to_message_id%type,i_IS_PAYMENT_REQUESTED in SNDB_message_data.IS_PAYMENT_REQUESTED%type);
        PROCEDURE SNDB_ADD_payment_request_data(i_requester_id in SNDB_payment_request_data.requester_id%type,i_reciever_id in SNDB_payment_request_data.reciever_id%type,i_request_status in SNDB_payment_request_data.request_status%type,i_request_amount in SNDB_payment_request_data.request_amount%type,i_payment_description in SNDB_payment_request_data.payment_description%type,i_payment_date in SNDB_payment_request_data.payment_date%type,i_payment_method in SNDB_payment_request_data.payment_method%type,i_Message_id in SNDB_payment_request_data.Message_id%type);
        PROCEDURE SNDB_ADD_user_account_group(i_user_account_id in SNDB_user_account_group.user_account_id%type, i_user_group_id in SNDB_user_account_group.group_id%type);

        procedure SNDB_add_group_recipient(i_group_id_recipientdata in SNDB_group_recipient.group_id%type,i_user_id_recipientdata in SNDB_group_recipient.user_id%type, i_created_date_recipient in SNDB_group_recipient.created_date%type,i_is_group_active_recipient in SNDB_group_recipient.is_group_active%type);

        procedure SNDB_add_reminder_freq(i_freq_type in SNDB_reminder_freq.freq_type%type, i_is_active in SNDB_reminder_freq.is_active%type);


    END INSERTIONS;
/

CREATE OR REPLACE PACKAGE BODY INSERTIONS
AS

   PROCEDURE CHECK_NULL (I_FIELD IN CHAR, IS_NULL OUT NUMBER)
AS

BEGIN
IF I_FIELD is null or length(I_FIELD) =0 THEN
IS_NULL:=1;
ELSE
IS_NULL:=0;
END IF;
END CHECK_NULL;


    procedure ADD_ROLES(i_ROLE_NAME in SNDB_user_roles_data.role_name%type, i_ROLE_DESCRIPTION in sndb_user_roles_data.role_description%TYPE )
as
i_role_id  number;
role_count number;
ex_invalid_role_name exception;
Role_Already_Exists exception;
begin

if i_ROLE_NAME is null or length(i_ROLE_NAME) =0
then 
raise ex_invalid_role_name;
end if;

select count (*) into role_count from SNDB_user_roles_data where role_name = i_ROLE_NAME;
if role_count>0 then
raise Role_Already_Exists;
else
i_role_id := sndb_role_id_seq.nextval;
insert into SNDB_user_roles_data (
role_id,
ROLE_NAME,
ROLE_DESCRIPTION
)
values
(i_role_id,
i_ROLE_NAME,
i_ROLE_DESCRIPTION
);
dbms_output.put_line('Role '||i_ROLE_NAME|| ' Created Successfully!');
end if;
exception
when ex_invalid_role_name then
dbms_output.put_line('role_name cannot be null');

when Role_Already_Exists then
dbms_output.put_line('Role Already exists');

end add_roles;


PROCEDURE ADD_USER_LOGIN(i_username in SNDB_user_login.username%type, i_password in SNDB_user_login.password%TYPE, i_user_type in SNDB_user_login.user_type%TYPE)
as
j_user_login_id Number;
user_count  number;
password_count number;
User_name_exists exception;
password_exists exception;
i_user_login_id number;
j_user_type varchar2(50);

begin

select count (*) into user_count from SNDB_user_login where username = i_username;
select count (*) into password_count from SNDB_user_login where SNDB_user_login.password = i_password;
if user_count>0 then
raise User_name_exists;
end if;

if password_count>0 then
raise password_exists;
end if;

if user_count=0 then
i_user_login_id:= sndb_user_login_seq.nextval;

insert into SNDB_user_login(	
       user_login_id,
       username,
       password,
       user_type
       )
values (
i_user_login_id,
i_username,
i_password,
i_user_type
);

dbms_output.put_line('User '||i_username|| ' login Successful!');
end if;

Exception
when User_name_exists then
dbms_output.put_line('username Already in use, Enter valid username');
when password_exists Then
dbms_output.put_line('Password Already in use, Enter valid password');

end ADD_USER_LOGIN;

PROCEDURE ADD_USER_LOGIN(i_name in SNDB_gender_data.name%type)
AS
j_gender_id number;
GENDER_EXISTS EXCEPTION;
GENDER_count NUMBER;
BEGIN
select count (*) into GENDER_count from SNDB_gender_data where name = i_name;
IF GENDER_count>0 THEN
RAISE GENDER_EXISTS;

ELSE
j_gender_id:=sndb_gender_data_seq.nextval;
INSERT INTO SNDB_gender_data(
gender_id,
name)
values(
j_gender_id,
i_name);
dbms_output.put_line('GENDER '||i_name|| ' added Successfully!');
END IF;
EXCEPTION
when GENDER_EXISTS THEN
dbms_output.put_line('GENDER '||i_name|| ' already exists.');
END ADD_USER_LOGIN;


PROCEDURE ADD_GENDER_DATA(i_name in SNDB_gender_data.name%type)
AS
j_gender_id number;
GENDER_EXISTS EXCEPTION;
GENDER_count NUMBER;
BEGIN
select count (*) into GENDER_count from SNDB_gender_data where name = UPPER(i_name);
IF GENDER_count>0 THEN
RAISE GENDER_EXISTS;

ELSE
j_gender_id:=sndb_gender_data_seq.nextval;
INSERT INTO SNDB_gender_data(
gender_id,
name)
values(
j_gender_id,
upper(i_name));
dbms_output.put_line('GENDER '||i_name|| ' added Successfully!');
END IF;
EXCEPTION
when GENDER_EXISTS THEN
dbms_output.put_line('GENDER '||i_name|| ' already exists.');
WHEN others then
if sqlcode=-02290 then
dbms_output.put_line('Gender should be from the following list: ''MALE'',''FEMALE'',''OTHERS''');
END IF;
END ADD_GENDER_DATA;

PROCEDURE SNDB_ADD_user_account(I_user_id in SNDB_user_account.user_id%type, I_first_name in SNDB_user_account.first_name%type,I_last_name in SNDB_user_account.last_name%type,I_email_id in SNDB_user_account.email_id%type,I_phone_number IN SNDB_user_account.phone_number%type, I_university_name IN SNDB_user_account.university_name%type, I_college_name IN SNDB_user_account.college_name%type,I_course_name in SNDB_user_account.course_name%type,I_gender_id in SNDB_user_account.gender_id%type,I_dob in SNDB_user_account.dob%type,I_otp in SNDB_user_account.otp%type,I_created_at in SNDB_user_account.created_at%type )
AS
j_user_account_id number;
IS_NULL NUMBER;
USER_ID_EXISTS EXCEPTION;
USER_ID_count NUMBER;
USER_ID_from_login NUMBER;
gender_ID_from_gender_data NUMBER;
EMAIL_ID_COUNT NUMBER;
PHONE_NUM_COUNT NUMBER;
FIRST_NAME_IS_NULL EXCEPTION;
LAST_NAME_IS_NULL EXCEPTION;
OTP_IS_NULL EXCEPTION;
USER_ID_DOESNT_EXISTS_IN_LOGIN_TABLE EXCEPTION;
GENDER_ID_DOESNT_EXISTS_IN_GENDER_TABLE EXCEPTION;
EMAIL_ID_EXISTS EXCEPTION;
PHONE_NUM_EXISTS EXCEPTION;
INVALID_PHONE_NUM_LENGTH EXCEPTION;
INVALID_EMAIL_FORMAT EXCEPTION;
BEGIN

select count (*) into USER_ID_from_login from SNDB_user_login b where b.user_login_id=i_user_id;
if USER_ID_from_login =0 then
raise USER_ID_DOESNT_EXISTS_IN_LOGIN_TABLE;
END IF;
select count (*) into gender_ID_from_gender_data from SNDB_gender_data b where b.gender_id=I_gender_id;
if gender_ID_from_gender_data =0 then
raise GENDER_ID_DOESNT_EXISTS_IN_GENDER_TABLE;
END IF;

select count (*) into EMAIL_ID_COUNT from SNDB_user_account b where b.email_id=I_email_id;
if EMAIL_ID_COUNT > 0 then
raise EMAIL_ID_EXISTS;
END IF;
select count (*) into PHONE_NUM_COUNT from SNDB_user_account b where b.phone_number=I_phone_number;
if PHONE_NUM_COUNT > 0 then
raise PHONE_NUM_EXISTS;
END IF;

CHECK_NULL(I_first_name,IS_NULL);
IF IS_NULL = 1 THEN
RAISE FIRST_NAME_IS_NULL;
END IF;

CHECK_NULL(I_last_name,IS_NULL);
IF IS_NULL = 1 THEN
RAISE LAST_NAME_IS_NULL;
END IF;

CHECK_NULL(I_otp,IS_NULL);
IF IS_NULL = 1 THEN
RAISE OTP_IS_NULL;
END IF;

IF LENGTH(TRIM(I_phone_number))>10 THEN
RAISE INVALID_PHONE_NUM_LENGTH;
END IF;

if NOT REGEXP_LIKE (I_email_id,'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') then
RAISE INVALID_EMAIL_FORMAT;
END IF;


select count (*) into USER_ID_count from SNDB_user_account where user_id = i_user_id;
IF USER_ID_count>0 THEN
RAISE USER_ID_EXISTS;
ELSE
j_user_account_id:=sndb_user_account_id_seq.nextval;
INSERT INTO SNDB_user_account(
 user_account_id,
       user_id,
      first_name,
      last_name,
      email_id,
      phone_number,
      university_name,
      college_name,
      course_name,
      gender_id,
      dob,
      otp,
      created_at )
values(
j_user_account_id,
I_user_id,
upper(I_first_name),
upper(I_last_name),
I_email_id,
I_phone_number,
upper(I_university_name),
upper(I_college_name),
upper(I_course_name),
I_gender_id,
I_dob,
I_otp,
I_created_at

);
dbms_output.put_line('User_Account '||I_user_id|| ' added Successfully!');
END IF;
EXCEPTION
WHEN USER_ID_DOESNT_EXISTS_IN_LOGIN_TABLE THEN
dbms_output.put_line('User_id '||I_user_id|| ' entered does not exists in user_login table.');
dbms_output.put_line('Enter valid parent key ID');
WHEN GENDER_ID_DOESNT_EXISTS_IN_GENDER_TABLE THEN
dbms_output.put_line('GENDER_ID '||I_gender_id|| ' entered does not exists in GENDER DATA table.');
dbms_output.put_line('Enter valid parent key ID');
WHEN FIRST_NAME_IS_NULL THEN
dbms_output.put_line('FIRST NAME CANNOT BE NULL. ENTER VALID FIRST NAME');
WHEN LAST_NAME_IS_NULL THEN
dbms_output.put_line('LAST NAME CANNOT BE NULL. ENTER VALID LAST NAME');
WHEN OTP_IS_NULL THEN
dbms_output.put_line('OTP CANNOT BE NULL. ENTER VALID OTP');
when USER_ID_EXISTS THEN
dbms_output.put_line('User_id '||I_user_id|| ' already exists.');
when EMAIL_ID_EXISTS THEN
dbms_output.put_line('EMAIL ID '||I_email_id|| ' already used. Enter unique value.');
WHEN INVALID_EMAIL_FORMAT THEN
dbms_output.put_line('EMAIL ID '||I_email_id|| ' ENTERED IS NOT IN VALID FORMAT');
dbms_output.put_line('Enter valid EMAIL ADDRESS');
when PHONE_NUM_EXISTS THEN
dbms_output.put_line('Phone Number'||I_phone_number|| ' already used. Enter unique value.');
WHEN INVALID_PHONE_NUM_LENGTH THEN
dbms_output.put_line('Phone Number'||I_phone_number|| 'entered has more than 10 digits.');
dbms_output.put_line('Enter valid phone number');
END SNDB_ADD_user_account;

PROCEDURE SNDB_ADD_PHOTO_DATA(i_user_account_id in SNDB_USER_PHOTO_DATA.user_account_id%type,
i_photo_link in SNDB_USER_PHOTO_DATA.photo_link%type, i_time_added in SNDB_USER_PHOTO_DATA.time_added%type,
i_photo_visibility in SNDB_USER_PHOTO_DATA.photo_visibility%type)
AS
i_photo_id number;
i_username varchar2(50);
PROFILE_PHOTO_EXISTS EXCEPTION;
Photo_count NUMBER;
BEGIN
select count (*) into Photo_count from SNDB_USER_PHOTO_DATA where user_account_id = i_user_account_id;
select username into i_username from sndb_user_login c where c.user_login_id= i_user_account_id;
IF Photo_count>0 THEN
RAISE PROFILE_PHOTO_EXISTS;
ELSE
i_photo_id:=SNDB_USER_PHOTO_DATA_SEQ.nextval;
INSERT INTO SNDB_USER_PHOTO_DATA(
PHOTO_id,
user_account_id,
photo_link,
time_added,
photo_visibility
)
values(
i_photo_id,
i_user_account_id,
i_photo_link,
i_time_added,
i_photo_visibility
)
;
dbms_output.put_line('Photo of '||i_username|| ' added Successfully!');
END IF;
EXCEPTION
when PROFILE_PHOTO_EXISTS THEN
dbms_output.put_line('Photo for '||i_username|| ' already exists.');
END SNDB_ADD_PHOTO_DATA;

PROCEDURE SNDB_ADD_POST_DATA(i_subject in SNDB_POST_DATA.subject%type,
i_content in SNDB_POST_DATA.content%type,
i_user_id in SNDB_POST_DATA.user_id%type)
as
j_post_id Number;
user_id_count_from_user_account number;
user_id_doesnt_exists_in_user_Account exception;

begin

select count (*) into user_id_count_from_user_account from SNDB_USER_ACCOUNT a where a.user_id = i_user_id;
if user_id_count_from_user_account =0 then
raise user_id_doesnt_exists_in_user_Account;
end if;


j_post_id:= SNDB_POST_DATA_SEQ.nextval;

insert into SNDB_POST_DATA(	
         post_id,
       subject,
       content,
       user_id
       )
values (
j_post_id,
i_subject,
i_content,
i_user_id
);

dbms_output.put_line('User Photo for user_id '||i_user_id|| ' added successfully!');

Exception
when user_id_doesnt_exists_in_user_Account then
dbms_output.put_line('No user exsists with user_id '||i_user_id ||' in user_account table');
dbms_output.put_line('Enter valid parent key values');

END SNDB_ADD_POST_DATA;


PROCEDURE SNDB_ADD_votes_data(i_post_id in SNDB_votes_data.post_id%type,
i_upcount in SNDB_votes_data.upcount%type,
i_downcount in SNDB_votes_data.downcount%type)
as
j_VOTE_ID Number;
POST_id_count_from_POST_DATA number;
POST_id_doesnt_exists_in_POST_DATA exception;

begin

select count (*) into POST_id_count_from_POST_DATA from SNDB_POST_DATA a where a.POST_ID = i_post_id;
if POST_id_count_from_POST_DATA =0 then
raise POST_id_doesnt_exists_in_POST_DATA;
end if;



j_VOTE_ID:= SNDB_VOTE_DATA_SEQ.nextval;

insert into SNDB_votes_data(	
     vote_id,
       post_id,
       upcount,
       downcount
       )
values (
j_VOTE_ID,
i_post_id,
i_upcount,
i_downcount 
);

dbms_output.put_line('VOTES DATA for POST_id '||i_post_id|| ' added successfully!');

Exception
when POST_id_doesnt_exists_in_POST_DATA then
dbms_output.put_line('No POST exsists with post_id '||i_post_id ||' in POST_DATA TABLE');
dbms_output.put_line('Enter valid parent key values');

END SNDB_ADD_votes_data;


PROCEDURE SNDB_ADD_logged_in_data(i_user_logged_id in SNDB_logged_in_data.user_logged_id%type,
i_login_time in SNDB_logged_in_data.login_time%type,
i_logout_time in SNDB_logged_in_data.logout_time%type)
as
j_clock_in_id Number;
V_CLOCKED_ID number;
user_id_FROM_user_account number;
VAR_LOG_OUT_TIME TIMESTAMP;
USER_id_doesnt_exists_in_USER_ACCOUNT_TABLE exception;
USER_ALREADY_HAS_ACTIVE_LOGIN EXCEPTION;
begin

select count (*) into user_id_FROM_user_account from SNDB_USER_ACCOUNT a where a.user_id = i_user_logged_id;
if user_id_FROM_user_account =0 then
raise USER_id_doesnt_exists_in_USER_ACCOUNT_TABLE;
end if;

SELECT COUNT(*) INTO V_CLOCKED_ID FROM sndb_logged_in_data a WHERE a.user_logged_id =i_user_logged_id;
 IF V_CLOCKED_ID >0 THEN
     select (LOGOUT_TIME) into VAR_LOG_OUT_TIME
  from ( select a.LOGOUT_TIME
              , row_number() over ( order by a.user_logged_id desc ) as row_num
           from SNDB_logged_in_data a ) ;     
           if VAR_LOG_OUT_TIME is null then
          raise USER_ALREADY_HAS_ACTIVE_LOGIN;
          
ELSIF VAR_LOG_OUT_TIME >= i_login_time  then
RAISE USER_ALREADY_HAS_ACTIVE_LOGIN;
else
j_clock_in_id:= SNDB_LOGGED_IN_ID_SEQ.nextval;

insert into SNDB_logged_in_data(	
    clock_in_id,
       user_logged_id,
       login_time,
       logout_time
       )
values (
j_clock_in_id,
i_user_logged_id,
i_login_time,
i_logout_time
);

dbms_output.put_line('USER LOGGED IN DATA FOR USER ID '||i_user_logged_id|| ' added successfully!');
end if;
else
j_clock_in_id:= SNDB_LOGGED_IN_ID_SEQ.nextval;

insert into SNDB_logged_in_data(	
    clock_in_id,
       user_logged_id,
       login_time,
       logout_time
       )
values (
j_clock_in_id,
i_user_logged_id,
i_login_time,
i_logout_time
);

dbms_output.put_line('USER LOGGED IN DATA FOR USER ID '||i_user_logged_id|| ' added successfully!');
end if;
Exception
when USER_id_doesnt_exists_in_USER_ACCOUNT_TABLE then
dbms_output.put_line('NO USER EXISTS WITH USER ID '||i_user_logged_id ||' IN USER_ACCOUNT_TABLE');
dbms_output.put_line('Enter valid parent key values');
WHEN USER_ALREADY_HAS_ACTIVE_LOGIN THEN
dbms_output.put_line('USER '||i_user_logged_id||' ALREADY HAS AN ACTIVE LOGIN, CANNOT START NEW LOGIN');
END SNDB_ADD_logged_in_data;


PROCEDURE SNDB_ADD_STATUS_DATA(i_status_type in SNDB_STATUS.status_type%type)
AS
i_status_id number;
Status_EXISTS EXCEPTION;
status_count NUMBER;
i_status varchar2(50);
BEGIN
select count (*) into status_count from SNDB_STATUS where status_type = i_status_type;
IF status_count>0 THEN
RAISE Status_EXISTS;
ELSE
i_status_id:=SNDB_STATUS_seq.nextval;
INSERT INTO SNDB_STATUS(
status_id,
status_type)
values(
i_status_id,
i_status_type);
dbms_output.put_line('Status '||i_status_type|| ' added Successfully!');
END IF;
EXCEPTION
when Status_EXISTS THEN
dbms_output.put_line('Status '||i_status_type|| ' already exists.');
WHEN others then
if sqlcode=-02290 then
dbms_output.put_line('Status should be from the following list: ''Accepted'',''Rejected'',''Pending''');
END IF;
END SNDB_ADD_STATUS_DATA;


PROCEDURE SNDB_ADD_FRIEND_DATA(i_requester_id in SNDB_ADDFRIEND_DATA.requester_id%type,
i_addressee_id in SNDB_ADDFRIEND_DATA.addressee_id%type,i_created_datetime in SNDB_ADDFRIEND_DATA.created_datetime%type,
i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,
i_Status_comment in SNDB_ADDFRIEND_DATA.Status_comment%type,i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,
i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type)
AS
i_friendship_id number;
IS_NULL number;
i_User_name varchar2(50);
i_user_FRIEND NUMBER;
i_user number;
i_user_id number;
i_user_friend_id number;
UNIQUE_ID varchar2(50);
--user_exists EXCEPTION;
Userid_not_valid EXCEPTION;
friendid_not_valid EXCEPTION;
requester_id_is_null EXCEPTION;
friend_id_is_null EXCEPTION;
status_id_is_not_valid Exception;
status_id_is_null EXCEPTION;
alreadyfriends EXCEPTION;
same_user_id exception;
user_count NUMBER;
i_statusid number;
i_username varchar2(50);
i_friend number;
new_req_add_id number;
req_add_id number;
BEGIN
select count (*) into i_user_id from sndb_user_account b where b.user_id =i_requester_id;
if i_user_id =0 then
raise Userid_not_valid;
END IF;
select count (*) into i_user_friend_id from sndb_user_account b where b.user_id =i_addressee_id;
if i_user_friend_id =0 then
raise friendid_not_valid;
END IF;
select username into i_username from sndb_user_login c where c.user_login_id= i_requester_id;
select count (*) into i_statusid from sndb_status b where b.status_id =i_status_id;
if i_statusid =0 then
raise status_id_is_not_valid;
END IF;
CHECK_NULL(i_requester_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE requester_id_is_null;
END IF;
CHECK_NULL(i_addressee_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE friend_id_is_null;
END IF;
CHECK_NULL(i_status_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE status_id_is_null;
END IF;
select count (*) into i_user from sndb_user_account b where b.user_id =i_requester_id;
select b.user_id into i_user from sndb_user_account b where b.user_id =i_requester_id;
select b.user_id into i_user_FRIEND from sndb_user_account b where b.user_id =i_addressee_id; 
select count (*) into i_friend from sndb_user_account b where b.user_id =i_addressee_id;
--select concat(b.requester_id,b.addressee_id) into req_add_id from sndb_addfriend_data b where b.requester_id = i_requester_id and b.addressee_id = i_addressee_id;
-- concat(i_requester_id,i_addressee_id) into new_req_add_id from sndb_addfriend_data  where b.requester_id = i_requester_id and b.addressee_id = i_addressee_id;
select count(*) into unique_id from sndb_addfriend_data b where (b.requester_id = i_requester_id and b.addressee_id = i_addressee_id) or ( b.addressee_id = i_requester_id  and b.requester_id = i_addressee_id);
if unique_id > 0  then
raise alreadyfriends;
end if;
IF i_user_FRIEND = i_user THEN
RAISE same_user_id;
ELSE
i_friendship_id:=SNDB_ADDFRIEND_DATA_Seq.nextval;
INSERT INTO SNDB_ADDFRIEND_DATA(
friendship_id,
requester_id,
addressee_id,
created_datetime,
status_id,
logout_time,
Status_comment,
approved_time,
status_updated_time
)
values(
i_friendship_id,
i_requester_id,
i_addressee_id,
i_created_datetime,
i_status_id,
i_logout_time,
i_Status_comment,
i_approved_time,
i_status_updated_time
)
;
dbms_output.put_line('Friend of '||i_username|| ' added Successfully!');
END IF;
EXCEPTION
when Userid_not_valid THEN
dbms_output.put_line('User_id '||i_requester_id || ' entered does not match the user_account table dataset.');
dbms_output.put_line('requester user id does not in addfriend table');
when friendid_not_valid then
dbms_output.put_line('friendid '||i_addressee_id|| ' entered does not match the user_account table datasets.');
dbms_output.put_line('addressee user id does not in addfriend table');
when alreadyfriends then
dbms_output.put_line(i_requester_id || ' '||i_addressee_id|| 'are friends already itself');
when status_id_is_not_valid then
dbms_output.put_line('statusid '||i_status_id|| ' entered does not match the status table datasets.');
dbms_output.put_line('enter valid status id');
when requester_id_is_null then
dbms_output.put_line('requester id cannot be null');
when friend_id_is_null then
dbms_output.put_line('addressee id cannot be null');
when status_id_is_null then
dbms_output.put_line('status ID cannot be null');
when same_user_id then
dbms_output.put_line('Same user id for requester and addressee id');

END SNDB_ADD_FRIEND_DATA;


PROCEDURE SNDB_ADD_SNDB_conversation_data(I_conversation_id in SNDB_conversation_data.conversation_id%type,I_conversation_initiated_id in SNDB_conversation_data.conversation_initiated_id%type,I_conversation_started in SNDB_conversation_data.conversation_started%type,I_conversation_ended in SNDB_conversation_data.conversation_ended%type,I_participant_id in SNDB_conversation_data.participant_id%type)
AS
J_CONVERSATION_PRI_id number;
CONVERSATION_ID_count NUMBER;
IS_NULL number;
Friendship_id_from_addfriend varchar(50);
CONVO_INITIATED_USER_ID_from_USER_ACCOUNT NUMBER;
PARTICIPANT_USER_ID_from_USER_ACCOUNT NUMBER;
unique_id number;
requester_address_id varchar2(250);
requester_id_from_addfriend varchar2(50);
addresse_id_from_addfriend varchar2(50);
CONVERSATION_ID_EXISTS exception;
CONVERSATION_ID_DOESNT_EXISTS_IN_ADDFRIEND_TABLE EXCEPTION;
CONVO_INITIATED_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
PARTICIPANT_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
CONVERSION_ID_IS_NULL EXCEPTION;
conversation_initiated_id_IS_NULL EXCEPTION;
participant_id_IS_NULL EXCEPTION;
conversation_already_exists exception;
Conversation_in_progress exception;
Conversation_ended_time_cannot_be_greater exception;
previous_convo_end_time_greater exception;
CONVERSATION_STARTED_AND_PARTICIAPNT_ID_COMBO_DOESNT_EXISTS_IN_ADDFRIEND_TABLE EXCEPTION;
VAR_INTO VARCHAR(100);
VAR_INTO_1 timestamp;
BEGIN

if I_conversation_started >= I_conversation_ended then
raise Conversation_ended_time_cannot_be_greater;
end if;

CHECK_NULL(I_conversation_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE CONVERSION_ID_IS_NULL;
END IF;

CHECK_NULL(I_conversation_initiated_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE conversation_initiated_id_IS_NULL;
END IF;

CHECK_NULL(I_participant_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE participant_id_IS_NULL;
END IF;
select count (*) into CONVO_INITIATED_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=I_conversation_initiated_id;
if CONVO_INITIATED_USER_ID_from_USER_ACCOUNT =0 then
raise CONVO_INITIATED_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;
select count (*) into PARTICIPANT_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=I_participant_id;
if PARTICIPANT_USER_ID_from_USER_ACCOUNT =0 then
raise PARTICIPANT_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;

--select count(*)  into unique_id from SNDB_conversation_data b 
--where (b.conversation_initiated_id=I_conversation_id and b.participant_id= I_participant_id and )
--or (b.conversation_initiated_id=I_participant_id and b.participant_id=I_conversation_id);
--if unique_id>0 then
--raise conversation_already_exists;



select COUNT(b.friendship_id) into Friendship_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;
IF Friendship_id_from_addfriend =0 THEN
RAISE CONVERSATION_ID_DOESNT_EXISTS_IN_ADDFRIEND_TABLE;
END IF;
select b.requester_id  into requester_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;
select b.addressee_id into addresse_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;

IF ((requester_id_from_addfriend =I_conversation_initiated_id ) and (addresse_id_from_addfriend = I_participant_id))
OR ((requester_id_from_addfriend =I_participant_id ) and (addresse_id_from_addfriend = I_conversation_initiated_id))
THEN
select count (*) into CONVERSATION_ID_count from SNDB_conversation_data a where a.conversation_id = I_conversation_id;
if CONVERSATION_ID_count > 0 then
--IF v_DEPT_name IS NULL OR LENGTH(v_DEPT_name) = 0 
select count(CONVERSATION_ENDED) into VAR_INTO
  from ( select a.CONVERSATION_ENDED
              , row_number() over ( order by a.CONVERSATION_ID desc ) as row_num
           from SNDB_conversation_data a ) 
  where row_num = 1;
if  VAR_INTO >0 THEN
select (CONVERSATION_ENDED) into VAR_INTO_1
  from ( select a.CONVERSATION_ENDED
              , row_number() over ( order by a.CONVERSATION_ID desc ) as row_num
           from SNDB_conversation_data a ) 
  where row_num = 1;
if VAR_INTO_1 >= I_conversation_started then
raise previous_convo_end_time_greater;
else
J_CONVERSATION_PRI_id:=sndb_CONVERSATION_PRI_id_seq.nextval;
INSERT INTO SNDB_conversation_data(conversation_pri_id,conversation_id,conversation_initiated_id,conversation_started,conversation_ended,participant_id)
values(J_CONVERSATION_PRI_id,I_conversation_id,I_conversation_initiated_id,I_conversation_started,I_conversation_ended,I_participant_id);
dbms_output.put_line('Conversation data for conversation id '||I_conversation_id|| ' added Successfully!');
end if;
else
raise Conversation_in_progress;
END IF;
ELSE
J_CONVERSATION_PRI_id:=sndb_CONVERSATION_PRI_id_seq.nextval;
INSERT INTO SNDB_conversation_data(conversation_pri_id,conversation_id,conversation_initiated_id,conversation_started,conversation_ended,participant_id)
values(J_CONVERSATION_PRI_id,I_conversation_id,I_conversation_initiated_id,I_conversation_started,I_conversation_ended,I_participant_id);
dbms_output.put_line('Conversation data for conversation id '||I_conversation_id|| ' added Successfully!');
END IF;
else
raise CONVERSATION_STARTED_AND_PARTICIAPNT_ID_COMBO_DOESNT_EXISTS_IN_ADDFRIEND_TABLE;
end if;

EXCEPTION
WHEN CONVERSATION_STARTED_AND_PARTICIAPNT_ID_COMBO_DOESNT_EXISTS_IN_ADDFRIEND_TABLE THEN
dbms_output.put_line(I_conversation_initiated_id|| ' and '||I_participant_id|| ' are not friends with the given conversation ID '||I_conversation_id);
dbms_output.put_line('Enter valid parent key ID');
WHEN CONVERSATION_ID_DOESNT_EXISTS_IN_ADDFRIEND_TABLE THEN
dbms_output.put_line('CONVERSATION_ID '||I_conversation_id|| ' entered does not exists in ADD_FRIEND FRIENDSHIP ID VALUES.');
dbms_output.put_line('Enter valid parent key ID');
WHEN CONVO_INITIATED_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('Conversation_initiated_id '||I_conversation_initiated_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN PARTICIPANT_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('PARTICIPANT_ID '||I_participant_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN CONVERSATION_ID_EXISTS THEN
dbms_output.put_line('Conversation ID '||I_conversation_id|| ' already exists.');
when conversation_already_exists then
dbms_output.put_line('Conversation between  '||I_conversation_id||' and '|| I_participant_id||' already exists.');
WHEN CONVERSION_ID_IS_NULL THEN
dbms_output.put_line('CONVERSION_ID CANNOT BE NULL. ENTER VALID CONVERSION_ID');
WHEN conversation_initiated_id_IS_NULL THEN
dbms_output.put_line('conversation_initiated_id CANNOT BE NULL. ENTER VALID ID');
WHEN participant_id_IS_NULL THEN
dbms_output.put_line('participant_id CANNOT BE NULL. ENTER VALID ID');
WHEN Conversation_in_progress THEN
dbms_output.put_line('Conversation already in progress');
when Conversation_ended_time_cannot_be_greater then
dbms_output.put_line('Conversation_ended timestamp '||I_conversation_ended||' cannot be greater than or equal to conversation started '||I_conversation_started);
dbms_output.put_line('Enter valid values');
WHEN previous_convo_end_time_greater THEN
dbms_output.put_line('Previous conversation end time is greater than current conversation start time');
dbms_output.put_line('Enter valid values');
END SNDB_ADD_SNDB_conversation_data;

PROCEDURE SNDB_ADD_message_data(i_messsage_content in SNDB_message_data.messsage_content%type,i_message_timestamp in SNDB_message_data.message_timestamp%type,i_conversation_id in SNDB_message_data.conversation_id%type,i_from_message_id in SNDB_message_data.from_message_id%type,i_to_message_id in SNDB_message_data.to_message_id%type,i_IS_PAYMENT_REQUESTED in SNDB_message_data.IS_PAYMENT_REQUESTED%type)
AS
j_message_id number;
IS_NULL number;
conversation_initiated_id_from_CONVERSATION_DATA VARCHAR(100);
participant_id_from_CONVERSATION_DATA VARCHAR(100);
FROM_MESSAGE_USER_ID_from_USER_ACCOUNT NUMBER;
TO_MESSAGE_USER_ID_from_USER_ACCOUNT NUMBER;
conversation_pri_id_from_CONVERSATION_DATA NUMBER;
CONVERSION_ID_IS_NULL exception;
From_Message_ID_IS_NULL EXCEPTION;
To_Message_ID_IS_NULL exception;
FROM_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
TO_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
FROM_TO_COMBO_DOESNT_EXISTS_IN_CONVERSATION_TABLE EXCEPTION;
CONVERSATION_ID_DOESNT_EXSISTS_IN_CONVO_DATA EXCEPTION;
BEGIN

CHECK_NULL(i_conversation_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE CONVERSION_ID_IS_NULL;
END IF;

CHECK_NULL(i_from_message_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE From_Message_ID_IS_NULL;
END IF;

CHECK_NULL(i_to_message_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE To_Message_ID_IS_NULL;
END IF;

select count (*) into FROM_MESSAGE_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=i_from_message_id;
if FROM_MESSAGE_USER_ID_from_USER_ACCOUNT =0 then
raise FROM_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;
select count (*) into TO_MESSAGE_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=i_to_message_id;
if TO_MESSAGE_USER_ID_from_USER_ACCOUNT =0 then
raise TO_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;
select COUNT(b.conversation_pri_id) into conversation_pri_id_from_CONVERSATION_DATA from SNDB_conversation_data b where b.conversation_pri_id=i_conversation_id;
IF conversation_pri_id_from_CONVERSATION_DATA =0 THEN
RAISE CONVERSATION_ID_DOESNT_EXSISTS_IN_CONVO_DATA;
END IF;
select b.conversation_initiated_id  into conversation_initiated_id_from_CONVERSATION_DATA from SNDB_conversation_data b where b.conversation_pri_id=i_conversation_id;
select b.participant_id into participant_id_from_CONVERSATION_DATA from SNDB_conversation_data b where b.conversation_pri_id=i_conversation_id;
IF ((conversation_initiated_id_from_CONVERSATION_DATA =i_from_message_id ) and (participant_id_from_CONVERSATION_DATA = i_to_message_id))
OR ((conversation_initiated_id_from_CONVERSATION_DATA =i_to_message_id ) and (participant_id_from_CONVERSATION_DATA = i_from_message_id))
THEN
j_message_id:=sndb_message_data_ID_seq.nextval;
INSERT INTO SNDB_message_data(
message_id,
       messsage_content,
       message_timestamp,
       conversation_id,
       from_message_id,
       to_message_id,
       IS_PAYMENT_REQUESTED)
values(
j_message_id,
i_messsage_content,
i_message_timestamp,
i_conversation_id,
i_from_message_id,
i_to_message_id,
UPPER(i_IS_PAYMENT_REQUESTED)
);
dbms_output.put_line('MESSAGE DATA added Successfully!');

else
raise FROM_TO_COMBO_DOESNT_EXISTS_IN_CONVERSATION_TABLE;
END IF;
EXCEPTION
WHEN CONVERSATION_ID_DOESNT_EXSISTS_IN_CONVO_DATA THEN
dbms_output.put_line('CONVERSATION_ID ENTERD '||i_conversation_id|| ' DOESNT EXSISTS IN CONVERSATION TABLE CONVERSATION PRI ID VALUES');
when FROM_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('FROM_MESSAGE_ID '||i_from_message_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN TO_MESSAGE_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('TO_MESSAGE_ID '||i_to_message_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN FROM_TO_COMBO_DOESNT_EXISTS_IN_CONVERSATION_TABLE THEN
dbms_output.put_line('THERE IS NO ACTIVE CONVERSATION BETWEEN '||i_from_message_id|| ' and '||i_to_message_id|| ' WITH CONVERSATION ID '||i_conversation_id);
dbms_output.put_line('Enter valid parent key VALUES');
WHEN CONVERSION_ID_IS_NULL THEN
dbms_output.put_line('CONVERSATION_ID CANNOT BE NULL. ENTER VALID CONVERSION_ID');
WHEN From_Message_ID_IS_NULL THEN
dbms_output.put_line('FROM_MESSAGE_ID CANNOT BE NULL. ENTER VALID FROM_MESSAGE_ID');
WHEN To_Message_ID_IS_NULL THEN
dbms_output.put_line('TO_MESSAGE_ID CANNOT BE NULL. ENTER VALID TO_MESSAGE_ID');
WHEN OTHERS THEN
if sqlcode=-02290 then
dbms_output.put_line('PAYMENT REQUESTED should be from the following list: ''YES'',''NO''');
END IF;
END SNDB_ADD_message_data;


PROCEDURE SNDB_ADD_payment_request_data(i_requester_id in SNDB_payment_request_data.requester_id%type,i_reciever_id in SNDB_payment_request_data.reciever_id%type,i_request_status in SNDB_payment_request_data.request_status%type,i_request_amount in SNDB_payment_request_data.request_amount%type,i_payment_description in SNDB_payment_request_data.payment_description%type,i_payment_date in SNDB_payment_request_data.payment_date%type,i_payment_method in SNDB_payment_request_data.payment_method%type,i_Message_id in SNDB_payment_request_data.Message_id%type)
AS
j_payment_request_id number;
IS_NULL number;
RECIEVER_USER_ID_from_USER_ACCOUNT NUMBER;
REQUESTER_USER_ID_from_USER_ACCOUNT NUMBER;
MESSAGE_id_from_MESSAGE_DATA NUMBER;
from_message_id_from_MESSAGE_DATA VARCHAR2(50);
to_message_id_from_MESSAGE_DATA VARCHAR2(50);
IS_PAYMENT_REQUESTED_FROM_MESSAGE_DATA VARCHAR2(10);
Requester_ID_IS_NULL EXCEPTION;
RECEIVER_ID_IS_NULL EXCEPTION;
resuest_status_IS_NULL exception;
resuest_amount_IS_NULL EXCEPTION;
PAYMENT_DATE_IS_NULL EXCEPTION;
PAYMENT_METHOD_IS_NULL EXCEPTION;
MESSAGE_ID_IS_NULL EXCEPTION;
RECIEVER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
REQUESTER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT EXCEPTION;
MESSAGE_ID_DOESNT_EXSISTS_IN_MESSAGE_TABLE EXCEPTION;
PAYMENT_FLAG_NOT_SET_IN_MESSAGE_DATA EXCEPTION;
RECEIVER_REQUESTER_COMBO_DOESNT_EXISTS_IN_MESSAGE_TABLE EXCEPTION;

BEGIN

CHECK_NULL(i_requester_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE Requester_ID_IS_NULL;
END IF;

CHECK_NULL(i_reciever_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE RECEIVER_ID_IS_NULL;
END IF;

CHECK_NULL(i_request_status,IS_NULL);
IF IS_NULL = 1 THEN
RAISE resuest_status_IS_NULL;
END IF;

CHECK_NULL(i_request_amount,IS_NULL);
IF IS_NULL = 1 THEN
RAISE resuest_amount_IS_NULL;
END IF;

CHECK_NULL(i_payment_date,IS_NULL);
IF IS_NULL = 1 THEN
RAISE PAYMENT_DATE_IS_NULL;
END IF;

CHECK_NULL(i_payment_method,IS_NULL);
IF IS_NULL = 1 THEN
RAISE PAYMENT_METHOD_IS_NULL;
END IF;

CHECK_NULL(i_Message_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE MESSAGE_ID_IS_NULL;
END IF;

select count (*) into RECIEVER_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=i_reciever_id;
if RECIEVER_USER_ID_from_USER_ACCOUNT =0 then
raise RECIEVER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;
select count (*) into REQUESTER_USER_ID_from_USER_ACCOUNT from SNDB_user_account b where b.user_id=i_requester_id;
if REQUESTER_USER_ID_from_USER_ACCOUNT =0 then
raise REQUESTER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
END IF;
select COUNT(b.message_id) into MESSAGE_id_from_MESSAGE_DATA from SNDB_message_data b where b.message_id=i_Message_id;
IF MESSAGE_id_from_MESSAGE_DATA =0 THEN
RAISE MESSAGE_ID_DOESNT_EXSISTS_IN_MESSAGE_TABLE;
END IF;

SELECT b.IS_PAYMENT_REQUESTED INTO IS_PAYMENT_REQUESTED_FROM_MESSAGE_DATA FROM SNDB_MESSAGE_DATA b WHERE b.message_id=i_Message_id;
 IF UPPER(IS_PAYMENT_REQUESTED_FROM_MESSAGE_DATA) = 'YES' THEN
 
select b.from_message_id  into from_message_id_from_MESSAGE_DATA from SNDB_message_data b where b.message_id=i_Message_id;
select b.to_message_id into to_message_id_from_MESSAGE_DATA from SNDB_message_data b where b.message_id=i_Message_id;
IF ((from_message_id_from_MESSAGE_DATA =i_requester_id ) and (to_message_id_from_MESSAGE_DATA = i_reciever_id))
THEN

j_payment_request_id:=sndb_Payment_Request_ID_seq.nextval;
INSERT INTO SNDB_payment_request_data(
payment_request_id,
        requester_id,
        reciever_id,
        request_status,
        request_amount,
        payment_description,
        payment_date,
        payment_method,
        Message_id
       )
values(
j_payment_request_id,
i_requester_id,
i_reciever_id,
UPPER(i_request_status),
i_request_amount,
i_payment_description,
i_payment_date,
i_payment_method,
i_Message_id
);
dbms_output.put_line('PAYMENT REQUEST DATA added Successfully!');

else
raise RECEIVER_REQUESTER_COMBO_DOESNT_EXISTS_IN_MESSAGE_TABLE;
END IF;
ELSE
RAISE PAYMENT_FLAG_NOT_SET_IN_MESSAGE_DATA;
END IF;
EXCEPTION
WHEN MESSAGE_ID_DOESNT_EXSISTS_IN_MESSAGE_TABLE THEN
dbms_output.put_line('MESSAGE_ID ENTERD '||i_Message_id|| ' DOESNT EXSISTS IN MESSAGE TABLE MESSAGE ID VALUES');
when REQUESTER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('REQUESTER ID '||i_requester_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN RECIEVER_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT THEN
dbms_output.put_line('RECIEVER ID '||i_reciever_id|| ' entered does not exists in USER_ACCOUNT.');
dbms_output.put_line('Enter valid parent key ID');
WHEN RECEIVER_REQUESTER_COMBO_DOESNT_EXISTS_IN_MESSAGE_TABLE THEN
dbms_output.put_line('THERE IS NO ACTIVE MESSAGE BETWEEN '||i_requester_id|| ' and '||i_reciever_id|| ' WITH MESSAGE ID '||i_Message_id);
dbms_output.put_line('Enter valid parent key VALUES');
WHEN Requester_ID_IS_NULL THEN
dbms_output.put_line('REQUESTER_ID CANNOT BE NULL. ENTER VALID REQUESTER_ID');
WHEN RECEIVER_ID_IS_NULL THEN
dbms_output.put_line('RECEIVER_ID CANNOT BE NULL. ENTER VALID RECEIVER_ID');
WHEN resuest_status_IS_NULL THEN
dbms_output.put_line('resuest_status CANNOT BE NULL. ENTER VALID resuest_status');
WHEN resuest_amount_IS_NULL THEN
dbms_output.put_line('resuest_amount CANNOT BE NULL. ENTER VALID resuest_amount');
WHEN PAYMENT_DATE_IS_NULL THEN
dbms_output.put_line('PAYMENT_DATE CANNOT BE NULL. ENTER VALID PAYMENT_DATE');
WHEN PAYMENT_METHOD_IS_NULL THEN
dbms_output.put_line('PAYMENT_METHOD CANNOT BE NULL. ENTER VALID PAYMENT_METHOD');
WHEN MESSAGE_ID_IS_NULL THEN
dbms_output.put_line('MESSAGE_ID CANNOT BE NULL. ENTER VALID MESSAGE_ID');
WHEN PAYMENT_FLAG_NOT_SET_IN_MESSAGE_DATA THEN
dbms_output.put_line('PAYMENT REQUEST FLAG FOR MEESAGE ID '||i_Message_id||' IS NOT SET IN MESSAGE TABLE');
WHEN OTHERS THEN
if sqlcode=-02290 then
dbms_output.put_line('REQUEST STATUS should be from the following list: ''APPROVED'',''DENIED''');
END IF;
END SNDB_ADD_payment_request_data;

procedure SNDB_ADD_GROUP(i_group_name in sndb_group.group_name%type,
i_created_date in sndb_group.created_date%type, i_is_group_active in sndb_group.is_group_active%type)
as
i_group_id number;
group_count number;
is_null number;
group_name_exists exception;
group_name_is_null_exists exception;
is_group_active_null exception;
begin
CHECK_NULL(i_group_name, is_null);
if is_null = 1 then
raise group_name_is_null_exists;
end if;
CHECK_NULL(i_is_group_active, is_null);
if is_null = 1 then
raise is_group_active_null;
end if;
select count(*) into group_count from sndb_group a where a.group_name = i_group_name;
if group_count >0 then
raise group_name_exists;
else
i_group_id:= sndb_group_seq.nextval;
insert into sndb_group(
group_id,
group_name,
created_date,
Is_group_active
)
values
(i_group_id,
i_group_name,
i_created_date,
i_is_group_active
);
end if;
exception
when group_name_exists then
dbms_output.put_line(i_group_name || 'is used already');
dbms_output.put_line('Please enter the different group_name');
when group_name_is_null_exists then
dbms_output.put_line('group_name cannot be null.');
when is_group_active_null then
dbms_output.put_line('is_group_active cannot be null.');
end sndb_add_group;

PROCEDURE SNDB_ADD_user_account_group(i_user_account_id in SNDB_user_account_group.user_account_id%type, i_user_group_id in SNDB_user_account_group.group_id%type)
as
user_account_group_id_exists exception;
useraccount_group_id_count number; 
is_null number;
user_account_id_null exception;
group_id_null exception;
user_account_id_not_exists exception;
group_id_not_exists exception;
useraccount_id_count number;
group_id_count number;
begin
select count(*) into useraccount_id_count from sndb_user_account a where a.user_id = i_user_account_id;
if useraccount_id_count = 0 then
raise user_account_id_not_exists;
end if;
select count(*) into group_id_count from sndb_group c where c.group_id  = i_user_group_id;
if group_id_count = 0 then
raise group_id_not_exists;
end if;
check_null(i_user_account_id, is_null);
if is_null = 1 then
raise user_account_id_null;
end if;
check_null(i_user_group_id, is_null);
if is_null = 1 then
raise group_id_null;
end if;
select count(*) into useraccount_group_id_count from SNDB_user_account_group b where b.user_account_id = i_user_account_id and b.group_id = i_user_group_id;
if useraccount_group_id_count > 0 then
raise user_account_group_id_exists;
else
insert into SNDB_user_account_group (
user_account_id,
group_id)
values
(
i_user_account_id,
i_user_group_id
);
dbms_output.put_line('the user account id and group id are ' || i_user_account_id || ' ' || i_user_group_id || ' succesfully added');
end if;
exception
when user_account_id_not_exists then
dbms_output.put_line('user_account_id is not present in user_account table');
when group_id_not_exists then
dbms_output.put_line('group_id is not present in group table');
when user_account_id_null then
dbms_output.put_line('entered user_account_id cannot be null');
when group_id_null then
dbms_output.put_line('entered group_id cannot be null');
when user_account_group_id_exists then
dbms_output.put_line('user_account_id and group_id already exists');
end SNDB_ADD_user_account_group;

procedure SNDB_add_group_recipient(
i_group_id_recipientdata in SNDB_group_recipient.group_id%type,
i_user_id_recipientdata in SNDB_group_recipient.user_id%type, i_created_date_recipient in SNDB_group_recipient.created_date%type,
i_is_group_active_recipient in SNDB_group_recipient.is_group_active%type)
as
is_null number;
j_group_recipient_id number;
group_id_recipientdata_is_null exception;
user_id_recipientdata_is_null exception;
created_date_recipient_is_null exception;
user_account_group_exists exception;
user_account_group number;
useraccount_id_count_recipient number;
group_recipeint_date date;
user_account_id_not_exists_recipient EXCEPTION;
not_created_correct_date EXCEPTION;
begin
select count(*) into useraccount_id_count_recipient from sndb_user_account_group a where a.user_account_id = i_user_id_recipientdata and  a.group_id  = i_group_id_recipientdata;
if useraccount_id_count_recipient = 0 then
raise user_account_id_not_exists_recipient;
end if;
select b.created_date into group_recipeint_date from sndb_group b where b.group_id  = i_group_id_recipientdata;
if group_recipeint_date >= i_created_date_recipient then
raise not_created_correct_date;
end if;
check_null(i_group_id_recipientdata, is_null);
if is_null = 1 then
raise group_id_recipientdata_is_null;
end if;
check_null(i_user_id_recipientdata, is_null);
if is_null = 1 then
raise user_id_recipientdata_is_null;
end if;
check_null(i_created_date_recipient, is_null);
if is_null = 1 then
raise created_date_recipient_is_null;
end if;
select count(*) into user_account_group from SNDB_group_recipient b where b.group_id = i_group_id_recipientdata and b.user_id = i_user_id_recipientdata;
if user_account_group > 0 then
raise user_account_group_exists;
else
j_group_recipient_id :=SNDB_group_recipient_seq.nextval();
insert into SNDB_group_recipient(
group_recipient_id,
group_id,
user_id,
created_date,
is_group_active
)
values
(
j_group_recipient_id,
i_group_id_recipientdata,
i_user_id_recipientdata,
i_created_date_recipient,
i_is_group_active_recipient
);
dbms_output.put_line('group data like created date,active are added to the table succesfully');
end if;
exception
when user_account_id_not_exists_recipient then
dbms_output.put_line('user_account_id and group id combo is not presnt in user_account_group table');
when not_created_correct_date then
dbms_output.put_line('group_id' || ' '||i_group_id_recipientdata||'  is not active for the entered date');
dbms_output.put_line('Please enter correct date');
when user_id_recipientdata_is_null then 
dbms_output.put_line('user_id cannot be null in recipient table');
when group_id_recipientdata_is_null then 
dbms_output.put_line('group_id cannot be null in recipient table');
when created_date_recipient_is_null then
dbms_output.put_line('created date cannot be null in recipient table');
when user_account_group_exists then
dbms_output.put_line('group id, user account exists and cannot be added');
end SNDB_add_group_recipient;

procedure SNDB_add_reminder_freq(i_freq_type in SNDB_reminder_freq.freq_type%type, i_is_active in SNDB_reminder_freq.is_active%type)
as
is_null number;
i_reminder_id number;
freq_type_null exception;
is_active_null exception;
freq_value number;
freq_type_exists exception;
begin
check_null(i_freq_type,is_null);
if is_null=1 then
raise freq_type_null;
end if;
check_null(i_is_active,is_null);
if is_null=1 then
raise is_active_null;
end if;
select count(*) into freq_value from SNDB_reminder_freq c where c.freq_type = i_freq_type;
if freq_value > 0 then 
raise freq_type_exists;
else
i_reminder_id:= SNDB_reminder_freq_seq.nextval();
insert into SNDB_reminder_freq (
reminder_id,
freq_type,
is_active)
values
(
i_reminder_id,
UPPER(i_freq_type),
UPPER(i_is_active)
);
end if;
DBMS_OUTPUT.PUT_LINE('freq_type : ' ||i_freq_type || ' is succesfully added.');
exception
when freq_type_null then
dbms_output.put_line('Freq type cannot be null');
when is_active_null then
dbms_output.put_line('is_active cannot be null');
when freq_type_exists then
DBMS_OUTPUT.PUT_LINE('freq_type : ' ||i_freq_type || ' is already present.');
WHEN others then
if sqlcode=-02290 then
dbms_output.put_line('This error could be due to :');
dbms_output.put_line('1. Active should be from the following list: ''YES'',''NO''');
dbms_output.put_line('2. Freq type should be from the following list: ''DAILY'',''WEEKLY'',''BIWEEKLY'',''MONTHLY''');
END IF;
end SNDB_add_reminder_freq;



 END INSERTIONS;
    /

    
    
    
begin

--INSERTIONS.add_roles('IT', 'user desc');
--INSERTIONS.ADD_USER_LOGIN('meenakshi','meenu123','user');
INSERTIONS.ADD_USER_LOGIN('test_trial','tes1123','user');

end;

begin
INSERTIONS.ADD_USER_LOGIN('meenakshi','meenu123','user');
INSERTIONS.ADD_USER_LOGIN('TRIAL','TRIA345','user');
INSERTIONS.ADD_USER_LOGIN('IGSX','IGXA123','user');

INSERTIONS.ADD_USER_LOGIN('WER','WER123','user');
end;

begin
INSERTIONS.ADD_GENDER_DATA('female');
end;

BEGIN
--SNDB_ADD_user_account(1,'','Fnu','en@fmail.com',12345,'NEU','CEO','MSIS',1,'01-Jan-22',10,CURRENT_TIMESTAMP);
--insertions.sndb_add_user_account(2,'Sud','fnu','fd12mail.com',562134578,'NEU','CEO','MSIS',1,'02-Jan-22','256',CURRENT_TIMESTAMP);
--insertions.sndb_add_user_account(3,'test','tnu','test@2mail.com',796543210,'NEU','CEO','MSIS',1,'02-Jan-22','256',CURRENT_TIMESTAMP);
insertions.sndb_add_user_account(4,'TRIAL','FDE','TSEst@2mail.com',5630976,'NEU','CEO','MSIS',1,'02-Jan-22','256',CURRENT_TIMESTAMP);
insertions.sndb_add_user_account(5,'IGZRS','TRE','IGZ@2mail.com',992654332,'NEU','CEO','MSIS',1,'02-Jan-22','256',CURRENT_TIMESTAMP);

END;

begin
INSERTIONS.SNDB_ADD_STATUS_DATA('Rejected');
end;

begin
--INSERTIONS.SNDB_ADD_FRIEND_DATA(2,3,CURRENT_TIMESTAMP,2,CURRENT_TIMESTAMP,'Great to connect',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
--INSERTIONS.SNDB_ADD_FRIEND_DATA(1,3,CURRENT_TIMESTAMP,2,CURRENT_TIMESTAMP,'Great to connect',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
INSERTIONS.SNDB_ADD_FRIEND_DATA(4,3,CURRENT_TIMESTAMP,2,CURRENT_TIMESTAMP,'Great to connect',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
INSERTIONS.SNDB_ADD_FRIEND_DATA(2,5,CURRENT_TIMESTAMP,2,CURRENT_TIMESTAMP,'Great to connect',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
end;


BEGIN
INSERTIONS.SNDB_ADD_SNDB_conversation_data(10,1,TO_TIMESTAMP('10-APR-22 12:21:32', 'DD-MON-YY HH24:mi:ss'),null,2);
INSERTIONS.SNDB_ADD_SNDB_conversation_data(11,3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,2);
INSERTIONS.SNDB_ADD_SNDB_conversation_data(12,1,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,3);
INSERTIONS.SNDB_ADD_SNDB_conversation_data(13,3,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,4);
INSERTIONS.SNDB_ADD_SNDB_conversation_data(14,5,CURRENT_TIMESTAMP,'',2);

end;

UPDATE SNDB_conversation_data
SET conversation_ended = TO_TIMESTAMP('10-APR-22 15:21:32', 'DD-MON-YY HH24:mi:ss')
WHERE CONVERSATION_ID =14;

BEGIN
INSERTIONS.SNDB_ADD_message_data('hello, come soon',CURRENT_TIMESTAMP,89,1,2, 'yes');
INSERTIONS.SNDB_ADD_message_data('Great Well Soon',CURRENT_TIMESTAMP,90,2,3,'YES');
INSERTIONS.SNDB_ADD_message_data('hello, come soon',CURRENT_TIMESTAMP,92,4,3, 'yes');
INSERTIONS.SNDB_ADD_message_data('Great Well Soon',CURRENT_TIMESTAMP,93,2,5,'YES');

END;

begin
 SNDB_ADD_payment_request_data(1,2,'REQUESTED',1,'Shop and stop bill',TO_TIMESTAMP('01-MAR-22 04:12.49', 'DD-MON-YY HH24:mi:ss'),'Debit',18);
SNDB_ADD_payment_request_data(2,5,'REQUESTED',100,'Shop and stop bill',TO_TIMESTAMP('01-MAR-22 04:12.49', 'DD-MON-YY HH24:mi:ss'),'Debit',21);

end;

SELECT * FROM SNDB_message_data;

SELECT * FROM SNDB_STATUS;

SELECT CREATED_DATETIME, FRIENDSHIP_ID, 
LAG(ADDRESSEE_ID) OVER(ORDER BY FRIENDSHIP_ID) as old_value
FROM SNDB_ADDFRIEND_DATA ;'

select * from SNDB_conversation_data;

delete SNDB_conversation_data;


begin
SNDB_ADD_POST_DATA('postnew','Hi everyone',1);
end;

select * from sndb_post_data;

BEGIN
SNDB_ADD_votes_data(1,2,3);
SNDB_ADD_votes_data(2,20,30);
END;

SELECT * FROM SNDB_VOTES_DATA;


BEGIN
SNDB_ADD_logged_in_data(1,TO_TIMESTAMP('10-MAY-2022 02:30:33','DD-MON-YY HH24:MI:SS'),NULL);
END;
