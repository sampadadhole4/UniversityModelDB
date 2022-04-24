create view View_Student_Post_Details as
select a.user_account_id, b.post_id,b.content, b.subject, c.vote_id,c.upcount,c.downcount
from sndb_user_account a, sndb_post_data b , sndb_votes_data c
where a.user_account_id = b.user_id and b.post_id = c.post_id;

select * from View_Student_Post_Details;

update View_Student_Post_Details set 
content = 'Can you come over?' where post_id =45;

--update View_Student_Post_Details set --not working
--upcount = 40 where post_id =42;

update View_Student_Post_Details set 
downcount = 0 where pvost_id = 42;

--update View_Student_Post_Details set --not working
--subject = 'Good Morning' where post_id = 42;