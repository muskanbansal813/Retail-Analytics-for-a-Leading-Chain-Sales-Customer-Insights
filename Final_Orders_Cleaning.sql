--create database Project1
--use Project1

----------------------Data Cleaning--------------------------------------
-- Orders Table
SELECT * INTO Orders1
FROM Orders

--------------------------------------
-- Count total records in the Orders Table
SELECT COUNT(*) AS Total_Records
FROM Orders1           --112650 rows

--To Check the records where total amount and payment value is matching
SELECT o.* INTO ORDERS_R1 -- 88625 (Matched rows)
FROM orders1 o
JOIN (
    SELECT o.order_id
    FROM orders1 o
    LEFT JOIN (
        SELECT order_id, SUM(payment_value) AS PAYMENT_VALUE
        FROM OrderPayments
        GROUP BY order_id
    ) op ON o.order_id = op.order_id
    GROUP BY o.order_id, PAYMENT_VALUE
    HAVING ABS(ROUND(SUM(Total_Amount), 0) - ROUND(PAYMENT_VALUE, 0)) < 1
) C ON o.order_id = C.order_id

---(ii)To Check the records where total amount and payment value is matching
SELECT O.*  --INTO ORDERS_R2             --(24025 rows)
FROM orders1 O
WHERE O.order_id NOT IN (
    SELECT Y.order_id
    FROM (
        SELECT order_id, SUM(payment_value) AS PAYMENT_VALUE
        FROM OrderPayments
        GROUP BY order_id
    ) X
    INNER JOIN (
        SELECT order_id, SUM(Total_Amount) AS TOTAL_AMOUNT
        FROM orders1
        GROUP BY order_id
    ) Y
    ON X.order_id = Y.order_id
    WHERE ABS(ROUND(X.PAYMENT_VALUE, 0) - ROUND(Y.TOTAL_AMOUNT, 0)) < 1
)

SELECT * FROM orders_R2 --24025 rows

--To solve the discrepanciesin unmatched records
--Step1:Take the max qty for same custid,orderid,productid 
WITH MaxQty AS (                    --13800 rows affected
    SELECT Customer_id, order_id, product_id, Channel,Delivered_StoreID,
         Bill_date_timestamp,Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount,
        DENSE_RANK() OVER (PARTITION BY order_id, product_id ORDER BY Quantity DESC
        ) AS rn
    FROM Orders_R2
)
SELECT Customer_id, order_id, product_id, Channel,Delivered_StoreID,
         Bill_date_timestamp,Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount
	--into orders_R3
FROM MaxQty
WHERE rn = 1

SELECT * FROM orders_r3

--After solving the cummalative qty issue we remove discrepancies from 6553 rows
SELECT o.* INTO ORDERS_R4 -- 6553 (Matched rows: 88625+6553=95173)
FROM orders_R3 o
JOIN (
    SELECT o.order_id
    FROM orders_R3 o
    LEFT JOIN (
        SELECT order_id, SUM(payment_value) AS PAYMENT_VALUE
        FROM OrderPayments
        GROUP BY order_id
    ) op ON o.order_id = op.order_id
    GROUP BY o.order_id, PAYMENT_VALUE
    HAVING ABS(ROUND(SUM(Total_Amount), 0) - ROUND(PAYMENT_VALUE, 0)) < 1
) C ON o.order_id = C.order_id

-----------------------------------------------------------------------------------------
--From umatched rows the 8038 rows still not resolved
              
SELECT X.*  --into orders_r5
FROM orders_r2 AS X
LEFT JOIN orders_r4 AS Y
    ON X.order_id = Y.order_id
WHERE Y.order_id IS NULL;

SELECT * FROM orders_r5
--------------------------------------------------------------------------------------------------
-- Selects orders from orders_r5 where the difference between the total amount (MRP - Discount) 
-- and the payment value from the orderpayments table is less than 1  (8038-7715=323)

SELECT o.*  --INTO ORDERS_R6      --7715 ROWS
FROM orders_r5 AS o
INNER JOIN (
    SELECT Y.order_id 
    FROM (
        SELECT order_id, (SUM(MRP) - SUM(Discount)) AS tot 
        FROM ORDERS_R5
        GROUP BY order_id
    ) AS X
    INNER JOIN (
        SELECT order_id, SUM(payment_value) AS pay 
        FROM orderpayments
        GROUP BY order_id
    ) AS Y
    ON X.order_id = Y.order_id
    WHERE ABS(ROUND(X.tot, 0) - ROUND(Y.pay, 0)) < 1
) AS Z 
ON o.order_id = Z.order_id;

SELECT * FROM orders_r6
---------------------------------------------------------
--STEP2: Change the qty to 1 and recalculate the total amount(rows-7715)
UPDATE orders_r6
SET quantity = 1
WHERE quantity > 1     --4497 rows affected

Updated the total amount
update orders_r6
set Total_Amount=MRP-Discount;     --7715 rows affected

-----------------------------------------------------------------
--There are some duplicates in Orders_R6, so, aggregated the Qty and Total_Amount
SELECT Customer_id,	order_id,	product_id	,Channel ,Delivered_StoreID,Bill_date_timestamp, 
sum(Quantity) as Quantity,Cost_Per_Unit,MRP	,Discount, sum(Total_Amount) as Total_Amount  --INTO ORDERS_R7
FROM orders_r6
group by Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,Cost_Per_Unit,MRP,Discount     --7275

--Check:3.To chck for multiple stores
 ---updating storeIDs for instore and phone delivery channels.
WITH RankStore AS (
    SELECT 
        order_id,
        Delivered_StoreID,
        SUM(Total_Amount) AS TotalAmount,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY SUM(Total_Amount) DESC) AS rn
    FROM ORDERS_R7
    GROUP BY order_id,
        Delivered_StoreID
)
-- Step 2: Update the Orders table by replacing the StoreID
UPDATE O
SET O.Delivered_StoreID = R.Delivered_StoreID
FROM ORDERS_R7 as O
INNER JOIN RankStore as R
    ON O.order_id = R.order_id
WHERE R.rn = 1 AND CHANNEL IN ('instore','phone delivery') 

SELECT * FROM ORDERS_R7      --7275

----------------------------------------------
--Combine the tables
SELECT * --INTO OrdersFinal                     --102453 rows
FROM (
    SELECT * FROM ORDERS_R1
    UNION
    SELECT * FROM ORDERS_R4
    UNION
    SELECT * FROM ORDERS_R7
) AS TB
--------                                             
SELECT * from OrdersFinal

--------------------------------------------------------------------------------

---- Delete the records where year 2020
SELECT order_id from OrdersFinal
WHERE YEAR(Bill_date_timestamp) = 2020

DELETE FROM OrdersFinal
WHERE YEAR(Bill_date_timestamp) = 2020;
----------------------------------------------------
--Create columns profit and total cost

ALTER TABLE OrdersFinal
ADD Total_Cost DECIMAL(10, 2);

UPDATE OrdersFinal
SET Total_Cost = Quantity * Cost_Per_Unit;
-------
ALTER TABLE OrdersFinal
ADD Profit DECIMAL(10, 2);

UPDATE OrdersFinal
SET Profit = Total_Amount - Total_Cost;

------------------------------------------------------
SELECT SUM(Total_Amount) FROM ordersfinal

SELECT SUM(payment_value) FROM OrderPayments
WHERE order_id in (SELECT DISTINCT order_id FROM OrdersFinal)
---------------------------------------------------------------

SELECT COUNT(order_id) FROM ordersFinal      --102450 total rows

SELECT COUNT(DISTINCT order_id) FROM ordersFinal    --98393 distinct rows

