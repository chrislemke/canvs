# CANVS Data Collection Strategy

**Version:** 1.0.0
**Last Updated:** January 2026
**Status:** Research

---

## Executive Summary

Data is the foundation of CANVS's value proposition. Every interaction on the platform generates learning opportunities that improve the product, personalize experiences, and build a defensible first-party data asset. This document outlines a comprehensive data collection strategy that maximizes learning while respecting user privacy and complying with global regulations.

**Core Philosophy:** "Collect with purpose, store with care, use with transparency."

---

## 1. Types of Data to Collect

### 1.1 User Behavior Data (Behavioral Telemetry)

The foundation of product analytics - understanding how users interact with CANVS.

| Data Category | Events | Purpose |
|---------------|--------|---------|
| **Navigation** | `screen_viewed`, `tab_switched`, `mode_changed` | UX optimization |
| **Engagement** | `post_viewed`, `post_tapped`, `scroll_depth` | Content relevance |
| **Creation** | `create_started`, `media_added`, `post_submitted` | Funnel optimization |
| **Social** | `reaction_added`, `comment_submitted`, `profile_viewed` | Feature adoption |
| **Discovery** | `search_performed`, `filter_applied`, `cluster_expanded` | Algorithm tuning |
| **Session** | `app_opened`, `app_backgrounded`, `session_duration` | Retention analysis |

**Implicit Signals (High Value):**

```yaml
implicit_signals:
  dwell_time:
    description: "Time spent viewing a specific post"
    threshold: ">3 seconds = meaningful engagement"
    use_case: "Content quality scoring"

  scroll_velocity:
    description: "Speed of scrolling through timeline"
    use_case: "Detect content fatigue"

  return_visits:
    description: "Repeated visits to same location"
    use_case: "Place affinity detection"

  unlock_attempts:
    description: "Approaching but not fully unlocking content"
    use_case: "Content teaser effectiveness"

  map_exploration:
    description: "Pan/zoom patterns on map"
    use_case: "Interest area identification"
```

### 1.2 Location Data (Spatial Intelligence)

**Critical for CANVS's core value proposition.**

| Data Type | Precision | Retention | Purpose |
|-----------|-----------|-----------|---------|
| **Creation location** | Full precision | Permanent (with content) | Anchor posts to places |
| **Unlock location** | Full precision | 30 days | Verify physical presence |
| **Background location** | Coarse (H3 res 6) | 7 days | Proximity notifications |
| **Movement patterns** | H3 cells visited | Anonymized aggregate | Heat map generation |
| **Dwell detection** | POI proximity | Session only | Real-time features |

**Location Data Schema:**

```typescript
interface LocationEvent {
  event_type: 'location_update' | 'geofence_enter' | 'geofence_exit' | 'unlock_attempt';
  timestamp: string;
  coordinates: {
    lat: number;
    lng: number;
    accuracy_m: number;
    altitude_m?: number;
    heading?: number;
    speed_mps?: number;
  };
  h3_cells: {
    res_6: string;   // ~3km - aggregation
    res_9: string;   // ~150m - neighborhood
    res_12: string;  // ~10m - precise
  };
  source: 'gps' | 'wifi' | 'cell' | 'vps';
  context: {
    is_foreground: boolean;
    battery_level?: number;
    connection_type: 'wifi' | 'cellular' | 'none';
  };
}
```

### 1.3 Content Data (User-Generated Content Metadata)

Every piece of content provides rich metadata for learning.

| Metadata Type | Auto-Extracted | Use Case |
|---------------|----------------|----------|
| **Media type** | Yes | Content format analytics |
| **Media dimensions** | Yes | Display optimization |
| **File size** | Yes | Compression effectiveness |
| **Creation time** | Yes | Temporal patterns |
| **Text length** | Yes | Content engagement correlation |
| **Hashtags** | Yes | Topic clustering |
| **Mentions** | Yes | Social graph building |
| **AI moderation scores** | Yes | Content safety trends |
| **Embedding vectors** | Generated | Semantic search, recommendations |

**AI-Assisted Classification:**

```yaml
content_classification:
  categories:
    - memory       # Personal moments
    - utility      # Helpful information
    - culture      # Art, events, local knowledge
    - social       # Meeting points, gatherings

  sentiment:
    - positive
    - neutral
    - negative
    - mixed

  topics:
    # Auto-extracted via LLM analysis
    - food_and_dining
    - nature_and_outdoors
    - art_and_culture
    - nightlife
    - sports_and_recreation
    - local_tips
    - historical
    - warning_hazard

  spatial_attributes:
    - indoor_outdoor
    - time_sensitivity    # "best at sunset"
    - weather_dependent
    - seasonal
    - accessibility_note
```

### 1.4 Device & Technical Data

| Data Type | Purpose | Sensitivity |
|-----------|---------|-------------|
| **Device model** | Feature compatibility | Low |
| **OS version** | Bug reproduction | Low |
| **App version** | Rollout tracking | Low |
| **Screen dimensions** | UI optimization | Low |
| **AR capabilities** | Feature gating | Low |
| **Network type** | Performance baselines | Low |
| **Battery state** | UX optimization | Low |
| **Memory/storage** | Caching strategy | Low |

### 1.5 Social Graph Data

| Data Point | Collection Method | Privacy Level |
|------------|-------------------|---------------|
| **Follows/followers** | Explicit action | Configurable visibility |
| **Place follows** | Explicit action | Private by default |
| **Blocked users** | Explicit action | Private |
| **Reaction patterns** | Implicit | Aggregated only |
| **Co-location events** | Proximity detection | Opt-in only |
| **Content interactions** | Implicit | Used for recommendations |

### 1.6 Temporal Data

**Time-based patterns reveal user intent and content relevance.**

```yaml
temporal_data:
  collection:
    - event_timestamp_utc
    - local_timezone
    - day_of_week
    - time_of_day_bucket  # morning/afternoon/evening/night
    - is_weekend
    - is_holiday  # regional calendar

  derived_patterns:
    - typical_usage_times
    - session_frequency
    - content_freshness_preference
    - seasonal_location_patterns
```

---

## 2. Data Collection Architecture

### 2.1 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CANVS CLIENT                                   │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                     Event Collection SDK                              │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │   Event     │  │  Location   │  │   Media     │  │  Session    │  │   │
│  │  │  Tracker    │  │  Manager    │  │  Analyzer   │  │  Handler    │  │   │
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │   │
│  │         │                │                │                │         │   │
│  │         └────────────────┴────────────────┴────────────────┘         │   │
│  │                                    │                                  │   │
│  │  ┌──────────────────────────────────────────────────────────────┐    │   │
│  │  │              Local Event Queue (IndexedDB/SQLite)             │    │   │
│  │  │     • Offline storage • Batching • Deduplication • Retry      │    │   │
│  │  └──────────────────────────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ HTTPS (batched, compressed)
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INGESTION LAYER                                   │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │              Supabase Edge Functions / Cloudflare Workers             │  │
│  │     • Schema validation • Enrichment • PII filtering • Rate limit     │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                      │                                      │
│                    ┌─────────────────┴─────────────────┐                    │
│                    ▼                                   ▼                    │
│  ┌──────────────────────────────┐   ┌──────────────────────────────┐       │
│  │     Real-Time Path           │   │      Batch Path               │       │
│  │  (Critical Events Only)      │   │  (All Analytics Events)       │       │
│  │                              │   │                                │       │
│  │  • Post creation             │   │  • User behavior              │       │
│  │  • Moderation triggers       │   │  • Session data               │       │
│  │  • Safety alerts             │   │  • Aggregations               │       │
│  └──────────────┬───────────────┘   └────────────────┬───────────────┘       │
│                 │                                     │                      │
│                 ▼                                     ▼                      │
│  ┌──────────────────────────────┐   ┌──────────────────────────────┐       │
│  │        Supabase               │   │     Event Queue/Buffer       │       │
│  │   PostgreSQL (Real-time)      │   │   (Supabase Edge / R2)       │       │
│  └──────────────────────────────┘   └────────────────┬───────────────┘       │
│                                                       │                      │
│                                                       │ Every 5-15 min       │
│                                                       ▼                      │
│                               ┌──────────────────────────────────┐          │
│                               │     Data Warehouse               │          │
│                               │   PostgreSQL / DuckDB / BigQuery │          │
│                               └──────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ANALYTICS LAYER                                   │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                    PostHog / Metabase / Custom Dashboards             │  │
│  │          Funnels • Retention • Cohorts • A/B Tests • Alerts           │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Event Streaming Options

| Option | Best For | Pros | Cons | Cost |
|--------|----------|------|------|------|
| **Supabase Edge + PostgreSQL** | MVP/Early Stage | Simple, integrated, real-time | Scale limits | $25-50/mo |
| **RudderStack (Open Source)** | Growth Stage | Self-hosted, 500K events free | Engineering overhead | Free-$500/mo |
| **Amazon Kinesis** | Scale | Fully managed, AWS ecosystem | Vendor lock-in | $0.015/shard-hour |
| **Apache Kafka (Managed)** | Enterprise | Industry standard, high throughput | Complexity | $500+/mo |
| **Redpanda** | Modern Alternative | Kafka-compatible, simpler ops | Newer, less ecosystem | Varies |

**Recommendation for CANVS:**

- **MVP (0-10K MAU):** Supabase Edge Functions + PostgreSQL
- **Growth (10K-100K MAU):** RudderStack Open Source + PostgreSQL
- **Scale (100K+ MAU):** RudderStack Cloud or Kinesis + Data Warehouse

### 2.3 Mobile SDK Considerations

```typescript
// CANVS Analytics SDK Configuration
interface AnalyticsConfig {
  // Batching
  batchSize: 20;              // Events per batch
  flushInterval: 30000;       // 30 seconds
  maxQueueSize: 1000;         // Local queue limit

  // Offline handling
  offlineStorageLimit: 10;    // MB
  offlineRetentionDays: 7;    // Days to keep offline events

  // Privacy
  anonymizeIp: true;
  collectDeviceId: false;     // Use anonymous session ID instead
  locationPrecision: 4;       // Decimal places (10m)

  // Performance
  backgroundFlush: true;
  compressionEnabled: true;
  minTimeBetweenSessions: 300; // 5 min = new session
}

// Example event tracking
canvasAnalytics.track('post_viewed', {
  post_id: 'uuid',
  content_type: 'pin',
  has_media: true,
  distance_m: 150,
  source: 'timeline',
  dwell_time_ms: 3500
});

// Automatic events (no code needed)
// - screen_view
// - app_open
// - app_background
// - session_start
// - session_end
```

### 2.4 Offline-First Data Collection

**Critical for location-based apps where users may have spotty connectivity.**

```typescript
// Offline queue implementation
class OfflineEventQueue {
  private db: IndexedDB;
  private maxSize: number = 10 * 1024 * 1024; // 10MB

  async enqueue(event: AnalyticsEvent): Promise<void> {
    const serialized = JSON.stringify(event);

    // Check storage limit
    const currentSize = await this.getQueueSize();
    if (currentSize + serialized.length > this.maxSize) {
      // Remove oldest events
      await this.pruneOldest(serialized.length);
    }

    await this.db.put('events', {
      id: generateUUID(),
      event: serialized,
      timestamp: Date.now(),
      attempts: 0
    });
  }

  async flush(): Promise<void> {
    const events = await this.db.getAll('events');

    if (events.length === 0) return;

    // Batch into chunks of 50
    const batches = chunk(events, 50);

    for (const batch of batches) {
      try {
        await this.sendBatch(batch);
        await this.db.deleteMany(batch.map(e => e.id));
      } catch (error) {
        // Mark failed, retry later
        await this.incrementAttempts(batch);
      }
    }
  }

  // Auto-flush when online
  constructor() {
    window.addEventListener('online', () => this.flush());
  }
}
```

---

## 3. User-Generated Content Data Processing

### 3.1 Metadata Extraction Pipeline

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Content Upload │────▶│ Metadata Extract│────▶│  AI Processing  │
│                 │     │                 │     │                 │
│  • Image/Video  │     │  • Dimensions   │     │  • Moderation   │
│  • Text         │     │  • File size    │     │  • Classification│
│  • Audio        │     │  • Format       │     │  • Embeddings   │
│                 │     │  • EXIF (strip) │     │  • Sentiment    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                        │
                                                        ▼
                                              ┌─────────────────┐
                                              │   Enrichment    │
                                              │                 │
                                              │  • Place type   │
                                              │  • Weather data │
                                              │  • Time context │
                                              │  • H3 indexing  │
                                              └─────────────────┘
```

### 3.2 Content Classification Schema

```sql
-- Content analysis results table
CREATE TABLE content_analysis (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id),

  -- AI Moderation
  moderation_score DECIMAL(3,2),
  moderation_categories JSONB,  -- {"hate": 0.01, "violence": 0.02, ...}

  -- Classification
  content_category TEXT,        -- memory, utility, culture, social
  topics TEXT[],                -- ['food', 'outdoor', 'sunset']
  sentiment TEXT,               -- positive, neutral, negative

  -- Embeddings (for semantic search)
  text_embedding VECTOR(1536),  -- OpenAI text-embedding-3-small
  image_embedding VECTOR(512),  -- CLIP or similar

  -- Spatial attributes
  is_indoor BOOLEAN,
  time_sensitive BOOLEAN,
  weather_dependent BOOLEAN,
  accessibility_relevant BOOLEAN,

  -- Timestamps
  analyzed_at TIMESTAMPTZ DEFAULT NOW(),
  model_version TEXT DEFAULT 'v1.0'
);

-- Index for semantic search
CREATE INDEX idx_content_analysis_text_embedding
ON content_analysis USING ivfflat (text_embedding vector_cosine_ops)
WITH (lists = 100);
```

### 3.3 Spatial Content Attributes

```yaml
spatial_content_metadata:
  anchor_quality:
    gps_accuracy_m: 12
    confidence_score: 0.85
    h3_precision: "res_12"
    positioning_method: "gps+wifi"

  place_context:
    reverse_geocode:
      street: "123 Main Street"
      neighborhood: "Mission District"
      city: "San Francisco"
      country: "US"
    place_type: "cafe"
    business_name: "Blue Bottle Coffee"
    operating_hours: "7am-6pm"

  environmental_context:
    weather_at_creation:
      condition: "sunny"
      temperature_c: 22
    lighting: "natural_daylight"
    crowd_level: "moderate"  # inferred from time/place
```

---

## 4. Privacy-Compliant Collection Framework

### 4.1 Regulatory Requirements Summary

| Regulation | Region | Key Requirements | Impact on CANVS |
|------------|--------|------------------|-----------------|
| **GDPR** | EU/EEA | Explicit consent, right to erasure, data minimization | Full opt-in before any tracking |
| **CCPA/CPRA** | California | Right to know, delete, opt-out of sale | "Do Not Sell" option required |
| **LGPD** | Brazil | Similar to GDPR, explicit consent | Same as EU users |
| **DPDP** | India | Explicit consent, data localization | May need India-based storage |
| **ATT** | iOS | Explicit permission for cross-app tracking | IDFA requires permission |

### 4.2 Consent Management Architecture

```typescript
// Consent categories
enum ConsentCategory {
  ESSENTIAL = 'essential',           // Required for app function
  ANALYTICS = 'analytics',           // Usage data
  PERSONALIZATION = 'personalization', // Recommendations
  LOCATION_PRECISE = 'location_precise',
  LOCATION_BACKGROUND = 'location_background',
  MARKETING = 'marketing'
}

// Consent state per user
interface UserConsent {
  user_id: string;
  consents: {
    [key in ConsentCategory]: {
      granted: boolean;
      granted_at?: Date;
      version: string;     // Privacy policy version
      method: 'explicit' | 'inferred';
    }
  };
  jurisdiction: 'gdpr' | 'ccpa' | 'other';
  last_updated: Date;
}

// Collection gating
function canCollect(event: AnalyticsEvent, consent: UserConsent): boolean {
  const requiredConsent = getRequiredConsent(event.type);

  if (requiredConsent === ConsentCategory.ESSENTIAL) {
    return true;  // Always collect essential events
  }

  return consent.consents[requiredConsent]?.granted === true;
}

// Essential events (always collected)
const ESSENTIAL_EVENTS = [
  'app_crash',
  'authentication_error',
  'security_alert',
  'content_report'
];
```

### 4.3 Data Minimization Implementation

```yaml
data_minimization_rules:
  location_data:
    creation_events:
      precision: "full"           # Need exact location for anchor
      retention: "permanent"      # Part of content
      anonymized: false

    unlock_events:
      precision: "full"
      retention: "30_days"        # Verify presence
      anonymized: false

    background_tracking:
      precision: "h3_res_6"       # ~3km hexagons
      retention: "7_days"
      anonymized: true            # No user_id in aggregates

    analytics_events:
      precision: "h3_res_9"       # ~150m hexagons
      retention: "90_days"
      anonymized: true

  user_identifiers:
    storage: "pseudonymized"      # Separate ID from PII
    analytics_id: "session_based" # New ID each session for analytics
    cross_session: "opt_in_only"

  ip_addresses:
    collection: "hash_only"       # Store hashed, not raw
    geo_resolution: "city_level"
    retention: "session_only"
```

### 4.4 Location Data Sensitivity Handling

```typescript
// Location anonymization utilities
class LocationPrivacy {
  // Reduce precision for display/sharing
  static reduceForDisplay(lat: number, lng: number): {lat: number, lng: number} {
    return {
      lat: Number(lat.toFixed(4)),  // ~10m precision
      lng: Number(lng.toFixed(4))
    };
  }

  // Snap to H3 cell center for aggregation
  static anonymizeForAnalytics(lat: number, lng: number): {lat: number, lng: number} {
    const h3Index = h3.latLngToCell(lat, lng, 6);  // ~3km hexagon
    const [centerLat, centerLng] = h3.cellToLatLng(h3Index);
    return { lat: centerLat, lng: centerLng };
  }

  // Add random noise within accuracy radius
  static addNoise(lat: number, lng: number, accuracy_m: number): {lat: number, lng: number} {
    const noiseRadiusKm = Math.max(accuracy_m, 50) / 1000;  // At least 50m
    const randomAngle = Math.random() * 2 * Math.PI;
    const randomDistance = Math.random() * noiseRadiusKm;

    // Simple offset calculation
    const latOffset = randomDistance * Math.cos(randomAngle) / 111;
    const lngOffset = randomDistance * Math.sin(randomAngle) / (111 * Math.cos(lat * Math.PI / 180));

    return {
      lat: lat + latOffset,
      lng: lng + lngOffset
    };
  }
}
```

### 4.5 Right to Erasure Implementation

```sql
-- Function to handle data deletion request
CREATE OR REPLACE FUNCTION delete_user_data(target_user_id UUID)
RETURNS JSONB AS $$
DECLARE
  deletion_summary JSONB;
BEGIN
  -- 1. Delete analytics events
  DELETE FROM analytics_events WHERE user_id = target_user_id;

  -- 2. Anonymize posts (keep content, remove authorship)
  UPDATE posts
  SET
    user_id = '00000000-0000-0000-0000-000000000000',  -- Anonymous user
    is_anonymized = TRUE
  WHERE user_id = target_user_id;

  -- 3. Delete comments (author request)
  DELETE FROM comments WHERE user_id = target_user_id;

  -- 4. Delete reactions
  DELETE FROM reactions WHERE user_id = target_user_id;

  -- 5. Delete location history
  DELETE FROM location_history WHERE user_id = target_user_id;

  -- 6. Delete push subscriptions
  DELETE FROM push_subscriptions WHERE user_id = target_user_id;

  -- 7. Delete user profile
  DELETE FROM users WHERE id = target_user_id;

  -- 8. Log deletion for compliance
  INSERT INTO deletion_audit_log (user_id, deleted_at, summary)
  VALUES (target_user_id, NOW(), deletion_summary);

  RETURN deletion_summary;
END;
$$ LANGUAGE plpgsql;
```

---

## 5. First-Party Data Strategy

### 5.1 Building a First-Party Data Asset

**First-party data is CANVS's most valuable long-term asset.**

```yaml
first_party_data_asset:
  user_profiles:
    explicit:
      - username
      - bio
      - avatar
      - location_text
      - notification_preferences

    derived:
      - content_preferences   # topics they engage with
      - temporal_patterns     # when they use app
      - place_affinities      # locations they frequent
      - social_style         # creator vs consumer
      - quality_score        # content quality history

  place_knowledge:
    crowdsourced:
      - user_generated_names
      - tips_and_recommendations
      - accessibility_notes
      - opening_hours_corrections

    aggregated:
      - visitor_patterns
      - peak_times
      - popular_content_types
      - sentiment_by_location

  content_corpus:
    text:
      - posts
      - comments
      - place_descriptions

    embeddings:
      - semantic_vectors
      - topic_clusters
      - entity_extraction

    spatial:
      - anchor_database
      - place_relationships
      - trail_connections
```

### 5.2 Progressive Data Collection (Earn Trust)

**Don't ask for everything on Day 1. Build trust over time.**

```yaml
progressive_collection:
  day_1:
    ask_for:
      - email (for account)
      - essential_analytics_consent
    value_exchange: "Create your first pin"

  week_1:
    ask_for:
      - location_while_using (precise)
    value_exchange: "Discover content near you"
    trigger: "After first 3 sessions"

  month_1:
    ask_for:
      - push_notifications
      - personalization_consent
    value_exchange: "Get notified when friends post nearby"
    trigger: "After following first place"

  engaged_users:
    ask_for:
      - background_location (optional)
    value_exchange: "Unlock content automatically as you walk"
    trigger: "Power users only (10+ unlocks)"
```

### 5.3 Value Exchange Framework

| Data Requested | Value Returned | When to Ask |
|----------------|----------------|-------------|
| **Location (foreground)** | See nearby content | First session |
| **Analytics consent** | Better recommendations | First session |
| **Email** | Account features, recovery | Account creation |
| **Push notification** | Don't miss nearby posts | After first engagement |
| **Background location** | Auto-unlock, proximity alerts | Power user milestone |
| **Photo library access** | Attach memories | When creating post |
| **Camera access** | Capture moments | When creating post |

---

## 6. Data Quality & Validation

### 6.1 Collection-Point Validation

```typescript
// Event validation schema
const eventSchema = z.object({
  event_name: z.string().max(64),
  timestamp: z.string().datetime(),
  user_id: z.string().uuid().optional(),
  session_id: z.string().uuid(),
  properties: z.record(z.unknown()),

  // Location validation
  location: z.object({
    lat: z.number().min(-90).max(90),
    lng: z.number().min(-180).max(180),
    accuracy_m: z.number().min(0).max(10000),
  }).optional(),

  // Device context
  device: z.object({
    platform: z.enum(['ios', 'android', 'web']),
    app_version: z.string(),
    os_version: z.string(),
  }),
});

// Validation at ingestion
async function validateAndEnrich(rawEvent: unknown): Promise<AnalyticsEvent> {
  // 1. Schema validation
  const event = eventSchema.parse(rawEvent);

  // 2. Timestamp sanity check (not future, not too old)
  const eventTime = new Date(event.timestamp);
  const now = new Date();
  if (eventTime > now || eventTime < new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)) {
    throw new ValidationError('Invalid timestamp');
  }

  // 3. Location sanity check
  if (event.location) {
    // Check for impossible locations (e.g., ocean, Antarctica)
    if (!isValidLandLocation(event.location)) {
      event.location = undefined;
    }

    // Check for impossible speed (teleportation detection)
    const lastLocation = await getLastKnownLocation(event.session_id);
    if (lastLocation && isImpossibleMovement(lastLocation, event.location)) {
      event.properties.location_suspicious = true;
    }
  }

  // 4. Deduplicate
  const eventHash = hashEvent(event);
  if (await isDuplicate(eventHash)) {
    throw new DuplicateError('Event already processed');
  }

  return event;
}
```

### 6.2 Location Data Accuracy Handling

```typescript
interface LocationQualityAssessment {
  quality_tier: 'excellent' | 'good' | 'fair' | 'poor';
  confidence_score: number;  // 0-1
  recommended_action: 'accept' | 'warn' | 'reject';
  issues: string[];
}

function assessLocationQuality(location: LocationData): LocationQualityAssessment {
  const issues: string[] = [];
  let score = 1.0;

  // Accuracy assessment
  if (location.accuracy_m > 100) {
    score -= 0.4;
    issues.push('Low GPS accuracy');
  } else if (location.accuracy_m > 50) {
    score -= 0.2;
    issues.push('Moderate GPS accuracy');
  }

  // Source assessment
  if (location.source === 'cell') {
    score -= 0.3;
    issues.push('Cell tower only - imprecise');
  }

  // Consistency check
  if (location.speed_mps && location.speed_mps > 50) {
    score -= 0.2;
    issues.push('High speed - possible vehicle');
  }

  // Determine tier
  let tier: LocationQualityAssessment['quality_tier'];
  let action: LocationQualityAssessment['recommended_action'];

  if (score >= 0.8) {
    tier = 'excellent';
    action = 'accept';
  } else if (score >= 0.6) {
    tier = 'good';
    action = 'accept';
  } else if (score >= 0.4) {
    tier = 'fair';
    action = 'warn';
  } else {
    tier = 'poor';
    action = 'reject';
  }

  return {
    quality_tier: tier,
    confidence_score: score,
    recommended_action: action,
    issues
  };
}
```

### 6.3 Schema Evolution Management

```sql
-- Event schema registry
CREATE TABLE event_schemas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_name TEXT NOT NULL,
  version INTEGER NOT NULL,
  schema JSONB NOT NULL,  -- JSON Schema definition
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deprecated_at TIMESTAMPTZ,

  UNIQUE(event_name, version)
);

-- Schema compatibility check
CREATE OR REPLACE FUNCTION validate_event_schema(
  p_event_name TEXT,
  p_event_data JSONB
) RETURNS BOOLEAN AS $$
DECLARE
  v_schema JSONB;
BEGIN
  -- Get active schema
  SELECT schema INTO v_schema
  FROM event_schemas
  WHERE event_name = p_event_name
    AND is_active = TRUE
  ORDER BY version DESC
  LIMIT 1;

  IF v_schema IS NULL THEN
    -- Unknown event type - log but accept
    RETURN TRUE;
  END IF;

  -- Validate against schema (using pg_jsonschema extension)
  RETURN jsonb_matches_schema(v_schema, p_event_data);
END;
$$ LANGUAGE plpgsql;
```

---

## 7. Free/Low-Cost Collection Tools

### 7.1 Tool Comparison for CANVS

| Tool | Free Tier | Best For | Integration Effort |
|------|-----------|----------|-------------------|
| **PostHog Cloud** | 1M events/mo | Product analytics | Low |
| **RudderStack OS** | Unlimited (self-host) | Event routing | Medium |
| **Metabase** | Self-hosted free | Dashboards | Low |
| **Countly** | Self-hosted free | Mobile analytics | Medium |
| **Plausible** | Self-hosted free | Web analytics | Low |
| **OpenPanel** | Open source | Product analytics | Medium |

### 7.2 Recommended Stack for CANVS

**MVP Stack (0-10K MAU, ~$0-50/month):**

```yaml
mvp_analytics_stack:
  event_collection:
    tool: "Custom SDK → Supabase Edge Functions"
    cost: "$0 (included in Supabase)"
    events_limit: "~500K/month"

  storage:
    tool: "Supabase PostgreSQL"
    cost: "$25/month (Pro plan)"
    retention: "90 days raw, aggregated thereafter"

  visualization:
    tool: "Metabase (self-hosted) + Supabase Dashboard"
    cost: "$0"
    features: "SQL dashboards, basic funnels"

  real_time:
    tool: "Supabase Realtime"
    cost: "$0 (included)"
    use_case: "Live content updates, presence"
```

**Growth Stack (10K-100K MAU, ~$100-500/month):**

```yaml
growth_analytics_stack:
  event_collection:
    tool: "RudderStack Open Source"
    deployment: "Docker on $20/mo VPS"
    events_limit: "Unlimited"

  product_analytics:
    tool: "PostHog Cloud"
    cost: "$0-225/month"
    features: "Funnels, retention, session replay"

  data_warehouse:
    tool: "Supabase PostgreSQL + DuckDB"
    cost: "$50/month"
    use_case: "Historical analysis, ML features"

  visualization:
    tool: "Metabase + Retool (admin)"
    cost: "$0-100/month"
```

### 7.3 Custom Event Collection Implementation

```typescript
// Lightweight custom analytics for MVP
// Store in Supabase, analyze later

// Event table schema
const eventTableSQL = `
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_name TEXT NOT NULL,
  user_id UUID,
  session_id UUID NOT NULL,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  properties JSONB DEFAULT '{}',
  location_h3 TEXT,  -- H3 index for privacy
  device_info JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_events_name_time ON analytics_events (event_name, timestamp DESC);
CREATE INDEX idx_events_user ON analytics_events (user_id, timestamp DESC);
CREATE INDEX idx_events_session ON analytics_events (session_id);
`;

// Supabase Edge Function for event ingestion
export async function POST(request: Request) {
  const events = await request.json();

  // Batch validate
  const validEvents = events.filter(validateEvent);

  // Batch insert
  const { error } = await supabase
    .from('analytics_events')
    .insert(validEvents);

  if (error) {
    return new Response(JSON.stringify({ error }), { status: 500 });
  }

  return new Response(JSON.stringify({ accepted: validEvents.length }));
}
```

---

## 8. Event Taxonomy for CANVS

### 8.1 Naming Convention

```
[object]_[action]

Examples:
- post_created
- post_viewed
- reaction_added
- map_panned
- location_unlocked
```

### 8.2 Core Event Catalog

```yaml
# ============================================
# CANVS Event Taxonomy v1.0
# ============================================

# --------------------------------------------
# USER LIFECYCLE
# --------------------------------------------
user_events:
  user_signed_up:
    properties:
      signup_method: "magic_link" | "phone" | "apple" | "google"
      referral_source: string
    priority: P0

  user_onboarding_step_completed:
    properties:
      step_name: string
      step_number: integer
      time_spent_ms: integer
    priority: P0

  user_settings_changed:
    properties:
      setting_name: string
      old_value: any
      new_value: any
    priority: P1

# --------------------------------------------
# CONTENT CREATION
# --------------------------------------------
creation_events:
  post_create_started:
    properties:
      entry_point: "fab" | "map_long_press" | "place_detail"
      location_accuracy_m: number
    priority: P0

  post_media_added:
    properties:
      media_type: "photo" | "video"
      source: "camera" | "library"
      file_size_kb: integer
    priority: P1

  post_submitted:
    properties:
      has_media: boolean
      has_text: boolean
      text_length: integer
      location_accuracy_m: number
      place_name_custom: boolean
      moderation_score: number
    priority: P0

  post_submit_failed:
    properties:
      error_type: string
      error_message: string
    priority: P0

# --------------------------------------------
# CONTENT CONSUMPTION
# --------------------------------------------
consumption_events:
  post_viewed:
    properties:
      post_id: uuid
      source: "timeline" | "map" | "profile" | "search" | "notification"
      distance_m: number
      is_unlocked: boolean
    priority: P0

  post_dwell:
    properties:
      post_id: uuid
      dwell_time_ms: integer
      scroll_depth_percent: integer
    priority: P1

  location_unlock_attempted:
    properties:
      post_id: uuid
      distance_m: number
      success: boolean
      location_accuracy_m: number
    priority: P0

  location_unlocked:
    properties:
      post_id: uuid
      time_to_unlock_s: integer
      approach_path_m: number  # distance traveled to unlock
    priority: P0

# --------------------------------------------
# SOCIAL INTERACTIONS
# --------------------------------------------
social_events:
  reaction_added:
    properties:
      post_id: uuid
      emoji: string
    priority: P1

  reaction_removed:
    properties:
      post_id: uuid
      emoji: string
    priority: P2

  comment_submitted:
    properties:
      post_id: uuid
      comment_length: integer
    priority: P1

  profile_viewed:
    properties:
      viewed_user_id: uuid
      source: "post" | "comment" | "search"
    priority: P2

  place_followed:
    properties:
      place_id: uuid
      discovery_source: "map" | "post" | "search"
    priority: P1

# --------------------------------------------
# NAVIGATION & DISCOVERY
# --------------------------------------------
navigation_events:
  screen_viewed:
    properties:
      screen_name: string
      previous_screen: string
    priority: P0

  map_interaction:
    properties:
      action: "pan" | "zoom_in" | "zoom_out" | "recenter"
      zoom_level: integer
    priority: P2

  search_performed:
    properties:
      query_text: string  # anonymized/hashed
      query_length: integer
      results_count: integer
      result_tapped: boolean
    priority: P1

  filter_applied:
    properties:
      filter_type: "time" | "content_type" | "following"
      filter_value: string
    priority: P2

  cluster_expanded:
    properties:
      cluster_size: integer
      location_h3: string
    priority: P2

# --------------------------------------------
# SYSTEM & PERFORMANCE
# --------------------------------------------
system_events:
  app_opened:
    properties:
      cold_start: boolean
      notification_triggered: boolean
      deeplink: string
    priority: P0

  app_backgrounded:
    properties:
      session_duration_s: integer
      posts_viewed: integer
      posts_created: integer
    priority: P0

  location_permission_requested:
    properties:
      permission_type: "when_in_use" | "always"
      granted: boolean
    priority: P0

  push_permission_requested:
    properties:
      granted: boolean
    priority: P0

  error_occurred:
    properties:
      error_type: string
      error_message: string
      screen_name: string
      is_fatal: boolean
    priority: P0
```

---

## 9. Implementation Roadmap

### Phase 1: MVP Foundation (Weeks 1-4)

```yaml
phase_1_deliverables:
  - Custom analytics SDK scaffold
  - Core event definitions (P0 events)
  - Supabase event storage
  - Basic dashboard in Metabase
  - Consent management UI
  - Location privacy utilities

  success_metrics:
    - Event capture rate > 99%
    - Event latency < 500ms
    - Dashboard load time < 3s
```

### Phase 2: Growth Analytics (Months 2-3)

```yaml
phase_2_deliverables:
  - Full event taxonomy implemented
  - Funnel analysis dashboards
  - Retention cohort tracking
  - A/B testing infrastructure
  - PostHog integration (optional)
  - GDPR/CCPA data export

  success_metrics:
    - Track all P0 and P1 events
    - Retention dashboard live
    - Data export < 24 hours
```

### Phase 3: Intelligence Layer (Months 4-6)

```yaml
phase_3_deliverables:
  - Content recommendation engine
  - Place popularity scoring
  - User segmentation
  - Anomaly detection (fraud/spam)
  - Real-time analytics streaming
  - ML feature store

  success_metrics:
    - Recommendation CTR > baseline
    - Spam detection accuracy > 95%
    - Real-time lag < 30s
```

---

## 10. Key Metrics to Track

### 10.1 North Star Metric

**MPI/week = Meaningful Place Interactions per user per week**

Defined as:
- Unlocking a post
- Creating a post
- Adding a reaction at location
- Following a place

### 10.2 Input Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| **Activation Rate** | Users who create first post within 7 days | 25% |
| **Day 7 Retention** | Users returning 7 days after signup | 30% |
| **DAU/MAU** | Stickiness ratio | 20% |
| **Posts per Active User** | Content creation engagement | 0.5/week |
| **Unlock Rate** | Posts unlocked / Posts viewed | 40% |
| **Time to First Post** | Minutes from signup to first post | <15 min |

### 10.3 Quality Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| **Location Accuracy** | % of posts with <30m accuracy | >80% |
| **Moderation False Positive Rate** | Good content incorrectly blocked | <5% |
| **Event Capture Rate** | Events received / Events attempted | >99% |
| **Data Freshness** | Time from event to dashboard | <15 min |

---

## References & Sources

### Data Collection Architecture
- [AWS Event-Driven Architecture Best Practices](https://aws.amazon.com/blogs/architecture/best-practices-for-implementing-event-driven-architectures-in-your-organization/)
- [Kafka Event-Driven Architecture](https://estuary.dev/blog/kafka-event-driven-architecture/)
- [Analytics Stack with Streaming](https://www.mitzu.io/post/designing-analytics-stack-with-streaming-and-event-driven-architecture)

### Customer Data Platforms
- [RudderStack vs Segment Comparison](https://www.rudderstack.com/competitors/rudderstack-vs-segment/)
- [RudderStack Open Source](https://github.com/rudderlabs/rudder-server)
- [PostHog Open Source Analytics](https://posthog.com/blog/best-open-source-analytics-tools)

### Privacy & Compliance
- [First-Party Data Compliance 2025](https://secureprivacy.ai/blog/first-party-data-collection-compliance-gdpr-ccpa-2025)
- [Mobile App Compliance 2025](https://www.didomi.io/blog/mobile-app-compliance-2025)
- [App Data Compliance GDPR CCPA](https://www.wildnetedge.com/blogs/app-data-compliance-implementing-gdpr-ccpa-in-your-apps)

### Offline-First Analytics
- [Android Offline-First Architecture](https://www.droidcon.com/2025/12/16/the-complete-guide-to-offline-first-architecture-in-android/)
- [Countly Offline Analytics](https://countly.com/blog/mastering-analytics-for-offline-applications-and-devices-with-countly)
- [Pendo Mobile Offline Support](https://support.pendo.io/hc/en-us/articles/360043016412-Mobile-offline-support-for-analytics)

### Spatial Computing Data
- [Location-Based AR 2025](https://www.plugxr.com/augmented-reality/location-based-ar/)
- [Deloitte Spatial Computing](https://www2.deloitte.com/us/en/insights/focus/tech-trends/2025/spatial-computing.html)
- [ARway Location-Based AR](https://arway.ai/augmented-reality/location-based-augmented-reality/)

---

*Document generated: January 2026*
*Next review: Prior to MVP launch*
