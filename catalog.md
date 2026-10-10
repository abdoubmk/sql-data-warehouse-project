Here is a data catalog for your three Gold-layer views. You can save it as `gold_data_catalog.md` in your data warehouse project repository.

# Gold Layer — Data Catalog

## 1. `gold.dim_customers`

Description: Customer dimension view containing customer details enriched with demographic and geographic information from the CRM and ERP Silver-layer tables. It is designed to support customer segmentation and analytical reporting.

| Attribute         | Description                                                           |
| ----------------- | --------------------------------------------------------------------- |
| `customer_key`    | Generated surrogate key identifying a customer in the dimension view. |
| `customer_id`     | Original customer ID from the CRM system.                             |
| `customer_number` | Business identifier assigned to the customer.                         |
| `first_name`      | Customer's first name.                                                |
| `last_name`       | Customer's last name.                                                 |
| `country`         | Customer's country of residence.                                      |
| `marital_status`  | Customer's marital status.                                            |
| `gender`          | Customer's gender, standardized using CRM and ERP information.        |
| `birthdate`       | Customer's date of birth.                                             |
| `created_date`    | Date the customer record was created in the CRM system.               |

## 2. `gold.dim_products`

Description: Product dimension view combining product details with category, subcategory, and maintenance information. It includes currently active products and supports product analysis and categorization.

| Attribute        | Description                                                                     |
| ---------------- | ------------------------------------------------------------------------------- |
| `product_key`    | Generated surrogate key identifying a product in the dimension view.            |
| `product_id`     | Original product ID from the CRM system.                                        |
| `product_number` | Business identifier of the product.                                             |
| `product_name`   | Name or description of the product.                                             |
| `category_id`    | Identifier of the product category.                                             |
| `category`       | Product category name.                                                          |
| `subcategory`    | Product subcategory name.                                                       |
| `maintenance`    | Maintenance classification or requirement associated with the product category. |
| `cost`           | Product cost.                                                                   |
| `product_line`   | Product line classification, such as Mountain, Road, or Touring.                |
| `start_date`     | Date from which the current product record is valid.                            |

## 3. `gold.fact_sales`

Description: Sales fact view containing sales transaction details linked to customer and product dimensions. It supports sales analysis by customer, product, order date, and financial measures.

| Attribute       | Description                                                    |
| --------------- | -------------------------------------------------------------- |
| `order_number`  | Identifier of the sales order.                                 |
| `product_key`   | Surrogate key linking the transaction to `gold.dim_products`.  |
| `customer_key`  | Surrogate key linking the transaction to `gold.dim_customers`. |
| `order_date`    | Date the sales order was placed.                               |
| `shipping_date` | Date the order was shipped.                                    |
| `due_date`      | Scheduled due date associated with the order.                  |
| `sales_amount`  | Sales amount recorded for the transaction.                     |
| `quantity`      | Number of units sold.                                          |
| `price`         | Price recorded for the transaction.                            |

## Summary of the Gold layer

| View                 | Type      | Purpose                             |
| -------------------- | --------- | ----------------------------------- |
| `gold.dim_customers` | Dimension | Customer analysis and segmentation  |
| `gold.dim_products`  | Dimension | Product analysis and categorization |
| `gold.fact_sales`    | Fact      | Sales reporting and analysis        |

Data modeling: Your Gold layer follows a dimensional modeling approach with two dimension views and one fact view. The fact view uses the customer and product surrogate keys to connect sales transactions to descriptive information.

