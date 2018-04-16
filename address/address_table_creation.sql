

USE staging_payments
GO

drop table address_asis;
drop table address_valid;
drop table address_reception;

create table address_asis(
	address_id int not null identity(1, 1) primary key,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_id int not null, --Change to foreign key later
	address_type varchar(100)
);

create table address_valid(
	address_id int primary key,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_id int not null, --Change to foreign key later
	address_type varchar(100),
	invalid_flag varchar(7)
);

create table address_reception(
	address_sk int not null,
	address_id int,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_id int not null, --Change to foreign key later
	address_type varchar(100),
	invalid_flag varchar(7)
	PRIMARY KEY CLUSTERED
	(
		address_SK ASC
	)
);

CREATE SEQUENCE [dbo].[address_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO
