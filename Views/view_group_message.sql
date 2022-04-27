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


create view view_group_message as
select c.username as username, a.group_message_content, a.subject
from 
sndb_group_message a,
sndb_user_account b,
sndb_user_login c
where b.user_Account_id = a.group_message_pri_id and c.user_login_id = b.user_id and upper(c.username) = 'GET_LOGGEDIN_USER_ID';
