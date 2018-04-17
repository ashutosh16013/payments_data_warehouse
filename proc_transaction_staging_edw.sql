USE staging_payments
GO

sp_help transaction_valid

CREATE PROC [dbo].[proc_fact_payments_transaction_asis_valid]
as 
begin

	TRUNCATE TABLE [dbo].[transaction_valid];

	INSERT INTO [transaction_valid]
		(product_code,
		 customer_code,
		 date_code,
		 amount_paid,
		 pdt_price,
		 invalid_flag
		) 
	select
		ISNULL(product_code,''),
		ISNULL(customer_code,''),
		ISNULL(date_code,''),
		CASE WHEN TRY_CONVERT(int, ISNULL(amount_paid, -1)) IS NULL THEN -1
		ELSE ISNULL(amount_paid, -1) END,
		CASE WHEN TRY_CONVERT(int, ISNULL(pdt_price, -1)) IS NULL THEN -1
		ELSE ISNULL(pdt_price, -1) END,
		'VALID'
    from dbo.transaction_asis;

	update transaction_valid set invalid_flag='INVALID'
	where product_code='' OR customer_code='' OR date_code='' OR amount_paid=-1 OR pdt_price=-1;
end
GO

CREATE PROC [dbo].[proc_fact_payments_transaction_valid_reception]
as 
begin

	TRUNCATE TABLE [dbo].[transaction_reception];

	INSERT INTO [transaction_reception]
		(
		 transaction_SK,
		 product_SK,
		 customer_SK,
		 date_SK,
		 amount_paid,
		 pdt_price
		) 
	select
		CONCAT(YEAR(GETDATE()), next value for dbo.transaction2_sur_key_sequence),
		P.product_SK,
		C.customer_SK,
		D.date_SK,
		amount_paid,
		pdt_price

		FROM
		(Select * from [dbo].transaction_valid where invalid_flag='VALID') X
		INNER JOIN edw_payments.dbo.dim_product 
		ON X.product_code = P.product_code and P.updated_dts=CAST('2999-01-01' AS DATE)
		INNER JOIN edw_payments.dbo.dim_customer C
		ON X.customer_code = C.customer_code and D.updated_dts=CAST('2999-01-01' AS DATE)
		INNER JOIN edw_payments.dbo.dim_date D
		ON X.date_code = D.date_code and D.updated_dts=CAST('2999-01-01' AS DATE)
end
GO


