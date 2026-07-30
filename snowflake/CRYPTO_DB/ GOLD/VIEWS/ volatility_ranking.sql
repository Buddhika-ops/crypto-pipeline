CREATE OR REPLACE VIEW CRYPTO_DB.GOLD.VOLATILITY_RANKING AS
SELECT
    coin_id,
    STDDEV(price_usd) AS price_volatility,
    AVG(price_usd) AS avg_price,
    MIN(price_usd) AS min_price,
    MAX(price_usd) AS max_price,
    COUNT(*) AS data_points
FROM CRYPTO_DB.GOLD.FACT_CRYPTO_PRICES
GROUP BY coin_id
ORDER BY price_volatility DESC;