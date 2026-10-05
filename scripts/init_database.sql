/*
===============================================================================
Description: This SQL script creates the three schemas used to organize the
             data warehouse into different processing layers.

             Bronze: Stores raw data with minimal transformation.
             Silver: Stores cleaned and transformed data.
             Gold:   Stores business-ready data for reporting and analytics.

Note:        The 'data_warehouse' database must be created manually before
             running this script.

Database:    PostgreSQL
===============================================================================
*/

CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;
