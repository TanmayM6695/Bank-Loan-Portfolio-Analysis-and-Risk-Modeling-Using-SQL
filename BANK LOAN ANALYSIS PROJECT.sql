SELECT * FROM finance_1;
select * FROM finance_2;

/* GROUPED CATEGORIES OF KPIs:
1) LOAN ORIGINATION METRICS
2) CREDIT RISK KPIs
3) REPAYMENT BEHAVIOUR METRICS
4) BORROWER PROFILE ANALYSIS
5) RECOVERY AND DEFAULT RISK
6) ANOMALY AND DATA QUALITY CHECKS
7) FEATURE ENGINEERING ML READY */


# 1) LOAN ORIGINATION METRICS: It helps to understand trends in disbursed loans by amount, term, state, and borrower purpose.

-- **Year-wise-loan-amount**: 
SELECT YEAR(issue_d) AS year, SUM(loan_amnt) AS total_disbursed FROM Finance_1 GROUP BY year;

/*
1) Tracks the total amount of loans issued each year.
2) Business Use:
> See if the company is scaling lending year-over-year
> Track loan policy effectiveness (e.g., post-regulation changes)
> Detect macro trends like economic growth or downturns*/

-- **Purpose-wise Loan Volume and Value**:
SELECT purpose, COUNT(*) AS loan_count, concat("$", format( round(sum(loan_amnt)/1000000,2),2),"M") AS total_value FROM Finance_1 GROUP BY purpose; 

/* 
1) Displays the count and total disbursed amount for each loan purpose (e.g., debt consolidation, home improvement, education).
2)  Business Use:
> Understand borrower intent
> Design targeted loan products (e.g., low-interest for education)
> Spot high-risk purposes (e.g., small business during recessions)*/

-- **State-wise Average Loan Amount**:
SELECT addr_state, ROUND(AVG(loan_amnt), 2) AS avg_loan FROM Finance_1 GROUP BY addr_state;

/*
1) Shows average loan amount per state, giving a regional lending profile.
2) Business Use:
> Gauge affordability and demand per state
> Detect underserved or overexposed geographies
> Adjust marketing or risk models based on state performance*/

-- **Term-wise Loan Count**:
SELECT term, COUNT(*) AS count FROM Finance_1 GROUP BY term;

/*
1) Breaks down loans issued by loan term
2) Business Use:
> Understand borrower preferences for repayment length
> Predict cash inflow and interest earnings
> Spot shifts */


# 2) CREDIT RISK KPIs- 
# The objective is to measure and segment loan risk based on key borrower attributes like credit grades, income verification, and debt burden (DTI).
# These metrics help banks optimize credit policy, risk exposure, and loss mitigation.

-- **Grade & Sub-grade Funded Amount**:
SELECT grade, sub_grade, concat("$", format( round(sum(funded_amnt)/1000000,2),2),"M") AS total_funded FROM Finance_1 GROUP BY grade, sub_grade;

/*
1) Total amount of funds disbursed across different credit grades and subgrades (A1 to G5)
2)  Business Use:
> Measures the risk-reward balance of the loan book
> Grade A = Low risk, low return | Grade G = High risk, high return
> Helps regulators and credit teams balance portfolio risk*/

-- Verification Status vs Total Payment
SELECT verification_status,  concat("$", format( round(sum(total_pymnt)/1000000,2),2),"M") AS total_payment
FROM Finance_1  JOIN Finance_2 ON finance_1.id = finance_2.id
GROUP BY verification_status;

/*
1) Compares total repayment performance between: a) Verified Income, b) Source Verified and c) Not Verified
2)  Business Use:
> Test if verification reduces default risk
> Useful for improving underwriting strategies
> May show that verified borrowers repay more consistently*/

-- **DTI Bucket Distribution**:
SELECT
  CASE
    WHEN dti <= 10 THEN '0-10'
    WHEN dti <= 20 THEN '11-20'
    WHEN dti <= 30 THEN '21-30'
    ELSE '31+'
  END AS dti_bucket, COUNT(*) AS count FROM Finance_1 GROUP BY dti_bucket;
  
/* 
1) DTI (Debt-to-Income) = Monthly debt obligations ÷ Monthly income
2) It shows how many borrowers fall in DTI risk bands: 0–10%, 11–20%, 21–30%, and 31%+
3) Business Use:
> Helps segment financial stress across customers
> High DTI → lower repayment capacity → higher credit risk
> Can be used to flag risky applications or tighten lending policy*/

-- **Funded-to-Requested Ratio**:
SELECT id, ROUND(funded_amnt / loan_amnt, 2) AS funding_ratio  FROM Finance_1;

/* 
1) Funded Ratio = Funded Amount / Requested Loan Amount
2) How much of the requested loan was actually funded. Values: ~1.0 → Fully funded , <1.0 → Partially funded, >1.0 → Data anomaly or overfunding
3)  Business Use:
> Shows how confident the institution is in a borrower
> High ratio = strong creditworthiness
> Low ratio = partial approval due to risk concerns
> Can also flag data issues if ratio > 1  */


# 3) REPAYMENT BEHAVIOR METRICS: The objective is to To analyze how borrowers are repaying loans over time, including:
# a) Trends in total repayments
# b) Recovery from late payments
# c) Overall balance behavior

-- Total Payment Trend by Year
SELECT YEAR(last_pymnt_d) AS year, concat("$", format( round(sum(total_pymnt)/1000000,2),2),"M") AS total_paid FROM Finance_2  GROUP BY year;

/* 
1) It shows how much total payment (principal + interest) has been collected from borrowers in each year.
2) Business Use:
> Tracks cash inflow performance over time
> Detects drop-off years (e.g., due to economic crises)
> Useful for investor confidence & quarterly earnings analysis */

-- Late Fee & Recovery Ratio by Subgrade
SELECT sub_grade, concat("$", format( round(sum(recoveries)/1000,2),2),'K') AS total_recoveries ,sum(total_rec_late_fee) AS total_late_fees
FROM Finance_1 JOIN Finance_2  ON finance_1.id = finance_2.id GROUP BY sub_grade;

/* 
1) It shows aggregates late fees charged and amounts recovered from charged-off accounts, grouped by credit subgrade.
2) Business Use:
> Measures effectiveness of collections team
> Identifies subgrades with poor repayment behavior
> Helps price risk better via adjusted interest rates  */

-- Revolving Balance Distribution
SELECT grade , ROUND(AVG(CAST(revol_bal AS DECIMAL)), 2) AS avg_revol_bal
FROM Finance_1  JOIN Finance_2  ON finance_1.id = finance_2.id GROUP BY grade;

/* 
1) The unpaid credit card style balance that the borrower is carrying is the Revolving Balance
2) Business Use:
> Indicates ongoing credit burden of different borrower segments
> Grades with high balances may default more easily
> Helps underwriters decide how much more credit to offer*/


# 4) BORROWER PROFILE ANALYTICS: The objective is to analyze borrower characteristics such as income, home ownership, and employment length, and relate them to loan behavior and risk.
# These KPIs help banks to: 
# a) Optimize customer segmentation
# b) Personalize loan products and offers
# c) Refine credit scoring models based on profile-based performance

-- **Home Ownership vs Loan Status**
SELECT home_ownership, loan_status, COUNT(*) AS count FROM Finance_1 GROUP BY home_ownership, loan_status;

/*
1) It shows a cross-tab of how borrowers with different home ownership statuses (MORTGAGE, RENT, OWN) are distributed across loan statuses
2) Business Use: 
> Homeowners tend to have more financial stability
> Renters may pose slightly higher default risk
> Helps target underwriting and interest-rate adjustments */ 

-- **Employment Length vs Funded Amount**
SELECT emp_length, ROUND(AVG(funded_amnt), 2) AS avg_funding FROM Finance_1 GROUP BY emp_length;

/* 
1) It shows the average funded amount across different employment lengths
2)  Business Use:
> More stable employment = higher income and lower risk
> Helps adjust funding decisions and approval limits*/

-- **Annual Income vs Installment**
SELECT
  CASE
    WHEN annual_inc <= 50000 THEN '<50K'
    WHEN annual_inc <= 100000 THEN '50K-1L'
    ELSE '1L+'
  END AS income_group, ROUND(AVG(installment), 2) AS avg_installment FROM Finance_1 GROUP BY income_group;
  
  /* 
1) The average monthly installment grouped by annual income buckets
2) Business Use:
> Higher income = more capacity for higher EMIs
> Helps define loan caps and EMI structuring per income */

-- **Ownership Category Repayment Performance**
SELECT home_ownership, ROUND(AVG(total_pymnt), 2) AS avg_payment
FROM Finance_1  JOIN Finance_2  ON finance_1.id = finance_2.id GROUP BY home_ownership;

/* 
1) It shows the average total repayment (or payment-to-loan ratio) by home ownership status.
2) Business Use:
> Highlights which borrower group tends to repay more completely
> May indicate which categories are underperforming despite high loan issuance*/


# 5) RECOVERY AND DFAULT RISK: The objective is to evaluate borrower defaults, recovery efforts, and delinquency patterns — helping banks minimize losses and optimize recovery actions.
#These KPIs guide:
# a) Risk provisioning (how much loss to expect)
# b) Collections and recovery strategies
# c) Underwriting policy changes for high-default segments

-- **Recovery Fees by Loan Purpose**
SELECT purpose, CASE WHEN RANK() OVER (ORDER BY SUM(recoveries) DESC) = 1 
THEN CONCAT("$", FORMAT(ROUND(SUM(recoveries)/1000000, 2), 2), "M")
ELSE CONCAT("$", FORMAT(ROUND(SUM(recoveries)/1000, 2), 2), "K") END AS total_recovered FROM Finance_1  JOIN Finance_2  ON finance_1.id = finance_2.id GROUP BY purpose;

/* 
1)  It shows total recoveries grouped by loan purpose (e.g., debt consolidation, home improvement, small business)
2) Business Use:
> Identifies which loan purposes result in the most recoverable defaults
> Helps collections teams prioritize recovery resources
> Informs product design — maybe avoid loans with poor recovery rate*/

-- **Default Rate by Grade**
SELECT grade, COUNT(CASE WHEN loan_status = 'Charged Off' THEN 1 END) / COUNT(*) AS default_rate FROM Finance_1 GROUP BY grade;

/*
1) It describes proportion of charged-off (defaulted) loans over total loans, grouped by credit grade (A–G)
2) Business Use:
> Essential for credit risk models
> Helps optimize risk-based pricing (higher interest for high-risk grades)
> Assists in grade reclassification or cutoff tuning*/ 

-- **Last Credit Pull Trend vs Loan Status**
SELECT DATE_FORMAT(last_credit_pull_d, '%Y-%m') AS month, loan_status, COUNT(*) AS count
FROM Finance_2  JOIN Finance_1  ON finance_1.id = finance_2.id GROUP BY month, loan_status;

/*
1) It tracks when the borrower's credit was last pulled and compares it with current loan status (Current, Charged-Off, etc.)
2) Business Use:
> Helps identify stale credit checks or inactivity
> Can detect sudden transitions from “Current” to “Default”
> May highlight accounts for early intervention */

-- **Delinquency Buckets**
SELECT
  CASE
    WHEN delinq_2yrs = 0 THEN 'No Delinq'
    WHEN delinq_2yrs = 1 THEN '1'
    ELSE '2+'
  END AS delinq_bucket, COUNT(*) AS count FROM Finance_2 GROUP BY delinq_bucket;
  
  /*
  1) It uses the delinq_2yrs field — number of 30+ days past due delinquencies in the last 2 years
  2) It shows groups borrowers into: a) No delinquencies b) 1 delinquency and c) 2 or more delinquencies
  3) Business Use:
> Strong predictor for future defaults
> Flags risky profiles before loan issuance
> Enhances credit decision rules and automated scoring */ 


# 6) ANOMALY AND DATA QUALITY CHECKS: 
# The objective is to identify red flags, unrealistic values, or data inconsistencies that could:
# Corrupt analytics
# Mislead underwriting models
# Introduce risk in ML model training

-- **Interest Rate Anomalies**
SELECT id, int_rate FROM Finance_1
WHERE CAST(REPLACE(int_rate, '%', '') AS DECIMAL) > 30 OR CAST(REPLACE(int_rate, '%', '') AS DECIMAL) < 5;

/* 
1) It shows flags records where interest rates are either unreasonably low or very high.
2) Business Use:
> Prevents training ML models on extreme or mis-entered rates
> Ensures consistency in pricing policy*/ 

-- **Zero or Overfunded Loans*
SELECT id, loan_amnt, funded_amnt FROM Finance_1
WHERE funded_amnt = 0 OR funded_amnt > loan_amnt;

/* 
1) It finds loans where: The funded amount is zero or negative Or exceeds the requested loan amount
2) Business Use:
> Avoids modeling on invalid disbursals
> Detects system bugs or fraud*/ 

-- **Missing Annual Income or Credit Line**
SELECT COUNT(*) AS missing_annual_inc FROM Finance_1 WHERE annual_inc IS NULL;
SELECT COUNT(*) AS missing_credit_line FROM Finance_2 WHERE earliest_cr_line IS NULL;

/* 
1) It finds entries where annual income or credit history start date is missing or blank.
2) Business Use:
> Prevents inaccurate risk modeling or affordability scoring
> Ensures these key fields are present for all approved loans */

-- **Utilization Over 100%**
SELECT id, revol_util FROM Finance_2
WHERE CAST(REPLACE(revol_util, '%', '') AS DECIMAL) > 100;

/* 
1) It shows flags cases where utilization exceeds 100%, which is not practically possible (debt beyond credit limit).
2) Business Use:
> Prevents feeding unrealistic behaviors into scoring models
> Flags potential credit bureau errors or fraud */

# 7) FEATURE ENGINEERING FOR ML READINESS:
# ML-ready features from raw transactional and borrower data — enabling predictive model training and risk scoring.

-- **Credit Age (Months)**
SELECT id,  ROUND(DATEDIFF(issue_d, earliest_cr_line) / 30) AS credit_age_months
FROM Finance_1 JOIN Finance_2 using(id) order by credit_age_months desc;

/* 
1) It tells how long the borrower has had credit history (based on earliest_cr_line)
2) It matters as a) Longer credit age = lower risk
b) Important for creditworthiness modeling */

-- **High Utilization Binary Flag**
SELECT id,
       CASE WHEN CAST(REPLACE(revol_util, '%', '') AS DECIMAL) > 80 THEN 1 ELSE 0 END AS high_util_flag
FROM Finance_2;

/* 
1)  It tells whether the borrower is using more than 80% of their available revolving credit.
2) Why it matters:
> High utilization = credit stress
> Strong predictor for default risk or over-leveraging*/ 

-- **Funded Ratio**
SELECT id, ROUND(funded_amnt / loan_amnt, 2) AS funding_ratio FROM Finance_1;

/* 
1)  It is the ratio of loan actually funded vs loan amount requested.
2) If it is low then it may indicate that the lender doubts about the borrower
3) It is useful for modeling approval confidence */ 

-- **Payment to Loan Ratio**
SELECT finance_1.id, ROUND(total_pymnt / loan_amnt, 2) AS pay_to_loan_ratio
FROM Finance_1 JOIN Finance_2 ON finance_1.id = finance_2.id order by pay_to_loan_ratio desc;

/* 
1) It tells how much has the borrower repaid compared to their original loan.
2) Why it matters:
> Higher = repayment progress
> Good for early warning systems and dynamic risk scoring */ 



