---View_Student_Payment_Details ---

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

------