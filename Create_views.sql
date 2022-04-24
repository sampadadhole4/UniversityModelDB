create view View_Student_details as
select a.user_account_id  as User_ID , c.username as User_Name  , a.first_name ||' ' || a.last_name as Full_Name ,
a.email_id as Email_ID, a.phone_number as Phone_Number, a.university_name as University_Name ,
a.college_name as Colleg_Name,a.course_name as Course_Name, a.dob as Date_Of_Birth from sndb_user_account a ,
sndb_user_login c where c.user_login_id = a.user_id and c.user_type = 'User';

select * from View_Student_details;

update View_Student_details set 
email_id = 'dps@gamil.com' where user_id =4;

update View_Student_details set 
phone_number =  6578904321, university_name = 'OU' , Date_of_birth =  TO_DATE('07/15/2013', 'MM/DD/YYYY') where user_id =4;

------------------------

create or replace view view_friends_message as 
select a.friendship_id, a.requester_id , a.addressee_id,b.messsage_content,a.status_comment,b.message_timestamp,
b.is_payment_requested from sndb_addfriend_data a, sndb_message_data b where a.friendship_id = b.conversation_id and 
a.requester_id = b.from_message_id and a.addressee_id = b.to_message_id;

update view_friends_message set messsage_content = 'There' , status_comment = 'How you doing' , 
message_timestamp = TO_TIMESTAMP('26-jul-22 20.11.12','DD-MON-YY HH24:mi:ss')
where friendship_id = 4 and 
requester_id = 5 and addressee_id = 6;

------------------------------

create or replace view sndb_View_Student_Friends_Details as
select  m.requester_id, m.addressee_id ,c.first_name , c.last_name , c.email_id, 
c.phone_number, c.university_name, c.college_name, c.course_name,c.dob from sndb_user_account c , 
sndb_addfriend_data m where m.addressee_id = c.user_id;

update sndb_View_Student_Friends_Details 
set first_name = 'Jay' , Last_name = 'Veeru', course_name = 'DBMS' Where requester_id = 5 and addressee_id = 6;

------------------------------

create or replace view View_Student_profile_photo as
select b.username, a.user_account_id, a.photo_link ,a.time_added ,a.photo_visibility from sndb_user_photo_data a, sndb_user_login b where b.user_login_id = a.user_account_id

select * from View_Student_profile_photo;

Update View_Student_profile_photo set photo_link = 'http:itsme', photo_visibility = 'NO' where user_account_id = 5;

