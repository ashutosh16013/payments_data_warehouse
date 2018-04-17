USE staging_payments
GO

--for dropping tables
DROP table [dbo].[customer_asis]
DROP table [dbo].[customer_valid]
DROP table [dbo].[customer_reception]

--creation of tables

CREATE TABLE [dbo].[customer_asis](
	[customer_code] [varchar] (30) NULL ,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] [varchar] (60) NULL,
	[customer_telephone] [varchar] (20) NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [varchar] (30) NULL,
);

--stage 2 table with some validations added
CREATE TABLE [dbo].[customer_valid](
	[customer_code] [varchar] (30),
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] [varchar] (60)NOT NULL,
	[customer_telephone] [integer] NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [datetime] NOT NULL,
	[invalid_flag] [varchar](7) NULL,
) ON [PRIMARY]
GO

--stage 3 for customer dimension
CREATE TABLE [dbo].[customer_reception](
	[customer_SK] [int] NOT NULL,
	[customer_code] [varchar] (30) NOT NULL,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] [varchar] (60) NOT NULL, --change this for foreign key
	[customer_telephone] [integer] NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [datetime] NOT NULL,
	[invalid_flag] [varchar](7) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[customer_SK] ASC
	)
) ON [PRIMARY]
GO


--FOR DEPARTMENT DIMENSION

DROP TABLE transaction_dept_asis
DROP TABLE transaction_dept_valid
DROP TABLE transaction_dept_reception

CREATE TABLE [dbo].[transaction_dept_asis](
	[transaction_code] [varchar] (30) NULL ,
	[transaction_date] [varchar] (30) NULL,
	[transaction_amount] [varchar] (30) NULL,
	[transaction_pdt_id] [varchar] (30)NULL, --change for foreign key
	[transaction_dept] [varchar] (30) NULL, --reference to department table
);

CREATE TABLE [dbo].[transaction_dept_valid](
	[transaction_code] [varchar] (30) NOT NULL,
	[transaction_date] [datetime] NULL,
	[transaction_amount] [integer] NULL,
	[transaction_pdt_id] [integer] NULL, --change for foreign key
	[transaction_dept] [integer]  NULL, --reference to department table
	[invalid_flag] [varchar](7) NULL,
);

CREATE TABLE [dbo].[transaction_dept_reception](
	[transaction_SK] [int] NOT NULL,
	[transaction_code] [int] NOT NULL ,
	[transaction_date] [datetime] NULL,
	[transaction_amount] [integer] NULL,
	[transaction_pdt_id] [integer] NULL, --change for foreign key
	[transaction_dept] [integer]  NULL, --reference to department table
	[invalid_flag] [varchar](7) NULL,
	PRIMARY KEY CLUSTERED 
	(
		[transaction_SK] ASC
	)
) ON [PRIMARY]


--dimension Address
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


--address dimension

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
	customer_id int not null default 0, --Change to foreign key later
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
