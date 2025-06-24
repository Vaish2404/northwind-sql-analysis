WITH MonthlyRevenue AS (
    SELECT 
        strftime('%Y-%m', o.OrderDate) AS Month,
        ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Revenue
    FROM "Order" o
    JOIN OrderDetail od ON o.Id = od.OrderId
    GROUP BY Month
    ORDER BY Month
)
SELECT 
    Month,
    Revenue,
    ROUND(AVG(Revenue) OVER (
        ORDER BY Month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS Rolling3MonthAvg
FROM MonthlyRevenue;
