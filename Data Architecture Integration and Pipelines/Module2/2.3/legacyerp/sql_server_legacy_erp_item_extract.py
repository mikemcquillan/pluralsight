from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerpitems.csv"

SQL_QUERY = """
SELECT  I.ItemRef, 
        IT.ItemType, 
        I.ItemName, 
        I.Price
FROM dbo.Item I
    INNER JOIN dbo.ItemType IT
        ON I.ItemTypeRef = IT.ItemTypeRef;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)