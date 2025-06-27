--EDA Steps for Customer Table

Use [Retail Anaysis]

SELECT table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE';


Select * FROM Customers

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'Customers';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM Customers;

--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers';

-- checking missing values
SELECT 'Custid' AS Column_Name, COUNT(*) AS Null_Count FROM Customers WHERE Custid IS NULL
UNION ALL
SELECT 'customer_city' AS Column_Name, COUNT(*) AS Null_Count FROM Customers WHERE customer_city IS NULL
UNION ALL
SELECT 'customer_state' AS Column_Name, COUNT(*) AS Null_Count FROM Customers WHERE customer_state IS NULL
UNION ALL
SELECT 'Gender' AS Column_Name, COUNT(*) AS Null_Count FROM Customers WHERE Gender IS NULL

--Identify Duplicate Records
SELECT Custid,customer_city,customer_state,Gender, COUNT(*) as Duplicate_Cnt
FROM Customers
GROUP BY Custid,customer_city,customer_state,Gender
HAVING COUNT(*) > 1;

--Table Orders

--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'Orders';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM Orders;

--checking missing values
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name, COUNT(*) AS Null_Count ' +
    'FROM Orders WHERE [' + COLUMN_NAME + '] IS NULL', 
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

EXEC(@sql);

----Identify Duplicate Records
SELECT Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount, COUNT(*) as Duplicate_Cnt
FROM Orders
GROUP BY Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount
HAVING COUNT(*) > 1;

--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM Orders;

--Table3: OrderPayments

--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'Orders';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM Orders;

--checking missing values
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name, COUNT(*) AS Null_Count ' +
    'FROM Orders WHERE [' + COLUMN_NAME + '] IS NULL', 
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

EXEC(@sql);

----Identify Duplicate Records
SELECT Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount, COUNT(*) as Duplicate_Cnt
FROM Orders
GROUP BY Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount
HAVING COUNT(*) > 1;

SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(
        Customer_id, order_id, product_id, Channel, Delivered_StoreID, 
        Bill_date_timestamp, Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount
    )) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(
        Customer_id, order_id, product_id, Channel, Delivered_StoreID, 
        Bill_date_timestamp, Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount
    )) AS Duplicate_Records
FROM Orders;

--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM Orders;

--Table4: OrderPayments

--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'Orders';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM Orders;

--checking missing values
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name, COUNT(*) AS Null_Count ' +
    'FROM Orders WHERE [' + COLUMN_NAME + '] IS NULL', 
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

EXEC(@sql);

----Identify Duplicate Records
SELECT Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount, COUNT(*) as Duplicate_Cnt
FROM Orders
GROUP BY Customer_id,order_id,product_id,Channel,Delivered_StoreID,Bill_date_timestamp,
Quantity,Cost_Per_Unit,MRP,	Discount,Total_Amount
HAVING COUNT(*) > 1;

SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(
        Customer_id, order_id, product_id, Channel, Delivered_StoreID, 
        Bill_date_timestamp, Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount
    )) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(
        Customer_id, order_id, product_id, Channel, Delivered_StoreID, 
        Bill_date_timestamp, Quantity, Cost_Per_Unit, MRP, Discount, Total_Amount
    )) AS Duplicate_Records
FROM Orders;


--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM Orders;

--Table3: OrderPayments
--Understanding the structure, datatype of the Customers table
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OrderPayments';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'OrderPayments';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM OrderPayments;

--checking missing values
SELECT 'order_id' AS Column_Name, COUNT(*) AS Null_Count FROM OrderPayments WHERE order_id IS NULL
UNION ALL
SELECT 'payment_type' AS Column_Name, COUNT(*) AS Null_Count FROM OrderPayments WHERE payment_type IS NULL
UNION ALL
SELECT 'payment_value' AS Column_Name, COUNT(*) AS Null_Count FROM OrderPayments WHERE payment_value IS NULL

----Identify Duplicate Records
SELECT order_id,payment_type,payment_value, COUNT(*) as Duplicate_Cnt
FROM OrderPayments
GROUP BY order_id,payment_type,payment_value
HAVING COUNT(*) > 1;

--At overall level
SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(order_id, payment_type, payment_value)) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, payment_type, payment_value)) AS Duplicate_Records
FROM OrderPayments;


--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OrderPayments';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM OrderPayments;

--Table5:OrderReview_Ratings

--Understanding the structure, datatype of the Customers table
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OrderReview_Ratings';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'OrderReview_Ratings';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM OrderReview_Ratings;

--checking missing values
SELECT 'order_id' AS Column_Name, COUNT(*) AS Null_Count FROM OrderReview_Ratings WHERE order_id IS NULL
UNION ALL
SELECT 'Customer_Satisfaction_Score' AS Column_Name, COUNT(*) AS Null_Count FROM OrderReview_Ratings
WHERE Customer_Satisfaction_Score IS NULL


----Identify Duplicate Records
SELECT order_id,Customer_Satisfaction_Score, COUNT(*) as Duplicate_Cnt
FROM OrderReview_Ratings
GROUP BY order_id,Customer_Satisfaction_Score
HAVING COUNT(*) > 1;

--At overall level
SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(order_id, Customer_Satisfaction_Score)) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(order_id, Customer_Satisfaction_Score)) AS Duplicate_Records
FROM OrderReview_Ratings;


--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OrderReview_Ratings';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM OrderReview_Ratings;

--Table4:ProductsInfo

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductsInfo';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'ProductsInfo';
-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM ProductsInfo;

--checking missing values
DECLARE @sql NVARCHAR(MAX);

-- Create dynamic SQL for NULL count checking
SELECT @sql = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name, COUNT(*) AS Null_Count ' +
    'FROM ProductsInfo WHERE [' + COLUMN_NAME + '] IS NULL', 
    ' UNION ALL '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductsInfo';

-- Execute the dynamic SQL
EXEC(@sql);


----Identify Duplicate Records
SELECT product_id,Category,product_name_lenght,product_description_lenght,
product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm
, COUNT(*) as Duplicate_Cnt
FROM ProductsInfo
GROUP BY product_id,Category,product_name_lenght,product_description_lenght,
product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm
HAVING COUNT(*) > 1;

--At overall level
SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(
        product_id, Category, product_name_lenght, product_description_lenght, 
        product_photos_qty, product_weight_g, product_length_cm, 
        product_height_cm, product_width_cm
    )) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(
        product_id, Category, product_name_lenght, product_description_lenght, 
        product_photos_qty, product_weight_g, product_length_cm, 
        product_height_cm, product_width_cm
    )) AS Duplicate_Records
FROM ProductsInfo;


--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductsInfo';

--Verify Data Ranges and Outliers
SELECT MIN(Total_Amount) AS Min_Value, MAX(Total_Amount) AS Max_Value, 
AVG(Total_Amount) AS Avg_Value
FROM ProductsInfo;

--Table6: Stores Info
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StoresInfo';

-- So the below query gives us the number of columns in the dataset.
SELECT COUNT(*) AS TotalColumns FROM information_schema.columns
WHERE table_name = 'StoresInfo';

-- Count the number of rows.
SELECT COUNT(*) AS TotalRows FROM StoresInfo;

--checking missing values
SELECT 'StoreID' AS Column_Name, COUNT(*) AS Null_Count FROM StoresInfo WHERE StoreID IS NULL
UNION ALL
SELECT 'seller_city' AS Column_Name, COUNT(*) AS Null_Count FROM StoresInfo WHERE seller_city IS NULL
UNION ALL
SELECT 'seller_state' AS Column_Name, COUNT(*) AS Null_Count FROM StoresInfo WHERE seller_state IS NULL
UNION ALL
SELECT 'Region' AS Column_Name, COUNT(*) AS Null_Count FROM StoresInfo WHERE Region IS NULL


----Identify Duplicate Records
SELECT StoreID,seller_city,seller_state, Region,COUNT(*) as Duplicate_Cnt
FROM StoresInfo
GROUP BY StoreID,seller_city,seller_state, Region
HAVING COUNT(*) > 1;

--At overall llevel
SELECT 
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT CONCAT(StoreID, seller_city, seller_state, Region)) AS Unique_Records,
    COUNT(*) - COUNT(DISTINCT CONCAT(StoreID, seller_city, seller_state, Region)) AS Duplicate_Records
FROM StoresInfo;


--Check Column Name
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StoresInfo';

















