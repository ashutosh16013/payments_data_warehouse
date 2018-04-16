

use staging_payments
go

drop table payments_asis;
drop table payments_valid;
drop table payments_reception;
drop SEQUENCE payments_sur_key_sequence;


create table payments_asis(
	payment_id int not null identity(1,1) primary key,
	payment_mode varchar(100),
	payment_amount decimal(20, 4),
	payment_date datetime,
	customer_id int, --foreign key change required
	order_id int not null,  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100) --foreign key
);


create table payments_valid(
	payment_id int primary key,
	payment_mode varchar(100),
	payment_amount decimal(20, 4),
	payment_date datetime,
	customer_id int, --foreign key change required
	order_id int not null,  --foreign key change required
	billing_address varchar(100), --foreign key
	shipment_address varchar(100), --foreign key
	invalid_flag varchar(7)
);

create table payments_reception(
	payment_SK int not null,
	payment_id int not null,
	payment_mode varchar(100),
	payment_amount decimal(20, 4),
	payment_date datetime,
	customer_id int, --foreign key change required
	order_id int not null,  --foreign key change required
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

