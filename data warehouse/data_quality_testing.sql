-- So sánh kết quả 2 câu truy vấn sau để kiểm tra dữ liệu có mất mát hay tính toán sai không

-- Sử dụng câu truy vấn này ở database lưu trữ Data Warehouse
SELECT revenue
FROM syvh_fact_orderline_trans
ORDER BY revenue DESC;

-- Sử dụng câu truy vấn này ở staging layer
SELECT quantityordered * priceeach AS revenue
FROM syvh_stg_orderdetails
ORDER BY revenue DESC;