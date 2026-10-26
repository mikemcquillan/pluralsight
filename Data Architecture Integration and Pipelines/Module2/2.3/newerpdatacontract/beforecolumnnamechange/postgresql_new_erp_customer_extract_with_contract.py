from postgresql_csv_file_extract import export_query_to_csv
from dataclasses import dataclass
from typing import Tuple
from postgres_data_contract import DataContract, validate_data_contract

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Output path - ensure this folder exists
CSV_FILE_PATH = "C:\\extracts\\erp\\"
CSV_BASE_FILE_NAME = "customer.csv"

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
CUSTOMER_CONTRACT = DataContract(
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
        "AddresLine2",
        "AddressLine3",
        "LastUpdatedBy",
        "LastUpdated",
    ),
)

# Execute export for each country database
def process_each_database():
    for d in DATABASES:

        conn_string = CONNECTION_STRING.replace("DB_NAME", d)

        contract_is_valid, failure_reason = validate_data_contract(conn_string, CUSTOMER_CONTRACT)

        if not contract_is_valid:
            print(f"{d}. Data contract validation failed. Reason: {failure_reason}")
        else:
            export_query_to_csv(d, conn_string, SQL_QUERY, CSV_FILE_PATH, CSV_BASE_FILE_NAME)

if __name__ == "__main__":
    process_each_database()
