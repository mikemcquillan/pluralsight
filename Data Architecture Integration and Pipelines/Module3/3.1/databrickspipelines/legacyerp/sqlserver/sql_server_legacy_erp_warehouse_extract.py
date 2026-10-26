from sql_server_csv_extract import export_query_to_csv
from sftp import send_file_over_sftp
import os

# Output path - change this to the required folder
CSV_FILE_PATH = "C:\\extracts\\legacyerp\\legacyerpwarehouses.csv"

# Set the remote folder to save the files on the SFTP server
SFTP_REMOTE_PATH = "legacyerp/"

SQL_QUERY = """
SELECT  W.WarehouseRef,
        W.WarehouseName
FROM dbo.Warehouse W;
"""

# Send file via SFTP
def send_file_to_remote_server(local_file_path):
    try:
        file_name = os.path.basename(local_file_path).split('/')[-1]
        remote_file_path = f"{SFTP_REMOTE_PATH}{file_name}"
        send_file_over_sftp(local_file_path, remote_file_path)
    except Exception as e:
        print("Error sending file to SFTP: ", e)

if __name__ == "__main__":
    export_query_to_csv(SQL_QUERY, CSV_FILE_PATH)
    send_file_to_remote_server(CSV_FILE_PATH)
