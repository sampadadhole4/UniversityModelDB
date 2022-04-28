------------Reports Visulization in sql developer-------------

select e.group_id, 'group user count', count(*) from sndb_user_account_group e join sndb_group d
on e.group_id = d.group_id  group by e.group_id order by e.group_id;

select e.role_name , 'Role count' , count(*)
from sndb_user_roles_data e
join sndb_user_login d
on e.role_name = d.user_type
group by e.role_name;