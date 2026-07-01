--Creating tables for CRM source system
--Adding a T-SQL check to know if table already exists in the database
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id             INT          ,
    cst_key            NVARCHAR (50),
    cst_firstname      NVARCHAR (50),
    cst_lastname       NVARCHAR (50),
    cst_marital_status NVARCHAR (50),
    cst_gndr           NVARCHAR (50),
    cst_create_date    DATE         ,
    dwh_create_date    DATETIME2     DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id          INT          ,
    prd_key         NVARCHAR (50),
    prd_nm          NVARCHAR (50),
    prd_cost        INT          ,
    prd_line        NVARCHAR (50),
    prd_start_dt    DATE         ,
    prd_end_dt      DATE         ,
    dwh_create_date DATETIME2     DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

CREATE TABLE [silver].[crm_sales_details] (
    [sls_order_num] NVARCHAR (50) NULL,
    [sls_prd_key]   NVARCHAR (50) NULL,
    [sls_cust_id]   NVARCHAR (50) NULL,
    [sls_order_dt]  INT           NULL,
    [sls_ship_dt]   INT           NULL,
    [sls_due_dt]    INT           NULL,
    [sls_sales]     INT           NULL,
    [sls_quantity]  INT           NULL,
    [sls_price]     INT           NULL,
    dwh_create_date DATETIME2     DEFAULT GETDATE()
) ON [PRIMARY];