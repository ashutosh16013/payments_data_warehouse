USE staging_payments
GO

drop table dbo.balance_asis
drop table dbo.balance_valid

create table dbo.balance_asis(
    date_code varchar(20) NULL,
    transaction_dept_code varchar(20) NULL,
    department_code varchar(20) NULL,
    amount_due numeric(30,5) NULL,
    amount_paid numeric(30,5) NULL
);
GO

create table dbo.balance_valid(
    date_code date NULL,
    transaction_dept_code varchar(20) NULL,
    department_code varchar(20) NULL,
    amount_due numeric(30,5) NULL,
    amount_paid numeric(30,5) NULL,
    invalid_flag varchar (7) NOT NULL
);
GO


drop table dbo.balance_reception
create table dbo.balance_reception(
    balance_SK integer primary key,
    date_code date,
    transaction_dept_SK varchar(20) NULL,
    department_SK varchar(20) NULL,
    amount_due numeric(30,5) NULL,
    amount_paid numeric(30,5) NULL,
)

use edw_payments
GO
drop table fact_balance
CREATE TABLE fact_balance (
    balance_SK integer primary key,
    date_code date,
    transaction_dept_SK varchar(20) NULL,
    department_SK varchar(20) NULL,
    amount_due numeric(30,5) NULL,
    amount_paid numeric(30,5) NULL,
    foreign key (transaction_dept_SK) references dim_transaction_dept(transaction_SK),
    foreign key (department_SK) references dim_department(department_SK)
);