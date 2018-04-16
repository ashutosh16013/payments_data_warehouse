USE staging_payments
GO

--for dropping tables
DROP table [dbo].[customer_asis]
DROP table [dbo].[customer_valid]
DROP table [dbo].[customer_reception]

--creation of tables

CREATE TABLE [dbo].[customer_asis](
	[customer_code] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY ,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] varchar(60) NOT NULL,
	[customer_telephone] [integer] NULL,
	[customer_email] [varchar](50) NULL,
	[customer_relationship_status] [varchar](9) NULL,
	[customer_registration_date] [datetime] NOT NULL,
) ON [PRIMARY]

--stage 2 table with some validations added
CREATE TABLE [dbo].[customer_valid](
	[customer_code] [int] NOT NULL PRIMARY KEY,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] varchar (60)NOT NULL,
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
	[customer_code] [int] NOT NULL,
	[customer_first_name] [varchar](30) NULL,
	[customer_middle_name] [varchar](30) NULL,
	[customer_last_name] [varchar](30) NULL,
	[customer_gender] [varchar] (1) NULL,
	[customer_address] varchar (60) NOT NULL, --change this for foreign key
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