        STOCK PORTFOLIO ANALYTICS DASHBOARD


Project      : Stock Portfolio Analytics Dashboard
Database     : MySQL
Tools Used   : MySQL, Power BI, Excel
Author       : Harsh Gaggar

Description:
This SQL script contains analytical queries used to support
the Stock Portfolio Analytics Dashboard. The queries generate
KPIs and insights related to portfolio investment, holdings,
transactions, allocation, and investment trends.



=====================================================
KPI QUERIES
=====================================================

1. Total Investment
SELECT
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Total_Investment
FROM fact_transactions;

2. Total Shares Purchased
SELECT
    SUM(Quantity) AS Total_Shares
FROM fact_transactions
WHERE `Transaction Type` = 'Buy';

3. Total Transactions
SELECT
    COUNT(*) AS Total_Transactions
FROM fact_transactions;

4. Number of Holdings
SELECT
    COUNT(DISTINCT Stock) AS Total_Stocks
FROM fact_transactions;


=====================================================
STOCK ANALYSIS
=====================================================

5. Investment by Stock
SELECT
    Stock,
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Investment
FROM fact_transactions
GROUP BY Stock
ORDER BY Investment DESC;

6. Shares Held by Stock
SELECT
    Stock,
    SUM(Quantity) AS Shares
FROM fact_transactions
GROUP BY Stock
ORDER BY Shares DESC;

7. Average Buy Price by Stock
SELECT
    Stock,
    ROUND(AVG(`Buy Price`), 2) AS Average_Buy_Price
FROM fact_transactions
GROUP BY Stock
ORDER BY Average_Buy_Price DESC;

8. Top 5 Most Invested Stocks
SELECT
    Stock,
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Total_Investment
FROM fact_transactions
GROUP BY Stock
ORDER BY Total_Investment DESC
LIMIT 5;

9. Portfolio Allocation by Stock (%)
SELECT
    Stock,
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Investment,
    ROUND(
        100 * SUM(Quantity * `Buy Price`) /
        (SELECT SUM(Quantity * `Buy Price`) FROM fact_transactions),
        2
    ) AS Portfolio_Percentage
FROM fact_transactions
GROUP BY Stock
ORDER BY Portfolio_Percentage DESC;

10. Investment Ranking
SELECT
    Stock,
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Total_Investment,
    RANK() OVER (
        ORDER BY SUM(Quantity * `Buy Price`) DESC
    ) AS Investment_Rank
FROM fact_transactions
GROUP BY Stock;


=====================================================
TRANSACTION ANALYSIS
=====================================================

11. Buy vs Sell Analysis
SELECT
    `Transaction Type`,
    COUNT(*) AS Transactions,
    SUM(Quantity) AS Total_Shares
FROM fact_transactions
GROUP BY `Transaction Type`;

12. Highest Value Transaction
SELECT
    TransactionID,
    Stock,
    Quantity,
    `Buy Price`,
    ROUND(Quantity * `Buy Price`, 2) AS Transaction_Value
FROM fact_transactions
ORDER BY Transaction_Value DESC
LIMIT 1;


=====================================================
TIME SERIES ANALYSIS
=====================================================

 13. Monthly Investment Trend
SELECT
    DATE_FORMAT(
        STR_TO_DATE(Date, '%d-%b-%y'),
        '%Y-%m'
    ) AS Month,
    ROUND(SUM(Quantity * `Buy Price`), 2) AS Investment
FROM fact_transactions
GROUP BY Month
ORDER BY Month;