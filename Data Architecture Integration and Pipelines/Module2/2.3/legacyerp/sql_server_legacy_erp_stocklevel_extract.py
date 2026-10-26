from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerpstocklevels.csv"

SQL_QUERY = """
SELECT  SL.ItemRef, 
        SL.WarehouseRef, 
        SL.StockLevel
FROM dbo.StockLevel SL;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)