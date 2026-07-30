CREATE OR REPLACE VIEW  CRYPTO_DB.GOLD.MARKET_OVERVIEW AS
SELECT
    snapshot_at,
    total_market_cap_usd,
    total_volume_24h_usd,
    btc_dominance_pct,
    active_coins_count,
    market_cap_change_24h_pct
FROM CRYPTO_DB.GOLD.FACT_MARKET_SNAPSHOT
QUALIFY ROW_NUMBER() OVER (ORDER BY snapshot_at DESC) =1;