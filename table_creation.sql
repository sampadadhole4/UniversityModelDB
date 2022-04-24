SET SERVEROUTPUT ON;

CREATE SEQUENCE sndb_role_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_user_login_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_gender_data_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_user_account_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SNDB_STATUS_Seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SNDB_ADDFRIEND_DATA_Seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_CONVERSATION_PRI_id_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_message_data_ID_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE sndb_Payment_Request_ID_seq START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
create sequence sndb_group_seq start with 1 increment by 1 nocache nocycle;
create sequence SNDB_group_recipient_seq start with 1 increment by 1 nocache nocycle;
create sequence SNDB_reminder_freq_seq  start with 1 increment by 1 nocache nocycle;
create sequence SNDB_GROUP_MESSAGE_seq start with 1 increment by 1 nocache nocycle;
create sequence SNDB_USER_PHOTO_DATA_SEQ start with 1 increment by 1 nocache nocycle;
create sequence SNDB_POST_DATA_SEQ start with 1 increment by 1 nocache nocycle;
create sequence SNDB_VOTE_DATA_SEQ start with 1 increment by 1 nocache nocycle;
create sequence SNDB_LOGGED_IN_ID_SEQ start with 1 increment by 1 nocache nocycle;


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


 EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_POST_DATA','CREATE TABLE SNDB_POST_DATA
(
         post_id number NOT NULL,
       subject varchar2(50) NOT NULL,
       content varchar2(50),
       user_id number NOT NULL,
       CONSTRAINT SNDB_post_id_pk PRIMARY KEY (post_id),
       CONSTRAINT SNDB_FK_POST_user_id FOREIGN KEY (user_id)
       REFERENCES SNDB_USER_ACCOUNT(user_id)

)
')]';


 EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_votes_data','CREATE TABLE SNDB_votes_data
(
       vote_id number NOT NULL,
       post_id number NOT NULL,
       upcount number,
       downcount number,
        CONSTRAINT SNDB_vote_id_pk PRIMARY KEY (vote_id),
       CONSTRAINT SNDB_FK_post_id FOREIGN KEY (post_id)
       REFERENCES SNDB_POST_DATA(post_id)


)
')]';

 EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_logged_in_data','CREATE TABLE SNDB_logged_in_data
(
    clock_in_id number NOT NULL,
       user_logged_id number NOT NULL,
       login_time timestamp,
       logout_time timestamp,
        CONSTRAINT SNDB_clock_in_id_pk PRIMARY KEY (clock_in_id),
       CONSTRAINT SNDB_FK_user_logged_id FOREIGN KEY (user_logged_id)
       REFERENCES SNDB_USER_ACCOUNT(user_id)

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

   EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_message_data','CREATE TABLE SNDB_message_data 
                (	
            
            message_id number NOT NULL,
       messsage_content varchar2(1000),
       message_timestamp timestamp,
       conversation_id number NOT NULL,
       from_message_id number NOT NULL,
       to_message_id number NOT NULL,
       IS_PAYMENT_REQUESTED VARCHAR2(10),
CONSTRAINT SNDB_message_id_pk PRIMARY KEY (message_id ),
CONSTRAINT SNDB_FK_conve_mssg_id FOREIGN KEY (conversation_id )
    REFERENCES SNDB_conversation_data(conversation_PRI_id),
 CONSTRAINT SNDB_Fk_From_messg_id FOREIGN KEY (from_message_id)
    REFERENCES SNDB_USER_ACCOUNT(USER_ID),
CONSTRAINT SNDB_Fk_To_messg_id FOREIGN KEY (to_message_id)
       REFERENCES SNDB_USER_ACCOUNT(USER_ID),
       CONSTRAINT sndb_CHK_PAYMENT_REQUESTED CHECK (IS_PAYMENT_REQUESTED IN(''YES'',''NO''))
               )
        ')]';


   EXECUTE IMMEDIATE q'[INSERT INTO CONFIG_TABLE VALUES ('SNDB_payment_request_data','CREATE TABLE SNDB_payment_request_data 
                (	
            
      payment_request_id number NOT NULL ,
        requester_id number NOT NULL,
        reciever_id number NOT NULL,
        request_status varchar2(10) NOT NULL,
        request_amount number NOT NULL,
        payment_description varchar2(50) ,
        payment_date date NOT NULL,
        payment_method varchar2(50) NOT NULL,
        Message_id number NOT NULL,
      CONSTRAINT payment_reqt_id_pk PRIMARY KEY (payment_request_id ),
        CONSTRAINT Fk_paymnt_reciever_id FOREIGN KEY (reciever_id)
      REFERENCES SNDB_user_account (user_id),
      CONSTRAINT Fk_paymnt_requester_id FOREIGN KEY (requester_id)
      REFERENCES SNDB_user_account (user_id),
      CONSTRAINT FK_conversation_id FOREIGN KEY (Message_id)
     REFERENCES SNDB_Message_data(message_id),
      CONSTRAINT sndb_CHK_Prequest_status CHECK (request_status IN(''REQUESTED'',''APPROVED'',''DENIED''))
       
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

    END IF;
END;
/

--DROP TABLE CONFIG_TABLE;


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

