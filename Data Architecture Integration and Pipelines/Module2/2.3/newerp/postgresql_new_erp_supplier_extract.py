from postgresql_csv_file_extract import export_query_to_csv

# Need to install psycopg to use this script - use pip3 install "psycopg[binary]"

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Output path - ensure this folder exists
CSV_FILE_PATH = "C:\\extracts\\erp\\"
CSV_BASE_FILE_NAME = "supplier.csv"

SQL_QUERY = """
SELECT	S.SupplierId,
		S.OurRef,
		S.CompanyName,
		S.PrimaryContact,
		S.AddressLine1,
		S.AddressLine2,
		S.AddressLine3,
		S.LastUpdatedBy,
		S.LastUpdated
	FROM erp.Supplier S;
"""

# Connection string - should really be held in a secret
CONNECTION_STRING = (
    "host=localhost "
    "port=5432 "
    "dbname=DB_NAME "
    "user=postgres "
    "password=PASSWORD "
)

# Execute export for each country database
def process_each_database():
    for d in DATABASES:
        conn_string = CONNECTION_STRING.replace("DB_NAME", d)
        export_query_to_csv(d, conn_string, SQL_QUERY, CSV_FILE_PATH, CSV_BASE_FILE_NAME)

if __name__ == "__main__":
    process_each_database()
