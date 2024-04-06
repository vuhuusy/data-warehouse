# <p align="center" style="font-size: 39px;"><strong>PROJECT: Building a Data Warehouse for an E-commerce company</strong></p>

## Table of Contents
1. [About the Dataset](#line-30)

## 1. About the Dataset
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
      <img src="https://www.mysqltutorial.org/wp-content/uploads/2023/10/mysql-sample-database.png" width="600" />

## 2. Tools used in the Project
- EDA: Python (pandas, matplotlib, seaborn, ...)
- Database: MySQL, Oracle Database
- Data Integration Tool: Oracle Data Integrator
- Data Visualization: PowerBI

## 3. Exploratory Data Analysis (EDA)
- Exploratory Data Analysis: [Link](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/EDA.ipynb)
 

## 4. Kiến trúc Data Warehouse
![Data Warehouse Architecture](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/Data%20Warehouse%20Architecture.png)

Tổng quan kiến trúc Data Warehouse:
- **Data Source:** Dữ liệu nguồn được lấy từ [MySQL Sample Database](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/) và được lưu trữ trong CSDL MySQL
- **Staging Area:** Dữ liệu nguồn được đẩy vào lớp Staging để thực hiện tiền xử lý dữ liệu (dữ liệu lỗi, thiếu), phương thức Load 1:1 tức là dữ liệu sẽ y nguyên như ở lớp Data Source (có thể tùy chọn load theo Business date để chỉ lấy những dữ liệu mới nhất), được lưu trữ trong CSDL Oracle
- **Data Warehouse:** Dữ liệu sau khi được xử lý ở lớp Staging sẽ được đẩy vào lưu trữ trong Data Warehouse trong CSDL Oracle, trong đó:
   - Bảng Dim sẽ sử dụng cơ chế SCD để lưu vết lịch sử
   - Bảng Fact sẽ sử dụng cơ chế Control Append để load những dữ liệu mới
- **Data Mart:** Sau khi load dữ liệu đã được xử lý vào Data Warehouse, chúng ta tạo ra các Data Mart chứa dữ liệu cần dùng cho các phòng ban (department) (VD: product, region, customer)
- **BI Tool:** Cắm dữ liệu vào Power BI vào tạo ra các báo cáo để đưa ra insight

## 5. Other resources
- Slide
