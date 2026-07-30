CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.COIN_SUMMARY_STATS AS
SELECT
    coin_id,
    AVG(price_usd) AS avg_price,
    MIN(price_usd) AS min_price,
    MAX(price_usd) AS max_price,
    AVG(volume_24h) AS avg_volume_24h,
    AVG(change_24h_pct) AS avg_change_24h_pct,
    COUNT(*) AS data_points,
    MIN(last_updated_at) AS earliest_snapshot,
    MAX(last_updated_at) AS latest_snapshot
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES
GROUP BY coin_id
ORDER BY coin_id;