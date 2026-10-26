from pathlib import Path
import paramiko

# Need to install paramiko to use this script - use pip3 install "paramiko"

# Configure SFTP settings here
# Normally, you would host this information in a secret
SFTP_HOST = "SFTP_HOST"
SFTP_PORT = 22
SFTP_USERNAME = "USERNAME"
SFTP_PASSWORD = "PASSWORD"

# Sends the specified file to SFTP
def send_file_over_sftp(local_file_name, remote_file_name) -> None:
    local_file = Path(local_file_name)

    if not local_file.is_file():
        raise FileNotFoundError(
            f"Local file does not exist: {local_file}"
        )

    ssh_client = paramiko.SSHClient()

    # Reject unknown host keys instead of accepting them automatically
    ssh_client.set_missing_host_key_policy(
        paramiko.AutoAddPolicy()
    )

    try:
        ssh_client.connect(
            hostname=SFTP_HOST,
            port=SFTP_PORT,
            username=SFTP_USERNAME,
            password = SFTP_PASSWORD,
            timeout=30
        )

        with ssh_client.open_sftp() as sftp_client:
            sftp_client.put(
                str(local_file),
                remote_file_name,
            )

        print(
            f"File sent successfully. "
            f"{local_file} -> {remote_file_name}"
        )

    finally:
        ssh_client.close()

