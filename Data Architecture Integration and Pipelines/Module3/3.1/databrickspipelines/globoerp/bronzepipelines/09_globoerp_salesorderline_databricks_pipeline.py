import dlt

from pyspark.sql.types import (
  StructType,
  StructField,
  StringType,
  IntegerType,
  BooleanType,
  DecimalType
)
from pyspark.sql.functions import col, current_timestamp

# Run this script in Databricks

TABLE_NAME = "globodata.bronze.globoerp_salesorderline"
TABLE_COMMENT = "Bronze events received from Azure Blob Storage CSV files"

# Use Azure Blob Storage container - configuration here
storage_account = "globomantics"
storage_container = "imports"
storage_path = "uploads/globoerp/salesorderline"
sas_token = "TOKEN"

spark.conf.set(
    f"fs.azure.sas.{storage_container}.{storage_account}.blob.core.windows.net",
    sas_token
)

source_path = (
    f"wasbs://{storage_container}@{storage_account}.blob.core.windows.net/"
    f"{storage_path}"
)

DATA_SCHEMA = StructType([
    StructField("salesorderid", IntegerType(), True),
    StructField("warehousecode", StringType(), True),
    StructField("productid", IntegerType(), True),
    StructField("ordinal", IntegerType(), True),
    StructField("quantity", IntegerType(), True),
    StructField("itemprice", StringType(), True),
    StructField("linetotal", StringType(), True),
    StructField("lastupdatedby", StringType(), True),
    StructField("lastupdated", StringType(), True)
])

@dlt.table(
    name = TABLE_NAME,
    comment = TABLE_COMMENT
)
def globoerp_bronze_import():
    return (
        spark.readStream
        .format("cloudFiles")
        .option("cloudFiles.format", "csv")
        .option("cloudFiles.includeExistingFiles", "true")
        .option("header", "true")
        .option("delimiter", "|")
        .option("quote", '"')
        .option("escape", '"')
        .option("mode", "PERMISSIVE")
        .option("rescuedDataColumn", "_rescued_data")
        .schema(DATA_SCHEMA)
        .load(source_path)
        .withColumn("sourcefilename", col("_metadata.file_name"))
        .withColumn("importdate", current_timestamp())
        .drop("_metadata")
    )
