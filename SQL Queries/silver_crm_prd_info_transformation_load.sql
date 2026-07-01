--Quality Checks on Data in Bronze layer before loading it to Silver Layer

/*=========================================================================================================
--Check 1 : Check for any nulls or duplicates in primary key
 =========================================================================================================*/

SELECT   prd_id,
         count(1)
FROM     [bronze].[crm_prd_info]
GROUP BY prd_id
HAVING   count(1) > 1
         OR prd_id IS NULL;
--above query returned duplicates and null in primary key

/*=========================================================================================================
  Check 2 : Derive columns and transformations
 =========================================================================================================*/

SELECT [prd_id],
       replace(substring(prd_key, 1, 5),'-','_') AS cat_id,
       substring(prd_key,7) as prd_key,
       [prd_nm],
       coalesce([prd_cost],0) as prd_cst, --ISNULL can also be used
       case when UPPER(TRIM([prd_line])) = 'M' then 'Mountain'
            when UPPER(TRIM([prd_line])) = 'R' then 'Road'
            when UPPER(TRIM([prd_line])) = 'S' then 'Other Sales'
            when UPPER(TRIM([prd_line])) = 'T' then 'Touring'
            else 'Not Available' end as prd_line,
       [prd_start_dt],
       DATEADD(DAY,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) as [prd_end_dt]
FROM   [bronze].[crm_prd_info];

/*=========================================================================================================
  Inserting data into Silver layer's crm_prd_info
 =========================================================================================================*/

INSERT INTO [silver].[crm_prd_info]
           ([prd_id],
            [cat_id]
           ,[prd_key]
           ,[prd_nm]
           ,[prd_cost]
           ,[prd_line]
           ,[prd_start_dt]
           ,[prd_end_dt])
           SELECT [prd_id],
       replace(substring(prd_key, 1, 5),'-','_') AS cat_id,
       substring(prd_key,7) as prd_key,
       [prd_nm],
       coalesce([prd_cost],0) as prd_cost, --ISNULL can also be used
       case when UPPER(TRIM([prd_line])) = 'M' then 'Mountain'
            when UPPER(TRIM([prd_line])) = 'R' then 'Road'
            when UPPER(TRIM([prd_line])) = 'S' then 'Other Sales'
            when UPPER(TRIM([prd_line])) = 'T' then 'Touring'
            else 'Not Available' end as prd_line,
       [prd_start_dt],
       DATEADD(DAY,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) as [prd_end_dt]
FROM   [bronze].[crm_prd_info];