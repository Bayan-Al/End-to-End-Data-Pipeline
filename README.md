 # End-to-End Data Pipeline & Analytics Portfolio: Saudi Commercial Ecosystem

## Overview

This repository houses a production-grade, end-to-end data pipeline and analytics solution built to ingest, orchestrate, transform, and visualize public commercial data across the Kingdom of Saudi Arabia. Designed with a modern data stack, the architecture seamlessly moves data from a transactional PostgreSQL source (Supabase) to a cloud data warehouse (Google BigQuery) via Airbyte, automates workflows using Mage AI, transforms data cleanly using dbt, and delivers executive-level business intelligence through Power BI.

---

## Architecture & Tech Stack

```
[ Supabase (PostgreSQL) ] 
       │
       ▼ (Airbyte Ingestion)
[ Google BigQuery (Data Warehouse) ]
       │
       ▼ (dbt Modeling & Transformations)
[ Mage AI (Orchestration & Automation) ]
       │
       ▼ (Power BI Dashboards & Reporting)
[ Executive Insights & KPI Reporting ]

```

* **Source Database**: Supabase (PostgreSQL) storing raw financial and commercial entity records.


* **Data Ingestion**: Airbyte for automated, reliable data synchronization.


* **Data Warehouse**: Google BigQuery acting as the centralized analytical storage layer.


* **Transformation & Modeling**: `dbt` (Data Build Tool) utilizing a robust star schema (`staging`, `dim_table`, `fact_table`).


* **Orchestration**: Mage AI managing pipeline dependencies and daily automated runs.


* **Business Intelligence**: Power BI (`Saudi Commercial Analytics.pbit`) featuring interactive star schema relationships and custom DAX measures.



---

## Project Structure

```text
End-to-End-Data-Pipeline/
│
├── supabase/                 # Source PostgreSQL schema and database definitions
│
├── airbyte/                  # Ingestion connectors and configuration syncs
│
├── bigquery/                 # BigQuery dataset structures and schema overviews
│
├── dbt/                      # dbt transformation models (`saudi_commercial_dbt`)
│   ├── models/
│   │   ├── 1.staging/        # Staging views with text cleaning and deduplication
│   │   └── 2.mart/           # Dimensional and fact tables (`dim_table`, `fact_table`)
│   └── dbt_project.yml       # Project configuration and materialization rules
│
├── mage/                     # Mage AI orchestration pipelines and API scripts
│   ├── data_loader.py        # Python script triggering Airbyte API syncs
│   └── pipeline run logs     # Execution metrics and DAG configurations
│
└── power_bi/                 # Analytical dashboards and data model exports
    ├── Saudi Commercial Analytics.pbit
    └── visuals/              # Visual exports (Regional breakdowns, business types, KPIs)

```

---

## Pipeline Components

### 1. Ingestion & Orchestration (`mage/` & `airbyte/`)

* **Automated Scheduling**: Configured via Mage AI to execute daily data pipeline runs connecting Supabase to Google BigQuery.


* **API Triggering**: Utilizes programmatic data loader scripts (`data_loader.py`) to trigger Airbyte sync jobs securely through REST API payloads.


* **Performance**: Optimized execution times averaging ~40 seconds per full pipeline refresh.




### 2. Data Modeling & Transformation (`dbt/`)

The transformation layer is structured into rigorous modular tiers:

* **Staging Layer (`staging_layer.sql`)**: Cleans raw strings using `nullif(trim(...))` to handle missing/`NA` values safely, applies `safe_cast` typing, and executes a window function (`row_number() over (partition by id order by _airbyte_extracted_at desc)`) to guarantee zero duplicates based on the latest extraction timestamp.


* **Dimensional Table (`dim_table.sql`)**: Materialized table capturing entity profiles, geographical attributes (city, region, district), commercial record details, and communication/social media selling channels.


* **Fact Table (`fact_table.sql`)**: Materialized table isolating quantitative metrics such as store ratings, total reviews, refund days, and exchange periods linked via `business_id`.




### 3. Business Intelligence & Analytics (`power_bi/`)

The Power BI semantic model implements a clean star schema connecting `dim_table` and `fact_table` in a 1-to-1 relationship, supported by a dedicated `measures_table`. Key analytical dashboards highlight:

* **Executive KPIs**: Tracking over 71K total stores, an average rating of 4.50, 91K total reviews, and a 51.70% overall gold certification rate.


* **Regional Distribution**: Deep dives across major Saudi provinces including Riyadh, Makkah, and the Eastern Province.


* **Business Classifications**: Visual breakdowns analyzing online stores, merchant categories, and return/exchange policy compliance.



---

## Key Technical Highlights

* **Idempotent Data Pipelines**: Deduplication logic built straight into the dbt staging layer ensures robust handling of repeated extractions.
* **Modern Analytics Engineering**: Separation of concerns across raw ingestion, staging views, dimensional modeling, orchestration, and BI visualization.




---
