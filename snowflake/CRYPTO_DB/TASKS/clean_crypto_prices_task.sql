CREATE OR REPLACE TASK CRYPTO_DB.TASKS.CLEAN_CRYPTO_PRICES_TASK
WAREHOUSE = CRYPTO_WH
SCHEDULE = '5 MINUTE'

AS

INSERT INTO CRYPTO_DB.SILVER.CRYPTO_PRICES_CLEAN
(
    coin_id,
    price_usd,
    market_cap,
    volume_24h,
    change_24h_pct,
    last_updated_at,
    ingested_at,
    processed_at
)

SELECT
    coin_id,
    price_usd,
    market_cap,
    volume_24h,
    change_24h_pct,
    last_updated_at,
    ingested_at,
    CURRENT_TIMESTAMP()
FROM(
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY coin_id,ingested_at
            ORDER BY ingested_at DESC
        )AS rn
    FROM CRYPTO_DB.RAW.CRYPTO_PRICES_RAW
    
    WHERE 
        ingested_at >(
            SELECT 
                last_processed_at
            FROM CRYPTO_DB.SILVER.ETL_WATERMARK
            WHERE 
                pipeline_name = 'crypto_prices'
        
        ) AND
        price_usd IS NOT NULL AND
        volume_24h IS NOT NULL AND
        price_usd > 0 
    )
WHERE rn = 1;