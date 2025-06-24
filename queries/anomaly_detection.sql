WITH MonthlyRevenue AS (
    SELECT 
        strftime('%Y-%m', o.OrderDate) AS Month,
        ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Revenue
    FROM "Order" o
    JOIN OrderDetail od ON o.Id = od.OrderId
    GROUP BY Month
    ORDER BY Month
),
WithLag AS (
    SELECT 
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Month) AS PrevMonthRevenue
    FROM MonthlyRevenue
)
SELECT 
    Month,
    Revenue,
    PrevMonthRevenue,
    ROUND(((Revenue - PrevMonthRevenue)*100.0 / PrevMonthRevenue), 2) AS PercentChange,
    CASE 
        WHEN ABS((Revenue - PrevMonthRevenue)*1.0 / PrevMonthRevenue) >= 0.20 THEN 'Anomaly'
        ELSE 'Normal'
    END AS Status
FROM WithLag
WHERE PrevMonthRevenue IS NOT NULL;
