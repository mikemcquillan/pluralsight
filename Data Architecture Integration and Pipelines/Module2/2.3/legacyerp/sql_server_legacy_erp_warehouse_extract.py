from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerpwarehouses.csv"

SQL_QUERY = """
SELECT  W.WarehouseRef,
        W.WarehouseName
FROM dbo.Warehouse W;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)