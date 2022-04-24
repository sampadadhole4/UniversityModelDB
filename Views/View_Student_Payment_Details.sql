create view View_Student_Payment_Details as
select d.first_name as requester, 
c.friendship_id,a.conversation_id,a.request_status,a.request_amount,
a.payment_description,a.payment_method
from sndb_payment_request_data a, 
sndb_conversation_data b,
sndb_addfriend_data c,
sndb_user_account d
where b.conversation_pri_id = a.conversation_id and
c.friendship_id = b.conversation_id and c.requester_id = d.user_id;