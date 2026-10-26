import csv
import pyodbc

# Need to install pyodbc to use this script - use pip3 install "pyodbc"

SQL_CONNECTION_STRING = (
     "DRIVER={ODBC Driver 18 for SQL Server};"
     "SERVER=192.168.1.124;"
     "DATABASE=legacyerp;"
     "UID=sa;"
     "PWD=PASSWORD;"
     "TrustServerCertificate=yes;"
)

def export_query_to_csv(sql_query, csv_file_name) -> None:
    """Execute query and export data"""
    connection = None
    cursor = None

    try:
        connection = pyodbc.connect(SQL_CONNECTION_STRING)
        cursor = connection.cursor()
        cursor.execute(sql_query)

        # Get the column names returned by the query.
        headers = [column[0] for column in cursor.description]

        with open(
            csv_file_name,
            mode="w",
            newline="",
            encoding="utf-8"
        ) as csv_file:
            writer = csv.writer(
                csv_file,
                delimiter="|",
                quoting=csv.QUOTE_MINIMAL
            )

            # Write the column headings first.
            writer.writerow(headers)

            # Write the query results.
            for row in cursor:
                cleaned_row = [
                    value.strip('~') if isinstance(value, str) else value
                    for value in row
                ]

                writer.writerow(cleaned_row)

        print(f"CSV file created: {csv_file_name}")

    except pyodbc.Error as error:
        print(f"SQL Server error: {error}")

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None:
            connection.close()