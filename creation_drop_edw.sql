Use edw_payments
GO

drop TABLE dim_customer

CREATE TABLE dbo.dim_customer (
	[customer_SK] [int] NOT NULL,
	[customer_code] [varchar] (30)NOT NULL,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] varchar(1) NULL,
	[customer_address] varchar(60)NOT NULL,
	[customer_telephone] [integer] NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [datetime] NOT NULL,
	[inserted_dts] [datetime] NOT NULL,
	[updated_dts] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[customer_SK] ASC
	)
);

GO

DROP TABLE dbo.dim_transaction_dept

CREATE TABLE [dbo].[dim_transaction_dept](
	[transaction_SK] [int] NOT NULL,
	[transaction_code] [int] NOT NULL ,
	[transaction_date] [datetime] NULL,
	[transaction_amount] [integer] NULL,
	[transaction_pdt_id] [integer] NULL, --change for foreign key
	[transaction_dept] [integer]  NULL, --reference to department table
	[inserted_dts] [datetime] NOT NULL,
	[updated_dts] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[transaction_SK] ASC
	)
) ON [PRIMARY]


drop table edw_payments.dbo.dim_product;
go

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