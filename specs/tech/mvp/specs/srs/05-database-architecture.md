# 5. Database Architecture

> [← Back to Index](./index.md) | [← Previous: User Interface Specifications](./04-user-interface-specifications.md)

## 5.1 Database Selection

**Primary Database:** PostgreSQL 15+ with PostGIS and H3 extensions

**Rationale:**
- PostGIS provides industry-standard spatial querying
- H3 extension enables efficient hexagonal spatial indexing
- Row-Level Security (RLS) for data isolation
- JSON/JSONB for flexible metadata storage
- Native full-text search capabilities
- pgvector extension for AI embeddings

## 5.2 Schema Design

### 5.2.1 Entity Relationship Diagram

```
┌─────────────┐       ┌─────────────────┐       ┌─────────────┐
│   users     │       │     posts       │       │place_anchors│
├─────────────┤       ├─────────────────┤       ├─────────────┤
│ id (PK)     │──┐    │ id (PK)         │    ┌──│ id (PK)     │
│ email       │  │    │ user_id (FK)────│────┘  │ lat         │
│ username    │  └────│ place_anchor_id │       │ lng         │
│ ...         │       │ content         │       │ h3_index_*  │
└─────────────┘       │ media_url       │       │ ...         │
       │              │ ...             │       └─────────────┘
       │              └─────────────────┘              │
       │                     │                         │
       │                     │                         │
       ▼                     ▼                         ▼
┌─────────────┐       ┌─────────────┐         ┌─────────────────┐
│  reactions  │       │  comments   │         │  place_follows  │
├─────────────┤       ├─────────────┤         ├─────────────────┤
│ id (PK)     │       │ id (PK)     │         │ id (PK)         │
│ post_id(FK) │       │ post_id(FK) │         │ user_id (FK)    │
│ user_id(FK) │       │ user_id(FK) │         │ place_id (FK)   │
│ emoji       │       │ content     │         │ created_at      │
└─────────────┘       └─────────────┘         └─────────────────┘
```

### 5.2.2 Table Definitions

#### users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE,
  display_name TEXT,
  bio TEXT,
  avatar_url TEXT,
  location_text TEXT,

  -- Authentication
  email_verified BOOLEAN DEFAULT FALSE,
  last_sign_in_at TIMESTAMPTZ,

  -- Settings
  reality_filter_level INTEGER DEFAULT 25 CHECK (reality_filter_level BETWEEN 0 AND 100),
  notification_preferences JSONB DEFAULT '{"email_digest": true, "in_app": true}'::jsonb,

  -- Privacy
  is_private BOOLEAN DEFAULT FALSE,
  blocked_user_ids UUID[] DEFAULT '{}',

  -- Moderation
  is_suspended BOOLEAN DEFAULT FALSE,
  suspension_reason TEXT,
  trust_score DECIMAL(3,2) DEFAULT 1.00,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT username_format CHECK (username ~ '^[a-z0-9_]{3,30}$'),
  CONSTRAINT display_name_length CHECK (char_length(display_name) <= 50),
  CONSTRAINT bio_length CHECK (char_length(bio) <= 160)
);

-- Indexes
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at DESC);
```

#### place_anchors

```sql
CREATE TABLE place_anchors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Location (precise)
  lat DOUBLE PRECISION NOT NULL,
  lng DOUBLE PRECISION NOT NULL,
  accuracy_meters REAL,

  -- H3 Indexes (multiple resolutions for efficient querying)
  h3_index_12 TEXT NOT NULL,  -- ~10m hexagon (precise)
  h3_index_9 TEXT NOT NULL,   -- ~150m hexagon (neighborhood)
  h3_index_6 TEXT NOT NULL,   -- ~3km hexagon (city-level)

  -- PostGIS geometry
  location GEOGRAPHY(POINT, 4326) GENERATED ALWAYS AS (
    ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
  ) STORED,

  -- Place metadata
  custom_name TEXT,
  reverse_geocode JSONB,  -- Cached geocoding result
  place_type TEXT,        -- 'custom', 'business', 'landmark', etc.

  -- Statistics
  post_count INTEGER DEFAULT 0,
  follower_count INTEGER DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT lat_range CHECK (lat BETWEEN -90 AND 90),
  CONSTRAINT lng_range CHECK (lng BETWEEN -180 AND 180)
);

-- Indexes
CREATE INDEX idx_place_anchors_h3_12 ON place_anchors(h3_index_12);
CREATE INDEX idx_place_anchors_h3_9 ON place_anchors(h3_index_9);
CREATE INDEX idx_place_anchors_h3_6 ON place_anchors(h3_index_6);
CREATE INDEX idx_place_anchors_location ON place_anchors USING GIST(location);
CREATE INDEX idx_place_anchors_post_count ON place_anchors(post_count DESC);
```

#### posts

```sql
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  place_anchor_id UUID NOT NULL REFERENCES place_anchors(id),

  -- Content
  content TEXT,
  media_url TEXT,
  media_thumbnail_url TEXT,
  media_type TEXT CHECK (media_type IN ('image', 'video')),
  media_metadata JSONB,  -- dimensions, duration, etc.

  -- AI/Moderation
  moderation_score DECIMAL(3,2),
  moderation_flags JSONB,
  is_hidden BOOLEAN DEFAULT FALSE,       -- Hidden by moderation
  hide_reason TEXT,
  embedding VECTOR(1536),                -- For semantic search

  -- Engagement counters (denormalized for performance)
  reaction_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,

  -- Deletion (soft delete)
  is_deleted BOOLEAN DEFAULT FALSE,
  deleted_at TIMESTAMPTZ,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT content_or_media CHECK (content IS NOT NULL OR media_url IS NOT NULL),
  CONSTRAINT content_length CHECK (char_length(content) <= 500)
);

-- Indexes
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_place_anchor_id ON posts(place_anchor_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_posts_not_deleted ON posts(id) WHERE NOT is_deleted AND NOT is_hidden;
CREATE INDEX idx_posts_embedding ON posts USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Trigger to update place_anchor.post_count
CREATE OR REPLACE FUNCTION update_place_post_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE place_anchors SET post_count = post_count + 1 WHERE id = NEW.place_anchor_id;
  ELSIF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE) THEN
    UPDATE place_anchors SET post_count = post_count - 1 WHERE id = OLD.place_anchor_id;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_place_post_count
AFTER INSERT OR UPDATE OR DELETE ON posts
FOR EACH ROW EXECUTE FUNCTION update_place_post_count();
```

#### reactions

```sql
CREATE TABLE reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  emoji TEXT NOT NULL CHECK (emoji IN ('❤️', '👍', '😂', '😮', '😢', '📍')),
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(post_id, user_id)  -- One reaction per user per post
);

CREATE INDEX idx_reactions_post_id ON reactions(post_id);
CREATE INDEX idx_reactions_user_id ON reactions(user_id);
```

#### comments

```sql
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,

  -- Moderation
  moderation_score DECIMAL(3,2),
  is_hidden BOOLEAN DEFAULT FALSE,

  -- Deletion
  is_deleted BOOLEAN DEFAULT FALSE,
  deleted_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT content_length CHECK (char_length(content) <= 280)
);

CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_created_at ON comments(post_id, created_at DESC);
```

#### place_follows

```sql
CREATE TABLE place_follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  place_id UUID NOT NULL REFERENCES place_anchors(id) ON DELETE CASCADE,

  -- Notification preferences for this follow
  notify_new_posts BOOLEAN DEFAULT TRUE,

  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, place_id)
);

CREATE INDEX idx_place_follows_user_id ON place_follows(user_id);
CREATE INDEX idx_place_follows_place_id ON place_follows(place_id);
```

#### notifications

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

  type TEXT NOT NULL CHECK (type IN (
    'reaction', 'comment', 'follow', 'mention', 'place_activity', 'system'
  )),

  -- Reference to related entity
  reference_type TEXT,  -- 'post', 'comment', 'user', 'place'
  reference_id UUID,

  -- Notification content
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,

  -- Status
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT reference_required CHECK (
    (reference_type IS NULL AND reference_id IS NULL) OR
    (reference_type IS NOT NULL AND reference_id IS NOT NULL)
  )
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, created_at DESC)
  WHERE NOT is_read;
```

## 5.3 Row-Level Security Policies

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users: Can read public profiles, can update own profile
CREATE POLICY users_read ON users
  FOR SELECT USING (true);

CREATE POLICY users_update ON users
  FOR UPDATE USING (auth.uid() = id);

-- Posts: Can read non-deleted public posts, can CRUD own posts
CREATE POLICY posts_read ON posts
  FOR SELECT USING (
    NOT is_deleted
    AND NOT is_hidden
    AND NOT EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = posts.user_id
      AND u.is_private = true
      AND u.id != auth.uid()
    )
  );

CREATE POLICY posts_insert ON posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY posts_update ON posts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY posts_delete ON posts
  FOR DELETE USING (auth.uid() = user_id);

-- Notifications: Users can only see their own
CREATE POLICY notifications_owner ON notifications
  FOR ALL USING (auth.uid() = user_id);
```

## 5.4 Database Functions

```sql
-- Get nearby posts with scoring
CREATE OR REPLACE FUNCTION get_nearby_posts(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_meters INTEGER DEFAULT 5000,
  page_size INTEGER DEFAULT 20,
  page_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  post_id UUID,
  content TEXT,
  media_url TEXT,
  user_id UUID,
  username TEXT,
  avatar_url TEXT,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  distance_meters DOUBLE PRECISION,
  reaction_count INTEGER,
  comment_count INTEGER,
  created_at TIMESTAMPTZ,
  feed_score DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  WITH user_location AS (
    SELECT ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography AS geog
  )
  SELECT
    p.id,
    p.content,
    p.media_url,
    p.user_id,
    u.username,
    u.avatar_url,
    pa.lat,
    pa.lng,
    ST_Distance(pa.location, ul.geog) AS distance_meters,
    p.reaction_count,
    p.comment_count,
    p.created_at,
    (
      POWER(0.5, EXTRACT(EPOCH FROM (NOW() - p.created_at)) / 86400.0) *
      EXP(-ST_Distance(pa.location, ul.geog) / 1000.0) *
      (1 + LOG(GREATEST(1, p.reaction_count + p.comment_count * 2)))
    ) AS feed_score
  FROM posts p
  JOIN users u ON p.user_id = u.id
  JOIN place_anchors pa ON p.place_anchor_id = pa.id
  CROSS JOIN user_location ul
  WHERE
    NOT p.is_deleted
    AND NOT p.is_hidden
    AND ST_DWithin(pa.location, ul.geog, radius_meters)
  ORDER BY feed_score DESC
  LIMIT page_size
  OFFSET page_offset;
END;
$$ LANGUAGE plpgsql STABLE;
```

---

> [Next: Authentication & User Account System →](./06-authentication-user-account-system.md)
