---Retail Store Analysis
select * from stores360
select * from orders360
select * from CUSTOMER360
------------------------------High level metrics--------------------------------------------------
--1.Total Orders
SELECT COUNT(DISTINCT Order_id) AS Total_Orders
FROM orders360

--2.Total Customers
SELECT COUNT(DISTINCT Custid) AS Total_Customers
FROM Customer360

--3. Total spend and profit, Total discount
SELECT ROUND(SUM(Total_Amount),2) AS Total_Spend, ROUND(SUM(Total_Cost),2) AS Total_Cost,ROUND(SUM(Profit),2) AS Total_Profit,ROUND(SUM(Quantity),2) AS Total_Qunatity,
SUM(Discount) AS Total_Discount FROM orders360

--4.avg Discount per order
select AVG(Discount) as Avg_Discount_Per_Order from orders360

--5. Average Order Value (AOV)
SELECT AVG(Total_Amount) AS Average_Order_Value FROM orders360

--6.Average Profit Per order
SELECT AVG(Profit) AS Average_Profit_Value
FROM orders360

--7.Total Categories
SELECT COUNT(DISTINCT Product_Category) AS Total_Categories
FROM orders360

--8. Total Stores
SELECT COUNT(DISTINCT Delivered_StoreID) AS Total_Stores FROM orders360

--9.Total Locations
SELECT COUNT(DISTINCT customer_city) AS Total_Locations FROM CUSTOMER360

--10. Total states
SELECT COUNT(DISTINCT customer_state) AS Total_States
FROM customer360

--11. Total channels
SELECT COUNT(DISTINCT Channel) AS Total_Channels
FROM orders360;

--12.Profit Percntage
SELECT (SUM(Profit) * 100.0 / SUM(Total_Amount)) AS Profit_Percentage FROM orders360

--13.Percentage of Discount
SELECT (SUM(Discount) * 100.0 / SUM(Total_Amount)) AS Discount_Percentage
FROM orders360; 

--Transaction per customer
SELECT CAST(COUNT(order_id) AS FLOAT) / COUNT(DISTINCT Customer_id) AS AvgTransactionsPerCustomer
FROM orders360;

--Total Delivered stores
SELECT COUNT(DISTINCT Delivered_StoreID) AS Total_Stores FROM orders360

--Total Products
SELECT COUNT(DISTINCT product_id) AS Total_Products FROM orders360

-- Male count
SELECT COUNT(DISTINCT Custid) AS Male_Customers
FROM customer360
where gender = 'M'

-- Female count
SELECT COUNT(DISTINCT Custid) AS Female_Customers
FROM customer360
where gender = 'F'

--14.  Repeat Purchase Rate(Percentage of customers who made more than one purchase.)
SELECT (COUNT(Customer_id) * 100.0 / (SELECT COUNT(DISTINCT Customer_id) FROM orders360)) AS Repeat_Purchase_Rate
FROM (
    SELECT Customer_id 
    FROM orders360
    GROUP BY Customer_id
    HAVING COUNT(Order_id) > 1
) tb;

--15. One Time Buysers Percentage
SELECT (COUNT(Customer_id) * 100.0 / (SELECT COUNT(DISTINCT Customer_id) FROM orders360)) AS One_Time_Buyers_Percentage
FROM (
    SELECT Customer_id 
    FROM orders360
    GROUP BY Customer_id
    HAVING COUNT(Order_id) = 1
) tb;

--Average Days Between Two Transactions(if the customer has more than one transaction)
WITH TransactionGaps AS (
    SELECT Customer_id,DATEDIFF(DAY, 
                 LAG(Bill_date_timestamp) OVER (PARTITION BY Customer_id ORDER BY bill_date_timestamp), 
                 Bill_date_timestamp) AS Days_Between_Transactions FROM orders360    )
SELECT Customer_id,AVG(Days_Between_Transactions) AS Avg_Days_Between_Transactions
FROM TransactionGaps
WHERE Days_Between_Transactions > 1
GROUP BY Customer_id;

--Average categories per order
SELECT AVG(CategoryCount) AS AvgCategoriesPerOrder
FROM (
    SELECT order_id, COUNT(DISTINCT Product_Category) AS CategoryCount
    FROM orders360 GROUP BY order_id
) AS CategoryCounts;

------------------------EDA ---------------------------------------------------------------------
--2. Category wise reveue and profit
SELECT Product_Category AS Category_Count,Round(SUM(Total_Amount),2) AS Revenue_Contribution
,SUM(Profit) AS Profit_Contribution
FROM customer360 AS c join orders360 AS o
ON c.custid = o.customer_id
GROUP BY Product_Category
ORDER BY Revenue_Contribution DESC;


--Store Wise Behaviour 
SELECT Delivered_StoreID, ROUND(SUM(Total_Amount),2) AS Total_Revenue
FROM orders360
orders360
GROUP BY Delivered_StoreID
ORDER BY Total_Revenue DESC;

--Understanding how many new customers acquired every month (who made transaction first time in the data)
SELECT 
	YEAR(First_Transaction_Date) AS Year,
    DATENAME(MONTH, First_Transaction_Date) AS Transaction_Month,
    COUNT(DISTINCT Custid) AS New_Customers
FROM CUSTOMER360
GROUP BY YEAR(First_Transaction_Date),DATENAME(MONTH, First_Transaction_Date), MONTH(First_Transaction_Date)
ORDER BY Year,MONTH(First_Transaction_Date)

--Monthly Revenue and New Customer Trends Over Time
SELECT 
    YEAR(First_Transaction_Date) AS Year,
    DATENAME(MONTH, First_Transaction_Date) AS Month_Name,
    ROUND(SUM(Monetary),2) AS Monthly_Revenue,
    COUNT(DISTINCT Custid) AS New_Customers
FROM CUSTOMER360
GROUP BY YEAR(First_Transaction_Date), DATENAME(MONTH, First_Transaction_Date), MONTH(First_Transaction_Date)
ORDER BY Year, MONTH(First_Transaction_Date)

--List the top 10 most expensive products sorted by price and their contribution to sales
SELECT TOP 10 Product_Category, 
ROUND(SUM(Total_Amount),2) AS Total_Sales,
SUM(Quantity) AS Total_Quantity
FROM orders360
GROUP BY  Product_Category
ORDER BY Total_Sales DESC

-- Top 10 Performing Stores
SELECT TOP 10
    Delivered_StoreID,
    ROUND(SUM(Total_Amount),2) AS Total_Store_Sales
FROM orders360
GROUP BY Delivered_StoreID
ORDER BY Total_Store_Sales DESC

-- Worst 10 Performing Stores
SELECT TOP 10
    Delivered_StoreID,
    ROUND(SUM(Total_Amount),2) AS Total_Store_Sales
FROM orders360
GROUP BY Delivered_StoreID
ORDER BY Total_Store_Sales ASC

--Understand the trends/seasonality of sales, quantity by category, region, store, channel, payment method etc…

--1.Sales by Region (Monthly Trend)
SELECT Region,ROUND(SUM(Total_Revenue),2) AS Total_Revenue
FROM  stores360
GROUP BY Region
ORDER BY Total_Revenue DESC

--2.Sales by State
SELECT seller_state,ROUND(SUM(Total_Revenue),2) AS Total_Revenue
FROM  stores360
GROUP BY seller_state
ORDER BY Total_Revenue DESC

--3. Sales by Channel
SELECT Channel, ROUND(SUM(Total_Amount),2) AS Total_Revenue,
SUM(Quantity) AS Total_Quantity
FROM orders360 
GROUP BY Channel
ORDER BY Total_Revenue DESC

--. Sales by Product_Category
SELECT Product_Category, ROUND(SUM(Total_Amount),2) AS Total_Revenue
FROM orders360 
GROUP BY Product_Category
ORDER BY Total_Revenue DESC

--Top 10 products by revenue
SELECT Top 10 product_id, ROUND(SUM(Total_Amount),2) AS Total_Revenue,
SUM(Quantity) AS Total_Quantity
FROM orders360 
GROUP BY product_id
ORDER BY Total_Revenue DESC

--Top 5 Product Categories by Revenue Across Regions
WITH RankedCategories AS (
    SELECT seller_state, Product_Category, ROUND(SUM(Total_Amount), 2) AS Total_Revenue,
        ROW_NUMBER() OVER (PARTITION BY seller_state ORDER BY SUM(Total_Amount) DESC) AS Rn
    FROM orders360 AS O
    JOIN stores360 AS S
    ON O.Delivered_StoreID = S.StoreID
    GROUP BY seller_state, Product_Category  )
SELECT seller_state, Product_Category, Total_Revenue
FROM RankedCategories
WHERE Rn <= 5
ORDER BY seller_state, Rn;

---------------------------------------------------------------------------------------------------------------------------
-------------------------------CUSTOMER BEHAVIOUR ANALYSIS--------------------------------------------------------------
--Gender Anaysis
SELECT Gender, COUNT(*) AS NumberOfCustomers
FROM Customers
GROUP BY Gender;

--Sales Distribution by Gender
SELECT Gender, ROUND(SUM(Monetary),2) AS TotalSales,
--ROUND((SUM(Monetary) * 100.0 / (SELECT SUM(Monetary) FROM CUSTOMER360)),2) AS PercentageOfTotalSales
ROUND(SUM(Total_Profit),2) AS TotalProfit
FROM CUSTOMER360 
GROUP BY Gender

--Customers by segment
SELECT Customer_Segment,  
ROUND(COUNT(Custid),2) AS Customer_cnt
FROM customer360
GROUP BY Customer_Segment
ORDER BY Customer_cnt DESC;

--REVENUE BY SEGMENT
SELECT Customer_Segment,  
ROUND(SUM(Monetary),2) AS Total_Revenue
FROM customer360
GROUP BY Customer_Segment
ORDER BY Total_Revenue DESC;

----Understand the behavior of discount seekers & non discount seekers

SELECT Discount_Type,COUNT(Custid) AS Customer_Count
FROM (
    SELECT Custid,
        CASE
            WHEN CAST(Transactions_With_Discount AS FLOAT) / NULLIF(Frequency, 0) >= 0.5 THEN 'Discount Seeker'
            ELSE 'Non-Discount Seeker' END AS Discount_Type
    FROM customer360
) tb
GROUP BY Discount_Type

--Sales nd Profit by discount vs Non discount seekers
SELECT Discount_Type, 
    ROUND(SUM(monetary),2) AS TotalSales,
    ROUND(SUM(Total_Profit),2) AS TotalProfit
FROM (
    SELECT Custid,Monetary, Total_Profit,       
        CASE WHEN CAST(Transactions_With_Discount AS FLOAT) / NULLIF(Frequency, 0) >= 0.5 THEN 'Discount Seeker'
            ELSE 'Non-Discount Seeker' END AS Discount_Type FROM customer360
) tb GROUP BY Discount_Type

------Discount Cusstomer Count by stores
SELECT 
    o.Delivered_Storeid, 
    COUNT(DISTINCT o.Customer_id) AS DiscountCustomerCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE 
    CAST(c.Transactions_With_Discount AS FLOAT) / NULLIF(c.Frequency, 0) >= 0.5  -- Discount Seeker condition
GROUP BY o.Delivered_Storeid
ORDER BY DiscountCustomerCount DESC

--Top 5 categories prchase by discount customers
SELECT TOP 5
    o.Product_Category,
    COUNT(o.Order_id) AS PurchaseCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE 
    CAST(c.Transactions_With_Discount AS FLOAT) / NULLIF(c.Frequency, 0) >= 0.5  -- Discount Seeker condition
GROUP BY o.Product_Category
ORDER BY PurchaseCount DESC

------Non Discount Customer Count by stores
SELECT 
    o.Delivered_Storeid, 
    COUNT(DISTINCT o.Customer_id) AS NonDiscountCustomerCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE 
    CAST(c.Transactions_With_Discount AS FLOAT) / NULLIF(c.Frequency, 0) < 0.5  -- Non-Discount Seeker condition
GROUP BY o.Delivered_Storeid ORDER BY NonDiscountCustomerCount DESC

----Top 5 categories prchase by Non discount customers
SELECT TOP 5 
    o.Product_Category,
    COUNT(o.Order_id) AS PurchaseCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE 
    CAST(c.Transactions_With_Discount AS FLOAT) / NULLIF(c.Frequency, 0) < 0.5  -- Non-Discount Seeker condition
GROUP BY o.Product_Category
ORDER BY PurchaseCount DESC

-----------------------------------One Time Buyers & Repeat Customers---------------------------------------------------
SELECT Buyer_Type,
    COUNT(DISTINCT Customer_id) AS Customer_Count,
    (COUNT(DISTINCT Customer_id) * 100.0 / (SELECT COUNT(DISTINCT Customer_id) FROM orders360)) AS Percentage
FROM (
    SELECT o.Customer_id,
    CASE WHEN COUNT(o.Order_id) = 1 THEN 'One-Time Buyer'ELSE 'Repeated Buyer'END AS Buyer_Type
    FROM orders360 o GROUP BY o.Customer_id
) AS BuyerSummary
GROUP BY Buyer_Type

--Revenue generated by one time buyers over time
SELECT 
    YEAR(o.Bill_date_timestamp) AS Order_Year, 
    DATENAME(MONTH, o.Bill_date_timestamp) AS Order_Month,
    ROUND(SUM(o.Total_Amount),2) AS Revenue
FROM orders360 o
JOIN (
    SELECT Customer_id
    FROM orders360 
    GROUP BY Customer_id
    HAVING COUNT(Order_id) = 1  -- One-time buyers only
) AS OneTimeBuyers ON o.Customer_id = OneTimeBuyers.Customer_id
GROUP BY YEAR(o.Bill_date_timestamp), MONTH(o.Bill_date_timestamp), DATENAME(MONTH, o.Bill_date_timestamp)
ORDER BY Order_Year, MONTH(o.Bill_date_timestamp);  -- Order first by year, then by month chronologically

--Number of One-Time Buyers Top 10  State
SELECT Top 10 c.customer_state, COUNT(DISTINCT o.Customer_id) AS OneTimeBuyerCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE c.Custid IN (
        SELECT Customer_id FROM orders360 
        GROUP BY Customer_id HAVING COUNT(Order_id) = 1  -- One-time buyers only 
		)
GROUP BY c.customer_state
ORDER BY OneTimeBuyerCount DESC

----Number of One-Time Buyers Top 10  Store
SELECT TOP 10 o.Delivered_Storeid, 
COUNT(DISTINCT o.Customer_id) AS OneTimeBuyerCount
FROM orders360 o
WHERE o.Customer_id IN (
    SELECT Customer_id FROM orders360 
    GROUP BY Customer_id HAVING COUNT(Order_id) = 1 -- One-time buyers only
)
GROUP BY o.Delivered_Storeid
ORDER BY OneTimeBuyerCount DESC

--Revenue generated by repeat time buyers over time
SELECT 
    YEAR(o.Bill_date_timestamp) AS Order_Year, 
    DATENAME(MONTH, o.Bill_date_timestamp) AS Order_Month,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM orders360 o
JOIN (
    SELECT Customer_id
    FROM orders360 
    GROUP BY Customer_id
    HAVING COUNT(Order_id) > 1  -- Repeat buyers only
) AS RepeatBuyers ON o.Customer_id = RepeatBuyers.Customer_id
GROUP BY YEAR(o.Bill_date_timestamp), MONTH(o.Bill_date_timestamp), DATENAME(MONTH, o.Bill_date_timestamp)
ORDER BY Order_Year, MONTH(o.Bill_date_timestamp);  -- Order first by year, then by month chronologically

--Number of RepeatTime Buyers Top 10  State
SELECT Top 10 c.customer_state, COUNT(DISTINCT o.Customer_id) AS OneTimeBuyerCount
FROM orders360 o
JOIN customer360 c ON o.Customer_id = c.Custid
WHERE c.Custid IN (
        SELECT Customer_id FROM orders360 
        GROUP BY Customer_id HAVING COUNT(Order_id) > 1  -- Repeat buyers only
		)
GROUP BY c.customer_state
ORDER BY OneTimeBuyerCount DESC

----Number of Repeat-Time Buyers Top 10  Store
SELECT TOP 10 o.Delivered_Storeid, 
COUNT(DISTINCT o.Customer_id) AS OneTimeBuyerCount
FROM orders360 o
WHERE o.Customer_id IN (
    SELECT Customer_id FROM orders360 
    GROUP BY Customer_id HAVING COUNT(Order_id) > 1 -- Repeat buyers only
)
GROUP BY o.Delivered_Storeid
ORDER BY OneTimeBuyerCount DESC

--Which products appeared in the transactions?
SELECT DISTINCT Product_ID, Product_Category 
FROM orders360
ORDER BY Product_ID;

--Segment the customers (divide the customers into groups) based on the revenue
SELECT Customer_Segment,  
ROUND(SUM(Monetary),2) AS Total_Revenue
FROM customer360
GROUP BY Customer_Segment
ORDER BY Total_Revenue DESC;

--
SELECT Customer_Segment,  
SUM(Monetary) AS Total_Revenue
FROM customer360
GROUP BY Customer_Segment
ORDER BY Total_Revenue DESC; 

------------------------------------One category buyers/Multiple categories buyers-----------------------

SELECT Category_Type,COUNT(DISTINCT Customer_id) AS Customer_Count,
(COUNT(DISTINCT Customer_id) * 100.0 / (SELECT COUNT(DISTINCT Customer_id) FROM orders360)) AS Percentage
FROM (
    SELECT o.Customer_id,
    CASE WHEN COUNT(DISTINCT o.Product_Category) = 1 THEN 'Single Category Buyer' ELSE 'Multiple Category Buyer'
    END AS Category_Type FROM orders360 o GROUP BY o.Customer_id
) AS CategorySummary
GROUP BY Category_Type
ORDER BY Category_Type;

------------------------------------------------------------
--Count of customers who purchases across all channels,i.e, Instore,online,Phone delivery

SELECT 
    COUNT(DISTINCT Customer_id) AS Customers_Count,
    (COUNT(DISTINCT Customer_id) * 100.0 / (SELECT COUNT(DISTINCT Customer_id) FROM orders360)) AS Percentage
FROM (
    SELECT Customer_id
    FROM orders360 o
    GROUP BY Customer_id
    HAVING COUNT(DISTINCT o.Channel) = (SELECT COUNT(DISTINCT Channel) FROM orders360)
) AS AllChannelCustomers



------------------------------SALES ANALYSIS OVER TIME--------------------------------------------------------------------------------------------
-- Weekly Seasonality
SELECT DATENAME(WEEKDAY, Bill_date_timestamp) AS Weekday,
    ROUND(SUM(Total_Amount), 2) AS TotalSales,
	ROUND((SUM(Total_Amount) * 100.0) / (SELECT SUM(Total_Amount) FROM orders360), 2
    ) AS SalesPercentage
FROM orders360
GROUP BY DATENAME(WEEKDAY, Bill_date_timestamp),DATEPART(WEEKDAY, Bill_date_timestamp)
ORDER BY DATEPART(WEEKDAY, Bill_date_timestamp)

--Hourly Seasonality
SELECT DATENAME(HOUR, Bill_date_timestamp) AS Hour,
    ROUND(SUM(Total_Amount), 2) AS TotalSales,
	ROUND((SUM(Total_Amount) * 100.0) / (SELECT SUM(Total_Amount) FROM orders360), 2) AS SalesPercentage
FROM orders360
GROUP BY DATENAME(HOUR, Bill_date_timestamp), DATEPART(HOUR, Bill_date_timestamp)
ORDER BY DATEPART(HOUR, Bill_date_timestamp)

--Monthly
SELECT DATENAME(MONTH, Bill_date_timestamp) AS Month_,
       ROUND(SUM(Total_Amount), 2) AS TotalSales,
	   ROUND((SUM(Total_Amount) * 100.0) / (SELECT SUM(Total_Amount) FROM orders360), 2) AS SalesPercentage
FROM orders360
GROUP BY DATENAME(MONTH, Bill_date_timestamp), MONTH(Bill_date_timestamp)
ORDER BY MONTH(Bill_date_timestamp)

-- Yearly Seasonality (Year-over-Year Comparison)
SELECT YEAR(Bill_date_timestamp) AS Year,ROUND(SUM(Total_Amount), 2) AS TotalSales,
ROUND((SUM(Total_Amount) * 100.0) / (SELECT SUM(Total_Amount) FROM orders360), 2) AS SalesPercentage
FROM orders360
GROUP BY YEAR(Bill_date_timestamp)
ORDER BY TotalSales 
------------------------------------
--Top2 weeks with highest sales each year

WITH RankedWeeks AS (
    SELECT 
        YEAR(Bill_date_timestamp) AS Year,
        DATENAME(MONTH, Bill_date_timestamp) AS MonthName,
        DATEPART(WEEK, Bill_date_timestamp) AS WeekNumber,
        MIN(Bill_date_timestamp) AS StartDate,
        MAX(Bill_date_timestamp) AS EndDate,
        ROUND(SUM(Total_Amount), 2) AS TotalSales,
        ROW_NUMBER() OVER (PARTITION BY YEAR(Bill_date_timestamp) ORDER BY SUM(Total_Amount) DESC) AS WeekRank
    FROM orders360
    GROUP BY YEAR(Bill_date_timestamp), DATENAME(MONTH, Bill_date_timestamp), DATEPART(WEEK, Bill_date_timestamp)
)
SELECT 
    Year,
    CONCAT(MonthName, ' ', DAY(StartDate), '-', DAY(EndDate)) AS WeekRange,
    TotalSales
FROM RankedWeeks
WHERE WeekRank <= 2
ORDER BY Year, WeekRank;

--Weekday vs weekend Sales
SELECT
    CASE WHEN DATEPART(WEEKDAY, Bill_date_timestamp) IN (1, 7) THEN 'Weekend'
         ELSE 'Weekday' END AS DayType,
    ROUND(SUM(Total_AMOUNT),2) AS TotalSales,
	ROUND((SUM(Total_Amount) * 100.0) / (SELECT SUM(Total_Amount) FROM orders360), 2) AS SalesPercentage
FROM orders360
GROUP BY CASE WHEN DATEPART(WEEKDAY, Bill_date_timestamp) IN (1, 7) THEN 'Weekend'
         ELSE 'Weekday' END

------------------------------------------------------------------------------------------------------------------
--category Performance Analysis

WITH CategorySales AS (
    SELECT Product_Category,ROUND(SUM(Total_Amount), 2) AS TotalSales
    FROM orders360 GROUP BY Product_Category
)
SELECT Product_Category,TotalSales,
    ROUND((TotalSales / SUM(TotalSales) OVER ()) * 100, 2) AS PercentageOfTotalSales
FROM CategorySales ORDER BY TotalSales DESC

---------CUSTOMER BEHAVIOR ANALYSIS------------------------------------

-----Count of customers in each state
SELECT customer_state, COUNT(DISTINCT custid) AS NumberOfCustomers
FROM customer360
GROUP BY customer_state
ORDER BY NumberOfCustomers DESC

-----------------------------------
----Preferred Channel by customers
SELECT
    Preferred_Channel,COUNT(Custid) AS Customer_Count
FROM (
    SELECT Custid,
        CASE
            WHEN Instore_Frequency >= Online_Frequency AND Instore_Frequency >= Phone_Frequency THEN 'Instore'
            WHEN Online_Frequency >= Instore_Frequency AND Online_Frequency >= Phone_Frequency THEN 'Online'
            ELSE 'Phone' END AS Preferred_Channel
    FROM customer360
) tb GROUP BY Preferred_Channel
ORDER BY Customer_Count DESC

----Preferred Payment Method by customers
SELECT
    COUNT(CASE WHEN Transactions_Paid_With_Voucher = 1 THEN 1 END) AS VOUCHER_CUST, -- Count customers who used Voucher
    COUNT(CASE WHEN Transactions_Paid_With_Credit_Card = 1 THEN 1 END) AS CREDIT_CUST, -- Count customers who used Credit Card
    COUNT(CASE WHEN Transactions_Paid_With_Debit_Card = 1 THEN 1 END) AS DEBIT_CUST, -- Count customers who used Debit Card
    COUNT(CASE WHEN Transactions_Paid_With_UPI = 1 THEN 1 END) AS UPI_CUST -- Count customers who used UPI
FROM 
    customer360 AS c



----Discount VS Non Discount Seekers
SELECT
    Custid,
    CAST(Transactions_With_Discount AS FLOAT) / NULLIF(Frequency, 0) AS Discount_Proportion,
    CASE
        WHEN CAST(Transactions_With_Discount AS FLOAT) / NULLIF(Frequency, 0) >= 0.5 THEN 'Discount Seeker'
        ELSE 'Non-Discount Seeker'
    END AS Discount_Type
FROM customer360

--------------


SELECT 
    CASE 
        WHEN Category_Purchase_Frequency = 1 THEN 'One Category Purchaser'
        WHEN Category_Purchase_Frequency > 1 THEN 'Multiple Categories Purchaser'
    END AS Frequency_Category,
    COUNT(DISTINCT customer_id) AS CustomerCount
FROM orders360
GROUP BY Category_Purchase_Frequency
ORDER BY CustomerCount DESC


----------------------------------------------------------
--customers divided into one time buyers vs Repeat buyers

WITH CustomerPurchases AS (
    SELECT Customer_id,COUNT(Order_id) AS PurchaseCount
    FROM orders360 GROUP BY Customer_id
)
SELECT
    CASE 
        WHEN PurchaseCount = 1 THEN 'One-Time Buyer'
        WHEN PurchaseCount > 1 THEN 'Repeat Buyer'
    END AS BuyerType, COUNT(Customer_ID) AS CustomerCount
FROM CustomerPurchases
GROUP BY 
    CASE 
        WHEN PurchaseCount = 1 THEN 'One-Time Buyer'
        WHEN PurchaseCount > 1 THEN 'Repeat Buyer'
    END ORDER BY CustomerCount DESC;

select * from orders360
select * from customer360


--Find out the number of customers who purchased in all the channels and find the key metrics.
SELECT
    COUNT(DISTINCT customer_id) AS num_customers_all_channels,
    SUM(Total_Amount) AS total_spent,
    AVG(Total_Amount) AS avg_spend_per_customer,
    COUNT(order_id) AS total_purchases,
    MAX(Bill_date_timestamp) AS recency
FROM orders360
WHERE customer_id IN (
    SELECT customer_id
    FROM orders360
    GROUP BY customer_id
    HAVING COUNT(DISTINCT channel) = (SELECT COUNT(DISTINCT channel) FROM orders360)
)
-----------------------------CATEGORY BEHAVIOR------------------------------------------------
--
WITH CategorySales AS (
    SELECT 
        product_category, 
        ROUND(SUM(Total_Amount),2) AS TotalSales
    FROM orders360
    GROUP BY product_category
),
OrderedCategorySales AS (
    SELECT
        product_category,
        TotalSales,
        SUM(TotalSales) OVER () AS TotalSalesAllCategories -- Total of all category sales
    FROM CategorySales
)
SELECT 
    product_category,
    TotalSales,
    SUM(TotalSales) OVER (ORDER BY TotalSales DESC ROWS UNBOUNDED PRECEDING) AS CumulativeSales,  -- Cumulative sales adding up
    ROUND(SUM(TotalSales) OVER (ORDER BY TotalSales DESC ROWS UNBOUNDED PRECEDING) * 100.0 / TotalSalesAllCategories, 2) AS CumulativePercentage
FROM OrderedCategorySales
ORDER BY TotalSales DESC;  -- Order categories by TotalSales in descending order

--Most Popular Categories During First Purchase and Number of Orders
WITH FirstPurchase AS (
    SELECT 
        Customer_id, 
        MIN(Bill_date_timestamp) AS FirstPurchaseDate
    FROM Orders360
    GROUP BY Customer_id
)

SELECT 
    o.Product_Category, 
    COUNT(o.Bill_date_timestamp) AS NumberOfOrders
FROM Orders360 o
JOIN FirstPurchase fp ON o.Customer_id = fp.Customer_id
WHERE o.Bill_date_timestamp = fp.FirstPurchaseDate
GROUP BY o.Product_Category
ORDER BY NumberOfOrders DESC;

-------------------------------CUSTOMER SATISFACTION ANALYSIS--------------------------------
-- Top 5 Maximum Rated Categories
SELECT TOP 5
    Product_Category, 
    ROUND(AVG(customer_satisfaction_score),2) AS Average_Rating
FROM orders360
GROUP BY Product_Category
ORDER BY Average_Rating DESC;

-- Bottom 5 Maximum Rated Categories
SELECT TOP 5
    Product_Category, 
    ROUND(AVG(customer_satisfaction_score),2) AS Average_Rating
FROM orders360
GROUP BY Product_Category
ORDER BY Average_Rating ASC;

---- Average Rating by Store/Id 
SELECT 
    Delivered_StoreID, 
    ROUND(AVG(customer_satisfaction_score),2) AS Average_Rating
FROM orders360
GROUP BY Delivered_StoreID
ORDER BY Average_Rating DESC;
---Min,max,avg rating by state
SELECT 
    c.customer_state, 
    COUNT(customer_satisfaction_score) AS Rating_Count,
    MIN(customer_satisfaction_score) AS Min_Rating,
    MAX(customer_satisfaction_score) AS Max_Rating,
    ROUND(AVG(customer_satisfaction_score),2) AS Average_Rating
FROM orders360 AS o
JOIN CUSTOMER360 AS c
ON o.Customer_id = c.Custid
GROUP BY c.customer_state
ORDER BY Average_Rating DESC;

SELECT  
    FORMAT(Bill_date_timestamp, 'yyyy-MM') AS Year_Month,
    ROUND(AVG(customer_satisfaction_score), 2) AS Avg_Rating
FROM orders360 
GROUP BY FORMAT(Bill_date_timestamp, 'yyyy-MM')
ORDER BY Year_Month ASC, Avg_Rating DESC;





--------Cross-Selling (Which products are selling together)-------------------------------------------------------- 
SELECT TOP 10
    oi1.product_category AS ProductCategory1,
    oi2.product_category AS ProductCategory2,
    oi3.product_category AS ProductCategory3,
    ROUND(SUM(oi1.Total_Amount + oi2.Total_Amount + oi3.Total_Amount), 2) AS TotalSales
FROM orders360 oi1
JOIN orders360 oi2 ON oi1.order_id = oi2.order_id
JOIN orders360 oi3 ON oi1.order_id = oi3.order_id
WHERE oi1.product_category < oi2.product_category 
    AND oi1.product_category < oi3.product_category 
    AND oi2.product_category < oi3.product_category
GROUP BY oi1.product_category, oi2.product_category, oi3.product_category
ORDER BY TotalSales DESC;

----------------------------------------
--Top 5 Main Categories and Their Most Associated Categories by Order Count
WITH CategoryCrossSelling AS (
    SELECT 
        c1.product_category AS MainCategory,
        c2.product_category AS AssociatedCategory,
        COUNT(DISTINCT c1.order_id) AS OrderCount
    FROM orders360 c1
    JOIN orders360 c2 
        ON c1.order_id = c2.order_id 
        AND c1.product_category <> c2.product_category
    GROUP BY c1.product_category, c2.product_category
),
TopMainCategories AS (
    SELECT TOP 5 product_category AS MainCategory
    FROM orders360
    GROUP BY product_category
    ORDER BY COUNT(DISTINCT order_id) DESC
)

SELECT 
    cs.MainCategory,
    cs.AssociatedCategory,
    cs.OrderCount
FROM CategoryCrossSelling cs
JOIN TopMainCategories tmc
    ON cs.MainCategory = tmc.MainCategory
WHERE cs.AssociatedCategory IN (
    SELECT TOP 5 product_category
    FROM orders360
    WHERE product_category <> cs.MainCategory
    GROUP BY product_category
    ORDER BY COUNT(DISTINCT order_id) DESC
)
ORDER BY cs.MainCategory, cs.OrderCount DESC;


---------------------------------------------------------------------------------------------


