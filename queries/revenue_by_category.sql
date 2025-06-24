SELECT 
    c.CategoryName,
    strftime('%Y-%m', o.OrderDate) AS Month,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Revenue
FROM OrderDetail od
JOIN "Order" o ON od.OrderId = o.Id
JOIN Product p ON od.ProductId = p.Id
JOIN Category c ON p.CategoryId = c.Id
GROUP BY c.CategoryName, Month
ORDER BY Month;
