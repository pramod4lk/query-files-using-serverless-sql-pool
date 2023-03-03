-- This is auto-generated code
SELECT YEAR(OrderDate) AS OrderYear,
        COUNT(*) AS OrderedItems
FROM
    OPENROWSET(
        BULK 'https://raritbiprod.dfs.core.windows.net/staging/parquet/**',
        FORMAT = 'PARQUET'
    ) AS [result]
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear
