--Creation of order360
select * from OrdersFinal_New

SELECT o.*,
    p.category AS Product_Category,                     -- Product Category
	COUNT( DISTINCT op.payment_type) Payment_Type_count, --payment type count
	COUNT(DISTINCT p.category) AS Category_Purchase_Frequency,  --category freq count
    COUNT(DISTINCT o.Delivered_StoreID) AS Store_Count ,-- Count of Distinct Stores
	AVG(Avg_Customer_Satisfaction_Score) AS customer_satisfaction_score,
	SUM(CASE WHEN payment_type = 'Credit_Card' THEN (Total_Amount) ELSE 0 END ) CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' THEN (Total_Amount) ELSE 0 END )  DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' THEN (Total_Amount) ELSE 0 END )  UPI_Cash_amt,
	SUM(CASE WHEN payment_type = 'Voucher' THEN (Total_Amount) ELSE 0 END )  Voucher_amt    INTO orders360
FROM 
    OrdersFinal o
JOIN 
    ProductsInfo  p ON o.Product_id = p.product_id
JOIN 
    OrderPayments1 op ON o.order_id = op.order_id
JOIN 
    OrderReview_Ratings r ON r.order_id = o.Order_id
GROUP BY 
	o.Order_id,o.Customer_id,o.product_id,o.Delivered_StoreID,
	o.Bill_date_timestamp,o.Channel,o.Discount,
	o.Quantity,o.Cost_Per_Unit,o.MRP,o.Total_Amount,o.Total_Cost,o.Profit,
    p.category
ORDER BY 
    o.Customer_id;


select * from Orders360  --102450rows

select count(distinct order_id) as Total_Orders from orders360_1   --98393 distinct orderids

select round(sum(Total_Amount),2) as total_Amt from orders360_1
select round(sum(Profit),2) as total_profit from orders360_1


select * from OrderReview_Ratings

ALTER TABLE orders360
ALTER COLUMN customer_satisfaction_score FLOAT;
