DROP TABLE SYVH_DMART_PRODUCT;
DROP TABLE SYVH_DMART_CUSTOMER;
DROP TABLE SYVH_DMART_EMPLOYEE;
DROP TABLE SYVH_DMART_OFFICE;

CREATE TABLE SYVH_DMART_PRODUCT (
    productKey INT,
    productName VARCHAR2(70),
    month VARCHAR(6),
    quantitySold INT,
    cost DECIMAL(38,8),
    revenue DECIMAL(38,8),
    profit DECIMAL(38,8)
);

CREATE TABLE SYVH_DMART_CUSTOMER (
    customerKey INT,
    productKey INT,
    month VARCHAR(6),
    quantitySold INT,
    cost DECIMAL(38,8),
    revenue DECIMAL(38,8),
    profit DECIMAL(38,8)
);

CREATE TABLE SYVH_DMART_EMPLOYEE (
    employeeKey INT,
    productKey INT,
    month VARCHAR(6),
    quantitySold INT,
    cost DECIMAL(38,8),
    revenue DECIMAL(38,8),
    profit DECIMAL(38,8)
);

CREATE TABLE SYVH_DMART_OFFICE (
    officeKey INT,
    productKey INT,
    month VARCHAR(6),
    quantitySold INT,
    cost DECIMAL(38,8),
    revenue DECIMAL(38,8),
    profit DECIMAL(38,8)
);