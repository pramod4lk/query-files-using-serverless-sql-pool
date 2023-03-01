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
