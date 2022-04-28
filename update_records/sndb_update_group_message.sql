create or replace procedure SNDB_UPDATE_GROUP_MESSAGE(
i_group_message_PRI_id in SNDB_GROUP_MESSAGE.group_message_PRI_id%type,
i_Is_reminder in SNDB_GROUP_MESSAGE.Is_reminder%type,
i_reminder_freq_id in SNDB_GROUP_MESSAGE.reminder_freq_id%type
)
as
j_Next_reminder_date date;
j_Is_reminder varchar2(50);
j_reminder_freq_id number;
reminder_freq_id_cannot_be_null exception;
is_reminder_cannot_be_same exception;
same_freq_id_cannot_be_updated exception;
reminder_id_expiry_date_must_be_greater_than_group_created_date EXCEPTION;
group_message_id_cannot_be_null exception;
j_group_message_created_date date;
is_reminder_freq_is_null exception;
begin
if i_group_message_PRI_id is null then
raise group_message_id_cannot_be_null;
end if;
if i_Is_reminder is null or length(i_Is_reminder) = 0 then
raise is_reminder_freq_is_null;
end if;
IF i_reminder_freq_id is null then
raise reminder_freq_id_cannot_be_null;
end if;
select a.Is_reminder into j_Is_reminder from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
select a.reminder_freq_id into j_reminder_freq_id from sndb_group_message a where a.group_message_PRI_id = i_group_message_PRI_id;
if j_Is_reminder != i_Is_reminder then
raise is_reminder_cannot_be_same;
end if;

if j_reminder_freq_id != i_reminder_freq_id then
 if i_reminder_freq_id = 1 then
  update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +1, e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
 dbms_output.put_line('upadted reminder freq id of 1 ,next reminder date,is reminder for a group');
  end if;
  
 if i_reminder_freq_id = 2 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +7 , e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
  dbms_output.put_line('upadted reminder freq id of 2 ,next reminder date,is reminder for a group');
 end if;
 
 if i_reminder_freq_id = 3 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +14 ,  e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
dbms_output.put_line('upadted reminder freq id of 3 ,next reminder date,is reminder for a group');
 end if;
 
 if i_reminder_freq_id = 4 then
 update SNDB_GROUP_MESSAGE e set e.reminder_freq_id = i_reminder_freq_id ,
 Next_reminder_date = sysdate +30 ,e.Is_reminder = i_Is_reminder  where e.group_message_PRI_id = i_group_message_PRI_id;
 dbms_output.put_line('upadted reminder freq id of 4 ,next reminder date, is reminder for a group');
 end if;
  else
 raise same_freq_id_cannot_be_updated;
 end if;
exception
when same_freq_id_cannot_be_updated then
dbms_output.put_line('same freq id cannot be updated');
when is_reminder_cannot_be_same then
dbms_output.put_line('same is_reminder cannot be updated');
when group_message_id_cannot_be_null then
dbms_output.put_line('group message pri id cannot be null');
when is_reminder_freq_is_null then
dbms_output.put_line('is reminder freq is null');
when reminder_freq_id_cannot_be_null then
dbms_output.put_line('reminder_freq_id_cannot_be_null');
WHEN others then
if sqlcode=-02290 then
dbms_output.put_line('1. reminder_id should be from the following list: ''YES'',''NO''');
end if;
end;
/

begin
SNDB_UPDATE_GROUP_MESSAGE(1,'YES',NULL);
end;