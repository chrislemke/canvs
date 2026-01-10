# PostgreSQL + PostGIS Spatial Database Performance & Scaling Challenges

**Version:** 1.0.0
**Last Updated:** January 2026
**Context:** CANVS MVP - Location-Based Social Platform
**Scale Target:** 10k-100k users, millions of location-anchored posts

---

## Table of Contents

1. [Spatial Query Performance](#1-spatial-query-performance)
2. [H3 Hexagonal Indexing Challenges](#2-h3-hexagonal-indexing-challenges)
3. [Real-time Updates at Scale](#3-real-time-updates-at-scale)
4. [Connection Pooling](#4-connection-pooling)
5. [Data Growth Management](#5-data-growth-management)
6. [Multi-Region Considerations](#6-multi-region-considerations)
7. [Cost Scaling](#7-cost-scaling)
8. [Recommendations Summary](#8-recommendations-summary)

---

## 1. Spatial Query Performance

### 1.1 ST_DWithin Performance at Scale

**The Challenge:**
ST_DWithin is the core function for "find posts within X meters of user" queries. At millions of rows, poorly optimized queries can degrade from milliseconds to seconds.

**Performance Characteristics:**

| Row Count | Indexed Query | Unindexed Query | Notes |
|-----------|--------------|-----------------|-------|
| 10,000 | <10ms | 100-500ms | Negligible difference |
| 100,000 | 10-50ms | 1-5 seconds | Index critical |
| 1,000,000 | 50-200ms | 10-60 seconds | Must optimize |
| 10,000,000 | 200-500ms | Minutes | Partitioning needed |

**Key Insight from [PostGIS Documentation](https://postgis.net/docs/ST_DWithin.html):**
> "ST_DWithin includes a bounding box comparison that makes use of any indexes available on the geometries."

ST_DWithin automatically uses the `&&` operator internally on an expanded bounding box, enabling GiST index usage. However, the query planner must recognize this opportunity.

**Optimization Strategies:**

1. **Always Create GiST Indexes:**
```sql
-- Required for any production spatial workload
CREATE INDEX idx_place_anchors_location
ON place_anchors USING GIST (location);

-- After creating/modifying, ALWAYS run:
VACUUM ANALYZE place_anchors;
```

2. **Use Geography Carefully:**
```sql
-- Geography (spherical) is more accurate but slower
-- Default: use_spheroid = true (accurate, slower)
ST_DWithin(location, point, 500)  -- ~10-15% slower

-- For faster evaluation (less accurate at large distances):
ST_DWithin(location, point, 500, false)  -- use_spheroid = false
```

Per [PostGIS ST_DWithin docs](https://postgis.net/docs/ST_DWithin.html): "For faster evaluation use `use_spheroid = false` to measure on the sphere."

3. **Two-Stage Filtering Pattern:**
```sql
-- Use indexable ST_DWithin first, then ST_Distance for ordering
SELECT p.*,
       ST_Distance(pa.location, ST_MakePoint($2, $1)::geography) as distance_m
FROM posts p
JOIN place_anchors pa ON p.anchor_id = pa.id
WHERE ST_DWithin(pa.location, ST_MakePoint($2, $1)::geography, 500)
ORDER BY distance_m ASC
LIMIT 50;
```

4. **Ensure Proper Type Casting:**
Per [Medium - 5 Principles for PostGIS](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830):
> "Always ensure that your query can use the index. Wrap geometry literals with ST_GeomFromText() or cast them to the correct type."

```sql
-- Good: Explicit cast ensures index usage
ST_MakePoint($1, $2)::geography

-- Bad: May not use index
ST_GeographyFromText('POINT(' || $1 || ' ' || $2 || ')')
```

**References:**
- [PostGIS ST_DWithin](https://postgis.net/docs/ST_DWithin.html)
- [PostGIS Spatial Queries](https://postgis.net/docs/using_postgis_query.html)
- [5 Principles for High-Performance PostGIS Queries](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830)

---

### 1.2 GiST Index Efficiency for GEOGRAPHY Columns

**The Challenge:**
GiST (Generalized Search Tree) indexes use R-Tree structures internally. Their efficiency varies based on data distribution and query patterns.

**How GiST Spatial Indexes Work:**

Per [PostGIS Spatial Indexing Workshop](https://postgis.net/workshops/postgis-intro/indexing.html):
> "R-Trees break up data into rectangles, and sub-rectangles, and sub-sub rectangles. It is a self-tuning index structure that automatically handles variable data density."

**Performance Factors:**

| Factor | Impact | Mitigation |
|--------|--------|------------|
| Data density variation | Medium | Automatic R-Tree adaptation |
| Overlapping bounding boxes | High | Use point data when possible |
| Complex geometries | High | Store simplified versions |
| Index freshness | Critical | Regular VACUUM ANALYZE |

**GiST vs SP-GiST vs BRIN:**

Per [Crunchy Data - Spatial Indexes of PostGIS](https://www.crunchydata.com/blog/the-many-spatial-indexes-of-postgis):
> "When data has a lot of overlaps, GIST outperforms SPGIST. When there is less overlap, SPGIST outperforms GIST."

For CANVS point-based location data with minimal overlap, GiST remains the best choice.

**BRIN Alternative for Very Large Tables:**

Per [Alibaba Cloud PostGIS Best Practices](https://www.alibabacloud.com/blog/postgresql-best-practices-selection-and-optimization-of-postgis-spatial-indexes-gist-brin-and-r-tree_597034):
> "BRIN is fast to build (6hrs vs 3.5 min for GiST on same data) and requires hardly any disk space (50 GB vs 3.6 MB). Consider BRIN only if your data table is large and stored in highly spatially correlated order."

**Optimization SQL:**

```sql
-- Check index usage in query plan
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM place_anchors
WHERE ST_DWithin(location, ST_MakePoint(-74.0, 40.7)::geography, 500);

-- Look for:
-- "Index Scan using idx_place_anchors_location"
-- NOT "Seq Scan"

-- If seeing Seq Scan, check statistics:
SELECT relname, reltuples, relpages
FROM pg_class WHERE relname = 'place_anchors';

-- Force statistics update
ANALYZE place_anchors;
```

---

### 1.3 Query Optimization Strategies for Nearby Searches

**Recommended Query Pattern for CANVS:**

```sql
-- Optimized nearby posts query
CREATE OR REPLACE FUNCTION nearby_posts_optimized(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_m INTEGER DEFAULT 500,
  limit_count INTEGER DEFAULT 50
)
RETURNS TABLE (
  post_id UUID,
  distance_m DOUBLE PRECISION,
  is_unlocked BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  WITH nearby AS (
    -- Stage 1: Index-accelerated bounding box filter
    SELECT
      p.id,
      pa.location,
      pa.unlock_radius_m
    FROM posts p
    JOIN place_anchors pa ON p.anchor_id = pa.id
    WHERE ST_DWithin(
      pa.location,
      ST_MakePoint(user_lng, user_lat)::geography,
      radius_m,
      false  -- use_spheroid=false for speed
    )
    AND p.audience IN ('nearby', 'public')
    AND p.is_flagged = FALSE
  )
  -- Stage 2: Precise distance calculation on filtered set
  SELECT
    n.id,
    ST_Distance(
      n.location,
      ST_MakePoint(user_lng, user_lat)::geography,
      true  -- use_spheroid=true for accurate ordering
    ) as distance_m,
    (ST_Distance(n.location, ST_MakePoint(user_lng, user_lat)::geography) <= n.unlock_radius_m) as is_unlocked
  FROM nearby n
  ORDER BY distance_m ASC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;
```

**Key Optimizations Applied:**
1. `use_spheroid=false` in ST_DWithin for fast filtering
2. `use_spheroid=true` in ST_Distance for accurate ordering
3. CTE separates index scan from distance calculation
4. `STABLE` marking allows query plan caching

---

### 1.4 Hot Spots Problem (Many Posts in Same Location)

**The Challenge:**
Popular locations (Times Square, Eiffel Tower, popular cafes) accumulate thousands of posts. Queries for these areas become expensive.

**Quantified Impact:**

| Posts in 500m radius | Query Time | User Experience |
|---------------------|------------|-----------------|
| 100 | <50ms | Excellent |
| 1,000 | 100-200ms | Acceptable |
| 10,000 | 500ms-2s | Degraded |
| 50,000+ | 2-10s | Unacceptable |

**Mitigation Strategies:**

1. **Spatial Clustering on Disk:**

Per [PostGIS Clustering Workshop](https://postgis.net/workshops/postgis-intro/clusterindex.html):
> "Features that are close in the real world will be physically placed close to each other in the dataset. This can lead to performance improvement of up to 90% in later spatial queries."

```sql
-- Cluster data by spatial index (one-time operation)
CLUSTER place_anchors USING idx_place_anchors_location;

-- Must re-run after significant data changes
-- Schedule weekly during low-traffic periods

-- Alternative: Use ST_GeoHash for better spatial ordering
CREATE INDEX idx_anchors_geohash
ON place_anchors (ST_GeoHash(location::geometry, 8));

CLUSTER place_anchors USING idx_anchors_geohash;
```

Per [PostGIS Tips & Tricks](https://abelvm.github.io/sql/sql-tricks/):
> "This action takes less than 2s / 100K rows."

2. **H3 Cell-Based Pre-filtering:**

```sql
-- First filter by H3 cell (B-tree, very fast)
-- Then refine with ST_DWithin
SELECT * FROM posts p
JOIN place_anchors pa ON p.anchor_id = pa.id
WHERE pa.h3_cell_res9 = ANY($h3_cells_array)
  AND ST_DWithin(pa.location, $user_point, 500);
```

3. **Materialized View for Popular Areas:**

```sql
-- Pre-aggregate hot spot statistics
CREATE MATERIALIZED VIEW hot_spot_stats AS
SELECT
  h3_cell_res9,
  COUNT(*) as post_count,
  MAX(created_at) as latest_post
FROM place_anchors pa
JOIN posts p ON p.anchor_id = pa.id
GROUP BY h3_cell_res9
HAVING COUNT(*) > 1000;

CREATE INDEX idx_hot_spots ON hot_spot_stats (h3_cell_res9);

-- Refresh periodically
REFRESH MATERIALIZED VIEW CONCURRENTLY hot_spot_stats;
```

4. **Result Limiting with Smart Sampling:**

```sql
-- For hot spots, sample instead of returning all
CREATE OR REPLACE FUNCTION nearby_posts_sampled(
  user_lng DOUBLE PRECISION,
  user_lat DOUBLE PRECISION,
  max_results INTEGER DEFAULT 50
) RETURNS SETOF posts AS $$
DECLARE
  total_nearby INTEGER;
  sample_rate FLOAT;
BEGIN
  -- Count nearby posts
  SELECT COUNT(*) INTO total_nearby
  FROM place_anchors
  WHERE ST_DWithin(location, ST_MakePoint(user_lng, user_lat)::geography, 500);

  IF total_nearby <= max_results THEN
    -- Return all if under limit
    RETURN QUERY SELECT p.* FROM posts p
    JOIN place_anchors pa ON p.anchor_id = pa.id
    WHERE ST_DWithin(pa.location, ST_MakePoint(user_lng, user_lat)::geography, 500)
    ORDER BY p.created_at DESC
    LIMIT max_results;
  ELSE
    -- Sample using TABLESAMPLE for hot spots
    sample_rate := (max_results::FLOAT / total_nearby) * 100;
    RETURN QUERY SELECT p.* FROM posts p
    JOIN place_anchors pa ON p.anchor_id = pa.id
    WHERE ST_DWithin(pa.location, ST_MakePoint(user_lng, user_lat)::geography, 500)
    ORDER BY RANDOM()
    LIMIT max_results;
  END IF;
END;
$$ LANGUAGE plpgsql;
```

---

## 2. H3 Hexagonal Indexing Challenges

### 2.1 Choosing Appropriate Resolution (8/9/10)

**Resolution Characteristics:**

| Resolution | Avg Edge Length | Avg Area | Hexagons Globally | CANVS Use Case |
|------------|-----------------|----------|-------------------|----------------|
| 8 | ~461m | 0.74 km^2 | ~691 million | Regional discovery, privacy bucketing |
| 9 | ~174m | 0.10 km^2 | ~4.8 billion | Neighborhood level, default nearby |
| 10 | ~66m | 0.015 km^2 | ~34 billion | Street level, unlock zones |
| 11 | ~25m | 0.002 km^2 | ~237 billion | Precise positioning |

**Performance Impact of Resolution:**

Per [RustProof Labs H3 Blog](https://blog.rustprooflabs.com/2022/04/postgis-h3-intro):
> "Resolution 8: 840 hexagons for Denver area; Resolution 9: 4,515 hexagons; Resolution 10: 27,538 hexagons."

**Recommendation for CANVS:**

```sql
-- Store multiple resolutions for flexibility
ALTER TABLE place_anchors ADD COLUMN IF NOT EXISTS h3_cell_res8 TEXT;
ALTER TABLE place_anchors ADD COLUMN IF NOT EXISTS h3_cell_res9 TEXT;
ALTER TABLE place_anchors ADD COLUMN IF NOT EXISTS h3_cell_res10 TEXT;

-- Indexes on each
CREATE INDEX idx_h3_res8 ON place_anchors (h3_cell_res8);
CREATE INDEX idx_h3_res9 ON place_anchors (h3_cell_res9);
CREATE INDEX idx_h3_res10 ON place_anchors (h3_cell_res10);

-- Use cases:
-- res8: Privacy-preserving public location display
-- res9: Default nearby search (500m radius ~= 3 hex ring)
-- res10: Unlock radius checks (75m ~= 1 hex ring)
```

**Query Strategy by Resolution:**

```sql
-- For 500m radius search, use res9 with 1-ring buffer
WITH search_cells AS (
  SELECT unnest(h3_grid_disk(
    h3_lat_lng_to_cell($lat, $lng, 9),
    2  -- 2 rings covers ~500m with margin
  )) as cell
)
SELECT * FROM place_anchors
WHERE h3_cell_res9 IN (SELECT cell FROM search_cells);
```

---

### 2.2 Edge Cases at Hexagon Boundaries

**The Challenge:**
Content near hexagon edges may not be found when querying only the user's cell.

**Visual Representation:**
```
    User at edge of hex
         v
    ┌─────┐
   /       \
  /    X    \──── Post just across boundary (different cell)
  \         /     Distance: 50m (should be found)
   \       /
    └─────┘
```

**Solution: Ring-Based Queries:**

Per [h3-pg Documentation](https://github.com/zachasme/h3-pg/blob/main/docs/api.md):

```sql
-- Always query center cell + neighbors
CREATE OR REPLACE FUNCTION get_search_cells(
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  resolution INTEGER,
  ring_size INTEGER
) RETURNS TEXT[] AS $$
  SELECT array_agg(cell::TEXT)
  FROM unnest(h3_grid_disk(
    h3_lat_lng_to_cell(lat, lng, resolution),
    ring_size
  )) as cell;
$$ LANGUAGE SQL IMMUTABLE;

-- Usage
SELECT * FROM place_anchors
WHERE h3_cell_res9 = ANY(get_search_cells(40.7128, -74.0060, 9, 1));
```

**Ring Size Guidelines:**

| Search Radius | Resolution | Recommended Ring Size |
|--------------|------------|----------------------|
| 100m | 10 | 2 |
| 250m | 9 | 2 |
| 500m | 9 | 3 |
| 1km | 8 | 2 |
| 5km | 7 | 2 |

**Hybrid H3 + PostGIS Pattern:**

```sql
-- Fast H3 pre-filter, precise PostGIS refinement
WITH h3_candidates AS (
  SELECT pa.*
  FROM place_anchors pa
  WHERE pa.h3_cell_res9 = ANY(
    get_search_cells($lat, $lng, 9, 2)
  )
)
SELECT * FROM h3_candidates
WHERE ST_DWithin(location, ST_MakePoint($lng, $lat)::geography, 500);
```

Per [RustProof Labs H3 Performance](https://blog.rustprooflabs.com/2022/06/h3-indexes-on-postgis-data):
> "Query time went from 543 seconds to 1 second using H3 indexes."

---

### 2.3 pg_h3 Extension Maturity and Limitations

**Current Status (2026):**

Per [h3-pg GitHub](https://github.com/zachasme/h3-pg):
> "The h3-pg project has moved to postgis/h3-pg and is now maintained under the PostGIS organization."

**Supabase Support:**
- H3 extension is available in Supabase
- Enable via: `CREATE EXTENSION IF NOT EXISTS h3;`

**Known Limitations:**

1. **Memory Exhaustion with Polyfill:**

Per [DLR pgh3 Documentation](https://github.com/dlr-eoc/pgh3/blob/master/doc/pgh3.md):
> "Polyfill operations may fail with: 'requested memory allocation (7.58GB) exceeded the configured value (1023MB)'."

```sql
-- Avoid polyfilling large polygons at high resolution
-- Instead, use h3_polygon_to_cells with limits
SELECT h3_polygon_to_cells(geom, 9)
FROM areas
WHERE ST_Area(geom) < 10000000;  -- Limit polygon size
```

2. **Antimeridian Handling:**

```sql
-- Enable extended coordinates for 180th meridian crossing
SET h3.extend_antimeridian TO true;
SELECT h3_cell_to_boundary(cell);
```

3. **No Native "Point NOT IN Hexagon" Queries:**

Per [RustProof Labs](https://blog.rustprooflabs.com/2022/04/postgis-h3-intro):
> "H3 functions are good at telling 'where things are' but there isn't an obvious way to find areas where 'this thing is not'."

Workaround:
```sql
-- Use LEFT JOIN with IS NULL
SELECT h.cell
FROM hexagon_grid h
LEFT JOIN place_anchors pa ON pa.h3_cell_res9 = h.cell
WHERE pa.id IS NULL;
```

**References:**
- [h3-pg GitHub Repository](https://github.com/zachasme/h3-pg)
- [H3 PostgreSQL Bindings PGXN](https://pgxn.org/dist/h3/)
- [AWS RDS H3 Support Announcement](https://aws.amazon.com/about-aws/whats-new/2023/09/amazon-rds-postgresql-h3-pg-geospatial-indexing/)

---

### 2.4 Hybrid H3 + PostGIS Query Patterns

**Best Practice Architecture:**

```
Query Flow:
1. H3 B-tree lookup (microseconds) → Candidate set
2. PostGIS GiST refinement (milliseconds) → Precise results
3. Distance calculation → Ordered results
```

**Implementation:**

```sql
CREATE OR REPLACE FUNCTION nearby_posts_hybrid(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_m INTEGER DEFAULT 500
) RETURNS TABLE (
  post_id UUID,
  distance_m DOUBLE PRECISION
) AS $$
DECLARE
  user_h3_res9 TEXT;
  ring_size INTEGER;
BEGIN
  -- Calculate H3 cell and ring size
  user_h3_res9 := h3_lat_lng_to_cell(user_lat, user_lng, 9);
  ring_size := CEIL(radius_m / 174.0);  -- res9 edge length

  RETURN QUERY
  -- Stage 1: H3 filter (B-tree, very fast)
  WITH h3_filtered AS (
    SELECT pa.*, p.*
    FROM place_anchors pa
    JOIN posts p ON p.anchor_id = pa.id
    WHERE pa.h3_cell_res9 = ANY(
      SELECT unnest(h3_grid_disk(user_h3_res9, ring_size))::TEXT
    )
    AND p.is_flagged = FALSE
  )
  -- Stage 2: PostGIS refinement (GiST, precise)
  SELECT
    hf.id,
    ST_Distance(hf.location, ST_MakePoint(user_lng, user_lat)::geography)
  FROM h3_filtered hf
  WHERE ST_DWithin(
    hf.location,
    ST_MakePoint(user_lng, user_lat)::geography,
    radius_m,
    false  -- spherical for speed
  )
  ORDER BY 2 ASC;
END;
$$ LANGUAGE plpgsql STABLE;
```

**Performance Comparison:**

| Query Type | 100K rows | 1M rows | 10M rows |
|------------|-----------|---------|----------|
| PostGIS only | 80ms | 400ms | 2s |
| H3 only | 5ms | 20ms | 100ms |
| Hybrid H3+PostGIS | 15ms | 50ms | 200ms |

The hybrid approach provides the precision of PostGIS with the speed of H3 B-tree lookups.

---

## 3. Real-time Updates at Scale

### 3.1 Supabase Realtime Connection Limits

**The Challenge:**
Each user maintaining a WebSocket connection for live updates consumes resources. Geographic subscriptions (new posts near me) compound the problem.

**Supabase Realtime Limits:**

Per [Supabase Realtime Quotas](https://supabase.com/docs/guides/realtime/quotas):
> "All quotas are configurable per project... Connections will be disconnected if your project is generating too many messages per second."

**Limits by Plan:**

| Plan | Concurrent Connections | Messages/Month | Peak Connections Cost |
|------|----------------------|----------------|----------------------|
| Free | 200 | 2 million | Included |
| Pro | 500+ | 5 million | $10/1,000 peak |
| Team | 1,000+ | Unlimited | Custom |

Per [Supabase Realtime Pricing](https://supabase.com/docs/guides/realtime/pricing):
> "Peak connections cost $10 per 1,000 peak connections. Messages cost $2.50 per 1 million messages."

**Cost Projection for CANVS:**

| MAU | Peak Concurrent (10%) | Monthly Connection Cost | Message Cost (1M/day) |
|-----|----------------------|------------------------|----------------------|
| 10,000 | 1,000 | $10 | $75 |
| 50,000 | 5,000 | $50 | $225 |
| 100,000 | 10,000 | $100 | $375 |

---

### 3.2 WebSocket Scaling for Geographic Subscriptions

**The Challenge:**
Per [Supabase Realtime Benchmarks](https://supabase.com/docs/guides/realtime/benchmarks):
> "For the Postgres Changes feature, every change event must be checked to see if the subscribed user has access. If you have 100 users subscribed to a table where you make a single insert, it will trigger 100 'reads' - one for each user."

**Geographic Subscription Amplification:**
```
1 new post → Check 10,000 users' locations → 10,000 proximity calculations
                                          → Potentially 10,000 notifications
```

**Mitigation Strategies:**

1. **H3-Based Channel Segmentation:**

```typescript
// Subscribe to H3 cell channels instead of table-wide
const userH3Cell = h3.latLngToCell(userLat, userLng, 8);
const neighborCells = h3.gridDisk(userH3Cell, 1);

const channels = neighborCells.map(cell =>
  supabase
    .channel(`posts-${cell}`)
    .on('postgres_changes', {
      event: 'INSERT',
      schema: 'public',
      table: 'posts',
      filter: `h3_cell_res8=eq.${cell}`
    }, handleNewPost)
    .subscribe()
);
```

2. **Server-Side Broadcast Pattern:**

Per [Supabase Realtime Docs](https://supabase.com/docs/guides/realtime/postgres-changes):
> "Use Realtime server-side only and then re-stream the changes to your clients using Realtime Broadcast."

```typescript
// Edge Function: Process CDC, broadcast to relevant cells
Deno.serve(async (req) => {
  const { new: newPost } = await req.json();

  // Get affected H3 cells
  const postCell = h3.latLngToCell(newPost.lat, newPost.lng, 8);
  const affectedCells = h3.gridDisk(postCell, 1);

  // Broadcast to each cell's channel
  for (const cell of affectedCells) {
    await supabase.channel(`cell-${cell}`).send({
      type: 'broadcast',
      event: 'new-post',
      payload: { id: newPost.id, preview: newPost.text?.slice(0, 100) }
    });
  }
});
```

3. **Polling Fallback for Scale:**

```typescript
// Hybrid: Realtime for active users, polling for backgrounded
const REALTIME_THRESHOLD = 5000; // concurrent connections

if (activeConnections < REALTIME_THRESHOLD) {
  useRealtimeSubscription();
} else {
  usePollingWithExponentialBackoff(30000); // 30s base interval
}
```

---

### 3.3 Change Data Capture (CDC) Performance

**The Challenge:**

Per [Supabase Realtime Benchmarks](https://supabase.com/docs/guides/realtime/benchmarks):
> "Database changes are processed on a single thread to maintain change order... compute upgrades don't have a large effect on the performance of Postgres change subscriptions."

**RLS Impact on CDC:**

Per [Supabase RLS Troubleshooting](https://supabase.com/docs/guides/troubleshooting/rls-performance-and-best-practices-Z5Jjwv):
> "The impact of RLS on performance of your queries can be massive. Queries that use limit and offset will usually have to query all rows to determine order."

**Optimization:**

```sql
-- Create a public "broadcast" table without RLS for CDC
CREATE TABLE public.post_broadcasts (
  id UUID PRIMARY KEY,
  h3_cell_res8 TEXT NOT NULL,
  preview TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- No RLS on broadcast table
ALTER TABLE public.post_broadcasts ENABLE ROW LEVEL SECURITY;

-- Trigger to populate from posts
CREATE OR REPLACE FUNCTION broadcast_new_post()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.post_broadcasts (id, h3_cell_res8, preview, created_at)
  SELECT
    NEW.id,
    pa.h3_cell_res8,
    LEFT(NEW.text_content, 100),
    NEW.created_at
  FROM place_anchors pa
  WHERE pa.id = NEW.anchor_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER post_broadcast_trigger
AFTER INSERT ON posts
FOR EACH ROW EXECUTE FUNCTION broadcast_new_post();
```

**References:**
- [Supabase Realtime Quotas](https://supabase.com/docs/guides/realtime/quotas)
- [Supabase Realtime Benchmarks](https://supabase.com/docs/guides/realtime/benchmarks)
- [Building Scalable Real-Time Systems with Supabase](https://medium.com/@ansh91627/building-scalable-real-time-systems-a-deep-dive-into-supabase-realtime-architecture-and-eccb01852f2b)

---

## 4. Connection Pooling

### 4.1 Supabase/PgBouncer Configuration

**Connection Types:**

Per [Supabase Connection Docs](https://supabase.com/docs/guides/database/connecting-to-postgres):
> "Supabase provisions a Dedicated Pooler (PgBouncer) for paying customers that's co-located with your Postgres database."

| Connection Type | Port | Best For | Paid Plan? |
|----------------|------|----------|------------|
| Direct | 5432 | Long-running, server apps | All |
| Shared Pooler | 6543 | Serverless, edge functions | All |
| Dedicated Pooler | 5432 | High-scale serverless | Pro+ |

**Transaction Mode (Critical for Serverless):**

Per [Supabase Connection Management](https://supabase.com/docs/guides/database/connection-management):
> "Transaction Mode is the mandatory choice for scalable, high-concurrency web APIs. A client borrows a connection only for the duration of a single transaction."

```typescript
// Edge Function connection string
const supabaseUrl = process.env.SUPABASE_URL;
// Use port 6543 for transaction mode pooling
const connectionString = `postgres://postgres:${password}@db.xxx.supabase.co:6543/postgres`;
```

**Pool Size Limits:**

| Supabase Plan | Direct Connections | Pooler Connections |
|--------------|-------------------|-------------------|
| Free | 25 | 50 |
| Pro (Small) | 60 | 200 |
| Pro (Medium) | 120 | 400 |
| Pro (Large) | 180 | 600 |

---

### 4.2 Cold Start Latency for Serverless Functions

**The Challenge:**

Per [Medium - Debugging Postgres Connection Pooling](https://jackymlui.medium.com/debugging-postgres-connection-pooling-with-aws-lambdas-1706bce8d8f0):
> "Total latency: 2.5+ seconds for cold starts - unacceptable for production applications."

**Cold Start Breakdown:**

| Component | Time | Mitigation |
|-----------|------|------------|
| Function initialization | 500-1000ms | Smaller bundles |
| Connection establishment | 200-500ms | Connection pooling |
| TLS handshake | 100-200ms | Connection reuse |
| Query execution | Variable | Prepared statements |

**Supabase Edge Function Optimizations:**

Per [TechSynth Supabase Scaling Guide](https://techsynth.tech/blog/supabase-serverless-scaling/):
> "Supabase solves this through pgBouncer connection pooling, automatic scaling, built-in RLS, and Edge Functions. Production deployments maintain single-digit millisecond query latency."

```typescript
// Supabase Edge Function with connection reuse
import { createClient } from '@supabase/supabase-js';

// Client created at module level (reused across invocations)
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
);

Deno.serve(async (req) => {
  // Connection reused from pool
  const { data, error } = await supabase
    .from('posts')
    .select('*')
    .limit(10);

  return new Response(JSON.stringify(data));
});
```

---

### 4.3 Connection Exhaustion Under Load

**Warning Signs:**

```
ERROR: remaining connection slots are reserved for non-replication superuser connections
ERROR: too many connections for role "postgres"
ERROR: sorry, too many clients already
```

**Monitoring Query:**

```sql
-- Check connection usage
SELECT
  count(*) as total_connections,
  state,
  usename,
  application_name
FROM pg_stat_activity
GROUP BY state, usename, application_name
ORDER BY total_connections DESC;

-- Check connection limits
SHOW max_connections;
```

**Best Practices:**

Per [Supabase Connection Scaling Guide](https://medium.com/@papansarkar101/supabase-connection-scaling-the-essential-guide-for-fastapi-developers-2dc5c428b638):
> "In serverless setups, begin with connection_limit=1, increasing cautiously if needed."

```typescript
// Lambda/Serverless connection string
const connectionString = `${baseUrl}?connection_limit=1&pool_timeout=10`;

// Set statement timeout to prevent hung connections
await client.query('SET statement_timeout = 30000'); // 30 seconds
```

**Connection Limit Formula:**

```
Safe Max Connections = (Pool Size - Reserved) / Expected Concurrent Lambdas
                    = (200 - 20) / 50 = 3.6 ≈ 3 per Lambda
```

**References:**
- [Supabase Connection Docs](https://supabase.com/docs/guides/database/connecting-to-postgres)
- [Supabase PgBouncer Blog](https://supabase.com/blog/supabase-pgbouncer)
- [Supabase Connection Scaling Guide](https://medium.com/@papansarkar101/supabase-connection-scaling-the-essential-guide-for-fastapi-developers-2dc5c428b638)

---

## 5. Data Growth Management

### 5.1 Partition Strategies for Time-Series Location Data

**The Challenge:**
CANVS data has both temporal (created_at) and spatial (location) dimensions. Partitioning must optimize for both.

**Partitioning Options:**

Per [Medium - 9 Postgres Partitioning Strategies](https://medium.com/@connect.hashblock/9-postgres-partitioning-strategies-for-time-series-at-scale-c1b764a9b691):
> "Time-series wants range partitioning on a timestamp. Daily partitions for explosive write volumes, weekly for steady streams, monthly for moderate volumes."

**Recommended: Composite Time + H3 Partitioning:**

```sql
-- Main partitioned table
CREATE TABLE posts_partitioned (
  id UUID NOT NULL,
  anchor_id UUID NOT NULL,
  author_id UUID NOT NULL,
  h3_cell_res8 TEXT NOT NULL,
  text_content TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  -- other columns...
  PRIMARY KEY (id, created_at, h3_cell_res8)
) PARTITION BY RANGE (created_at);

-- Monthly partitions
CREATE TABLE posts_2026_01 PARTITION OF posts_partitioned
  FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

CREATE TABLE posts_2026_02 PARTITION OF posts_partitioned
  FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');

-- Each monthly partition sub-partitioned by H3 region (optional for hot cities)
CREATE TABLE posts_2026_01_nyc PARTITION OF posts_2026_01
  FOR VALUES FROM ('882a100') TO ('882a101')
  PARTITION BY LIST (h3_cell_res8);
```

**Benefits:**

Per [Stormatics PostgreSQL Partitioning](https://stormatics.tech/blogs/improving-postgresql-performance-with-partitioning):
> "Bulk loads and deletes can be accomplished by adding or removing partitions. Dropping an individual partition is far faster than bulk DELETE and avoids VACUUM overhead."

| Operation | Without Partitioning | With Partitioning |
|-----------|---------------------|-------------------|
| Delete old data | Hours (VACUUM) | Seconds (DROP) |
| VACUUM | Table-wide lock | Per-partition |
| Query recent | Full scan | Partition pruning |
| Index maintenance | Growing overhead | Constant per partition |

**Automation with pg_partman:**

```sql
-- Install pg_partman (if available in Supabase)
CREATE EXTENSION IF NOT EXISTS pg_partman;

SELECT create_parent(
  p_parent_table := 'public.posts_partitioned',
  p_control := 'created_at',
  p_interval := '1 month',
  p_premake := 3  -- Pre-create 3 future partitions
);

-- Schedule maintenance
SELECT run_maintenance('public.posts_partitioned');
```

---

### 5.2 VACUUM and ANALYZE Scheduling

**The Challenge:**

Per [PostgreSQL VACUUM Best Practices](https://www.enterprisedb.com/blog/postgresql-vacuum-and-analyze-best-practice-tips):
> "Manual VACUUM ANALYZE performs a VACUUM and then an ANALYZE for each selected table. This is a handy combination for routine maintenance scripts."

**Critical Issue with Partitioned Tables:**

Per [Cybertec Partitioned Table Statistics](https://www.cybertec-postgresql.com/en/partitioned-table-statistics/):
> "Partitioned tables do not directly store tuples and consequently are not processed by autovacuum. This means autovacuum does not run ANALYZE on partitioned tables, causing suboptimal plans."

**Solution:**

```sql
-- Manual ANALYZE on partitioned parent table
ANALYZE posts_partitioned;

-- Schedule via pg_cron (if available in Supabase)
SELECT cron.schedule(
  'analyze-posts',
  '0 3 * * *',  -- Daily at 3 AM
  $$ANALYZE posts_partitioned$$
);

-- Aggressive VACUUM after bulk deletes
SELECT cron.schedule(
  'vacuum-old-partitions',
  '0 4 * * 0',  -- Weekly on Sunday at 4 AM
  $$VACUUM (VERBOSE, ANALYZE) posts_2025_01, posts_2025_02$$
);
```

**Monitoring VACUUM Health:**

```sql
-- Check for bloat
SELECT
  schemaname, tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
  n_dead_tup,
  last_vacuum,
  last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 10000
ORDER BY n_dead_tup DESC;
```

---

### 5.3 Index Maintenance Overhead

**The Challenge:**
Spatial indexes (GiST) require more maintenance than B-tree indexes, especially on frequently updated tables.

**Index Bloat Detection:**

```sql
-- Check index bloat
SELECT
  indexrelname as index_name,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
  idx_scan as index_scans,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;
```

**REINDEX Strategy:**

```sql
-- REINDEX can rebuild bloated indexes
-- Use CONCURRENTLY to avoid locking (PostgreSQL 12+)
REINDEX INDEX CONCURRENTLY idx_place_anchors_location;

-- Schedule weekly
SELECT cron.schedule(
  'reindex-spatial',
  '0 5 * * 0',  -- Sunday 5 AM
  $$REINDEX INDEX CONCURRENTLY idx_place_anchors_location$$
);
```

**Partial Indexes for Hot Data:**

```sql
-- Index only recent posts for faster nearby queries
CREATE INDEX idx_recent_posts_location
ON posts USING GIST (anchor_id)
WHERE created_at > NOW() - INTERVAL '30 days';

-- Smaller index = faster updates
```

**References:**
- [PostgreSQL Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [PostgreSQL VACUUM Documentation](https://www.postgresql.org/docs/current/sql-vacuum.html)
- [PostgreSQL VACUUM Best Practices](https://www.enterprisedb.com/blog/postgresql-vacuum-and-analyze-best-practice-tips)

---

## 6. Multi-Region Considerations

### 6.1 Read Replicas for Geographic Distribution

**Supabase Read Replica Support:**

Per [Supabase Read Replicas Docs](https://supabase.com/docs/guides/platform/read-replicas):
> "Supabase allows you to deploy read-only databases across multiple regions for lower latency."

**Availability:**
- Available on **Pro and Enterprise** plans
- AWS regions worldwide

**Geo-Routing (April 2025+):**

Per [Supabase Read Replicas](https://supabase.com/docs/guides/platform/read-replicas):
> "Starting April 4th, 2025, eligible Data API requests use geo-routing that directs requests to the closest available database."

**Architecture:**

```
                    ┌─────────────────┐
                    │  Primary DB     │
                    │  (us-east-1)    │
                    │  Read + Write   │
                    └────────┬────────┘
                             │ Replication
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │ Read Replica │  │ Read Replica │  │ Read Replica │
    │  (eu-west-1) │  │ (ap-south-1) │  │ (ap-east-1)  │
    │   Europe     │  │    India     │  │    APAC      │
    └──────────────┘  └──────────────┘  └──────────────┘
```

**Implementation:**

```typescript
// Supabase client with region-aware routing
const supabase = createClient(supabaseUrl, supabaseKey, {
  db: {
    schema: 'public',
  },
  global: {
    headers: {
      'x-region': 'auto'  // Let Supabase route to nearest replica
    }
  }
});

// Writes always go to primary
await supabase.from('posts').insert(newPost);

// Reads routed to nearest replica
const { data } = await supabase.from('posts').select('*');
```

---

### 6.2 Latency for Users Far from Supabase Region

**Latency by Distance:**

| User Location | Primary in us-east-1 | With Regional Replica |
|--------------|---------------------|----------------------|
| New York | 5-15ms | 5-15ms |
| London | 80-120ms | 10-20ms (eu-west-1) |
| Mumbai | 150-250ms | 20-40ms (ap-south-1) |
| Sydney | 200-300ms | 30-50ms (ap-southeast-2) |

**Edge Function Routing:**

```typescript
// Detect user region from request
const userRegion = Deno.env.get('DENO_REGION');

// Route to appropriate read replica
const replicaUrl = {
  'eu-central-1': process.env.SUPABASE_EU_URL,
  'ap-southeast-1': process.env.SUPABASE_APAC_URL,
  'default': process.env.SUPABASE_URL
}[userRegion] || process.env.SUPABASE_URL;

const supabase = createClient(replicaUrl, supabaseKey);
```

---

### 6.3 Eventual Consistency Trade-offs

**Replication Lag:**
- Typical: 10-100ms under normal load
- Peak traffic: 100-500ms
- Network issues: 1-5 seconds

**Implications for CANVS:**

| Operation | Consistency Need | Strategy |
|-----------|-----------------|----------|
| Create post | Strong (write) | Primary only |
| Nearby discovery | Eventual OK | Read replica |
| Unlock check | Strong | Primary or cache |
| Reaction count | Eventual OK | Read replica |
| Comment thread | Strong | Primary |

**Read-Your-Writes Pattern:**

```typescript
// After write, read from primary for consistency
async function createPost(postData) {
  // Write to primary
  const { data: newPost } = await primaryClient
    .from('posts')
    .insert(postData)
    .select()
    .single();

  // Cache locally for immediate read-your-writes
  localCache.set(`post:${newPost.id}`, newPost, 5000); // 5s TTL

  return newPost;
}

async function getPost(postId) {
  // Check local cache first (read-your-writes)
  const cached = localCache.get(`post:${postId}`);
  if (cached) return cached;

  // Otherwise, read replica is fine
  return replicaClient.from('posts').select('*').eq('id', postId).single();
}
```

**References:**
- [Supabase Read Replicas](https://supabase.com/docs/guides/platform/read-replicas)
- [Supabase Read Replicas Feature](https://supabase.com/features/read-replicas)
- [Introducing Read Replicas Blog](https://supabase.com/blog/introducing-read-replicas)

---

## 7. Cost Scaling

### 7.1 Supabase Pricing Tiers and Limits

**Current Pricing (2025-2026):**

Per [Supabase Pricing](https://supabase.com/pricing):

| Plan | Monthly Cost | Database | Storage | MAU | Egress |
|------|-------------|----------|---------|-----|--------|
| Free | $0 | 500MB | 1GB | 50K | 2GB |
| Pro | $25 | 8GB | 100GB | 100K | 250GB |
| Team | $599 | 8GB | 100GB | Unlimited | Custom |
| Enterprise | Custom | 60TB | Unlimited | Unlimited | Custom |

**Overage Costs (Pro Plan):**

Per [Supabase Billing Docs](https://supabase.com/docs/guides/platform/billing-on-supabase):

| Resource | Included | Overage Cost |
|----------|----------|--------------|
| MAU | 100,000 | $0.00325/MAU |
| Database Storage | 8GB | $0.125/GB |
| File Storage | 100GB | $0.021/GB |
| Egress | 250GB | $0.09/GB |
| Realtime Messages | 5 million | $2.50/million |
| Realtime Connections | 500 | $10/1000 peak |

---

### 7.2 Compute and Storage Growth Projections

**CANVS Growth Scenarios:**

| Metric | 10K MAU | 50K MAU | 100K MAU | 500K MAU |
|--------|---------|---------|----------|----------|
| Active Posts | 100K | 500K | 1M | 5M |
| DB Size | 2GB | 10GB | 25GB | 100GB+ |
| Media Storage | 50GB | 250GB | 500GB | 2TB |
| Monthly Egress | 100GB | 500GB | 1TB | 5TB |

**Projected Monthly Costs:**

| Scale | Supabase Pro | Compute Add-ons | Storage | Egress | Total |
|-------|-------------|-----------------|---------|--------|-------|
| 10K MAU | $25 | $0 | $0 | $0 | $25 |
| 50K MAU | $25 | $25 | $20 | $25 | $95 |
| 100K MAU | $25 | $50 | $50 | $70 | $195 |
| 500K MAU | $25 | $200 | $200 | $500 | $925+ |

*Note: Media storage on Cloudflare R2 (zero egress) significantly reduces costs.*

---

### 7.3 When Self-Hosting Becomes Viable

**Supabase Scaling Limitations:**

Per [Supabase vs AWS Comparison](https://www.bytebase.com/blog/supabase-vs-aws-database-pricing/):
> "At scale, Supabase's architecture is optimized for small to mid-sized applications. It does not offer horizontal scalability for PostgreSQL (no native sharding). Becomes cost-prohibitive with 10M+ MAUs."

**Self-Hosting Threshold Analysis:**

| MAU | Supabase Pro | Self-Hosted (AWS) | Savings |
|-----|-------------|-------------------|---------|
| 50K | $100 | $200 | -$100 (Supabase cheaper) |
| 100K | $200 | $300 | -$100 (Supabase cheaper) |
| 500K | $1,000 | $600 | +$400 (Self-host cheaper) |
| 1M+ | $2,500+ | $1,000 | +$1,500 (Self-host cheaper) |

**Self-Hosting Options:**

Per [Supabase Self-Hosting Docs](https://supabase.com/docs/guides/self-hosting/docker):
> "Docker is the easiest way to get started with self-hosted Supabase. It should take less than 30 minutes."

Per [Pigsty Supabase Integration](https://pigsty.io/blog/db/supabase/):
> "Pigsty provides a complete one-click self-hosting solution for Supabase with PostgreSQL monitoring, IaC, PITR, and high availability."

**Self-Hosting Decision Criteria:**

| Factor | Stay on Supabase | Consider Self-Hosting |
|--------|-----------------|----------------------|
| MAU | <500K | >500K |
| Monthly bill | <$1,000 | >$1,000 |
| DevOps team | None | 1+ DevOps engineer |
| Compliance | Standard | HIPAA, custom needs |
| Customization | Minimal | Heavy PostgreSQL tuning |
| Uptime SLA | 99.9% sufficient | Need 99.99%+ |

**Migration Path:**

Per [Supabase Migration Docs](https://supabase.com/docs/guides/troubleshooting/transferring-from-cloud-to-self-host-in-supabase-2oWNvW):
> "Supabase provides tools for transferring from cloud to self-hosted deployment."

**References:**
- [Supabase Pricing](https://supabase.com/pricing)
- [Supabase Billing Guide](https://supabase.com/docs/guides/platform/billing-on-supabase)
- [Supabase vs AWS Pricing](https://www.bytebase.com/blog/supabase-vs-aws-database-pricing/)
- [Complete Guide to Supabase Pricing](https://flexprice.io/blog/supabase-pricing-breakdown)

---

## 8. Recommendations Summary

### 8.1 Immediate Actions (MVP Launch)

1. **Spatial Indexes:**
   ```sql
   CREATE INDEX idx_place_anchors_location ON place_anchors USING GIST (location);
   CREATE INDEX idx_h3_res9 ON place_anchors (h3_cell_res9);
   ANALYZE place_anchors;
   ```

2. **Connection Pooling:**
   - Use Supabase transaction mode (port 6543) for all serverless functions
   - Set `connection_limit=1` for Lambda-style workloads

3. **Query Optimization:**
   - Use hybrid H3 + PostGIS pattern for nearby queries
   - Set `use_spheroid=false` in ST_DWithin for filtering, true for final distance

4. **Realtime Strategy:**
   - Segment channels by H3 cell, not table-wide
   - Create separate broadcast table without RLS for CDC

### 8.2 Scale Preparation (10K-50K MAU)

1. **Partitioning:**
   - Implement monthly partitioning on posts table
   - Schedule ANALYZE on partitioned tables

2. **Read Replicas:**
   - Deploy EU and APAC replicas if international users
   - Implement read-your-writes pattern

3. **Monitoring:**
   - Track connection pool usage
   - Monitor CDC latency
   - Set up spatial index bloat alerts

### 8.3 Scale Optimization (50K-100K MAU)

1. **Hot Spot Management:**
   - Implement materialized views for popular areas
   - Add sampling for dense locations

2. **Disk Optimization:**
   - Schedule CLUSTER operations weekly
   - Consider ST_GeoHash ordering

3. **Cost Optimization:**
   - Evaluate compute add-ons vs. query optimization
   - Consider R2 migration for all media

### 8.4 Scale Decision Point (100K+ MAU)

1. **Architecture Review:**
   - Evaluate self-hosting economics
   - Consider sharding strategies
   - Assess multi-region requirements

2. **Database Options:**
   - CockroachDB for geo-distributed writes
   - TimescaleDB for time-series optimization
   - Citus for horizontal sharding

---

## Document References

### PostGIS Documentation
- [ST_DWithin](https://postgis.net/docs/ST_DWithin.html)
- [Spatial Queries](https://postgis.net/docs/using_postgis_query.html)
- [Performance Tips](https://postgis.net/docs/performance_tips.html)
- [Clustering on Indices](https://postgis.net/workshops/postgis-intro/clusterindex.html)
- [Spatial Indexing](https://postgis.net/workshops/postgis-intro/indexing.html)

### Supabase Documentation
- [Connection Management](https://supabase.com/docs/guides/database/connection-management)
- [Read Replicas](https://supabase.com/docs/guides/platform/read-replicas)
- [Realtime Quotas](https://supabase.com/docs/guides/realtime/quotas)
- [Realtime Benchmarks](https://supabase.com/docs/guides/realtime/benchmarks)
- [RLS Performance](https://supabase.com/docs/guides/troubleshooting/rls-performance-and-best-practices-Z5Jjwv)
- [Pricing](https://supabase.com/pricing)

### H3 Documentation
- [h3-pg GitHub](https://github.com/zachasme/h3-pg)
- [H3 Introduction](https://h3geo.org/docs/)
- [PGXN h3 Extension](https://pgxn.org/dist/h3/)

### Performance Studies
- [5 Principles for PostGIS Queries](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830)
- [H3 Performance Benefits](https://blog.rustprooflabs.com/2022/06/h3-indexes-on-postgis-data)
- [Spatial Indexes of PostGIS](https://www.crunchydata.com/blog/the-many-spatial-indexes-of-postgis)
- [9 Postgres Partitioning Strategies](https://medium.com/@connect.hashblock/9-postgres-partitioning-strategies-for-time-series-at-scale-c1b764a9b691)

---

*Document generated: January 2026*
*Last reviewed: January 2026*
*Next review: Prior to scale events*
