--Quality Checks on Data in Bronze layer before loading it to Silver Layer

/*=========================================================================================================
--Check 1 : Check for any nulls or duplicates in primary key
 =========================================================================================================*/

SELECT cst_id,count(1) FROM [bronze].[crm_cust_info]
GROUP BY cst_id HAVING count(1) > 1 or cst_id is null

--above query returned duplicates and null in primary key

/*=========================================================================================================
  Check 2 : Check for any unwanted space in the columns:
  cst_firstname,
  cst_lastname,
  cst_gndr,
  cst_marital_status
 =========================================================================================================*/


SELECT   cst_id,
         cst_key,
         cst_firstname,
         cst_lastname,
         cst_gndr,
         cst_marital_status,
         cst_create_date
FROM     [bronze].[crm_cust_info]
WHERE cst_firstname != TRIM(cst_firstname)

/*=========================================================================================================
                                TRANSFORMATION SCRIPT
                     --> (removing duplicates) 
                     --> (removing leading and trailing spaces) 
                     --> (change cst_gndr(M-->Male and F-->Female)[Data Standardization and Consistency]
                     --> (change cst_marital status (M --> Married and S --> Single)
 ==========================================================================================================*/

SELECT cst_id,
       cst_key,
       TRIM(cst_firstname) AS cst_firstname,
       TRIM(cst_lastname) AS cst_lastname,
       CASE WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
            WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
            ELSE cst_gndr END AS cst_gndr,
       CASE WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
            WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
            ELSE cst_marital_status END AS cst_marital_status,
       cst_marital_status,
       cst_create_date
FROM   (SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_duplicates
        FROM   [bronze].[crm_cust_info]
        WHERE  cst_id IS NOT NULL) AS b
WHERE  flag_duplicates = 1;