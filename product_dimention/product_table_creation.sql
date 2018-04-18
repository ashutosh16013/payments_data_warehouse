USE staging_payments
go
drop table dbo.product_asis;
go
drop table dbo.product_valid;
go 
drop table dbo.product_reception;
go

CREATE TABLE dbo.product_asis(
	product_key varchar(20) null,
	product_name varchar(20) null,
	product_detail varchar(100) null,
	product_category varchar(20) null,
	product_brand varchar(20) null,
	product_manuf_date varchar (20) null,
	product_manuf_cost varchar (20) null,
	product_manuf_area varchar(20) null,
	product_expire_date varchar(20) null
);
go
CREATE TABLE dbo.product_valid(
	product_key varchar(20) not null,
	product_name varchar(20) not null,
	product_detail varchar(100) not null,
	product_category varchar(20) not null,
	product_brand varchar(20) not null,
	product_manuf_date date not null,
	product_manuf_cost int not null,
	product_manuf_area varchar(20) not null,
	product_expire_date varchar(20) not null,
	invalid_flag varchar(10) not null
);
go
CREATE TABLE dbo.product_reception(
	product_sur_key int not null,
	product_key varchar(20) not null,
	product_name varchar(20) not null,
	product_detail varchar(100) not null,
	product_category varchar(20) not null,
	product_brand varchar(20) not null,
	product_manuf_date date not null,
	product_manuf_cost int not null,
	product_manuf_area varchar(20) not null,
	product_expire_date varchar(20) not null,
	invalid_flag varchar(10) not null
); 

Use edw_payments
GO

CREATE TABLE dbo.dim_product(
product_sur_key int primary key,
product_key varchar(20) not null,
product_name varchar(20) not null,
product_detail varchar(100) not null,
product_category varchar(20) not null,
product_brand varchar(20) not null,
product_manuf_date date not null,
product_manuf_cost int not null,
product_manuf_area varchar(20) not null,
product_expire_date date not null,
inserted_dts date not null,
updated_dts date not null
);

go