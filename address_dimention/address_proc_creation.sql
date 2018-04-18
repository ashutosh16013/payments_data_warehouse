
use staging_payments
GO

Drop proc address_asis_valid;
drop proc address_valid_reception
create proc address_asis_valid
as
begin

	Delete from dbo.address_valid;
	insert into dbo.address_valid 
	(
		address_code,
		address_details,
		city,
		country,
		address_pincode,
		customer_code,
		address_type,
		invalid_flag
	)
	select
		isnull(address_code, ''),
		isnull(address_details, ''),
		isnull(city, ''),
		ISNULL(country, ''),
		CASE WHEN TRY_CONVERT(int, ISNULL(address_pincode, -1)) IS NULL THEN -1
		ELSE ISNULL(address_pincode, -1) END,
		isnull(customer_code, ''),
		isnull(address_type, ''),
		'VALID'
		from dbo.address_asis;

	update dbo.address_valid set invalid_flag='INVALID'
	where address_code='' or address_pincode=-1 OR country='' OR customer_code=''
end

Drop proc address_valid_reception;
create proc address_valid_reception
as
begin

	delete from dbo.address_reception;
	insert into dbo.address_reception
	(
		address_sk,
		address_code,
		address_details,
		city,
		country,
		address_pincode,
		customer_code,
		address_type,
		invalid_flag
	)
	select 
		CONCAT(YEAR(GETDATE()), NEXT VALUE FOR dbo.address_sur_key_sequence),
		address_code,
		address_details,
		city,
		country,
		address_pincode,
		customer_code,
		address_type,
		invalid_flag
	from dbo.address_valid where invalid_flag='VALID';
end

use edw_payments
go
drop proc proc_payments_address_reception_edw;
create proc proc_payments_address_reception_edw
as
begin

	update A set updated_dts=GETDATE()
	from edw_payments.dbo.dim_address A
	INNER JOIN staging_payments.dbo.address_reception B 
	ON A.address_code=B.address_code 
	where A.updated_dts=CONVERT(datetime,'2999-01-01');

	insert into edw_payments.dbo.dim_address
	(
		address_sk,
		address_code,
		address_details,
		city,
		country,
		address_pincode,
		customer_code,
		address_type,
		inserted_dts,
		updated_dts
	)
	select 
		address_sk,
		address_code,
		address_details,
		city,
		country,
		address_pincode,
		customer_code,
		address_type,
		GETDATE(),
		CAST('2999-01-01' as date)
	from staging_payments.dbo.address_reception;
end


sp_help address_valid