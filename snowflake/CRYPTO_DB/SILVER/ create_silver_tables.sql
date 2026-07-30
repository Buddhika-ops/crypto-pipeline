CREATE SCHEMA IF NOT EXISTS CRYPTO_DB.SILVER;

CREATE OR REPLACE TABLE CRYPTO_DB.SILVER.CRYPTO_PRICES_CLEAN(
    coin_id VARCHAR,
    price_usd FLOAT,
    market_cap FLOAT,
    volume_24h FLOAT,
    change_24h_pct FLOAT,
    last_updated_at TIMESTAMP_NTZ,
    ingested_at TIMESTAMP_NTZ,
    processed_at TIMESTAMP_NTZ
);
