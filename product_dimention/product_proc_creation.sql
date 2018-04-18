use staging_payments;

go
create proc dbo.proc_payments_product_asis_valid
as
begin
	truncate table dbo.product_valid
	insert into staging_payments.dbo.product_valid(
		product_key,
		product_name,
		product_detail,
		product_category,
		product_brand,
		product_manuf_date,
		product_manuf_cost,
		product_manuf_area,
		product_expire_date,
		invalid_flag
	) 
	select ISNULL(product_key,''),
	ISNULL(product_name,''),
	ISNULL(product_detail,''),
	ISNULL(product_category,''),
	ISNULL(product_brand,''),
	case when ISDATE(product_manuf_date) = 0 then CONVERT(datetime,'1900-01-01')
		else CONVERT(datetime,product_manuf_date)
	end,
	case when TRY_CONVERT(int,isnull(product_manuf_cost,0)) is null then -1
		else ISNULL(product_manuf_cost,0)
	end,
	ISNULL(product_manuf_area,''),
	case when ISDATE(product_expire_date) = 0 then CONVERT(datetime,'1900-01-01')
		else CONVERT(datetime,product_expire_date)
	end,
	'VALID'
	from staging_payments.dbo.product_asis

	update staging_payments.dbo.product_valid set invalid_flag='INVALID'
	where product_manuf_cost=-1 or product_key='' or product_key=''
end

go

drop proc dbo.proc_payments_product_asis_valid

go


create SEQUENCE [dbo].[product_sur_key_sequence]
	As [bigint]
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
go

go
drop proc proc_payments_product_valid_reception;
go

create proc dbo.proc_payments_product_valid_reception
as
begin
	truncate table staging_payments.dbo.product_reception
	insert into staging_payments.dbo.product_reception(product_sur_key,
		product_key,
		product_name,
		product_detail,
		product_category,
		product_brand,
		product_manuf_date,
		product_manuf_cost,
		product_manuf_area,
		product_expire_date,
		invalid_flag
	)
	select 	CONCAT(YEAR(GETDATE()), NEXT value for dbo.product_sur_key_sequence),
		product_key,
		product_name,
		product_detail,
		product_category,
		product_brand,
		product_manuf_date,
		product_manuf_cost,
		product_manuf_area,
		product_expire_date,
		invalid_flag
		from dbo.product_valid
		where invalid_flag='VALID'
end

use edw_payments
go
create proc dbo.proc_payments_product_reception_edw
as
begin
	update A set updated_dts=GETDATE()
	from edw_payments.dbo.dim_product A
	INNER JOIN staging_payments.dbo.product_reception B 
	ON A.product_key=B.product_key 
	where A.updated_dts=CONVERT(datetime,'2999-01-01')

	insert into edw_payments.dbo.dim_product(
		product_sur_key,
		product_key,
		product_name,
		product_detail,
		product_category,
		product_brand,
		product_manuf_date,
		product_manuf_cost,
		product_manuf_area,
		product_expire_date,
		inserted_dts,
		updated_dts
	) 
	select 
		product_sur_key,
		product_key,
		product_name,
		product_detail,
		product_category,
		product_brand,
		product_manuf_date,
		product_manuf_cost,
		product_manuf_area,
		product_expire_date,
		GETDATE(),
		CONVERT(datetime,'2999-01-01')
	from staging_payments.dbo.product_reception
	where invalid_flag='VALID'
end
go
drop proc dbo.proc_payments_product_reception_edw;