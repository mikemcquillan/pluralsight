from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerporderlines.csv"

SQL_QUERY = """
SELECT  OL.ItemRef, 
        OL.WarehouseRef, 
        OL.StockLevel
        OL.Quantity,
        OL.SingleItemPrice,
        OL.TotalLinePrice
FROM dbo.OrderLine OL;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)