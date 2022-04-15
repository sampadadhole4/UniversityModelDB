
SET SERVEROUTPUT ON;

begin 
execute immediate 'DROP TABLE SNDB_group_message'; 
exception when others then null; 
end;
/

begin 
execute immediate 'DROP TABLE SNDB_reminder_freq'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_group_recipient drop constraint FK_user_grp_ID_key'; 
exception when others then null; 
end;
/

begin 
execute immediate 'drop table SNDB_group_recipient'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table SNDB_user_account_group drop constraint user_group_ID'; 
exception when others then null; 
end;
/

begin 
execute immediate 'drop table SNDB_user_account_group'; 
exception when others then null; 
end;
/

begin 
execute immediate 'drop table SNDB_group'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_payment_request_data drop constraint FK_conversation_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_payment_request_data drop constraint Fk_paymnt_requester_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_payment_request_data drop constraint Fk_paymnt_reciever_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_payment_request_data'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_message_data drop constraint UQ_conversation_id'; 
exception when others then null; 
end;
/
begin 
execute immediate 'alter table  SNDB_message_data drop constraint Fk_To_messg_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_message_data drop constraint Fk_From_messg_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_message_data'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table  SNDB_conversation_data drop constraint Fk_frd_user_start_id'; 
exception when others then null; 
end;
/
begin 
execute immediate 'alter table  SNDB_conversation_data drop constraint FK_participant_id'; 
exception when others then null; 
end;
/

begin 
execute immediate 'DROP TABLE SNDB_conversation_data'; 
exception when others then null; 
end;
/

begin 
execute immediate 'alter table sndb_addfriend_data drop constraint Fk_friend_status_id'; 
exception when others then null; 
end;
/
begin 
execute immediate 'DROP TABLE sndb_addfriend_data'; 
exception when others then null; 
end;
/


begin 
execute immediate 'alter table  SNDB_STATUS drop constraint CHK_STATUS'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_STATUS'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_user_photo_data'; 
exception when others then null; 
end;
/
begin 
execute immediate 'Drop table SNDB_LOGGED_IN_DATA'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_VOTES_DATA'; 
exception when others then null; 
end;
/
begin 
execute immediate 'Drop table SNDB_post_data'; 
exception when others then null; 
end;
/
begin 
execute immediate 'alter table  SNDB_USER_ACCOUNT drop constraint UQ_fields'; 
exception when others then null; 
end;
/

begin 
execute immediate 'Drop table SNDB_USER_ACCOUNT'; 
exception when others then null; 
end;
/
begin 
execute immediate 'drop table SNDB_gender_data'; 
exception when others then null; 
end;
/
begin 
execute immediate 'Drop table SNDB_user_login'; 
exception when others then null; 
end;
/
begin 
execute immediate 'Drop table SNDB_user_roles_data'; 
exception when others then null; 
end;
/


--USER_ROLES data Table creation--
DECLARE
    p_user_roles_data NUMBER;
    user_roles_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_user_roles_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_user_roles_data';
 
    IF p_user_roles_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_user_roles_data(
       role_id number NOT NULL PRIMARY KEY,
       role_name varchar2(50) NOT NULL unique,
       role_description varchar2(50)
          
    )';
   DBMS_OUTPUT.PUT_LINE('TABLE CONFIG_TABLE CREATED SUCCESSFULLY');
    ELSE
        RAISE user_roles_data_table_exsists;
    END IF;
EXCEPTION
    WHEN user_roles_data_table_exsists THEN
        dbms_output.put_line('SNDB_user_roles_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_user_roles_data Table already in use by existing object');
        END IF;
END;
/

DECLARE
    p_user_login NUMBER;
    user_login_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_user_login
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_user_login';

    IF p_user_login = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_user_login(
       user_login_id number NOT NULL,
       username varchar2(50) NOT NULL,
       password varchar2(50) NOT NULL,
       user_type varchar2(50) not null,
       CONSTRAINT user_login_id_pk PRIMARY KEY (user_login_id),
        CONSTRAINT FK_user_type FOREIGN KEY (user_type)
       REFERENCES SNDB_USER_ROLES_DATA(ROLE_NAME)
    )';
     
    ELSE
        RAISE user_login_exsists;
    END IF;
EXCEPTION
    WHEN user_login_exsists THEN
        dbms_output.put_line('SNDB_user_login Table already exists');
          WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_user_login Table already in use by existing object'); 
        END IF;
END;
/
--gender_data data Table creation–

DECLARE
    p_gender_data NUMBER;
    gender_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_gender_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_GENDER_DATA';

    IF p_gender_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_gender_data (
       gender_id number NOT NULL,
       name varchar2(50) NOT NULL,
CONSTRAINT gender_id_pk PRIMARY KEY (gender_id )
 )';
   ELSE
        RAISE gender_data_table_exsists ;
    END IF;
EXCEPTION
    WHEN gender_data_table_exsists THEN
       dbms_output.put_line('SNDB_gender_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_gender_data  Table already in use by existing object'); 
        END IF;
END;
/

--USER_ACCOUNT Table creation–

DECLARE
    p_user_account NUMBER;
    user_account_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_user_account 
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_user_account';

    IF p_user_account = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_user_account(
        user_account_id number not null,
       user_id int not null unique,
      first_name varchar2(50) not null,
      last_name varchar2(50) not null,
      email_id varchar2(50) not null,
      phone_number int,
      university_name varchar2(50),
      college_name varchar2(50),
      course_name varchar2(50),
      gender_id int,
      dob date,
      otp int,
      created_at timestamp,
      CONSTRAINT user_id_pk PRIMARY KEY (user_account_id),
  CONSTRAINT FK_user_id FOREIGN KEY (gender_id)
   REFERENCES SNDB_gender_data(gender_id)
    )';
      ELSE
        RAISE user_account_table_exsists ;
    END IF;
EXCEPTION
    WHEN user_account_table_exsists THEN
        dbms_output.put_line('SNDB_user_account Table already exists');
          WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_user_account Table already in use by existing object'); 
        END IF;
END;
/
ALTER TABLE SNDB_USER_ACCOUNT
ADD CONSTRAINT UQ_fields UNIQUE (email_id, phone_number);

ALTER TABLE SNDB_USER_ACCOUNT
MODIFY otp int NOT NULL;

ALTER TABLE SNDB_USER_ACCOUNT
ADD CONSTRAINT FK_user_login_id
FOREIGN KEY (user_id) REFERENCES SNDB_USER_LOGIN(user_login_id);

DECLARE
    p_post_data_query NUMBER;
    post_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_post_data_query
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_post_data';

    IF p_post_data_query = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_POST_DATA(
       post_id number NOT NULL,
       subject varchar2(50) NOT NULL,
       content varchar2(50),
       user_id number NOT NULL,
       CONSTRAINT post_id_pk PRIMARY KEY (post_id),
       CONSTRAINT FK_POST_user_id FOREIGN KEY (user_id)
       REFERENCES SNDB_USER_ACCOUNT(user_id)
    )';
     
    ELSE
        RAISE post_data_table_exsists;
    END IF;
EXCEPTION
    WHEN post_data_table_exsists THEN
        dbms_output.put_line('SNDB_post_data Table already exists');
          WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_post_data Table already in use by existing object'); 
        END IF;
END;
/

--Votes data Table creation–

DECLARE
    p_votes_data NUMBER;
    votes_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_votes_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_VOTES_DATA';

    IF p_votes_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_votes_data(
       vote_id number NOT NULL,
       post_id number NOT NULL,
       upcount number,
       downcount number,
        CONSTRAINT vote_id_pk PRIMARY KEY (vote_id),
       CONSTRAINT FK_post_id FOREIGN KEY (post_id)
       REFERENCES SNDB_POST_DATA(post_id)
    )';
    
    ELSE
        RAISE votes_data_table_exsists;
    END IF;
EXCEPTION
    WHEN votes_data_table_exsists THEN
        dbms_output.put_line('SNDB_votes_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_votes_data Table already in use by existing object'); 
        END IF;
END;
/

--Logged_in data Table creation–

DECLARE
    p_loggedin_data NUMBER;
    logged_in_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_loggedin_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_LOGGED_IN_DATA';

    IF p_loggedin_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_logged_in_data(
       clock_in_id number NOT NULL,
       user_logged_id number NOT NULL,
       login_time timestamp,
       logout_time timestamp,
        CONSTRAINT clock_in_id_pk PRIMARY KEY (clock_in_id),
       CONSTRAINT FK_user_logged_id FOREIGN KEY (user_logged_id)
       REFERENCES SNDB_USER_ACCOUNT(user_id)
       
    )';
    
  
    ELSE
        RAISE logged_in_data_table_exsists;
    END IF;
EXCEPTION
    WHEN logged_in_data_table_exsists THEN
        dbms_output.put_line('SNDB_logged_in_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_logged_in_data Table already in use by existing object'); 
        END IF;
END;
/

--USER_PHOTO DATA TABLE CREATION

DECLARE
    p_user_photo_data NUMBER;
    user_photo_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_user_photo_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_user_photo_data';
        
    IF p_user_photo_data = 0 THEN
       EXECUTE IMMEDIATE 'CREATE TABLE SNDB_user_photo_data(
        photo_id number NOT NULL ,
        user_account_id number NOT NULL,
        photo_link varchar2(50),
        time_added timestamp,
        photo_visibility varchar2(10),
        CONSTRAINT photo_id_pk PRIMARY KEY (photo_id ),
       CONSTRAINT FK_user_account_id FOREIGN KEY (user_account_id )
     REFERENCES SNDB_user_account(user_id)
    )';
     ELSE
        RAISE user_photo_data_table_exsists ;
    END IF;
EXCEPTION
    WHEN user_photo_data_table_exsists THEN
        dbms_output.put_line('SNDB_user_photo_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_user_photo_data Table already in use by existing object'); 
        END IF;
END;
/

--status Table creation–

DECLARE
    p_status NUMBER;
    status_table_exists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_status
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_STATUS';
    IF p_status = 0 THEN
       EXECUTE IMMEDIATE 'CREATE TABLE SNDB_status(
       status_id number NOT NULL,
       status_type varchar2(30) NOT NULL,
       CONSTRAINT status_id_pk PRIMARY KEY (status_id)
  
    )';
    ELSE
        RAISE status_table_exists;
    END IF;
EXCEPTION
    WHEN status_table_exists THEN
        dbms_output.put_line('SNDB_status Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_status Table already in use by existing object'); 
        END IF;
END;
/

ALTER TABLE SNDB_STATUS
ADD CONSTRAINT CHK_STATUS CHECK (STATUS_TYPE IN('Accepted','Rejected','Pending'));


--addfriend data Table creation–

DECLARE
    p_addfriend_data NUMBER;
    addfriend_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_addfriend_data 
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_addfriend_data';

    IF p_addfriend_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_addfriend_data(
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
    )';

    ELSE
        RAISE addfriend_data_table_exsists ;
    END IF;
EXCEPTION
    WHEN addfriend_data_table_exsists THEN
        dbms_output.put_line('SNDB_addfriend_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_addfriend_data Table already in use by existing object'); 
        END IF;
END;
/
ALTER TABLE sndb_addfriend_data
ADD CONSTRAINT Fk_friend_status_id
   FOREIGN KEY (status_id)
   REFERENCES sndb_STATUS (status_id );
   
-- conversation_data Table creation–

DECLARE
    p_conversation_data NUMBER;
    conversation_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_conversation_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_CONVERSATION_DATA';

    IF p_conversation_data = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_conversation_data(
        conversation_pri_id number NOT NULL,
       conversation_id number NOT NULL,
       conversation_initiated_id number NOT NULL,
       conversation_started timestamp,
       conversation_ended timestamp,
       participant_id number NOT NULL,
CONSTRAINT convers_pri_id_pk PRIMARY KEY (conversation_pri_id),
CONSTRAINT frd_conversation_id_FK FOREIGN KEY (conversation_id)
    REFERENCES SNDB_ADDFRIEND_DATA(FRIENDSHIP_ID)
    
    )';

    ELSE
        RAISE conversation_data_table_exsists;
    END IF;
EXCEPTION
    WHEN conversation_data_table_exsists THEN
        dbms_output.put_line('SNDB_conversation_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_conversation_data Table already in use by existing object'); 
        END IF;
END;
/

ALTER TABLE SNDB_conversation_data
ADD CONSTRAINT Fk_frd_user_start_id
   FOREIGN KEY (conversation_initiated_id)
   REFERENCES SNDB_user_account (user_id);
   
ALTER TABLE SNDB_conversation_data add CONSTRAINT FK_participant_id FOREIGN KEY (participant_id)
    REFERENCES SNDB_user_account(user_id);

--MESSAGE DATA TABLE CREATION—


DECLARE
    p_message_data NUMBER;
    p_message_data_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_message_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_message_data';
    IF p_message_data = 0 THEN
    EXECUTE IMMEDIATE 'CREATE TABLE SNDB_message_data(
       message_id number NOT NULL,
       messsage_content varchar2(1000),
       message_timestamp timestamp,
       conversation_id number NOT NULL,
       from_message_id number NOT NULL,
       to_message_id number NOT NULL,
CONSTRAINT message_id_pk PRIMARY KEY (message_id ),
CONSTRAINT FK_conve_mssg_id FOREIGN KEY (conversation_id )
    REFERENCES SNDB_conversation_data(conversation_PRI_id)

    )';
    ELSE
        RAISE p_message_data_exsists;
    END IF;
EXCEPTION
    WHEN p_message_data_exsists THEN
        dbms_output.put_line('SNDB_message_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_message_data Table already in use by existing object'); 
        END IF;
END;
/

ALTER TABLE SNDB_message_data
ADD CONSTRAINT Fk_From_messg_id FOREIGN KEY (from_message_id)
    REFERENCES SNDB_USER_ACCOUNT(USER_ID);

ALTER TABLE SNDB_message_data
ADD CONSTRAINT Fk_To_messg_id FOREIGN KEY (to_message_id)
    REFERENCES SNDB_USER_ACCOUNT(USER_ID);

     
 ALTER TABLE SNDB_MESSAGE_DATA 
 ADD CONSTRAINT UQ_conversation_id Unique (conversation_id);


--Payment Request TABLE CREATION—

DECLARE
    p_payment_request_data NUMBER;
    payment_request_data_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_payment_request_data
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_payment_request_data';

    IF p_payment_request_data = 0 THEN
       EXECUTE IMMEDIATE 'CREATE TABLE SNDB_payment_request_data(
        payment_request_id number NOT NULL ,
        requester_id number NOT NULL,
        reciever_id number NOT NULL,
        request_status varchar2(10) NOT NULL,
        request_amount number NOT NULL,
        payment_description varchar2(50) ,
        payment_date date NOT NULL,
        payment_method varchar2(50) NOT NULL,
        conversation_id number NOT NULL,
      CONSTRAINT payment_reqt_id_pk PRIMARY KEY (payment_request_id )
        
      
    )';
    ELSE
        RAISE payment_request_data_table_exsists ;
    END IF;
EXCEPTION
    WHEN payment_request_data_table_exsists THEN
        dbms_output.put_line('SNDB_payment_request_data Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_payment_request_data Table already in use by existing object'); 
        END IF;
END;
/



ALTER TABLE SNDB_payment_request_data
ADD CONSTRAINT Fk_paymnt_reciever_id FOREIGN KEY (reciever_id)
      REFERENCES SNDB_user_account (user_id);

ALTER TABLE SNDB_payment_request_data
ADD  CONSTRAINT Fk_paymnt_requester_id FOREIGN KEY (requester_id)
      REFERENCES SNDB_user_account (user_id);
      
  ALTER TABLE SNDB_payment_request_data
ADD  CONSTRAINT FK_conversation_id FOREIGN KEY (conversation_id)
     REFERENCES SNDB_Message_data(conversation_id);

 
--group Table creation--
DECLARE
    p_group NUMBER;
    group_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_group 
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_group';

    IF p_group = 0 THEN
       EXECUTE IMMEDIATE 'CREATE TABLE SNDB_group(
       group_id number NOT NULL,
       group_name varchar2(50) NOT NULL,
       created_date date,
       Is_group_active varchar2(10) NOT NULL,
CONSTRAINT group_id_pk PRIMARY KEY (group_id)

    )';
    ELSE
        RAISE group_table_exsists ;
    END IF;
EXCEPTION
    WHEN group_table_exsists THEN
        dbms_output.put_line('SNDB_group Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_group Table already in use by existing object'); 
        END IF;
END;
/

--user_account_group data Table creation–


DECLARE
    p_user_account_group NUMBER;
    user_account_group_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_user_account_group 
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_user_account_group';

    IF p_user_account_group = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_user_account_group(
    
       user_account_id number NOT NULL,
       group_id number NOT NULL,
     
    CONSTRAINT FK_user_group_account_id FOREIGN KEY (user_account_id)
       REFERENCES SNDB_user_account(user_id),
         CONSTRAINT FK_user_MSSG_id FOREIGN KEY (group_id)
       REFERENCES SNDB_GROUP(GROUP_id)
    )';


    ELSE
        RAISE user_account_group_table_exsists ;
    END IF;
EXCEPTION
    WHEN user_account_group_table_exsists THEN
        dbms_output.put_line('SNDB_user_account_group Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_user_account_group Table already in use by existing object'); 
        END IF;
END;
/



ALTER TABLE SNDB_user_account_group
ADD CONSTRAINT user_group_ID PRIMARY KEY (user_account_id, group_id);

--GROUP RECIPIENT table creation–

DECLARE
    p_group_recipient NUMBER;
    p_group_recipient_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_group_recipient
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_group_recipient';

    IF p_group_recipient = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_group_recipient(
       group_recipient_id number NOT NULL,
       group_id number NOT NULL,
       user_id number NOT NULL,
       created_date date NOT NULL,
       is_group_active varchar2(10),
       group_message_id number NOT NULL unique,
       CONSTRAINT group_recipnt_id_pk PRIMARY KEY (group_recipient_id )
          )';
    ELSE
        RAISE p_group_recipient_exsists;
    END IF;
EXCEPTION
    WHEN p_group_recipient_exsists THEN
        dbms_output.put_line('SNDB_group_recipient Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_group_recipient Table already in use by existing object'); 
        END IF;
END;
/


alter table SNDB_group_recipient
add  CONSTRAINT FK_user_grp_ID_key FOREIGN KEY (user_id,group_id)
    REFERENCES SNDB_USER_ACCOUNT_GROUP(user_account_id,group_id);

--reminder_freq Table creation--
DECLARE
    p_reminder_freq NUMBER;
    reminder_freq_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_reminder_freq 
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_reminder_freq';
    IF p_reminder_freq = 0 THEN
       EXECUTE IMMEDIATE 'CREATE TABLE SNDB_reminder_freq(
       reminder_id number NOT NULL,
       freq_type varchar2(20)  NOT NULL,
       is_active varchar2(20)  NOT NULL,
       CONSTRAINT reminder_id_pk PRIMARY KEY (reminder_id )
         )';
    ELSE
        RAISE reminder_freq_exsists;
    END IF;
EXCEPTION
    WHEN reminder_freq_exsists THEN
        dbms_output.put_line('SNDB_reminder_freq Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_reminder_freq Table already in use by existing object'); 
        END IF;
END;
/

-- group_message Table creation--
DECLARE
    p_group_message NUMBER;
    p_group_message_table_exsists EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO p_group_message
    FROM
        user_tables
    WHERE
        table_name = 'SNDB_group_message';

    IF p_group_message = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SNDB_group_message(
        group_message_PRI_id number NOT NULL,
       group_message_id number NOT NULL,
       subject varchar2(50),
       creator_id number NOT NULL,
       group_message_content clob NOT NULL,
       group_message_created_date date NOT NULL,
       Is_reminder varchar2(10) NOT NULL,
       Next_reminder_date date NOT NULL,
       reminder_freq_id number NOT NULL,
       reminder_expiry_date date NOT NULL,
       group_message_status varchar2(10),
CONSTRAINT group_message_id_pk PRIMARY KEY (group_message_PRI_id ),
   CONSTRAINT FK_creator_id FOREIGN KEY (creator_id)
    REFERENCES SNDB_user_account(user_id),
    CONSTRAINT FK_RECIP_MESSAGE_id FOREIGN KEY (group_message_id)
    REFERENCES SNDB_GROUP_RECIPIENT(group_message_id),
    CONSTRAINT FK_reminder_frequ_id FOREIGN KEY (reminder_freq_id)
    REFERENCES SNDB_reminder_freq(reminder_id)
          )';
    ELSE
        RAISE p_group_message_table_exsists;
    END IF;
EXCEPTION
    WHEN p_group_message_table_exsists THEN
        dbms_output.put_line('SNDB_group_message Table already exists');
     WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('SNDB_group_message Table already in use by existing object'); 
        END IF;
END;

/





