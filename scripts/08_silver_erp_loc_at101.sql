```sql
/*
===============================================================================
This SQL script transforms ERP customer location information from
             the Bronze layer into the Silver layer.

             The script standardizes customer IDs by removing hyphens and
             cleans country values by mapping country codes to their full
             names.

             Missing or empty country values are replaced with 'n/a' to
             ensure consistency and improve data quality.

Note:        The 'data_warehouse' database and the Bronze and Silver tables
             must already exist before running this script.

Database:    PostgreSQL
Layer:       Silver
===============================================================================
*/


INSERT INTO silver.erp_loc_at101 (
    cid,
    cntry
)
SELECT
    REPLACE(cid, '-', '') AS cid,
    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE cntry
    END AS cntry
FROM bronze.erp_loc_at101;
```
