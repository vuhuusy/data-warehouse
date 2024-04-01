DROP TABLE SYVH_DIM_CUSTOMERS;
DROP TABLE SYVH_DIM_OFFICES;
DROP TABLE SYVH_DIM_PRODUCTS;
DROP TABLE SYVH_DIM_EMPLOYEES;
DROP TABLE SYVH_FACT_ORDERLINE_TRANS;

CREATE TABLE SYVH_DIM_CUSTOMERS (
  customerKey INT PRIMARY KEY,
  customerNumber INT,
  customerName VARCHAR2(50),
  contactLastName VARCHAR2(50),
  contactFirstName VARCHAR2(50),
  phone VARCHAR2(50),
  addressLine1 VARCHAR2(50),
  addressLine2 VARCHAR2(50),
  city VARCHAR2(50),
  state VARCHAR2(50),
  postalCode VARCHAR2(15),
  country VARCHAR2(50),
  salesRepEmployeeKey INT,
  creditLimit DECIMAL(10,2),
  status_flag VARCHAR2(1),
  starting_date DATE,
  ending_date DATE
);

CREATE TABLE SYVH_DIM_OFFICES (
  officeKey INT PRIMARY KEY,
  officeCode VARCHAR2(10),
  city VARCHAR2(50),
  phone VARCHAR2(50),
  addressLine1 VARCHAR2(50),
  addressLine2 VARCHAR2(50),
  state VARCHAR2(50),
  country VARCHAR2(50),
  postalCode VARCHAR2(15),
  territory VARCHAR2(10),
  status_flag VARCHAR2(1),
  starting_date DATE,
  ending_date DATE
);

CREATE TABLE SYVH_DIM_PRODUCTS (
  productKey INT PRIMARY KEY,
  productCode VARCHAR2(15),
  productName VARCHAR2(70),
  productLine VARCHAR2(50),
  productScale VARCHAR2(10),
  productVendor VARCHAR2(50),
  productDescription VARCHAR2(1000),
  MSRP DECIMAL(10,2),
  productLineDescription VARCHAR2(4000),
  status_flag VARCHAR2(1),
  starting_date DATE,
  ending_date DATE
);

CREATE TABLE SYVH_DIM_EMPLOYEES (
  employeeKey INT PRIMARY KEY,
  employeeNumber INT,
  lastName VARCHAR2(50),
  firstName VARCHAR2(50),
  extension VARCHAR2(10),
  email VARCHAR2(100),
  officeCode VARCHAR2(10),
  reportsTo INT,
  jobTitle VARCHAR2(50),
  status_flag VARCHAR2(1),
  starting_date DATE,
  ending_date DATE
);

CREATE TABLE SYVH_FACT_ORDERLINE_TRANS (
  orderNumber INT,
  orderLineNumber INT,
  orderDateKey VARCHAR2(8),
  requiredDateKey VARCHAR2(8),
  shippedDateKey VARCHAR2(8),
  customerKey INT,
  saleRepKey INT,
  officeKey INT,
  productKey INT,
  status VARCHAR2(20),
  quantityOrdered INT,
  priceEach DECIMAL(10,2),
  buyPrice DECIMAL(10,2),
  cost DECIMAL(20,4),
  revenue DECIMAL(20,4)
);