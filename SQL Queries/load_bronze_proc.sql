USE [DataWarehouse]
GO

/****** Object:  StoredProcedure [bronze].[load_bronze]    Script Date: 21-06-2026 00:42:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER     PROCEDURE [bronze].[load_bronze]
AS
BEGIN
    BEGIN TRY
        DECLARE @startdate DATETIME ,@enddate DATETIME;
        PRINT '=======================================================';
        PRINT '                LOADING BRONZE LAYER                   '
        PRINT '=======================================================';

        PRINT 'Mode: Full Load';
        PRINT '```````````````````````````````````````````';
        PRINT 'Truncating data from CRM source tables...';
        PRINT '```````````````````````````````````````````';
        SET @startdate = GETDATE();
        /*Truncating data from tables*/
        TRUNCATE TABLE [bronze].[crm_cust_info];
        TRUNCATE TABLE [bronze].[crm_prd_info];
        TRUNCATE TABLE [bronze].[crm_sales_details];
        SET @enddate = GETDATE();
        PRINT '>> Truncate Duration: ' + CAST(DATEDIFF(millisecond,@startdate,@enddate) AS NVARCHAR) + ' seconds';
        PRINT ' -----------------------';
        PRINT '`````````````````````````````````````````````';
        PRINT 'Bulk Inserting data into CRM source tables...';
        PRINT '`````````````````````````````````````````````';
        /* Performing bulk insert into crm tables from csv files */ /*--------[crm_cust_info]-------*/

        PRINT '>> Inserting into table: crm_cust_info';
        BULK INSERT [bronze].[crm_cust_info] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_crm\cust_info.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK 

        /*--------[crm_prd_info]-------*/
        PRINT '>> Inserting into table: crm_prd_info';
        BULK INSERT [bronze].[crm_prd_info] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_crm\prd_info.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK 
    
        /*--------[crm_sales_details]-------*/
        PRINT '>> Inserting into table: crm_sales_details';
        BULK INSERT [bronze].[crm_sales_details] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_crm\sales_details.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK 
    
        PRINT '```````````````````````````````````````````';
        PRINT 'Truncating data from ERP source tables...';
        PRINT '```````````````````````````````````````````';
        /*Truncating data from tables*/
        TRUNCATE TABLE [bronze].[erp_cust_az12];
        TRUNCATE TABLE [bronze].[erp_loc_a101];
        TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]; 
    

        /* Performing bulk insert into erp tables from csv files */ 
        PRINT '`````````````````````````````````````````````';
        PRINT 'Bulk Inserting data into ERP source tables...';
        PRINT '`````````````````````````````````````````````';
        /*--------[erp_cust_az12]-------*/
        PRINT '>> Inserting into table: erp_cust_az12';
        BULK INSERT [bronze].[erp_cust_az12] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\CUST_AZ12.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK 
    
        /*--------[erp_loc_a101]-------*/
        PRINT '>> Inserting into table: erp_loc_a101';
        BULK INSERT [bronze].[erp_loc_a101] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\LOC_A101.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK 
    
        /*--------[erp_px_cat_g1v2]-------*/
        PRINT '>> Inserting into table: erp_px_cat_g1v2';
        BULK INSERT [bronze].[erp_px_cat_g1v2] FROM 'C:\Users\I536982\OneDrive - SAP SE\Documents\Personal Projects\sql_dwh_project\datasets\source_erp\PX_CAT_G1V2.csv'
            WITH (FIRSTROW = 2, --FIRST ROW STARTS FROM
        FIELDTERMINATOR = ',', --FILE DELIMITER
        TABLOCK); --KEEPS THE TABLE LOCK
    END TRY
    BEGIN CATCH
        PRINT '==================================================================';
        PRINT 'ERROR MESSAGE: '+ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: '+CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE: '+CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================================';
    END CATCH
END
GO


