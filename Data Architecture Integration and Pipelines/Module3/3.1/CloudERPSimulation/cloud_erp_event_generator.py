import ssl
import time
import json
import encryption
from datetime import datetime, timedelta
import urllib.request
from azure.eventhub import EventData, EventHubProducerClient

# Generate and send one JSON document every two seconds
INTERVAL_SECONDS = 2

EVENT_HUB_NAMESPACE = "globo-cloud-erp"

EVENT_HUB_NAME = "TYPE ADDRESS HERE"
EVENT_HUB_KEY_NAME = "TYPE KEY NAME HERE"
EVENT_HUB_KEY_VALUE = "PASTE KEY VALUE HERE"

# Event Hubs connection string, good practice would be to use a secret!
EVENT_HUB_CONNECTION_STRING = (
    f"Endpoint={EVENT_HUB_NAMESPACE};"
    f"SharedAccessKeyName={EVENT_HUB_KEY_NAME};"
    f"SharedAccessKey={EVENT_HUB_KEY_VALUE};"
    f"EntityPath={EVENT_HUB_NAME}"
)

def generate_document():

    response = urllib.request.urlopen("https://mcqtech.com/python")
    data = json.load(response)
    return data
    
def create_tls_13_context() -> ssl.SSLContext:
    """Create an SSL context that requires TLS 1.3."""
    if not hasattr(ssl, "TLSVersion") or not hasattr(
        ssl.TLSVersion,
        "TLSv1_3",
    ):
        raise RuntimeError(
            "This Python/OpenSSL installation does not support TLS 1.3."
        )

    context = ssl.create_default_context()
    context.minimum_version = ssl.TLSVersion.TLSv1_3
    context.maximum_version = ssl.TLSVersion.MAXIMUM_SUPPORTED

    return context

# Main program execution
def main() -> None:
    tls_context = create_tls_13_context()

    # Connect to the event hub
    producer = EventHubProducerClient.from_connection_string(
        conn_str=EVENT_HUB_CONNECTION_STRING,
        eventhub_name=EVENT_HUB_NAME,
        ssl_context=tls_context,
    )

    # Generate an encryption key. Keep hold of this so data can be decrypted!
    key = encryption.generate_encryption_key()
    
    print(f"Encryption key: {key}. Use this to decrypt events.")
    print("Sending events. Press Ctrl+C to stop.")

    try:
        with producer:
            # Send events until interrupted
            while True:
                document = encryption.encrypt_json(generate_document(), key)
                json_payload = json.dumps(document, separators=(",", ":"))  # Encryption performed here
                
                event = EventData(json_payload)
                producer.send_batch([event])
                
                print(json.dumps(document, indent=4))
                
                time.sleep(INTERVAL_SECONDS)

    except KeyboardInterrupt:
        print("\nStopped.")

# Use to view decrypted data
def decrypt_json(json, key):
    json_data = encryption.decrypt_json(json, key)
    print(json_data)

# Program execution starts here
if __name__ == "__main__":
    main()
