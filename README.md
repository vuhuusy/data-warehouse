# <p align="center" style="font-size: 39px;"><strong>Project: Xây dựng Data Warehouse cho công ty thương mại điện tử</strong></p>

## Table of Contents
1. [Thông tin về bộ dữ liệu](#line-30)

### 1. Thông tin về bộ dữ liệu
   - Bao gồm giới thiệu về bộ dữ liệu (dữ liệu về gì)

### 3. Khám phá dữ liệu (EDA)
   - Số bảng cột,...

### 4. Giới thiệu về Tool sử dụng trong Project
- Database: MySQL, Oracle Database
- Data Integration Tool: Oracle Data Integrator
- Data Visualization: 

### 5. Kiến trúc Data Warehouse
![Data Warehouse Architecture](https://github.com/vuhuusy/Data-Warehouse-for-Classicmodels-Database/blob/main/data%20warehouse/Data%20Warehouse%20Architecture.png)

Tổng quan kiến trúc Data Warehouse:
- **Data Source:** Dữ liệu nguồn được lấy từ [MySQL Sample Database](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/) và được lưu trữ trong CSDL MySQL
- **Staging Area:** Dữ liệu nguồn được đẩy vào lớp Staging để thực hiện tiền xử lý dữ liệu (dữ liệu lỗi, thiếu), phương thức Load 1:1 tức là dữ liệu sẽ y nguyên như ở lớp Data Source (có thể tùy chọn load theo Business date để chỉ lấy những dữ liệu mới nhất), được lưu trữ trong CSDL Oracle
- **Data Warehouse:** Dữ liệu sau khi được xử lý ở lớp Staging sẽ được đẩy vào lưu trữ trong Data Warehouse trong CSDL Oracle, trong đó:
   - Bảng Dim sẽ sử dụng cơ chế SCD để lưu vết lịch sử
   - Bảng Fact sẽ sử dụng cơ chế Control Append để load những dữ liệu mới
- **Data Mart:** Sau khi load dữ liệu đã được xử lý vào Data Warehouse, chúng ta tạo ra các Data Mart chứa dữ liệu cần dùng cho các phòng ban (department) (VD: product, region, customer)
- **BI Tool:** Cắm dữ liệu vào Power BI vào tạo ra các báo cáo để đưa ra insight
