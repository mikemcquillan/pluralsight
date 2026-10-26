import json
import random
import ssl
import time
from datetime import datetime, timedelta

from azure.eventhub import EventData, EventHubProducerClient

# Need to install azure.eventhub to use this script - use pip3 install azure.eventhub

# Generate and send one JSON document every two seconds.
INTERVAL_SECONDS = 2

EVENT_HUB_NAMESPACE = "globomantics"

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

# All of these lists/constants are used to generate random events
SCANNER_IDS = [
    "UK WH 01",
    "UK WH 02",
    "US WH 01",
    "US WH 02",
    "NL WH 01",
    "NL WH 02",
]

ACTIONS = [
    "Scanned",
    "Picked",
    "Packed",
    "Dispatched",
]

WAREHOUSES = [
    "WH1",
    "WH2",
    "WH3",
]

ORDER_NUMBER_MIN = 10000
ORDER_NUMBER_MAX = 99999

QUANTITY_MIN = 1
QUANTITY_MAX = 100

PRODUCT_NUMBER_MIN = 1
PRODUCT_NUMBER_MAX = 100

# Inclusive date range for generated DateTime values
DATE_RANGE_START = datetime(2026, 9, 1, 0, 0, 0)
DATE_RANGE_END = datetime(2026, 9, 30, 23, 59, 59)

def random_datetime(start: datetime, end: datetime) -> datetime:
    """Generates a random date"""
    total_seconds = int((end - start).total_seconds())
    random_seconds = random.randint(0, total_seconds)
    return start + timedelta(seconds=random_seconds)

def country_from_scanner_id(scanner_id: str) -> str:
    """Obtain the country name from the scanner"""
    for country in ("UK", "US", "NL"):
        if country in scanner_id:
            return country

    raise ValueError(f"Scanner ID does not contain a supported country: {scanner_id}")


def generate_document() -> dict:
    """Create a JSON event"""
    scanner_id = random.choice(SCANNER_IDS)

    return {
        "ScannerId": scanner_id,
        "DateTime": random_datetime(
            DATE_RANGE_START,
            DATE_RANGE_END,
        ).strftime("%Y-%m-%d %H:%M:%S"),
        "Action": random.choice(ACTIONS),
        "OrderNumber": random.randint(
            ORDER_NUMBER_MIN,
            ORDER_NUMBER_MAX,
        ),
        "OrderType": random.choice(
            [
                "SalesOrder",
                "PurchaseOrder",
            ]
        ),
        "Warehouse": random.choice(WAREHOUSES),
        "Country": country_from_scanner_id(scanner_id),
        "ProductCode": f"BATT{random.randint(PRODUCT_NUMBER_MIN, PRODUCT_NUMBER_MAX)}",
        "Quantity": random.randint(
            QUANTITY_MIN,
            QUANTITY_MAX,
        ),
    }


def create_tls_13_context() -> ssl.SSLContext:
    """
    Creates SSL context using TLS 1.3 or higher
    """
    context = ssl.create_default_context()

    if not hasattr(ssl, "TLSVersion") or not hasattr(ssl.TLSVersion, "TLSv1_3"):
        raise RuntimeError(
            "The Python or OpenSSL install does not support TLS 1.3."
        )

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

    print("Sending events. Press Ctrl+C to stop.")

    try:
        with producer:
            # Send events until interrupted
            while True:
                document = generate_document()
                json_payload = json.dumps(document, separators=(",", ":"))

                event = EventData(json_payload)
                producer.send_batch([event])

                print(json.dumps(document, indent=4))

                time.sleep(INTERVAL_SECONDS)

    except KeyboardInterrupt:
        print("\nStopped.")

# Program execution starts here
if __name__ == "__main__":
    main()
