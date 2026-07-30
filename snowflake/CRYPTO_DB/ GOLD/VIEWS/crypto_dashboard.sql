CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.CRYPTO_DASHBOARD AS
SELECT
    f.coin_id,
    f.price_usd,
    f.market_cap,
    f.volume_24h,
    f.change_24h_pct,
    f.last_updated_at
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES f
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY f.coin_id
    ORDER BY f.last_updated_at DESC
) = 1
ORDER BY f.market_cap DESC;