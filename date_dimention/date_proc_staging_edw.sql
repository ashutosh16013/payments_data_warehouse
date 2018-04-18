use staging_payments
go 

drop proc dbo.proc_payment_date_asis_valid

create proc dbo.proc_payment_date_asis_valid
as
begin
	TRUNCATE TABLE dbo.date_valid
	insert into staging_payments.dbo.date_valid(
		day,
		month,
		year,
		invalid_flag
	)
	select ISNULL(day,0),
	ISNULL(month,0),
	ISNULL(year,0),
	'VALID'
	from dbo.date_asis

	update staging_payments.dbo.date_valid set invalid_flag = 'INVALID'
	where ISDATE(CONCAT(year,'-',month,'-',day,' ','00:00:00.00')) = 0
end
go


drop proc dbo.proc_payments_date_valid_reception
create proc dbo.proc_payments_date_valid_reception
as
begin
	TRUNCATE TABLE dbo.date_reception
	insert into staging_payments.dbo.date_reception(
		date_sur_key,
		day,
		month,
		year,
		quarter,
		day_month,
		day_year,
		month_year,
		quarter_year,
		invalid_flag
	)
	select
	CONCAT(YEAR(GETDATE()), NEXT value for dbo.date_sur_key_sequence),
	day,
	month,
	year,
	TRY_CONVERT(varchar,(TRY_CONVERT(int,month)-1)/3 + 1),
	CONCAT(day,'_',month),
	CONCAT(day,'_',year),
	CONCAT(month,'_',year),
	CONCAT(TRY_CONVERT(varchar,(TRY_CONVERT(int,month)-1)/3 + 1),'_',year),
	'VALID'
	from dbo.date_valid
	where invalid_flag = 'VALID'
end


use edw_payments
go
DROP PROCEDURE proc_payments_date_reception_edw
go
create proc dbo.proc_payments_date_reception_edw
as
begin
	insert into edw_payments.dbo.dim_date(
		date_sur_key,
		day,
		month,
		year,
		quarter,
		day_month,
		day_year,
		month_year,
		quarter_year
	)
	select
		date_sur_key,
		day,
		month,
		year,
		quarter,
		day_month,
		day_year,
		month_year,
		quarter_year
	from staging_payments.dbo.date_reception st
	where ((select count(day) from EDW_SALES_Project.dbo.dim_date dw where dw.day=st.day and dw.month=st.month and dw.year=st.year) = 0)
end

