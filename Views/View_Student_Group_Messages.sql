create view View_Student_Group_Messages as
select a.group_message_id,b.user_id,b.group_id,a.reminder_expiry_date,a.next_reminder_date,
c.freq_type,a.is_reminder,a.subject, a.group_message_content,c.is_active
from sndb_group_message a, 
sndb_group_recipient b, 
sndb_reminder_freq c
where a.reminder_freq_id= c.reminder_id 
and b.group_message_id= a.group_message_id;


update View_Student_Group_Messages
set is_reminder = 'Yes'  where
group_message_id =1 and user_id=1 and group_id=1;
update View_Student_Group_Messages set
freq_type='Weekly'
where group_id = 1 and group_message_id = 1;

update view_student_group_messages set 
reminder_expiry_date ='07-JAN-1976' where 
group_id = 1 and group_message_id = 1;