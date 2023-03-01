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
 
 
