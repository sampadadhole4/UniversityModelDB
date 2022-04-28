select a.user_account_id, ' no of requests', count(*) from sndb_user_account a join sndb_addfriend_data b on (a.user_account_id = b.requester_id or a.user_account_id = b.addressee_id)
group by a.user_account_id order by count(*) ASC;



select a.user_account_id, ' no of payement reqs', count(*) from sndb_user_account a join sndb_payment_request_data b on (a.user_account_id = b.requester_id or a.user_account_id = b.reciever_id)
group by a.user_account_id order by count(*) ASC;
