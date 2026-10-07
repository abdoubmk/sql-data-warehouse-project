-- ============================================================
-- CRM CUSTOMER DATA TRANSFORMATION
-- Source: bronze.crm_cust_info
-- Target: silver.crm_cust_info
-- ============================================================


-- ============================================================
-- 1. DATA EXPLORATION
-- ============================================================

-- Transformation: None
-- Purpose: Inspect the raw Bronze customer data before cleaning.
SELECT *
FROM bronze.crm_cust_info;


-- ============================================================
-- 2. DUPLICATE DETECTION
-- ============================================================

-- Transformation: Duplicate detection
-- Purpose: Identify customers that appear more than once
--          based on the business key cst_id.

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IN (
    SELECT cst_id
    FROM bronze.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1
);


-- ============================================================
-- 3. DATA CLEANING AND TRANSFORMATION
-- ============================================================

-- Transformation 1: Deduplication
-- Keep only the most recent record for each customer.
-- ROW_NUMBER() ranks records by cst_create_date DESC,
-- so flag_last = 1 represents the latest record.
--
-- Transformation 2: String trimming
-- TRIM() removes unnecessary leading and trailing spaces
-- from first and last names.
--
-- Transformation 3: Standardization
-- Convert gender codes:
--     F -> Female
--     M -> Male
--     Other/NULL values -> n/a
--
-- Transformation 4: Record selection
-- Only the latest record for each cst_id is loaded into Silver.
--
-- Note:
-- We do NOT delete records from Bronze.
-- Bronze should preserve the raw/source data.
-- Deduplication is performed during the Silver transformation.

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

WITH RankedRecords AS (

    SELECT 
        cst_id,
        cst_key,

        -- Transformation: Remove unnecessary spaces
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,

        cst_marital_status,

        -- Transformation: Standardize gender values
        CASE 
            WHEN cst_gndr = 'F' THEN 'Female'
            WHEN cst_gndr = 'M' THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,

        cst_create_date,

        -- Transformation: Deduplicate customer records
        -- Latest record receives flag_last = 1
        ROW_NUMBER() OVER (
            PARTITION BY cst_id
            ORDER BY cst_create_date DESC
        ) AS flag_last

    FROM bronze.crm_cust_info
)

SELECT 
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date

FROM RankedRecords

-- Transformation: Keep only the latest record
WHERE flag_last = 1;


-- ============================================================
-- 4. VALIDATION
-- ============================================================

-- Transformation: None
-- Purpose: Verify the cleaned and transformed Silver data.
SELECT *
FROM silver.crm_cust_info;


-- ============================================================
-- 5. VALIDATION: CHECK FOR DUPLICATES
-- ============================================================

-- Transformation: Data quality validation
-- Purpose: Confirm that Silver contains only one record
--          per customer after deduplication.

SELECT 
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;
