from postgresql_csv_file_extract_with_encryption import export_query_to_csv
from dataclasses import dataclass
from typing import Tuple
from postgres_data_contract import DataContract, validate_data_contract
from sftp import send_file_over_sftp
import os

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Output path - change this to the required folder
CSV_FILE_PATH = "C:\\extracts\\erp\\"
CSV_BASE_FILE_NAME = "customer.csv"

# Set the remote folder to save the files on the SFTP server
SFTP_REMOTE_PATH = "erp/customer/"

SQL_QUERY = """
SELECT  C.CustomerId,
        C.OurRef,
        C.CompanyName,
        C.CustomerName,
        T.Title,
        G.Gender,
        C.AddressLine1,
        C.AddressLine2,
        C.AddressLine3,
        C.LastUpdatedBy,
        C.LastUpdated
FROM erp.Customer C
    LEFT JOIN erp.Title T ON C.TitleId = T.TitleId
    LEFT JOIN erp.Gender G ON C.GenderId = G.GenderId;
;
"""

# Connection string - should really be held in a secret
CONNECTION_STRING = (
    "host=localhost "
    "port=5432 "
    "dbname=DB_NAME "
    "user=postgres "
    "password=PASSWORD "
)

# Class defining the data contract
DATA_CONTRACT = DataContract(
    schema_name="erp",
    table_name="customer",
    required_columns=(
        "CustomerId",
        "OurRef",
        "CompanyName",
        "CustomerName",
        "TitleId",
        "GenderId",
        "AddressLine1",
        "AddressLine2",
        "AddressLine3",
        "LastUpdatedBy",
        "LastUpdated"
    )
)

# Send file via SFTP
def send_file_to_remote_server(local_file_path):
    try:
        file_name = os.path.basename(local_file_path).split('/')[-1]
        remote_file_path = f"{SFTP_REMOTE_PATH}{file_name}"
        send_file_over_sftp(local_file_path, remote_file_path)
    except Exception as e:
        print("Error sending file to SFTP: ", e)

# Execute export for each country database, sending to SFTP
def process_each_database():
    for d in DATABASES:
        conn_string = CONNECTION_STRING.replace("DB_NAME", d)

        contract_is_valid, failure_reason = validate_data_contract(conn_string, DATA_CONTRACT)

        if not contract_is_valid:
            print(f"{d}. Data contract validation failed. Reason: {failure_reason}")
        else:
            csv_file = export_query_to_csv(d, conn_string, SQL_QUERY, CSV_FILE_PATH, CSV_BASE_FILE_NAME)
            send_file_to_remote_server(csv_file)

if __name__ == "__main__":
    process_each_database()
