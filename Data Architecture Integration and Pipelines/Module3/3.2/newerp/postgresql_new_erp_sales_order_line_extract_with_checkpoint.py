from postgresql_csv_file_extract import export_query_to_csv
from sftp import send_file_over_sftp
import psycopg

# Need to install psycopg to use this script - use pip3 install "psycopg[binary]"

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Output path - ensure this folder exists
CSV_FILE_PATH = "C:\\extracts\\erp\\"
CSV_BASE_FILE_NAME = "salesorderline_START_END.csv"

# Controls how many records are in each file
NUMBER_OF_RECORDS_PER_BATCH = 1000

# Run a SELECT COUNT to obtain the record total
SQL_COUNT_QUERY = """
SELECT COUNT(1) FROM erp.SalesOrderLine;
"""

SQL_QUERY = """
SELECT	SOL.SalesOrderId,
		W.WarehouseCode,
		SOL.ProductId,
		SOL.Ordinal,
		SOL.Quantity,
		SOL.ItemPrice,
		SOL.LineTotal,
		SOL.LastUpdatedBy,
		SOL.LastUpdated
	FROM erp.SalesOrderLine SOL
		INNER JOIN erp.Warehouse W
			ON SOL.WarehouseId = W.WarehouseId
    LIMIT MAX_RECORD_COUNT OFFSET OFFSET_NUMBER;
"""

# Connection string - should really be held in a secret
CONNECTION_STRING = (
    "host=localhost "
    "port=5432 "
    "dbname=DB_NAME "
    "user=postgres "
    "password=PASSWORD "
)

# Executes a SQL statement and returns a single value
def execute_single_query_sql(conn_string, query) -> int:
    connection = None
    cursor = None
    return_value = ""
    
    try:
        with psycopg.connect(conn_string) as conn:

            with conn.cursor() as cursor:
                cursor.execute(query)
                for row in cursor:
                    return_value = [
                        str(value)
                        for value in row
                    ]

        return int(return_value[0])

    except psycopg.Error as error:
        print(f"{conn_string}. Database error: {error}")
        return 0

# Obtain the connection string for the targe database
def get_conn_string(database_name):
    return CONNECTION_STRING.replace("DB_NAME", database_name)

# Obtain the last record ID
def get_max_record_id(conn_string):
    return execute_single_query_sql(conn_string, SQL_COUNT_QUERY)

# Execute export for each country database
def process_each_database():
    for d in DATABASES:
        conn_string = get_conn_string(d)
        max_record_id = get_max_record_id(conn_string)
        current_record_id = 0
        last_record_id_in_batch = NUMBER_OF_RECORDS_PER_BATCH

        print(f"Current: {current_record_id}, Max: {max_record_id}")

        while current_record_id <= max_record_id:

            checkpoint_sql_query = SQL_QUERY.replace("MAX_RECORD_COUNT", str(NUMBER_OF_RECORDS_PER_BATCH))
            checkpoint_sql_query = checkpoint_sql_query.replace("OFFSET_NUMBER", str(current_record_id))

            last_record_id_in_batch = max_record_id if current_record_id > max_record_id else (current_record_id + NUMBER_OF_RECORDS_PER_BATCH)

            file_name = CSV_BASE_FILE_NAME.replace("START", str(current_record_id)).replace("END", str(last_record_id_in_batch))

            csv_file = export_query_to_csv(d, conn_string, checkpoint_sql_query, CSV_FILE_PATH, file_name)
            #send_file_over_sftp(csv_file, file_name)

            current_record_id += NUMBER_OF_RECORDS_PER_BATCH

            if current_record_id > max_record_id:
                current_record_id = max_record_id
                max_record_id -= 1          # Do this to cause the loop to exit

if __name__ == "__main__":
    process_each_database()
