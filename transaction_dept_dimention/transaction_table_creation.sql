




USE staging_payments
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

Use edw_payments
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