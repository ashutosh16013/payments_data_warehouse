USE staging_payments
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

sp_help customer_valid

drop procedure proc_dim_payments_customer_asis_valid

CREATE PROC [dbo].[proc_dim_payments_customer_asis_valid]
as 
begin

	TRUNCATE TABLE [dbo].[customer_valid];

	INSERT INTO [customer_valid]
		(customer_code,
		 customer_first_name,
		 customer_middle_name,
		 customer_last_name,
		 customer_gender,
		 customer_address,
		 customer_telephone,
		 customer_email,
		 customer_relationship_status,
		 customer_registration_date,
		 invalid_flag
		) 
	select
		ISNULL(customer_code,''), 
		ISNULL(customer_first_name, ''),
		ISNULL(customer_middle_name, '') ,
		ISNULL(customer_last_name, ''),
		ISNULL(customer_gender, ''),
		ISNULL(customer_address, ''),
		CASE WHEN TRY_CONVERT(int, ISNULL(customer_telephone, -1)) IS NULL THEN -1
		ELSE ISNULL(customer_telephone, -1) END,
		ISNULL (customer_email,''),
		ISNULL (customer_relationship_status,''),
		CASE WHEN TRY_CONVERT(date, ISNULL(customer_registration_date, CAST('1900-01-01' as DATE))) IS NULL THEN CAST('1900-01-01' as DATE)
		ELSE ISNULL(customer_registration_date, CAST('1900-01-01' as DATE)) END,
		'VALID'
    from dbo.customer_asis;
    
    
    update customer_valid set invalid_flag='INVALID'
    where customer_code='' OR customer_first_name ='' OR (customer_telephone=-1 AND customer_email='') OR customer_registration_date =CAST('1900-01-01' as DATE);
end
GO


--procedure_customer_valid_reception

sp_help customer_reception
drop procedure proc_payments_customer_valid_reception

CREATE PROC [dbo].[proc_payments_customer_valid_reception]
as 
begin

	TRUNCATE TABLE [dbo].[customer_reception];

	INSERT INTO [customer_reception]
		(customer_SK,
		 customer_code,
		 customer_first_name,
		 customer_middle_name,
		 customer_last_name,
		 customer_gender,
		 customer_address,
		 customer_telephone,
		 customer_email,
		 customer_relationship_status,
		 customer_registration_date,
		 invalid_flag
		) 
	select
		CONCAT(YEAR(GETDATE()), NEXT VALUE FOR dbo.customer_sur_key_sequence),
		customer_code,
		 customer_first_name,
		 customer_middle_name,
		 customer_last_name,
		 customer_gender,
		 customer_address,
		 customer_telephone,
		 customer_email,
		 customer_relationship_status,
		 customer_registration_date,
		 invalid_flag
    from dbo.customer_valid where invalid_flag='VALID';
    
end
GO

--procedure for staging to edw
USE edw_payments
GO

DROP procedure proc_payments_customer_reception_edw

CREATE PROC [dbo].[proc_payments_customer_reception_edw]
as 
begin
	
	update A set updated_dts=GETDATE()
	from edw_payments.dbo.dim_customer A
	INNER JOIN staging_payments.dbo.customer_reception B 
	ON A.customer_code=B.customer_code 
	where A.updated_dts=CONVERT(datetime,'2999-01-01');

	INSERT INTO edw_payments.dbo.[dim_customer]
		(customer_SK,
		 customer_code,
		 customer_first_name,
		 customer_middle_name,
		 customer_last_name,
		 customer_gender,
		 customer_address,
		 customer_telephone,
		 customer_email,
		 customer_relationship_status,
		 customer_registration_date,
		 inserted_dts,
		 updated_dts
		) 
	select
		customer_SK,
		customer_code, 
		customer_first_name,
		customer_middle_name,
		customer_last_name,
		customer_gender,
		customer_address,
		customer_telephone,
		customer_email,
		customer_relationship_status,
		customer_registration_date,
		GETDATE(),
		CONVERT(datetime,'2999-01-01')
    from staging_payments.dbo.customer_reception;
    
end
GO