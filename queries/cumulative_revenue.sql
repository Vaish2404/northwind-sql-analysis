WITH MonthlyRevenue AS (
    SELECT 
        strftime('%Y-%m', o.OrderDate) AS Month,
        ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Revenue
    FROM "Order" o
    JOIN OrderDetail od ON o.Id = od.OrderId
    GROUP BY Month
)
SELECT 
    Month,
    Revenue,
    ROUND(SUM(Revenue) OVER (ORDER BY Month), 2) AS CumulativeRevenue
FROM MonthlyRevenue;
