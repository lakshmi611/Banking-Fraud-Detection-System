# 🛡️ Banking Fraud Detection Analytics Project

## 📌 Project Overview

This project demonstrates an **end-to-end Banking Fraud Detection Analytics solution** using **MySQL, Power BI, and Python**. The primary objective is to transform raw banking transaction data into meaningful business insights that help detect suspicious activities, improve fraud monitoring, and support data-driven decision-making.

The project follows a complete analytics workflow—from data cleaning and transformation to dashboard development and advanced analytical insights.

---

# 🎯 Objectives

* Clean and standardize raw banking transaction data.
* Identify and resolve data quality issues.
* Analyze customer, transaction, merchant, device, and geographic behavior.
* Detect fraud patterns and high-risk transactions.
* Build interactive dashboards for business users.
* Generate actionable business insights and recommendations.
* Demonstrate an end-to-end Data Analytics workflow using industry-standard tools.

---

# 🛠️ Tech Stack

| Tool            | Purpose                                                                  |
| --------------- | ------------------------------------------------------------------------ |
| **MySQL**       | Database creation, data cleaning, SQL analysis                           |
| **Power BI**    | Interactive dashboards and business intelligence                         |
| **Python**      | Exploratory Data Analysis (EDA), statistical analysis, business insights |
| **Excel / CSV** | Dataset storage and import                                               |

---

# 📂 Project Workflow

```text
Raw Banking Dataset
        │
        ▼
MySQL
(Database Creation)
        │
        ▼
Data Cleaning
(Duplicates, Missing Values,
Standardization, Validation)
        │
        ▼
Business SQL Queries
(40 Business Questions)
        │
        ▼
Power BI Dashboards
        │
        ▼
Python Analysis
(EDA & Statistical Insights)
        │
        ▼
Business Recommendations
```

---

# 📊 Dataset Overview

The dataset contains realistic banking transaction records with customer, merchant, device, payment, and fraud-related information.

### Features Include

* Transaction ID
* Customer ID
* Account ID
* Transaction Date & Time
* Transaction Amount
* Merchant Name
* Merchant Category
* Payment Channel
* Device Type
* Device ID
* IP Address
* Customer Age
* Customer Tenure
* Customer City
* Customer Country
* Account Balance
* Failed Transactions
* Transaction Frequency
* Average Transaction Amount
* Distance from Home
* International Transaction Flag
* New Device Flag

---

# 🧹 Data Cleaning (MySQL)

The raw dataset intentionally contained common real-world data quality issues.

### Cleaning Activities

* Database creation
* Backup table creation
* Primary key implementation
* Duplicate detection and removal
* Missing value analysis
* Blank value handling
* Data entry error correction
* Merchant name standardization
* Device name standardization
* Country validation
* City-country consistency checks
* Invalid data correction
* Outlier detection
* Derived column creation
* Risk Score calculation
* Customer Segment creation
* Transaction Category creation
* Index creation for query optimization

---

# 📈 Business Analysis

More than **40 business questions** were answered using SQL under the following categories:

* Data Quality & Governance
* Customer Analysis
* Transaction Analysis
* Payment Channel Analysis
* Merchant Analysis
* Device Analysis
* Geographic Analysis
* Fraud Risk Analysis

---

# 📊 Power BI Dashboards

The project includes three interactive dashboards.

## 1️⃣ Executive Overview

Provides a high-level overview of business performance.

### KPIs

* Total Transactions
* Total Customers
* Total Transaction Value
* Average Transaction Amount

### Visuals

* Monthly Trend
* Customer Segments
* Top Merchants
* Geographic Distribution
* Payment Channel Analysis

---

## 2️⃣ Device & Customer Analysis

Focuses on customer behavior and transaction patterns.

### Visuals

* Customer Age Distribution
* Customer Segments
* Device Usage
* Payment Channels
* Peak Transaction Hours
* Merchant Categories

---

## 3️⃣ Fraud Risk & Investigation Dashboard

Designed for fraud analysts.

### Visuals

* Risk Score Distribution
* High-Risk Customers
* Fraud Heat Matrix
* Risk by Device
* Risk by Merchant
* Investigation Table
* Drill-through Transaction Details
* Geographic Fraud Analysis

---

# 🐍 Python Analysis

Python complements SQL and Power BI by performing advanced analytics.

## Step 1

Data Loading & Validation

* Import cleaned dataset
* Dataset information
* Summary statistics
* Missing value verification

---

## Step 2

Exploratory Data Analysis

* Distribution Analysis
* Correlation Analysis
* Outlier Detection

---

## Step 3

Customer & Transaction Analysis

* Customer Spending
* Merchant Analysis
* Payment Channel Analysis
* Transaction Trends

---

## Step 4

Fraud Risk Analysis

* Risk Score Distribution
* High-Risk Customers
* Device Risk
* International Transaction Analysis

---

## Step 5

Business Insights & Recommendations

* Statistical Analysis
* Fraud Indicators
* Final Recommendations

---

# 📌 Key Findings

### Customer Insights

* Premium and Gold customers contribute the highest transaction value.
* Long-tenure customers exhibit more stable transaction behavior.

### Transaction Insights

* Medium-value transactions dominate the portfolio.
* Peak transaction activity occurs during evening hours.
* Digital payment methods are most frequently used.

### Fraud Insights

* International transactions carry higher fraud risk.
* New devices are associated with higher risk scores.
* Repeated failed transactions are strong fraud indicators.
* High-value transactions require enhanced monitoring.

### Merchant Insights

* A small number of merchants generate a large share of revenue.
* Travel and E-commerce merchants exhibit relatively higher fraud risk.

---

# 💡 Business Recommendations

## Data Quality

* Implement automated validation rules.
* Maintain standardized reference tables.
* Schedule regular data quality audits.

---

## Fraud Prevention

* Risk-based authentication
* Multi-factor authentication
* New device verification
* International transaction monitoring
* Fraud alert automation

---

## Customer Management

* Customer risk profiling
* Premium customer protection
* Fraud awareness programs

---

## Merchant Monitoring

* Merchant-specific fraud thresholds
* Continuous monitoring of high-value merchants

---

## Device Security

* Device fingerprinting
* Device behavior monitoring
* New device verification

---

# 📁 Project Structure

```text
Banking-Fraud-Detection/
│
├── Dataset/
│   ├── fraud_transactions_raw.csv
│   ├── fraud_transactions_clean.csv
│
├── SQL/
│   ├── Database_Creation.sql
│   ├── Data_Cleaning.sql
│   ├── Business_Queries.sql
│
├── PowerBI/
│   ├── Banking_Fraud_Dashboard.pbix
│
├── Python/
│   ├── Fraud_Analysis.ipynb
│
├── Documentation/
│   ├── Business_Questions.docx
│   ├── Dashboard_Insights.docx
│   ├── Final_Report.docx
│
└── README.md
```

---

# 🚀 Skills Demonstrated

* SQL Database Design
* Data Cleaning & Transformation
* Data Validation
* Exploratory Data Analysis (EDA)
* Business Intelligence
* Dashboard Development
* DAX Calculations
* Data Visualization
* Statistical Analysis
* Fraud Risk Analytics
* Business Recommendation Development

---

# 📚 Future Enhancements

* Develop a machine learning model for fraud prediction.
* Implement anomaly detection using Isolation Forest or Local Outlier Factor.
* Build a real-time fraud monitoring pipeline.
* Integrate streaming transaction data.
* Deploy dashboards with automated refresh schedules.
* Implement automated fraud alert notifications.

---

# 👩‍💻 Author

**Lakshmi T**

**Project:** Banking Fraud Detection Analytics

**Tools Used:** MySQL | Power BI | Python

---

# ⭐ Project Summary

This project showcases a complete **Banking Fraud Detection Analytics** workflow by integrating **MySQL for data preparation, Power BI for interactive dashboards, and Python for advanced analytics**. The solution transforms raw banking transaction data into actionable insights that help identify fraud risks, improve customer monitoring, enhance operational efficiency, and support strategic decision-making. It demonstrates practical skills in data cleaning, SQL querying, business intelligence, statistical analysis, and fraud analytics, making it a strong portfolio project for Data Analyst roles.
