-- ============================================
-- Healthcare Claims Anomaly Analysis
-- Author: Bhanu Mudireddy
-- Data: CMS Medicare Physician & Practitioners
-- ============================================

-- Query 1: Top 10 Highest Charging Provider Types
SELECT 
    Provider_Type,
    ROUND(AVG(Avg_Submitted_Charge), 2) as Avg_Charge,
    ROUND(AVG(Avg_Medicare_Payment), 2) as Avg_Medicare_Paid,
    ROUND(AVG(Avg_Submitted_Charge) - AVG(Avg_Medicare_Payment), 2) as Avg_Unpaid_Gap,
    COUNT(*) as Total_Records
FROM medicare_claims
GROUP BY Provider_Type
ORDER BY Avg_Charge DESC
LIMIT 10;

-- Query 2: Billing Anomaly Detection using Window Functions
SELECT 
    Provider_Type,
    Last_Name,
    First_Name,
    State,
    HCPCS_Desc,
    ROUND(Avg_Submitted_Charge, 2) as Provider_Charge,
    ROUND(AVG(Avg_Submitted_Charge) 
        OVER (PARTITION BY Provider_Type), 2) as Specialty_Avg,
    ROUND(Avg_Submitted_Charge / 
        AVG(Avg_Submitted_Charge) 
        OVER (PARTITION BY Provider_Type), 2) as Charge_Ratio
FROM medicare_claims
WHERE Avg_Submitted_Charge > 1000
ORDER BY Charge_Ratio DESC
LIMIT 20;

-- Query 3: State Level Billing Analysis
SELECT 
    State,
    ROUND(AVG(Avg_Submitted_Charge), 2) as Avg_Charge,
    ROUND(AVG(Avg_Medicare_Payment), 2) as Avg_Medicare_Paid,
    COUNT(DISTINCT NPI) as Total_Providers,
    SUM(Total_Services) as Total_Services
FROM medicare_claims
GROUP BY State
ORDER BY Avg_Charge DESC
LIMIT 15;

-- Query 4: Top Services by Medicare Payment
SELECT 
    HCPCS_Desc,
    Provider_Type,
    ROUND(AVG(Avg_Submitted_Charge), 2) as Avg_Charge,
    ROUND(AVG(Avg_Medicare_Payment), 2) as Avg_Medicare_Paid,
    SUM(Total_Services) as Total_Services_Nationwide
FROM medicare_claims
GROUP BY HCPCS_Desc, Provider_Type
ORDER BY Total_Services_Nationwide DESC
LIMIT 10;