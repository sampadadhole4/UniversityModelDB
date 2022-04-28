SET SERVEROUTPUT ON;

CREATE SEQUENCE sndb_role_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_user_login_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_gender_data_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_user_account_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SNDB_STATUS_Seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SNDB_ADDFRIEND_DATA_Seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_CONVERSATION_PRI_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


DECLARE
    row_count NUMBER(10);
BEGIN
    SELECT
        COUNT(*)
    INTO row_count
    FROM
        user_tables
    WHERE
        table_name = 'CONFIG_TABLE';

    IF ( row_count > 0 ) THEN
        dbms_output.put_line('TABLE CONFIG_TABLE ALREADY EXISTS');
    ELSE
        EXECUTE IMMEDIATE 'CREATE TABLE CONFIG_TABLE
    (
       TABLE_NAME varchar2(50), 
       TABLE_DEF varchar2(3000) NOT NULL, 
       CONSTRAINT CONFIG_TABLE_PK PRIMARY KEY(TABLE_NAME)
    )';
        dbms_output.put_line('TABLE CONFIG_TABLE CREATED SUCCESSFULLY');
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_USER_ROLES_DATA','CREATE TABLE SNDB_user_roles_data
            (	
          
           role_id number NOT NULL PRIMARY KEY,
   	role_name varchar2(50) NOT NULL unique,
       role_description varchar2(50)

            )
    ')]';
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_user_login','CREATE TABLE SNDB_user_login
            (	
            user_login_id number NOT NULL,
       username varchar2(50) NOT NULL,
       password varchar2(50) NOT NULL,
       user_type varchar2(50) not null,
       CONSTRAINT user_login_id_pk PRIMARY KEY (user_login_id),
        CONSTRAINT FK_user_type FOREIGN KEY (user_type)
       REFERENCES SNDB_USER_ROLES_DATA(ROLE_NAME)

            )
    ')]';
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_gender_data','CREATE TABLE SNDB_gender_data 
            (	
        
             gender_id number NOT NULL,
       name varchar2(50) NOT NULL,
CONSTRAINT gender_id_pk PRIMARY KEY (gender_id ),
 CONSTRAINT SNDB_gender_name_allowed CHECK (name IN (''MALE'',''FEMALE'',''OTHERS''))

            )
    ')]';
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_user_account','CREATE TABLE SNDB_user_account 
            (	
        
     user_account_id number not null,
       user_id int not null unique,
      first_name varchar2(50) not null,
      last_name varchar2(50) not null,
      email_id varchar2(50) not null UNIQUE,
      phone_number int UNIQUE,
      university_name varchar2(50),
      college_name varchar2(50),
      course_name varchar2(50),
      gender_id int,
      dob date,
      otp int NOT NULL,
      created_at timestamp,
      CONSTRAINT user_id_pk PRIMARY KEY (user_account_id),
  CONSTRAINT FK_user_id FOREIGN KEY (gender_id)
   REFERENCES SNDB_gender_data(gender_id),
   CONSTRAINT FK_user_login_id
FOREIGN KEY (user_id) REFERENCES SNDB_USER_LOGIN(user_login_id)
            )
    ')]';
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_USER_PHOTO_DATA','CREATE TABLE SNDB_USER_PHOTO_DATA
(
        photo_id number NOT NULL,
        user_account_id number NOT NULL,
        photo_link varchar2(50),
        time_added timestamp,
        photo_visibility varchar2(10),
        CONSTRAINT SNDB_photo_id_pk PRIMARY KEY (photo_id),
       CONSTRAINT SNBD_FK_user_account_id FOREIGN KEY (user_account_id )
     REFERENCES SNDB_user_account(user_id)
)
')]';


EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_STATUS','CREATE TABLE SNDB_STATUS
(
       status_id number NOT NULL,
       status_type varchar2(30) NOT NULL,
       CONSTRAINT sndb_status_id_pk PRIMARY KEY (status_id),
	   CONSTRAINT sndb_CHK_STATUS CHECK (STATUS_TYPE IN(''Accepted'',''Rejected'',''Pending''))
)
')]';

EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_ADDFRIEND_DATA','CREATE TABLE SNDB_ADDFRIEND_DATA
(
       friendship_id number NOT NULL,
       requester_id number NOT NULL,
       addressee_id number NOT NULL,
       created_datetime timestamp,
       status_id  number NOT NULL,
       logout_time timestamp,
       Status_comment varchar2(50),
       approved_time timestamp,
       status_updated_time timestamp,
 CONSTRAINT friendship_id_pk PRIMARY KEY (friendship_id ),
       CONSTRAINT FK_requester_id FOREIGN KEY (requester_id)
    REFERENCES SNDB_user_account(user_id),
        CONSTRAINT FK_addressee_id FOREIGN KEY (addressee_id)
    REFERENCES SNDB_user_account(user_id)
  )
')]';

        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_conversation_data','CREATE TABLE SNDB_conversation_data 
                (	
            
           conversation_pri_id number NOT NULL,
           conversation_id number NOT NULL,
           conversation_initiated_id number NOT NULL,
           conversation_started timestamp,
           conversation_ended timestamp,
           participant_id number NOT NULL,
          CONSTRAINT SNDB_convers_pri_id_pk PRIMARY KEY (conversation_pri_id),
          CONSTRAINT SNDB_frd_conversation_id_FK FOREIGN KEY (conversation_id)
        REFERENCES SNDB_ADDFRIEND_DATA(FRIENDSHIP_ID),
     CONSTRAINT SNDB_Fk_frd_user_start_id
       FOREIGN KEY (conversation_initiated_id)
       REFERENCES SNDB_user_account (user_id),
    CONSTRAINT SNDB_FK_participant_id FOREIGN KEY (participant_id)
        REFERENCES SNDB_user_account(user_id)
    
               )
        ')]';
        EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_GROUP','CREATE TABLE SNDB_GROUP 
            (	
    group_id number NOT NULL,
       group_name varchar2(50) NOT NULL,
       created_date date,
       Is_group_active varchar2(10) NOT NULL,
CONSTRAINT SNDB_group_id_pk PRIMARY KEY (group_id)
   )
    ')]';
    
    execute immediate q'[INSERT INTO CONFIG_TABLE VALUES('SNDB_user_account_group','CREATE TABLE SNDB_user_account_group
(
       user_account_id number NOT NULL,
       group_id number NOT NULL,
	     CONSTRAINT SNDB_FK_user_group_account_id FOREIGN KEY (user_account_id)
       REFERENCES SNDB_user_account(user_id),
         CONSTRAINT SNDB_FK_user_MSSG_id FOREIGN KEY (group_id)
       REFERENCES SNDB_GROUP(GROUP_id),
	   CONSTRAINT sndb_user_group_ID_pk PRIMARY KEY (user_account_id, group_id)
	   )
	')]'; 
    
   EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_group_recipient','CREATE TABLE SNDB_group_recipient 
            (	
       group_recipient_id number NOT NULL,
       group_id number NOT NULL,
       user_id number NOT NULL,
       created_date date NOT NULL,
       is_group_active varchar2(10),
       CONSTRAINT group_recipnt_id_pk PRIMARY KEY (group_recipient_id ),
	   CONSTRAINT sndb_FK_user_grp_ID_key FOREIGN KEY (user_id,group_id)
    REFERENCES SNDB_USER_ACCOUNT_GROUP(user_account_id,group_id)
  )
    ')]'; 
    
execute immediate q'[insert into config_table values('SNDB_reminder_freq', 'create table SNDB_reminder_freq
(
       reminder_id number NOT NULL,
       freq_type varchar2(20)  NOT NULL,
       is_active varchar2(20)  NOT NULL,
       CONSTRAINT sndb_reminder_id_pk PRIMARY KEY (reminder_id ),
	   CONSTRAINT sndb_active CHECK (is_active IN(''YES'',''NO'')),
	   CONSTRAINT sndb_freq_type CHECK (freq_type IN(''DAILY'',''WEEKLY'',''BIWEEKLY'',''MONTHLY''))
)
')]';
   
   execute immediate q'[insert into config_table values('SNDB_GROUP_MESSAGE', 'create table SNDB_GROUP_MESSAGE
(
       group_message_PRI_id number NOT NULL,
       group_message_id number NOT NULL,
       subject varchar2(50) NOT NULL,
       creator_id number NOT NULL,
       group_message_content clob NOT NULL,
       group_message_created_date date NOT NULL,
       Is_reminder varchar2(10) NOT NULL,
       Next_reminder_date date NOT NULL,
       reminder_freq_id number NOT NULL,
       reminder_expiry_date date NOT NULL,
       group_message_status varchar2(10),
CONSTRAINT sndb_group_message_id_pk PRIMARY KEY (group_message_PRI_id ),
   CONSTRAINT sndb_FK_creator_id FOREIGN KEY (creator_id)
    REFERENCES SNDB_user_account(user_id),
    CONSTRAINT sndb_FK_RECIP_MESSAGE_id FOREIGN KEY (group_message_id)
    REFERENCES SNDB_GROUP_RECIPIENT(group_recipient_id),
    CONSTRAINT sndb_FK_reminder_frequ_id FOREIGN KEY (reminder_freq_id)
    REFERENCES SNDB_reminder_freq(reminder_id),
	CONSTRAINT sndb_Is_reminder CHECK (Is_reminder IN(''YES'',''NO'')),
	CONSTRAINT sndb_group_message_status CHECK (group_message_status IN(''Delivered'',''Read''))
)
')]';
    
    END IF;

END;
/

DROP TABLE config_table;

DROP TABLE sndb_gender_data;

SELECT
    *
FROM
    config_table;

DECLARE
    CURSOR config_table_cur IS
    SELECT
        *
    FROM
        config_table;

    tab_name  VARCHAR2(50);
    tab_def   VARCHAR2(3000);
    row_count NUMBER(10) := 0;
BEGIN
    FOR i IN config_table_cur LOOP
        tab_name := i.table_name;
        tab_def := i.table_def;
        dbms_output.put_line('--------------------------');
        SELECT
            COUNT(*)
        INTO row_count
        FROM
            user_tables
        WHERE
            table_name = upper(tab_name);

        dbms_output.put_line('tanle_name is ='
                             || tab_name
                             || 'row count i s='
                             || row_count);
        IF ( row_count > 0 ) THEN
            dbms_output.put_line('TABLE '
                                 || tab_name
                                 || ' ALREADY EXISTS');
        ELSE
            dbms_output.put_line('--------------------------');
            EXECUTE IMMEDIATE ( tab_def );
            dbms_output.put_line('TABLE '
                                 || tab_name
                                 || ' CREATED SUCCESSFULLY');
        END IF;

    END LOOP;

    dbms_output.put_line('ALL TABLES CREATED');
END;
/

select * from config_table;



CREATE OR REPLACE PACKAGE INSERTIONS
    AS    
        PROCEDURE CHECK_NULL (I_FIELD IN CHAR, IS_NULL OUT NUMBER);
        PROCEDURE ADD_ROLES(i_ROLE_NAME in SNDB_user_roles_data.role_name%type, i_ROLE_DESCRIPTION in sndb_user_roles_data.role_description%TYPE);
        PROCEDURE ADD_USER_LOGIN(i_username in SNDB_user_login.username%type, i_password in SNDB_user_login.password%TYPE, i_user_type in SNDB_user_login.user_type%TYPE);
        PROCEDURE ADD_GENDER_DATA(i_name in SNDB_gender_data.name%type);
        PROCEDURE SNDB_ADD_user_account(I_user_id in SNDB_user_account.user_id%type, I_first_name in SNDB_user_account.first_name%type,I_last_name in SNDB_user_account.last_name%type,I_email_id in SNDB_user_account.email_id%type,I_phone_number IN SNDB_user_account.phone_number%type, I_university_name IN SNDB_user_account.university_name%type, I_college_name IN SNDB_user_account.college_name%type,I_course_name in SNDB_user_account.course_name%type,I_gender_id in SNDB_user_account.gender_id%type,I_dob in SNDB_user_account.dob%type,I_otp in SNDB_user_account.otp%type,I_created_at in SNDB_user_account.created_at%type );
 PROCEDURE  SNDB_ADD_PHOTO_DATA(i_user_account_id in SNDB_USER_PHOTO_DATA.user_account_id%type, i_photo_link in SNDB_USER_PHOTO_DATA.photo_link%type, i_time_added in SNDB_USER_PHOTO_DATA.time_added%type,i_photo_visibility in SNDB_USER_PHOTO_DATA.photo_visibility%type); 
 
 PROCEDURE SNDB_ADD_STATUS_DATA(i_status_type in SNDB_STATUS.status_type%type);
        PROCEDURE SNDB_ADD_FRIEND_DATA(i_requester_id in SNDB_ADDFRIEND_DATA.requester_id%type,i_addressee_id in SNDB_ADDFRIEND_DATA.addressee_id%type,i_created_datetime in SNDB_ADDFRIEND_DATA.created_datetime%type,i_status_id in SNDB_ADDFRIEND_DATA.status_id%type, i_logout_time in SNDB_ADDFRIEND_DATA.logout_time%type,i_Status_comment in SNDB_ADDFRIEND_DATA.Status_comment%type,i_approved_time in SNDB_ADDFRIEND_DATA.approved_time%type,i_status_updated_time in SNDB_ADDFRIEND_DATA.status_updated_time%type);
        PROCEDURE SNDB_ADD_SNDB_conversation_data(I_conversation_id in SNDB_conversation_data.conversation_id%type,I_conversation_initiated_id in SNDB_conversation_data.conversation_initiated_id%type,I_conversation_started in SNDB_conversation_data.conversation_started%type,I_conversation_ended in SNDB_conversation_data.conversation_ended%type,I_participant_id in SNDB_conversation_data.participant_id%type);
procedure SNDB_ADD_GROUP(i_group_name in sndb_group.group_name%type,i_created_date in sndb_group.created_date%type, i_is_group_active in sndb_group.is_group_active%type);

 PROCEDURE SNDB_ADD_user_account_group(i_user_account_id in SNDB_user_account_group.user_account_id%type, i_user_group_id in SNDB_user_account_group.group_id%type);
procedure SNDB_add_group_recipient(
i_group_id_recipientdata in SNDB_group_recipient.group_id%type,
i_user_id_recipientdata in SNDB_group_recipient.user_id%type, i_created_date_recipient in SNDB_group_recipient.created_date%type,
i_is_group_active_recipient in SNDB_group_recipient.is_group_active%type);
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
dbms_output.put_line('User_account '||I_user_id|| ' added Successfully!');
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
dbms_output.put_line('Status  '||i_status_type|| ' already exists.');
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
VAR_INTO VARCHAR(50);
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
raise PARTICIPANT_USER_ID_DOESNT_EXISTS_IN_USER_ACCOUNT;
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


select count(CONVERSATION_ENDED) into VAR_INTO
  from ( select a.CONVERSATION_ENDED
              , row_number() over ( order by a.CONVERSATION_ID desc ) as row_num
           from SNDB_conversation_data a ) 
  where row_num = 1;
select b.friendship_id into Friendship_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;
select b.requester_id  into requester_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;
select b.addressee_id into addresse_id_from_addfriend from SNDB_ADDFRIEND_DATA b where b.friendship_id=I_conversation_id;

IF ((requester_id_from_addfriend =I_conversation_initiated_id ) and (addresse_id_from_addfriend = I_participant_id))
OR ((requester_id_from_addfriend =I_participant_id ) and (addresse_id_from_addfriend = I_conversation_initiated_id))
THEN
select count (*) into CONVERSATION_ID_count from SNDB_conversation_data a where a.conversation_id = I_conversation_id;
if CONVERSATION_ID_count > 0 then
--IF v_DEPT_name IS NULL OR LENGTH(v_DEPT_name) = 0 
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
raise CONVERSATION_ID_DOESNT_EXISTS_IN_ADDFRIEND_TABLE;
end if;

EXCEPTION
WHEN CONVERSATION_ID_DOESNT_EXISTS_IN_ADDFRIEND_TABLE THEN
dbms_output.put_line('CONVERSATION_ID '||I_conversation_id|| ' entered does not exists in ADD_FRIEND FRIENDSHIP ID VALUES.');
dbms_output.put_line(I_conversation_initiated_id|| ' and '||I_participant_id|| ' are not friends');
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
dbms_output.put_line('group data succesfully added.');
end if;
exception
when group_name_exists then
dbms_output.put_line(i_group_name || ' is used already');
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
select * from sndb_addfriend_data;
select * from sndb_group;
select * from sndb_user_account;
select * from sndb_user_account_group;
select * from sndb_group_recipient;
begin
insertions.sndb_add_group('team4',sysdate+1,'Yes');
end;
begin
insertions.SNDB_add_reminder_freq('Weekly','Yes');
end;
begin
insertions.sndb_add_user_account_group(11,3);
end;
begin
insertions.sndb_add_group_recipient(4,10,sysdate-1,'yes');
end;

select * from SNDB_reminder_freq;