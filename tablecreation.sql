-GROUP RECIPIENT table creation–

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




-MESSAGE DATA TABLE CREATION—


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
