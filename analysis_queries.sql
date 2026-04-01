CREATE DATABASE bank_churn_project;
USE bank_churn_project;
Create table bank_churn ( CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Tenure INT,
    Balance DECIMAL(15,2),
    NumOfProducts INT,
    HasCrCard INT,
    IsActiveMember INT,
    EstimatedSalary DECIMAL(15,2),
    Exited INT,
    AgeGroup VARCHAR(20),
    BalanceTier VARCHAR(20),
    ChurnLabel VARCHAR(20)
);
#QUERY 1 — Basic Churn Count
#Business Question: How many customers churned vs stayed overall?


USE bank_churn_project;

SELECT
    ChurnLabel AS Customer_Status,
    COUNT(*) AS Total_Customers
FROM bank_churn
GROUP BY ChurnLabel;

#QUERY 2 — Churn Rate by Geography
#Business Question: Which country has the highest churn rate?
USE bank_churn_project;

SELECT
    Geography,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM bank_churn
GROUP BY Geography
ORDER BY Churn_Rate_Percent DESC;

#Querry 3 - Churn Rate by gender
#Business Question: Does gender affect churn rate?


#QUERY 4 — Churn by Number of Products
#Business Question: Do customers with more products churn more?

USE bank_churn_project;

SELECT
    NumOfProducts,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

# QUERY 5 — Average Balance: Churned vs Retained
#Business Question: What is the profile of a churned customer vs a retained customer?


# QUERY 6 — Churn by Age Group
#Business Question: Which age group churns the most?
USE bank_churn_project;

SELECT
    AgeGroup,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM bank_churn
GROUP BY AgeGroup
ORDER BY Churn_Rate_Percent DESC;

#QUERY 7 — High Value Churned Customers 
#Business Question: Who are the most valuable customers we are losing?

USE bank_churn_project;

SELECT
    Geography,
    Gender,
    Age,
    Balance,
    CreditScore
FROM bank_churn
WHERE Exited = 1
AND Balance > (
    SELECT AVG(Balance)
    FROM bank_churn
    WHERE Exited = 1
)
ORDER BY Balance DESC
LIMIT 10;

#QUERY 8 — Active vs Inactive Member Churn
#Business Question: Does being an active member reduce churn?

USE bank_churn_project;

SELECT
    CASE WHEN IsActiveMember = 1 THEN 'Active'
         ELSE 'Inactive'
    END AS Member_Status,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate_Percent
FROM bank_churn
GROUP BY IsActiveMember;

#QUERY 9 — CTE (Common Table Expression)
#Business Question: What is the churn rate by Geography AND Gender combined?

USE bank_churn_project;

WITH ChurnSummary AS (
    SELECT
        Geography,
        Gender,
        COUNT(*) AS Total_Customers,
        SUM(Exited) AS Churned_Customers,
        ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate
    FROM bank_churn
    GROUP BY Geography, Gender
)
SELECT *
FROM ChurnSummary
ORDER BY Churn_Rate DESC;

#QUERY 10 — Window Function RANK()
#Business Question: How do Geography + Gender segments rank against each other by churn rate?

USE bank_churn_project;

SELECT
    Geography,
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS Churn_Rate,
    RANK() OVER (ORDER BY SUM(Exited) * 100.0 / COUNT(*) DESC) AS Churn_Rank
FROM bank_churn
GROUP BY Geography, Gender
ORDER BY Churn_Rank;







