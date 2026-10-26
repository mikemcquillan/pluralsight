import csv
import psycopg
from text_encryption import generate_encryption_key, encrypt_list, decrypt_list

# Need to install psycopg to use this script - use pip3 install "psycopg[binary]"

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Generate an encryption key
def create_encryption_key() -> str:
    return generate_encryption_key()

# Perform the actual export
def export_query_to_csv(database_name, conn_string, sql_query, file_path, base_file_name) -> str:
    """Execute query and export data"""
    connection = None
    cursor = None

    # Generate an encryption key. Keep hold of this so data can be decrypted!
    key = create_encryption_key()    
    print(f"Encryption key: {key}. Use this to decrypt events.")

    try:
        with psycopg.connect(conn_string) as conn:
            with conn.cursor() as cursor:
                cursor.execute(sql_query)

                # Obtain column names
                headers = [column[0] for column in cursor.description]

                file_name = f"{file_path}{database_name}_{base_file_name}"

                with open(
                    file_name,
                    mode="w",
                    newline="",
                    encoding="utf-8"
                ) as csv_file:
                    writer = csv.writer(
                        csv_file,
                        delimiter="|",
                        quoting=csv.QUOTE_MINIMAL
                    )

                    # Write column headers
                    writer.writerow(encrypt_list(headers, key))

                    # Write each row
                    for row in cursor:
                        cleaned_row = [
                            value.strip('~') if isinstance(value, str) else value
                            for value in row
                        ]

                        writer.writerow(encrypt_list(cleaned_row, key))

        print(f"CSV file created: {file_name}")
        return file_name

    except psycopg.Error as error:
        print(f"Database error: {error}")
        return ""

    except OSError as error:
        print(f"File error: {error}")
        return ""

# View the decrypted data
def print_decrypted_file(file_path, key):

    rows = []

    with open(
        file_path,
        mode="r",
        newline="",
        encoding="utf-8"
    ) as read_csv_file:
        reader = csv.reader(
            read_csv_file,
            delimiter="|",
            quoting=csv.QUOTE_MINIMAL)

        for row in reader:
            rows.append(decrypt_list(row, key))
    
    print(rows)