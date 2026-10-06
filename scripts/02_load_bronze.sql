/*
===============================================================================
This SQL script performs a full load of the Bronze layer.

             The script first removes all existing data from the Bronze tables
             and then loads the latest raw data from the source CSV files.

             Bronze tables:
             CRM:
             - crm_cust_info
             - crm_prd_info
             - crm_sales_details

             ERP:
             - erp_cust_az12
             - erp_loc_at101
             - erp_px_cat_g1v2

Load Strategy:
             Full Load - existing data is removed before loading the source
             files again.

Note:        The 'data_warehouse' database, 'bronze' schema, and Bronze tables
             must already exist before running this script.

Database:    PostgreSQL
Layer:       Bronze
===============================================================================
*/


-- ============================================================================
-- CRM TABLES
-- ============================================================================

-- Remove existing data before the full load
TRUNCATE TABLE bronze.crm_cust_info;

-- Load customer data
COPY bronze.crm_cust_info
FROM '/var/lib/postgresql/import/source_crm/cust_info.csv'
WITH (
    FORMAT CSV,
    HEADER true
);


TRUNCATE TABLE bronze.crm_prd_info;

-- Load product data
COPY bronze.crm_prd_info
FROM '/var/lib/postgresql/import/source_crm/prd_info.csv'
WITH (
    FORMAT CSV,
    HEADER true
);


TRUNCATE TABLE bronze.crm_sales_details;

-- Load sales data
COPY bronze.crm_sales_details
FROM '/var/lib/postgresql/import/source_crm/sales_details.csv'
WITH (
    FORMAT CSV,
    HEADER true
);


-- ============================================================================
-- ERP TABLES
-- ============================================================================

TRUNCATE TABLE bronze.erp_cust_az12;

-- Load ERP customer data
COPY bronze.erp_cust_az12
FROM '/var/lib/postgresql/import/source_erp/CUST_AZ12.csv'
WITH (
    FORMAT CSV,
    HEADER true
);


TRUNCATE TABLE bronze.erp_loc_at101;

-- Load ERP location data
COPY bronze.erp_loc_at101
FROM '/var/lib/postgresql/import/source_erp/LOC_A101.csv'
WITH (
    FORMAT CSV,
    HEADER true
);


TRUNCATE TABLE bronze.erp_px_cat_g1v2;

-- Load ERP product category data
COPY bronze.erp_px_cat_g1v2
FROM '/var/lib/postgresql/import/source_erp/PX_CAT_G1V2.csv'
WITH (
    FORMAT CSV,
    HEADER true
);

