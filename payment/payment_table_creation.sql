

use staging_payments
go

drop table payments_asis;
drop table payments_valcode;
drop table payments_reception;
drop SEQUENCE payments_sur_key_sequence;


create table payments_asis(
	payment_code varchar(30),
	payment_mode varchar(100),
	payment_amount varchar(20),
	payment_date varchar(20),
	customer_code varchar(30), --foreign key change required
	order_code varchar(30),  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100) --foreign key
);


create table payments_valid(
	payment_code  varchar(30),
	payment_mode varchar(100),
	payment_amount int,
	payment_date datetime,
	customer_code  varchar(30), --foreign key change required
	order_code  varchar(30),  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100), --foreign key
	invalid_flag varchar(7)
);

create table payments_reception(
	payment_SK int not null,
	payment_code  varchar(30),
	payment_mode varchar(100),
	payment_amount int,
	payment_date datetime,
	customer_code  varchar(30), --foreign key change required
	order_code  varchar(30),  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100), --foreign key
	invalid_flag varchar(7)
	PRIMARY KEY CLUSTERED
	(
		payment_SK ASC
	)
);

CREATE SEQUENCE [dbo].[payments_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO

use edw_payments
go
drop table dim_payments
create table dim_payments(
	payment_SK int not null,
	payment_code  varchar(30),
	payment_mode varchar(100),
	payment_amount int,
	payment_date datetime,
	customer_code  varchar(30), --foreign key change required
	order_code  varchar(30),  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100), --foreign key
	inserted_dts datetime,
	updated_dts datetime
	PRIMARY KEY CLUSTERED
	(
		payment_SK ASC
	)
);