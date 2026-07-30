CREATE SCHEMA IF NOT EXISTS CRYPTO_DB.GOLD;

CREATE OR REPLACE TABLE CRYPTO_DB.GOLD.DIM_COIN(
    coin_key NUMBER AUTOINCREMENT,
    coin_id varchar,
    create_at TIMESTAMP_NTZ default current_timestamp()
);

CREATE OR REPLACE TABLE CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES(
    coin_id VARCHAR,
    price_usd FLOAT,
    market_cap FLOAT,
    volume_24h FLOAT,
    change_24h_pct FLOAT,
    last_updated_at TIMESTAMP_NTZ,
    ingested_at TIMESTAMP_NTZ,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE CRYPTO_DB.GOLD.FACT_MARKET_SNAPSHOT(
    snapshot_id INT AUTOINCREMENT PRIMARY KEY,
    snapshot_at TIMESTAMP,
    total_market_cap_usd NUMBER,
    total_volume_24h_usd NUMBER,
    btc_dominance_pct NUMBER,
    active_coins_count INT,
    market_cap_change_24h_pct NUMBER,
    ingested_at TIMESTAMP_NTZ,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
