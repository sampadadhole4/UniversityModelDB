create view view_all_data as
select * from user_objects where object_type in ('TABLE','VIEW','INDEX','FUNCTION','PROCEDURE');