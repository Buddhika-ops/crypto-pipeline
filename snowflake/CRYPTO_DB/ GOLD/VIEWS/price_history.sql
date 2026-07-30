CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.PRICE_HISTORY AS
SELECT
    f.coin_id,
    f.price_usd,
    f.market_cap,
    f.volume_24h,
    f.change_24h_pct,
    f.last_updated_at
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES f
ORDER BY f.coin_id, f.last_updated_at;