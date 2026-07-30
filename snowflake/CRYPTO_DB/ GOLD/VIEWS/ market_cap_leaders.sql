CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.MARKET_CAP_LEADERS AS
SELECT
    coin_id,
    market_cap,
    price_usd,
    change_24h_pct,
    volume_24h,
    last_updated_at,
    RANK() OVER (ORDER BY market_cap DESC) AS market_cap_rank
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY coin_id
    ORDER BY last_updated_at DESC
) = 1
ORDER BY market_cap_rank;