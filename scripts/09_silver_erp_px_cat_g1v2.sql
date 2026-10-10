```sql
/*
===============================================================================
Description: This SQL script loads ERP product category information from the
             Bronze layer into the Silver layer.

             The source data has been reviewed, and no data quality issues
             requiring transformation have been identified. Therefore, the
             data is transferred directly from Bronze to Silver without
             additional transformations.

Note:        The 'data_warehouse' database and the Bronze and Silver tables
             must already exist before running this script.

Database:    PostgreSQL
Layer:       Silver
===============================================================================
*/


INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT *
FROM bronze.erp_px_cat_g1v2;
```
