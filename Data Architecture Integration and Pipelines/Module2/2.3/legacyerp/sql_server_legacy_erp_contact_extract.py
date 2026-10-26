from sql_server_csv_extract import export_query_to_csv

CSV_FILE_NAME = "C:\\extracts\\legacyerp\\legacyerpcontacts.csv"

SQL_QUERY = """
SELECT
    Ref,
    ContactType,
    CompanyName,
    FirstName,
    LastName,
    Title,
    Gender,
    AddressLine1,
    City,
    Postcode
FROM dbo.Contact;
"""

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_NAME)
