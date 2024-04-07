# <p align="center" style="font-size: 39px;"><strong>PROJECT: Building a Data Warehouse for an E-commerce company</strong></p>

In this project, I am going to build a Data Warehouse for an E-commerce company. Bảng Fact trong Data Warehouse sẽ thuộc loại Transaction - tức là bảng Fact sẽ lưu trữ các chỉ số đo lường được từ các lần đặt hàng. Mỗi hàng trong bảng Fact tương ứng với một chi tiết đơn hàng trong đơn hàng của khách hàng đặt.

## Table of Contents
1. [About the Dataset](#1)
2. [Tools used in the Project](#2)
3. [Exploratory Data Analysis](#3)
4. [Data Warehouse Architecture](#4)
5. [Implementation Process](#5)
   - 5.1 [ Data Source to Staging Area](#6)
   - 5.2 [Staging Area to Data Warehouse](#7)
   - 5.3 [Data Warehouse to Data Mart](#8)
   - 5.4 [Luồng tổng (Load plan)](#9)
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
- Trong phần này, chúng ta sẽ khám phá dữ liệu để có được cái nhìn tổng quan về bộ dữ liệu. Chúng ta sẽ xem xét các giá trị null, outliers, các dữ liệu nhiễu (lỗi) để có thể đưa ra quyết định xử lý dữ liệu ở lớp Staging.
- Exploratory Data Analysis: [Link](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/EDA.ipynb)
 
## 4. Data Warehouse Architecture <a id="4"></a>
![Data Warehouse Architecture](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/Data%20Warehouse%20Architecture.png)

Tổng quan kiến trúc Data Warehouse:
- **Data Source:** Dữ liệu nguồn được lấy từ [MySQL Sample Database](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/) và được lưu trữ trong CSDL MySQL
- **Staging Area:** Dữ liệu nguồn được đẩy vào lớp Staging để thực hiện tiền xử lý dữ liệu (dữ liệu lỗi, thiếu), phương thức Load 1:1 tức là dữ liệu sẽ y nguyên như ở lớp Data Source (có thể tùy chọn load theo Business date để chỉ lấy những dữ liệu mới nhất), được lưu trữ trong CSDL Oracle
- **Data Warehouse:** Dữ liệu sau khi được xử lý ở lớp Staging sẽ được đẩy vào lưu trữ trong Data Warehouse trong CSDL Oracle, trong đó:
   - Bảng Dim sẽ sử dụng cơ chế SCD để lưu vết lịch sử
   - Bảng Fact sẽ sử dụng cơ chế Control Append để load những dữ liệu mới
- **Data Mart:** Sau khi load dữ liệu đã được xử lý vào Data Warehouse, chúng ta tạo ra các Data Mart chứa dữ liệu cần dùng cho các phòng ban (department) (VD: product, region, customer)
- **BI Tool:** Cắm dữ liệu vào Power BI vào tạo ra các báo cáo để đưa ra insight.

## 5. Implementation Process <a id="5"></a>
### 5.1. Data Source to Staging Area <a id="6"></a>
- Trong **Project** của ODI, tạo 1 folder đặt tên là SRC-STG để lưu trữ các job đổ dữ liệu từ *Source* vào *Staging*.
- Trong Oracle Database: tạo database tên là Staging trong đó chứa các bảng có cấu trúc y hệt với các bảng ở source ([Code](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/staging/create%20table.sql)).
- Tạo ra các **MAPPING**, đặt tên: SRC-STG_<tên_bảng_nguồn> để thực hiện load 1:1 dữ liệu từ source vào staging.
  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/staging_mapping.png" width="300"/>
- Sử dụng Control Append và trước khi load dữ liệu mới vào bảng trong Staging thì sẽ phải truncate dữ liệu cũ trong Staging đi
- Load 1:1 tức là không làm biến đổi dữ liệu, bảng ở source và bảng ở staging sẽ giống hệt nhau (Lưu ý: trong thực tế khi ETL bảng giao dịch sẽ chặn dữ liệu theo ngày, ví dụ: chỉ ETL dữ liệu bán hàng ngày hôm nay).
- Knowledge Modules used:
   - LKM SQL to Oracle
   - IKM SQL Control Append (trong đó: FLOW_CONTROL = False, TRUNCATE = True - để xóa dữ liệu cũ trước khi đẩy vào Staging)
   - CKM SQL 

### 5.2 Staging Area to Data Warehouse <a id="7"></a>
- Trong **Project** của ODI, tạo 1 folder đặt tên là STG-DWH để lưu trữ các job từ Staging vào DWH
- Trong Oracle Database: tạo database tên là DWH trong đó chứa các bảng Dim và bảng Fact ([Logic mapping and SCD Behavior](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing), [Code](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/create_dim_fact_table.sql))
- Tạo ra các **MAPPING**, đặt tên: STG-DWH_<tên bảng đích> để thực hiện load dữ liệu từ Staging vào các bảng Dim và bảng Fact (*Lưu ý: Phải load dữ liệu vào bảng Dim trước bảng Fact để nếu dữ liệu ở bảng Dim thay đổi thì bảng Fact có thể tiếp nhận được sự thay đổi đó nhờ SCD Type 2*)

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/dwh_mapping.png" width="300"/>
- Trong bảng Dim cũng sẽ sử dụng thêm 3 thuộc tính sau:
     - STATUS_FLAG: chỉ báo hàng hiện tại có hiệu lực
     - STARTING_DATE: Ngày bắt đầu có hiệu lực
     - ENDING_DATE: Ngày hết hiệu lực
- Chú ý: Các bảng Dim sẽ sử dụng [Surrogate Key](https://www.kimballgroup.com/1998/05/surrogate-keys/) làm khóa chính (PK)
- Knowledge Modules used:
   - LKM Oracle to Oracle (Built-In)
   - IKM Oracle Slowly Changing Dimension
   - CKM Oracle
 
### 5.3 Data Warehouse to Data Mart <a id="8"></a>
- Trong **Project** của ODI, tạo 1 folder đặt tên là DWH – DATA MART để lưu trữ các job từ DWH vào Data Mart
- Trong Oracle Database: tạo các bảng lưu trữ dữ liệu được tổng hợp từ Data Warehouse ([Step 3](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing))
- Tạo các **MAPPING**, đặt tên: DWH-DMART_<tên_bảng_đích> để thực hiện load dữ liệu tổng hợp từ bảng Fact vào các bảng trong Data Mart
  
   <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/dmart_mapping.png" width="300"/>
- Knowledge Modules used:
  - IKM Oracle Insert
  - CKM Oracle

### 5.4 Luồng tổng (Load plan) <a id="9"></a>
- Tạo ra các **Scenario** của các **MAPPING** vừa tạo
- Thứ tự thực hiện **Scenario** như sau:

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/load_plan.png" width="700"/>

- Cấu hình chạy tự động mỗi ngày vào 12 giờ đêm như sau:

  <img src="https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/image/load_plan_scheduling.png" width="500"/>
### 5.5 Data Mart to BI Tool <a id="10"></a>
- Server: (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=222.252.21.249)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orclpdb)))
- Trong Power BI, tạo kết nối với Oracle database để lấy dữ liệu ([Hướng dẫn kết nối](https://indaacademy.vn/powerbi/ket-noi-power-bi-desktop-voi-oracle-database/))
- 

## 6. Other resources
- [Slide](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/tree/main/slide)
- [Steps to build a data warehouse](https://docs.google.com/document/d/1aUuI05t6H8JNAP0yxywMeoEULC0fLZ7-QiKZPJ1tfuQ/edit?usp=sharing)
