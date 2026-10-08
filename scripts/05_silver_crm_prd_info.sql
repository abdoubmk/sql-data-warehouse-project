```sql
/*
===============================================================================
Description: This SQL script performs data quality checks and transforms CRM
             product information from the Bronze layer into the Silver layer.

             The script checks for duplicate or null product IDs and invalid
             product costs, then cleans and standardizes product data before
             loading it into the Silver table.

             Transformations include product key formatting, handling missing
             costs, standardizing product line values, and calculating product
             end dates based on the next start date.

Note:        The 'data_warehouse' database and the Bronze and Silver tables
             must already exist before running this script.

Database:    PostgreSQL
Layer:       Silver
===============================================================================
*/


-- ============================================================================
-- DATA QUALITY CHECKS
-- ============================================================================

-- Check for duplicate or null product IDs
SELECT prd_id, COUNT(*) AS num_dup
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for null or non-positive product costs
SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost <= 0 OR prd_cost IS NULL;


-- ============================================================================
-- TRANSFORM AND LOAD CRM PRODUCT INFORMATION INTO THE SILVER LAYER
-- ============================================================================

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    LEAD(prd_start_dt) OVER (
        PARTITION BY prd_key
        ORDER BY prd_start_dt
    ) - INTERVAL '1 day' AS prd_end_dt
FROM bronze.crm_prd_info;
```
