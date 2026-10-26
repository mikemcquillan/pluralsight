import psycopg
from typing import Tuple
from dataclasses import dataclass

# Query to pull columns for the specified table in the specified schema
VALIDATION_QUERY = """
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'TARGET_SCHEMA'
    AND table_name = 'TARGET_TABLE'
    ORDER BY ordinal_position;
    """

@dataclass(frozen=True)
class DataContract:
    schema_name: str
    table_name: str
    required_columns: Tuple[str, ...]

def validate_data_contract(
    conn_string,
    contract
) -> tuple[bool, str]:
    """
    Validate the columns in the data contract

    Returns a tuple. Bool is true if the contract is valid.
    The string is blank if successful, otherwise it contains failure reasons.
    """

    try:
        with psycopg.connect(conn_string) as conn:

            query = VALIDATION_QUERY.replace("TARGET_SCHEMA", contract.schema_name)
            query = query.replace("TARGET_TABLE", contract.table_name)
        
            # Obtain column names for the specified table
            with conn.cursor() as cursor:
                cursor.execute(query)

                database_columns = {
                    row[0].lower()
                    for row in cursor.fetchall()
                }

            expected_columns = {
                column.lower()
                for column in contract.required_columns
            }

            # Determine if any columns are missing
            missing_columns = expected_columns - database_columns

            if missing_columns:
                missing_columns_text = ", ".join(
                    sorted(missing_columns)
                )

                return (
                    False,
                    f"Columns are missing: {missing_columns_text}"
                )

            return True, ""

    except psycopg.Error as error:
        return (
            False,
            f"Could not validate contract - error: {error}"
        )