# create database
CREATE DATABASE Fraud_Detection_DB;
USE Fraud_Detection_DB;

# create raw table
CREATE TABLE fraud_transactions_raw (
    transaction_id VARCHAR(50),
    customer_id VARCHAR(50),
    account_id VARCHAR(50),
    transaction_datetime VARCHAR(100),
    transaction_amount DECIMAL(15,2),
    merchant_name VARCHAR(100),
    merchant_category VARCHAR(100),
    payment_channel VARCHAR(50),
    device_type VARCHAR(50),
    device_id VARCHAR(100),
    ip_address VARCHAR(50),
    customer_age VARCHAR(20),
    customer_tenure_months INT,
    customer_city VARCHAR(100),
    customer_country VARCHAR(100),
    account_balance DECIMAL(15,2),
    failed_transactions_last_24h INT,
    transactions_last_24h INT,
    transactions_last_30d INT,
    avg_transaction_amount_30d DECIMAL(15,2),
    distance_from_home_km DECIMAL(15,2),
    is_international INT,
    is_new_device INT
);

# Preview data
SELECT *
FROM fraud_transactions_raw
LIMIT 10;

# Count total records
SELECT COUNT(*) AS Total_Rows
FROM fraud_transactions_raw;

# Count total columns
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='fraud_transactions_raw';

# create a backup table
CREATE TABLE transactions_clean AS
SELECT *
FROM fraud_transactions_raw;

# add primary key
ALTER TABLE transactions_clean
ADD COLUMN row_id INT AUTO_INCREMENT PRIMARY KEY;

# Duplicate Analysis
# Find duplicates:
SELECT transaction_id,
COUNT(*) duplicate_count
FROM transactions_clean
GROUP BY transaction_id
HAVING COUNT(*) > 1;

# remove duplicates
DELETE t1
FROM transactions_clean t1
INNER JOIN transactions_clean t2
ON t1.transaction_id = t2.transaction_id
AND t1.row_id > t2.row_id;

# standardize country names
UPDATE transactions_clean
SET customer_country='India'
WHERE customer_country IN
('Indai','INDIA','india','IND');

# standardize merchant names
UPDATE transactions_clean
SET merchant_name='Amazon'
WHERE merchant_name IN
('Amazn','AMAZON','amazon');

# standardize device names
UPDATE transactions_clean
SET device_type='Android'
WHERE device_type IN
('Andriod','ANDROID');

# missing value analysis
SELECT *
FROM transactions_clean
WHERE customer_age = ''
OR merchant_name = ''
OR customer_city = ''
OR device_type = '';

# Convert Blank Spaces to NULL 
# Numeric Columns 
UPDATE transactions_clean 
SET customer_age = NULL 
WHERE TRIM(customer_age) = ''; 

UPDATE transactions_clean 
SET account_balance = NULL 
WHERE TRIM(account_balance) = ''; 

UPDATE transactions_clean 
SET transaction_amount = NULL 
WHERE TRIM(transaction_amount) = '';

# Text columns 
UPDATE transactions_clean 
SET merchant_name = NULL 
WHERE TRIM(merchant_name) = ''; 

UPDATE transactions_clean 
SET customer_city = NULL 
WHERE TRIM(customer_city) = ''; 

UPDATE transactions_clean 
SET device_type = NULL 
WHERE TRIM(device_type) = ''; 

UPDATE transactions_clean 
SET payment_channel = NULL 
WHERE TRIM(payment_channel) = '';

# Replace Missing Numeric Values with median 
# Customer Age 
SET @median_age = 
( 
  SELECT AVG(customer_age) 
  FROM 
  ( 
    SELECT customer_age, 
        ROW_NUMBER() OVER (ORDER BY customer_age) AS rn, 
        COUNT(*) OVER () AS total_rows 
	FROM transactions_clean 
    WHERE customer_age IS NOT NULL 
  ) x 
  WHERE rn IN ( 
   FLOOR((total_rows + 1)/2), 
   FLOOR((total_rows + 2)/2) 
   ) 
);

UPDATE transactions_clean 
SET customer_age = ROUND(@median_age) 
WHERE customer_age IS NULL; 

# Replace Missing Categorical Values with Mode 
# Most Frequent device type 
SET @mode_device = 
( 
  SELECT device_type 
  FROM transactions_clean 
  WHERE device_type IS NOT NULL 
  GROUP BY device_type 
  ORDER BY COUNT(*) DESC 
  LIMIT 1 
); 

UPDATE transactions_clean 
SET device_type = @mode_device 
WHERE device_type IS NULL;

# Most Frequent Merchant 
SET @mode_merchant = 
( 
  SELECT merchant_name 
  FROM transactions_clean 
  WHERE merchant_name IS NOT NULL 
  GROUP BY merchant_name 
  ORDER BY COUNT(*) DESC 
  LIMIT 1 
); 

UPDATE transactions_clean 
SET merchant_name = @mode_merchant 
WHERE merchant_name IS NULL;

# Most Frequent City 
SET @mode_city = 
( 
  SELECT customer_city 
  FROM transactions_clean 
  WHERE customer_city IS NOT NULL 
  GROUP BY customer_city 
  ORDER BY COUNT(*) DESC 
  LIMIT 1 
); 

UPDATE transactions_clean 
SET customer_city = @mode_city 
WHERE customer_city IS NULL;

# Verify No Missing Values Remain 
SELECT 
SUM(customer_age IS NULL) AS missing_age, 
SUM(account_balance IS NULL) AS missing_balance, 
SUM(merchant_name IS NULL) AS missing_merchant, 
SUM(customer_city IS NULL) AS missing_city, 
SUM(device_type IS NULL) AS missing_device, 
SUM(payment_channel IS NULL) AS missing_channel 
FROM transactions_clean;

# detect negative values
SELECT *
FROM transactions_clean
WHERE transaction_amount < 0;

# Standardize Text Columns 
UPDATE transactions_clean 
SET merchant_name = TRIM(merchant_name); 

UPDATE transactions_clean 
SET customer_city = TRIM(customer_city); 

UPDATE transactions_clean 
SET payment_channel = TRIM(payment_channel);

# text formatting
UPDATE transactions_clean
SET merchant_name =
CONCAT(
UPPER(LEFT(merchant_name,1)),
LOWER(SUBSTRING(merchant_name,2))
);

# invalid age detection
SELECT *
FROM transactions_clean
WHERE customer_age < 18
OR customer_age > 100;

# Invalid tranasaction amounts
SELECT *
FROM fraud_transactions_raw
WHERE transaction_amount <= 0;

# country city validation
SELECT *
FROM fraud_transactions_raw
WHERE customer_city IN
('Mumbai','Delhi','Chennai','Kolkata')
AND customer_country <> 'India';

# Detect Extreme Transaction Outliers 
SELECT * 
FROM transactions_clean 
WHERE transaction_amount > 50000;

DESCRIBE transactions_clean;

SELECT
MIN(transaction_amount),
MAX(transaction_amount),
AVG(transaction_amount)
FROM fraud_transactions_raw;

# date time column
ALTER TABLE transactions_clean
ADD COLUMN transaction_date DATE,
ADD COLUMN transaction_time TIME;

SELECT transaction_datetime
FROM transactions_clean
LIMIT 10;

UPDATE transactions_clean
SET transaction_datetime =
DATE_FORMAT(
    STR_TO_DATE(transaction_datetime,'%Y-%m-%d %H:%i:%s.%f'),
    '%Y-%m-%d %H:%i:%s'
);

UPDATE transactions_clean
SET
transaction_date =
DATE(
    STR_TO_DATE(transaction_datetime,'%Y-%m-%d %H:%i:%s.%f')
),
transaction_time =
TIME(
    STR_TO_DATE(transaction_datetime,'%Y-%m-%d %H:%i:%s.%f')
);

ALTER TABLE transactions_clean
ADD COLUMN transaction_dt DATETIME;

UPDATE transactions_clean
SET transaction_dt =
STR_TO_DATE(
    transaction_datetime,
    '%Y-%m-%d %H:%i:%s.%f'
);

UPDATE transactions_clean
SET
transaction_date = DATE(transaction_dt),
transaction_time = TIME(transaction_dt);

SELECT
transaction_datetime,
transaction_dt,
transaction_date,
transaction_time
FROM transactions_clean
LIMIT 10;

# day of week
ALTER TABLE transactions_clean
ADD COLUMN day_name VARCHAR(20);

UPDATE transactions_clean
SET day_name = DAYNAME(transaction_date);

# month name
ALTER TABLE transactions_clean
ADD COLUMN month_name VARCHAR(20);

UPDATE transactions_clean
SET month_name = MONTHNAME(transaction_date);

# year
ALTER TABLE transactions_clean
ADD COLUMN transaction_year INT;

UPDATE transactions_clean
SET transaction_year = YEAR(transaction_date);

# weekend flag
ALTER TABLE transactions_clean
ADD COLUMN is_weekend TINYINT;

UPDATE transactions_clean
SET is_weekend =
CASE
    WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 1
    ELSE 0
END;

# time bucket
ALTER TABLE transactions_clean
ADD COLUMN transaction_period VARCHAR(20);

UPDATE transactions_clean
SET transaction_period =
CASE
    WHEN HOUR(transaction_time) BETWEEN 0 AND 5 THEN 'Night'
    WHEN HOUR(transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;

# create risk score
ALTER TABLE transactions_clean
ADD COLUMN risk_score DECIMAL(10,2);

UPDATE transactions_clean
SET risk_score =
(
failed_transactions_last_24h*10 +
transactions_last_24h*2 +
is_international*20 +
is_new_device*15
);

# create customer segment
ALTER TABLE transactions_clean
ADD COLUMN customer_segment VARCHAR(20);

UPDATE transactions_clean
SET customer_segment =
CASE
WHEN account_balance >= 1000000 THEN 'Premium'
WHEN account_balance >= 250000 THEN 'Gold'
ELSE 'Regular'
END;

# create transaction size category
ALTER TABLE transactions_clean
ADD COLUMN transaction_category VARCHAR(20);

UPDATE transactions_clean
SET transaction_category =
CASE
WHEN transaction_amount < 1000 THEN 'Low'
WHEN transaction_amount < 10000 THEN 'Medium'
ELSE 'High'
END;

# create fraud flags
ALTER TABLE transactions_clean
ADD COLUMN fraud_flag VARCHAR(20);

UPDATE transactions_clean
SET fraud_flag =
CASE
WHEN risk_score > 50 THEN 'High Risk'
WHEN risk_score > 25 THEN 'Medium Risk'
ELSE 'Low Risk'
END;

# index creation
CREATE INDEX idx_customer
ON transactions_clean(customer_id);

CREATE INDEX idx_transaction
ON transactions_clean(transaction_id);

CREATE INDEX idx_country
ON transactions_clean(customer_country);

CREATE INDEX idx_merchant
ON transactions_clean(merchant_name);

# clean final table
CREATE TABLE fraud_transactions_clean AS
SELECT *
FROM transactions_clean;

# data quality validation
SELECT COUNT(*)
FROM fraud_transactions_clean;

# create audit log table
CREATE TABLE cleaning_audit (
audit_id INT AUTO_INCREMENT PRIMARY KEY,
step_name VARCHAR(200),
records_affected INT,
execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM fraud_transactions_clean;