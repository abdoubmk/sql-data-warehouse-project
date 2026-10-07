/*
===============================================================================
Description: This SQL script creates the tables used to store the Silver layer
             of the data warehouse.

             The Silver layer contains cleaned, standardized, and transformed
             data from the Bronze layer.

             The data stored in this layer is prepared for further integration,
             analysis, and business reporting.

             Silver: Stores cleaned and transformed data.

Note:        The 'data_warehouse' database and 'silver' schema must be created
             manually before running this script.

Database:    PostgreSQL
Metadata : dwh_create_dt for all tables
===============================================================================
*/

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(1),
    cst_create_date    DATE,
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE silver.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(100),
    prd_cost     INT,
    prd_line     VARCHAR(1),
    prd_start_dt DATE,
    prd_end_dt   DATE,
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE silver.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE silver.erp_cust_az12 (
    cid   VARCHAR(50),
    bdate DATE,
    gen   VARCHAR(50),
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE silver.erp_loc_at101 (
    cid   VARCHAR(50),
    cntry VARCHAR(50),
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE silver.erp_px_cat_g1v2 (
    ac_br         VARCHAR(10),
    cat           VARCHAR(50),
    subcat        VARCHAR(50),
    maintenance   VARCHAR(50),
	dwh_create_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
