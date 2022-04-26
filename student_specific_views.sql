CREATE VIEW view_student_post_details AS
    SELECT
        a.user_account_id,
        b.post_id,
        b.content,
        b.subject,
        c.vote_id,
        c.upcount,
        c.downcount
    FROM
        sndb_user_account a,
        sndb_post_data    b,
        sndb_votes_data   c
    WHERE
            a.user_account_id = b.user_id
        AND b.post_id = c.post_id;

SELECT
    *
FROM
    sndb_user_login;

SELECT
    *
FROM
    sndb_votes_data;

SELECT
    *
FROM
    sndb_post_data;

CREATE OR REPLACE FUNCTION get_loggedin_user_id RETURN VARCHAR2 IS
    l_user_id VARCHAR2(50);
BEGIN
    SELECT
        username
    INTO l_user_id
    FROM
        all_users
    WHERE
        username = (
            SELECT
                user
            FROM
                dual
        );

    RETURN l_user_id;
END get_loggedin_user_id;
/

CREATE OR REPLACE VIEW view_student_post_details AS
    SELECT
        a.username,
        a.user_login_id,
        b.subject,
        b.content,
        b.post_id,
        c.upcount,
        c.downcount
    FROM
             sndb_user_login a
        JOIN sndb_post_data  b ON a.user_login_id = b.user_id
        JOIN sndb_votes_data c ON c.post_id = b.post_id
    WHERE
            a.user_type = 'User'
        AND upper(a.username) = get_loggedin_user_id;

INSERT INTO sndb_status VALUES (
    1,
    'Pending'
);

INSERT INTO sndb_status VALUES (
    2,
    'Rejected'
);

INSERT INTO sndb_status VALUES (
    3,
    'Accepted'
);

INSERT INTO sndb_addfriend_data VALUES (
    1,
    3,
    4,
    current_timestamp,
    2,
    current_timestamp,
    'Great to connect',
    current_timestamp,
    current_timestamp
);

INSERT INTO sndb_addfriend_data VALUES (
    2,
    4,
    5,
    current_timestamp,
    2,
    current_timestamp,
    'Great to connect',
    current_timestamp,
    current_timestamp
);

INSERT INTO sndb_conversation_data VALUES (
    1,
    1,
    3,
    current_timestamp,
    current_timestamp,
    4
);

INSERT INTO sndb_conversation_data VALUES (
    2,
    2,
    4,
    current_timestamp,
    current_timestamp,
    5
);

INSERT INTO sndb_message_data VALUES (
    1,
    'hello, come soon',
    current_timestamp,
    1,
    3,
    4,
    'YES'
);

INSERT INTO sndb_message_data VALUES (
    2,
    'Great Well Soon',
    current_timestamp,
    2,
    4,
    5,
    'NO'
);

SELECT
    *
FROM
    sndb_addfriend_data;

CREATE OR REPLACE VIEW sndb_view_student_friends_details AS
    SELECT
        m.requester_id,
        m.addressee_id,
        c.first_name,
        c.last_name,
        c.email_id,
        c.phone_number,
        c.university_name,
        c.college_name,
        c.course_name,
        c.dob
    FROM
        sndb_user_account   c,
        sndb_addfriend_data m
    WHERE
        m.addressee_id = c.user_id;

SELECT
    *
FROM
    sndb_user_login;

SELECT
    *
FROM
    sndb_user_account;

SELECT
    *
FROM
    sndb_addfriend_data;
select * from sndb



insert into sndb_payment_request_data values(2000,    3    ,4    ,'APPROVED'    ,1    ,'Shop and stop bill',    TO_TIMESTAMP('01-MAR-22 04:12.49', 'DD-MON-YY HH24:mi:ss'),    'Debit',    1);
insert into sndb_payment_request_data values(2001,    4    ,5,    'REQUESTED',    10.05,    'Wallgreens bill',TO_TIMESTAMP('04-MAR-22 03.11.50', 'DD-MON-YY HH24:mi:ss'),    'Credit',    2);


create or replace view sndb_View_Student_Friends_Details as
select a.user_login_id, c.requester_id,c.addressee_id,a.username ,(b.first_name || ' ' || b.last_name) as Full_Name, 
b.email_id, b.phone_number, b.university_name, b.college_name, b.course_name,b.dob 
from sndb_user_login a        
inner join sndb_user_account b
    on a.user_login_id = b.user_id
inner join sndb_addfriend_data c
    on c.addressee_id = b.user_id where a.user_type = 'User' and upper(a.username) = GET_LOGGEDIN_USER_ID;
    

select * from sndb_message_data;
select * from sndb_addfriend_data;
select * from sndb_user_account;
select * from sndb_user_login;
select * from sndb_payment_request_data;

create or replace view View_Student_One_on_One_Conversations as 
select a.username ,(b.first_name || ' ' || b.last_name) as Full_Name,
d.message_id,e.reciever_id, e.request_status,e.request_amount,e.payment_description,e.payment_date
from sndb_user_login a        
inner join sndb_user_account b
    on a.user_login_id = b.user_id
inner join sndb_addfriend_data c
    on c.addressee_id = b.user_id
inner join sndb_message_data d
   on c.addressee_id = d.to_message_id 
inner join sndb_payment_request_data e
 on e.message_id = d.message_id where d.is_payment_requested = 'YES' and a.user_type = 'User' and upper(a.username) = GET_LOGGEDIN_USER_ID;


select d.first_name as requester, 
c.friendship_id,a.conversation_id,a.request_status,a.request_amount,
a.payment_description,a.payment_method
from sndb_payment_request_data a, 
sndb_conversation_data b,
sndb_addfriend_data c,
sndb_user_account d
where b.conversation_pri_id = a.conversation_id and
c.friendship_id = b.conversation_id and c.requester_id = d.user_id;

s

            
        
        
        
        create or replace view view_friends_message as 
select a.friendship_id, a.requester_id , a.addressee_id,b.messsage_content,a.status_comment,b.message_timestamp,
b.is_payment_requested from sndb_addfriend_data a, sndb_message_data b where a.friendship_id = b.conversation_id and 
a.requester_id = b.from_message_id and a.addressee_id = b.to_message_id;


insert into sndb_group values(1,'DBMS',sysdate,'Yes');
insert into sndb_group values(2,'Team5',sysdate,'No');

insert into sndb_user_account_group values(3,1);
insert into sndb_user_account_group values(4,2);

insert into sndb_group_recipient values(3,1,3,sysdate,'Yes');
insert into sndb_group_recipient values(4,2,4,sysdate,'No');

insert into sndb_reminder_freq values(1,'WEEKLY','YES');
insert into sndb_reminder_freq values(2,'WEEKLY','NO');




insert into sndb_group_message values(1,3,'Hola',1,'How are you doing',sysdate,'YES',sysdate+1,1,sysdate+10,'Read');
insert into sndb_group_message values(2,4,'Give me peace',2,'Hope you are doing fine',sysdate,'YES',sysdate+1,2,sysdate+10,'Read');







select * from sndb_user_account;
select * from sndb_user_login;
select * from sndb_group;
SELECT * FROM sndb_group_recipient;
SELECT * FROM sndb_group_message;

View_Student_Group_Messages

select a.username ,(b.first_name || ' ' || b.last_name) as Full_Name

from sndb_user_login a        
inner join sndb_user_account b
    on a.user_login_id = b.user_id
inner join sndb_group_recipient c
    on c.user_id = b.user_id
inner join sndb_group_message d
   on c.user_id = d.creator_id; 
inner join sndb_payment_request_data e