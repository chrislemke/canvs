# AI Implementation Architecture for CANVS

## Comprehensive Technical Specifications for the Spatial Social AR Platform

**Version:** 1.0.0
**Date:** January 2026
**Status:** Architecture Planning
**Related Documents:**
- [tech_specs.md](../../mvp/specs/tech_specs.md)
- [visionary_feature_integrations.md](./visionary_feature_integrations.md)
- [GPS Precision Research](../../../research/gps_precision/intro.md)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [LLM Model Comparison for Spatial Apps](#2-llm-model-comparison-for-spatial-apps)
3. [Vector Database Architecture](#3-vector-database-architecture)
4. [Edge vs Cloud Inference Trade-offs](#4-edge-vs-cloud-inference-trade-offs)
5. [Cost Analysis](#5-cost-analysis)
6. [Implementation Patterns](#6-implementation-patterns)
7. [Recommended Architecture](#7-recommended-architecture)
8. [Security and Privacy Considerations](#8-security-and-privacy-considerations)
9. [Future Roadmap](#9-future-roadmap)

---

## 1. Executive Summary

### The AI Challenge for CANVS

CANVS requires AI capabilities across multiple domains:

1. **Reality Filter (Core):** Personalized content curation based on user preferences, location context, and emotional intent
2. **Content Moderation:** Real-time text, image, and audio moderation for safety
3. **Semantic Search:** Finding memories by meaning, emotion, and context
4. **Conversational AI:** AR tour guides and location-based NPCs
5. **Generative Features:** Text-to-AR content creation (future)

### Key Recommendations

| Capability | Recommended Solution | Rationale |
|------------|---------------------|-----------|
| Primary LLM | Claude API (Anthropic) | Best reasoning, context handling, safety |
| Fast Operations | GPT-4o-mini / Haiku | Speed + cost for simple tasks |
| Content Moderation | OpenAI Moderation API | Free, multimodal, accurate |
| Vector Database | PostgreSQL + pgvector | Integrated with existing stack |
| Semantic Cache | Redis + vector similarity | Low-latency repeated queries |
| Edge Inference | Core ML / TensorFlow Lite | Privacy-sensitive features |

### Architecture Philosophy

```
"AI as the Reality Filter, not a chatbot"
```

CANVS AI should feel like an extension of user perception, surfacing relevant content without requiring explicit queries. The AI layer should be:

- **Invisible:** Works in the background to filter and prioritize
- **Personal:** Adapts to individual preferences and context
- **Safe:** Prevents harmful content and protects privacy
- **Efficient:** Balances quality with cost and latency

---

## 2. LLM Model Comparison for Spatial Apps

### 2.1 Model Evaluation Matrix

| Model | Context Window | Multimodal | Latency (TTFT) | Cost (1M tokens) | Best For |
|-------|---------------|------------|----------------|------------------|----------|
| **Claude 3.5 Sonnet** | 200K | Text + Images | ~800ms | $3 in / $15 out | Complex reasoning, safety |
| **Claude 3.5 Haiku** | 200K | Text + Images | ~300ms | $0.25 in / $1.25 out | Fast responses, cost-efficient |
| **GPT-4o** | 128K | Text + Images + Audio | ~400ms | $2.50 in / $10 out | Multimodal, real-time |
| **GPT-4o-mini** | 128K | Text + Images | ~200ms | $0.15 in / $0.60 out | High volume, simple tasks |
| **Gemini 1.5 Pro** | 2M | Text + Images + Video | ~600ms | $1.25 in / $5 out | Long context, cost-effective |
| **Gemini 1.5 Flash** | 1M | Text + Images + Video | ~200ms | $0.075 in / $0.30 out | Speed + long context |
| **Llama 3.1 405B** | 128K | Text | Variable | Self-hosted | Fine-tuning, privacy |
| **Llama 3.1 70B** | 128K | Text | Variable | Self-hosted | Balance of capability + cost |

### 2.2 Detailed Model Analysis

#### Claude API (Anthropic)

**Strengths for CANVS:**
- Superior reasoning for complex spatial queries ("find places where people felt nostalgic")
- Best-in-class safety and content filtering
- Excellent at following nuanced instructions
- 200K context enables rich location history analysis
- Constitutional AI reduces harmful outputs

**Optimal Use Cases:**
- Reality Filter personalization logic
- Complex semantic search queries
- Safety-critical content decisions
- Generating location narratives and summaries

**Implementation Pattern:**
```typescript
// Reality Filter Query Pattern
async function filterContentForUser(
  userId: string,
  nearbyContent: SpatialContent[],
  userContext: UserContext
): Promise<FilteredContent[]> {
  const prompt = `You are a Reality Filter for a spatial social platform.

User Profile:
- Interests: ${userContext.interests.join(', ')}
- Current mood: ${userContext.mood || 'neutral'}
- Time of day: ${userContext.timeOfDay}
- Movement pattern: ${userContext.isWalking ? 'walking' : 'stationary'}

Nearby Content (${nearbyContent.length} items):
${nearbyContent.map(c => `- [${c.id}] ${c.category}: "${c.preview}" (${c.distanceM}m away, ${c.reactions} reactions)`).join('\n')}

Select and rank the TOP 5 most relevant items for this user right now.
Return JSON: [{ "id": string, "relevanceScore": 0-1, "reason": string }]`;

  const response = await anthropic.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 1024,
    messages: [{ role: 'user', content: prompt }]
  });

  return JSON.parse(response.content[0].text);
}
```

**Pricing (January 2026):**
- Claude 3.5 Sonnet: $3/1M input, $15/1M output
- Claude 3.5 Haiku: $0.25/1M input, $1.25/1M output
- Claude 3 Opus: $15/1M input, $75/1M output

#### GPT-4o / GPT-4 Turbo (OpenAI)

**Strengths for CANVS:**
- Native multimodal (text + images + audio in single call)
- Fastest response times among frontier models
- Real-time audio processing for voice notes
- Excellent at structured output (JSON mode)
- Largest ecosystem of tools and integrations

**Optimal Use Cases:**
- Image understanding (what's in this photo?)
- Voice note transcription and understanding
- Real-time conversational AR guides
- Structured data extraction from content

**Implementation Pattern:**
```typescript
// Multimodal Content Analysis
async function analyzeUserContent(
  text: string | null,
  imageUrl: string | null,
  audioUrl: string | null
): Promise<ContentAnalysis> {
  const messages = [];

  const content = [];
  if (text) content.push({ type: 'text', text });
  if (imageUrl) content.push({ type: 'image_url', image_url: { url: imageUrl } });
  if (audioUrl) {
    // First transcribe audio
    const transcription = await openai.audio.transcriptions.create({
      file: await fetch(audioUrl).then(r => r.blob()),
      model: 'whisper-1'
    });
    content.push({ type: 'text', text: `[Audio transcription]: ${transcription.text}` });
  }

  content.push({
    type: 'text',
    text: `Analyze this content for a spatial social platform:
1. Primary emotion conveyed
2. Key topics/themes
3. Appropriate category (memory, utility, culture)
4. Suggested tags (max 5)
5. Privacy sensitivity (low/medium/high)

Return as JSON.`
  });

  const response = await openai.chat.completions.create({
    model: 'gpt-4o',
    messages: [{ role: 'user', content }],
    response_format: { type: 'json_object' }
  });

  return JSON.parse(response.choices[0].message.content);
}
```

**Pricing (January 2026):**
- GPT-4o: $2.50/1M input, $10/1M output
- GPT-4o-mini: $0.15/1M input, $0.60/1M output
- Whisper: $0.006/minute

#### Gemini Pro (Google)

**Strengths for CANVS:**
- 2M token context window (1M for Flash)
- Native video understanding
- Cost-effective for high-volume operations
- Google Maps integration potential
- Grounding with Google Search

**Optimal Use Cases:**
- Processing long location histories
- Video memory analysis
- Cost-optimized batch operations
- Integration with Google spatial services

**Implementation Pattern:**
```typescript
// Long Context Location History Analysis
async function analyzeLocationHistory(
  userId: string,
  historyDays: number = 365
): Promise<LocationInsights> {
  const history = await getLocationHistory(userId, historyDays);

  // Gemini can handle massive context
  const prompt = `Analyze this user's location history and spatial social interactions over ${historyDays} days:

${JSON.stringify(history, null, 2)}

Provide insights:
1. Most meaningful places (by engagement, not just frequency)
2. Temporal patterns (when do they explore vs revisit?)
3. Social patterns (who do they share places with?)
4. Predicted interests for content discovery
5. Suggested "memory walks" connecting meaningful locations

Return structured JSON.`;

  const response = await genai.generateContent({
    model: 'gemini-1.5-pro',
    contents: [{ role: 'user', parts: [{ text: prompt }] }],
    generationConfig: { responseMimeType: 'application/json' }
  });

  return JSON.parse(response.response.text());
}
```

**Pricing (January 2026):**
- Gemini 1.5 Pro: $1.25/1M input (up to 128K), $5/1M output
- Gemini 1.5 Pro: $2.50/1M input (128K-2M), $10/1M output
- Gemini 1.5 Flash: $0.075/1M input, $0.30/1M output

#### Open-Source Models (Llama 3, Mistral)

**Strengths for CANVS:**
- Full control over model behavior
- No data leaves your infrastructure
- One-time cost (compute) vs per-token
- Fine-tuning for CANVS-specific tasks
- Edge deployment possible

**Optimal Use Cases:**
- Privacy-critical operations (location processing)
- High-volume, low-complexity tasks
- Custom fine-tuned models for CANVS vocabulary
- Offline/edge inference

**Deployment Options:**

| Option | Cost | Latency | Scalability | Best For |
|--------|------|---------|-------------|----------|
| Self-hosted (GPU) | $2-10/hr | ~100ms | Manual | Development, testing |
| Together.ai | $0.90/1M (70B) | ~200ms | Auto | Production fallback |
| Fireworks.ai | $0.90/1M (70B) | ~150ms | Auto | Low-latency needs |
| Replicate | Pay-per-use | Variable | Auto | Burst capacity |
| Modal | $1.20/1M | ~100ms | Auto | Fine-tuned models |

**Fine-Tuning Considerations:**

```python
# Example: Fine-tuning Llama 3 for CANVS content classification
from transformers import AutoModelForSequenceClassification, Trainer

# CANVS-specific training data
training_data = [
    {"text": "This is where we first met, exactly 3 years ago today", "label": "memory"},
    {"text": "Hidden entrance around back, ring twice", "label": "utility"},
    {"text": "Best mural in the neighborhood, @artist_handle", "label": "culture"},
    # ... thousands more examples
]

# Fine-tune for content classification
model = AutoModelForSequenceClassification.from_pretrained(
    "meta-llama/Llama-3.1-8B",
    num_labels=3  # memory, utility, culture
)

trainer = Trainer(
    model=model,
    train_dataset=training_data,
    # ... training config
)
trainer.train()
```

### 2.3 Model Selection Decision Tree

```
                    ┌─────────────────────────────────────┐
                    │        What's the task?             │
                    └─────────────────┬───────────────────┘
                                      │
           ┌──────────────────────────┼──────────────────────────┐
           │                          │                          │
           ▼                          ▼                          ▼
   ┌───────────────┐         ┌───────────────┐         ┌───────────────┐
   │   Complex     │         │    Simple     │         │   Multimodal  │
   │   Reasoning   │         │   Tasks       │         │   (img/audio) │
   └───────┬───────┘         └───────┬───────┘         └───────┬───────┘
           │                          │                          │
           ▼                          ▼                          ▼
   ┌───────────────┐         ┌───────────────┐         ┌───────────────┐
   │ Safety-       │         │ High Volume?  │         │ Real-time?    │
   │ Critical?     │         │               │         │               │
   └───────┬───────┘         └───────┬───────┘         └───────┬───────┘
           │                          │                          │
     ┌─────┴─────┐             ┌──────┴──────┐            ┌──────┴──────┐
     │           │             │             │            │             │
     ▼           ▼             ▼             ▼            ▼             ▼
 ┌───────┐  ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐
 │Claude │  │Claude │    │Gemini │    │GPT-4o │    │GPT-4o │    │Gemini │
 │Sonnet │  │Haiku  │    │Flash  │    │mini   │    │       │    │Flash  │
 └───────┘  └───────┘    └───────┘    └───────┘    └───────┘    └───────┘
  (Yes)      (No)        (Yes)         (No)        (Yes)         (No)
```

### 2.4 Hybrid Model Strategy for CANVS

**Recommended Multi-Model Architecture:**

```typescript
interface ModelRouter {
  // Route requests to optimal model based on task characteristics
  route(task: AITask): ModelConfig;
}

const modelConfig = {
  // Tier 1: High-stakes, complex reasoning
  'reality-filter-personalization': {
    model: 'claude-3-5-sonnet-20241022',
    fallback: 'gpt-4o',
    maxTokens: 2048,
    temperature: 0.3
  },

  // Tier 2: Real-time, multimodal
  'content-analysis-multimodal': {
    model: 'gpt-4o',
    fallback: 'gemini-1.5-pro',
    maxTokens: 1024,
    temperature: 0.1
  },

  // Tier 3: High-volume, simple
  'content-classification': {
    model: 'gpt-4o-mini',
    fallback: 'gemini-1.5-flash',
    maxTokens: 256,
    temperature: 0.0
  },

  // Tier 4: Content moderation (specialized)
  'content-moderation': {
    model: 'omni-moderation-latest',  // OpenAI free moderation
    fallback: 'claude-3-5-haiku-20241022',
    maxTokens: 512
  },

  // Tier 5: Long context analysis
  'history-analysis': {
    model: 'gemini-1.5-pro',
    fallback: 'claude-3-5-sonnet-20241022',
    maxTokens: 4096,
    temperature: 0.2
  },

  // Tier 6: Privacy-sensitive (self-hosted)
  'location-processing': {
    model: 'llama-3.1-8b-instruct',  // Self-hosted
    fallback: 'gpt-4o-mini',
    maxTokens: 512,
    temperature: 0.0
  }
};
```

---

## 3. Vector Database Architecture

### 3.1 Why Vector Search for CANVS

CANVS requires semantic understanding beyond keyword matching:

- **Emotion-based discovery:** "Show me places where people felt peaceful"
- **Similarity search:** "Find posts similar to this memory"
- **Personalization:** Match user preferences to content
- **Deduplication:** Identify semantically similar content

### 3.2 Vector Database Options

| Database | Hosting | Cost Model | Max Vectors | Query Latency | Best For |
|----------|---------|------------|-------------|---------------|----------|
| **pgvector** | Self/Supabase | DB cost | 10M+ | 10-50ms | Integration with PostgreSQL |
| **Pinecone** | Managed | $0.096/1M vec/mo | 10B+ | 10-20ms | Large scale, managed |
| **Weaviate** | Self/Cloud | Self-hosted free | 100M+ | 5-20ms | Hybrid search |
| **Qdrant** | Self/Cloud | Self-hosted free | 100M+ | 5-15ms | Performance, filtering |
| **Milvus** | Self/Cloud | Self-hosted free | 1B+ | 1-10ms | Massive scale |
| **Chroma** | Self/Cloud | Self-hosted free | 10M | 10-30ms | Simplicity |

### 3.3 Recommended: PostgreSQL + pgvector + PostGIS Integration

**Why pgvector for CANVS:**

1. **Already using PostgreSQL:** Supabase stack includes PostgreSQL
2. **Spatial + Semantic in one query:** Combine PostGIS geometry with vector similarity
3. **Transactional consistency:** ACID guarantees with content data
4. **Lower operational complexity:** One database to manage
5. **Cost-effective:** No additional service costs

**Schema Design:**

```sql
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS h3;

-- Content embeddings table
CREATE TABLE content_embeddings (
    id UUID PRIMARY KEY REFERENCES posts(id) ON DELETE CASCADE,

    -- Text embedding (1536 dimensions for OpenAI ada-002)
    text_embedding vector(1536),

    -- Image embedding (512 dimensions for CLIP)
    image_embedding vector(512),

    -- Combined/fused embedding
    content_embedding vector(768),

    -- Metadata for filtering
    category TEXT NOT NULL,
    emotion_tags TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW(),

    -- Spatial reference (denormalized for query efficiency)
    location GEOGRAPHY(POINT, 4326),
    h3_cell_res9 TEXT
);

-- Optimized indexes
CREATE INDEX idx_text_embedding ON content_embeddings
    USING ivfflat (text_embedding vector_cosine_ops) WITH (lists = 100);

CREATE INDEX idx_content_embedding ON content_embeddings
    USING hnsw (content_embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);

CREATE INDEX idx_location ON content_embeddings USING GIST (location);
CREATE INDEX idx_h3_cell ON content_embeddings (h3_cell_res9);
CREATE INDEX idx_category ON content_embeddings (category);

-- User preference embeddings
CREATE TABLE user_preference_embeddings (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,

    -- Learned preference vector (updated periodically)
    preference_embedding vector(768),

    -- Interest categories with weights
    interest_weights JSONB DEFAULT '{}',

    -- Last interaction embeddings (for recent context)
    recent_interactions vector(768)[],

    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Hybrid Spatial + Semantic Query:**

```sql
-- Find semantically similar content within spatial radius
CREATE OR REPLACE FUNCTION find_relevant_content(
    user_lat DOUBLE PRECISION,
    user_lng DOUBLE PRECISION,
    radius_m INTEGER,
    user_preference_embedding vector(768),
    emotion_filter TEXT[] DEFAULT NULL,
    limit_count INTEGER DEFAULT 20
)
RETURNS TABLE (
    post_id UUID,
    distance_m DOUBLE PRECISION,
    semantic_similarity DOUBLE PRECISION,
    combined_score DOUBLE PRECISION,
    category TEXT,
    preview TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH spatial_candidates AS (
        -- First filter by spatial proximity (uses spatial index)
        SELECT
            ce.id,
            ce.content_embedding,
            ce.category,
            p.text_content,
            ST_Distance(ce.location, ST_MakePoint(user_lng, user_lat)::geography) as dist_m
        FROM content_embeddings ce
        JOIN posts p ON ce.id = p.id
        WHERE ST_DWithin(
            ce.location,
            ST_MakePoint(user_lng, user_lat)::geography,
            radius_m
        )
        AND (emotion_filter IS NULL OR ce.emotion_tags && emotion_filter)
        AND p.is_flagged = FALSE
    )
    SELECT
        sc.id as post_id,
        sc.dist_m as distance_m,
        1 - (sc.content_embedding <=> user_preference_embedding) as semantic_similarity,
        -- Combined scoring: 60% semantic, 30% proximity, 10% recency
        (
            0.6 * (1 - (sc.content_embedding <=> user_preference_embedding)) +
            0.3 * (1 - LEAST(sc.dist_m / radius_m, 1)) +
            0.1 * (1 - EXTRACT(EPOCH FROM (NOW() - p.created_at)) / 86400 / 30)
        ) as combined_score,
        sc.category,
        LEFT(sc.text_content, 100) as preview
    FROM spatial_candidates sc
    JOIN posts p ON sc.id = p.id
    ORDER BY combined_score DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;
```

### 3.4 Embedding Generation Pipeline

```typescript
import OpenAI from 'openai';

const openai = new OpenAI();

// Generate text embeddings
async function generateTextEmbedding(text: string): Promise<number[]> {
  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',  // 1536 dimensions, $0.02/1M tokens
    input: text,
    encoding_format: 'float'
  });
  return response.data[0].embedding;
}

// Generate image embeddings (using CLIP via API)
async function generateImageEmbedding(imageUrl: string): Promise<number[]> {
  // Option 1: Use Replicate's CLIP
  const response = await replicate.run(
    "openai/clip-vit-base-patch32:embedding",
    { input: { image: imageUrl } }
  );
  return response.embedding;

  // Option 2: Self-hosted CLIP (more cost-effective at scale)
  // return await clipService.embed(imageUrl);
}

// Fused content embedding
async function generateContentEmbedding(
  text: string | null,
  imageUrl: string | null
): Promise<number[]> {
  const embeddings: number[][] = [];

  if (text) {
    embeddings.push(await generateTextEmbedding(text));
  }

  if (imageUrl) {
    const imgEmb = await generateImageEmbedding(imageUrl);
    // Pad/project to same dimension if needed
    embeddings.push(projectTo768(imgEmb));
  }

  // Weighted average fusion
  if (embeddings.length === 2) {
    return weightedAverage(embeddings, [0.6, 0.4]);  // Favor text
  }
  return embeddings[0];
}
```

### 3.5 Caching Strategy for Real-Time AR

**Redis Vector Similarity Cache:**

```typescript
import { createClient } from 'redis';
import { SchemaFieldTypes, VectorAlgorithms } from 'redis';

const redis = createClient({ url: process.env.REDIS_URL });

// Create vector index for frequently accessed areas
await redis.ft.create('idx:hot_content', {
  '$.embedding': {
    type: SchemaFieldTypes.VECTOR,
    ALGORITHM: VectorAlgorithms.HNSW,
    TYPE: 'FLOAT32',
    DIM: 768,
    DISTANCE_METRIC: 'COSINE'
  },
  '$.h3_cell': { type: SchemaFieldTypes.TAG },
  '$.category': { type: SchemaFieldTypes.TAG }
}, {
  ON: 'JSON',
  PREFIX: 'content:'
});

// Cache hot content for active H3 cells
async function cacheHotContent(h3Cell: string, content: ContentWithEmbedding[]) {
  const pipeline = redis.multi();

  for (const item of content) {
    pipeline.json.set(`content:${item.id}`, '$', {
      id: item.id,
      embedding: item.embedding,
      h3_cell: h3Cell,
      category: item.category,
      preview: item.preview,
      cached_at: Date.now()
    });
    pipeline.expire(`content:${item.id}`, 3600);  // 1 hour TTL
  }

  await pipeline.exec();
}

// Fast vector search in cache
async function searchCachedContent(
  h3Cell: string,
  queryEmbedding: number[],
  limit: number = 10
): Promise<CachedContent[]> {
  const results = await redis.ft.search('idx:hot_content',
    `(@h3_cell:{${h3Cell}})=>[KNN ${limit} @embedding $query_vec AS score]`,
    {
      PARAMS: { query_vec: Buffer.from(new Float32Array(queryEmbedding).buffer) },
      SORTBY: 'score',
      DIALECT: 2
    }
  );

  return results.documents.map(doc => ({
    ...doc.value,
    similarity: 1 - parseFloat(doc.value.score)
  }));
}
```

### 3.6 Scaling Considerations

**Vector Count Projections:**

| Stage | Posts | Embeddings | Storage | Index Size |
|-------|-------|------------|---------|------------|
| MVP (10K users) | 50K | 50K | ~300MB | ~100MB |
| Growth (100K users) | 500K | 500K | ~3GB | ~1GB |
| Scale (1M users) | 5M | 5M | ~30GB | ~10GB |
| Mass (10M users) | 50M | 50M | ~300GB | ~100GB |

**When to Consider Dedicated Vector DB:**

- >10M vectors: Consider Pinecone or Qdrant Cloud
- Complex hybrid queries: Consider Weaviate
- Ultra-low latency (<5ms): Consider Milvus
- Multi-tenancy requirements: Consider Pinecone namespaces

---

## 4. Edge vs Cloud Inference Trade-offs

### 4.1 Trade-off Matrix

| Factor | Edge Inference | Cloud Inference |
|--------|---------------|-----------------|
| **Latency** | 10-100ms | 200-2000ms |
| **Privacy** | Data stays on device | Data sent to servers |
| **Model Size** | Limited (100MB-2GB) | Unlimited |
| **Capability** | Simple tasks | Complex reasoning |
| **Cost** | Device compute | Per-request |
| **Offline** | Yes | No |
| **Updates** | App update required | Instant |
| **Battery** | Higher drain | Minimal |

### 4.2 Edge Inference Use Cases for CANVS

**Ideal for Edge:**
1. **On-device content classification** (is this a memory, utility, or culture post?)
2. **Local sentiment detection** (basic emotion tagging)
3. **Image feature extraction** (for deduplication, basic tagging)
4. **Privacy-sensitive location processing**
5. **Offline content preview generation**

**Implementation with Core ML (iOS):**

```swift
import CoreML
import Vision

class OnDeviceContentClassifier {
    private let model: VNCoreMLModel

    init() throws {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndNeuralEngine  // Use Neural Engine

        let mlModel = try CANVSContentClassifier(configuration: config)
        self.model = try VNCoreMLModel(for: mlModel.model)
    }

    func classifyContent(text: String, image: UIImage?) async -> ContentClassification {
        var results: [String: Float] = [:]

        // Text classification
        if !text.isEmpty {
            let textRequest = VNCoreMLRequest(model: model)
            // ... process text
        }

        // Image classification
        if let image = image {
            let imageRequest = VNCoreMLRequest(model: model) { request, error in
                guard let observations = request.results as? [VNClassificationObservation] else { return }
                for observation in observations {
                    results[observation.identifier] = observation.confidence
                }
            }

            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            try? handler.perform([imageRequest])
        }

        return ContentClassification(
            category: results.max(by: { $0.value < $1.value })?.key ?? "unknown",
            confidence: results.values.max() ?? 0
        )
    }
}
```

**Implementation with TensorFlow Lite (Android):**

```kotlin
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.image.TensorImage

class OnDeviceClassifier(context: Context) {
    private val interpreter: Interpreter

    init {
        val model = FileUtil.loadMappedFile(context, "canvs_classifier.tflite")
        val options = Interpreter.Options().apply {
            setNumThreads(4)
            addDelegate(NnApiDelegate())  // Use Neural Network API
        }
        interpreter = Interpreter(model, options)
    }

    fun classify(text: String, image: Bitmap?): ContentClassification {
        // Prepare inputs
        val textEmbedding = encodeText(text)
        val imageFeatures = image?.let { extractFeatures(it) } ?: FloatArray(512)

        // Run inference
        val output = Array(1) { FloatArray(3) }  // 3 categories
        interpreter.run(arrayOf(textEmbedding, imageFeatures), output)

        val categories = listOf("memory", "utility", "culture")
        val maxIdx = output[0].indices.maxByOrNull { output[0][it] } ?: 0

        return ContentClassification(
            category = categories[maxIdx],
            confidence = output[0][maxIdx]
        )
    }
}
```

### 4.3 Hybrid Edge-Cloud Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          User Device                                 │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     Edge ML Layer                            │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │   │
│  │  │   Content    │  │   Emotion    │  │  Location        │   │   │
│  │  │  Classifier  │  │  Detector    │  │  Processor       │   │   │
│  │  │  (Core ML)   │  │  (TF Lite)   │  │  (On-device)     │   │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              │ Pre-processed data                   │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Decision Layer                            │   │
│  │  • If confidence > 0.9 → Use edge result                    │   │
│  │  • If complex query → Send to cloud                         │   │
│  │  • If privacy-sensitive → Keep on device                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
                                │ HTTPS (when needed)
                                ▼
┌───────────────────────────────────────────────────────────────────────┐
│                            Cloud AI Layer                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐   │
│  │  Claude API     │  │  GPT-4o        │  │  Vector Search      │   │
│  │  (Complex       │  │  (Multimodal    │  │  (Semantic          │   │
│  │   reasoning)    │  │   analysis)     │  │   discovery)        │   │
│  └─────────────────┘  └─────────────────┘  └─────────────────────┘   │
└───────────────────────────────────────────────────────────────────────┘
```

### 4.4 Model Compression for Edge

**Techniques for Edge Deployment:**

| Technique | Size Reduction | Accuracy Loss | Implementation |
|-----------|---------------|---------------|----------------|
| Quantization (INT8) | 4x | 1-3% | TFLite, Core ML |
| Pruning | 2-10x | 2-5% | TensorFlow |
| Knowledge Distillation | N/A (smaller model) | 3-10% | Custom training |
| ONNX Optimization | 1.5-2x | <1% | ONNX Runtime |

**Example: Distilling Claude to Edge Model:**

```python
# Distill Claude's classification behavior to a small model
from transformers import DistilBertForSequenceClassification

# Generate training data from Claude
training_data = []
for text in sample_texts:
    # Get Claude's classification
    claude_response = await anthropic.messages.create(
        model='claude-3-5-sonnet-20241022',
        messages=[{
            'role': 'user',
            'content': f'Classify this CANVS post into memory/utility/culture: "{text}"'
        }]
    )
    training_data.append({
        'text': text,
        'label': claude_response.content[0].text.lower()
    })

# Train small model to mimic Claude
student_model = DistilBertForSequenceClassification.from_pretrained(
    'distilbert-base-uncased',
    num_labels=3
)

# Train and export to Core ML / TFLite
# ... training code ...

# Export
import coremltools as ct
coreml_model = ct.convert(student_model, source='pytorch')
coreml_model.save('CANVSContentClassifier.mlpackage')
```

---

## 5. Cost Analysis

### 5.1 Per-Operation Cost Breakdown

**Content Creation (per post):**

| Operation | Model | Tokens/Units | Cost |
|-----------|-------|--------------|------|
| Content moderation | OpenAI Moderation | 1 call | $0 (free) |
| Text embedding | text-embedding-3-small | ~100 tokens | $0.000002 |
| Image embedding | CLIP (Replicate) | 1 image | $0.0001 |
| Classification | GPT-4o-mini | ~200 tokens | $0.00009 |
| **Total per post** | | | **~$0.0002** |

**Content Discovery (per query):**

| Operation | Model | Tokens/Units | Cost |
|-----------|-------|--------------|------|
| Query embedding | text-embedding-3-small | ~50 tokens | $0.000001 |
| Vector search | pgvector | 1 query | $0 (included) |
| Result ranking | GPT-4o-mini | ~500 tokens | $0.00023 |
| **Total per query** | | | **~$0.0003** |

**Reality Filter (per user session):**

| Operation | Model | Tokens/Units | Cost |
|-----------|-------|--------------|------|
| User preference analysis | Claude Haiku | ~1000 tokens | $0.00075 |
| Batch content filtering | GPT-4o-mini | ~2000 tokens | $0.0009 |
| Personalization | Claude Haiku | ~500 tokens | $0.00038 |
| **Total per session** | | | **~$0.002** |

### 5.2 Projected Monthly Costs by Scale

**Assumptions:**
- Average user creates 3 posts/month
- Average user performs 50 discovery queries/month
- Average user has 20 sessions/month (Reality Filter)
- 20% of content requires image analysis

| Users | Posts | Queries | Sessions | Est. Monthly AI Cost |
|-------|-------|---------|----------|---------------------|
| 1,000 | 3K | 50K | 20K | ~$60 |
| 10,000 | 30K | 500K | 200K | ~$600 |
| 100,000 | 300K | 5M | 2M | ~$6,000 |
| 1,000,000 | 3M | 50M | 20M | ~$60,000 |

### 5.3 Cost Optimization Strategies

**1. Semantic Caching:**

```typescript
// Cache embedding + response for similar queries
class SemanticCache {
  private redis: Redis;
  private similarityThreshold = 0.95;

  async getOrCompute<T>(
    query: string,
    computeFn: () => Promise<T>
  ): Promise<T> {
    const queryEmbedding = await generateEmbedding(query);

    // Search for similar cached queries
    const cached = await this.findSimilar(queryEmbedding);
    if (cached && cached.similarity > this.similarityThreshold) {
      return cached.response as T;
    }

    // Compute and cache
    const response = await computeFn();
    await this.cache(query, queryEmbedding, response);
    return response;
  }
}

// Usage
const cache = new SemanticCache();
const result = await cache.getOrCompute(
  "find peaceful places nearby",
  () => llmReasonAboutContent(nearbyContent, "peaceful")
);
```

**Estimated Savings:** 40-60% for repeated query patterns

**2. Request Batching:**

```typescript
// Batch multiple embeddings in one API call
async function batchEmbed(texts: string[]): Promise<number[][]> {
  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: texts  // Up to 2048 texts per call
  });
  return response.data.map(d => d.embedding);
}

// Batch process content queue
const pendingContent: ContentItem[] = [];
setInterval(async () => {
  if (pendingContent.length === 0) return;

  const batch = pendingContent.splice(0, 100);
  const texts = batch.map(c => c.text);
  const embeddings = await batchEmbed(texts);

  // Store embeddings
  await bulkInsertEmbeddings(batch.map((c, i) => ({
    id: c.id,
    embedding: embeddings[i]
  })));
}, 1000);  // Process every second
```

**Estimated Savings:** 20-30% from reduced API overhead

**3. Tiered Model Selection:**

```typescript
// Route to cheapest sufficient model
function selectModel(task: AITask): ModelConfig {
  // Simple classification → smallest model
  if (task.type === 'classification' && task.complexity === 'low') {
    return { model: 'gpt-4o-mini', maxTokens: 100 };
  }

  // Multimodal → GPT-4o (native support)
  if (task.hasImages || task.hasAudio) {
    return { model: 'gpt-4o', maxTokens: 500 };
  }

  // Complex reasoning → Claude (best quality)
  if (task.requiresReasoning || task.safetyCritical) {
    return { model: 'claude-3-5-sonnet-20241022', maxTokens: 1000 };
  }

  // Default → cost-effective
  return { model: 'gemini-1.5-flash', maxTokens: 500 };
}
```

**Estimated Savings:** 50-70% vs using top model for everything

**4. Edge Offloading:**

```typescript
// Use edge for high-frequency, simple tasks
async function classifyContent(content: ContentItem): Promise<Classification> {
  // Try edge first
  if (isEdgeCapable() && content.textLength < 500) {
    const edgeResult = await edgeClassifier.classify(content);
    if (edgeResult.confidence > 0.9) {
      return edgeResult;  // No cloud cost
    }
  }

  // Fall back to cloud
  return await cloudClassifier.classify(content);
}
```

**Estimated Savings:** 60-80% for simple classification tasks

### 5.4 Vector Database Cost Comparison

| Solution | 1M Vectors | 10M Vectors | 100M Vectors |
|----------|------------|-------------|--------------|
| pgvector (Supabase Pro) | $25/mo (included) | $25/mo | $100/mo (Team) |
| Pinecone Starter | $0 | N/A | N/A |
| Pinecone Standard | $70/mo | $700/mo | $7,000/mo |
| Qdrant Cloud | $50/mo | $200/mo | $1,500/mo |
| Weaviate Cloud | $25/mo | $100/mo | $800/mo |
| Self-hosted (AWS) | ~$100/mo | ~$400/mo | ~$2,000/mo |

**Recommendation:** Start with pgvector (included in Supabase), migrate to dedicated solution at >10M vectors or <10ms latency requirements.

---

## 6. Implementation Patterns

### 6.1 Reality Filter Implementation

The Reality Filter is the core AI feature - it makes CANVS feel personalized without explicit queries.

```typescript
// Reality Filter Service
class RealityFilterService {
  constructor(
    private llmClient: LLMClient,
    private vectorDb: VectorDatabase,
    private cache: SemanticCache
  ) {}

  async filterForUser(
    userId: string,
    userLocation: GeoPoint,
    nearbyContent: SpatialContent[]
  ): Promise<FilteredContent[]> {
    // 1. Get user context
    const userContext = await this.buildUserContext(userId);

    // 2. Pre-filter by basic relevance
    const candidates = await this.preFilter(nearbyContent, userContext);

    // 3. Compute semantic relevance scores
    const scored = await this.scoreBySemanticRelevance(
      candidates,
      userContext.preferenceEmbedding
    );

    // 4. Apply LLM reasoning for final ranking
    const ranked = await this.llmRank(scored, userContext);

    // 5. Apply safety and diversity constraints
    return this.postProcess(ranked);
  }

  private async buildUserContext(userId: string): Promise<UserContext> {
    const [profile, history, preferences] = await Promise.all([
      this.getProfile(userId),
      this.getRecentHistory(userId, 30),  // Last 30 days
      this.getPreferenceEmbedding(userId)
    ]);

    return {
      interests: profile.interests,
      avoidTopics: profile.avoidTopics,
      preferenceEmbedding: preferences,
      recentInteractions: history.map(h => h.category),
      timeOfDay: this.getTimeCategory(),
      dayOfWeek: new Date().getDay(),
      mood: await this.inferMood(history)
    };
  }

  private async preFilter(
    content: SpatialContent[],
    context: UserContext
  ): Promise<SpatialContent[]> {
    return content.filter(c => {
      // Remove content from blocked users
      if (context.blockedUsers.includes(c.authorId)) return false;

      // Remove content in avoided topics
      if (c.tags.some(t => context.avoidTopics.includes(t))) return false;

      // Keep if matches any interest
      if (c.tags.some(t => context.interests.includes(t))) return true;

      // Keep if high engagement
      if (c.engagementScore > 0.8) return true;

      // Keep recent content for serendipity
      if (Date.now() - c.createdAt.getTime() < 86400000) return true;

      return false;
    });
  }

  private async scoreBySemanticRelevance(
    content: SpatialContent[],
    userEmbedding: number[]
  ): Promise<ScoredContent[]> {
    // Batch retrieve embeddings
    const embeddings = await this.vectorDb.getEmbeddings(content.map(c => c.id));

    // Compute cosine similarities
    return content.map((c, i) => ({
      ...c,
      semanticScore: cosineSimilarity(embeddings[i], userEmbedding)
    }));
  }

  private async llmRank(
    content: ScoredContent[],
    context: UserContext
  ): Promise<RankedContent[]> {
    // Use cache for similar contexts
    const cacheKey = this.buildContextCacheKey(context);

    return this.cache.getOrCompute(cacheKey, async () => {
      const prompt = this.buildRankingPrompt(content, context);

      const response = await this.llmClient.complete({
        model: 'claude-3-5-haiku-20241022',  // Fast for ranking
        messages: [{ role: 'user', content: prompt }],
        maxTokens: 1024
      });

      return this.parseRankingResponse(response, content);
    });
  }

  private buildRankingPrompt(
    content: ScoredContent[],
    context: UserContext
  ): string {
    return `You are a Reality Filter for a spatial social platform.

User Profile:
- Interests: ${context.interests.join(', ')}
- Current time: ${context.timeOfDay} on ${['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][context.dayOfWeek]}
- Recent mood indicators: ${context.mood}
- Recently engaged with: ${context.recentInteractions.slice(0, 5).join(', ')}

Available content (${content.length} items):
${content.slice(0, 50).map((c, i) =>
  `${i + 1}. [${c.id}] ${c.category} | ${c.distanceM}m away | Score: ${c.semanticScore.toFixed(2)}
     "${c.preview.substring(0, 80)}..."
     Tags: ${c.tags.join(', ')}`
).join('\n')}

Select the TOP 10 most relevant items for this user RIGHT NOW.
Consider:
- Semantic match to interests
- Time appropriateness (morning vs evening content)
- Emotional resonance with current mood
- Discovery potential (slight surprises are good)
- Proximity (closer is usually better, but not always)

Return JSON array: [{ "id": "...", "rank": 1-10, "reason": "brief explanation" }]`;
  }

  private postProcess(content: RankedContent[]): FilteredContent[] {
    // Ensure diversity
    const categories = new Set<string>();
    const diversified = content.filter(c => {
      if (categories.size >= 3 && categories.has(c.category)) {
        return categories.size < 5;  // Allow some repetition
      }
      categories.add(c.category);
      return true;
    });

    // Limit to reasonable number
    return diversified.slice(0, 10).map(c => ({
      id: c.id,
      rank: c.rank,
      relevanceReason: c.reason,
      displayConfidence: c.semanticScore > 0.8 ? 'high' : 'medium'
    }));
  }
}
```

### 6.2 Content Moderation Pipeline

```typescript
// Multi-layer moderation pipeline
class ModerationPipeline {
  async moderate(content: UserContent): Promise<ModerationResult> {
    const results: ModerationCheck[] = [];

    // Layer 1: OpenAI Moderation API (free, fast)
    const openaiResult = await this.openaiModerate(content);
    results.push({ source: 'openai', ...openaiResult });

    if (openaiResult.flagged && openaiResult.confidence > 0.95) {
      return this.createResult(results, 'reject');
    }

    // Layer 2: Location-aware rules
    const locationResult = await this.checkLocationRules(content);
    results.push({ source: 'location', ...locationResult });

    if (locationResult.flagged) {
      return this.createResult(results, 'reject');
    }

    // Layer 3: Community standards (LLM-based for edge cases)
    if (openaiResult.flagged || this.needsReview(content)) {
      const llmResult = await this.llmReview(content);
      results.push({ source: 'llm', ...llmResult });

      if (llmResult.flagged) {
        return this.createResult(results, 'review');  // Human review
      }
    }

    return this.createResult(results, 'approve');
  }

  private async openaiModerate(content: UserContent): Promise<OpenAIModerationResult> {
    const input: Array<{type: string; text?: string; image_url?: {url: string}}> = [];

    if (content.text) {
      input.push({ type: 'text', text: content.text });
    }
    if (content.imageUrl) {
      input.push({ type: 'image_url', image_url: { url: content.imageUrl } });
    }

    const response = await openai.moderations.create({
      model: 'omni-moderation-latest',
      input
    });

    return {
      flagged: response.results[0].flagged,
      categories: Object.entries(response.results[0].categories)
        .filter(([_, v]) => v)
        .map(([k]) => k),
      confidence: Math.max(...Object.values(response.results[0].category_scores))
    };
  }

  private async checkLocationRules(content: UserContent): Promise<LocationModerationResult> {
    // Check if near sensitive locations
    const nearbyPOIs = await this.getNearbyPOIs(content.location, 100);  // 100m radius

    const sensitiveTypes = ['school', 'hospital', 'place_of_worship', 'cemetery', 'government'];
    const nearbySensitive = nearbyPOIs.filter(p => sensitiveTypes.includes(p.type));

    if (nearbySensitive.length === 0) {
      return { flagged: false, restrictions: [] };
    }

    // Apply location-specific rules
    const restrictions: string[] = [];

    for (const poi of nearbySensitive) {
      switch (poi.type) {
        case 'school':
          restrictions.push('no_adult_content', 'no_solicitation');
          if (content.hasAdultThemes) return { flagged: true, reason: 'near_school' };
          break;
        case 'cemetery':
          restrictions.push('respectful_content_only');
          break;
        case 'hospital':
          restrictions.push('no_graphic_content');
          break;
      }
    }

    return { flagged: false, restrictions };
  }

  private async llmReview(content: UserContent): Promise<LLMModerationResult> {
    const response = await anthropic.messages.create({
      model: 'claude-3-5-haiku-20241022',
      max_tokens: 512,
      messages: [{
        role: 'user',
        content: `You are a content moderator for a location-based social platform.

Review this content for policy violations:
- Text: "${content.text}"
- Location context: ${content.locationDescription}
- Image description: ${content.imageDescription || 'No image'}

Policies:
1. No harassment, hate speech, or personal attacks
2. No explicit adult content in public areas
3. No promotion of illegal activities
4. No doxxing or sharing private information
5. Respect for location context (e.g., solemn places)

Respond with JSON:
{
  "decision": "approve" | "reject" | "review",
  "reason": "brief explanation",
  "suggestedAction": "none" | "warn_user" | "require_edit" | "escalate"
}`
      }]
    });

    const result = JSON.parse(response.content[0].text);
    return {
      flagged: result.decision !== 'approve',
      decision: result.decision,
      reason: result.reason,
      suggestedAction: result.suggestedAction
    };
  }
}
```

### 6.3 Semantic Search Implementation

```typescript
// Semantic search with spatial awareness
class SemanticSearchService {
  constructor(
    private vectorDb: VectorDatabase,
    private llm: LLMClient,
    private embedder: EmbeddingService
  ) {}

  async search(
    query: string,
    userLocation: GeoPoint,
    options: SearchOptions = {}
  ): Promise<SearchResult[]> {
    // 1. Expand query for better recall
    const expandedQuery = await this.expandQuery(query);

    // 2. Generate query embedding
    const queryEmbedding = await this.embedder.embed(expandedQuery);

    // 3. Hybrid search: vector + spatial + filters
    const candidates = await this.vectorDb.hybridSearch({
      embedding: queryEmbedding,
      location: userLocation,
      radiusM: options.radiusM || 1000,
      categories: options.categories,
      emotionTags: this.extractEmotionIntent(query),
      limit: 100
    });

    // 4. Re-rank with LLM understanding
    const reranked = await this.rerank(query, candidates, options);

    return reranked.slice(0, options.limit || 20);
  }

  private async expandQuery(query: string): Promise<string> {
    // Use LLM to expand query with synonyms and related concepts
    const response = await this.llm.complete({
      model: 'gpt-4o-mini',
      messages: [{
        role: 'user',
        content: `Expand this search query with related terms and concepts:
Query: "${query}"

Examples:
- "peaceful places" → "peaceful places calm quiet serene tranquil relaxing meditation nature"
- "good coffee" → "good coffee cafe specialty espresso latte barista roaster"

Return only the expanded query, no explanation.`
      }],
      maxTokens: 100
    });

    return response.content;
  }

  private extractEmotionIntent(query: string): string[] | null {
    const emotionKeywords: Record<string, string[]> = {
      'happy': ['happy', 'joy', 'fun', 'exciting', 'celebrate'],
      'peaceful': ['peaceful', 'calm', 'quiet', 'serene', 'relaxing'],
      'nostalgic': ['nostalgic', 'memories', 'remember', 'old times', 'childhood'],
      'romantic': ['romantic', 'love', 'date', 'couple', 'anniversary'],
      'adventurous': ['adventure', 'explore', 'discover', 'hidden', 'secret']
    };

    const lowerQuery = query.toLowerCase();
    const matches: string[] = [];

    for (const [emotion, keywords] of Object.entries(emotionKeywords)) {
      if (keywords.some(k => lowerQuery.includes(k))) {
        matches.push(emotion);
      }
    }

    return matches.length > 0 ? matches : null;
  }

  private async rerank(
    originalQuery: string,
    candidates: SearchCandidate[],
    options: SearchOptions
  ): Promise<SearchResult[]> {
    if (candidates.length <= 10) {
      return candidates;  // Skip reranking for small result sets
    }

    const response = await this.llm.complete({
      model: 'claude-3-5-haiku-20241022',
      messages: [{
        role: 'user',
        content: `Rerank these search results for the query: "${originalQuery}"

Results:
${candidates.slice(0, 30).map((c, i) =>
  `${i + 1}. [${c.id}] ${c.category} | ${c.distanceM}m | Similarity: ${c.similarity.toFixed(2)}
     "${c.preview}"`
).join('\n')}

Consider:
- Relevance to query intent
- Content quality (engagement, recency)
- Location proximity
- Diversity of results

Return JSON array of top 20 IDs in order: ["id1", "id2", ...]`
      }],
      maxTokens: 512
    });

    const rankedIds = JSON.parse(response.content);
    const idToRank = new Map(rankedIds.map((id: string, i: number) => [id, i]));

    return candidates
      .filter(c => idToRank.has(c.id))
      .sort((a, b) => idToRank.get(a.id)! - idToRank.get(b.id)!)
      .map((c, i) => ({ ...c, rank: i + 1 }));
  }
}
```

### 6.4 Conversational AR Guide

```typescript
// Location-aware conversational AI
class ARGuideService {
  private conversationHistory: Map<string, ConversationMessage[]> = new Map();

  async chat(
    userId: string,
    message: string,
    context: ARContext
  ): Promise<GuideResponse> {
    // Get or initialize conversation
    const history = this.conversationHistory.get(userId) || [];

    // Build location context
    const locationContext = await this.buildLocationContext(context);

    // Generate response
    const response = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 1024,
      system: `You are a knowledgeable AR guide for CANVS, a spatial social platform.

Current Location Context:
${locationContext}

Your role:
- Answer questions about the current location and nearby places
- Share interesting stories and history
- Recommend places based on user interests
- Be conversational, warm, but concise (people are walking!)
- Reference specific CANVS posts when relevant
- Suggest follow-up locations or experiences

Keep responses under 150 words unless asked for more detail.`,
      messages: [
        ...history.map(m => ({ role: m.role, content: m.content })),
        { role: 'user', content: message }
      ]
    });

    const assistantMessage = response.content[0].text;

    // Update history (keep last 10 turns)
    history.push({ role: 'user', content: message });
    history.push({ role: 'assistant', content: assistantMessage });
    this.conversationHistory.set(userId, history.slice(-20));

    // Extract any location recommendations
    const recommendations = await this.extractRecommendations(assistantMessage);

    return {
      message: assistantMessage,
      recommendations,
      suggestedFollowups: this.generateFollowups(context, assistantMessage)
    };
  }

  private async buildLocationContext(context: ARContext): Promise<string> {
    const [nearbyContent, placeInfo, userHistory] = await Promise.all([
      this.getNearbyContent(context.location, 200),
      this.getPlaceInfo(context.location),
      this.getUserLocationHistory(context.userId)
    ]);

    return `
Location: ${placeInfo.name || 'Unknown location'}
Address: ${placeInfo.address}
Type: ${placeInfo.types?.join(', ') || 'Unknown'}

Nearby CANVS Content (${nearbyContent.length} items):
${nearbyContent.slice(0, 10).map(c =>
  `- [${c.category}] "${c.preview}" (${c.distanceM}m away, ${c.reactions} reactions)`
).join('\n')}

User has previously visited nearby:
${userHistory.slice(0, 5).map(h => `- ${h.placeName} (${h.daysAgo} days ago)`).join('\n')}

Time: ${context.timeOfDay} on ${context.dayOfWeek}
Weather: ${context.weather || 'Unknown'}
`.trim();
  }

  private generateFollowups(context: ARContext, response: string): string[] {
    const genericFollowups = [
      "What else is interesting nearby?",
      "Tell me more about this place",
      "Any hidden gems around here?"
    ];

    // Could use LLM to generate contextual follow-ups
    return genericFollowups;
  }
}
```

---

## 7. Recommended Architecture

### 7.1 High-Level Architecture Diagram

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                              CANVS AI Architecture                              │
└────────────────────────────────────────────────────────────────────────────────┘

                                 ┌─────────────────┐
                                 │   Mobile App    │
                                 │  (iOS/Android)  │
                                 └────────┬────────┘
                                          │
                    ┌─────────────────────┼─────────────────────┐
                    │                     │                     │
                    ▼                     ▼                     ▼
          ┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
          │   Edge ML       │   │   API Gateway   │   │   WebSocket     │
          │ (Core ML/TFLite)│   │   (Supabase)    │   │   (Real-time)   │
          └────────┬────────┘   └────────┬────────┘   └────────┬────────┘
                   │                     │                     │
                   │                     ▼                     │
                   │            ┌─────────────────┐            │
                   │            │   Edge Functions │            │
                   │            │   (Deno Runtime) │            │
                   │            └────────┬────────┘            │
                   │                     │                     │
                   └─────────────────────┼─────────────────────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
                    ▼                    ▼                    ▼
          ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
          │  AI Router      │  │  Vector Service │  │  Cache Layer    │
          │  (Model Select) │  │  (Embeddings)   │  │  (Redis)        │
          └────────┬────────┘  └────────┬────────┘  └────────┬────────┘
                   │                    │                    │
          ┌────────┴────────────────────┴────────────────────┴────────┐
          │                                                            │
          │                    AI Services Layer                       │
          │                                                            │
          │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
          │  │ Claude API   │  │ OpenAI API   │  │ Gemini API   │     │
          │  │ (Reasoning)  │  │ (Multimodal) │  │ (Long Ctx)   │     │
          │  └──────────────┘  └──────────────┘  └──────────────┘     │
          │                                                            │
          │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
          │  │ Moderation   │  │ Embeddings   │  │ Self-Hosted  │     │
          │  │ (OpenAI)     │  │ (OpenAI)     │  │ (Llama 3)    │     │
          │  └──────────────┘  └──────────────┘  └──────────────┘     │
          │                                                            │
          └────────────────────────────┬───────────────────────────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
          ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
          │  PostgreSQL     │  │  Cloudflare R2  │  │  Redis          │
          │  + pgvector     │  │  (Media)        │  │  (Cache)        │
          │  + PostGIS      │  │                 │  │                 │
          └─────────────────┘  └─────────────────┘  └─────────────────┘
```

### 7.2 Service Breakdown

| Service | Technology | Purpose | Scaling Strategy |
|---------|------------|---------|------------------|
| Edge ML | Core ML / TFLite | On-device classification | N/A (per-device) |
| API Gateway | Supabase | Request routing, auth | Auto-scale |
| Edge Functions | Deno | AI orchestration | Serverless |
| AI Router | Custom | Model selection | Stateless |
| Vector Service | pgvector | Embeddings + search | Vertical |
| Cache Layer | Redis | Semantic cache | Horizontal |
| Claude API | Anthropic | Complex reasoning | External |
| OpenAI API | OpenAI | Multimodal + moderation | External |
| Gemini API | Google | Long context | External |

### 7.3 Data Flow Examples

**Content Creation Flow:**

```
1. User creates post
       │
2. Edge ML classifies (if capable)
       │
3. Upload to Supabase
       │
4. Edge Function triggered
       │
       ├──► OpenAI Moderation (async)
       │
       ├──► Generate embeddings
       │
       └──► Store in pgvector

5. Return success to user
```

**Discovery Flow:**

```
1. User opens map view
       │
2. Get user location + preferences
       │
3. Query pgvector (spatial + semantic)
       │
4. Check Redis cache
       │
       ├── Cache hit ──► Return cached filter
       │
       └── Cache miss ──► Call AI Router
                               │
                               ├──► Claude (Reality Filter logic)
                               │
                               └──► Cache result

5. Return ranked content to user
```

---

## 8. Security and Privacy Considerations

### 8.1 Data Privacy in AI Pipeline

**Principles:**
1. **Minimize data sent to external APIs**
2. **Process location data on-device when possible**
3. **Anonymize data before AI processing**
4. **Implement data retention limits**

**Implementation:**

```typescript
// Anonymize before sending to external AI
function sanitizeForAI(content: UserContent): SanitizedContent {
  return {
    // Remove PII
    text: removePII(content.text),

    // Use relative location, not absolute
    locationContext: content.isNearPOI ? content.poiType : 'outdoor',

    // Anonymize user info
    authorContext: {
      accountAge: bucketize(content.authorAccountAge, [7, 30, 90, 365]),
      trustScore: bucketize(content.authorTrustScore, [0.3, 0.5, 0.7, 0.9])
    },

    // Don't send exact coordinates
    // Don't send user IDs
    // Don't send identifiable metadata
  };
}
```

### 8.2 API Key Management

```typescript
// Secure API key rotation
class APIKeyManager {
  private keys: Map<string, APIKey> = new Map();

  async getKey(provider: 'anthropic' | 'openai' | 'google'): Promise<string> {
    const keyInfo = this.keys.get(provider);

    if (!keyInfo || this.shouldRotate(keyInfo)) {
      const newKey = await this.fetchKey(provider);
      this.keys.set(provider, { key: newKey, fetchedAt: Date.now() });
      return newKey;
    }

    return keyInfo.key;
  }

  private shouldRotate(keyInfo: APIKey): boolean {
    const maxAge = 24 * 60 * 60 * 1000;  // 24 hours
    return Date.now() - keyInfo.fetchedAt > maxAge;
  }

  private async fetchKey(provider: string): Promise<string> {
    // Fetch from secret manager (e.g., Supabase Vault, AWS Secrets Manager)
    return await secretManager.getSecret(`${provider}_api_key`);
  }
}
```

### 8.3 Rate Limiting and Cost Controls

```typescript
// Per-user AI usage limits
const AI_LIMITS = {
  free: {
    dailyQueries: 50,
    dailyCreations: 10,
    maxTokensPerQuery: 1000
  },
  pro: {
    dailyQueries: 500,
    dailyCreations: 100,
    maxTokensPerQuery: 4000
  }
};

async function checkAIQuota(userId: string, operation: 'query' | 'create'): Promise<boolean> {
  const tier = await getUserTier(userId);
  const limits = AI_LIMITS[tier];

  const usage = await redis.get(`ai_usage:${userId}:${new Date().toDateString()}`);
  const currentUsage = usage ? JSON.parse(usage) : { queries: 0, creations: 0 };

  if (operation === 'query' && currentUsage.queries >= limits.dailyQueries) {
    throw new QuotaExceededError('Daily query limit reached');
  }

  if (operation === 'create' && currentUsage.creations >= limits.dailyCreations) {
    throw new QuotaExceededError('Daily creation limit reached');
  }

  // Update usage
  currentUsage[operation === 'query' ? 'queries' : 'creations']++;
  await redis.setex(
    `ai_usage:${userId}:${new Date().toDateString()}`,
    86400,
    JSON.stringify(currentUsage)
  );

  return true;
}
```

---

## 9. Future Roadmap

### 9.1 Phase 1: MVP (Q1 2026)

**AI Features:**
- Basic content moderation (OpenAI Moderation API)
- Simple content classification (edge + GPT-4o-mini)
- Text embeddings for semantic search (pgvector)
- Basic Reality Filter (rule-based + simple LLM ranking)

**Investment:** ~$500/month AI costs at 10K users

### 9.2 Phase 2: Enhanced Intelligence (Q2-Q3 2026)

**AI Features:**
- Full Reality Filter with Claude reasoning
- Multimodal content understanding (images + audio)
- Semantic caching for cost optimization
- User preference learning

**Investment:** ~$3,000/month AI costs at 50K users

### 9.3 Phase 3: Conversational AR (Q4 2026)

**AI Features:**
- AR tour guide (location-aware chatbot)
- Voice interaction support
- Real-time translation of content
- Emotion-based discovery

**Investment:** ~$15,000/month AI costs at 200K users

### 9.4 Phase 4: Generative Spatial (2027)

**AI Features:**
- Text-to-AR content generation
- AI-generated location summaries
- Predictive content surfacing
- Custom fine-tuned models

**Investment:** ~$50,000/month AI costs at 500K users

### 9.5 Technology Watch

**Emerging technologies to monitor:**
- **Multimodal embeddings:** Unified text/image/audio embeddings
- **Smaller, faster models:** Edge deployment of capable models
- **Real-time voice:** Native voice conversation in apps
- **AR-native AI:** AI that understands 3D spatial context
- **Federated learning:** Privacy-preserving personalization

---

## References

### Model Documentation
- [Anthropic Claude API](https://docs.anthropic.com/en/api)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [Google Gemini API](https://ai.google.dev/gemini-api/docs)
- [Meta Llama](https://llama.meta.com/)

### Vector Databases
- [pgvector Documentation](https://github.com/pgvector/pgvector)
- [Pinecone Documentation](https://docs.pinecone.io/)
- [Weaviate Documentation](https://weaviate.io/developers/weaviate)

### Edge ML
- [Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [ONNX Runtime](https://onnxruntime.ai/)

### Research
- [Retrieval-Augmented Generation](https://arxiv.org/abs/2005.11401)
- [ColBERT: Efficient Retrieval](https://arxiv.org/abs/2004.12832)
- [CLIP: Connecting Text and Images](https://openai.com/research/clip)

---

*Document generated: January 2026*
*Author: CANVS Technical Architecture Team*
*Next review: Prior to MVP development kickoff*
