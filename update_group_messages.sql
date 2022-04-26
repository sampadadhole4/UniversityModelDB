create or replace procedure SNDB_UPDATE_GROUP_MESSAGE( i_group_message_PRI_id in SNDB_GROUP_MESSAGE.group_message_PRI_id%type
,i_subject in SNDB_GROUP_MESSAGE.subject%type,
i_group_message_content in SNDB_GROUP_MESSAGE.group_message_content%type,
i_Is_reminder in SNDB_GROUP_MESSAGE.Is_reminder%type,
i_Next_reminder_date in SNDB_GROUP_MESSAGE.Next_reminder_date%type,
i_reminder_freq_id in SNDB_GROUP_MESSAGE.reminder_freq_id%type,
i_reminder_expiry_date in SNDB_GROUP_MESSAGE.reminder_expiry_date%type,
i_group_message_status in SNDB_GROUP_MESSAGE.group_message_status%type)
as
j_Next_reminder_date date;
j_Is_reminder varchar2(50);
j_reminder_freq_id number;
is_reminder_cannot_be_same exception;
same_freq_id_cannot_be_updated exception;
j_group_message_status varchar2(50);
same_group_message_status EXCEPTION;
begin
select a.Is_reminder into j_Is_reminder from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.Next_reminder_date into j_Next_reminder_date from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.reminder_freq_id into j_reminder_freq_id from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.group_message_status into j_group_message_status from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
Update SNDB_GROUP_MESSAGE a set a.subject = i_subject,a.group_message_content= i_group_message_content where a.group_message_PRI_id = i_group_message_PRI_id;
dbms_output.put_line('subject and message_conetnt of the group is updated');
if j_Is_reminder != i_Is_reminder then
update SNDB_GROUP_MESSAGE b set b.Is_reminder = i_Is_reminder where b.group_message_PRI_id = i_group_message_PRI_id;
else raise is_reminder_cannot_be_same;
end if;
if j_group_message_status != i_group_message_status then
update SNDB_GROUP_MESSAGE b set b.group_message_status = i_group_message_status where b.group_message_PRI_id = i_group_message_PRI_id;
else raise same_group_message_status;
end if;
if j_reminder_freq_id != i_reminder_freq_id then
 if i_reminder_freq_id = 1 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +1 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 2 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +7 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 3 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +14 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 if i_reminder_freq_id = 4 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +30 , e.reminder_expiry_date = i_reminder_expiry_date where e.group_message_PRI_id = i_group_message_PRI_id;
 end if;
 else raise same_freq_id_cannot_be_updated;
 end if;
exception
when same_freq_id_cannot_be_updated then
dbms_output.put_line('same freq id cannot be updated');
when is_reminder_cannot_be_same then
dbms_output.put_line('same is_reminder cannot be updated');
when same_group_message_status then
dbms_output.put_line('same group message status cannot be updated');
end;
/