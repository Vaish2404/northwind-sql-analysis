SELECT 
    od.OrderId,
    o.OrderDate,
    od.Quantity * od.UnitPrice AS Revenue
FROM OrderDetail od
JOIN [Order]o ON od.OrderId = o.Id;


SELECT 
    strftime('%Y-%m', o.OrderDate) AS Month,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Monthly_Revenue
FROM OrderDetail od
JOIN [Order] o ON od.OrderID = o.Id
GROUP BY Month
ORDER BY Month;

WITH MonthlyRevenue AS (
    SELECT 
        strftime('%Y-%m', o.OrderDate) AS Month,
        ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Revenue
    FROM OrderDetail od
    JOIN [Order] o ON od.OrderId = o.Id
    GROUP BY Month
),
WithLag AS (
    SELECT 
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Month) AS PrevRevenue
    FROM MonthlyRevenue
)
SELECT 
    Month,
    Revenue,
    PrevRevenue,
    ROUND(((Revenue - PrevRevenue) / PrevRevenue) * 100.0, 2) AS MoM_Change_Percent
FROM WithLag;

