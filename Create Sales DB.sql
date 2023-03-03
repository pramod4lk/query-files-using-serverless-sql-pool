CREATE DATABASE Sales
   COLLATE Latin1_General_100_BIN2_UTF8;
 GO;

 Use Sales;
 GO;

 CREATE EXTERNAL DATA SOURCE SalesData WITH (
     LOCATION = 'https://raritbiprod.dfs.core.windows.net/staging/'
 );
 GO;

SELECT *
 FROM
  OPENROWSET(
    BULK 'csv/*.csv',
    DATA_SOURCE = 'SalesData',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0'
  ) AS orders

SELECT *
FROM 
  OPENROWSET(
    BULK 'parquet/**',
    DATA_SOURCE = 'SalesData',
    FORMAT='PARQUET'
  ) AS orders