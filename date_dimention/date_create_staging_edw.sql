use staging_payments
go
drop table dbo.date_asis;
go
drop table dbo.date_valid;
go 
drop table dbo.date_reception; 
go
CREATE TABLE dbo.date_asis(
	day varchar(4) null,
	month varchar(4) null,
	year varchar(6) null
);
go
CREATE TABLE dbo.date_valid(
	day varchar(4) not null,
	month varchar(4) not null,
	year varchar(6) not null,
	invalid_flag varchar(10) not null
);
go 
CREATE TABLE dbo.date_reception(
	date_sur_key integer primary key,
	day varchar(4) not null,
	month varchar(4) not null,
	year varchar(6) not null,
	quarter varchar(4) not null,
	day_month varchar(8) not null,
	day_year varchar(8) not null,
	month_year varchar(8) not null,
	quarter_year varchar(8) not null,
	invalid_flag varchar(10) not null
); 

use edw_payments;
go

drop table dbo.dim_date;
go
CREATE TABLE dbo.dim_date (
	date_sur_key int,
	day varchar(4) not null,
	month varchar(4) not null,
	year varchar(6) not null,
	quarter varchar(4) not null,
	day_month varchar(8) not null,
	day_year varchar(8) not null,
	month_year varchar(8) not null,
	quarter_year varchar(8) not null,
	inserted_dts datetime,
	updated_dts datetime
	primary key clustered (
	date_sur_key asc
	)
);