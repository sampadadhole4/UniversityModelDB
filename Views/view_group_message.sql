CREATE OR REPLACE FUNCTION GET_LOGGEDIN_USER_ID 
RETURN varchar2 
IS
L_USER_ID varchar2(50);
BEGIN
    SELECT USERNAME 
        INTO L_USER_ID
            FROM 
            all_users 
            WHERE USERNAME = (SELECT USER FROM DUAL);
    RETURN L_USER_ID;
END GET_LOGGEDIN_USER_ID;
/




create or replace view view_group_message as
select c.username as username, a.group_message_content, a.subject
from 
sndb_group_message a,
sndb_user_account b,
sndb_user_login c
where b.user_Account_id = a.group_message_pri_id and c.user_login_id = b.user_id 
and upper(c.username) = GET_LOGGEDIN_USER_ID;



CREATE OR REPLACE VIEW View_Student_Payment_Details AS
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
 on e.message_id = d.message_id where d.is_payment_requested = 'YES' and a.user_type = 'USER' and upper(a.username) = GET_LOGGEDIN_USER_ID;



create or replace view View_Student_Post_Details as
select a.user_account_id, b.post_id,b.content, b.subject, c.vote_id,c.upcount,c.downcount
from sndb_user_account a, sndb_post_data b , sndb_votes_data c
where a.user_account_id = b.user_id and b.post_id = c.post_id;



create or replace view View_Student_profile_photo as
select b.username, a.user_account_id, a.photo_link ,a.time_added ,a.photo_visibility 
from sndb_user_photo_data a, sndb_user_login b where b.user_login_id = a.user_account_id;


create or replace view view_all_data as
select * from user_objects where object_type in ('TABLE','VIEW','INDEX','FUNCTION','PROCEDURE');


create  or replace view View_Student_details as
select a.user_account_id  as User_ID , c.username as User_Name  , a.first_name ||' ' || a.last_name as Full_Name ,
a.email_id as Email_ID, a.phone_number as Phone_Number, a.university_name as University_Name ,
a.college_name as Colleg_Name,a.course_name as Course_Name, a.dob as Date_Of_Birth from sndb_user_account a ,
sndb_user_login c where c.user_login_id = a.user_id and c.user_type = 'User';


-- create or replace view sndb_View_Student_Friends_Details as
-- select  m.requester_id, m.addressee_id ,c.first_name , c.last_name , c.email_id, 
-- c.phone_number, c.university_name, c.college_name, c.course_name,c.dob from sndb_user_account c , 
-- sndb_addfriend_data m where m.addressee_id = c.user_id;