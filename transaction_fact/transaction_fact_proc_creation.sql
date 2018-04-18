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
        CASE WHEN TRY_CONVERT(date, ISNULL(date_code, CAST('1900-01-01' as DATE))) IS NULL THEN CAST('1900-01-01' as DATE)
        ELSE ISNULL(date_code, CAST('1900-01-01' as DATE)) END,
        CASE WHEN TRY_CONVERT(int, ISNULL(amount_paid, -1)) IS NULL THEN -1
        ELSE ISNULL(amount_paid, -1) END,
        CASE WHEN TRY_CONVERT(int, ISNULL(pdt_price, -1)) IS NULL THEN -1
        ELSE ISNULL(pdt_price, -1) END,
        'VALID'
    from dbo.transaction_asis;

    update transaction_valid set invalid_flag='INVALID'
    where product_code='' OR customer_code='' OR date_code=CAST('1900-01-01' as DATE) OR amount_paid=-1 OR pdt_price=-1;
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
		INNER JOIN edw_payments.dbo.dim_product P
		ON X.product_code = P.product_code and P.updated_dts=CAST('2999-01-01' AS DATE)
		INNER JOIN edw_payments.dbo.dim_customer C
		ON X.customer_code = C.customer_code and D.updated_dts=CAST('2999-01-01' AS DATE)
end
GO

--reception to edw for fact transaction

sp_help fact_transaction
CREATE PROC proc_fact_transaction_reception_edw
as 
begin

UPDATE A
SET record_flag='O'
FROM edw_sales.dbo.fact_transaction A
INNER JOIN staging_paments.dbo.transaction_reception R
ON A.product_SK = R.product_SK
AND A.customer_sur_key = R.SK
AND A.date_sur_key = R.SK

INSERT INTO edw_payments.dbo.fact_transaction
(
	transaction_SK,
	product_SK,
	customer_SK,
	date_SK,
	amount_paid,
	pdt_price,
	record_flag
)

SELECT
	transaction_SK,
	product_SK,
	customer_SK,
	date_SK,
	amount_paid,
	pdt_price,
	'C'
	from staging_payments.dbo.transaction_reception

end

GO

