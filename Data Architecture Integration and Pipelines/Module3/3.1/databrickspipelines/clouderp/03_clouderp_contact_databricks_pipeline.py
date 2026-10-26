import dlt

from pyspark.sql.types import (
  StructType,
  StructField,
  StringType,
  IntegerType,
  ArrayType
)
from pyspark.sql import functions as F

# Run this script in Databricks

TABLE_NAME = "globodata.bronze.clouderp_contact"
TABLE_COMMENT = "Bronze events received from Azure Event Hub"

EVENT_HUB_NAMESPACE = "globo-events"

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

KAFKA_OPTIONS = {
  "kafka.bootstrap.servers"  : f"{EVENT_HUB_NAMESPACE}.servicebus.windows.net:9093",
  "subscribe"                : EVENT_HUB_NAME,
  "kafka.sasl.mechanism"     : "PLAIN",
  "kafka.security.protocol"  : "SASL_SSL",
  "kafka.sasl.jaas.config"   : f"kafkashaded.org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"{EVENT_HUB_CONNECTION_STRING}\";",
  "kafka.request.timeout.ms" : 60000,
  "kafka.session.timeout.ms" : 30000,
  "maxOffsetsPerTrigger"     : 50000,
  "failOnDataLoss"           : "false",
  "startingOffsets"          : "latest"
}

SUB_DATA_SCHEMA = StructType([
    StructField("Id", StringType(), True),
    StructField("OurRef", StringType(), True),
    StructField("Title", StringType(), True),
    StructField("Gender", StringType(), True),
    StructField("CompanyName", StringType(), True),
    StructField("Name", StringType(), True),
    StructField("Address", StringType(), True)
])

BASE_EVENT_SCHEMA = StructType([
    StructField("Call", StringType(), True),
    StructField("DateTime", StringType(), True),
    StructField("Action", StringType(), True),
    StructField("User", StringType(), True),
    StructField("Data", SUB_DATA_SCHEMA, True)
])

@dlt.table(
    name = TABLE_NAME,
    comment = TABLE_COMMENT,
    table_properties = {
        "quality": "bronze",
        "delta.autoOptimize.optimizeWrite": "true",
        "delta.autoOptimize.autoCompact": "true"
    }
)
@dlt.expect_or_drop(
    "valid_action",
    "Call IN ('GetCustomer', 'GetSupplier')"
)
@dlt.expect_or_drop(
    "valid_event",
    """
    Call IS NOT NULL
    AND EntryDate IS NOT NULL
    AND Action IS NOT NULL
    """
)
def cloud_erp_events():
    raw_events = (
        spark.readStream
        .format("kafka")
        .options(**KAFKA_OPTIONS)
        .load()
    )

    parsed_events = (
        raw_events
        .select(
            F.from_json(
                F.col("value").cast("string"),
                BASE_EVENT_SCHEMA
            ).alias("event")
        )
        .select("event.*")
    )

    return (
        parsed_events
        .select(
            F.col("Call").cast("string").alias("Call"),

            F.to_timestamp(
                F.col("DateTime"),
                "yyyy-MM-dd HH:mm:ss"
            ).alias("EntryDate"),

            F.col("Action").cast("string").alias("Action"),
            F.col("User").cast("string").alias("User"),
            F.col("Data.Id").cast("string").alias("Id"),
            F.col("Data.OurRef").cast("string").alias("OurRef"),
            F.col("Data.Title").cast("string").alias("Title"),
            F.col("Data.Gender").cast("string").alias("Gender"),
            F.col("Data.CompanyName").cast("string").alias("CompanyName"),
            F.col("Data.Name").cast("string").alias("Name"),
            F.col("Data.Address").cast("string").alias("Address"),
            F.current_timestamp().alias("importdate")
        )
    )