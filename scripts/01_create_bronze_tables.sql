/*
===============================================================================
This SQL script creates the tables in the Bronze layer of the
             data warehouse.

             The Bronze layer stores raw data extracted from source systems
             with minimal or no transformation. The tables are organized
             according to their source systems:

             CRM:
             - crm_cust_info
             - crm_prd_info
             - crm_sales_details

             ERP:
             - erp_cust_az12
             - erp_loc_at101
             - erp_px_cat_g1v2

Note:        The 'data_warehouse' database and 'bronze' schema must already
             exist before running this script.

Database:    PostgreSQL
Layer:       Bronze
===============================================================================
*/


-- ============================================================================
-- CRM TABLES
-- ============================================================================

-- Customer information
CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(1),
    cst_create_date    DATE
);


-- Product information
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(100),
    prd_cost     INT,
    prd_line     VARCHAR(1),
    prd_start_dt DATE,
    prd_end_dt   DATE
);


-- Sales information
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);


-- ============================================================================
-- ERP TABLES
-- ============================================================================

-- ERP customer information
CREATE TABLE bronze.erp_cust_az12 (
    cid   VARCHAR(50),
    bdate DATE,
    gen   VARCHAR(50)
);


-- ERP customer location information
CREATE TABLE bronze.erp_loc_at101 (
    cid   VARCHAR(50),
    cntry VARCHAR(50)
);


-- ERP product category information
CREATE TABLE bronze.erp_px_cat_g1v2 (
    ac_br         VARCHAR(10),
    cat           VARCHAR(50),
    subcat        VARCHAR(50),
    maintenance   VARCHAR(50)
);
```
