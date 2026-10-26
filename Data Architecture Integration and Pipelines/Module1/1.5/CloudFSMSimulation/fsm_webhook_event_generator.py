import json
import random
import ssl
import time
from datetime import datetime, timedelta
from azure.eventhub import EventData, EventHubProducerClient

# Need to install azure.eventhub to use this script - use pip3 install azure.eventhub

INTERVAL_SECONDS = 2

EVENT_HUB_NAMESPACE = "globo-cloud-fsm"

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

DATE_RANGE_START = datetime(2026, 9, 1, 0, 0, 0)
DATE_RANGE_END = datetime(2026, 9, 30, 23, 59, 59)

ACTIONS = [
    "Insert",
    "Update",
    "Delete",
]

USERS = [
    "Grace",
    "James",
    "Sophie",
    "Oliver",
    "Emily",
]

ENGINEERS = [
    "Tom Smith",
    "Sarah Jones",
    "David Brown",
    "Emma Wilson",
]

# Prefixes used to generate vehicle registrations
VEHICLE_PREFIXES = [
    "AA11",
    "BB22",
    "CC33",
    "DD44",
    "EE55",
    "FF66",
]

def random_datetime(start: datetime, end: datetime) -> datetime:
    """Generates a random date"""
    total_seconds = int((end - start).total_seconds())
    return start + timedelta(seconds=random.randint(0, total_seconds))

# Formats a date
def format_datetime(value: datetime) -> str:
    return value.strftime("%Y-%m-%d %H:%M:%S")

def generate_vehicle() -> str:
    """
    Generates a simulated vehicle registration, e.g.
    AA11 1AA
    """
    prefix = random.choice(VEHICLE_PREFIXES)

    final_character = prefix[-1]
    return f"{prefix} {final_character}{prefix[:2]}"


def generate_document() -> dict:
    """Generates a JSON document to simulate the Webhook"""
    visit_start = random_datetime(
        DATE_RANGE_START,
        DATE_RANGE_END,
    )

    visit_duration_hours = random.randint(1, 4)
    visit_end = visit_start + timedelta(hours=visit_duration_hours)

    visit_id = random.randint(18045, 18500)

    return {
        "DateTime": format_datetime(
            random_datetime(
                DATE_RANGE_START,
                DATE_RANGE_END,
            )
        ),
        "Action": random.choice(ACTIONS),
        "User": random.choice(USERS),
        "VisitId": visit_id,
        "CustomerRef": f"Cust{random.randint(1, 100)}",
        "VisitStart": format_datetime(visit_start),
        "VisitEnd": format_datetime(visit_end),
        "Engineer": random.choice(ENGINEERS),
        "Vehicle": generate_vehicle(),
        "Notes": f"Visit notes {random.randint(1, 30)}",
    }


def create_tls_13_context() -> ssl.SSLContext:
    """Creates SSL context using TLS 1.3 or higher"""
    if not hasattr(ssl, "TLSVersion") or not hasattr(
        ssl.TLSVersion,
        "TLSv1_3",
    ):
        raise RuntimeError(
            "The Python or OpenSSL install does not support TLS 1.3."
        )

    context = ssl.create_default_context()
    context.minimum_version = ssl.TLSVersion.TLSv1_3
    context.maximum_version = ssl.TLSVersion.MAXIMUM_SUPPORTED

    return context

# Main program execution
def main() -> None:
    tls_context = create_tls_13_context()

    producer = EventHubProducerClient.from_connection_string(
        conn_str=EVENT_HUB_CONNECTION_STRING,
        eventhub_name=EVENT_HUB_NAME,
        ssl_context=tls_context,
    )

    print("Sending events. Press Ctrl+C to stop.")

    try:
        with producer:
            while True:
                document = generate_document()

                json_payload = json.dumps(
                    document,
                    separators=(",", ":"),
                )

                event = EventData(json_payload)

                # Send the JSON document to the event hub
                producer.send_batch([event])
                print(json.dumps(document, indent=4))

                time.sleep(INTERVAL_SECONDS)

    except KeyboardInterrupt:
        print("\nStopped.")

# Program execution starts here
if __name__ == "__main__":
    main()
