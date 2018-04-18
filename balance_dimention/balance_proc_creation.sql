CREATE SEQUENCE [dbo].[balance_sur_key_sequence]
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 2147483647
 CACHE
GO

--fact_balance

USE staging_payments
GO

sp_help balance_reception
drop proc proc_fact_payments_transaction_asis_valid
CREATE PROC [dbo].[proc_fact_payments_balance_asis_valid]
as
begin

    TRUNCATE TABLE [dbo].[balance_valid];

    INSERT INTO [balance_valid]
        (date_code
         transaction_dept_code
         department_code
         amount_due
         amount_paid
         invalid_flag
        )
    select
        CASE WHEN TRY_CONVERT(date, ISNULL(date_code, CAST('1900-01-01' as DATE))) IS NULL THEN CAST('1900-01-01' as DATE)
            ELSE ISNULL(date_code, CAST('1900-01-01' as DATE)) END,
        ISNULL(transaction_dept_code,''),
        ISNULL(department_code,''),
        CASE WHEN TRY_CONVERT(int, ISNULL(amount_due, -1)) IS NULL THEN -1
        ELSE ISNULL(amount_due, -1) END,
        CASE WHEN TRY_CONVERT(int, ISNULL(amount_paid, -1)) IS NULL THEN -1
        ELSE ISNULL(amount_paid, -1) END,
        'VALID'
    from dbo.balance_asis;

    update balance_valid set invalid_flag='INVALID'
    where transaction_dept_code='' OR department_code='' OR date_code=CAST('1900-01-01' as DATE) OR amount_paid=-1 OR amount_due=-1;
end
GO


drop proc proc_fact_payments_transaction_valid_reception
CREATE PROC [dbo].[proc_fact_payments_balance_valid_reception]
as
begin

    TRUNCATE TABLE [dbo].[balance_reception];

    INSERT INTO [balance_reception]
        (
         balance_SK
         date_code
         transaction_dept_SK
         department_SK
         amount_due
         amount_paid
        )
    select
        CONCAT(YEAR(GETDATE()), next value for dbo.balance_sur_key_sequence),
        X.date_code,
        T.transaction_dept_SK,
        D.department_SK,
        amount_due,
        amount_paid,
       

        FROM
        (Select * from [dbo].balance_valid where invalid_flag='VALID') X
        INNER JOIN edw_payments.dbo.dim_transaction_dept T
        ON X.transaction_dept_code = P.transaction_dept_code and P.updated_dts=CAST('2999-01-01' AS DATE)
        INNER JOIN edw_payments.dbo.dim_department D
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