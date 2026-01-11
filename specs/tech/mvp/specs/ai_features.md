# CANVS AI Features - Comprehensive MVP Specification

**Version:** 2.0.0
**Date:** January 2026
**Status:** Implementation Ready
**Author:** CANVS Technical Architecture Team (AI-Assisted)

---

## Document Overview

This document provides the complete AI features specification for CANVS, the Spatial Social Layer platform. It synthesizes research from multiple specialized documents and defines implementation-ready specifications for LLM agent functionalities beyond traditional chatbots.

### Related Documents
- [AI Implementation Architecture](../../parts/ai/ai_implementation_architecture.md) - LLM models, vector databases, cost analysis
- [Spatial AI Features](../../parts/ai/spatial_ai_features.md) - Location intelligence, spatial reasoning, AR optimization
- [Tech Specs](./tech_specs.md) - Overall technical specifications
- [Challenges](./challenges.md) - Known challenges and mitigations

### Document Structure
1. **Executive Summary** - Core principles and feature overview
2. **AI Reality Filter** - The cornerstone personalization engine
3. **Semantic Search & Discovery** - Emotion-based and contextual search
4. **Content Intelligence** - Auto-categorization, quality scoring, trend detection
5. **Content Generation** - Caption assistance, trail narratives, accessibility
6. **Content Moderation** - Spatial-aware, multi-modal, anti-stalking
7. **Spatial AI** - Location intelligence, scene understanding, AR optimization
8. **Implementation Roadmap** - Phased delivery plan
9. **Technical Architecture** - Models, packages, dependencies
10. **Cost Analysis** - Projected expenses and optimization strategies

---

## 1. Executive Summary

### 1.1 The CANVS AI Philosophy

```
"AI as the Reality Filter, not a chatbot"
```

CANVS AI should feel like an extension of user perception, surfacing relevant content without requiring explicit queries. The AI layer is:

- **Invisible:** Works in the background to filter and prioritize
- **Personal:** Adapts to individual preferences and context
- **Spatial:** Understands physical world context and relationships
- **Safe:** Prevents harmful content and protects privacy
- **Efficient:** Balances quality with cost and latency

### 1.2 Core AI Capabilities Matrix

| Capability | Description | MVP Phase | Priority |
|------------|-------------|-----------|----------|
| **Reality Filter** | Personalized content curation without explicit queries | v1 (Basic), v2 (Full) | Critical |
| **Content Moderation** | Multi-modal, spatial-aware safety | v1 | Critical |
| **Semantic Search** | Find content by meaning, emotion, context | v1 | High |
| **Auto-Categorization** | Classify content into memory/utility/culture | v1 | High |
| **Location Intelligence** | Place type, personality, ambient conditions | v1 | High |
| **Content Generation** | Captions, trails, accessibility descriptions | v2 | Medium |
| **Spatial Reasoning** | Scene understanding, occlusion, placement | v2+ | Medium |
| **Conversational Guide** | AR tour guide and location-aware assistant | v3 | Low |

### 1.3 Technology Stack Summary

| Component | Recommended Solution | Rationale |
|-----------|---------------------|-----------|
| Primary LLM | Claude API (Anthropic) | Best reasoning, context handling, safety |
| Fast Operations | GPT-4o-mini / Claude Haiku | Speed + cost for simple tasks |
| Multimodal | GPT-4o | Native image + audio understanding |
| Content Moderation | OpenAI Moderation API | Free, multimodal, accurate |
| Vector Database | PostgreSQL + pgvector | Integrated with Supabase stack |
| Embeddings | text-embedding-3-small | Cost-effective, good quality |
| Edge Inference | Core ML / TensorFlow Lite | Privacy-sensitive features |
| Semantic Cache | Redis + vector similarity | Low-latency repeated queries |

---

## 2. AI Reality Filter (Core Feature)

### 2.1 Overview

**The Reality Filter is CANVS's signature AI feature** - it automatically surfaces relevant spatial content based on user preferences, location context, emotional state, and temporal patterns without requiring explicit search queries.

### 2.2 Value Proposition

**For Users:**
- Discover relevant content without searching
- Personalized experience that improves over time
- Context-aware filtering (time of day, mood, activity)
- Serendipitous discovery of hidden gems

**For Platform:**
- Key differentiator from other location apps
- Increased engagement through relevance
- Reduced cognitive load on users
- Data-driven personalization creates switching costs

### 2.3 Technical Functionality

```typescript
interface RealityFilterRequest {
  userId: string;
  location: GeoPoint;
  context: {
    timeOfDay: 'morning' | 'afternoon' | 'evening' | 'night';
    dayOfWeek: number;
    isWalking: boolean;
    mood?: string;
    recentInteractions: string[];
  };
  filters?: {
    categories?: string[];
    emotionTags?: string[];
    maxDistance?: number;
  };
}

interface RealityFilterResponse {
  rankedContent: Array<{
    contentId: string;
    rank: number;
    relevanceScore: number;
    relevanceReason: string;
    displayConfidence: 'high' | 'medium' | 'low';
  }>;
  totalNearby: number;
  filterApplied: string;
}
```

**Processing Pipeline:**

1. **User Context Building** - Aggregate preferences, history, current state
2. **Spatial Query** - Retrieve nearby content using PostGIS + H3 indexing
3. **Pre-filtering** - Remove blocked users, avoided topics, flagged content
4. **Semantic Scoring** - Compute embedding similarity with user preferences
5. **LLM Ranking** - Apply complex reasoning for final ranking
6. **Diversity Enforcement** - Ensure variety in categories and sources
7. **Caching** - Store results for similar contexts

### 2.4 Implementation Pattern

```typescript
class RealityFilterService {
  async filterForUser(
    userId: string,
    location: GeoPoint,
    nearbyContent: SpatialContent[]
  ): Promise<FilteredContent[]> {
    // 1. Build user context from profile and recent activity
    const userContext = await this.buildUserContext(userId);

    // 2. Pre-filter by basic relevance rules
    const candidates = this.preFilter(nearbyContent, userContext);

    // 3. Score by semantic similarity to user preferences
    const scored = await this.scoreBySemanticRelevance(
      candidates,
      userContext.preferenceEmbedding
    );

    // 4. LLM reasoning for final ranking (cached)
    const ranked = await this.llmRank(scored, userContext);

    // 5. Post-process for diversity
    return this.enforceD iversity(ranked);
  }
}
```

### 2.5 Preference Learning

The Reality Filter learns from:

| Signal | Weight | Update Frequency |
|--------|--------|------------------|
| Explicit reactions (❤️, 💬) | 0.4 | Real-time |
| View duration (>3s) | 0.2 | Real-time |
| Content creation patterns | 0.15 | Daily |
| Location visit frequency | 0.15 | Weekly |
| Time-of-day preferences | 0.1 | Weekly |

### 2.6 Challenges & Mitigations

| Challenge | Mitigation |
|-----------|------------|
| Cold start for new users | Use location-based popularity, ask initial preferences |
| Filter bubble risk | Inject 10-20% serendipity content |
| Staleness | Time-decay recent interactions, periodic preference refresh |
| Latency | Aggressive caching, pre-compute for popular areas |
| Cost | Batch similar requests, use cheaper models for ranking |

### 2.7 Models & Dependencies

- **Primary LLM:** Claude 3.5 Haiku ($0.25/1M in, $1.25/1M out) - Fast ranking
- **Complex Reasoning:** Claude 3.5 Sonnet ($3/1M in, $15/1M out) - Edge cases
- **Embeddings:** text-embedding-3-small ($0.02/1M tokens)
- **Vector Store:** pgvector (included in Supabase)
- **Cache:** Redis with vector similarity search

---

## 3. Semantic Search & Discovery

### 3.1 Overview

Enable users to find content by meaning, emotion, and context rather than exact keywords. Supports queries like "find peaceful places nearby" or "show me nostalgic memories from this neighborhood."

### 3.2 Value Proposition

**For Users:**
- Find content that matches feelings, not just words
- Discover places with specific "vibes"
- Natural language queries work intuitively
- Cross-modal search (find images by describing feelings)

**For Platform:**
- Unique discovery experience
- Higher engagement through relevant results
- Enables emotion-based features
- Better content surfacing for long-tail content

### 3.3 Technical Functionality

```typescript
interface SemanticSearchRequest {
  query: string;
  location: GeoPoint;
  radiusM: number;
  filters?: {
    categories?: string[];
    emotionTags?: string[];
    dateRange?: { start: Date; end: Date };
    authorIds?: string[];
  };
  limit?: number;
}

async function semanticSearch(
  request: SemanticSearchRequest
): Promise<SearchResult[]> {
  // 1. Expand query with synonyms and related concepts
  const expandedQuery = await expandQuery(request.query);

  // 2. Generate query embedding
  const queryEmbedding = await embedder.embed(expandedQuery);

  // 3. Hybrid search: vector + spatial + filters
  const candidates = await vectorDb.hybridSearch({
    embedding: queryEmbedding,
    location: request.location,
    radiusM: request.radiusM,
    emotionTags: extractEmotionIntent(request.query),
    limit: 100
  });

  // 4. LLM re-ranking for nuanced understanding
  return await rerank(request.query, candidates);
}
```

### 3.4 Emotion-Based Discovery

Map emotional descriptors to searchable attributes:

| Emotion Query | Mapped Attributes |
|---------------|-------------------|
| "peaceful" | calm, quiet, serene, nature, meditation |
| "romantic" | love, date, couple, sunset, intimate |
| "nostalgic" | memories, childhood, old times, remember |
| "adventurous" | explore, hidden, secret, discover |
| "inspiring" | art, creativity, motivation, culture |

### 3.5 Implementation Considerations

**Query Processing:**
1. Extract emotional intent from query
2. Expand with synonyms using LLM
3. Generate embedding for semantic matching
4. Apply location and temporal filters
5. Re-rank top results with LLM understanding

**Performance Optimization:**
- Cache common query expansions
- Pre-compute area embeddings for popular locations
- Use smaller models for query expansion
- Limit re-ranking to top 30 candidates

### 3.6 Models & Dependencies

- **Query Expansion:** GPT-4o-mini ($0.15/1M in)
- **Embeddings:** text-embedding-3-small ($0.02/1M tokens)
- **Re-ranking:** Claude 3.5 Haiku ($0.25/1M in)
- **Vector Search:** pgvector with HNSW index

---

## 4. Content Intelligence

### 4.1 Automatic Content Categorization

Classify all content into CANVS's three primary categories without manual tagging.

**Categories:**
- **Memory:** Personal experiences, nostalgia, significant moments
- **Utility:** Practical information, tips, warnings, recommendations
- **Culture:** Art, events, community, social commentary

```typescript
interface ContentCategorization {
  primaryCategory: 'memory' | 'utility' | 'culture';
  secondaryCategories: string[];
  emotionalTone: {
    dominant: string;
    valence: number;   // -1 to 1
    arousal: number;   // 0 to 1
    emotions: Record<string, number>;
  };
  topicTags: string[];
  confidence: number;
}

async function categorizeContent(content: SpatialContent): Promise<ContentCategorization> {
  // 1. Rule-based pre-classification (keywords)
  const ruleBasedCategory = applyCategorizationRules(content);

  // 2. LLM classification for nuanced understanding
  const llmClassification = await classifyWithLLM(content);

  // 3. Emotional analysis
  const emotionalProfile = await analyzeEmotions(content);

  // 4. Topic extraction
  const topics = await extractTopics(content);

  return {
    primaryCategory: resolveCategory(ruleBasedCategory, llmClassification),
    secondaryCategories: llmClassification.secondary,
    emotionalTone: emotionalProfile,
    topicTags: topics,
    confidence: calculateConfidence(ruleBasedCategory, llmClassification)
  };
}
```

### 4.2 Content Quality Scoring

Evaluate content quality for ranking and discovery:

| Factor | Weight | Description |
|--------|--------|-------------|
| Engagement velocity | 0.25 | Views, reactions, shares over time |
| Author reputation | 0.20 | Historical content quality |
| Content richness | 0.20 | Media, length, completeness |
| Location relevance | 0.15 | Match to stated location |
| Recency | 0.10 | Freshness of content |
| Uniqueness | 0.10 | Distinctiveness from duplicates |

### 4.3 Trending Detection (Location-Level)

Detect emerging trends at specific locations:

```typescript
interface TrendingAnalysis {
  h3Cell: string;
  timeWindow: number;
  trendingContent: Array<{
    contentId: string;
    score: number;
    factors: {
      viewVelocity: number;
      reactionVelocity: number;
      uniqueEngagers: number;
      geographicSpread: number;
    };
  }>;
  emergingTopics: Array<{
    topic: string;
    velocity: number;
    sentiment: number;
  }>;
  activityLevel: 'quiet' | 'normal' | 'active' | 'buzzing' | 'viral';
}
```

**Use Cases:**
- "Something's happening at Union Square - 15 new posts in the last hour"
- Surface breaking local events
- Feature viral content in discovery

### 4.4 Duplicate & Spam Detection

Location-aware duplicate detection:

| Pattern | Description | Detection Method |
|---------|-------------|------------------|
| Exact duplicate | Same text at same location | Text hash matching |
| Near duplicate | Similar text, same/nearby location | Fuzzy text matching |
| Semantic duplicate | Same meaning, different words | Embedding similarity |
| Location carpet bombing | Same content at many locations | Cross-location pattern analysis |
| Promotional spam | Commercial content disguised as organic | Keyword + link analysis |

### 4.5 Models & Dependencies

- **Classification:** GPT-4o-mini ($0.15/1M in)
- **Emotion Analysis:** Custom prompts on GPT-4o-mini
- **Topic Extraction:** KeyBERT or LLM-based
- **Duplicate Detection:** SimHash + embedding similarity

---

## 5. Content Generation Assistants

### 5.1 Caption Generation

Generate contextual caption suggestions for user content.

**Features:**
- Multiple tone options (nostalgic, playful, informative)
- Location-aware suggestions
- Time and weather context integration
- Hashtag recommendations

```typescript
interface CaptionSuggestion {
  caption: string;
  tone: 'nostalgic' | 'playful' | 'informative' | 'poetic';
  confidence: number;
  hashtags?: string[];
}

// Example output for sunset at Point Lookout:
[
  {
    caption: "The kind of sunset that makes you forget everything else. Point Lookout, 7:42 PM.",
    tone: "nostalgic",
    hashtags: ["#sunset", "#pointlookout", "#goldhour"]
  },
  {
    caption: "POV: You finally found the spot everyone talks about",
    tone: "playful",
    hashtags: ["#bestview", "#worthit"]
  }
]
```

### 5.2 Trail Narrative Generation

Create cohesive walking experiences from content and locations.

**Features:**
- Generates waypoints with narrative text
- Considers CANVS content along routes
- Adapts to user duration and preferences
- Builds emotional arcs through the journey

```typescript
interface GeneratedTrail {
  title: string;
  description: string;
  waypoints: Array<{
    location: GeoPoint;
    narrative: string;
    suggestedAction: string;
    relatedContent: ContentReference[];
    estimatedTime: number;
  }>;
  totalDuration: number;
  theme: string;
  emotionalArc: string;  // e.g., "curiosity → discovery → hope"
}
```

### 5.3 Accessibility Descriptions

Generate WCAG-compliant descriptions for AR content.

**Features:**
- Short (50 chars), medium (200 chars), and full descriptions
- Spatial context descriptions ("15m ahead, at eye level")
- Interaction hints for assistive technology
- Audio description generation for complex content

```typescript
interface ARContentAccessibility {
  shortDescription: string;      // For lists
  mediumDescription: string;     // For previews
  fullDescription: string;       // For screen readers
  spatialContext: string;        // Where content appears
  interactionHints: string[];    // How to engage
  alternativeFormats: {
    audioDescription?: string;
    brailleReady?: string;
  };
}
```

### 5.4 Time Capsule Prompts

Personalized writing prompts for time capsule creation.

**Capsule Types & Sample Prompts:**
- **Memory:** "What's one detail about this place you never want to forget?"
- **Farewell:** "What made this place feel like home?"
- **Celebration:** "What's the feeling you want to bottle up from right now?"
- **Message to Future:** "What do you hope you'll have accomplished when you open this?"
- **Grief:** "What would you want to tell them right now?"
- **Gratitude:** "What unexpected gift did this place give you?"

### 5.5 Models & Dependencies

- **Caption Generation:** Claude 3.5 Haiku (fast, cost-effective)
- **Trail Narratives:** Claude 3.5 Sonnet (complex reasoning)
- **Image Analysis:** GPT-4o (native multimodal)
- **Accessibility:** Claude 3.5 Sonnet (quality descriptions)
- **Routing:** Mapbox Directions API or OSRM

---

## 6. Content Moderation

### 6.1 Spatial-Aware Moderation

Apply different moderation rules based on location context.

**Zone Classification:**

| Zone Type | Examples | Restrictions |
|-----------|----------|--------------|
| child_safe | Schools, playgrounds | No adult content, violence, profanity, solicitation |
| sensitive | Cemeteries, memorials, places of worship | No disrespect, commercial, political content |
| residential | Neighborhoods, hotels | Enhanced privacy, no specific addresses |
| public | Parks, streets | Standard moderation |
| adult_context | Bars, clubs | Relaxed rules (age-gated) |

```typescript
async function applySpatialModeration(
  content: UserContent,
  location: GeoPoint
): Promise<ModerationResult> {
  // 1. Classify zone from nearby POIs
  const nearbyPOIs = await getNearbyPOIs(location, 200);
  const zone = classifyZone(nearbyPOIs);
  const policy = ZONE_POLICIES[zone];

  // 2. Run base moderation (OpenAI - free)
  const baseResult = await openai.moderations.create({
    model: 'omni-moderation-latest',
    input: buildModerationInput(content)
  });

  // 3. Apply zone-specific restrictions
  const zoneViolations = checkZoneRestrictions(content, policy);

  // 4. Determine action
  return combineResults(baseResult, zoneViolations, zone);
}
```

### 6.2 Multi-Modal Moderation

Moderate text, images, audio, and video content.

**Pipeline:**
1. **Text:** OpenAI Moderation API (free)
2. **Images:** OpenAI omni-moderation-latest (free, multimodal)
3. **Audio:** Transcribe with Whisper → text moderation + speech pattern analysis
4. **Video:** Sample frames (1fps) → image moderation + audio track

**CANVS-Specific Categories:**
- `canvs/privacy` - Photos revealing private information
- `canvs/stalking` - Content enabling stalking behavior
- `canvs/location_risk` - Content revealing sensitive locations

### 6.3 Anti-Stalking Detection

Detect patterns indicating stalking behavior.

**Detection Signals:**

| Signal | Weight | Description |
|--------|--------|-------------|
| Disproportionate engagement | 0.30 | >3x engagement with one user vs average |
| Physical proximity pattern | 0.40 | Repeatedly near target's content locations |
| Time-correlated creation | 0.25 | Creating content shortly after target at same location |
| Rapid following movement | 0.50 | GPS movements tracking another user |
| Multiple targets | -0.20 | Patterns across many users (likely not stalking) |

**Actions by Risk Score:**
- 0.9+ : Immediate suspension, notify moderators and target
- 0.7-0.9 : Shadow restrictions (hide from target)
- 0.5-0.7 : Increased monitoring

### 6.4 Content Freshness

Manage content lifecycle based on type and engagement.

| Content Type | Default TTL | Max Lifespan | Renewal Triggers |
|--------------|-------------|--------------|------------------|
| Pin | 90 days | 365 days | Reaction, comment, view spike |
| Capsule | 365 days | 10 years | New entry, unlock, share |
| Utility | 30 days | 180 days | Confirmation, correction |

**Freshness Actions:**
- Fresh (>0.6): Normal display
- Aging (0.3-0.6): "Posted X ago" badge
- Stale (<0.3): "May be outdated" badge, demoted in ranking
- Archived: Hidden from discovery, accessible via direct link

### 6.5 Age Gating

Context-sensitive age restrictions.

```typescript
interface AgeGatingDecision {
  requiredAge: number; // 0, 13, 17, 18, 21
  gatingReason: string;
  verificationRequired: boolean;
  alternativeAvailable: boolean;
}
```

**Verification Methods:**
- 0-13: No verification needed
- 13-17: Self-declaration
- 18+: Credit card verification
- 21+: ID verification (optional)

### 6.6 Models & Dependencies

- **Base Moderation:** OpenAI Moderation API (free, multimodal)
- **Audio Transcription:** OpenAI Whisper ($0.006/minute)
- **Tone Analysis:** Claude 3.5 Haiku (nuanced review)
- **POI Data:** Overpass API (OSM) or Google Places
- **Zone Classification:** Custom logic with cached POI data

---

## 7. Spatial AI Features

### 7.1 Location Intelligence

#### 7.1.1 Place Type Classification

Automatically understand what type of place the user is at.

**Data Sources:**
- Google Places API (primary)
- OpenStreetMap via Overpass API (backup)
- Foursquare (additional context)
- Custom ML inference

```typescript
interface PlaceClassification {
  primaryType: string;         // e.g., 'restaurant', 'park'
  secondaryTypes: string[];    // e.g., ['outdoor_dining', 'family_friendly']
  confidence: number;
  semanticCategory: 'social' | 'work' | 'transit' | 'nature' | 'culture' | 'commerce';
}
```

#### 7.1.2 Location Personality Profiling

Build semantic profiles of locations based on aggregated content.

**Attributes (0-1 scale):**
- romantic, adventurous, peaceful, nostalgic
- artistic, social, professional, family_friendly
- nightlife, nature

**Use Case:** "Find places that feel romantic" → Query against location personalities

#### 7.1.3 Ambient Conditions Prediction

Predict environmental conditions for optimal content viewing.

**Factors:**
- Lighting (natural/artificial, intensity)
- Noise level prediction
- Crowd density (from Google Popular Times)
- Weather impact

### 7.2 Indoor/Outdoor Detection

Multi-signal detection for positioning strategy selection.

**Signals & Weights:**
| Signal | Weight | Indoor Indication |
|--------|--------|-------------------|
| GPS accuracy | 0.30 | >50m = likely indoor |
| Ambient light | 0.20 | <500 lux = likely indoor |
| Barometric stability | 0.15 | Low variance = indoor |
| Magnetic anomaly | 0.10 | High = indoor (buildings) |
| WiFi density | 0.10 | >10 APs = likely indoor |
| Vision (sky/ceiling) | 0.15 | Ceiling detected = indoor |

**Output:**
- `environment`: 'indoor' | 'outdoor' | 'semi_outdoor' | 'underground'
- `gpsReliability`: 'high' | 'medium' | 'low' | 'none'
- `recommendedPositioning`: 'gps' | 'wifi' | 'bluetooth' | 'vps' | 'dead_reckoning'

### 7.3 Spatial Reasoning (v2+)

#### 7.3.1 Depth Estimation

For devices without LiDAR, estimate scene depth from camera.

**Models (by quality/speed):**
| Model | Speed (Mobile) | Quality | Size |
|-------|----------------|---------|------|
| Depth Anything v2 | ~80ms | State-of-art | 97MB |
| MiDaS v3.1 | ~100ms | High | 100MB |
| FastDepth | ~20ms | Moderate | 5MB |

**Strategy:**
- LiDAR devices: Use native ARKit/ARCore depth
- Modern devices: Depth Anything v2
- Low-end devices: FastDepth fallback

#### 7.3.2 Semantic Scene Understanding

Understand scene surfaces and objects for intelligent placement.

**Detected Elements:**
- Planes: floor, wall, ceiling, table, door, window
- Objects: furniture, people, vegetation, vehicles
- Regions: navigable areas, obstacles

**AR Framework Support:**
| Feature | ARKit | ARCore | 8th Wall | WebXR |
|---------|-------|--------|----------|-------|
| Plane Detection | Native | Native | Native | Limited |
| Plane Classification | Native (v4+) | Limited | No | No |
| Scene Reconstruction | Native (LiDAR) | Depth API | No | No |
| Light Estimation | Native | Native | Limited | Limited |

### 7.4 Path Intelligence

#### 7.4.1 Walkable Path Generation

Generate pedestrian-safe routes with accessibility considerations.

**Route Factors:**
- Pedestrian network (OSM/Overture)
- Crosswalk wait times
- Terrain/slope
- CANVS content density
- Scenic vs direct preferences

#### 7.4.2 Time Estimation

Accurate walking time with multiple factors:

| Factor | Adjustment |
|--------|------------|
| User pace | 0.8x (slow) to 1.4x (athletic) |
| Slope >5° | +4% per degree |
| Stairs | 0.6x speed |
| Crosswalks | +30s each |
| Weather | 0.85x in rain, 0.9x extreme temps |
| Crowds | 0.7x in crowded areas |

#### 7.4.3 Accessibility Routing

Route with mobility aid considerations:

- Maximum slope limits
- Curb cut requirements
- Stair avoidance
- Surface type preferences
- Rest stop planning

### 7.5 Models & Dependencies

- **Place Data:** Google Places API, Overpass API
- **Weather:** OpenWeatherMap API
- **Popular Times:** Google Places API
- **Sun Position:** SunCalc.js (edge)
- **Depth Estimation:** Depth Anything v2 (TFLite/Core ML)
- **Routing:** OSRM or Mapbox Directions

---

## 8. Implementation Roadmap

### Phase 1: MVP v1 (Q1 2026)

**AI Features:**
- Basic content moderation (OpenAI Moderation API)
- Simple content classification (edge + GPT-4o-mini)
- Text embeddings for semantic search (pgvector)
- Rule-based Reality Filter with simple LLM ranking
- Place type classification (Google Places API)
- Indoor/outdoor detection (sensor fusion)

**Investment:** ~$500/month AI costs at 10K users

### Phase 2: Enhanced Intelligence (Q2-Q3 2026)

**AI Features:**
- Full Reality Filter with Claude reasoning
- Multimodal content understanding (images + audio)
- Semantic caching for cost optimization
- User preference learning
- Location personality profiling
- Content generation assistants (captions, accessibility)
- Anti-stalking pattern detection

**Investment:** ~$3,000/month AI costs at 50K users

### Phase 3: Spatial Intelligence (Q4 2026)

**AI Features:**
- Monocular depth estimation
- Semantic scene understanding
- Occlusion-aware content placement
- Trail narrative generation
- Conversational AR guide (basic)
- Trending detection at location level

**Investment:** ~$15,000/month AI costs at 200K users

### Phase 4: Generative Spatial (2027)

**AI Features:**
- Text-to-AR content generation
- AI-generated location summaries
- Predictive content surfacing
- Custom fine-tuned models
- Full conversational guide with history

**Investment:** ~$50,000/month AI costs at 500K users

---

## 9. Technical Architecture

### 9.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Device                               │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Edge ML Layer                             ││
│  │  • Content Classification (Core ML/TFLite)                   ││
│  │  • Indoor/Outdoor Detection (sensor fusion)                  ││
│  │  • Depth Estimation (v2+)                                    ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Supabase Edge Functions                     │
│  • AI Router (model selection)                                   │
│  • Request batching                                              │
│  • Semantic caching                                              │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
       ┌───────────┐   ┌───────────┐   ┌───────────┐
       │ Claude API│   │ OpenAI API│   │ Gemini API│
       │ (Reasoning)│   │(Multimodal)│   │(Long Ctx) │
       └───────────┘   └───────────┘   └───────────┘
                              │
                              ▼
       ┌─────────────────────────────────────────────┐
       │              PostgreSQL + pgvector          │
       │         + PostGIS (spatial queries)         │
       └─────────────────────────────────────────────┘
```

### 9.2 Model Selection Strategy

```typescript
const modelConfig = {
  // Complex reasoning, safety-critical
  'reality-filter-personalization': {
    model: 'claude-3-5-sonnet-20241022',
    fallback: 'gpt-4o',
    maxTokens: 2048
  },

  // Real-time, multimodal
  'content-analysis-multimodal': {
    model: 'gpt-4o',
    fallback: 'gemini-1.5-pro',
    maxTokens: 1024
  },

  // High-volume, simple tasks
  'content-classification': {
    model: 'gpt-4o-mini',
    fallback: 'gemini-1.5-flash',
    maxTokens: 256
  },

  // Content moderation
  'content-moderation': {
    model: 'omni-moderation-latest',  // OpenAI, free
    fallback: 'claude-3-5-haiku-20241022',
    maxTokens: 512
  },

  // Long context analysis
  'history-analysis': {
    model: 'gemini-1.5-pro',
    fallback: 'claude-3-5-sonnet-20241022',
    maxTokens: 4096
  },

  // Privacy-sensitive (edge/self-hosted)
  'location-processing': {
    model: 'llama-3.1-8b-instruct',
    fallback: 'gpt-4o-mini',
    maxTokens: 512
  }
};
```

### 9.3 Vector Database Schema

```sql
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Content embeddings
CREATE TABLE content_embeddings (
    id UUID PRIMARY KEY REFERENCES posts(id),
    text_embedding vector(1536),      -- OpenAI text-embedding-3-small
    content_embedding vector(768),     -- Fused multimodal
    category TEXT NOT NULL,
    emotion_tags TEXT[],
    location GEOGRAPHY(POINT, 4326),
    h3_cell_res9 TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User preference embeddings
CREATE TABLE user_preference_embeddings (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    preference_embedding vector(768),
    interest_weights JSONB DEFAULT '{}',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_content_embedding
    ON content_embeddings USING hnsw (content_embedding vector_cosine_ops);
CREATE INDEX idx_location ON content_embeddings USING GIST (location);
CREATE INDEX idx_h3_cell ON content_embeddings (h3_cell_res9);
```

### 9.4 Caching Strategy

**Redis Vector Similarity Cache:**
- Cache embeddings for active H3 cells
- 1-hour TTL for cached content
- Semantic query caching (similarity threshold 0.95)
- Estimated cache hit rate: 40-60%

---

## 10. Cost Analysis

### 10.1 Per-Operation Costs

**Content Creation (per post):**
| Operation | Model | Cost |
|-----------|-------|------|
| Content moderation | OpenAI Moderation | $0 (free) |
| Text embedding | text-embedding-3-small | $0.000002 |
| Classification | GPT-4o-mini | $0.00009 |
| **Total per post** | | **~$0.0001** |

**Content Discovery (per query):**
| Operation | Model | Cost |
|-----------|-------|------|
| Query embedding | text-embedding-3-small | $0.000001 |
| Vector search | pgvector | $0 (included) |
| Result ranking | GPT-4o-mini | $0.00023 |
| **Total per query** | | **~$0.0003** |

**Reality Filter (per session):**
| Operation | Model | Cost |
|-----------|-------|------|
| Preference analysis | Claude Haiku | $0.00075 |
| Content filtering | GPT-4o-mini | $0.0009 |
| **Total per session** | | **~$0.002** |

### 10.2 Projected Monthly Costs by Scale

| Users | Posts/mo | Queries/mo | Sessions/mo | Est. AI Cost |
|-------|----------|------------|-------------|--------------|
| 1,000 | 3K | 50K | 20K | ~$60 |
| 10,000 | 30K | 500K | 200K | ~$600 |
| 100,000 | 300K | 5M | 2M | ~$6,000 |
| 1,000,000 | 3M | 50M | 20M | ~$60,000 |

### 10.3 Cost Optimization Strategies

| Strategy | Expected Savings |
|----------|------------------|
| Semantic caching | 40-60% |
| Request batching | 20-30% |
| Tiered model selection | 50-70% |
| Edge offloading | 60-80% for simple tasks |

### 10.4 Vector Database Costs

| Solution | 1M Vectors | 10M Vectors | 100M Vectors |
|----------|------------|-------------|--------------|
| pgvector (Supabase) | $25/mo (included) | $25/mo | $100/mo |
| Pinecone | $70/mo | $700/mo | $7,000/mo |
| Qdrant Cloud | $50/mo | $200/mo | $1,500/mo |

**Recommendation:** Start with pgvector, evaluate dedicated solution at >10M vectors.

---

## References

### Model Documentation
- [Anthropic Claude API](https://docs.anthropic.com/en/api)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [Google Gemini API](https://ai.google.dev/gemini-api/docs)
- [OpenAI Moderation](https://platform.openai.com/docs/guides/moderation)

### Vector Databases
- [pgvector Documentation](https://github.com/pgvector/pgvector)
- [Supabase Vector](https://supabase.com/docs/guides/ai)

### AR/Spatial
- [ARKit Documentation](https://developer.apple.com/documentation/arkit)
- [ARCore Documentation](https://developers.google.com/ar)
- [H3 Geo Index](https://h3geo.org/)
- [PostGIS](https://postgis.net/)

### ML Models
- [Depth Anything](https://github.com/LiheYoung/Depth-Anything)
- [MiDaS](https://github.com/isl-org/MiDaS)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [Core ML](https://developer.apple.com/documentation/coreml)

---

*Document generated: January 2026*
*Next review: Prior to MVP development kickoff*
*AI-Assisted Documentation using Claude Flow orchestration*
