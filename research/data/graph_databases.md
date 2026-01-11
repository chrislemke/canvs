# Graph Databases for CANVS: Comprehensive Research Report

**Research Date:** 2026-01-11
**Purpose:** Evaluate graph database options for CANVS spatial social platform
**Focus:** Place-as-index architecture, social connections, spatial relationships, meaning graph

---

## Executive Summary

Graph databases are ideally suited for CANVS's core architecture because they model relationships as first-class citizens rather than afterthoughts. CANVS's fundamental concept - "Place as Index" where every location becomes a node with memories, pins, bubbles, trails, and social connections - maps naturally to a graph data model.

**Top Recommendation:** Neo4j Aura Free Tier for MVP, with potential migration path to Neo4j Professional or Amazon Neptune Serverless for scale.

---

## 1. Why Graph Databases are Ideal for CANVS

### 1.1 The Core Problem Graph Databases Solve

Traditional relational databases treat relationships as foreign key constraints - they denote that rows are related but don't capture the richness of those connections. For CANVS, where the entire product is about relationships between:

- **People and Places** (User visited Location)
- **People and People** (User friends with User)
- **People and Memories** (User created Capsule at Location)
- **Places and Places** (Location connected to Location via Trail)
- **Memories and Emotions** (Capsule tagged with Emotion)

...this relational approach would require expensive JOIN operations that grow exponentially with relationship depth.

### 1.2 Graph Database Advantages for CANVS

| Capability | Graph Database Advantage | CANVS Application |
|------------|-------------------------|-------------------|
| **Index-Free Adjacency** | Each node holds pointers to neighbors - constant-time hops | "Your friend left a note here 3 years ago" - traverse User -> Friends -> Memories -> Places instantly |
| **Relationship Properties** | Edges can store data (timestamps, quality, intensity) | `FRIENDS_WITH {since: 2020, strength: 0.8}`, `VISITED {emotion: "joy", timestamp: ...}` |
| **Variable-Length Paths** | Query paths of unknown depth efficiently | "Find all memories from friends-of-friends within 2 hops" |
| **Pattern Matching** | Declarative pattern queries | "Find places where two friends have overlapping memories" |
| **Spatial Functions** | Native support for geospatial queries | "All pins within 500m of current location" |

### 1.3 Performance for Social Queries

Research shows that recommending items to users three connections away is **180x faster with graph databases than relational databases**. For CANVS's friend-memory surfacing feature, this is critical.

**Pointer Hopping:** Graph databases perform pointer hopping - a direct walk of memory. Relationships are stored as direct physical RAM addresses, making traversals extremely fast.

---

## 2. Graph Database Options Comparison

### 2.1 Neo4j

**Overview:** The most widely-used graph database, purpose-built for graph workloads with native graph storage and processing.

**Key Features:**
- Native property graph model
- Cypher query language (industry standard, declarative)
- ACID transactions
- Native spatial support with `point()` and `point.distance()` functions
- Vector data type support (as of 2025.10.1) for AI/embeddings
- GraphRAG integration for generative AI applications

**Pricing Tiers:**

| Tier | Price | Limits | Best For |
|------|-------|--------|----------|
| **Aura Free** | $0 | 50,000 nodes, 175,000 relationships, no time limit, no credit card | MVP, prototyping |
| **Professional** | $65/GB/month | Min 1GB, up to 128GB, auto-scaling, daily backups | Production apps |
| **Business Critical** | $146/GB/month | Min 2GB, enhanced SLA, security | Enterprise |

**Spatial Capabilities:**
```cypher
-- Create point index for fast spatial queries
CREATE POINT INDEX poiIndex FOR (p:Place) ON (p.location)

-- Find all pins within 500m
MATCH (p:Pin)
WHERE point.distance(p.location, point({latitude: 37.563434, longitude: -122.322255})) < 500
RETURN p

-- Distance between nodes
MATCH (u:User)-[:VISITED]->(p1:Place), (u)-[:VISITED]->(p2:Place)
RETURN p1.name, p2.name, point.distance(p1.location, p2.location) / 1000 AS km
```

**Pros:**
- Mature ecosystem, extensive documentation
- Intuitive Cypher query language
- Strong community and learning resources
- Free tier sufficient for MVP (50K nodes, 175K relationships)
- Native spatial functions built-in
- Vector search for AI features

**Cons:**
- Memory-based pricing can get expensive at scale
- Cypher has learning curve (though easier than GSQL)

**Sources:**
- [Neo4j AuraDB](https://neo4j.com/product/auradb/)
- [Neo4j Pricing on G2](https://www.g2.com/products/neo4j-graph-database/pricing)
- [Neo4j Spatial Functions](https://neo4j.com/docs/cypher-manual/current/functions/spatial/)

---

### 2.2 Amazon Neptune

**Overview:** AWS's fully managed graph database supporting property graphs (Gremlin, openCypher) and RDF (SPARQL).

**Key Features:**
- Multiple query languages: Gremlin, openCypher, SPARQL
- Neptune Serverless - automatic scaling
- Storage up to 128 TiB
- 100,000+ queries/second capability
- Integration with AWS ecosystem (Bedrock for AI, S3 for data lakes)
- GraphRAG with Amazon Bedrock Knowledge Bases

**Pricing Options:**

| Option | Model | Best For |
|--------|-------|----------|
| **On-Demand** | Pay per instance hour + storage + I/O | Predictable workloads |
| **Serverless** | Pay per NCU-second (1 NCU ≈ 2GB memory) | Variable workloads, up to 90% savings |
| **I/O-Optimized** | No I/O charges, higher base | I/O-heavy workloads (>25% of spend on I/O) |

**Neptune Serverless Benefits:**
- No upfront investment
- Scales instantly in fine-grained increments
- Up to 90% savings vs. provisioning for peak
- Pay only for resources used

**Pros:**
- Deep AWS integration
- Multiple query language support
- Serverless option for cost optimization
- High availability (3 AZs, 15 read replicas)
- No vendor lock-in concern if already on AWS

**Cons:**
- More complex pricing model
- Requires AWS ecosystem familiarity
- No free tier (but serverless can be very cheap for low usage)

**Sources:**
- [Amazon Neptune Features](https://aws.amazon.com/neptune/features/)
- [Amazon Neptune Pricing](https://aws.amazon.com/neptune/pricing/)

---

### 2.3 ArangoDB

**Overview:** Native multi-model database supporting documents, graphs, and key-values in one platform with a single query language (AQL).

**Key Features:**
- Multi-model: graph + document + key-value
- Powerful AQL query language (supports joins, graph traversals, full-text search)
- Horizontal scaling with SmartGraphs
- ACID transactions
- Built-in full-text search

**Pricing:**
- **Community Edition:** Free, fully featured, no size limits
- **Enterprise Edition:** Commercial license for advanced features (SmartGraphs, encryption, LDAP)
- **ArangoGraph (Cloud):** 14-day free trial, then $0.20/hour starting price

**Pros:**
- True multi-model - single database for all data types
- Can store graph relationships AND document data together
- Open source Community Edition is full-featured
- Flexible data modeling

**Cons:**
- Smaller ecosystem than Neo4j
- AQL has its own learning curve
- Cloud offering less mature than Neo4j Aura

**Sources:**
- [ArangoDB GitHub](https://github.com/arangodb/arangodb)
- [ArangoDB Enterprise](https://arango.ai/products/arangodb/)

---

### 2.4 Dgraph

**Overview:** Native GraphQL database with graph backend, designed for terabyte-scale real-time workloads.

**Key Features:**
- Native GraphQL (no code required for schema/API)
- Distributed, horizontally scalable
- Written in Go for performance
- Jepsen tested for consistency
- gRPC and Protocol Buffers support

**Pros:**
- GraphQL-native (modern API paradigm)
- Millisecond queries on terabytes
- Strong horizontal scaling
- Open source core

**Cons:**
- Smaller community than Neo4j
- Less mature tooling ecosystem
- Cloud pricing not as transparent

**Sources:**
- [Dgraph Pricing](https://dgraph.io/pricing)
- [Dgraph Documentation](https://docs.dgraph.io/)

---

### 2.5 JanusGraph

**Overview:** Open-source, distributed graph database under The Linux Foundation, supporting billions of vertices and edges.

**Key Features:**
- Apache License 2.0 (fully open source)
- Pluggable storage backends: Cassandra, HBase, Bigtable, BerkeleyDB, ScyllaDB
- Gremlin query language (Apache TinkerPop)
- Integration with Spark, Giraph, Hadoop for analytics
- Geo, numeric range, and full-text search via Elasticsearch/Solr
- ACID transactions

**Pricing:** **Free** (open source, self-hosted)

**Pros:**
- Completely free and open source
- Massive scale potential (billions of nodes)
- Flexible storage backend choice
- No vendor lock-in
- Strong for analytics workloads

**Cons:**
- Requires self-hosting and operations expertise
- More complex setup than managed services
- Gremlin less intuitive than Cypher

**Sources:**
- [JanusGraph.org](https://janusgraph.org/)
- [JanusGraph GitHub](https://github.com/JanusGraph/janusgraph)
- [IBM JanusGraph Deep Dive](https://www.ibm.com/think/insights/database-deep-dives-janusgraph)

---

### 2.6 TigerGraph

**Overview:** Massively parallel processing graph database built for analytical workloads and deep-link queries.

**Key Features:**
- GSQL query language (SQL-like + graph traversal)
- Native parallel processing
- Excellent for 10+ hop deep traversals
- 2-10x data compression
- Trillions of edges support

**Performance:**
- Data loading 12-58x faster than Neo4j
- Specializes in deep traversals in sub-second time
- Best for fraud detection, supply chain analysis, influence propagation

**Pros:**
- Unmatched performance for deep traversals
- Excellent for large-scale analytics
- Strong geospatial analysis capabilities

**Cons:**
- GSQL is proprietary (smaller ecosystem)
- Higher operational complexity
- Schema changes require query recompilation
- Steeper learning curve
- Enterprise pricing

**Best For:** Deep analytical queries (10+ hops), not ideal for CANVS MVP

**Sources:**
- [TigerGraph vs Neo4j Comparison](https://www.puppygraph.com/blog/tigergraph-vs-neo4j)
- [TigerGraph Geospatial Analysis](https://www.tigergraph.com/solutions/geospatial-analysis/)

---

## 3. Graph Modeling for CANVS

### 3.1 Node Types

```
(:User)           - Platform users
(:Place)          - Physical locations (with lat/long point property)
(:Pin)            - Simple anchors (notes, photos, audio, links)
(:Bubble)         - Group memory objects ("We used to meet here")
(:Capsule)        - Rich time capsules (multimedia + 3D capture + timeline)
(:Trail)          - Sequence of anchors forming narrative routes
(:Drop)           - Geo-fenced releases (music, art, collectibles)
(:Portal)         - Place-to-place connections via story logic
(:Emotion)        - Emotion taxonomy nodes (joy, grief, calm, etc.)
(:Topic)          - Interest/topic taxonomy nodes
```

### 3.2 Edge Types (Relationships)

```cypher
// User relationships
(User)-[:FRIENDS_WITH {since, strength}]->(User)
(User)-[:CREATED {timestamp, device}]->(Pin|Bubble|Capsule|Trail|Drop|Portal)
(User)-[:VISITED {timestamp, duration, emotion}]->(Place)
(User)-[:OPENED {timestamp}]->(Capsule|Drop)
(User)-[:IS_INTERESTED_IN {weight}]->(Topic)

// Content-Place relationships
(Pin)-[:LOCATED_AT {precision_level, anchor_type}]->(Place)
(Bubble)-[:LOCATED_AT]->(Place)
(Capsule)-[:LOCATED_AT]->(Place)
(Drop)-[:UNLOCKS_AT {start_time, end_time}]->(Place)

// Trail relationships
(Trail)-[:STARTS_AT]->(Place)
(Trail)-[:ENDS_AT]->(Place)
(Trail)-[:CONTAINS {order}]->(Pin|Bubble|Capsule)

// Portal relationships
(Portal)-[:CONNECTS {story_reason}]->(Place)
(Place)-[:SIBLING_OF {reason}]->(Place)

// Emotional/semantic relationships
(Pin|Bubble|Capsule)-[:TAGGED_WITH {intensity}]->(Emotion)
(Pin|Bubble|Capsule)-[:RELATES_TO]->(Topic)
(Place)-[:NEAR {distance_m}]->(Place)

// Memory surfacing relationships
(User)-[:REMEMBERS {emotional_weight, last_recalled}]->(Place)
```

### 3.3 Node Properties

```cypher
// User node
CREATE (u:User {
  id: "uuid",
  username: "string",
  created_at: datetime(),
  home_location: point({latitude: x, longitude: y}),
  privacy_level: "public|friends|private"
})

// Place node
CREATE (p:Place {
  id: "uuid",
  name: "string",
  location: point({latitude: x, longitude: y}),
  anchor_bundle: "json_reference",  // Multi-representation anchor data
  place_type: "bench|cafe|trail|plaza|etc",
  vps_coverage: boolean,
  created_at: datetime()
})

// Pin node
CREATE (pin:Pin {
  id: "uuid",
  content_type: "text|photo|audio|video|3d",
  content_url: "string",
  visibility: "public|friends|private|group",
  created_at: datetime(),
  expires_at: datetime(),  // Optional expiration
  anchor_confidence: float  // 0-1 confidence score
})

// Capsule node (Time Capsule)
CREATE (c:Capsule {
  id: "uuid",
  title: "string",
  description: "text",
  media_urls: ["array", "of", "urls"],
  spatial_capture_url: "3d_capture_reference",
  unlock_condition: "immediate|date|return_visit",
  unlock_date: datetime(),
  visibility: "public|friends|private",
  created_at: datetime()
})

// Trail node
CREATE (t:Trail {
  id: "uuid",
  name: "string",
  description: "text",
  estimated_duration_minutes: integer,
  distance_meters: float,
  emotional_theme: "string",  // "grief", "joy", "discovery"
  created_at: datetime()
})
```

### 3.4 The "Meaning Graph" - CANVS's Unique Layer

The Meaning Graph connects:
- **Emotions** to **Places** (via user memories)
- **People** to **People** (via shared place experiences)
- **Time** to **Place** (temporal scrubbing)
- **Topics** to **Places** (semantic discovery)

This enables queries like:
- "Where do people feel calm in this city?"
- "What places connect me and this friend?"
- "Show me the emotional history of this location"

---

## 4. Query Patterns for Data-Driven Features

### 4.1 Friend-Memory Surfacing

**Feature:** "Your friend left a note here 3 years ago"

```cypher
// Find all memories from friends at/near current location
MATCH (me:User {id: $userId})-[:FRIENDS_WITH]->(friend:User)
MATCH (friend)-[:CREATED]->(memory:Pin|Bubble|Capsule)
MATCH (memory)-[:LOCATED_AT]->(place:Place)
WHERE point.distance(place.location, point({latitude: $lat, longitude: $long})) < 500
RETURN friend.username, memory, place,
       point.distance(place.location, point({latitude: $lat, longitude: $long})) AS distance
ORDER BY memory.created_at DESC
```

### 4.2 Friends-of-Friends Memory Discovery

**Feature:** Extended network memory surfacing

```cypher
// Find memories from friends-of-friends (2 hops)
MATCH (me:User {id: $userId})-[:FRIENDS_WITH*1..2]->(person:User)
WHERE person <> me
MATCH (person)-[:CREATED]->(memory)
MATCH (memory)-[:LOCATED_AT]->(place:Place)
WHERE point.distance(place.location, point({latitude: $lat, longitude: $long})) < 1000
RETURN person.username,
       length((me)-[:FRIENDS_WITH*1..2]->(person)) AS connection_depth,
       memory, place
ORDER BY connection_depth, memory.created_at DESC
LIMIT 20
```

### 4.3 Emotion-Based Place Discovery

**Feature:** "Show me places where people reported feeling calm"

```cypher
// Find places tagged with specific emotion
MATCH (place:Place)<-[:LOCATED_AT]-(content)-[:TAGGED_WITH]->(e:Emotion {name: "calm"})
WHERE point.distance(place.location, point({latitude: $lat, longitude: $long})) < 5000
WITH place, count(content) AS calm_count
WHERE calm_count >= 3  // Minimum threshold
RETURN place, calm_count
ORDER BY calm_count DESC
LIMIT 10
```

### 4.4 Trail Discovery by Emotional Theme

**Feature:** "Discover trails that connect emotionally similar places"

```cypher
// Find trails with places sharing emotional theme
MATCH (t:Trail)-[:CONTAINS]->(content)-[:LOCATED_AT]->(place:Place)
MATCH (content)-[:TAGGED_WITH]->(emotion:Emotion)
WHERE point.distance(t.start_location, point({latitude: $lat, longitude: $long})) < 10000
WITH t, collect(DISTINCT emotion.name) AS emotions, count(place) AS place_count
WHERE "hope" IN emotions OR "discovery" IN emotions
RETURN t, emotions, place_count
ORDER BY place_count DESC
```

### 4.5 Hidden Place Connections

**Feature:** "Surface hidden connections between places I've visited"

```cypher
// Find places I've visited that share common visitors/creators
MATCH (me:User {id: $userId})-[:VISITED]->(myPlace:Place)
MATCH (other:User)-[:VISITED]->(myPlace)
MATCH (other)-[:VISITED]->(connectedPlace:Place)
WHERE connectedPlace <> myPlace
  AND NOT (me)-[:VISITED]->(connectedPlace)
WITH connectedPlace, count(DISTINCT other) AS shared_visitors
WHERE shared_visitors >= 3
RETURN connectedPlace, shared_visitors
ORDER BY shared_visitors DESC
LIMIT 10
```

### 4.6 Similar Place-Memory Pattern Users

**Feature:** "Find users with similar place-memory patterns"

```cypher
// Find users who created content at same places with similar emotions
MATCH (me:User {id: $userId})-[:CREATED]->(myContent)-[:LOCATED_AT]->(place:Place)
MATCH (myContent)-[:TAGGED_WITH]->(emotion:Emotion)
MATCH (other:User)-[:CREATED]->(theirContent)-[:LOCATED_AT]->(place)
MATCH (theirContent)-[:TAGGED_WITH]->(emotion)
WHERE other <> me
WITH other, count(DISTINCT place) AS shared_places,
     collect(DISTINCT emotion.name) AS shared_emotions
WHERE shared_places >= 2
RETURN other.username, shared_places, shared_emotions
ORDER BY shared_places DESC
```

### 4.7 AI Agent Context Query

**Feature:** "Give me a 30-minute walk that ends somewhere optimistic"

```cypher
// Find trail ending at optimistic place within walking distance
MATCH (t:Trail)-[:ENDS_AT]->(endPlace:Place)
MATCH (endPlace)<-[:LOCATED_AT]-(content)-[:TAGGED_WITH]->(e:Emotion)
WHERE e.name IN ["joy", "hope", "optimism", "inspiration"]
  AND t.estimated_duration_minutes <= 30
  AND point.distance(t.start_location, point({latitude: $lat, longitude: $long})) < 500
WITH t, endPlace, count(content) AS positive_content_count
ORDER BY positive_content_count DESC
RETURN t, endPlace, positive_content_count
LIMIT 5
```

### 4.8 Temporal Memory Query

**Feature:** "What happened here last summer?"

```cypher
// Find content at location from specific time period
MATCH (content)-[:LOCATED_AT]->(place:Place)
WHERE point.distance(place.location, point({latitude: $lat, longitude: $long})) < 100
  AND content.created_at >= datetime("2025-06-01")
  AND content.created_at <= datetime("2025-08-31")
OPTIONAL MATCH (creator:User)-[:CREATED]->(content)
RETURN content, creator.username, content.created_at
ORDER BY content.created_at DESC
```

---

## 5. Recommendation: Neo4j for CANVS

### 5.1 Why Neo4j

| Factor | Neo4j Advantage for CANVS |
|--------|---------------------------|
| **Free Tier** | 50K nodes, 175K relationships - sufficient for MVP |
| **Spatial Native** | Built-in `point()` and `point.distance()` - no extensions needed |
| **Cypher** | Intuitive pattern matching, easier to learn than Gremlin/GSQL |
| **Ecosystem** | Best documentation, community, learning resources |
| **AI Integration** | Vector search + GraphRAG ready for AI agent features |
| **Managed Service** | Aura handles operations, upgrades, backups |
| **Growth Path** | Clear upgrade path to Professional tier |

### 5.2 Implementation Path

**Phase 1: MVP (Neo4j Aura Free)**
- 50,000 nodes covers: ~5,000 users, ~20,000 places, ~25,000 content items
- Test core features: friend-memory surfacing, spatial queries, trails
- Validate graph model design
- Zero cost

**Phase 2: Beta (Neo4j Aura Professional)**
- Scale to 100,000+ users
- $65/GB/month starting
- Enable vector search for AI features
- Add more sophisticated queries

**Phase 3: Scale (Evaluate Options)**
- If >1M users: Consider Neptune Serverless for cost optimization
- If analytics-heavy: Consider ArangoDB multi-model
- If self-hosted required: Consider JanusGraph

### 5.3 Alternative Considerations

**Amazon Neptune** if:
- Already heavily invested in AWS
- Need serverless auto-scaling
- Want multiple query language options

**ArangoDB** if:
- Need document store alongside graph
- Want single database for all data types
- Prefer open-source with commercial option

**JanusGraph** if:
- Need complete control over infrastructure
- Have DevOps expertise for self-hosting
- Cost sensitivity at massive scale

---

## 6. Cost Projections

### Neo4j Aura

| Phase | Users | Estimated Nodes | Tier | Monthly Cost |
|-------|-------|-----------------|------|--------------|
| MVP | 1,000 | 30,000 | Free | $0 |
| Beta | 10,000 | 300,000 | Professional 4GB | $260 |
| Launch | 50,000 | 1.5M | Professional 16GB | $1,040 |
| Growth | 250,000 | 7.5M | Professional 64GB | $4,160 |

### Amazon Neptune Serverless

For comparison, Neptune Serverless charges per NCU-second:
- Low usage (dev): ~$50-100/month
- Medium usage: ~$200-500/month
- Variable workloads can see significant savings vs. provisioned

---

## 7. Implementation Considerations

### 7.1 Schema Design Best Practices

1. **Denormalize for read performance** - Store frequently-accessed data on nodes
2. **Use relationship properties** - Timestamps, weights on edges
3. **Create indexes** - Point indexes for spatial, composite indexes for common patterns
4. **Plan for temporal queries** - Include created_at, updated_at on all nodes

### 7.2 Indexing Strategy

```cypher
-- Essential indexes for CANVS
CREATE INDEX user_id FOR (u:User) ON (u.id)
CREATE INDEX place_id FOR (p:Place) ON (p.id)
CREATE POINT INDEX place_location FOR (p:Place) ON (p.location)
CREATE INDEX content_created FOR (c:Pin|Bubble|Capsule) ON (c.created_at)
CREATE INDEX emotion_name FOR (e:Emotion) ON (e.name)
```

### 7.3 Query Optimization

- Use `PROFILE` and `EXPLAIN` to analyze query plans
- Limit relationship traversal depth (`*1..3` not `*`)
- Use `LIMIT` on all discovery queries
- Consider query caching for common patterns

---

## 8. Conclusion

Graph databases are not just suitable for CANVS - they are the natural choice for a "Place-as-Index" architecture where relationships between people, places, memories, and emotions form the core product value.

**Neo4j Aura Free** provides the ideal starting point:
- Zero cost for MVP
- Native spatial queries
- Intuitive Cypher language
- Clear growth path
- Strong AI integration for future features

The graph model enables CANVS's differentiated features:
- Friend-memory surfacing
- Emotional place discovery
- Trail recommendations
- Hidden connection revelation
- AI agent context queries

This foundation supports the 2027 roadmap goal of "Scaling the Meaning Graph" with LLM integration for summarization, semantic search, and friend-memory surfacing.

---

## Sources

- [Neo4j AuraDB](https://neo4j.com/product/auradb/)
- [Neo4j Pricing on G2](https://www.g2.com/products/neo4j-graph-database/pricing)
- [Neo4j Spatial Functions](https://neo4j.com/docs/cypher-manual/current/functions/spatial/)
- [Neo4j Spatial Values](https://neo4j.com/docs/cypher-manual/current/values-and-types/spatial/)
- [Amazon Neptune Features](https://aws.amazon.com/neptune/features/)
- [Amazon Neptune Pricing](https://aws.amazon.com/neptune/pricing/)
- [ArangoDB GitHub](https://github.com/arangodb/arangodb)
- [ArangoDB Enterprise](https://arango.ai/products/arangodb/)
- [Dgraph Pricing](https://dgraph.io/pricing)
- [JanusGraph.org](https://janusgraph.org/)
- [JanusGraph GitHub](https://github.com/JanusGraph/janusgraph)
- [TigerGraph vs Neo4j](https://www.puppygraph.com/blog/tigergraph-vs-neo4j)
- [TigerGraph Geospatial](https://www.tigergraph.com/solutions/geospatial-analysis/)
- [Neo4j Knowledge Graph Use Cases](https://neo4j.com/use-cases/knowledge-graph/)
- [Neo4j Social Network Use Cases](https://neo4j.com/use-cases/social-network/)
- [Spatial Knowledge Graphs Podcast](https://mapscaping.com/podcast/spatial-knowledge-graphs/)
- [Graph Database Schema Design](https://medium.com/@guillaume.prevost/graph-database-design-for-our-social-travel-app-daedcab3ee92)
- [NebulaGraph Social Networks](https://www.nebula-graph.io/posts/social-networks-with-graph-database-1)
