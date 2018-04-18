USE staging_payments
GO

drop table dbo.transaction_asis
drop table dbo.transaction_valid

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
	date_code date NOT NULL,
	amount_paid integer NOT NULL,
	pdt_price integer NOT NULL,
	invalid_flag varchar (7) NOT NULL
);
GO


drop table dbo.transaction_reception
create table dbo.transaction_reception(
	transaction_SK varchar(20) NOT NULL,
	product_SK varchar(20) NOT NULL,
	customer_SK varchar(20) NOT NULL,
	date_SK datetime NOT NULL,
	amount_paid numeric(30,5) NOT NULL,
	pdt_price numeric(30,5) NOT NULL
)

use edw_payments
GO
drop table fact_transaction
CREATE TABLE fact_transaction (
	transaction_SK int primary key,
	product_SK int NOT NULL,
	customer_SK int NOT NULL,
	date_SK date NOT NULL,
	amount_paid numeric(30,5) NOT NULL,
	pdt_price numeric(30,5) NOT NULL,
	record_flag varchar(2) not null,
	foreign key (product_SK) references dim_product(product_sur_key),
	foreign key (customer_SK) references dim_customer(customer_SK)
);
