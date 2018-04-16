

use staging_payments
GO

drop proc payments_asis_valid;
drop proc payments_valid_reception;

create proc dbo.payments_asis_valid
as
begin
	
	delete from dbo.payments_valid;
	insert into dbo.payments_valid(
		payment_id,
		payment_mode,
		payment_amount,
		payment_date,
		customer_id, 
		order_id,  
		billing_address,
		shipment_address,
		invalid_flag
	)
	select 
		payment_id,
		isnull(payment_mode, ''),
		isnull(payment_amount, 0.0),
		isnull(payment_date, CONVERT(datetime, '1900-01-01')),
		isnull(customer_id, 0), 
		order_id,  
		isnull(billing_address, ''),
		isnull(shipment_address, ''),
		'VALID'
	from dbo.payments_asis ;

	update dbo.payments_valid set invalid_flag='INVALID' where payment_amount=0 
	or payment_mode not in ('cash', 'online') or payment_date=cast('1900-01-01' as date);
 end


create proc dbo.payments_valid_reception
as
begin
	
	delete from dbo.payments_reception;
	insert into dbo.payments_reception(
		payment_SK,
		payment_id,
		payment_mode,
		payment_amount,
		payment_date,
		customer_id, 
		order_id,  
		billing_address,
		shipment_address,
		invalid_flag
	)
	select 
		CONCAT(YEAR(GETDATE()), NEXT VALUE FOR dbo.payments_sur_key_sequence),
		payment_id,
		payment_mode,
		payment_amount,
		payment_date,
		customer_id, 
		order_id,  
		billing_address,
		shipment_address,
		invalid_flag
	from dbo.payments_valid ;
end

