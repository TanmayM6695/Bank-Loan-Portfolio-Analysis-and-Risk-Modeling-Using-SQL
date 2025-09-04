📊 Banking Loan Portfolio Analytics using SQL

📌 Project Overview

This project focuses on analyzing a real-world banking loan portfolio using SQL to uncover insights into loan origination, credit risk, borrower profiles, repayment behaviors, and data anomalies. Additionally, it includes feature engineering to prepare datasets for machine learning models that predict loan defaults.
By building Key Performance Indicators (KPIs) and SQL workflows, the project demonstrates strong capabilities in data analysis, business problem-solving, and SQL expertise, highly relevant for consulting, data science, and financial analytics roles.

🎯Objectives

•	Understand loan origination trends and repayment behaviors.

•	Identify risk factors and anomalies in borrower profiles.

•	Build SQL-driven KPIs for portfolio health monitoring.

•	Engineer ML-ready features (credit age, funded ratio, utilization flags) for predictive modeling.

•	Ensure data quality through anomaly detection and validation.

🧑‍💻 Role & Contributions

•	Designed and executed SQL KPIs across 8 categories (origination, risk, borrower profile, repayment, anomalies, ML features).

•	Implemented advanced SQL techniques (joins, window functions, CTEs, temp tables, CASE logic).

•	Built anomaly detection scripts (outliers, missing values, overfunded loans).

•	Engineered ML-ready features to support downstream credit risk models.

•	Delivered business-ready insights for underwriting, collections, and investor confidence.


📊 Key Features (Grouped KPIs)

1.	Loan Origination Metrics
   
•	Year-wise loan disbursement trends

•	State-wise average loan amounts

•	Purpose and term-wise loan distributions

2.	Credit Risk KPIs
   
•	Grade & Sub-grade-wise funded amounts

•	Verification status vs repayments

•	DTI bucket distributions

•	Funded-to-requested loan ratios


3.	Borrower Profile Analytics
   
•	Income vs loan trends

•	Home ownership vs repayment behavior

•	Employment length vs default probability

4.	Repayment & Collection KPIs
   
•	Recovery rates by loan status

•	Payment-to-loan ratios

•	Delinquency vs borrower profile analysis

5.	Anomaly & Data Quality Checks
   
•	Outlier detection in interest rates (>30%, <5%)

•	Missing values (income, credit history)

•	Overfunded/zero-funded loans

•	Utilization >100% flags

6.	Feature Engineering for ML
   
•	Credit age in months

•	High utilization binary flag (>80%)

•	Funded ratio (funded/loan requested)

•	EMI-to-income ratio


How to Use

Clone the repository:

bash

git clone https://github.com/TanmayM6695/Bank-Loan-Portfolio-Analysis-and-Risk-Modeling-Using-SQL.git

Import Data:

Load finance_1.csv and finance_2.csv into your SQL database.

Run SQL Scripts:

Execute individual SQL scripts from the scripts/ folder within your analytics environment (MySQL, PostgreSQL, etc.).

Customize KPIs:

Modify script parameters to suit your institution's specific reporting needs or risk criteria.


