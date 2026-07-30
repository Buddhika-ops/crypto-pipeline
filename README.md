# Crypto Data Pipeline
 
A real-time crypto data pipeline: ingests live prices via Kafka, loads them into Snowflake through a medallion architecture (Raw → Silver → Gold), and visualizes the results in a Metabase dashboard.

 ## Diagram

 <img width="1122" height="532" alt="crypto_prices drawio" src="https://github.com/user-attachments/assets/75b13699-e25a-45b1-ba8c-7e05746fc324" />

 ## Features

- Live cryptocurrency price ingestion from the CoinGecko API
- Real-time streaming with Apache Kafka
- Snowflake Medallion Architecture (Raw → Silver → Gold)
- Automated data processing with Snowflake Tasks
- Incremental loading using watermark tracking
- Star schema with dimension and fact tables
- Analytical Gold views for reporting
- Interactive Metabase dashboard

## Architecture
 
```
CoinGecko API
      │
      ▼
Python Producer (Kafka)
      │
      ▼
Kafka Topic: crypto_prices
      │
      ▼
Python Consumer
      │
      ▼
Snowflake RAW.CRYPTO_PRICES_RAW
      │
      ▼  (CLEAN_CRYPTO_PRICES_TASK)
Snowflake SILVER.CRYPTO_PRICES_CLEAN
      │
      ▼  (LOAD_DIM_COIN_TASK → LOAD_FACT_COIN_PRICES_TASK → FACT_MARKET_SNAPSHOT)
Snowflake GOLD (dim_coin, fact_crypto_prices, fact_market_snapshot)
      │
      ▼
Gold Views (top_movers, price_history, market_overview, ...)
      │
      ▼
Metabase Dashboard
```

## Tech Stack

| Category | Technology |
|----------|------------|
| Language | Python |
| Streaming | Apache Kafka |
| Data Warehouse | Snowflake |
| Scheduling | Snowflake Tasks |
| Containerization | Docker |
| Visualization | Metabase |
| Version Control | Git & GitHub |

## Project Structure
 
```
crypto-pipeline/
├── producer/           # Kafka producer (pulls from CoinGecko API)
├── consumer/           # Kafka consumer (writes to Snowflake RAW)
├── snowflake/
│   └── CRYPTO_DB/
│       ├── RAW/         # Raw table DDL
│       ├── SILVER/      # Cleaned table DDL
│       ├── TASKS/       # Scheduled task SQL (clean, dim, fact, snapshot)
│       └── GOLD/        # Dimension, fact, and view SQL
├── docs/                # Notes / diagrams
├── docker-compose.yml   # Kafka + Zookeeper local setup
├── requirements.txt
├── .env.example
└── .gitignore
```
 ## Data Model
 
**Dimension**
- `dim_coin` — coin reference table (coin_key, coin_id)
**Facts**
- `fact_crypto_prices` — one row per coin per snapshot (price, market cap, volume, % change)
- `fact_market_snapshot` — one row per snapshot, aggregated across all coins (total market cap, BTC dominance, etc.)
**Gold Views**
- `crypto_dashboard` — latest snapshot per coin, sorted by market cap
- `top_movers` — coins ranked by 24h % change
- `market_overview` — latest market-wide snapshot
- `price_history` — full price history per coin, for trend charts
- `volatility_ranking` — coins ranked by volatility
- `market_cap_leaders` — coins ranked by market cap
- `coin_summary_stats` — min/max/avg price stats per coin


## Pipeline Schedule
 
The task chain runs every **5 minutes**:
```
CLEAN_CRYPTO_PRICES_TASK (root, scheduled)
   → UPDATE_WATERMARK_TASK
   → LOAD_DIM_COIN_TASK
   → LOAD_FACT_COIN_PRICES_TASK
   → FACT_MARKET_SNAPSHOT
```

## Setup
 
1. Clone the repo
2. Copy `.env.example` to `.env` and fill in your values
3. Start Kafka locally:
```bash
   docker-compose up -d
```
4. Install Python dependencies:
```bash
   pip install -r requirements.txt
```
5. Run the producer and consumer
6. Deploy the SQL scripts in `snowflake/` in the following order:
    1. RAW
    2. SILVER
    3. GOLD
    4. TASKS
7. Connect Metabase to Snowflake and import the dashboard

## Start Producer

```bash
   python producer/producer.py
```

## Start Consumer

```bash
   python consumer/consumer.py
```

## Dashboard
 
Built in Metabase, connected directly to the Snowflake `GOLD` schema. Includes:
- Live price trend chart (filterable by coin)
- Top gainers/losers
- Market cap leaders
- Market-wide KPI cards (total market cap, volume, BTC dominance)

## Dashboard Preview

Add screenshots here.
- docs/screenshots/


## Status
 
Actively collecting live data. Task history and pipeline runs can be checked via:
```sql
SELECT * FROM TABLE(CRYPTO_DB.INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY SCHEDULED_TIME DESC;
```

## Future Improvements

- Integrate dbt for SQL model management
- Deploy Kafka using Kubernetes
- Add CI/CD with GitHub Actions
- Add alerting for task failures
- Support additional cryptocurrency APIs
