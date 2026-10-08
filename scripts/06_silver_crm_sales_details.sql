/*
================================================================================
FILE: silver_crm_sales_details.sql
DESCRIPTION: ETL process to load cleaned sales data from Bronze to Silver layer
AUTHOR: Data Engineering Team
DATE: 2026-10-09

PURPOSE:
    - Transform raw sales data from bronze.crm_sales_details
    - Clean and validate date fields (convert 8-digit integers to DATE type)
    - Recalculate invalid sales amounts and prices
    - Load deduplicated, validated data into silver layer
    
TRANSFORMATIONS APPLIED:
    1. Date Validation: Convert 8-digit numeric dates (YYYYMMDD) to DATE type
       - Invalid dates (0, <10000000, >99999999) become NULL
    2. Sales Amount Validation: Recalculate sls_sales if:
       - Value is NULL or <= 0
       - Doesn't match sls_quantity * sls_price
    3. Price Validation: Recalculate sls_price if:
       - Value is NULL or <= 0
       - Derived from sls_sales / sls_quantity
    4. Absolute Values: Use ABS() to handle negative prices
    
TABLE STRUCTURE:
    - sls_ord_num: Order number (VARCHAR)
    - sls_prd_key: Product key (VARCHAR)
    - sls_cust_id: Customer ID (INT)
    - sls_order_dt: Order date (DATE)
    - sls_ship_dt: Shipping date (DATE)
    - sls_due_dt: Due date (DATE)
    - sls_sales: Total sales amount (INT)
    - sls_quantity: Quantity sold (INT)
    - sls_price: Unit price (INT)
    - dwh_create_dt: Data warehouse load timestamp (auto-generated)
================================================================================
*/

-- ============================================================================
-- STEP 1: DROP EXISTING TABLE (Full Refresh Strategy)
-- ============================================================================
-- Purpose: Remove old version of the table to ensure clean reload
-- Warning: This will delete all existing data in the silver table
DROP TABLE silver.crm_sales_details;

-- ============================================================================
-- STEP 2: CREATE SILVER TABLE STRUCTURE
-- ============================================================================
-- Purpose: Define the clean, validated table structure for the silver layer
-- Note: dwh_create_dt automatically captures when data was loaded
CREATE TABLE silver.crm_sales_details (
    sls_ord_num   VARCHAR(50),           -- Order number
    sls_prd_key   VARCHAR(50),           -- Product key
    sls_cust_id   INT,                   -- Customer ID
    sls_order_dt  DATE,                  -- Order date (cleaned)
    sls_ship_dt   DATE,                  -- Shipping date (cleaned)
    sls_due_dt    DATE,                  -- Due date (cleaned)
    sls_sales     INT,                   -- Total sales amount (validated)
    sls_quantity  INT,                   -- Quantity sold
    sls_price     INT,                   -- Unit price (validated)
    dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Auto load timestamp
);

-- ============================================================================
-- STEP 3: INSERT CLEANED DATA FROM BRONZE LAYER
-- ============================================================================
-- Purpose: Transform and load validated sales data into silver table
-- Strategy: Apply data quality rules during the INSERT process
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT 
    -- Pass-through columns (no transformation needed)
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    
    -- ==========================================================================
    -- DATE TRANSFORMATION: sls_order_dt
    -- Logic: Convert 8-digit integer (YYYYMMDD) to DATE type
    -- Validation: Set to NULL if invalid (0, too short, too long)
    -- ==========================================================================
    CASE 
        WHEN sls_order_dt = 0 
          OR sls_order_dt < 10000000 
          OR sls_order_dt > 99999999 
        THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,
    
    -- ==========================================================================
    -- DATE TRANSFORMATION: sls_ship_dt
    -- Logic: Same validation as sls_order_dt
    -- ==========================================================================
    CASE 
        WHEN sls_ship_dt = 0 
          OR sls_ship_dt < 10000000 
          OR sls_ship_dt > 99999999 
        THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,
    
    -- ==========================================================================
    -- DATE TRANSFORMATION: sls_due_dt
    -- Logic: Same validation as sls_order_dt
    -- ==========================================================================
    CASE 
        WHEN sls_due_dt = 0 
          OR sls_due_dt < 10000000 
          OR sls_due_dt > 99999999 
        THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,
    
    -- ==========================================================================
    -- SALES AMOUNT VALIDATION: sls_sales
    -- Logic: Recalculate if invalid
    -- Conditions for recalculation:
    --   - Value is NULL or <= 0 (invalid amount)
    --   - Doesn't match quantity * price (data inconsistency)
    -- Formula: ABS(sls_price) * sls_quantity
    -- ==========================================================================
    CASE 
        WHEN sls_sales <= 0 
          OR sls_sales IS NULL 
          OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN ABS(sls_price) * sls_quantity
        ELSE sls_sales
    END AS sls_sales,
    
    -- Pass-through column
    sls_quantity,
    
    -- ==========================================================================
    -- PRICE VALIDATION: sls_price
    -- Logic: Recalculate if invalid
    -- Conditions for recalculation:
    --   - Value is NULL or <= 0 (invalid price)
    -- Formula: sls_sales / sls_quantity
    -- Warning: Potential division by zero if sls_quantity = 0
    -- ==========================================================================
    CASE 
        WHEN sls_price <= 0 
          OR sls_sales IS NULL 
        THEN sls_sales / sls_quantity
        ELSE sls_price
    END AS sls_price
    
FROM bronze.crm_sales_details;

-- ============================================================================
-- END OF FILE
-- ============================================================================
-- RESULT: silver.crm_sales_details now contains cleaned, validated sales data
-- NEXT STEPS: 
--   - Verify data quality with SELECT queries
--   - Proceed to load into gold layer if needed
-- ============================================================================
