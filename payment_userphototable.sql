-Payment Request TABLE CREATION—

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
