CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1qaz2wsx@@';

CREATE DATABASE SCOPED CREDENTIAL StagingCredential
WITH
    IDENTITY='SHARED ACCESS SIGNATURE',  
    SECRET = '1qaz2wsx@@';
GO

CREATE EXTERNAL DATA SOURCE Staging
WITH (
    LOCATION = 'https://raritbiprod.dfs.core.windows.net/staging/',
	CREDENTIAL = StagingCredential
)

CREATE EXTERNAL FILE FORMAT CsvFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS(
            FIELD_TERMINATOR = ',',
            STRING_DELIMITER = '"'
        )
    );
GO

SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'data/sample-data.csv',
        DATA_SOURCE = 'Staging',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

CREATE EXTERNAL TABLE dbo.Sales
(
    [Year] INT,
    Industry_aggregation_NZSIOC VARCHAR(20),
    Industry_code_NZSIOC INT
)
WITH
(
    DATA_SOURCE = Staging,
    LOCATION = 'data/*.csv',
    FILE_FORMAT = CsvFormat
);
GO

-- query the table
SELECT * FROM dbo.Sales;