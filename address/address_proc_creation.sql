
use staging_payments
GO

Drop proc address_asis_valid;
create proc address_asis_valid
as
begin

	Delete from dbo.address_valid;
	insert into dbo.address_valid 
	(
		address_id,
		address_details,
		city,
		country,
		address_pincode,
		customer_id,
		address_type,
		invalid_flag
	)
	select
		address_id,
		isnull(address_details, ''),
		isnull(city, ''),
		ISNULL(country, ''),
		isnull(address_pincode, 0),
		customer_id,
		isnull(address_type, ''),
		'VALID'
		from dbo.address_asis;
end

Drop proc address_valid_reception;
create proc address_valid_reception
as
begin

	delete from dbo.address_reception;
	insert into dbo.address_reception
	(
		address_sk,
		address_id,
		address_details,
		city,
		country,
		address_pincode,
		customer_id,
		address_type,
		invalid_flag
	)
	select 
		CONCAT(YEAR(GETDATE()), NEXT VALUE FOR dbo.address_sur_key_sequence),
		address_id,
		address_details,
		city,
		country,
		address_pincode,
		customer_id,
		address_type,
		invalid_flag
	from dbo.address_valid;
end
