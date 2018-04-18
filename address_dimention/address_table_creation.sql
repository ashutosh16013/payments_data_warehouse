

USE staging_payments
GO

drop table address_asis;
drop table address_valid;
drop table address_reception;

create table address_asis(
	address_code varchar(30) ,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode varchar(10),
	customer_code varchar(30), --Change to foreign key later
	address_type varchar(100)
);

create table address_valid(
	address_code varchar(30) ,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_code varchar(30), --Change to foreign key later
	address_type varchar(100),
	invalid_flag varchar(7)
);

create table address_reception(
	address_sk int not null,
	address_code varchar(30) ,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_code varchar(30), --Change to foreign key later
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

sp_help address_valid

use edw_payments
GO
create table dim_address(
	address_sk int not null,
	address_code varchar(30) ,
	address_details varchar(100),
	city varchar(100),
	country varchar(100),
	address_pincode int,
	customer_code varchar(30), --Change to foreign key later
	address_type varchar(100),
	inserted_dts datetime,
	updated_dts datetime
	PRIMARY KEY CLUSTERED
	(
		address_SK ASC
	)
);
