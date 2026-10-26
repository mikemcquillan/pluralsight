import csv
import psycopg

# Need to install psycopg to use this script - use pip3 install "psycopg[binary]"

DATABASES = ["newerpnl", "newerpuk", "newerpus"]

# Perform the actual export
def export_query_to_csv(database_name, conn_string, sql_query, file_path, base_file_name) -> str:
    """Execute query and export data"""
    connection = None
    cursor = None

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
                    writer.writerow(headers)

                    # Write each row
                    for row in cursor:
                        cleaned_row = [
                            value.strip('~') if isinstance(value, str) else value
                            for value in row
                        ]

                        writer.writerow(cleaned_row)

        print(f"CSV file created: {file_name}")
        return file_name

    except psycopg.Error as error:
        print(f"Database error: {error}")
        return ""

    except OSError as error:
        print(f"File error: {error}")
        return ""