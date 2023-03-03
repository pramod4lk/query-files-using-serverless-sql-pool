-- This is auto-generated code
SELECT TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://raritbiprod.dfs.core.windows.net/staging/json/',
        FORMAT = 'CSV',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0b'
    )
    WITH (
        jsonContent varchar(MAX)
    ) AS [result]
