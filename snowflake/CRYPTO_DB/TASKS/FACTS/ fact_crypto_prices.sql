CREATE OR REPLACE TASK CRYPTO_DB.TASKS.LOAD_FACT_COIN_PRICES_TASK
WAREHOUSE = CRYPTO_WH
AFTER CRYPTO_DB.TASKS.LOAD_DIM_COIN_TASK
AS
INSERT INTO  CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES(
    coin_id, 
    price_usd,
    market_cap,
    volume_24h,
    change_24h_pct,
    last_updated_at,
    ingested_at,
    loaded_at
)
SELECT
    d.coin_id, 
    s.price_usd,
    s.market_cap,
    s.volume_24h,
    s.change_24h_pct,
    s.last_updated_at,
    s.ingested_at,
    CURRENT_TIMESTAMP()
FROM CRYPTO_DB.SILVER.CRYPTO_PRICES_CLEAN s
JOIN CRYPTO_DB.GOLD.DIM_COIN d
    ON s.coin_id = d.coin_id
WHERE NOT EXISTS
    (
        SELECT 1
        FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES g
        WHERE g.coin_id = d.coin_id
        AND g.ingested_at =s.ingested_at
);