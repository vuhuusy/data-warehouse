DROP TABLE SYVH_STG_productlines;
DROP TABLE SYVH_STG_products;
DROP TABLE SYVH_STG_offices;
DROP TABLE SYVH_STG_employees;
DROP TABLE SYVH_STG_customers;
DROP TABLE SYVH_STG_payments;
DROP TABLE SYVH_STG_orders;
DROP TABLE SYVH_STG_orderdetails;

CREATE TABLE SYVH_STG_productlines (
  productLine VARCHAR2(50) PRIMARY KEY,
  textDescription VARCHAR2(4000),
  htmlDescription VARCHAR2(4000),
  image VARCHAR2(4000)
);

CREATE TABLE SYVH_STG_products (
  productCode VARCHAR2(15) PRIMARY KEY,
  productName VARCHAR2(70),
  productLine VARCHAR2(50),
  productScale VARCHAR2(10),
  productVendor VARCHAR2(50),
  productDescription VARCHAR2(1000),
  quantityInStock INT,
  buyPrice DECIMAL(10,2),
  MSRP DECIMAL(10,2)
);

CREATE TABLE SYVH_STG_offices (
  officeCode VARCHAR2(10) PRIMARY KEY,
  city VARCHAR2(50),
  phone VARCHAR2(50),
  addressLine1 VARCHAR2(50),
  addressLine2 VARCHAR2(50),
  state VARCHAR2(50),
  country VARCHAR2(50),
  postalCode VARCHAR2(15),
  territory VARCHAR2(10)
);

CREATE TABLE SYVH_STG_employees (
  employeeNumber INT PRIMARY KEY,
  lastName VARCHAR2(50),
  firstName VARCHAR2(50),
  extension VARCHAR2(10),
  email VARCHAR2(100),
  officeCode VARCHAR2(10),
  reportsTo INT,
  jobTitle VARCHAR2(50)
);

CREATE TABLE SYVH_STG_customers (
  customerNumber INT PRIMARY KEY,
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
  salesRepEmployeeNumber INT,
  creditLimit DECIMAL(10,2)
);

CREATE TABLE SYVH_STG_payments (
  customerNumber INT,
  checkNumber VARCHAR2(50),
  paymentDATE DATE,
  amount DECIMAL(10,2),
  PRIMARY KEY (customerNumber, checkNumber)
);

CREATE TABLE SYVH_STG_orders (
  orderNumber INT PRIMARY KEY,
  orderDATE DATE,
  requiredDATE DATE,
  shippedDATE DATE,
  status VARCHAR2(15),
  comments VARCHAR2(4000),
  customerNumber INT
);

CREATE TABLE SYVH_STG_orderdetails (
  orderNumber INT,
  productCode VARCHAR2(15),
  quantityOrdered INT,
  priceEach DECIMAL(10,2),
  orderLineNumber INT,
  PRIMARY KEY (orderNumber, productCode)
);