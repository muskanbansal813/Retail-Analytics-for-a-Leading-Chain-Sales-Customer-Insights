SELECT 
		c.Custid,
        c.customer_city,
        c.customer_state,
        c.Gender,
        MIN(o.Bill_date_timestamp) AS First_Transaction_Date,
        MAX(o.Bill_date_timestamp) AS Last_Transaction_Date,
		DATEDIFF(DAY, MIN(Bill_date_timestamp),MAX(Bill_date_timestamp)) AS Tenure,
		DATEDIFF(DAY, MAX(Bill_date_timestamp),(SELECT MAX(Bill_date_timestamp) FROM OrdersFinal)) AS Inactive_Days,
        COUNT(o.order_id) AS Frequency,
        COUNT(DISTINCT o.order_id) AS Distinct_Transactions,
        SUM(o.Total_Amount) AS Monetary,
        SUM(o.Profit) AS Total_Profit,
        SUM(o.Discount) AS Total_Discount,
        SUM(o.Quantity) AS Total_Quantity,
        COUNT(DISTINCT o.product_id) AS Distinct_Items_Purchased,
        COUNT(DISTINCT p.category) AS Distinct_Categories_Purchased,
        COUNT(CASE WHEN o.Discount > 0 THEN 1 END) AS Transactions_With_Discount,
        COUNT(CASE WHEN o.Profit < 0 THEN 1 END) AS Transactions_With_Loss,
        COUNT(DISTINCT o.Channel) AS No_Of_Channels_Used,
        COUNT(DISTINCT o.Delivered_StoreID) AS No_Of_DelieverdStores,
        COUNT(DISTINCT c.customer_city) AS No_Of_Cities_Purchased,
        COUNT(DISTINCT op.payment_type) AS No_Of_Payment_Types_Used,
        COUNT(CASE WHEN op.payment_type = 'Voucher' THEN 1 END) AS Transactions_Paid_With_Voucher,
        COUNT(CASE WHEN op.payment_type = 'credit_card' THEN 1 END) AS Transactions_Paid_With_Credit_Card,
        COUNT(CASE WHEN op.payment_type = 'debit_card' THEN 1 END) AS Transactions_Paid_With_Debit_Card,
        COUNT(CASE WHEN op.payment_type = 'UPI/Cash' THEN 1 END) AS Transactions_Paid_With_UPI,
	---Channels
    -- For Instore
    COUNT(CASE WHEN o.Channel = 'Instore' THEN o.order_id ELSE NULL END) AS Instore_Frequency,   -- Number of Transactions
    COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN o.order_id ELSE NULL END) AS Instore_Distinct_Transactions, -- Distinct Transactions
    SUM(CASE WHEN o.Channel = 'Instore' THEN o.Total_Amount ELSE 0 END) AS Instore_Monetary,   -- Total Revenue
    SUM(CASE WHEN o.Channel = 'Instore' THEN o.Total_Amount ELSE 0 END) AS Instore_Total_Amount_Spent,  -- Total Spent
    SUM(CASE WHEN o.Channel = 'Instore' THEN o.Profit ELSE 0 END) AS Instore_Profit,  -- Total Profit
    SUM(CASE WHEN o.Channel = 'Instore' THEN o.Discount ELSE 0 END) AS Instore_Discount,  -- Total Discount
    SUM(CASE WHEN o.Channel = 'Instore' THEN o.Quantity ELSE 0 END) AS Instore_Total_Quantity,  -- Total Quantity
    COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN o.product_id ELSE NULL END) AS Instore_Distinct_Items_Purchased, -- Distinct Items
    COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN p.Category ELSE NULL END) AS Instore_Distinct_Categories_Purchased, -- Distinct Categories
	 COUNT(CASE WHEN o.Channel = 'Instore' AND o.Discount > 0 THEN o.order_id ELSE NULL END) AS Instore_Transactions_With_Discount, -- Transactions with Discount
    COUNT(CASE WHEN o.Channel = 'Instore' AND o.Profit < 0 THEN o.order_id ELSE NULL END) AS Instore_Transactions_With_Loss, -- Transactions with Loss
	COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN (o.Delivered_StoreID) ELSE NULL END) Instore_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN (seller_city) ELSE NULL END) Instore_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Instore' THEN (payment_type) ELSE NULL END) Instore_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Instore' THEN (Total_Amount) ELSE 0 END ) Instore_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Instore' THEN (Total_Amount) ELSE 0 END ) Instore_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Instore' THEN (Total_Amount) ELSE 0 END ) Instore_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Instore' THEN (Total_Amount) ELSE 0 END ) Instore_Vouch_amt,

	--ONLINE
	COUNT(CASE WHEN o.Channel = 'Online' THEN o.order_id ELSE NULL END) AS Online_Frequency,   -- Number of Transactions
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN o.order_id ELSE NULL END) AS Online_Distinct_Transactions, -- Distinct Transactions
	SUM(CASE WHEN o.Channel = 'Online' THEN o.Total_Amount ELSE 0 END) AS Online_Monetary,   -- Total Revenue
	SUM(CASE WHEN o.Channel = 'Online' THEN o.Total_Amount ELSE 0 END) AS Online_Total_Amount_Spent,  -- Total Spent
	SUM(CASE WHEN o.Channel = 'Online' THEN o.Profit ELSE 0 END) AS Online_Profit,  -- Total Profit
	SUM(CASE WHEN o.Channel = 'Online' THEN o.Discount ELSE 0 END) AS Online_Discount,  -- Total Discount
	SUM(CASE WHEN o.Channel = 'Online' THEN o.Quantity ELSE 0 END) AS Online_Total_Quantity,  -- Total Quantity
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN o.product_id ELSE NULL END) AS Online_Distinct_Items_Purchased, -- Distinct Items
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN p.Category ELSE NULL END) AS Online_Distinct_Categories_Purchased, -- Distinct Categories
	COUNT(CASE WHEN o.Channel = 'Online' AND o.Discount > 0 THEN o.order_id ELSE NULL END) AS Online_Transactions_With_Discount, -- Transactions with Discount
	COUNT(CASE WHEN o.Channel = 'Online' AND o.Profit < 0 THEN o.order_id ELSE NULL END) AS Online_Transactions_With_Loss, -- Transactions with Loss
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN (o.Delivered_StoreID) ELSE NULL END) Online_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN (seller_city) ELSE NULL END) Online_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Online' THEN (payment_type) ELSE NULL END) Online_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Online' THEN (Total_Amount) ELSE 0 END ) Online_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Online' THEN (Total_Amount) ELSE 0 END ) Online_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Online' THEN (Total_Amount) ELSE 0 END ) Online_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Online' THEN (Total_Amount) ELSE 0 END ) Online_Vouch_amt,

	--PHONE DELIVERY
	COUNT(CASE WHEN o.Channel = 'Phone Delivery' THEN o.order_id ELSE NULL END) AS Phone_Frequency,   -- Number of Transactions
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN o.order_id ELSE NULL END) AS Phone_Distinct_Transactions, -- Distinct Transactions
	SUM(CASE WHEN o.Channel = 'Phone Delivery' THEN o.Total_Amount ELSE 0 END) AS Phone_Monetary,   -- Total Revenue
	SUM(CASE WHEN o.Channel = 'Phone Delivery' THEN o.Total_Amount ELSE 0 END) AS Phone_Total_Amount_Spent,  -- Total Spent
	SUM(CASE WHEN o.Channel = 'Phone Delivery' THEN o.Profit ELSE 0 END) AS Phone_Profit,  -- Total Profit
	SUM(CASE WHEN o.Channel = 'Phone Delivery' THEN o.Discount ELSE 0 END) AS Phone_Discount,  -- Total Discount
	SUM(CASE WHEN o.Channel = 'Phone Delivery' THEN o.Quantity ELSE 0 END) AS Phone_Total_Quantity,  -- Total Quantity
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN o.product_id ELSE NULL END) AS Phone_Distinct_Items_Purchased, -- Distinct Items
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN p.Category ELSE NULL END) AS Phone_Distinct_Categories_Purchased, -- Distinct Categories
	COUNT(CASE WHEN o.Channel = 'Phone Delivery' AND o.Discount > 0 THEN o.order_id ELSE NULL END) AS Phone_Transactions_With_Discount, -- Transactions with Discount
	COUNT(CASE WHEN o.Channel = 'Phone Delivery' AND o.Profit < 0 THEN o.order_id ELSE NULL END) AS Phone_Transactions_With_Loss, -- Transactions with Loss
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN (o.Delivered_StoreID) ELSE NULL END) PhoneDelivery_Distinct_Stores,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN (seller_city) ELSE NULL END) PhoneDelivery_Distinct_Cities,
	COUNT(DISTINCT CASE WHEN o.Channel = 'Phone Delivery' THEN (payment_type) ELSE NULL END) PhoneDelivery_Distinct_PayType,
	SUM(CASE WHEN payment_type = 'Credit_Card' AND O.channel = 'Phone Delivery' THEN (Total_Amount) ELSE 0 END ) PhoneDelivery_CC_amt,
	SUM(CASE WHEN payment_type = 'Debit_Card' AND O.channel = 'Phone Delivery' THEN (Total_Amount) ELSE 0 END ) PhoneDelivery_DC_amt,
	SUM(CASE WHEN payment_type = 'UPI/Cash' AND O.channel = 'Phone Delivery' THEN (Total_Amount) ELSE 0 END ) PhoneDelivery_UPI_Cash_amt,
    SUM(CASE WHEN payment_type = 'Voucher' AND O.channel = 'Phone Delivery' THEN (Total_Amount) ELSE 0 END ) PhoneDelivery_Vouch_amt,
	--FOR CATEGORIES
	--1.
	COUNT(DISTINCT CASE WHEN p.Category = 'Food & Beverages' THEN (o.order_id) ELSE NULL END) Food_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Food & Beverages' THEN (o.product_id) ELSE NULL END) Food_Prod_count,
	SUM(CASE WHEN p.Category = 'Food & Beverages' THEN (Total_Amount) ELSE 0 END) Food_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Food & Beverages' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Food_Profit,
	SUM(CASE WHEN p.Category = 'Food & Beverages' THEN (o.Discount) ELSE 0 END) Food_Discount,
	SUM(CASE WHEN p.Category = 'Food & Beverages' THEN (QUANTITY) ELSE 0 END) Food_Quantity,
	--2.
	COUNT(DISTINCT CASE WHEN p.Category = 'Construction_Tools' THEN (o.order_id) ELSE NULL END) Construction_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Construction_Tools' THEN (o.product_id) ELSE NULL END) Construction_Prod_count,
	SUM(CASE WHEN p.Category = 'Construction_Tools' THEN (Total_Amount) ELSE 0 END) Construction_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Construction_Tools' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Construction_Profit,
	SUM(CASE WHEN p.Category = 'Construction_Tools' THEN (o.Discount) ELSE 0 END) Construction_Discount,
	SUM(CASE WHEN p.Category = 'Construction_Tools' THEN (QUANTITY) ELSE 0 END) Construction_Quantity,
	--3.
	COUNT(DISTINCT CASE WHEN p.Category = 'Fashion' THEN (o.order_id) ELSE NULL END) Fashion_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Fashion' THEN (o.product_id) ELSE NULL END) Fashion_Prod_count,
	SUM(CASE WHEN p.Category = 'Fashion' THEN (Total_Amount) ELSE 0 END) Fashion_Total_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Fashion' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Fashion_Profit,
	SUM(CASE WHEN p.Category = 'Fashion' THEN (o.Discount) ELSE 0 END) Fashion_Discount,
	SUM(CASE WHEN p.Category = 'Fashion' THEN (QUANTITY) ELSE 0 END) Fashion_Quantity,
	--4.
	COUNT(DISTINCT CASE WHEN p.Category = 'Stationery' THEN (o.order_id) ELSE NULL END) Stationery_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Stationery' THEN (o.product_id) ELSE NULL END) Stationery_Prod_count,
	SUM(CASE WHEN p.Category = 'Stationery' THEN (Total_Amount) ELSE 0 END) Stationery_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Stationery' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Stationery_Profit,
	SUM(CASE WHEN p.Category = 'Stationery' THEN (o.Discount) ELSE 0 END) Stationery_Discount,
	SUM(CASE WHEN p.Category = 'Stationery' THEN (QUANTITY) ELSE 0 END) Stationery_Quantity,
	--5.
	COUNT(DISTINCT CASE WHEN p.Category = 'Pet_Shop' THEN (o.order_id) ELSE NULL END) PetShop_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Pet_Shop' THEN (o.product_id) ELSE NULL END) PetShop_Prod_count,
	SUM(CASE WHEN p.Category = 'Pet_Shop' THEN (Total_Amount) ELSE 0 END) PetShop_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Pet_Shop' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) PetShop_Profit,
	SUM(CASE WHEN p.Category = 'Pet_Shop' THEN (o.Discount) ELSE 0 END) PetShop_Discount,
	SUM(CASE WHEN p.Category = 'Pet_Shop' THEN (QUANTITY) ELSE 0 END) PetShop_Quantity,
	--6.
	COUNT(DISTINCT CASE WHEN p.Category = 'Luggage_Accessories' THEN (o.order_id) ELSE NULL END) Luggage_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Luggage_Accessories' THEN (o.product_id) ELSE NULL END) Luggage_Prod_count,
	SUM(CASE WHEN p.Category = 'Luggage_Accessories' THEN (Total_Amount) ELSE 0 END) Luggage_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Luggage_Accessories' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Luggage_Profit,
	SUM(CASE WHEN p.Category = 'Luggage_Accessories' THEN (o.Discount) ELSE 0 END) Luggage_Discount,
	SUM(CASE WHEN p.Category = 'Luggage_Accessories' THEN (QUANTITY) ELSE 0 END) Luggage_Quantity,
	--7.
	COUNT(DISTINCT CASE WHEN p.Category = 'Electronics' THEN (o.order_id) ELSE NULL END) Electronics_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Electronics' THEN (o.product_id) ELSE NULL END) Electronics_Prod_count,
	SUM(CASE WHEN p.Category = 'Electronics' THEN (Total_Amount) ELSE 0 END) Electronics_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Electronics' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Electronics_Profit,
	SUM(CASE WHEN p.Category = 'Electronics' THEN (o.Discount) ELSE 0 END) Electronics_Discount,
	SUM(CASE WHEN p.Category = 'Electronics' THEN (QUANTITY) ELSE 0 END) Electronics_Quantity,
	--8.
	COUNT(DISTINCT CASE WHEN p.Category = 'Toys & Gifts' THEN (o.order_id) ELSE NULL END) ToysGifts_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Toys & Gifts' THEN (o.product_id) ELSE NULL END) ToysGifts_Prod_count,
	SUM(CASE WHEN p.Category = 'Toys & Gifts' THEN (Total_Amount) ELSE 0 END) ToysGifts_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Toys & Gifts' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) ToysGifts_Profit,
	SUM(CASE WHEN p.Category = 'Toys & Gifts' THEN (o.Discount) ELSE 0 END) ToysGifts_Discount,
	SUM(CASE WHEN p.Category = 'Toys & Gifts' THEN (QUANTITY) ELSE 0 END) ToysGifts_Quantity,
	--9.
	COUNT(DISTINCT CASE WHEN p.Category = 'Furniture' THEN (o.order_id) ELSE NULL END) Furniture_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Furniture' THEN (o.product_id) ELSE NULL END) Furniture_Prod_count,
	SUM(CASE WHEN p.Category = 'Furniture' THEN (Total_Amount) ELSE 0 END) Furniture_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Furniture' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Furniture_Profit,
	SUM(CASE WHEN p.Category = 'Furniture' THEN (o.Discount) ELSE 0 END) Furniture_Discount,
	SUM(CASE WHEN p.Category = 'Furniture' THEN (QUANTITY) ELSE 0 END) Furniture_Quantity,
	--10.
	COUNT(DISTINCT CASE WHEN p.Category = 'Auto' THEN (o.order_id) ELSE NULL END) Auto_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Auto' THEN (o.product_id) ELSE NULL END) Auto_Prod_count,
	SUM(CASE WHEN p.Category = 'Auto' THEN (Total_Amount) ELSE 0 END) Auto_Total_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Auto' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Auto_Profit,
	SUM(CASE WHEN p.Category = 'Auto' THEN (o.Discount) ELSE 0 END) Auto_Discount,
	SUM(CASE WHEN p.Category = 'Auto' THEN (QUANTITY) ELSE 0 END) Auto_Quantity,
	--11.
	COUNT(DISTINCT CASE WHEN p.Category = 'Baby' THEN (o.order_id) ELSE NULL END) Baby_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Baby' THEN (o.product_id) ELSE NULL END) Baby_Prod_count,
	SUM(CASE WHEN p.Category = 'Baby' THEN (Total_Amount) ELSE 0 END) Baby_Total_amt,
	ROUND(SUM(CASE WHEN P.Category = 'Baby' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Baby_Profit,
	SUM(CASE WHEN p.Category = 'Baby' THEN (o.Discount) ELSE 0 END) Baby_Discount,
	SUM(CASE WHEN p.Category = 'Baby' THEN (QUANTITY) ELSE 0 END) Baby_Quantity,
	--12.
	COUNT(DISTINCT CASE WHEN p.Category = 'Computers & Accessories' THEN (o.order_id) ELSE NULL END) Computer_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Computers & Accessories' THEN (o.product_id) ELSE NULL END) Computer_Prod_count,
	SUM(CASE WHEN p.Category = 'Computers & Accessories' THEN (Total_Amount) ELSE 0 END) Computer_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Computers & Accessories' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Computer_Profit,
	SUM(CASE WHEN p.Category = 'Computers & Accessories' THEN (o.Discount) ELSE 0 END) Computer_Discount,
	SUM(CASE WHEN p.Category = 'Computers & Accessories' THEN (QUANTITY) ELSE 0 END) Computer_Quantity,
	--13.
	COUNT(DISTINCT CASE WHEN p.Category = 'Home_Appliances' THEN (o.order_id) ELSE NULL END) HomeApp_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Home_Appliances' THEN (o.product_id) ELSE NULL END) HomeApp_Prod_count,
	SUM(CASE WHEN p.Category = 'Home_Appliances' THEN (Total_Amount) ELSE 0 END) HomeApp_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Home_Appliances' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) HomeApp_Profit,
	SUM(CASE WHEN p.Category = 'Home_Appliances' THEN (o.Discount) ELSE 0 END) HomeApp_Discount,
	SUM(CASE WHEN p.Category = 'Home_Appliances' THEN (QUANTITY) ELSE 0 END) HomeApp_Quantity,
	--14
	COUNT(DISTINCT CASE WHEN p.Category = 'Unknown' THEN (o.order_id) ELSE NULL END) Unknown_Transactions_Count,
	COUNT(CASE WHEN p.Category = 'Unknown' THEN (o.product_id) ELSE NULL END) Unknown_Prod_count,
	SUM(CASE WHEN p.Category = 'Unknown' THEN (Total_Amount) ELSE 0 END) Unknown_Total_amt,
	ROUND(SUM(CASE WHEN p.Category = 'Unknown' THEN (Total_Amount) - (o.Quantity * Cost_Per_Unit) ELSE 0 END),2) Unknown_Profit,
	SUM(CASE WHEN p.Category = 'Unknown' THEN (o.Discount) ELSE 0 END) Unknown_Discount,
	SUM(CASE WHEN p.Category = 'Unknown' THEN (QUANTITY) ELSE 0 END) Unknown_Quantity
	INTO CUSTOMER360
FROM  OrdersFinal  o 
LEFT JOIN  Customers c ON c.Custid=o.Customer_id
LEFT JOIN ProductsInfo p ON o.product_id=p.product_id
LEFT JOIN OrderPayments1 op ON o.order_id=op.order_id
LEFT JOIN StoresInfo s ON o.Delivered_StoreID=s.StoreID
GROUP BY Custid,customer_city,customer_state,Gender       --98302 rows

-----------------------------------------------------------------------------------------------
--Add customer segment based on the spend (Low, Medium, High) based on percentile (P33, P66)
ALTER TABLE customer360
ADD Customer_Segment NVARCHAR(50);


WITH Percentiles AS (
    SELECT 
        PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY Monetary) OVER () AS P33,
        PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY Monetary) OVER () AS P66
    FROM customer360
)
UPDATE customer360
SET Customer_Segment = CASE 
    WHEN Monetary <= p.P33 THEN 'Low Spend'
    WHEN Monetary <= p.P66 THEN 'Medium Spend'
    ELSE 'High Spend'
END
FROM customer360 c
CROSS JOIN Percentiles p;

select * from customer360


SELECT ROUND(SUM(Total_Amount),2) AS Total_Spend, ROUND(SUM(Profit),2) AS Total_Profit,ROUND(SUM(Quantity),2) AS Total_Qunatity,
SUM(Discount) AS Total_Discount
FROM orders360_1

SELECT ROUND(SUM(Monetary),2) AS Total_Spend, ROUND(SUM(Total_Profit),2) AS Total_Profit,ROUND(SUM(Total_Quantity),2) AS Total_Qunatity,
SUM(Total_Discount) AS Total_Discount
FROM CUSTOMER360

SELECT ROUND(SUM(Total_Revenue),2) AS Total_Spend, ROUND(SUM(Profit),2) AS Total_Profit,ROUND(SUM(Total_Quantity),2) AS Total_Qunatity,
SUM(Total_Discount) AS Total_Discount
FROM stores360

select * from OrderPayments
select * from OrdersFinal_New

SELECT MAX(Bill_date_timestamp) AS Last_Transaction_Date FROM OrdersFinal

SELECT MAX(Bill_date_timestamp) AS Last_Transaction_Date FROM Orders1

SELECT DISTINCT Category FROM ProductsInfo