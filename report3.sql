Select TRUNC(cast(conversation_started as date),'IW') , 'Weekly(Week start date)', count(*)
as Number_of_conversations from sndb_conversation_data group by TRUNC(cast(conversation_started as date),'IW')








EXPLAIN PLAN FOR
SELECT * FROM sndb_user_roles_data
WHERE lower(Role_name) = 'USER';

SELECT 
    PLAN_TABLE_OUTPUT 
FROM 
    TABLE(DBMS_XPLAN.DISPLAY());
    
 
 

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
   


select a.friendship_id,b.status_type,(select c.first_name  from  sndb_user_account c 
where a.requester_id =  c.user_id) as Requester_Name,(select c.first_name  from  sndb_user_account c 
where a.addressee_id =  c.user_id)as addresse_name
from sndb_addfriend_data a,sndb_status b
where a.status_id=b.status_id;