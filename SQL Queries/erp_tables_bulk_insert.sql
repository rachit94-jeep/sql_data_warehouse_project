/*Truncating data from tables*/
TRUNCATE TABLE [bronze].[erp_cust_az12];

TRUNCATE TABLE [bronze].[erp_loc_a101];

TRUNCATE TABLE [bronze].[erp_px_cat_g1v2];


GO
/* Performing bulk insert into crm tables from csv files */

/*--------[erp_cust_az12]-------*/

BULK INSERT [bronze].[erp_cust_az12] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\CUST_AZ12.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK

/*--------[erp_loc_a101]-------*/

BULK INSERT [bronze].[erp_loc_a101] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\LOC_A101.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK

/*--------[erp_px_cat_g1v2]-------*/

BULK INSERT [bronze].[erp_px_cat_g1v2] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
FIELDTERMINATOR = ',', --FILE DELIMITER
TABLOCK); --KEEPS THE TABLE LOCK
