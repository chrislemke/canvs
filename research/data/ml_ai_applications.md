# Machine Learning and AI Applications for CANVS

## Comprehensive Research Document for ML/AI-Powered Spatial Social Layer

**Version:** 1.0.0
**Date:** January 11, 2026
**Status:** Research Complete
**Related Documents:**
- [AI Features Specification](/specs/tech/mvp/specs/ai_features.md)
- [AI Implementation Architecture](/specs/tech/parts/ai/ai_implementation_architecture.md)
- [Spatial AI Features](/specs/tech/parts/ai/spatial_ai_features.md)
- [Visionary Feature Integrations](/specs/tech/parts/ai/visionary_feature_integrations.md)

---

## Executive Summary

This document provides comprehensive research on ML/AI applications that can enhance CANVS's spatial social layer. CANVS's unique position as a location-anchored content platform creates opportunities for ML applications that traditional social platforms cannot achieve.

### Key ML Opportunity Areas

| Category | Primary Application | Priority | Phase |
|----------|-------------------|----------|-------|
| **Reality Filter** | Personalized content ranking | Critical | MVP |
| **LLM Applications** | Context compression, semantic search | Critical | MVP |
| **Content Intelligence** | Auto-categorization, emotion tagging | High | MVP |
| **User Intelligence** | Clustering, preference learning | High | Phase 2 |
| **Safety & Trust** | Anomaly detection, moderation | Critical | MVP |
| **Spatial Intelligence** | Place embeddings, path generation | Medium | Phase 2 |
| **Meaning Graph** | Knowledge graph construction | Medium | Phase 3 |

---

## 1. ML Use Cases for CANVS

### 1.1 Content Recommendation (Reality Filter)

The Reality Filter is CANVS's signature ML feature - surfacing relevant spatial content based on user preferences, location context, and emotional intent.

#### Technical Approach

```
Input Signals → Feature Engineering → Scoring → LLM Ranking → Output
    │                   │                │           │           │
    ├── Location        ├── H3 cell      ├── Cosine  ├── Claude  ├── Top 5-10
    ├── User prefs      ├── Time buckets │   sim     │   Haiku   │   content
    ├── Context         ├── Category     ├── Rule    └───────────┘
    ├── Social graph    │   encoding     │   scores
    └── History         └── Embeddings   └───────────────────────
```

#### Scoring Components

| Signal | Weight | Feature Engineering |
|--------|--------|---------------------|
| Semantic similarity | 0.30 | Cosine distance between content & user preference embeddings |
| Social relevance | 0.25 | Friend-created content, reactions by friends |
| Spatial proximity | 0.15 | Distance decay function (1 / (1 + d/100)) |
| Temporal freshness | 0.15 | Exponential decay (0.95^days_old) |
| Engagement velocity | 0.10 | Reactions/views in last 24h vs. historical |
| Diversity bonus | 0.05 | Category rotation, serendipity injection |

#### Implementation Pattern

```typescript
interface RealityFilterPipeline {
  // Stage 1: Pre-filtering (fast, rules-based)
  preFilter(candidates: Content[], user: User): Content[];

  // Stage 2: Feature extraction
  extractFeatures(content: Content[], user: User): FeatureMatrix;

  // Stage 3: Scoring (embedding similarity + rules)
  score(features: FeatureMatrix): ScoredContent[];

  // Stage 4: LLM ranking (top N only, cached)
  llmRank(topN: ScoredContent[], context: UserContext): RankedContent[];

  // Stage 5: Diversity enforcement
  diversify(ranked: RankedContent[]): RankedContent[];
}
```

#### Cold Start Handling

**New User Strategies:**
1. **Onboarding quiz**: 3-5 questions about interests (street art, food, history, etc.)
2. **Location-based baseline**: Popular content at similar place types
3. **Demographic inference**: Age, device type, time-of-day patterns
4. **Social seeding**: Import interests from connected friends

**New Content Strategies:**
1. **Content-based features**: Category, emotion tags, author reputation
2. **Exploration bonus**: Boost new content visibility for 24-48 hours
3. **Similar content proxy**: Use embeddings from similar existing content

### 1.2 Emotion Classification

Automatically classify the emotional tone of content for search, filtering, and location personality profiling.

#### Emotion Taxonomy for CANVS

**Primary Emotions (Plutchik-based):**
- Joy / Happiness
- Sadness / Nostalgia
- Fear / Anxiety
- Anger / Frustration
- Surprise / Wonder
- Anticipation / Excitement
- Trust / Comfort
- Disgust / Distaste

**CANVS-Specific Emotions:**
- Nostalgia (core to memory features)
- Serenity / Peace
- Adventure / Discovery
- Romance / Love
- Gratitude
- Grief / Remembrance

#### Model Options

| Model | Accuracy | Latency | Cost | Best For |
|-------|----------|---------|------|----------|
| **DistilBERT-emotion** | 74% | 50ms | Free (edge) | Batch processing |
| **RoBERTa-emotion** | 78% | 100ms | Free (edge) | Higher accuracy needs |
| **GPT-4o-mini** | 85% | 200ms | $0.00015/call | Complex content |
| **Claude Haiku** | 83% | 300ms | $0.00025/call | Safety-critical |

#### Implementation

```typescript
// Hybrid emotion classification
async function classifyEmotion(content: UserContent): Promise<EmotionProfile> {
  // 1. Fast edge classification for common cases
  const edgeResult = await edgeEmotionModel.classify(content.text);

  if (edgeResult.confidence > 0.8) {
    return edgeResult;
  }

  // 2. LLM fallback for nuanced content
  const llmResult = await gpt4oMini.classify({
    text: content.text,
    imageDescription: content.imageAlt,
    locationContext: content.placeType
  });

  return mergeResults(edgeResult, llmResult);
}
```

### 1.3 Place Categorization & Semantic Understanding

Build semantic profiles of locations based on content aggregation.

#### Place2Vec Approach

Inspired by Word2Vec, Place2Vec learns embeddings for POI types based on spatial co-occurrence patterns.

**Data Sources:**
- OpenStreetMap POI data
- Google Places API
- User-generated content categories
- Temporal visit patterns

**Embedding Architecture:**
```python
# Place embedding model
class PlaceEmbedding(nn.Module):
    def __init__(self, vocab_size, embed_dim=128):
        super().__init__()
        self.embeddings = nn.Embedding(vocab_size, embed_dim)
        self.context = nn.Embedding(vocab_size, embed_dim)

    def forward(self, target, context):
        target_emb = self.embeddings(target)
        context_emb = self.context(context)
        return torch.sigmoid(torch.sum(target_emb * context_emb, dim=1))
```

**Use Cases:**
- "Find places similar to this café" (nearest neighbors in embedding space)
- "What's the vibe of this neighborhood?" (aggregate H3 cell embeddings)
- "Suggest places for a romantic evening" (query against personality vectors)

### 1.4 User Clustering & Segmentation

Group users by behavior patterns for improved recommendations and insights.

#### Clustering Approach

```
User Features → Dimensionality Reduction → Clustering → Segment Labels
     │                    │                    │             │
     ├── Content prefs    ├── PCA/UMAP        ├── K-means   ├── "Memory Keeper"
     ├── Location types   │                   │   DBSCAN    ├── "Urban Explorer"
     ├── Temporal patterns│                   │   HDBSCAN   ├── "Street Art Fan"
     ├── Social activity  │                   │             ├── "Local Guide"
     └── Engagement style │                   │             └── "Time Capsule Creator"
```

#### Feature Engineering

| Feature Category | Examples | Encoding |
|------------------|----------|----------|
| Content preferences | Memory/Utility/Culture ratios | Float [0,1] |
| Location types | Café visits, park visits, museum visits | Count encoding |
| Temporal patterns | Peak hours, weekday/weekend ratio | Time buckets |
| Social activity | Post frequency, reaction ratio, comment rate | Normalized counts |
| Engagement depth | Avg. view time, capsule opens, trail follows | Float metrics |

#### Implementation

```python
from sklearn.cluster import HDBSCAN
from sklearn.preprocessing import StandardScaler
import umap

def segment_users(user_features: np.ndarray, min_cluster_size: int = 50):
    # Standardize features
    scaler = StandardScaler()
    scaled = scaler.fit_transform(user_features)

    # Reduce dimensionality
    reducer = umap.UMAP(n_components=10, random_state=42)
    reduced = reducer.fit_transform(scaled)

    # Cluster with HDBSCAN (handles noise, variable density)
    clusterer = HDBSCAN(min_cluster_size=min_cluster_size)
    labels = clusterer.fit_predict(reduced)

    return labels, clusterer.probabilities_
```

### 1.5 Anomaly Detection (Spam, Abuse, Stalking)

Detect harmful patterns unique to spatial social platforms.

#### Detection Categories

**1. Content Spam:**
- Promotional content disguised as organic
- Duplicate content at multiple locations
- Keyword stuffing

**2. Behavioral Anomalies:**
- Unusual posting velocity
- Geographic impossibility (posts from distant locations in short time)
- Coordinated inauthentic behavior

**3. Stalking Patterns (Critical):**
- Disproportionate engagement with single user
- Physical proximity correlation with target's content
- Time-correlated content creation

#### Stalking Detection Model

```typescript
interface StalkingRiskSignals {
  // Engagement disproportion (>3x average with one user)
  engagementRatio: number; // weight: 0.30

  // Physical proximity pattern
  locationOverlap: number; // weight: 0.40

  // Temporal correlation
  timeCorrelation: number; // weight: 0.25

  // Multi-target indicator (reduces risk if many targets)
  targetDiversity: number; // weight: -0.20
}

async function calculateStalkingRisk(
  userId: string,
  targetId: string
): Promise<RiskScore> {
  const signals = await gatherSignals(userId, targetId);

  const riskScore =
    signals.engagementRatio * 0.30 +
    signals.locationOverlap * 0.40 +
    signals.timeCorrelation * 0.25 -
    signals.targetDiversity * 0.20;

  return {
    score: Math.max(0, Math.min(1, riskScore)),
    action: riskScore > 0.9 ? 'suspend' :
            riskScore > 0.7 ? 'shadow_restrict' :
            riskScore > 0.5 ? 'monitor' : 'none'
  };
}
```

### 1.6 Predictive Engagement Scoring

Predict which content will resonate before it's widely seen.

#### Features for Engagement Prediction

| Feature | Type | Description |
|---------|------|-------------|
| Author metrics | Numeric | Followers, avg. engagement, consistency |
| Content features | Text/Categorical | Length, emotion, category, media type |
| Location features | Numeric | Place popularity, recent activity |
| Temporal features | Numeric | Time of day, day of week, season |
| Social features | Graph | Author's social reach, mutual connections |

#### Model Architecture

```python
import lightgbm as lgb

# LightGBM for engagement prediction
engagement_model = lgb.LGBMRegressor(
    objective='regression',
    n_estimators=500,
    learning_rate=0.05,
    num_leaves=31,
    feature_fraction=0.8,
    bagging_fraction=0.8,
    bagging_freq=5
)

# Target: log(engagement + 1) to handle skew
# Features: [author_features, content_features, location_features, temporal_features]
```

---

## 2. LLM Applications for CANVS

### 2.1 Context Compression

**Problem:** 400 nearby anchors → 5 meaningful options

**Solution:** Multi-stage LLM compression

```typescript
async function compressContext(
  nearbyContent: SpatialContent[],
  userContext: UserContext,
  targetCount: number = 5
): Promise<CompressedContext> {
  // Stage 1: Embedding-based pre-selection (fast)
  const candidates = await selectBySimilarity(
    nearbyContent,
    userContext.preferenceEmbedding,
    50 // top 50 by embedding distance
  );

  // Stage 2: LLM summarization and selection
  const compressed = await claude.messages.create({
    model: 'claude-3-5-haiku-20241022',
    max_tokens: 1024,
    messages: [{
      role: 'user',
      content: `You are a spatial content curator. Given ${candidates.length} nearby content items and user context, select the ${targetCount} most meaningful for this user at this moment.

User Context:
- Interests: ${userContext.interests.join(', ')}
- Current intent: ${userContext.intent || 'browsing'}
- Time: ${userContext.timeOfDay}
- Recent interactions: ${userContext.recentActivity}

Nearby Content:
${candidates.map((c, i) => `${i+1}. [${c.category}] "${c.preview}" (${c.distanceM}m, ${c.emotionTag})`).join('\n')}

Return JSON: {
  "selected": [{ "index": number, "reason": string }],
  "summary": "One sentence summary of the spatial context"
}`
    }]
  });

  return JSON.parse(compressed.content[0].text);
}
```

### 2.2 Semantic Search

Enable natural language queries like:
- "Find peaceful places nearby"
- "Show me nostalgic memories from this neighborhood"
- "Where did my friends feel happy?"

#### Query Processing Pipeline

```
User Query → Query Expansion → Embedding → Hybrid Search → Re-ranking → Results
     │             │               │            │              │           │
     │       LLM synonym      text-embed-    pgvector +    Claude     Explained
     │       expansion        3-small        PostGIS       Haiku      results
```

#### Query Expansion

```typescript
async function expandQuery(query: string): Promise<ExpandedQuery> {
  const expansion = await gpt4oMini.complete({
    prompt: `Expand this spatial search query with synonyms and related concepts.
Query: "${query}"

Return JSON:
{
  "original": "${query}",
  "synonyms": ["word1", "word2"],
  "emotions": ["emotion1", "emotion2"],
  "placeTypes": ["type1", "type2"],
  "semanticExpansion": "expanded query for embedding"
}`
  });

  return JSON.parse(expansion);
}
```

### 2.3 Path Generation

Generate walking experiences that match emotional or thematic goals.

**Example:** "30-minute walk ending somewhere optimistic"

```typescript
interface PathGenerationRequest {
  startLocation: GeoPoint;
  duration: number; // minutes
  emotionalArc?: string; // "curiosity → discovery → hope"
  themes?: string[];
  accessibility?: AccessibilityRequirements;
}

async function generatePath(request: PathGenerationRequest): Promise<Trail> {
  // 1. Find candidate waypoints
  const candidates = await semanticSearch({
    query: request.emotionalArc || request.themes.join(' '),
    location: request.startLocation,
    radiusM: estimateWalkingRadius(request.duration)
  });

  // 2. Optimize route with constraints
  const optimizedRoute = await optimizeRoute({
    waypoints: candidates,
    maxDuration: request.duration,
    accessibility: request.accessibility,
    returnToStart: false
  });

  // 3. Generate narrative
  const narrative = await claude.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    messages: [{
      role: 'user',
      content: `Create a walking narrative for this trail:
Waypoints: ${JSON.stringify(optimizedRoute.waypoints)}
Emotional arc: ${request.emotionalArc}
Duration: ${request.duration} minutes

Generate a cohesive story that connects these places.`
    }]
  });

  return {
    waypoints: optimizedRoute.waypoints,
    narrative: narrative.content[0].text,
    estimatedDuration: optimizedRoute.duration,
    emotionalArc: request.emotionalArc
  };
}
```

### 2.4 Content Moderation

Multi-modal, spatial-aware moderation using LLMs.

#### Zone-Aware Rules

```typescript
const ZONE_POLICIES = {
  school: {
    maxAge: 18,
    restrictions: ['alcohol', 'adult_content', 'violence', 'solicitation'],
    radius: 200
  },
  memorial: {
    restrictions: ['humor', 'commercial', 'irreverent', 'political'],
    toneSensitivity: 'high'
  },
  hospital: {
    restrictions: ['loud_events', 'commercial_spam'],
    sensitivityBoost: true
  },
  nightlife: {
    ageRestriction: 18,
    relaxedRules: true
  }
};

async function moderateWithContext(
  content: UserContent,
  location: GeoPoint
): Promise<ModerationResult> {
  // 1. Free OpenAI moderation (base check)
  const baseCheck = await openai.moderations.create({
    model: 'omni-moderation-latest',
    input: buildModerationInput(content)
  });

  // 2. Zone classification
  const zone = await classifyZone(location);

  // 3. Apply zone-specific rules
  const zoneViolations = checkZoneViolations(content, ZONE_POLICIES[zone.type]);

  // 4. Combine results
  return combineResults(baseCheck, zoneViolations, zone);
}
```

### 2.5 Multi-Language Support

Real-time translation and cultural adaptation.

```typescript
async function translateContent(
  content: SpatialContent,
  targetLanguage: string
): Promise<TranslatedContent> {
  // Detect source language if not specified
  const sourceLanguage = content.language ||
    await detectLanguage(content.text);

  if (sourceLanguage === targetLanguage) {
    return content;
  }

  // Translate with cultural context
  const translation = await claude.messages.create({
    model: 'claude-3-5-haiku-20241022',
    messages: [{
      role: 'user',
      content: `Translate this spatial memory content from ${sourceLanguage} to ${targetLanguage}.
Preserve:
- Emotional tone and intent
- Cultural context (adapt idioms appropriately)
- Local place references

Content: "${content.text}"
Location context: ${content.placeType}, ${content.city}

Return JSON: {
  "translation": "...",
  "emotionalTonePreserved": true/false,
  "culturalNotes": "any relevant context"
}`
    }]
  });

  return {
    ...content,
    text: JSON.parse(translation.content[0].text).translation,
    originalText: content.text,
    translatedFrom: sourceLanguage
  };
}
```

---

## 3. Data Requirements for ML

### 3.1 Training Data Collection Strategies

#### Implicit Signals (Passive Collection)

| Signal | Collection Method | Use Case |
|--------|------------------|----------|
| View duration | Client instrumentation | Engagement prediction |
| Scroll depth | Intersection Observer API | Content relevance |
| Location dwell time | GPS + geofence | Place importance |
| Session patterns | Analytics | User segmentation |
| Social interactions | Database events | Recommendation |

#### Explicit Signals (User Actions)

| Signal | Collection Point | Use Case |
|--------|-----------------|----------|
| Reactions (emoji) | Post interaction | Sentiment labels |
| Category selection | Content creation | Classification training |
| Save/Bookmark | Post interaction | Relevance signals |
| Report/Flag | Post interaction | Moderation training |
| Onboarding answers | New user flow | Cold start |

### 3.2 Labeling and Annotation

#### Automated Labeling

```python
# Use LLMs for initial labeling, human review for quality
async def generate_training_labels(content_batch: List[Content]):
    labels = []
    for content in content_batch:
        # Multi-label classification prompt
        result = await gpt4o_mini.complete({
            "prompt": f"""Label this spatial content:
Text: "{content.text}"
Location: {content.place_type}

Categories (select all that apply): memory, utility, culture
Primary emotion: joy, sadness, nostalgia, excitement, peace, love, gratitude, other
Sensitivity: low, medium, high

Return JSON with confidence scores."""
        })
        labels.append(json.loads(result))

    return labels
```

#### Human-in-the-Loop Pipeline

```
LLM Auto-label → Confidence Filter → Human Review → Training Data
      │                  │                  │             │
   All content     Low confidence      Verify 10%      Final labels
                   flagged            of high conf.
```

### 3.3 Feature Engineering for Spatial Data

#### H3 Hexagonal Grid Features

```python
import h3

def extract_h3_features(lat: float, lng: float, content: List[Content]):
    h3_cell = h3.latlng_to_cell(lat, lng, 9)  # ~175m resolution

    features = {
        # Cell-level aggregates
        'cell_content_count': len([c for c in content if c.h3_cell == h3_cell]),
        'cell_avg_engagement': np.mean([c.engagement for c in content if c.h3_cell == h3_cell]),
        'cell_category_distribution': get_category_distribution(content, h3_cell),

        # Ring-based features (neighbors)
        'ring1_content_count': count_in_ring(content, h3_cell, 1),
        'ring2_content_count': count_in_ring(content, h3_cell, 2),

        # Temporal features
        'cell_activity_trend': calculate_trend(content, h3_cell, days=7),
        'cell_peak_hours': get_peak_hours(content, h3_cell)
    }

    return features
```

#### Temporal Features

```python
def extract_temporal_features(timestamp: datetime):
    return {
        'hour_sin': np.sin(2 * np.pi * timestamp.hour / 24),
        'hour_cos': np.cos(2 * np.pi * timestamp.hour / 24),
        'day_of_week': timestamp.weekday(),
        'is_weekend': timestamp.weekday() >= 5,
        'month_sin': np.sin(2 * np.pi * timestamp.month / 12),
        'month_cos': np.cos(2 * np.pi * timestamp.month / 12),
        'is_holiday': is_holiday(timestamp)
    }
```

### 3.4 Cold Start Handling

| Strategy | Target | Implementation |
|----------|--------|----------------|
| **Onboarding Quiz** | New users | 3-5 questions, map to preference vectors |
| **Popular Baseline** | New users/locations | Serve globally popular content at place type |
| **Social Seeding** | New users with friends | Import friend preferences (weighted by similarity) |
| **Content Features** | New content | Use category, emotion, author reputation |
| **Exploration Bonus** | New content | Temporary visibility boost (24-48h) |
| **Transfer Learning** | New locations | Use similar location embeddings |

### 3.5 Continuous Model Improvement

```python
# MLOps pipeline for continuous improvement
class MLOpsPipeline:
    def __init__(self, config: MLOpsConfig):
        self.experiment_tracker = mlflow.start_run()
        self.feature_store = FeatureStore()
        self.model_registry = MLflowRegistry()

    async def training_loop(self):
        while True:
            # 1. Collect new training data
            new_data = await self.feature_store.get_recent_labels(days=7)

            # 2. Retrain model
            new_model = self.train(new_data)

            # 3. Evaluate against holdout
            metrics = self.evaluate(new_model)

            # 4. Log experiment
            mlflow.log_metrics(metrics)

            # 5. Promote if improved
            if metrics['accuracy'] > self.current_best:
                self.model_registry.promote(new_model, stage='production')

            await asyncio.sleep(86400)  # Daily retraining
```

---

## 4. ML Infrastructure

### 4.1 Model Training Platforms (Free/Affordable Options)

| Platform | Free Tier | Best For | Limitations |
|----------|-----------|----------|-------------|
| **Google Colab** | 12hr sessions, T4 GPU | Experimentation, small training | Session limits, no persistence |
| **Kaggle Notebooks** | 30hr/week GPU | Competitions, prototyping | Limited storage |
| **Hugging Face Spaces** | CPU only free | Demo apps, inference | No training |
| **Modal** | $30/month credits | Production inference | Limited compute |
| **Replicate** | Pay-per-use | One-off inference | Can get expensive |
| **GitHub Codespaces** | 60hr/month | Development | Limited GPU |

### 4.2 Model Serving (Inference at Scale)

#### Recommended Architecture for CANVS

```
                          ┌──────────────────┐
                          │   Edge Inference │
                          │   (Core ML/TFLite) │
                          │   - Classification │
                          │   - Embeddings     │
                          └────────┬──────────┘
                                   │
┌──────────────────┐     ┌────────▼──────────┐     ┌──────────────────┐
│   Client App     │────▶│  Supabase Edge    │────▶│   LLM APIs       │
│   (PWA/Native)   │     │  Functions        │     │   (Claude/GPT)   │
└──────────────────┘     │  - Request routing │     │   - Complex tasks │
                         │  - Caching         │     └──────────────────┘
                         │  - Batching        │
                         └────────┬──────────┘
                                  │
                         ┌────────▼──────────┐
                         │   Vector Store    │
                         │   (pgvector)      │
                         │   - Similarity    │
                         │   - Ranking       │
                         └──────────────────┘
```

#### Inference Cost Optimization

| Strategy | Savings | Implementation |
|----------|---------|----------------|
| **Semantic caching** | 40-60% | Cache embedding results by content hash |
| **Request batching** | 20-30% | Batch similar requests over 50-100ms window |
| **Model tiering** | 50-70% | Use GPT-4o-mini for simple tasks, Sonnet for complex |
| **Edge offloading** | 60-80% | Run classification/embedding on device |
| **Result caching** | 30-50% | Cache Reality Filter results by H3 cell + user segment |

### 4.3 MLOps Tools

#### Recommended Stack for CANVS (Free Tier Focused)

| Tool | Purpose | Cost | Notes |
|------|---------|------|-------|
| **MLflow** | Experiment tracking, model registry | Free (self-hosted) | Apache 2.0 license |
| **Weights & Biases** | Experiment tracking, visualization | Free (100GB) | Best for collaboration |
| **DVC** | Data versioning | Free | Git-like for data |
| **Great Expectations** | Data validation | Free | Prevent data drift |
| **Evidently AI** | Model monitoring | Free | Detect model drift |

#### MLflow Setup for CANVS

```python
import mlflow
from mlflow.tracking import MlflowClient

# Initialize MLflow
mlflow.set_tracking_uri("sqlite:///mlflow.db")  # Local for MVP
mlflow.set_experiment("canvs-reality-filter")

# Log experiment
with mlflow.start_run():
    mlflow.log_params({
        "model_type": "hybrid_ranking",
        "embedding_model": "text-embedding-3-small",
        "llm_model": "claude-3-5-haiku"
    })

    # Train model
    model = train_reality_filter(train_data)

    # Log metrics
    mlflow.log_metrics({
        "ndcg@5": evaluate_ndcg(model, test_data, k=5),
        "mrr": evaluate_mrr(model, test_data),
        "latency_p95": measure_latency(model)
    })

    # Register model
    mlflow.sklearn.log_model(model, "reality_filter_v1")
```

### 4.4 Feature Stores

For CANVS MVP, use Supabase + Redis for feature storage:

```sql
-- Supabase feature table
CREATE TABLE ml_features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type TEXT NOT NULL, -- 'user', 'content', 'location'
    entity_id UUID NOT NULL,
    feature_name TEXT NOT NULL,
    feature_value JSONB NOT NULL,
    computed_at TIMESTAMPTZ DEFAULT NOW(),
    expires_at TIMESTAMPTZ,
    UNIQUE(entity_type, entity_id, feature_name)
);

-- Index for fast lookups
CREATE INDEX idx_features_entity ON ml_features(entity_type, entity_id);
CREATE INDEX idx_features_expires ON ml_features(expires_at) WHERE expires_at IS NOT NULL;
```

---

## 5. Privacy-Preserving ML

### 5.1 Federated Learning Opportunities

CANVS can leverage federated learning for privacy-sensitive personalization.

#### Candidate Use Cases

| Use Case | Feasibility | Privacy Benefit |
|----------|-------------|-----------------|
| **Preference learning** | High | User interests never leave device |
| **Location patterns** | High | Sensitive location data stays local |
| **Keyboard prediction** | Medium | Already proven by Google/Apple |
| **Emotion detection** | Medium | Personal emotional data protected |
| **Content ranking** | Low | Requires centralized content |

#### Implementation Approach

```python
# Using Flower framework for federated learning
import flwr as fl

class CANVSClient(fl.client.NumPyClient):
    def __init__(self, user_id: str, local_data: LocalDataset):
        self.user_id = user_id
        self.local_data = local_data
        self.model = create_local_model()

    def get_parameters(self, config):
        return self.model.get_weights()

    def fit(self, parameters, config):
        # Update local model with global parameters
        self.model.set_weights(parameters)

        # Train on local data only
        self.model.fit(
            self.local_data.features,
            self.local_data.labels,
            epochs=1
        )

        return self.model.get_weights(), len(self.local_data), {}

    def evaluate(self, parameters, config):
        self.model.set_weights(parameters)
        loss, accuracy = self.model.evaluate(
            self.local_data.test_features,
            self.local_data.test_labels
        )
        return loss, len(self.local_data.test_features), {"accuracy": accuracy}
```

### 5.2 On-Device Inference

#### Edge Models for CANVS

| Model | Size | Use Case | Framework |
|-------|------|----------|-----------|
| **Content classifier** | 5MB | Category prediction | Core ML / TFLite |
| **Emotion detector** | 10MB | Text emotion | ONNX Runtime |
| **Place type classifier** | 8MB | Location understanding | Core ML / TFLite |
| **Embedding model** | 50MB | Semantic similarity | Core ML |

#### Core ML Implementation (iOS)

```swift
import CoreML

class EdgeInference {
    private let emotionModel: EmotionClassifier
    private let categoryModel: CategoryClassifier

    init() throws {
        emotionModel = try EmotionClassifier(configuration: MLModelConfiguration())
        categoryModel = try CategoryClassifier(configuration: MLModelConfiguration())
    }

    func classifyContent(_ text: String) -> ContentClassification {
        // Run inference on device
        let emotionOutput = try? emotionModel.prediction(text: text)
        let categoryOutput = try? categoryModel.prediction(text: text)

        return ContentClassification(
            emotion: emotionOutput?.emotion ?? "unknown",
            category: categoryOutput?.category ?? "memory",
            confidence: emotionOutput?.confidence ?? 0.0
        )
    }
}
```

### 5.3 Differential Privacy

Apply differential privacy to aggregate analytics without exposing individual data.

```python
from opacus import PrivacyEngine
import torch

# Add differential privacy to model training
model = create_model()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

# Wrap with privacy engine
privacy_engine = PrivacyEngine()
model, optimizer, train_loader = privacy_engine.make_private(
    module=model,
    optimizer=optimizer,
    data_loader=train_loader,
    noise_multiplier=1.0,  # Privacy-utility tradeoff
    max_grad_norm=1.0,     # Gradient clipping
)

# Training with DP guarantees
for epoch in range(epochs):
    for batch in train_loader:
        optimizer.zero_grad()
        loss = compute_loss(model, batch)
        loss.backward()
        optimizer.step()

# Check privacy budget spent
epsilon = privacy_engine.get_epsilon(delta=1e-5)
print(f"Privacy budget (ε): {epsilon}")
```

---

## 6. Free/Affordable ML Tools

### 6.1 Hugging Face Ecosystem

| Service | Free Tier | CANVS Use Case |
|---------|-----------|----------------|
| **Hub** | Unlimited public models | Model storage, sharing |
| **Inference API** | Rate-limited | Prototyping, low-volume |
| **Spaces** | CPU-only | Demo apps, basic inference |
| **AutoTrain** | Limited credits | Quick fine-tuning |

#### Recommended Models from Hugging Face

```python
# Emotion classification
from transformers import pipeline
emotion_classifier = pipeline(
    "text-classification",
    model="j-hartmann/emotion-english-distilroberta-base"
)

# Zero-shot classification (flexible categories)
zero_shot = pipeline(
    "zero-shot-classification",
    model="facebook/bart-large-mnli"
)
result = zero_shot(
    "This is where we had our first date",
    candidate_labels=["memory", "utility", "culture"]
)

# Sentence embeddings
from sentence_transformers import SentenceTransformer
embedder = SentenceTransformer('all-MiniLM-L6-v2')
embeddings = embedder.encode(["text1", "text2"])
```

### 6.2 Google Colab for Training

```python
# Free GPU training on Colab
# 1. Mount Drive for persistence
from google.colab import drive
drive.mount('/content/drive')

# 2. Install dependencies
!pip install transformers datasets accelerate

# 3. Train model
from transformers import Trainer, TrainingArguments

training_args = TrainingArguments(
    output_dir='/content/drive/MyDrive/canvs-models',
    num_train_epochs=3,
    per_device_train_batch_size=16,
    save_steps=500,
    save_total_limit=2,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
)

trainer.train()
```

### 6.3 Startup Programs for AI Credits

| Program | Credits | Requirements |
|---------|---------|--------------|
| **OpenAI Startup** | $2,500 | Early-stage startup |
| **Anthropic Credits** | $1,000-$10,000 | Apply via program |
| **Google Cloud for Startups** | $100K over 2 years | Accepted startup |
| **AWS Activate** | $100K | Startup accelerator |
| **Azure for Startups** | $150K | Startup accelerator |
| **Modal Startup Credits** | $500/month | Y Combinator, etc. |

---

## 7. Building the "Meaning Graph"

### 7.1 Knowledge Graph Architecture

The Meaning Graph captures semantic relationships between places, content, people, and concepts.

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Meaning Graph                                │
├─────────────────────────────────────────────────────────────────────┤
│  Nodes:                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │  Place   │  │  Person  │  │  Content │  │  Concept │            │
│  │  (POI)   │  │  (User)  │  │  (Pin)   │  │  (Tag)   │            │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘            │
│       │             │             │             │                    │
│  Edges:                                                              │
│  ├── LOCATED_AT ──────────────────────────────┤                     │
│  ├── CREATED_BY ──────────────────────────────┤                     │
│  ├── TAGGED_WITH ─────────────────────────────┤                     │
│  ├── VISITED ─────────────────────────────────┤                     │
│  ├── SIMILAR_TO ──────────────────────────────┤                     │
│  ├── CONNECTED_TO (Portals) ──────────────────┤                     │
│  └── FEELS_LIKE ──────────────────────────────┤                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Entity Extraction from User Content

```typescript
async function extractEntities(content: UserContent): Promise<EntityExtractions> {
  const result = await claude.messages.create({
    model: 'claude-3-5-haiku-20241022',
    messages: [{
      role: 'user',
      content: `Extract entities from this spatial content:
Text: "${content.text}"
Location: ${content.location.name}, ${content.placeType}

Extract:
1. Named entities (people, places, organizations)
2. Temporal references (dates, times, seasons)
3. Emotional concepts
4. Activity types
5. Relationships implied

Return JSON: {
  "entities": [{ "text": "...", "type": "...", "confidence": 0-1 }],
  "temporalRefs": [{ "text": "...", "normalized": "ISO date or null" }],
  "emotions": ["..."],
  "activities": ["..."],
  "relationships": [{ "subject": "...", "predicate": "...", "object": "..." }]
}`
    }]
  });

  return JSON.parse(result.content[0].text);
}
```

### 7.3 Relationship Inference

```sql
-- Neo4j-style queries using Supabase + PostGIS

-- Find places that feel similar
WITH place_emotions AS (
  SELECT
    location_h3,
    array_agg(DISTINCT emotion_tag) as emotions,
    avg(sentiment_score) as avg_sentiment
  FROM content
  WHERE location_h3 = $target_h3
  GROUP BY location_h3
)
SELECT
  c.location_h3,
  similarity(pe.emotions, c.emotions) as emotional_similarity
FROM content c, place_emotions pe
WHERE c.location_h3 != $target_h3
  AND ST_DWithin(c.location, $location, 5000)
ORDER BY emotional_similarity DESC
LIMIT 10;
```

### 7.4 Semantic Place Embeddings

Combine multiple signals into unified place representations.

```python
import numpy as np

def compute_place_embedding(h3_cell: str, content: List[Content]) -> np.ndarray:
    """
    Compute a multi-signal place embedding.
    """
    # 1. Content embedding (average of content embeddings)
    content_emb = np.mean([c.embedding for c in content], axis=0)

    # 2. POI type embedding (from Place2Vec)
    poi_types = get_poi_types(h3_cell)
    poi_emb = np.mean([place2vec.get_embedding(t) for t in poi_types], axis=0)

    # 3. Emotion profile (from content emotion tags)
    emotion_emb = encode_emotions([c.emotion_tag for c in content])

    # 4. Temporal profile (when is this place active)
    temporal_emb = encode_temporal_pattern(content)

    # 5. Concatenate and project
    combined = np.concatenate([content_emb, poi_emb, emotion_emb, temporal_emb])
    place_embedding = projection_layer(combined)  # Project to 256 dims

    return place_embedding
```

---

## 8. Implementation Roadmap

### Phase 1: MVP (Q1 2026) - $50/month AI budget

| Feature | Models | Priority |
|---------|--------|----------|
| Content moderation | OpenAI Moderation API (free) | Critical |
| Basic categorization | GPT-4o-mini | High |
| Text embeddings | text-embedding-3-small | High |
| Simple Reality Filter | Rules + embedding similarity | High |
| Basic search | pgvector + PostGIS | High |

### Phase 2: Enhanced Intelligence (Q2-Q3 2026) - $500/month

| Feature | Models | Priority |
|---------|--------|----------|
| Full Reality Filter | Claude Haiku + caching | Critical |
| Emotion classification | DistilBERT (edge) + LLM fallback | High |
| User preference learning | Collaborative filtering | High |
| Path generation | Claude Sonnet | Medium |
| Anti-stalking detection | Custom model | Critical |

### Phase 3: Meaning Graph (Q4 2026) - $2,000/month

| Feature | Models | Priority |
|---------|--------|----------|
| Entity extraction | Claude Haiku | Medium |
| Knowledge graph | Neo4j/Supabase graph | Medium |
| Place personality profiling | Custom embeddings | Medium |
| Advanced recommendations | Hybrid ML | High |
| User segmentation | HDBSCAN clustering | Medium |

### Phase 4: Scale (2027) - $10,000+/month

| Feature | Models | Priority |
|---------|--------|----------|
| Federated learning | Flower framework | Medium |
| Custom fine-tuned models | Llama 3.x | Medium |
| Real-time personalization | Stream processing | High |
| Predictive content | Time-series ML | Medium |
| AR spatial reasoning | Vision models | Low |

---

## References

### Academic Papers
- [Place2Vec: Learning Embeddings for Place Types](https://gengchenmai.github.io/papers/2017-ACM_SIGSPATIAL17_place2vec.pdf)
- [PlaceFM: A Training-free Geospatial Foundation Model](https://arxiv.org/html/2507.02921)
- [Federated Learning: A Survey on Privacy-Preserving Collaborative Intelligence](https://arxiv.org/html/2504.17703v3)
- [Knowledge Graph Construction Using LLMs](https://www.mdpi.com/2076-3417/15/7/3727)

### Tools & Platforms
- [Hugging Face Inference API](https://huggingface.co/inference-api)
- [MLflow Documentation](https://mlflow.org/)
- [Weights & Biases](https://wandb.ai/)
- [Flower Federated Learning](https://flower.dev/)

### Industry Resources
- [MLOps Tools Comparison 2026](https://lakefs.io/blog/mlops-tools/)
- [Cold Start Problem Solutions](https://www.expressanalytics.com/blog/cold-start-problem)
- [Sentiment Analysis with Python](https://huggingface.co/blog/sentiment-analysis-python)
- [User Clustering in Recommendation Systems](https://www.geeksforgeeks.org/machine-learning/clustering-based-algorithms-in-recommendation-system/)

---

**Document Prepared By:** AI Research Agent
**Date:** January 11, 2026
**Next Review:** February 2026 (post-MVP development kickoff)
