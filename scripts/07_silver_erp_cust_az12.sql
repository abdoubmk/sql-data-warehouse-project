```sql
/*
===============================================================================
This SQL script transforms ERP customer information from the
             Bronze layer into the Silver layer.

             The script cleans and standardizes customer IDs, validates birth
             dates, and normalizes gender values to ensure data consistency
             and quality.

             Invalid birth dates are replaced with NULL, and unrecognized
             gender values are standardized to 'n/a'.

Note:        The 'data_warehouse' database and the Bronze and Silver tables
             must already exist before running this script.

Database:    PostgreSQL
Layer:       Silver
===============================================================================
*/


INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE
        WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4)
        ELSE TRIM(cid)
    END AS cid,

    CASE
        WHEN bdate < '1924-01-01' OR bdate > CURRENT_DATE THEN NULL
        ELSE bdate
    END AS bdate,

    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;
```
