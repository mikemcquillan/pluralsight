from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerporders.csv"

SQL_QUERY = """
SELECT  O.OrderRef, 
        O.OrderType, 
        O.OrderDate, 
        O.SentDate,
        O.ContactRef,
        O.DueDate
FROM dbo.[Order] O;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)