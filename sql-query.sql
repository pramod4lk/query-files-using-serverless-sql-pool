-- This could be used to extract data from CSV files.

SELECT TOP 100 *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/files/*.csv',
    FORMAT = 'csv') AS rows

/* As seen in the above example, you can use wildcards in the BULK parameter to include or exclude files in the query. 
The following list shows a few examples of how this can be used:

https://mydatalake.blob.core.windows.net/data/files/file1.csv: Only include file1.csv in the files folder.
https://mydatalake.blob.core.windows.net/data/files/file*.csv: All .csv files in the files folder with names that start with "file".
https://mydatalake.blob.core.windows.net/data/files/*: All files in the files folder.
https://mydatalake.blob.core.windows.net/data/files/**: All files in the files folder, and recursively its subfolders.
*/


/*Regardless of the type of delimited file you're using, you can read data from them by using the OPENROWSET function with the csv FORMAT parameter, 
and other parameters as required to handle the specific formatting details for your data.
*/

SELECT TOP 100 *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/files/*.csv',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0',
    FIRSTROW = 2) AS rows
    
/* Additional parameters you might require when working with delimited text files include:

FIELDTERMINATOR - the character used to separate field values in each row. 
    For example, a tab-delimited file separates fields with a TAB (\t) character. 
    The default field terminator is a comma (,).
ROWTERMINATOR - the character used to signify the end of a row of data. 
    For example, a standard Windows text file uses a combination of a carriage return (CR) and line feed (LF), 
    which is indicated by the code \n; while UNIX-style text files use a single line feed character, which can be indicated using the code 0x0a.
FIELDQUOTE - the character used to enclose quoted string values. For example, 
    to ensure that the comma in the address field value 126 Main St, 
    apt 2 isn't interpreted as a field delimiter, you might enclose the entire field value in quotation marks like this: "126 Main St, apt 2". 
    The double-quote (") is the default field quote character.
 */
 
 /*
 You could use the following query to extract the data with the correct column names and appropriately inferred SQL Server data types 
 (in this case INT, NVARCHAR, and DECIMAL)
 */
 
SELECT TOP 100 *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/files/*.csv',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE) AS rows

/*
To specify explicit column names and data types, 
you can override the default column names and inferred data types by providing a schema definition in a WITH clause, like this:
*/

SELECT TOP 100 *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/files/*.csv',
    FORMAT = 'csv',
    PARSER_VERSION = '2.0')
WITH (
    product_id INT,
    product_name VARCHAR(20) COLLATE Latin1_General_100_BIN2_UTF8,
    list_price DECIMAL(5,2)
) AS rows

--To return product data from a folder containing multiple JSON files in this format, you could use the following SQL query:

SELECT doc
FROM
    OPENROWSET(
        BULK 'https://mydatalake.blob.core.windows.net/data/files/*.json',
        FORMAT = 'csv',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    ) WITH (doc NVARCHAR(MAX)) as rows
	
/*
OPENROWSET has no specific format for JSON files, so you must use csv format with FIELDTERMINATOR, 
FIELDQUOTE, and ROWTERMINATOR set to 0x0b, and a schema that includes a single NVARCHAR(MAX) column. 
The result of this query is a rowset containing a single column of JSON documents, like this:

Output -> {"product_id":123,"product_name":"Widget","list_price": 12.99}
*/

-- To extract individual values from the JSON, you can use the JSON_VALUE function in the SELECT statement, as shown here:

SELECT JSON_VALUE(doc, '$.product_name') AS product,
           JSON_VALUE(doc, '$.list_price') AS price
FROM
    OPENROWSET(
        BULK 'https://mydatalake.blob.core.windows.net/data/files/*.json',
        FORMAT = 'csv',
        FIELDTERMINATOR ='0x0b',
        FIELDQUOTE = '0x0b',
        ROWTERMINATOR = '0x0b'
    ) WITH (doc NVARCHAR(MAX)) as rows

-- Querying Parquet files

SELECT TOP 100 *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/files/*.*',
    FORMAT = 'parquet') AS rows
	
-- To create a query that filters the results to include only the orders for January and February 2020, you could use the following code:

SELECT *
FROM OPENROWSET(
    BULK 'https://mydatalake.blob.core.windows.net/data/orders/year=*/month=*/*.*',
    FORMAT = 'parquet') AS orders
WHERE orders.filepath(1) = '2020'
    AND orders.filepath(2) IN ('1','2');
	
