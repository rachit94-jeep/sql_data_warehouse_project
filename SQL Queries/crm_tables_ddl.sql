--Creating tables for CRM source system
--Adding a T-SQL check to know if table already exists in the database
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT          ,
    cst_key            NVARCHAR (50),
    cst_firstname      NVARCHAR (50),
    cst_lastname       NVARCHAR (50),
    cst_marital_status NVARCHAR (50),
    cst_gndr           NVARCHAR (50),
    cst_create_date    DATE         
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT          ,
    prd_key      NVARCHAR (50),
    prd_nm       NVARCHAR (50),
    prd_cost     INT          ,
    prd_line     NVARCHAR (50),
    prd_start_dt DATE         ,
    prd_end_dt   DATE         
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE [bronze].[crm_sales_details](
	[sls_order_num] [nvarchar](50) NULL,
	[sls_prd_key] [nvarchar](50) NULL,
	[sls_cust_id] [nvarchar](50) NULL,
	[sls_order_dt] int NULL,
	[sls_ship_dt] int NULL,
	[sls_due_dt] int NULL,
	[sls_sales] int NULL,
	[sls_quantity] [int] NULL,
	[sls_price] [int] NULL
) ON [PRIMARY]
GO