import json
import os
from kafka import KafkaConsumer
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()

TOPIC = os.getenv("KAFKA_TOPIC")
KAFKA_BROKER = os.getenv("KAFKA_BROKER")

def create_consumer():
    return KafkaConsumer(
        TOPIC,
        bootstrap_servers=[KAFKA_BROKER],
        value_deserializer= lambda x: json.loads(x.decode("utf-8")),
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        group_id="crypto-snowflake-loader"
    )
def create_snowflake_connection():
    return snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
        schema=os.getenv("SNOWFLAKE_SCHEMA"),
        database=os.getenv("SNOWFLAKE_DATABASE")
    )

def insert_price(conn,message):
    cursor = conn.cursor()
    sql ="""
    INSERT INTO CRYPTO_PRICES_RAW
    (
        coin_id,
        price_usd,
        market_cap,
        volume_24h,  
        change_24h_pct,
        last_updated_at,
        ingested_at
    )VALUES
    (%s,%s,%s,%s,%s,
    TO_TIMESTAMP(%s),
    TO_TIMESTAMP(%s))
    """
    cursor.execute(
        sql,
        (
            message["coin_id"],
            message["price_usd"],
            message["market_cap"],
            message["volume_24h"],
            message["change_24h_pct"],
            message["last_updated_at"],
            message["ingested_at"]
        )
    )
    conn.commit()
    cursor.close()

def main():
    consumer = create_consumer()
    snowflake_conn = create_snowflake_connection()

    print("Consumer started...")

    for msg in consumer:
        data = msg.value

        print("Received:")
        print(data)

        insert_price(
            conn=snowflake_conn,
            message=data
        )
if __name__ == "__main__":
    main()