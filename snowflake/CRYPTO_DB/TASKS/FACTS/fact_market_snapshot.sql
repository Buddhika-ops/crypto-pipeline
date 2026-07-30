CREATE OR REPLACE TASK CRYPTO_DB.TASKS.FACT_MARKET_SNAPSHOT
WAREHOUSE = CRYPTO_WH
AFTER CRYPTO_DB.TASKS.LOAD_FACT_COIN_PRICES_TASK
AS
INSERT INTO 
CRYPTO_DB.GOLD.FACT_MARKET_SNAPSHOT(
    snapshot_at,
    total_market_cap_usd,
    total_volume_24h_usd,
    btc_dominance_pct,
    active_coins_count,
    market_cap_change_24h_pct,
    ingested_at,
    loaded_at
)
SELECT 
    f.last_updated_at,
    SUM(f.market_cap),
    SUM(f.volume_24h),
    SUM(CASE WHEN d.coin_id = 'bitcoin' THEN f.market_cap ELSE 0 END)/ SUM(f.market_cap) * 100,
    COUNT(DISTINCT f.coin_id),
    AVG(f.change_24h_pct),
    MAX(f.ingested_at),
    CURRENT_TIMESTAMP()
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES f
JOIN CRYPTO_DB.GOLD.DIM_COIN d
    ON f.coin_id = d.coin_id
GROUP BY f.last_updated_at;