CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.TOP_MOVERS AS
WITH latest_prices AS
(
    SELECT 
        f.coin_id, 
        f.price_usd,
        f.volume_24h,
        f.change_24h_pct,
        f.last_updated_at,
        ROW_NUMBER() OVER(
            PARTITION BY f.coin_id
            ORDER BY f.last_updated_at DESC
        )AS rn
    FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES f 
)
SELECT
    coin_id, 
    price_usd,
    volume_24h,
    change_24h_pct,
    last_updated_at
FROM latest_prices
WHERE rn = 1
ORDER BY change_24h_pct DESC;