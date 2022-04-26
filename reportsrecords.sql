Number of conversations started in each week

Script: 
Select TRUNC(cast(conversation_started as date),'IW') as "Weekly(Week start date)", count(*)
as Number_of_conversations from sndb_conversation_data group by TRUNC(cast(conversation_started as date),'IW');


Number of Payment Requests Approved/Denied

Script: 
select request_status as Payment_request,count(*) as count from sndb_payment_request_data group by request_status;


Number of groups created in the week

Script:
select TRUNC(CREATED_DATE,'IW') as "Weekly(Week Start Date)",count(*) as "Number of groups created" from sndb_group group by TRUNC(CREATED_DATE,'IW');


Number of active and inactive groups 

Script:
select IS_GROUP_ACTIVE as "GROUP Active (Yes/NO)",count(*) as "Count" from sndb_group group by IS_GROUP_ACTIVE;



Number of reminders created in a week

Script:
select TRUNC(group_message_created_date,'IW') as "Weekly(Week Start Date)",count(*)
as "Count of reminders in the week" from sndb_group_message where is_reminder='Yes'
group by TRUNC(group_message_created_date,'IW');



