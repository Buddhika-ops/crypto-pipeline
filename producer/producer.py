import json
import time
import requests
from kafka import KafkaProducer
import os
from dotenv import load_dotenv

load_dotenv()

COINS = ["bitcoin","ethereum","solana","dogecoin"]


KAFKA_BROKER = os.getenv("KAFKA_BROKER")
TOPIC = os.getenv("KAFKA_TOPIC")
POLL_INTERVAL_SECONDS = int(os.getenv("POLL_INTERVAL_SECONDS"))
COINGECKO_URL = os.getenv("COINGECKO_URL")

def create_producer():
    return KafkaProducer(
        bootstrap_servers= [KAFKA_BROKER],
        value_serializer= lambda v: json.dumps(v).encode("utf-8"),
    )

def fetch_prices():
    params={
        "ids":",".join(COINS),
        "vs_currencies": "usd",
        "include_market_cap":"true",
        "include_24hr_vol": "true",
        "include_24hr_change": "true",
        "include_last_updated_at":"true"
    }
    print("Calling CoinGecko...")
    response = requests.get(COINGECKO_URL,params=params,timeout= 10)
    print("API response received")
    response.raise_for_status()
    return response.json()

def main():
    producer = create_producer()
    print(f"Starting producer. Polling every {POLL_INTERVAL_SECONDS}s...")

    while True:
        try:
            data = fetch_prices()
            print("API DATA:")
            print(data)
            timestamp = int(time.time())

            for coin_id, price_info in data.items():
                message = {
                    "coin_id": coin_id,
                    "price_usd": price_info.get("usd"),
                    "market_cap": price_info.get("usd_market_cap"),
                    "volume_24h": price_info.get("usd_24h_vol"),
                    "change_24h_pct": price_info.get("usd_24h_change"),
                    "last_updated_at": price_info.get("last_updated_at"),
                    "ingested_at":timestamp
                }
                producer.send(topic=TOPIC,value=message)
                print(f"Sent: {message}")

            producer.flush()

        except requests.exceptions.RequestException as e :
            print(f"API error: {e}")
        except Exception as e:
            print(f"Unexpected error: {e}")

        time.sleep(POLL_INTERVAL_SECONDS)

if __name__ == "__main__":
    main()
