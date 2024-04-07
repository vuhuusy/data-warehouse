# <p align="center" style="font-size: 39px;"><strong>PROJECT: Building a Data Warehouse for an E-commerce company</strong></p>

In this project, I will be constructing a **Data Warehouse** to serve for analysis and report generation from the order data of the e-commerce company. Since the source data is in the form of transactional order data, the Fact table in the Data Warehouse will belong to the Transaction Fact table type - meaning the Fact table will store the measured metrics derived from each order placed. Each row in the Fact table corresponds to a specific order detail within a customer's placed order.

## Table of Contents
1. [About the Dataset](#1)
2. [Tools used in the Project](#2)
3. [Exploratory Data Analysis](#3)
4. [Data Warehouse Architecture](#4)
   - 4.1 [Overview of the Data Warehouse Architecture](#4.1)
   - 4.2 [Star Schema](#4.2)
6. [Implementation Process](#5)
   - 5.1 [ Data Source to Staging Area](#6)
   - 5.2 [Staging Area to Data Warehouse](#7)
   - 5.3 [Data Warehouse to Data Mart](#8)
   - 5.4 [Load Plan in ODI](#9)
   - 5.5 [Data Mart to BI Tool](#10)

## 1. About the Dataset <a id="1"></a>
   - The `classicmodels` database is a retailer of scale models of classic cars. It contains typical business data, including information about customers, products, sales orders, sales order line items, and more.
   - The MySQL sample database schema consists of the following tables:
      - **customers:** stores customer’s data.
      - **products:** stores a list of scale model cars.
      - **productlines:** stores a list of product lines.
      - **orders:** stores sales orders placed by customers.
      - **orderdetails:** stores sales order line items for every sales order.
      - **payments:** stores payments made by customers based on their accounts.
      - **employees:** stores employee information and the organization structure such as who reports to whom.
      - **offices:** stores sales office data.
   - The following picture illustrates the ER diagram of the sample database:
      <img src="https://www.mysqltutorial.org/wp-content/uploads/2023/10/mysql-sample-database.png" width="500"/>

## 2. Tools used in the Project <a id="2"></a>
- EDA: Python (pandas, matplotlib, seaborn, ...)
- Database: MySQL, Oracle Database
- Data Integration Tool: Oracle Data Integrator
- Data Visualization: PowerBI

## 3. Exploratory Data Analysis <a id="3"></a>
- In this section, we will explore the source data to gain an overview of the dataset. We will examine null values, outliers, and noisy data to make decisions on how to handle the data at the Staging layer.
- Exploratory Data Analysis: [Link](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/EDA.ipynb)
 
## 4. Data Warehouse Architecture <a id="4"></a>
![Data Warehouse Architecture](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/Data%20Warehouse%20Architecture.png)

### 4.1 Overview of the Data Warehouse Architecture <a id="4.1"></a>
- **Data Source:** The source data is retrieved from the [MySQL Sample Database](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/) and stored in a MySQL database.
- **Staging Area:** Source data is pushed into the Staging layer for preprocessing (handling errors, missing data). The Load method is 1:1, meaning the data remains identical to that in the Data Source (optional: can load based on Business date to fetch only the latest data). Staging data is stored in an Oracle database.
- **Data Warehouse:** Data processed in the Staging layer is loaded into the Data Warehouse storage in an Oracle database, where:
Dimension tables use Slowly Changing Dimension (SCD) mechanism to track historical changes.
Fact tables use Control Append mechanism to load new data.
- **Data Mart:** After loading processed data into the Data Warehouse, we create Data Marts containing data required for various departments (e.g., product, region, customer).
- **BI Tool:** Data is plugged into Power BI to generate reports for insights.

### 4.2 Star Schema <a id="4.2"></a>
<img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/Star%20Schema.png" width="600"/>

- Star schema consists of 4 Dimension tables and 1 Fact table as follows:
   - Employee dimension: contains information about employees
   - Customer dimension: contains information about customers
   - Date dimension: contains information about time
   - Office dimension: contains information about offices
   - Product dimension: contains information about products
   - Orderline Transaction Fact: contains information about order line details

## 5. Implementation Process <a id="5"></a>
### 5.1. Data Source to Staging Area <a id="6"></a>
- For the ODI **Project**, create a folder named `SRC-STG` to store jobs for loading data from *Source* to *Staging*.
- In the Oracle Database, create a database named `Staging` containing tables with structures identical to those in the source ([Code](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/staging/create%20table.sql)).
- Create **MAPPING**s named: `SRC-STG_<source_table_name>` to perform a 1:1 data load from source to staging.
  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/staging_mapping.png" width="300"/>
- Utilize Control Append, and before loading new data into the table in Staging, old data in Staging must be truncated.
- Load 1:1 means no data transformation is applied; the tables in both the source and staging will be identical (*Note: in reality, when ETL-ing transaction tables, data is typically filtered by date, for example, only ETL-ing today's sales data*).
- Knowledge Modules used:
   - LKM SQL to Oracle
   - IKM SQL Control Append (where: FLOW_CONTROL = False, TRUNCATE = True - to delete old data before pushing into Staging)
   - CKM SQL

### 5.2 Staging Area to Data Warehouse <a id="7"></a>
- Within the ODI **Project**, create a folder named `STG-DWH` to store jobs from Staging to DWH.
- In the Oracle Database: create a database named "DWH" containing Dim and Fact tables ([Logic mapping and SCD Behavior](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing), [Code](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/create_dim_fact_table.sql)).
- Create **MAPPING**s, named: `STG-DWH_<destination_table_name>` to load data from Staging into Dim and Fact tables (*Note: Data must be loaded into Dim tables before Fact tables so that if data in Dim tables changes, the Fact table can capture those changes through SCD Type 2*).

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/dwh_mapping.png" width="300"/>
- In the Dim tables, three additional attributes will be used:
   - **STATUS_FLAG:** indicating the current valid row
   - **STARTING_DATE:** Start date of validity
   - **ENDING_DATE:** End date of validity
- Dim tables will use [Surrogate Keys](https://www.kimballgroup.com/1998/05/surrogate-keys/) as primary keys (PK).
- Knowledge Modules used:
   - LKM Oracle to Oracle (Built-In)
   - IKM Oracle Slowly Changing Dimension
   - CKM Oracle
 
### 5.3 Data Warehouse to Data Mart <a id="8"></a>
- Within the ODI **Project**, create a folder named `DWH – DATA MART` to store jobs from DWH to Data Mart.
- In the Oracle Database: create tables to store data aggregated from the Data Warehouse ([Step 3](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing)).
- Create **MAPPING**s, named: `DWH-DMART_<destination_table_name>` to load aggregated data from Fact tables into tables within the Data Mart.
  
   <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/dmart_mapping.png" width="300"/>
- Knowledge Modules used:
  - IKM Oracle Insert
  - CKM Oracle

### 5.4 Load Plan in ODI <a id="9"></a>
- Create **Scenario**s for the **MAPPING**s created earlier.
- The execution sequence for the Scenarios is as follows:

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/load_plan.png" width="700"/>

- Configure automatic daily execution at midnight as follows:

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/load_plan_scheduling.png" width="500"/>
  
### 5.5 Data Mart to BI Tool <a id="10"></a>
- In **Power BI**, establish a connection with the **Oracle database** to fetch processed data ([Connection Guide](https://indaacademy.vn/powerbi/ket-noi-power-bi-desktop-voi-oracle-database/))
- Create reports to serve for analysis and decision-making purposes.

## 6. Other resources
- [Summary slide of key content in The Data Warehouse Toolkit book](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/tree/main/slide)
- [Step-by-step process of building a Data Warehouse](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing)
