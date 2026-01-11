# Data Processing and ETL Strategy for CANVS

## Comprehensive Research Report: Location-Anchored Social Platform Data Infrastructure

**Version:** 1.0.0
**Date:** January 2026
**Status:** Research Complete
**Related Documents:**
- [Database Architecture](../../specs/tech/mvp/specs/srs/05-database-architecture.md)
- [Tech Specs](../../specs/tech/mvp/specs/tech_specs.md)
- [AI Implementation Architecture](../../specs/tech/parts/ai/ai_implementation_architecture.md)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [CANVS Data Processing Requirements](#2-canvs-data-processing-requirements)
3. [ETL/ELT Tools Analysis](#3-etlelt-tools-analysis)
4. [Stream Processing Solutions](#4-stream-processing-solutions)
5. [Data Pipeline Architectures](#5-data-pipeline-architectures)
6. [Spatial Data Processing](#6-spatial-data-processing)
7. [ML/AI Data Pipeline](#7-mlai-data-pipeline)
8. [Free/Self-Hosted Stack Recommendations](#8-freeself-hosted-stack-recommendations)
9. [Architecture Recommendations](#9-architecture-recommendations)
10. [Implementation Roadmap](#10-implementation-roadmap)

---

## 1. Executive Summary

### The Data Challenge for CANVS

CANVS generates diverse, location-anchored data requiring multiple processing paradigms:

| Data Type | Volume Estimate (1M users) | Processing Type | Latency Requirement |
|-----------|---------------------------|-----------------|---------------------|
| Posts/Pins | 3M/month | Real-time + Batch | <500ms creation |
| Location Events | 500M/month | Stream | <100ms |
| User Interactions | 50M/month | Real-time | <200ms |
| Media Files | 10TB/month | Async Batch | Minutes |
| Embeddings | 5M/month | Near Real-time | <5s |
| Analytics Events | 1B/month | Stream + Batch | Varies |

### Key Recommendations

| Capability | Recommended Solution | Rationale |
|------------|---------------------|-----------|
| **Workflow Orchestration** | Apache Airflow (self-hosted) or Dagster | Free, mature, Python-native |
| **Stream Processing** | Redis Streams + PostgreSQL LISTEN/NOTIFY | Lightweight, integrated with stack |
| **Data Transformation** | dbt (Core) | Free, SQL-based, version controlled |
| **Data Integration** | Airbyte (self-hosted) | Open source, 300+ connectors |
| **Real-time Events** | Supabase Realtime | Already in stack, WebSocket |
| **Spatial Processing** | PostGIS + H3 | Already integrated, proven |
| **ML Pipelines** | Metaflow or Prefect | Python-native, free tier |

### Cost-Optimized Architecture Philosophy

```
"Process at the edge where possible, batch in the cloud where economical"
```

The strategy prioritizes:
- **Free/Open-Source First:** Minimize SaaS dependencies
- **PostgreSQL-Centric:** Leverage existing Supabase infrastructure
- **Event-Driven:** React to changes, don't poll
- **Incremental Processing:** Process only what changed
- **Spatial-Aware:** Optimize for location-based queries

---

## 2. CANVS Data Processing Requirements

### 2.1 Real-Time Processing Needs

**Live Feed Updates:**
```
User opens app → Location update → Query nearby content → Filter by preferences
                     ↓
              Stream process
                     ↓
            < 200ms total latency
```

**Use Cases:**
- Nearby content discovery (location change triggers query)
- Live activity indicators ("5 people viewing this place")
- Real-time engagement counters
- Notification delivery

**Requirements:**
- Sub-second latency for location-based queries
- Support 10K+ concurrent users per region
- Handle location update bursts (when user moves)
- Maintain WebSocket connections for live updates

### 2.2 Batch Processing Needs

**Analytics and Reporting:**
```
Daily/Weekly processes:
- Aggregate engagement metrics
- Calculate place popularity scores
- Generate user activity summaries
- Update content ranking signals
- Train/update ML models
```

**Requirements:**
- Process full dataset efficiently (millions of records)
- Scheduled execution with dependency management
- Retry and error handling
- Data quality checks
- Output to data warehouse for BI

### 2.3 Stream Processing Needs

**Activity Feeds:**
```
Post Created → Embed Generation → Moderation Check → Fan-out to Followers
     ↓              ↓                   ↓                    ↓
   < 1s          < 5s              < 10s              < 30s
```

**Use Cases:**
- New post processing pipeline
- Embedding generation for semantic search
- Content moderation pipeline
- Notification fan-out
- Analytics event collection

### 2.4 Spatial Data Processing Needs

**Location Operations:**
- Coordinate system transformations (WGS84 ↔ local projections)
- H3 cell calculations at multiple resolutions
- Proximity calculations (within radius queries)
- Spatial clustering (identify popular areas)
- Geofence processing (enter/exit detection)
- Heat map generation (activity density)

---

## 3. ETL/ELT Tools Analysis

### 3.1 Apache Airflow (Recommended for Orchestration)

**Overview:** The industry-standard workflow orchestration platform.

**Strengths for CANVS:**
- Free and open source (Apache 2.0 license)
- Mature ecosystem with extensive documentation
- Python-native (DAGs written in Python)
- Large community and plugin ecosystem
- Supports complex dependency graphs
- Built-in monitoring and alerting
- Integrates with all major data tools

**Limitations:**
- Requires infrastructure management
- Not designed for real-time (minimum 1-minute intervals)
- Can be resource-intensive at scale
- Learning curve for DAG development

**Self-Hosted Deployment:**

```yaml
# docker-compose.yml for Airflow
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    volumes:
      - postgres-db-volume:/var/lib/postgresql/data

  airflow-webserver:
    image: apache/airflow:2.8.0
    command: webserver
    ports:
      - "8080:8080"
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    depends_on:
      - postgres

  airflow-scheduler:
    image: apache/airflow:2.8.0
    command: scheduler
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    depends_on:
      - postgres
```

**Cost:** Free (self-hosted) or ~$100-300/month on managed services (Astronomer, MWAA)

**Example CANVS DAG:**

```python
# dags/canvs_daily_analytics.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'canvs-data',
    'depends_on_past': False,
    'email_on_failure': True,
    'email': ['data-team@canvs.app'],
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'canvs_daily_analytics',
    default_args=default_args,
    description='Daily analytics processing for CANVS',
    schedule_interval='0 2 * * *',  # 2 AM daily
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=['analytics', 'daily'],
) as dag:

    # Task 1: Aggregate daily engagement metrics
    aggregate_engagement = PostgresOperator(
        task_id='aggregate_engagement',
        postgres_conn_id='canvs_postgres',
        sql="""
            INSERT INTO analytics.daily_engagement (date, h3_cell_res6, posts, reactions, comments)
            SELECT
                DATE(created_at) as date,
                pa.h3_index_6 as h3_cell_res6,
                COUNT(DISTINCT p.id) as posts,
                SUM(p.reaction_count) as reactions,
                SUM(p.comment_count) as comments
            FROM posts p
            JOIN place_anchors pa ON p.place_anchor_id = pa.id
            WHERE p.created_at >= '{{ ds }}'::date
              AND p.created_at < '{{ ds }}'::date + interval '1 day'
              AND NOT p.is_deleted
            GROUP BY DATE(created_at), pa.h3_index_6
            ON CONFLICT (date, h3_cell_res6)
            DO UPDATE SET
                posts = EXCLUDED.posts,
                reactions = EXCLUDED.reactions,
                comments = EXCLUDED.comments,
                updated_at = NOW();
        """
    )

    # Task 2: Update place popularity scores
    update_place_scores = PostgresOperator(
        task_id='update_place_scores',
        postgres_conn_id='canvs_postgres',
        sql="""
            UPDATE place_anchors pa
            SET popularity_score = subq.score,
                updated_at = NOW()
            FROM (
                SELECT
                    pa.id,
                    (
                        0.4 * COALESCE(pa.follower_count, 0) / NULLIF(MAX(pa.follower_count) OVER(), 0) +
                        0.3 * COALESCE(pa.post_count, 0) / NULLIF(MAX(pa.post_count) OVER(), 0) +
                        0.3 * COALESCE(recent.engagement, 0) / NULLIF(MAX(recent.engagement) OVER(), 0)
                    ) as score
                FROM place_anchors pa
                LEFT JOIN (
                    SELECT place_anchor_id, SUM(reaction_count + comment_count * 2) as engagement
                    FROM posts
                    WHERE created_at > NOW() - interval '7 days'
                    GROUP BY place_anchor_id
                ) recent ON pa.id = recent.place_anchor_id
            ) subq
            WHERE pa.id = subq.id;
        """
    )

    # Task 3: Generate heat map data
    generate_heatmaps = PostgresOperator(
        task_id='generate_heatmaps',
        postgres_conn_id='canvs_postgres',
        sql="""
            INSERT INTO analytics.heatmap_data (date, h3_cell_res8, activity_level, center_lat, center_lng)
            SELECT
                '{{ ds }}'::date,
                pa.h3_index_9 as h3_cell,
                COUNT(*) as activity_level,
                AVG(pa.lat) as center_lat,
                AVG(pa.lng) as center_lng
            FROM posts p
            JOIN place_anchors pa ON p.place_anchor_id = pa.id
            WHERE p.created_at >= '{{ ds }}'::date - interval '7 days'
              AND NOT p.is_deleted
            GROUP BY pa.h3_index_9
            HAVING COUNT(*) > 5
            ON CONFLICT (date, h3_cell_res8) DO UPDATE SET
                activity_level = EXCLUDED.activity_level;
        """
    )

    # Define task dependencies
    aggregate_engagement >> update_place_scores >> generate_heatmaps
```

### 3.2 Dagster (Modern Alternative)

**Overview:** Modern data orchestrator with software engineering best practices.

**Strengths:**
- Software-defined assets (declarative data model)
- Built-in data lineage and observability
- Type-safe data contracts
- Better local development experience
- Modern UI
- Free open-source version

**Limitations:**
- Smaller community than Airflow
- Steeper learning curve for assets model
- Less mature plugin ecosystem

**Best For:** Teams comfortable with modern software practices who want strong data quality guarantees.

### 3.3 Prefect (Workflow Automation)

**Overview:** Python-native workflow orchestration with free tier.

**Strengths:**
- Very Pythonic API
- Free tier for small teams (3 users)
- Excellent error handling
- Dynamic workflows
- Good for ML pipelines

**Limitations:**
- Cloud-first model (self-hosting more complex)
- Less suitable for pure SQL pipelines

### 3.4 dbt (Data Transformation) - HIGHLY RECOMMENDED

**Overview:** The standard for SQL-based data transformation.

**Why dbt for CANVS:**
- **Free Core version** (dbt-core is open source)
- SQL-native (works with existing PostgreSQL skills)
- Version-controlled transformations
- Built-in testing and documentation
- Incremental models for efficiency
- Excellent for analytics engineering

**Example dbt Models for CANVS:**

```sql
-- models/marts/analytics/fct_daily_place_metrics.sql
{{
  config(
    materialized='incremental',
    unique_key='place_date_key',
    partition_by={'field': 'date', 'data_type': 'date'}
  )
}}

WITH posts AS (
    SELECT
        place_anchor_id,
        DATE(created_at) as post_date,
        COUNT(*) as post_count,
        SUM(reaction_count) as total_reactions,
        SUM(comment_count) as total_comments
    FROM {{ ref('stg_posts') }}
    WHERE NOT is_deleted AND NOT is_hidden
    {% if is_incremental() %}
    AND created_at > (SELECT MAX(date) FROM {{ this }})
    {% endif %}
    GROUP BY 1, 2
),

place_details AS (
    SELECT
        id as place_anchor_id,
        h3_index_6,
        h3_index_9,
        lat,
        lng
    FROM {{ ref('stg_place_anchors') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['p.place_anchor_id', 'p.post_date']) }} as place_date_key,
    p.place_anchor_id,
    p.post_date as date,
    pd.h3_index_6,
    pd.h3_index_9,
    pd.lat,
    pd.lng,
    p.post_count,
    p.total_reactions,
    p.total_comments,
    p.total_reactions + (p.total_comments * 2) as engagement_score,
    CURRENT_TIMESTAMP as processed_at
FROM posts p
JOIN place_details pd ON p.place_anchor_id = pd.place_anchor_id
```

```yaml
# models/marts/analytics/schema.yml
version: 2

models:
  - name: fct_daily_place_metrics
    description: Daily aggregated metrics for each place anchor
    columns:
      - name: place_date_key
        description: Surrogate key for place + date combination
        tests:
          - unique
          - not_null
      - name: engagement_score
        description: Weighted engagement score (reactions + 2*comments)
        tests:
          - not_null
          - dbt_utils.expression_is_true:
              expression: ">= 0"
```

**Cost:** Free (dbt-core), or $100/month for dbt Cloud with scheduling

### 3.5 Airbyte (Data Integration) - RECOMMENDED

**Overview:** Open-source data integration platform with 300+ connectors.

**Why Airbyte for CANVS:**
- **Free self-hosted version**
- Pre-built connectors for:
  - Analytics platforms (Amplitude, Mixpanel, GA4)
  - CRM/Support (Zendesk, Intercom)
  - Marketing (Mailchimp, SendGrid)
  - APIs (REST, GraphQL)
- Custom connector SDK
- Incremental sync support
- Schema change detection

**Self-Hosted Deployment:**

```bash
# Deploy Airbyte with Docker
git clone https://github.com/airbytehq/airbyte.git
cd airbyte
./run-ab-platform.sh
```

**Example Use Cases for CANVS:**
- Sync marketing emails to data warehouse
- Import support tickets for analysis
- Sync analytics events to PostgreSQL
- Export data to BI tools

**Cost:** Free (self-hosted), or $200/month+ for cloud

### 3.6 Meltano (Open Source ELT)

**Overview:** GitLab's open-source ELT platform.

**Strengths:**
- 100% free and open source
- Singer ecosystem (500+ taps/targets)
- CLI-first, git-native
- Integrates with dbt
- Good for smaller teams

**Limitations:**
- Smaller community
- Less polished UI
- More DIY setup required

### 3.7 Tool Comparison Matrix

| Tool | Cost | Complexity | Best For | CANVS Fit |
|------|------|------------|----------|-----------|
| **Airflow** | Free (self-host) | Medium-High | Complex DAGs | Excellent |
| **Dagster** | Free (self-host) | Medium | Data quality focus | Good |
| **Prefect** | Free tier | Low-Medium | Python ML pipelines | Good |
| **dbt Core** | Free | Low | SQL transformations | Excellent |
| **Airbyte** | Free (self-host) | Low | Data integration | Excellent |
| **Meltano** | Free | Medium | Full ELT stack | Good |

---

## 4. Stream Processing Solutions

### 4.1 Lightweight Options (Recommended for MVP)

#### Redis Streams

**Overview:** Built-in stream processing in Redis.

**Why Redis Streams for CANVS:**
- Already using Redis for caching
- Simple consumer group model
- Persistence with AOF
- Built-in backpressure handling
- Low latency (<1ms)

**Implementation Pattern:**

```typescript
// services/stream-processor.ts
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

// Producer: Add events to stream
async function publishLocationEvent(userId: string, lat: number, lng: number) {
  await redis.xadd('location-events', '*',
    'user_id', userId,
    'lat', lat.toString(),
    'lng', lng.toString(),
    'timestamp', Date.now().toString()
  );
}

// Consumer: Process location events
async function processLocationEvents() {
  const consumerGroup = 'location-processors';
  const consumerName = `processor-${process.pid}`;

  // Create consumer group if not exists
  try {
    await redis.xgroup('CREATE', 'location-events', consumerGroup, '0', 'MKSTREAM');
  } catch (e) {
    // Group already exists
  }

  while (true) {
    const events = await redis.xreadgroup(
      'GROUP', consumerGroup, consumerName,
      'COUNT', 100,
      'BLOCK', 5000,
      'STREAMS', 'location-events', '>'
    );

    if (events) {
      for (const [stream, messages] of events) {
        for (const [id, fields] of messages) {
          const event = parseFields(fields);

          // Process: Update user's current H3 cell
          await updateUserLocation(event.user_id, event.lat, event.lng);

          // Process: Check for nearby new content
          await checkNearbyContent(event.user_id, event.lat, event.lng);

          // Acknowledge
          await redis.xack('location-events', consumerGroup, id);
        }
      }
    }
  }
}

// Periodic cleanup: Trim old events
setInterval(async () => {
  await redis.xtrim('location-events', 'MAXLEN', '~', 100000);
}, 60000);
```

**Cost:** Included with Redis deployment (~$15-50/month)

#### PostgreSQL LISTEN/NOTIFY

**Overview:** Built-in pub/sub in PostgreSQL.

**Why for CANVS:**
- Zero additional infrastructure
- Triggers on data changes
- Works with Supabase Realtime
- Good for moderate throughput

**Implementation:**

```sql
-- Create notification trigger
CREATE OR REPLACE FUNCTION notify_post_created()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM pg_notify(
    'new_post',
    json_build_object(
      'id', NEW.id,
      'user_id', NEW.user_id,
      'place_anchor_id', NEW.place_anchor_id,
      'h3_cell', (SELECT h3_index_9 FROM place_anchors WHERE id = NEW.place_anchor_id)
    )::text
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_post_created
AFTER INSERT ON posts
FOR EACH ROW
EXECUTE FUNCTION notify_post_created();
```

```typescript
// Listen for notifications
import { Client } from 'pg';

const client = new Client(process.env.DATABASE_URL);
await client.connect();
await client.query('LISTEN new_post');

client.on('notification', async (msg) => {
  const payload = JSON.parse(msg.payload);

  // Trigger embedding generation
  await queueEmbeddingGeneration(payload.id);

  // Notify users following this area
  await notifyAreaFollowers(payload.h3_cell, payload.id);
});
```

### 4.2 Scalable Options (For Growth)

#### Apache Kafka

**Overview:** Distributed event streaming platform.

**When CANVS Needs Kafka:**
- >100K events/second
- Multi-datacenter deployment
- Event replay requirements
- Complex event routing

**Managed Options:**
- **Confluent Cloud:** $0.10/GB ingress, free tier available
- **AWS MSK Serverless:** Pay-per-use
- **Upstash Kafka:** Serverless, $0.10/100K messages

**Architecture with Kafka:**

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Mobile    │────▶│   Kafka     │────▶│  Consumers  │
│    Apps     │     │   Topics    │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
                          │
              ┌───────────┼───────────┐
              │           │           │
              ▼           ▼           ▼
         ┌─────────┐ ┌─────────┐ ┌─────────┐
         │location │ │  posts  │ │analytics│
         │ events  │ │  events │ │ events  │
         └─────────┘ └─────────┘ └─────────┘
```

#### Apache Flink

**Overview:** Stateful stream processing framework.

**Best For:**
- Complex event processing (CEP)
- Windowed aggregations
- Real-time ML inference
- Exactly-once semantics

**Use Case for CANVS:**
- Real-time trending places detection
- Anomaly detection (spam, abuse patterns)
- Session analysis

#### Apache Spark Streaming (Structured Streaming)

**Overview:** Batch-style API for stream processing.

**Best For:**
- Teams familiar with Spark
- Mixed batch/streaming workloads
- Large-scale data processing

### 4.3 Stream Processing Decision Tree

```
                    ┌─────────────────────────────────────┐
                    │  What's the event volume?           │
                    └─────────────────┬───────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              │                       │                       │
              ▼                       ▼                       ▼
        < 10K/sec               10K-100K/sec             > 100K/sec
              │                       │                       │
              ▼                       ▼                       ▼
     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
     │  Redis Streams  │     │  Redis Streams  │     │  Apache Kafka   │
     │  + PostgreSQL   │     │  + Kafka Lite   │     │  + Flink/Spark  │
     │  LISTEN/NOTIFY  │     │  (Upstash)      │     │                 │
     └─────────────────┘     └─────────────────┘     └─────────────────┘
           MVP                   Growth                   Scale
```

---

## 5. Data Pipeline Architectures

### 5.1 Lambda Architecture (Batch + Speed Layers)

**Overview:** Combines batch and real-time processing.

```
                     ┌─────────────────────────────────────┐
                     │              Raw Data                │
                     └─────────────────┬───────────────────┘
                                       │
                     ┌─────────────────┼─────────────────┐
                     │                 │                 │
                     ▼                 │                 ▼
            ┌─────────────────┐        │        ┌─────────────────┐
            │   Speed Layer   │        │        │   Batch Layer   │
            │   (Real-time)   │        │        │   (Historical)  │
            │                 │        │        │                 │
            │ • Redis Streams │        │        │ • Airflow + dbt │
            │ • Quick views   │        │        │ • Full recompute│
            └────────┬────────┘        │        └────────┬────────┘
                     │                 │                 │
                     └─────────────────┼─────────────────┘
                                       │
                                       ▼
                            ┌─────────────────────┐
                            │   Serving Layer     │
                            │   (Query Results)   │
                            └─────────────────────┘
```

**CANVS Implementation:**

| Layer | Technology | Data |
|-------|------------|------|
| Speed | Redis + Supabase Realtime | Live engagement, active users |
| Batch | Airflow + dbt | Historical analytics, ML features |
| Serving | PostgreSQL + Redis Cache | API responses |

**Pros:**
- Handles both real-time and complex queries
- Batch layer corrects speed layer errors
- Proven at scale

**Cons:**
- Code duplication (two processing paths)
- Complexity of maintaining two systems

### 5.2 Kappa Architecture (Stream-Only)

**Overview:** All data as streams, batch as special case.

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Event Stream                                 │
│                       (Single Source)                                │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Stream Processing Layer                           │
│                                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐│
│  │ Real-time   │  │ Windowed    │  │ Historical  │  │ Reprocessing ││
│  │ Views       │  │ Aggregates  │  │ Replay      │  │ (Backfill)   ││
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘│
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
                    ┌─────────────────────┐
                    │   Serving Layer     │
                    └─────────────────────┘
```

**When to Use:**
- True real-time requirements
- Simpler codebase (one path)
- Event-sourced systems

**Not Ideal For:**
- Complex historical analysis
- ML model training
- Ad-hoc queries on historical data

### 5.3 Modern Data Stack (Recommended for CANVS)

**Overview:** Best-of-breed tools for each layer.

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Data Sources                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐    │
│  │  App DB  │  │Analytics │  │Marketing │  │  External APIs   │    │
│  │(Supabase)│  │(Amplitude)│  │(Mailchimp)│  │  (Google Maps)  │    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┬─────────┘    │
└───────┼─────────────┼─────────────┼─────────────────┼───────────────┘
        │             │             │                 │
        ▼             ▼             ▼                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Ingestion Layer (Airbyte)                       │
│         Extract data from sources, load to warehouse                 │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  Data Warehouse (PostgreSQL/Supabase)                │
│                                                                      │
│    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐        │
│    │    Raw       │    │   Staging    │    │    Marts     │        │
│    │   (bronze)   │───▶│   (silver)   │───▶│    (gold)    │        │
│    └──────────────┘    └──────────────┘    └──────────────┘        │
│                                                                      │
│                        Transformed by dbt                            │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Consumption Layer                                │
│    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐        │
│    │     BI       │    │     ML       │    │ Application  │        │
│    │  (Metabase)  │    │  Pipelines   │    │    APIs      │        │
│    └──────────────┘    └──────────────┘    └──────────────┘        │
└─────────────────────────────────────────────────────────────────────┘
```

**CANVS Implementation:**

| Layer | Tool | Purpose |
|-------|------|---------|
| Sources | Supabase, Amplitude, Mailchimp | Operational + Analytics data |
| Ingestion | Airbyte | Extract & Load |
| Warehouse | PostgreSQL (Supabase) | Single source of truth |
| Transform | dbt | SQL transformations |
| Orchestrate | Airflow | Schedule & monitor |
| BI | Metabase | Self-serve analytics |
| Reverse ETL | Census/Hightouch (optional) | Sync to tools |

### 5.4 Data Mesh Considerations

**Overview:** Decentralized, domain-oriented data ownership.

**When CANVS Might Need This:**
- Multiple independent product teams
- Different data domains with separate ownership
- Need for federated governance

**Data Domains for CANVS:**
- **Places Domain:** Location anchors, spatial data, H3 indices
- **Content Domain:** Posts, media, moderation
- **Users Domain:** Profiles, preferences, social graph
- **Engagement Domain:** Reactions, comments, notifications
- **Analytics Domain:** Aggregated metrics, ML features

**Implementation Pattern:**

```
┌────────────────────────────────────────────────────────────────┐
│                    Federated Data Platform                      │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │Places Domain │  │Content Domain│  │ Users Domain │         │
│  │              │  │              │  │              │         │
│  │ • place_*    │  │ • posts      │  │ • users      │         │
│  │ • spatial_*  │  │ • media      │  │ • follows    │         │
│  │ • h3_*       │  │ • comments   │  │ • prefs      │         │
│  │              │  │              │  │              │         │
│  │ Owner: Geo   │  │ Owner: Core  │  │Owner: Growth │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              Shared Data Contracts & Catalog             │   │
│  └─────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────┘
```

---

## 6. Spatial Data Processing

### 6.1 Coordinate System Transformations

**Common Operations for CANVS:**

```sql
-- WGS84 (GPS) to Geography for distance calculations
SELECT ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography;

-- Convert to local projection for area calculations (example: NYC)
SELECT ST_Transform(
    ST_SetSRID(ST_MakePoint(-74.0060, 40.7128), 4326),
    2263  -- NAD83 / New York Long Island
);

-- Calculate distance in meters
SELECT ST_Distance(
    ST_SetSRID(ST_MakePoint(-74.0060, 40.7128), 4326)::geography,
    ST_SetSRID(ST_MakePoint(-73.9857, 40.7484), 4326)::geography
) as distance_meters;
```

**Batch Processing Pattern:**

```python
# Airflow task: Update H3 cells for all places
def update_h3_indices():
    """Recalculate H3 indices at multiple resolutions."""
    query = """
    UPDATE place_anchors
    SET
        h3_index_12 = h3_lat_lng_to_cell(lat, lng, 12),
        h3_index_9 = h3_lat_lng_to_cell(lat, lng, 9),
        h3_index_6 = h3_lat_lng_to_cell(lat, lng, 6),
        updated_at = NOW()
    WHERE h3_index_12 IS NULL
       OR updated_at < NOW() - interval '30 days';
    """
    execute_sql(query)
```

### 6.2 Spatial Clustering Algorithms

**Use Case:** Identify popular areas, detect content clusters.

**K-Means Clustering with PostGIS:**

```sql
-- Create function for spatial clustering
CREATE OR REPLACE FUNCTION cluster_places(
    min_cluster_size INTEGER DEFAULT 5,
    num_clusters INTEGER DEFAULT 100
)
RETURNS TABLE (
    cluster_id INTEGER,
    center_lat DOUBLE PRECISION,
    center_lng DOUBLE PRECISION,
    place_count INTEGER,
    total_posts INTEGER
) AS $$
BEGIN
    RETURN QUERY
    WITH clustered AS (
        SELECT
            pa.id,
            pa.lat,
            pa.lng,
            pa.post_count,
            ST_ClusterKMeans(
                ST_SetSRID(ST_MakePoint(pa.lng, pa.lat), 4326),
                num_clusters
            ) OVER() as cluster_id
        FROM place_anchors pa
        WHERE pa.post_count > 0
    )
    SELECT
        c.cluster_id::INTEGER,
        AVG(c.lat) as center_lat,
        AVG(c.lng) as center_lng,
        COUNT(*)::INTEGER as place_count,
        SUM(c.post_count)::INTEGER as total_posts
    FROM clustered c
    GROUP BY c.cluster_id
    HAVING COUNT(*) >= min_cluster_size
    ORDER BY total_posts DESC;
END;
$$ LANGUAGE plpgsql;
```

**DBSCAN for Density-Based Clustering:**

```sql
-- Identify dense areas with DBSCAN
SELECT
    ST_ClusterDBSCAN(
        location::geometry,
        eps := 100,  -- 100 meter radius
        minpoints := 3
    ) OVER() as cluster_id,
    id,
    lat,
    lng
FROM place_anchors
WHERE post_count > 0;
```

### 6.3 Geofence Processing

**Real-Time Geofence Detection:**

```typescript
// services/geofence-processor.ts
import * as h3 from 'h3-js';

interface Geofence {
  id: string;
  centerLat: number;
  centerLng: number;
  radiusMeters: number;
  h3Cells: string[];  // Pre-computed H3 cells
}

class GeofenceProcessor {
  private geofences: Map<string, Geofence> = new Map();

  async precomputeGeofenceCells(geofence: Geofence): Promise<string[]> {
    // Get H3 cells that cover the geofence
    const centerCell = h3.latLngToCell(
      geofence.centerLat,
      geofence.centerLng,
      9  // Resolution 9 (~174m hexagons)
    );

    // Get ring of cells based on radius
    const ringSize = Math.ceil(geofence.radiusMeters / 174);
    return h3.gridDisk(centerCell, ringSize);
  }

  async checkUserLocation(
    userId: string,
    lat: number,
    lng: number
  ): Promise<string[]> {
    const userCell = h3.latLngToCell(lat, lng, 9);
    const triggeredGeofences: string[] = [];

    for (const [id, geofence] of this.geofences) {
      if (geofence.h3Cells.includes(userCell)) {
        // Quick H3 check passed, do precise distance check
        const distance = this.haversineDistance(
          lat, lng,
          geofence.centerLat, geofence.centerLng
        );

        if (distance <= geofence.radiusMeters) {
          triggeredGeofences.push(id);
        }
      }
    }

    return triggeredGeofences;
  }

  private haversineDistance(
    lat1: number, lng1: number,
    lat2: number, lng2: number
  ): number {
    const R = 6371000; // Earth radius in meters
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLng = (lng2 - lng1) * Math.PI / 180;
    const a =
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLng/2) * Math.sin(dLng/2);
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  }
}
```

### 6.4 Heat Map Generation

**Batch Processing for Activity Heat Maps:**

```sql
-- Generate hourly heat map data by H3 cell
CREATE TABLE IF NOT EXISTS analytics.hourly_heatmaps (
    hour TIMESTAMPTZ NOT NULL,
    h3_cell TEXT NOT NULL,
    resolution INTEGER NOT NULL,
    activity_count INTEGER,
    unique_users INTEGER,
    center_lat DOUBLE PRECISION,
    center_lng DOUBLE PRECISION,
    PRIMARY KEY (hour, h3_cell, resolution)
);

-- Populate heat map (run hourly via Airflow)
INSERT INTO analytics.hourly_heatmaps (hour, h3_cell, resolution, activity_count, unique_users, center_lat, center_lng)
SELECT
    date_trunc('hour', created_at) as hour,
    pa.h3_index_9 as h3_cell,
    9 as resolution,
    COUNT(*) as activity_count,
    COUNT(DISTINCT p.user_id) as unique_users,
    AVG(pa.lat) as center_lat,
    AVG(pa.lng) as center_lng
FROM posts p
JOIN place_anchors pa ON p.place_anchor_id = pa.id
WHERE p.created_at >= NOW() - interval '2 hours'
GROUP BY date_trunc('hour', created_at), pa.h3_index_9
ON CONFLICT (hour, h3_cell, resolution)
DO UPDATE SET
    activity_count = EXCLUDED.activity_count,
    unique_users = EXCLUDED.unique_users;
```

**API for Heat Map Tiles:**

```typescript
// api/heatmap.ts
async function getHeatmapData(
  bounds: { north: number; south: number; east: number; west: number },
  resolution: number = 9,
  hours: number = 24
): Promise<HeatmapCell[]> {
  // Get H3 cells within bounds
  const h3Cells = getH3CellsInBounds(bounds, resolution);

  const result = await db.query(`
    SELECT
      h3_cell,
      SUM(activity_count) as intensity,
      center_lat,
      center_lng
    FROM analytics.hourly_heatmaps
    WHERE h3_cell = ANY($1)
      AND hour >= NOW() - interval '${hours} hours'
      AND resolution = $2
    GROUP BY h3_cell, center_lat, center_lng
  `, [h3Cells, resolution]);

  return result.rows.map(row => ({
    cell: row.h3_cell,
    lat: row.center_lat,
    lng: row.center_lng,
    intensity: normalizeIntensity(row.intensity)
  }));
}
```

---

## 7. ML/AI Data Pipeline

### 7.1 Feature Engineering Pipeline

**Overview:** Prepare data for ML models (recommendations, rankings, moderation).

**Feature Store Pattern:**

```sql
-- Feature store schema
CREATE SCHEMA IF NOT EXISTS features;

-- User features (updated daily)
CREATE TABLE features.user_features (
    user_id UUID PRIMARY KEY,

    -- Activity features
    days_since_signup INTEGER,
    total_posts INTEGER,
    total_reactions_given INTEGER,
    total_comments INTEGER,
    posts_last_7d INTEGER,
    posts_last_30d INTEGER,

    -- Engagement features
    avg_reactions_received DECIMAL(10, 2),
    avg_comments_received DECIMAL(10, 2),
    engagement_percentile DECIMAL(5, 2),

    -- Spatial features
    unique_places_visited INTEGER,
    avg_post_distance_from_home DECIMAL(10, 2),
    primary_h3_cells TEXT[],

    -- Content preferences (from embeddings)
    category_preferences JSONB,  -- {'memory': 0.6, 'utility': 0.2, 'culture': 0.2}

    -- Metadata
    computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Place features (updated daily)
CREATE TABLE features.place_features (
    place_anchor_id UUID PRIMARY KEY,

    -- Basic features
    total_posts INTEGER,
    total_unique_posters INTEGER,
    total_followers INTEGER,

    -- Temporal features
    posts_last_7d INTEGER,
    posts_last_30d INTEGER,
    avg_posts_per_day_30d DECIMAL(10, 2),

    -- Engagement features
    total_reactions INTEGER,
    total_comments INTEGER,
    avg_engagement_per_post DECIMAL(10, 2),

    -- Spatial features
    h3_index_6 TEXT,
    h3_index_9 TEXT,
    nearby_places_count INTEGER,  -- Within 500m

    -- Category distribution
    category_distribution JSONB,

    -- Computed scores
    popularity_score DECIMAL(5, 4),
    trending_score DECIMAL(5, 4),

    computed_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Feature Computation DAG:**

```python
# dags/ml_feature_pipeline.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

with DAG(
    'ml_feature_pipeline',
    default_args={'retries': 2},
    schedule_interval='0 4 * * *',  # 4 AM daily
    start_date=datetime(2026, 1, 1),
) as dag:

    def compute_user_features():
        """Compute user-level features for ML models."""
        query = """
        INSERT INTO features.user_features (
            user_id, days_since_signup, total_posts, total_reactions_given,
            total_comments, posts_last_7d, posts_last_30d, avg_reactions_received,
            avg_comments_received, engagement_percentile, unique_places_visited,
            primary_h3_cells, category_preferences
        )
        SELECT
            u.id as user_id,
            EXTRACT(DAY FROM NOW() - u.created_at)::INTEGER as days_since_signup,
            COALESCE(posts.total, 0) as total_posts,
            COALESCE(reactions.given, 0) as total_reactions_given,
            COALESCE(comments.total, 0) as total_comments,
            COALESCE(posts.last_7d, 0) as posts_last_7d,
            COALESCE(posts.last_30d, 0) as posts_last_30d,
            COALESCE(engagement.avg_reactions, 0) as avg_reactions_received,
            COALESCE(engagement.avg_comments, 0) as avg_comments_received,
            PERCENT_RANK() OVER (ORDER BY COALESCE(engagement.total, 0)) as engagement_percentile,
            COALESCE(places.unique_count, 0) as unique_places_visited,
            COALESCE(places.top_cells, '{}') as primary_h3_cells,
            COALESCE(prefs.categories, '{}'::jsonb) as category_preferences
        FROM users u
        LEFT JOIN (...) posts ON posts.user_id = u.id
        LEFT JOIN (...) reactions ON reactions.user_id = u.id
        LEFT JOIN (...) comments ON comments.user_id = u.id
        LEFT JOIN (...) engagement ON engagement.user_id = u.id
        LEFT JOIN (...) places ON places.user_id = u.id
        LEFT JOIN (...) prefs ON prefs.user_id = u.id
        ON CONFLICT (user_id) DO UPDATE SET
            days_since_signup = EXCLUDED.days_since_signup,
            total_posts = EXCLUDED.total_posts,
            ...
            computed_at = NOW();
        """
        execute_sql(query)

    def compute_place_features():
        """Compute place-level features for ML models."""
        # Similar pattern for place features
        pass

    def validate_features():
        """Run data quality checks on features."""
        checks = [
            "SELECT COUNT(*) FROM features.user_features WHERE engagement_percentile < 0 OR engagement_percentile > 1",
            "SELECT COUNT(*) FROM features.place_features WHERE popularity_score < 0",
        ]
        for check in checks:
            result = execute_sql(check)
            if result > 0:
                raise ValueError(f"Feature validation failed: {check}")

    compute_users = PythonOperator(
        task_id='compute_user_features',
        python_callable=compute_user_features,
    )

    compute_places = PythonOperator(
        task_id='compute_place_features',
        python_callable=compute_place_features,
    )

    validate = PythonOperator(
        task_id='validate_features',
        python_callable=validate_features,
    )

    [compute_users, compute_places] >> validate
```

### 7.2 Embedding Generation at Scale

**Architecture:**

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   New Content   │────▶│  Embedding      │────▶│   pgvector      │
│   (Posts)       │     │  Queue (Redis)  │     │   Storage       │
└─────────────────┘     └────────┬────────┘     └─────────────────┘
                                 │
                                 ▼
                        ┌─────────────────┐
                        │  Embedding      │
                        │  Workers (N)    │
                        │                 │
                        │ • Batch calls   │
                        │ • Rate limiting │
                        │ • Retry logic   │
                        └─────────────────┘
```

**Batch Embedding Worker:**

```typescript
// workers/embedding-worker.ts
import OpenAI from 'openai';
import { createClient } from 'redis';

const openai = new OpenAI();
const redis = createClient();

const BATCH_SIZE = 100;
const MAX_TOKENS_PER_BATCH = 8000;

interface EmbeddingJob {
  id: string;
  type: 'post' | 'user_preference';
  text: string;
}

async function processEmbeddingQueue() {
  while (true) {
    // Get batch of jobs
    const jobs: EmbeddingJob[] = [];
    let totalTokens = 0;

    while (jobs.length < BATCH_SIZE) {
      const job = await redis.rpop('embedding-queue');
      if (!job) break;

      const parsed = JSON.parse(job) as EmbeddingJob;
      const tokens = estimateTokens(parsed.text);

      if (totalTokens + tokens > MAX_TOKENS_PER_BATCH) {
        // Put it back and process current batch
        await redis.lpush('embedding-queue', job);
        break;
      }

      jobs.push(parsed);
      totalTokens += tokens;
    }

    if (jobs.length === 0) {
      await sleep(1000);
      continue;
    }

    // Batch API call
    const embeddings = await generateEmbeddings(jobs.map(j => j.text));

    // Store embeddings
    await storeEmbeddings(jobs.map((job, i) => ({
      id: job.id,
      type: job.type,
      embedding: embeddings[i]
    })));

    console.log(`Processed ${jobs.length} embeddings`);
  }
}

async function generateEmbeddings(texts: string[]): Promise<number[][]> {
  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: texts,
    encoding_format: 'float'
  });

  return response.data.map(d => d.embedding);
}

async function storeEmbeddings(items: { id: string; type: string; embedding: number[] }[]) {
  const values = items.map(item =>
    `('${item.id}', '[${item.embedding.join(',')}]'::vector)`
  ).join(',');

  await db.query(`
    INSERT INTO content_embeddings (id, embedding)
    VALUES ${values}
    ON CONFLICT (id) DO UPDATE SET
      embedding = EXCLUDED.embedding,
      updated_at = NOW();
  `);
}
```

### 7.3 Training Data Preparation

**Export Training Data for External Training:**

```sql
-- Export user-content interaction data for recommendation model
COPY (
    SELECT
        u.id as user_id,
        p.id as post_id,
        pa.h3_index_9 as location_cell,
        p.category,
        CASE
            WHEN r.id IS NOT NULL THEN 1
            WHEN c.id IS NOT NULL THEN 2
            ELSE 0
        END as interaction_type,
        EXTRACT(EPOCH FROM p.created_at) as timestamp
    FROM users u
    CROSS JOIN LATERAL (
        SELECT * FROM posts
        WHERE created_at > NOW() - interval '90 days'
        LIMIT 10000
    ) p
    JOIN place_anchors pa ON p.place_anchor_id = pa.id
    LEFT JOIN reactions r ON r.post_id = p.id AND r.user_id = u.id
    LEFT JOIN comments c ON c.post_id = p.id AND c.user_id = u.id
    WHERE r.id IS NOT NULL OR c.id IS NOT NULL
)
TO '/tmp/training_data.csv' WITH CSV HEADER;
```

**Incremental Training Data Pipeline:**

```python
# Using Metaflow for ML training pipeline
from metaflow import FlowSpec, step, Parameter, card

class CANVSRecommenderTraining(FlowSpec):

    training_days = Parameter('training_days', default=90)

    @step
    def start(self):
        """Load configuration and initialize."""
        print(f"Training on {self.training_days} days of data")
        self.next(self.extract_data)

    @step
    def extract_data(self):
        """Extract training data from database."""
        self.interactions = load_interactions(days=self.training_days)
        self.user_features = load_user_features()
        self.item_features = load_place_features()
        self.next(self.prepare_features)

    @step
    def prepare_features(self):
        """Prepare features for training."""
        self.X_train, self.X_test, self.y_train, self.y_test = \
            prepare_training_data(
                self.interactions,
                self.user_features,
                self.item_features
            )
        self.next(self.train_model)

    @card
    @step
    def train_model(self):
        """Train recommendation model."""
        from sklearn.ensemble import GradientBoostingClassifier

        self.model = GradientBoostingClassifier(
            n_estimators=100,
            max_depth=6,
            learning_rate=0.1
        )
        self.model.fit(self.X_train, self.y_train)

        # Evaluate
        self.accuracy = self.model.score(self.X_test, self.y_test)
        print(f"Model accuracy: {self.accuracy}")
        self.next(self.end)

    @step
    def end(self):
        """Export model."""
        if self.accuracy > 0.7:  # Quality threshold
            save_model(self.model, f'recommender_v{get_version()}')

if __name__ == '__main__':
    CANVSRecommenderTraining()
```

### 7.4 Model Serving Infrastructure

**Simple Model Serving with FastAPI:**

```python
# services/ml-api/main.py
from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np

app = FastAPI()

# Load models at startup
recommender_model = joblib.load('models/recommender_latest.joblib')
ranking_model = joblib.load('models/ranking_latest.joblib')

class RecommendationRequest(BaseModel):
    user_id: str
    user_features: dict
    candidate_ids: list[str]
    candidate_features: list[dict]

class RecommendationResponse(BaseModel):
    ranked_ids: list[str]
    scores: list[float]

@app.post("/recommend", response_model=RecommendationResponse)
async def recommend(request: RecommendationRequest):
    # Prepare feature matrix
    features = prepare_inference_features(
        request.user_features,
        request.candidate_features
    )

    # Get scores
    scores = recommender_model.predict_proba(features)[:, 1]

    # Sort by score
    ranked_indices = np.argsort(scores)[::-1]

    return RecommendationResponse(
        ranked_ids=[request.candidate_ids[i] for i in ranked_indices],
        scores=[float(scores[i]) for i in ranked_indices]
    )

@app.get("/health")
async def health():
    return {"status": "healthy"}
```

---

## 8. Free/Self-Hosted Stack Recommendations

### 8.1 Complete Open Source Stack

**Recommended Stack for CANVS MVP:**

| Component | Tool | Cost | Notes |
|-----------|------|------|-------|
| **Primary Database** | PostgreSQL (Supabase) | $25/mo | Already in stack |
| **Vector Store** | pgvector | $0 | Extension on PostgreSQL |
| **Stream Processing** | Redis Streams | $15/mo | Upstash or self-hosted |
| **Workflow Orchestration** | Airflow (self-hosted) | $50/mo VPS | Or use Supabase Edge |
| **Data Transformation** | dbt Core | $0 | Free open source |
| **Data Integration** | Airbyte (self-hosted) | $50/mo VPS | Or manual connectors |
| **Business Intelligence** | Metabase | $0 | Self-hosted |
| **Feature Store** | Custom PostgreSQL | $0 | Tables + dbt models |
| **ML Training** | Metaflow | $0 | Local or cloud runners |

**Total: ~$140/month** (vs $500+ for managed services)

### 8.2 Cloud Free Tiers

**Services with Generous Free Tiers:**

| Service | Free Tier | Use Case |
|---------|-----------|----------|
| **Supabase** | 500MB DB, 1GB storage | Primary backend |
| **Vercel** | 100GB bandwidth | Frontend + Edge functions |
| **Upstash Redis** | 10K commands/day | Caching, streams |
| **Upstash Kafka** | 10K messages/day | Event streaming |
| **PlanetScale** | 5GB storage | Backup/DR database |
| **Neon PostgreSQL** | 3GB storage | Dev/staging environment |
| **Modal** | $30/mo credits | ML model serving |
| **Railway** | $5/mo credits | Worker services |
| **Cloudflare R2** | 10GB storage | Media storage |

### 8.3 Self-Hosted Infrastructure

**Docker Compose for Data Stack:**

```yaml
# docker-compose.data.yml
version: '3.8'

services:
  # Airflow for orchestration
  airflow-webserver:
    image: apache/airflow:2.8.0
    ports:
      - "8080:8080"
    volumes:
      - ./dags:/opt/airflow/dags
      - ./logs:/opt/airflow/logs
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@airflow-db/airflow

  airflow-scheduler:
    image: apache/airflow:2.8.0
    command: scheduler
    volumes:
      - ./dags:/opt/airflow/dags
      - ./logs:/opt/airflow/logs
    depends_on:
      - airflow-webserver

  airflow-db:
    image: postgres:15
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    volumes:
      - airflow-db-data:/var/lib/postgresql/data

  # Metabase for BI
  metabase:
    image: metabase/metabase:latest
    ports:
      - "3000:3000"
    environment:
      MB_DB_TYPE: postgres
      MB_DB_DBNAME: metabase
      MB_DB_PORT: 5432
      MB_DB_USER: metabase
      MB_DB_PASS: metabase
      MB_DB_HOST: metabase-db

  metabase-db:
    image: postgres:15
    environment:
      POSTGRES_USER: metabase
      POSTGRES_PASSWORD: metabase
      POSTGRES_DB: metabase
    volumes:
      - metabase-db-data:/var/lib/postgresql/data

  # Redis for caching and streams
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes

  # Optional: Airbyte for data integration
  # airbyte:
  #   ... (see Airbyte docs for full config)

volumes:
  airflow-db-data:
  metabase-db-data:
  redis-data:
```

### 8.4 Cost-Effective Scaling Strategies

**Tier 1: MVP (0-10K users) - ~$100/month**
```
Supabase Pro: $25
Vercel Pro: $20
Upstash Redis: $15
Self-hosted Airflow (Railway): $20
Cloudflare R2: $10
Metabase (self-hosted): $10 VPS
```

**Tier 2: Growth (10K-100K users) - ~$500/month**
```
Supabase Team: $100
Vercel Pro: $50
Upstash Redis Pro: $50
Managed Airflow (Astronomer): $100
Cloudflare R2: $50
Kafka (Upstash): $50
Metabase Cloud: $100
```

**Tier 3: Scale (100K-1M users) - ~$3,000/month**
```
Supabase Enterprise: $500
Vercel Enterprise: $500
Redis Enterprise: $300
Airflow (dedicated): $300
Kafka (Confluent): $500
Data warehouse (Snowflake): $500
BI tools: $400
```

---

## 9. Architecture Recommendations

### 9.1 Recommended Architecture for CANVS

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              CANVS Data Architecture                                 │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                               DATA SOURCES                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │
│  │  Mobile App  │  │  Web PWA     │  │  Admin Panel │  │  External    │            │
│  │  (Posts,     │  │  (Browse,    │  │  (Moderation │  │  (Analytics, │            │
│  │  Location)   │  │  Discover)   │  │  Reports)    │  │  Marketing)  │            │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘            │
└─────────┼──────────────────┼──────────────────┼──────────────────┼──────────────────┘
          │                  │                  │                  │
          ▼                  ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                          REAL-TIME LAYER (Supabase)                                  │
│  ┌───────────────────────────────────────────────────────────────────────────────┐  │
│  │                          PostgreSQL + PostGIS + H3                             │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │  │
│  │  │   posts     │  │place_anchors│  │   users     │  │ interactions│          │  │
│  │  │ + pgvector  │  │ + spatial   │  │ + prefs     │  │ + reactions │          │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘          │  │
│  └───────────────────────────────────────────────────────────────────────────────┘  │
│                                        │                                             │
│  ┌──────────────────┐         ┌────────┴────────┐         ┌──────────────────┐      │
│  │ Supabase Auth    │         │ Realtime        │         │  Edge Functions  │      │
│  │ (Magic Links)    │         │ (WebSocket)     │         │  (Moderation)    │      │
│  └──────────────────┘         └─────────────────┘         └──────────────────┘      │
└─────────────────────────────────────────────────────────────────────────────────────┘
          │                                                            │
          ▼                                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                           STREAM PROCESSING LAYER                                    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │                              Redis Streams                                   │    │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │    │
│  │  │  location-   │  │  embedding-  │  │notification- │  │  analytics-  │     │    │
│  │  │  events      │  │  queue       │  │  queue       │  │  events      │     │    │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘     │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                        │                                             │
│                            ┌───────────┴───────────┐                                │
│                            │   Stream Workers      │                                │
│                            │   (Node.js/Python)    │                                │
│                            └───────────────────────┘                                │
└─────────────────────────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                            BATCH PROCESSING LAYER                                    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │                         Apache Airflow                                       │    │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐           │    │
│  │  │  Daily Analytics │  │  Feature         │  │  ML Training     │           │    │
│  │  │  DAG             │  │  Engineering DAG │  │  Pipeline        │           │    │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘           │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                        │                                             │
│                            ┌───────────┴───────────┐                                │
│                            │   dbt Transformations │                                │
│                            │   (SQL Models)        │                                │
│                            └───────────────────────┘                                │
└─────────────────────────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              ANALYTICS LAYER                                         │
│  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐               │
│  │   Analytics DB    │  │   Feature Store   │  │   ML Models       │               │
│  │   (PostgreSQL)    │  │   (PostgreSQL)    │  │   (FastAPI)       │               │
│  └─────────┬─────────┘  └─────────┬─────────┘  └─────────┬─────────┘               │
│            │                      │                      │                          │
│            └──────────────────────┼──────────────────────┘                          │
│                                   ▼                                                  │
│                         ┌───────────────────┐                                       │
│                         │     Metabase      │                                       │
│                         │   (Dashboards)    │                                       │
│                         └───────────────────┘                                       │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 9.2 Data Flow Patterns

**Pattern 1: New Post Creation**
```
1. User creates post in app
2. Supabase stores post in PostgreSQL
3. PostgreSQL trigger queues embedding job to Redis
4. Embedding worker processes queue
   - Generate text embedding (OpenAI API)
   - Generate image embedding if present (CLIP)
   - Store in pgvector
5. PostgreSQL trigger notifies content moderation
6. Edge function runs moderation check
7. If approved, broadcast via Realtime to nearby users
```

**Pattern 2: Nearby Content Discovery**
```
1. User opens map at location (lat, lng)
2. API receives request with location
3. Query PostgreSQL:
   - Spatial filter: ST_DWithin for radius
   - H3 filter: Match user's H3 cell
   - Vector filter: pgvector similarity to user preferences
4. Check Redis cache for recent results
5. If cache miss:
   - Run Reality Filter (Claude API)
   - Cache results for 5 minutes
6. Return ranked content to user
```

**Pattern 3: Daily Analytics Pipeline**
```
1. Airflow triggers at 2 AM
2. dbt runs staging models (clean raw data)
3. dbt runs mart models (aggregate metrics)
4. dbt runs feature models (ML features)
5. Airflow validates data quality
6. Airflow exports to feature store
7. Metabase dashboards auto-refresh
```

### 9.3 Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Real-time vs Batch** | Hybrid (Lambda-lite) | Best of both for CANVS use cases |
| **Stream Processing** | Redis Streams | Lightweight, integrated with cache |
| **Orchestration** | Airflow | Industry standard, free, flexible |
| **Transformation** | dbt | SQL-native, version-controlled |
| **Vector Store** | pgvector | Integrated, no extra service |
| **Feature Store** | Custom PostgreSQL | Keep stack simple |
| **ML Serving** | FastAPI | Simple, Python-native |
| **BI Tool** | Metabase | Free, self-hosted |

---

## 10. Implementation Roadmap

### 10.1 Phase 1: Foundation (Weeks 1-4)

**Objective:** Establish core data infrastructure.

**Tasks:**
- [ ] Set up PostgreSQL schemas (raw, staging, mart, features)
- [ ] Configure pgvector extension
- [ ] Implement Redis Streams for event queuing
- [ ] Create basic dbt project structure
- [ ] Deploy self-hosted Metabase

**Deliverables:**
- Database schema documentation
- Initial dbt models for staging
- Basic analytics dashboard

### 10.2 Phase 2: ETL Pipeline (Weeks 5-8)

**Objective:** Build automated data pipelines.

**Tasks:**
- [ ] Deploy Airflow (Docker or managed)
- [ ] Create daily analytics DAG
- [ ] Implement embedding generation pipeline
- [ ] Build feature engineering pipeline
- [ ] Set up data quality monitoring

**Deliverables:**
- Running Airflow instance
- Daily analytics pipeline
- Feature store populated

### 10.3 Phase 3: Real-Time Processing (Weeks 9-12)

**Objective:** Enable real-time features.

**Tasks:**
- [ ] Implement location event streaming
- [ ] Build notification pipeline
- [ ] Create real-time activity feeds
- [ ] Optimize query performance
- [ ] Implement caching strategy

**Deliverables:**
- Real-time content discovery
- Live engagement indicators
- Sub-second query responses

### 10.4 Phase 4: ML Integration (Weeks 13-16)

**Objective:** Deploy ML-powered features.

**Tasks:**
- [ ] Build training data export pipeline
- [ ] Train initial recommendation model
- [ ] Deploy model serving API
- [ ] Integrate with Reality Filter
- [ ] Implement A/B testing framework

**Deliverables:**
- Personalized content ranking
- ML-powered recommendations
- Model monitoring dashboard

### 10.5 Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Query latency (P95) | <200ms | API monitoring |
| Embedding generation | <5s per post | Queue metrics |
| Pipeline reliability | >99% DAG success | Airflow dashboard |
| Data freshness | <1 hour for analytics | dbt tests |
| Feature coverage | >90% users | Feature store queries |

---

## References

### ETL/ELT Tools
- [Apache Airflow Documentation](https://airflow.apache.org/docs/)
- [dbt Documentation](https://docs.getdbt.com/)
- [Airbyte Documentation](https://docs.airbyte.com/)
- [Dagster Documentation](https://docs.dagster.io/)
- [Prefect Documentation](https://docs.prefect.io/)

### Stream Processing
- [Redis Streams Documentation](https://redis.io/docs/data-types/streams/)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Apache Flink Documentation](https://flink.apache.org/docs/)

### Spatial Processing
- [PostGIS Documentation](https://postgis.net/documentation/)
- [H3 Documentation](https://h3geo.org/docs/)
- [Uber H3 Hexagonal Hierarchical Geospatial Indexing System](https://eng.uber.com/h3/)

### Vector Databases
- [pgvector Documentation](https://github.com/pgvector/pgvector)
- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)

### ML Pipelines
- [Metaflow Documentation](https://docs.metaflow.org/)
- [MLflow Documentation](https://mlflow.org/docs/latest/)

### Data Architecture Patterns
- [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/)
- [Designing Data-Intensive Applications](https://dataintensive.net/)
- [Data Mesh Principles](https://martinfowler.com/articles/data-mesh-principles.html)

---

*Document generated: January 2026*
*Author: CANVS Data Architecture Research*
*Next review: Prior to implementation kickoff*
