--data cleaning

-----------Customers table--------------------
--1. Change the datatype of column custid
ALTER TABLE Customers ADD Cust_id_text VARCHAR(50);
UPDATE Customers SET cust_id_text = CAST(Custid AS VARCHAR(50));
ALTER TABLE Customers DROP COLUMN Custid;
EXEC sp_rename 'Customers.cust_id_text', 'Custid', 'COLUMN';

--2. Remove the special characters from customer_city column
SELECT customer_city
FROM Customers
WHERE customer_city LIKE '%@%'

UPDATE Customers
SET customer_city = REPLACE(customer_city, '@', '')
WHERE customer_city LIKE '%@%'

select * from Customers

-------------------ProductInfo table--------------------------------------------
select Category from ProductsInfo
where Category like '#N/A'

--3. Replace the #N/A categories with Unknown
UPDATE ProductsInfo
SET Category = REPLACE(Category, '#N/A', 'Unknown')
WHERE Category LIKE '#N/A'

--4. fill the missing values with zero
UPDATE productsinfo
SET 
    product_name_lenght = 0,product_description_lenght = 0, product_photos_qty = 0, 
	product_weight_g = 0,product_length_cm = 0,product_height_cm = 0,product_width_cm = 0
WHERE 
    product_name_lenght IS NULL OR product_description_lenght IS NULL OR product_photos_qty IS NULL OR
	product_weight_g IS NULL OR product_length_cm IS NULL OR product_height_cm IS NULL OR product_width_cm IS NULL ;

select * from ProductsInfo

-----------------------StoresInfo Table-----------------------------------------------------------
SELECT StoreID,seller_city,seller_state, Region,COUNT(*) as Duplicate_Cnt
FROM StoresInfo
GROUP BY StoreID,seller_city,seller_state, Region
HAVING COUNT(*) > 1;

---5. Delete the duplicate record from storesInfo table
WITH CTE_Duplicates AS (
    SELECT  *,
        ROW_NUMBER() OVER (PARTITION BY StoreID, seller_city, seller_state, Region ORDER BY StoreID) AS RowNum
    FROM StoresInfo
)
DELETE FROM CTE_Duplicates
WHERE RowNum > 1;

--6. Remove the special characters from Seller_city column
SELECT seller_city
FROM StoresInfo
WHERE seller_city LIKE '%-%'

UPDATE StoresInfo
SET seller_city = REPLACE(seller_city, '-', '')
WHERE seller_city LIKE '%-%'

---------------------Order Review ratings Table----------------------------------

--7.Delete the duplicate records from Order Review ratings Table

---8. Same orderid having multiple customer satisfaction score
SELECT order_id, 
       AVG(Customer_Satisfaction_Score) AS Avg_Customer_Satisfaction_Score
INTO OrderReview_Aggregated
FROM OrderReview_Ratings
GROUP BY order_id;

DROP TABLE OrderReview_Ratings;
EXEC sp_rename 'OrderReview_Aggregated', 'OrderReview_Ratings';

select * from OrderReview_Ratings

-----------------------OrderPayments Table-------------------------------------------------

--10. Round off the paymentvalue till 2 decimal plcaes for better readability
UPDATE OrderPayments
SET payment_value = ROUND(payment_value, 2);

--11. solve the issue of payment value 0
select * from OrderPayments
where payment_value = 0

select * from OrderPayments  --103886 rows
SELECT 
    order_id, 
    SUM(payment_value) AS total_payment_value,
    COUNT(payment_type) AS total_payment_types
FROM orderpayments
GROUP BY order_id;                            --99440

select order_id,max(case when priority_number=1 then payment_type end) as payment_type,sum(payment_value) as payment_value 
into OrderPayments1
from (select *,ROW_NUMBER() over(partition by order_id order by payment_value desc) as priority_number 
	from (select * from OrderPayments
			where order_id in (select order_id from Ordersfinal)) as t) as tmp
	group by order_id                                                                      --98393 rows
