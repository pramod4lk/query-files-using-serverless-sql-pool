SELECT YEAR(OrderDate) AS OrderYear,
        SUM((UnitPrice * Quantity) + TaxAmount) AS GrossRevenue
 FROM dbo.Orders
 GROUP BY YEAR(OrderDate)
 ORDER BY OrderYear;