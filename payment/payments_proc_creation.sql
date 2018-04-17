

use staging_payments
GO

drop proc payments_asis_valid;
drop proc payments_valid_reception;

create proc dbo.payments_asis_valid
as
begin
	
	delete from dbo.payments_valid;
	insert into dbo.payments_valid(
		payment_code,
		payment_mode,
		payment_amount,
		payment_date,
		customer_code,
		order_code,
		billing_address,
		shipment_address,
		invalid_flag
	)
	select 
		isnull(payment_code, ''),
		isnull(payment_mode, ''),
		CASE WHEN TRY_CONVERT(int, ISNULL(payment_amount, -1)) IS NULL THEN -1
		ELSE ISNULL(payment_amount, -1) END,
		CASE WHEN TRY_CONVERT(datetime, ISNULL(payment_date, CAST('1900-01-01' as date))) IS NULL THEN -1
		ELSE ISNULL(payment_date, CAST('1900-01-01' as date)) END,
		isnull(customer_code, ''), 
		isnull(order_code, ''),  
		isnull(billing_address, ''),
		isnull(shipment_address, ''),
		'VALID'
	from dbo.payments_asis ;

	update dbo.payments_valid set invalid_flag='INVALID' where payment_amount=-1 
	or payment_mode='' or payment_code='' or order_code='' or payment_date=cast('1900-01-01' as date);
 end


create proc dbo.payments_valid_reception
as
begin
	
	delete from dbo.payments_reception;
	insert into dbo.payments_reception(
		payment_SK,
		payment_code,
		payment_mode,
		payment_amount,
		payment_date,
		customer_code,
		order_code,
		billing_address,
		shipment_address,
		invalid_flag
	)
	select 
		CONCAT(YEAR(GETDATE()), NEXT VALUE FOR dbo.payments_sur_key_sequence),
		payment_code,
		payment_mode,
		payment_amount,
		payment_date,
		customer_code,
		order_code,
		billing_address,
		shipment_address,
		invalid_flag
	from dbo.payments_valid where invalid_flag = 'VALID';
end

sp_help payments_valid

use edw_payments
go
drop proc proc_payments_payment_reception_edw
create proc dbo.proc_payments_payment_reception_edw
as
begin
	
	update A set updated_dts=GETDATE()
	from edw_payments.dbo.dim_payments A
	INNER JOIN staging_payments.dbo.payments_reception B 
	ON A.payment_code=B.payment_code 
	where A.updated_dts=CONVERT(datetime,'2999-01-01');
	insert into dbo.dim_payments(
		payment_SK,
		payment_code,
		payment_mode,
		payment_amount,
		payment_date,
		customer_code,
		order_code,
		billing_address,
		shipment_address,
		inserted_dts,
		updated_dts
	)
	select 
		payment_SK,
		payment_code,
		payment_mode,
		payment_amount,
		payment_date,
		customer_code,
		order_code,
		billing_address,
		shipment_address,
		GETDATE(),
		CAST('2999-01-01' as date)
	from staging_payments.dbo.payments_reception;
end

