/*Truncating data from tables*/
TRUNCATE TABLE [bronze].[crm_cust_info];

TRUNCATE TABLE [bronze].[crm_prd_info];

TRUNCATE TABLE [bronze].[crm_sales_details];


GO
/* Performing bulk insert into crm tables from csv files */

/*--------[crm_cust_info]-------*/

BULK INSERT [bronze].[crm_cust_info] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK

/*--------[crm_prd_info]-------*/

BULK INSERT [bronze].[crm_prd_info] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK

/*--------[crm_sales_details]-------*/

BULK INSERT [bronze].[crm_sales_details] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK

