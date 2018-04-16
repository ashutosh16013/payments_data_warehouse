Use edw_payments
GO

CREATE TABLE dbo.dim_customer (
	[customer_SK] [int] NOT NULL,
	[customer_code] [int] NOT NULL,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [integer] NULL,
	[customer_address] varchar NOT NULL,
	[customer_telephone] [integer] NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [datetime] NOT NULL,
	[invalid_flag] [varchar](7) NULL,
	[inserted_dts] [datetime] NOT NULL,
	[updated_dts] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[customer_SK] ASC
	)
);

GO

