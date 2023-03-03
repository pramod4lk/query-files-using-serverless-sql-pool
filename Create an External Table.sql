CREATE EXTERNAL FILE FORMAT CSVFormat
     WITH (
         FORMAT_TYPE = DELIMITEDTEXT,
         FORMAT_OPTIONS (
         FIELD_TERMINATOR = ',',
         STRING_DELIMITER = '"'
         )
     );

CREATE EXTERNAL TABLE dbo.Orders
 (
     SalesOrderNumber VARCHAR(10),
     SalesOrderLineNumber INT,
     OrderDate DATE,
     CustomerName VARCHAR(25),
     EmailAddress VARCHAR(50),
     Item VARCHAR(30),
     Quantity INT,
     UnitPrice DECIMAL(18,2),
     TaxAmount DECIMAL (18,2)
 )
 WITH
 (
     DATA_SOURCE =SalesData,
     LOCATION = 'csv/*.csv',
     FILE_FORMAT = CSVFormat
 );
 GO