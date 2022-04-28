create or replace procedure SNDB_UPDATE_payment_request_data(
i_payment_request_id in SNDB_payment_request_data.payment_request_id%type,
i_request_status in SNDB_payment_request_data.request_status%type,
i_request_amount in SNDB_payment_request_data.request_amount%type,
i_payment_description in SNDB_payment_request_data.payment_description%type,
i_payment_date in SNDB_payment_request_data.payment_date%type,i_payment_method 
in SNDB_payment_request_data.payment_method%type)
as
j_request_status varchar2(50);
IS_NULL number;
j_payment_date date;
no_change_in_request_status exception;
payment_date_cannot_be_less_than_previous_transaction exception;
request_status_cannot_be_null exception;
request_ammount_cannot_be_blank exception;
payment_request_id_cannot_be_null exception;
payment_dtae_is_null exception;
payment_method_null exception;
begin
CHECK_NULL(i_payment_request_id,IS_NULL);
IF IS_NULL = 1 THEN
RAISE payment_request_id_cannot_be_null;
END IF;
if  i_request_status is null then
raise request_status_cannot_be_null;
end if;
If i_request_amount is null then
raise request_ammount_cannot_be_blank;
end if;
if i_payment_date is null then
raise payment_dtae_is_null;
end if;
if i_payment_method is null then
raise payment_method_null;
end if;
select d.request_status into j_request_status from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;
select d.payment_date into j_payment_date from SNDB_payment_request_data d where d.payment_request_id = i_payment_request_id;

if j_request_status = i_request_status then
raise no_change_in_request_status;
end if;

if j_request_status != i_request_status then 
update SNDB_payment_request_data e set e.request_status = i_request_status, e.request_amount = i_request_amount,e.payment_description = i_payment_description ,  e.payment_date = i_payment_date where e.payment_request_id = i_payment_request_id;
dbms_output.put_line('request status, amount, payemnt description and payment date is updated');
end if;
--if i_payment_date >= j_payment_date then
--update SNDB_payment_request_data f set f.payment_date = i_payment_date where f.payment_request_id = i_payment_request_id; 
--dbms_output.put_line('payment_date is updated');
--else
--raise payment_date_cannot_be_less_than_previous_transaction;
--end if;

exception
when no_change_in_request_status then
dbms_output.put_line('request status id is same and please ebter the diffrent status id');
--when payment_date_cannot_be_less_than_previous_transaction then
--dbms_output.put_line('payment date cannot be less than previous transaction');
when request_status_cannot_be_null then
dbms_output.put_line('request status cannot be null');
when request_ammount_cannot_be_blank then
dbms_output.put_line('request ammount must have a value');
when payment_request_id_cannot_be_null then
dbms_output.put_line('payment request id must have a value');
when payment_dtae_is_null then
dbms_output.put_line('payment date is null, please enter a date');
when payment_method_null then
dbms_output.put_line('payment method  is null, please enter a payment method');
end;
/

