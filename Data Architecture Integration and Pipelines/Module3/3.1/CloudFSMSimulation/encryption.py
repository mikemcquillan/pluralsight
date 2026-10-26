import json

from cryptography.fernet import Fernet
from typing import Any

# Need to install cryptography library to use this script - use pip3 install cryptography

def generate_encryption_key() -> str:
    """
    Generate a new encryption key.

    Store this key securely. Data encrypted with a different key
    cannot be decrypted.
    """

    key = Fernet.generate_key().decode("utf-8")
    print(f"Encrpyion key: {key}")

    return key


def encrypt_json(data: dict, encryption_key: str) -> str:
    """Encrypt a dictionary containing JSON-compatible data."""
    key = encryption_key.encode("utf-8")
    fernet = Fernet(key)

    json_data = json.dumps(
        data,
        separators=(",", ":"),
    ).encode("utf-8")

    encrypted_data = fernet.encrypt(json_data)

    return encrypted_data.decode("utf-8")


def decrypt_json(
    encrypted_data: str,
    encryption_key: str,
) -> dict:
    """Decrypt an encrypted JSON string into a dictionary."""
    key = encryption_key.encode("utf-8")
    fernet = Fernet(key)

    decrypted_data = fernet.decrypt(
        encrypted_data.encode("utf-8")
    )

    return json.loads(
        decrypted_data.decode("utf-8")
    )

def encrypt_list(
    values: list[str],
    encryption_key: str,
) -> list[str]:
    """Encrypt each string in a list."""
    fernet = Fernet(encryption_key.encode("utf-8"))

    return [
        fernet.encrypt(value.encode("utf-8")).decode("utf-8")
        for value in values
    ]

def decrypt_list(
    encrypted_values: list[str],
    encryption_key: str,
) -> list[str]:
    """Decrypt each string in a list."""
    fernet = Fernet(encryption_key.encode("utf-8"))

    return [
        fernet.decrypt(
            encrypted_value.encode("utf-8")
        ).decode("utf-8")
        for encrypted_value in encrypted_values
    ]