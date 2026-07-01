/* Cleaning and Loading Data into silver layer erp customer profile table*/

INSERT INTO [silver].[erp_cust_az12] (cid,bdate,gen)
SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
            ELSE cid END AS cid,
       CASE WHEN YEAR(bdate)> YEAR(GETDATE()) THEN NULL
            ELSE bdate END AS bdate,
       CASE WHEN UPPER(gen) IN ('M','MALE') THEN 'Male'
            WHEN UPPER(gen) IN ('F','FEMALE') THEN 'Female'
            ELSE NULL END AS gen
FROM   [bronze].[erp_cust_az12];