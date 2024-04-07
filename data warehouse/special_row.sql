-- INSERT DIM_EMPLOYEES SPECIAL ROW
INSERT INTO SYVH_DIM_EMPLOYEES 
VALUES (0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', '0', 0, 'Unknown', '1', TO_DATE('1-1-1900', 'DD-MM-YYYY'), TO_DATE('1-1-2400', 'DD-MM-YYYY'));

-- INSERT DIM_CUSTOMERS SPECIAL ROW
INSERT INTO SYVH_DIM_CUSTOMERS
VALUES (0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 0, NULL, '1', TO_DATE('1-1-1900', 'DD-MM-YYYY'), TO_DATE('1-1-2400', 'DD-MM-YYYY'));

-- INSERT DIM_OFFICES SPECIAL ROW
INSERT INTO SYVH_DIM_OFFICES
VALUES (0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '1', TO_DATE('1-1-1900', 'DD-MM-YYYY'), TO_DATE('1-1-2400', 'DD-MM-YYYY'));

-- INSERT DIM_PRODUCTS SPECIAL ROW
INSERT INTO SYVH_DIM_PRODUCTS
VALUES (0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', NULL, NULL, 'Unknown', '1', TO_DATE('1-1-1900', 'DD-MM-YYYY'), TO_DATE('1-1-2400', 'DD-MM-YYYY'));

-- INSERT DIM_DATE SPECIAL ROW
INSERT INTO SYVH_DIM_DATE (DATE_VALUE, DATE_KEY)
VALUES (0, TO_DATE('1-1-2400', 'DD-MM-YYYY'));