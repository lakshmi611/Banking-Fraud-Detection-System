USE Fraud_Detection_DB;

# A. Data Quality & Governance
# Q1. Total Transactions
SELECT COUNT(*) AS total_transactions
FROM fraud_transactions_raw;

# Q2. Duplicate Transactions
SELECT transaction_id,
COUNT(*) duplicate_count
FROM fraud_transactions_raw
GROUP BY transaction_id
HAVING COUNT(*) > 1;

# total duplicate rows
SELECT COUNT(*) - COUNT(DISTINCT transaction_id)
AS duplicate_records
FROM fraud_transactions_raw;

# Q3. Missing Values by Column
SELECT
ROUND(
(SUM(customer_city IS NULL OR customer_city='')*100.0)/COUNT(*),2
) AS customer_city_missing_pct,

ROUND(
(SUM(device_type IS NULL OR device_type='')*100.0)/COUNT(*),2
) AS device_type_missing_pct,

ROUND(
(SUM(merchant_name IS NULL OR merchant_name='')*100.0)/COUNT(*),2
) AS merchant_name_missing_pct,

ROUND(
(SUM(customer_age IS NULL)*100.0)/COUNT(*),2
) AS customer_age_missing_pct

FROM fraud_transactions_raw;

# Q4. What data entry errors exist?
SELECT
merchant_name,
COUNT(*)
FROM fraud_transactions_raw
GROUP BY merchant_name;

# Q5. How many invalid city-country combinations exist?

SELECT COUNT(*) invalid_records
FROM fraud_transactions_raw
WHERE customer_city IN
('Mumbai','Delhi','Hyderabad','Chennai')
AND customer_country <> 'India';

# B. Customer Analysis
# Q6. Unique Customers and Accounts
SELECT
COUNT(DISTINCT customer_id) customers,
COUNT(DISTINCT account_id) accounts
FROM fraud_transactions_clean;

# Q7. Customer Age Distribution
SELECT
CASE
WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
WHEN customer_age BETWEEN 46 AND 60 THEN '46-60'
ELSE '60+'
END age_group,
COUNT(*) customers
FROM fraud_transactions_clean
GROUP BY age_group;

# Q8. Transaction Volume by Customer Segment
SELECT
customer_segment,
COUNT(*) transactions,
SUM(transaction_amount) total_amount
FROM fraud_transactions_clean
GROUP BY customer_segment;

# Q9. Customers with Highest Account Balances
SELECT customer_id,
MAX(account_balance) balance
FROM fraud_transactions_clean
GROUP BY customer_id
ORDER BY balance DESC
LIMIT 10;

# Q10. Average Tenure by Segment
SELECT
customer_segment,
AVG(customer_tenure_months) avg_tenure
FROM fraud_transactions_clean
GROUP BY customer_segment;

# C. Transaction Analysis
# Q11. Total Transaction Value
SELECT
SUM(transaction_amount) total_transaction_value
FROM fraud_transactions_clean;

# Q12. Average Transaction Amount
SELECT
AVG(transaction_amount) avg_transaction_amount
FROM fraud_transactions_clean;

# Q13. Transaction Category Distribution
SELECT
transaction_category,
COUNT(*) transactions
FROM fraud_transactions_clean
GROUP BY transaction_category;

# Q14. Peak Transaction Hours
SELECT
HOUR(transaction_dt) transaction_hour,
COUNT(*) total_transactions
FROM fraud_transactions_clean
GROUP BY transaction_hour
ORDER BY total_transactions DESC;

# Q15. International Transaction Percentage
SELECT
ROUND(
SUM(is_international=1)*100/COUNT(*),2
) international_percentage
FROM fraud_transactions_clean;

# D. Payment Channel Analysis
# Q16. Most Used Payment Channel
SELECT
payment_channel,
COUNT(*) total_transactions
FROM fraud_transactions_clean
GROUP BY payment_channel
ORDER BY total_transactions DESC;

# Q17. Highest Transaction Value by Channel
SELECT
payment_channel,
SUM(transaction_amount) total_value
FROM fraud_transactions_clean
GROUP BY payment_channel
ORDER BY total_value DESC;

# Q18. Risk Score by Payment Channel
SELECT
payment_channel,
AVG(risk_score) avg_risk_score
FROM fraud_transactions_clean
GROUP BY payment_channel
ORDER BY avg_risk_score DESC;

# Q19. Average Transaction by Channel
SELECT
payment_channel,
AVG(transaction_amount) avg_amount
FROM fraud_transactions_clean
GROUP BY payment_channel;

# Q20. Failed Transactions by Channel
SELECT
payment_channel,
SUM(failed_transactions_last_24h) failed_transactions
FROM fraud_transactions_clean
GROUP BY payment_channel
ORDER BY failed_transactions DESC;

# E. Merchant Analysis
# Q21. Top Merchants by Transactions
SELECT
merchant_name,
COUNT(*) transactions
FROM fraud_transactions_clean
GROUP BY merchant_name
ORDER BY transactions DESC
LIMIT 10;

# Q22. Top Merchants by Revenue
SELECT
merchant_name,
SUM(transaction_amount) revenue
FROM fraud_transactions_clean
GROUP BY merchant_name
ORDER BY revenue DESC
LIMIT 10;

# Q23. Merchant Category Contribution
SELECT
merchant_category,
COUNT(*) transactions,
SUM(transaction_amount) revenue
FROM fraud_transactions_clean
GROUP BY merchant_category;

# Q24. Highest Average Transaction Merchant
SELECT
merchant_name,
AVG(transaction_amount) avg_amount
FROM fraud_transactions_clean
GROUP BY merchant_name
ORDER BY avg_amount DESC;

# Q25. Merchant Categories with High Risk
SELECT
merchant_category,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY merchant_category
ORDER BY avg_risk DESC;

# F. Device Analysis
# Q26. Device Usage Distribution
SELECT
device_type,
COUNT(*) transactions
FROM fraud_transactions_clean
GROUP BY device_type;

# Q27. New Device Usage %
SELECT
ROUND(
SUM(is_new_device=1)*100/COUNT(*),2
) new_device_percentage
FROM fraud_transactions_clean;

# Q28. Device-wise Transaction Value
SELECT
device_type,
SUM(transaction_amount) total_value
FROM fraud_transactions_clean
GROUP BY device_type;

# Q29. Risk Score by Device Type
SELECT
device_type,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY device_type
ORDER BY avg_risk DESC;

# Q30. Failed Transactions by Device
SELECT
device_type,
SUM(failed_transactions_last_24h) failed_transactions
FROM fraud_transactions_clean
GROUP BY device_type;

# G. Geographic Analysis
# Q31. Top Cities by Transactions
SELECT
customer_city,
COUNT(*) transactions
FROM fraud_transactions_clean
GROUP BY customer_city
ORDER BY transactions DESC
LIMIT 10;

# Q32. Top Countries by Transaction Value
SELECT
customer_country,
SUM(transaction_amount) total_value
FROM fraud_transactions_clean
GROUP BY customer_country
ORDER BY total_value DESC;

# Q33. Domestic vs International
SELECT
CASE
WHEN is_international=1 THEN 'International'
ELSE 'Domestic'
END transaction_type,
COUNT(*) transactions
FROM fraud_transactions_clean
GROUP BY transaction_type;

# Q34. Highest Average Transaction Cities
SELECT
customer_city,
AVG(transaction_amount) avg_amount
FROM fraud_transactions_clean
GROUP BY customer_city
ORDER BY avg_amount DESC;

# Q35. India vs International Comparison
SELECT
CASE
WHEN customer_country='India'
THEN 'India'
ELSE 'International'
END region,
COUNT(*) transactions,
AVG(transaction_amount) avg_amount
FROM fraud_transactions_clean
GROUP BY region;

# H. Fraud Risk & Behavioral Analysis
# Q36. Highest Risk Customers
SELECT
customer_id,
AVG(risk_score) risk_score
FROM fraud_transactions_clean
GROUP BY customer_id
ORDER BY risk_score DESC
LIMIT 20;

# Q37. Transaction Frequency vs Risk
SELECT
transactions_last_30d,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY transactions_last_30d
ORDER BY transactions_last_30d;

# Q38. Failed Transactions vs Risk
SELECT
failed_transactions_last_24h,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY failed_transactions_last_24h;

# Q39. International vs Domestic Risk
SELECT
CASE
WHEN is_international=1
THEN 'International'
ELSE 'Domestic'
END transaction_type,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY transaction_type;

# Q40. Highest Fraud-Risk Pattern
SELECT
merchant_category,
device_type,
payment_channel,
AVG(risk_score) avg_risk
FROM fraud_transactions_clean
GROUP BY merchant_category,
device_type,
payment_channel
ORDER BY avg_risk DESC
LIMIT 20;