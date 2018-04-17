USE staging_payments
GO

create table dbo.transaction_asis(
	product_code varchar(20) NULL,
	customer_code varchar(20) NULL,
	date_code varchar(20) NULL,
	amount_paid numeric(30,5) NULL,
	pdt_price numeric(30,5) NULL
);
GO

create table dbo.transaction_valid(
	product_code varchar(20) NOT NULL,
	customer_code varchar(20) NOT NULL,
	date_code varchar(20) NOT NULL,
	amount_paid numeric(30,5) NOT NULL,
	pdt_price numeric(30,5) NOT NULL,
	invalid_flag varchar (7) NOT NULL
);
GO

create table dbo.transaction_reception(
	product_SK varchar(20) NOT NULL,
	customer_SK varchar(20) NOT NULL,
	date_SK varchar(20) NOT NULL,
	amount_paid numeric(30,5) NOT NULL,
	pdt_price numeric(30,5) NOT NULL
)
