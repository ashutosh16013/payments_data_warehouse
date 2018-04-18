USE [staging_payments]
GO

/****** Object:  Sequence [dbo].[customer_sur_key_sequence] ******/
CREATE SEQUENCE [dbo].[customer_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO


CREATE SEQUENCE [dbo].[transaction_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO

CREATE SEQUENCE [dbo].[payments_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO

CREATE SEQUENCE [dbo].[address_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO

create SEQUENCE [dbo].[date_sur_key_sequence]
	As [int]
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	CACHE 
go


CREATE SEQUENCE [dbo].[transaction2_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO

CREATE SEQUENCE [dbo].[balance_sur_key_sequence] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE 
GO
