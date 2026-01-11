# 3. Functional Requirements

> [← Back to Index](./index.md) | [← Previous: System Overview](./02-system-overview.md)

## 3.1 Map Mode (FR-MAP)

### 3.1.1 Overview

Map Mode is the primary discovery interface allowing users to explore location-anchored content on an interactive map.

### 3.1.2 Requirements

#### FR-MAP-001: Map Display

**Priority:** Critical
**Description:** The system SHALL display an interactive map centered on the user's current location.

**Acceptance Criteria:**
- Map loads within 2 seconds on 4G connection
- Map is pannable and zoomable with smooth 60fps animations
- User's location is indicated by a pulsing blue dot
- Location accuracy radius is shown as a semi-transparent circle

**Implementation Details:**

```javascript
// MapLibre GL JS Configuration
const mapConfig = {
  container: 'map-container',
  style: 'https://tiles.canvs.app/styles/light.json',
  center: [userLng, userLat],
  zoom: 15,
  minZoom: 3,
  maxZoom: 20,
  attributionControl: false,
  trackResize: true,
  fadeDuration: 300
};

// User location marker
const userLocationMarker = {
  type: 'Feature',
  geometry: {
    type: 'Point',
    coordinates: [lng, lat]
  },
  properties: {
    accuracy: accuracyMeters,
    heading: deviceHeading
  }
};
```

#### FR-MAP-002: Content Clustering

**Priority:** Critical
**Description:** The system SHALL cluster nearby posts into bubbles when multiple posts exist within proximity.

**Acceptance Criteria:**
- Posts within 50 meters at zoom level 15+ are clustered
- Cluster radius scales with zoom level
- Cluster shows post count badge
- Clicking cluster zooms to expand contents

**Clustering Algorithm:**

```javascript
// Supercluster configuration
const clusterConfig = {
  radius: 50,           // Cluster radius in pixels
  maxZoom: 18,          // Max zoom to cluster at
  minZoom: 0,
  minPoints: 2,         // Minimum posts to form cluster
  extent: 512,
  nodeSize: 64,

  // Custom reduce for cluster properties
  reduce: (accumulated, props) => {
    accumulated.postCount += 1;
    accumulated.latestTimestamp = Math.max(
      accumulated.latestTimestamp,
      props.createdAt
    );
    accumulated.hasMedia = accumulated.hasMedia || props.hasMedia;
  },

  // Initial properties for cluster
  map: (props) => ({
    postCount: 1,
    latestTimestamp: props.createdAt,
    hasMedia: props.mediaUrl !== null
  })
};
```

#### FR-MAP-003: Post Markers

**Priority:** Critical
**Description:** The system SHALL display individual posts as tappable markers on the map.

**Marker Visual Specification:**

| Property | Value |
|----------|-------|
| Shape | Circular with subtle shadow |
| Size | 40x40px on mobile, 32x32px on desktop |
| Color | Terracotta (#d97757) for posts with media, Sage (#8da399) for text-only |
| Animation | Subtle pulse on new posts (last 5 minutes) |

**Marker Interaction:**

```javascript
// Marker tap handler
function handleMarkerTap(postId, coordinates) {
  // 1. Highlight the marker
  setSelectedMarkerId(postId);

  // 2. Show preview card
  showPostPreview(postId);

  // 3. Optionally pan map to center on marker
  if (!isMarkerVisible(coordinates)) {
    map.easeTo({
      center: coordinates,
      duration: 300,
      easing: easeOutExpo
    });
  }
}

// Post preview card data
interface PostPreviewData {
  id: string;
  authorAvatar: string;
  authorName: string;
  textPreview: string;      // First 100 chars
  mediaThumbUrl?: string;
  reactionCount: number;
  commentCount: number;
  createdAt: Date;
  distance: number;         // Meters from user
}
```

#### FR-MAP-004: Geolocation Tracking

**Priority:** Critical
**Description:** The system SHALL track the user's location with appropriate accuracy handling.

**Accuracy Tiers:**

| Tier | Accuracy | UI Indication | Content Creation |
|------|----------|---------------|------------------|
| **High** | <10m | Green location dot | Allowed |
| **Medium** | 10-30m | Yellow location dot | Allowed with warning |
| **Low** | 30-100m | Orange location dot | Allowed with disclaimer |
| **Poor** | >100m | Red location dot | Blocked—prompt to retry |

**Geolocation Implementation:**

```javascript
// Geolocation options
const geoOptions = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 30000
};

// Location watcher with accuracy handling
function startLocationTracking() {
  return navigator.geolocation.watchPosition(
    (position) => {
      const { latitude, longitude, accuracy, heading } = position.coords;

      // Determine accuracy tier
      const tier = getAccuracyTier(accuracy);

      // Update location state
      updateUserLocation({
        lat: latitude,
        lng: longitude,
        accuracy,
        heading,
        tier,
        timestamp: position.timestamp
      });

      // Fetch nearby content if location changed significantly
      if (hasMovedSignificantly(latitude, longitude)) {
        fetchNearbyPosts(latitude, longitude, getViewRadius());
      }
    },
    (error) => handleGeolocationError(error),
    geoOptions
  );
}

function getAccuracyTier(accuracy) {
  if (accuracy <= 10) return 'high';
  if (accuracy <= 30) return 'medium';
  if (accuracy <= 100) return 'low';
  return 'poor';
}
```

#### FR-MAP-005: Map Controls

**Priority:** High
**Description:** The system SHALL provide map control buttons for common actions.

**Control Buttons:**

| Button | Icon | Position | Action |
|--------|------|----------|--------|
| **Recenter** | Compass/crosshair | Bottom-right | Pan to user location |
| **Zoom In** | Plus | Bottom-right (stacked) | Increase zoom by 1 |
| **Zoom Out** | Minus | Bottom-right (stacked) | Decrease zoom by 1 |
| **Layers** | Stacked squares | Top-right | Toggle map style |
| **Filter** | Funnel | Top-right | Open filter panel |

#### FR-MAP-006: Map Filters

**Priority:** Medium
**Description:** The system SHOULD allow users to filter visible content on the map.

**Filter Options:**

| Filter | Type | Options |
|--------|------|---------|
| **Time Range** | Dropdown | Last hour, Today, This week, This month, All time |
| **Content Type** | Multi-select | Photos, Text only, Verified places |
| **Author** | Toggle | Following only |
| **AI Filter** | Slider | Reality Filter intensity (0-100%) |

---

## 3.2 Timeline Mode (FR-TL)

### 3.2.1 Overview

Timeline Mode presents a chronological feed of content from the user's current vicinity and followed places.

### 3.2.2 Requirements

#### FR-TL-001: Feed Display

**Priority:** Critical
**Description:** The system SHALL display a scrollable feed of posts sorted by recency and proximity.

**Feed Algorithm (Pseudo Code):**

```
FUNCTION calculateFeedScore(post, userLocation):
    // Time decay factor (half-life: 24 hours)
    hoursAge = (now - post.createdAt) / 3600000
    timeFactor = 0.5 ^ (hoursAge / 24)

    // Distance factor (exponential decay)
    distance = haversineDistance(userLocation, post.location)
    distanceFactor = e ^ (-distance / 1000)  // 1km decay constant

    // Engagement boost
    engagementFactor = 1 + log10(1 + post.reactions + post.comments * 2)

    // Following boost
    followingBoost = isFollowing(post.placeId) ? 1.5 : 1.0

    // Final score
    RETURN timeFactor * distanceFactor * engagementFactor * followingBoost
```

**SQL Query:**

```sql
-- Fetch timeline posts with scoring
WITH user_location AS (
  SELECT
    ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography AS geog,
    $1 AS lng, $2 AS lat
),
scored_posts AS (
  SELECT
    p.*,
    u.username,
    u.avatar_url,
    pa.lat AS place_lat,
    pa.lng AS place_lng,
    ST_Distance(
      ST_SetSRID(ST_MakePoint(pa.lng, pa.lat), 4326)::geography,
      ul.geog
    ) AS distance_meters,
    (
      POWER(0.5, EXTRACT(EPOCH FROM (NOW() - p.created_at)) / 86400) *
      EXP(-ST_Distance(
        ST_SetSRID(ST_MakePoint(pa.lng, pa.lat), 4326)::geography,
        ul.geog
      ) / 1000) *
      (1 + LOG(1 + COALESCE(p.reaction_count, 0) + COALESCE(p.comment_count, 0) * 2)) *
      CASE WHEN pf.user_id IS NOT NULL THEN 1.5 ELSE 1.0 END
    ) AS feed_score
  FROM posts p
  JOIN users u ON p.user_id = u.id
  JOIN place_anchors pa ON p.place_anchor_id = pa.id
  CROSS JOIN user_location ul
  LEFT JOIN place_follows pf ON pf.place_id = pa.id AND pf.user_id = $3
  WHERE
    p.is_deleted = false
    AND p.is_hidden = false
    AND ST_DWithin(
      ST_SetSRID(ST_MakePoint(pa.lng, pa.lat), 4326)::geography,
      ul.geog,
      $4  -- radius in meters
    )
)
SELECT * FROM scored_posts
ORDER BY feed_score DESC
LIMIT $5 OFFSET $6;
```

#### FR-TL-002: Post Card Component

**Priority:** Critical
**Description:** Each post in the timeline SHALL be displayed as a card with consistent structure.

**Post Card Layout:**

```
┌────────────────────────────────────────────────────┐
│ ┌────┐  @username · 5 min ago · 📍 120m away       │
│ │ av │  ─────────────────────────────────────      │
│ └────┘                                             │
│                                                    │
│ Post text content goes here. It can be multiple    │
│ lines and will truncate after 280 characters...    │
│                                                    │
│ ┌──────────────────────────────────────────────┐   │
│ │                                              │   │
│ │           [Photo if present]                 │   │
│ │              16:9 aspect ratio               │   │
│ │                                              │   │
│ └──────────────────────────────────────────────┘   │
│                                                    │
│ ❤️ 24   💬 8   📍 Coffee Shop                       │
└────────────────────────────────────────────────────┘
```

**Card Component Interface:**

```typescript
interface PostCardProps {
  post: {
    id: string;
    userId: string;
    content: string;           // Max 280 chars displayed
    mediaUrl?: string;
    mediaType?: 'image' | 'video';
    createdAt: Date;
    placeAnchor: {
      id: string;
      name?: string;
      lat: number;
      lng: number;
    };
  };
  author: {
    id: string;
    username: string;
    avatarUrl?: string;
    isVerified: boolean;
  };
  engagement: {
    reactionCount: number;
    commentCount: number;
    userReaction?: string;     // Emoji if user reacted
  };
  distance: number;            // Meters from user
  onTap: () => void;
  onAuthorTap: () => void;
  onLocationTap: () => void;
  onReactionTap: () => void;
  onCommentTap: () => void;
}
```

#### FR-TL-003: Infinite Scroll

**Priority:** High
**Description:** The system SHALL implement infinite scroll to load more posts as the user scrolls.

**Implementation:**

```javascript
// Intersection Observer for infinite scroll
function useInfiniteScroll(loadMore, hasMore) {
  const observerRef = useRef(null);
  const sentinelRef = useRef(null);

  useEffect(() => {
    if (!hasMore) return;

    observerRef.current = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          loadMore();
        }
      },
      {
        root: null,
        rootMargin: '200px',  // Preload before reaching bottom
        threshold: 0.1
      }
    );

    if (sentinelRef.current) {
      observerRef.current.observe(sentinelRef.current);
    }

    return () => observerRef.current?.disconnect();
  }, [loadMore, hasMore]);

  return sentinelRef;
}

// Pagination state
const POSTS_PER_PAGE = 20;

function useFeedPagination() {
  const [posts, setPosts] = useState([]);
  const [cursor, setCursor] = useState(null);
  const [hasMore, setHasMore] = useState(true);
  const [isLoading, setIsLoading] = useState(false);

  async function loadMore() {
    if (isLoading || !hasMore) return;

    setIsLoading(true);

    const { data, nextCursor } = await fetchFeedPage(cursor, POSTS_PER_PAGE);

    setPosts(prev => [...prev, ...data]);
    setCursor(nextCursor);
    setHasMore(data.length === POSTS_PER_PAGE);
    setIsLoading(false);
  }

  return { posts, loadMore, hasMore, isLoading };
}
```

#### FR-TL-004: Pull to Refresh

**Priority:** High
**Description:** The system SHALL support pull-to-refresh gesture to reload the feed.

**Specification:**
- Pull distance: 80px to trigger refresh
- Visual feedback: Loading spinner appears at top
- Haptic feedback on mobile when threshold crossed
- Timeout: 10 seconds max refresh time

#### FR-TL-005: Timeline Filters

**Priority:** Medium
**Description:** The system SHOULD allow filtering the timeline by various criteria.

**Filter Tabs:**

| Tab | Description |
|-----|-------------|
| **For You** | Algorithmically ranked (default) |
| **Nearby** | Pure distance-based, closest first |
| **Following** | Only from followed places |
| **Recent** | Pure chronological, newest first |

---

## 3.3 Post Creation (FR-POST)

### 3.3.1 Overview

Post creation allows users to add content anchored to their current location.

### 3.3.2 Requirements

#### FR-POST-001: Create Post Flow

**Priority:** Critical
**Description:** The system SHALL provide a multi-step flow for creating location-anchored posts.

**Creation Flow:**

```
Step 1: Location Confirmation
┌────────────────────────────────────────────────────┐
│                CREATE POST                     [X] │
├────────────────────────────────────────────────────┤
│                                                    │
│  ┌──────────────────────────────────────────────┐  │
│  │         [Mini Map Preview]                   │  │
│  │              📍 (You are here)               │  │
│  └──────────────────────────────────────────────┘  │
│                                                    │
│  📍 Current Location                               │
│  123 Main Street, San Francisco                    │
│  Accuracy: ±8 meters ✅                            │
│                                                    │
│  [ ] Add custom place name                         │
│                                                    │
│            [Continue →]                            │
└────────────────────────────────────────────────────┘

Step 2: Content Entry
┌────────────────────────────────────────────────────┐
│ [Cancel]        CREATE POST            [Post]      │
├────────────────────────────────────────────────────┤
│                                                    │
│  📍 123 Main Street · ±8m                         │
│                                                    │
│  ┌──────────────────────────────────────────────┐  │
│  │ What's happening here?                        │ │
│  │                                               │ │
│  │ _                                             │ │
│  │                                               │ │
│  │                                               │ │
│  └──────────────────────────────────────────────┘  │
│                                                280 │
│                                                    │
│  ┌────┐                                            │
│  │ +📷│  Add photo                                 │
│  └────┘                                            │
│                                                    │
│  ── AI Disclosure ──────────────────────           │
│  ⓘ Your post will be reviewed by AI for safety    │
│                                                    │
└────────────────────────────────────────────────────┘

Step 3: Photo Preview (if added)
┌────────────────────────────────────────────────────┐
│ [Back]          PREVIEW                  [Post]    │
├────────────────────────────────────────────────────┤
│                                                    │
│  ┌──────────────────────────────────────────────┐  │
│  │                                              │  │
│  │                [Photo]                       │  │
│  │                                              │  │
│  │    [Remove]  [Replace]                       │  │
│  └──────────────────────────────────────────────┘  │
│                                                    │
│  Amazing sunset from the pier today! 🌅            │
│                                                    │
│  📍 Pier 39, San Francisco                         │
│                                                    │
└────────────────────────────────────────────────────┘
```

#### FR-POST-002: Text Input

**Priority:** Critical
**Description:** The system SHALL accept text content with character limits.

**Specification:**

| Property | Value |
|----------|-------|
| Max characters | 500 |
| Min characters | 1 (if no media) |
| Emoji support | Full Unicode 15.0 |
| Link detection | Auto-linkify URLs |
| Mention support | @username (MVP: display only, no notification) |
| Hashtag support | #tag (MVP: display only, no aggregation) |

#### FR-POST-003: Photo Attachment

**Priority:** Critical
**Description:** The system SHALL allow attaching one photo per post.

**Photo Handling:**

```javascript
// Image processing pipeline
async function processPostImage(file) {
  // 1. Validate file type
  const validTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/heic'];
  if (!validTypes.includes(file.type)) {
    throw new Error('Unsupported image format');
  }

  // 2. Check file size (max 10MB raw)
  if (file.size > 10 * 1024 * 1024) {
    throw new Error('Image too large. Maximum size is 10MB.');
  }

  // 3. Strip EXIF data (privacy)
  const strippedImage = await stripExifData(file);

  // 4. Resize to max dimensions
  const resizedImage = await resizeImage(strippedImage, {
    maxWidth: 2048,
    maxHeight: 2048,
    quality: 0.85,
    format: 'webp'
  });

  // 5. Generate thumbnail
  const thumbnail = await resizeImage(strippedImage, {
    maxWidth: 400,
    maxHeight: 400,
    quality: 0.7,
    format: 'webp'
  });

  // 6. Run AI content moderation
  const moderationResult = await moderateImage(resizedImage);
  if (moderationResult.blocked) {
    throw new Error('Image violates content guidelines');
  }

  return {
    full: resizedImage,
    thumbnail: thumbnail,
    moderationScore: moderationResult.score
  };
}
```

**Storage Paths:**

```
cloudflare-r2://canvs-media/
├── posts/
│   ├── {year}/{month}/{day}/
│   │   ├── {post_id}_full.webp      # Full size (max 2048px)
│   │   └── {post_id}_thumb.webp     # Thumbnail (max 400px)
```

#### FR-POST-004: Location Anchoring

**Priority:** Critical
**Description:** The system SHALL anchor posts to the user's current GPS coordinates.

**Anchoring Logic:**

```javascript
// Create or find place anchor
async function anchorPost(userLocation, customName = null) {
  const { lat, lng, accuracy } = userLocation;

  // Generate H3 index at resolution 12 (~10m hexagons)
  const h3Index = h3.latLngToCell(lat, lng, 12);

  // Check for existing anchor in same hex
  const existingAnchor = await db.placeAnchors.findFirst({
    where: { h3_index_12: h3Index }
  });

  if (existingAnchor && !customName) {
    // Reuse existing anchor
    return existingAnchor.id;
  }

  // Create new anchor
  const newAnchor = await db.placeAnchors.create({
    data: {
      lat,
      lng,
      accuracy_meters: accuracy,
      h3_index_12: h3Index,
      h3_index_9: h3.latLngToCell(lat, lng, 9),   // ~150m for clustering
      h3_index_6: h3.latLngToCell(lat, lng, 6),   // ~3km for city-level
      custom_name: customName,
      created_at: new Date()
    }
  });

  return newAnchor.id;
}
```

#### FR-POST-005: Post Submission

**Priority:** Critical
**Description:** The system SHALL validate and submit posts with AI moderation.

**Submission Pipeline (Pseudo Code):**

```
FUNCTION submitPost(content, mediaFile, location, userId):
    // Validate user is authenticated
    IF NOT isAuthenticated(userId) THEN
        THROW AuthenticationError
    END IF

    // Validate location accuracy
    IF location.accuracy > 100 THEN
        THROW LocationError("Location too inaccurate for posting")
    END IF

    // Validate content length
    IF length(content) > 500 THEN
        THROW ValidationError("Content exceeds 500 characters")
    END IF

    IF length(content) < 1 AND mediaFile IS NULL THEN
        THROW ValidationError("Post must have text or media")
    END IF

    // Process media if present
    mediaUrls = NULL
    IF mediaFile IS NOT NULL THEN
        TRY
            processedMedia = await processPostImage(mediaFile)
            mediaUrls = await uploadToR2(processedMedia)
        CATCH error
            THROW MediaError(error.message)
        END TRY
    END IF

    // AI Content Moderation
    moderationResult = await moderateContent(content, mediaUrls)
    IF moderationResult.action == "block" THEN
        THROW ModerationError("Content violates guidelines")
    END IF

    // Create place anchor
    anchorId = await anchorPost(location)

    // Insert post
    post = await db.posts.create({
        user_id: userId,
        place_anchor_id: anchorId,
        content: content,
        media_url: mediaUrls?.full,
        media_thumbnail_url: mediaUrls?.thumbnail,
        moderation_score: moderationResult.score,
        moderation_flags: moderationResult.flags,
        is_hidden: moderationResult.action == "review",
        created_at: now()
    })

    // Trigger async tasks
    await queue.add('geocode_place', { anchorId })
    await queue.add('notify_followers', { placeId: anchorId, postId: post.id })

    RETURN post
```

---

## 3.4 Reactions and Comments (FR-REACT)

### 3.4.1 Requirements

#### FR-REACT-001: Emoji Reactions

**Priority:** High
**Description:** Users SHALL be able to react to posts with emoji.

**Supported Reaction Emojis:**

| Emoji | Meaning | Category |
|-------|---------|----------|
| ❤️ | Love | Positive |
| 👍 | Like | Positive |
| 😂 | Funny | Positive |
| 😮 | Wow | Neutral |
| 😢 | Sad | Empathetic |
| 📍 | Been here | Location |

**Reaction Logic:**

```javascript
// Toggle reaction
async function toggleReaction(postId, userId, emoji) {
  // Check if user already reacted with this emoji
  const existing = await db.reactions.findFirst({
    where: { post_id: postId, user_id: userId, emoji: emoji }
  });

  if (existing) {
    // Remove reaction
    await db.reactions.delete({ where: { id: existing.id } });
    await db.posts.update({
      where: { id: postId },
      data: { reaction_count: { decrement: 1 } }
    });
    return { action: 'removed' };
  } else {
    // Remove any other reaction by this user first
    await db.reactions.deleteMany({
      where: { post_id: postId, user_id: userId }
    });

    // Add new reaction
    await db.reactions.create({
      data: {
        post_id: postId,
        user_id: userId,
        emoji: emoji,
        created_at: new Date()
      }
    });

    // Update count (might be same if replacing)
    await updateReactionCount(postId);

    return { action: 'added', emoji };
  }
}
```

#### FR-REACT-002: Comments

**Priority:** High
**Description:** Users SHALL be able to comment on posts.

**Comment Specification:**

| Property | Value |
|----------|-------|
| Max length | 280 characters |
| Threading | Single level (replies to post only) |
| Editing | Not allowed in MVP |
| Deletion | By author or post owner |

**Comment Creation:**

```sql
-- Insert comment with moderation
INSERT INTO comments (
  id,
  post_id,
  user_id,
  content,
  moderation_score,
  is_hidden,
  created_at
)
VALUES (
  gen_random_uuid(),
  $1,  -- post_id
  $2,  -- user_id
  $3,  -- content
  $4,  -- moderation_score (from AI)
  $5,  -- is_hidden (true if flagged)
  NOW()
)
RETURNING *;

-- Update comment count on post
UPDATE posts
SET comment_count = comment_count + 1
WHERE id = $1;
```

---

## 3.5 AI Features (FR-AI)

### 3.5.1 Reality Filter

#### FR-AI-001: Content Filtering

**Priority:** High
**Description:** The system SHALL provide AI-powered content filtering based on user preferences.

**Reality Filter Levels:**

| Level | Name | Description | Default For |
|-------|------|-------------|-------------|
| 0 | Unfiltered | All content visible | Opted-in adults |
| 25 | Light | Hide extreme negativity | Default |
| 50 | Moderate | Family-friendly content | Under 18 |
| 75 | Curated | Positive vibes only | Sensitive users |
| 100 | Zen | Only nature/art content | Meditation mode |

**Filter Implementation:**

```javascript
// Reality Filter scoring
async function applyRealityFilter(posts, filterLevel) {
  // Get filter threshold from level
  const threshold = calculateThreshold(filterLevel);

  // Filter posts based on moderation scores
  const filteredPosts = posts.filter(post => {
    // Always show if below threshold
    if (post.moderation_score < threshold.negativity) return true;

    // Check specific category scores
    const categories = JSON.parse(post.moderation_flags);

    if (filterLevel >= 50) {
      // Moderate: Hide mature content
      if (categories.sexual > 0.1) return false;
      if (categories.violence > 0.3) return false;
    }

    if (filterLevel >= 75) {
      // Curated: Only positive
      if (categories.negativity > 0.2) return false;
      if (categories.controversy > 0.3) return false;
    }

    return true;
  });

  return filteredPosts;
}
```

#### FR-AI-002: Content Moderation

**Priority:** Critical
**Description:** The system SHALL automatically moderate all user-generated content using AI.

**Moderation Pipeline:**

```
┌─────────────────────────────────────────────────────────────┐
│                   CONTENT MODERATION PIPELINE               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  User Submits Content                                       │
│          │                                                  │
│          ▼                                                  │
│  ┌───────────────────────────────────────────┐              │
│  │ 1. Text Moderation (OpenAI Moderation)    │              │
│  │    - Hate speech detection                │              │
│  │    - Violence detection                   │              │
│  │    - Sexual content detection             │              │
│  │    - Self-harm detection                  │              │
│  └───────────────────────────────────────────┘              │
│          │                                                  │
│          ▼                                                  │
│  ┌───────────────────────────────────────────┐              │
│  │ 2. Image Moderation (if media present)    │              │
│  │    - NSFW detection                       │              │
│  │    - Violence/gore detection              │              │
│  │    - Face detection (privacy)             │              │
│  └───────────────────────────────────────────┘              │
│          │                                                  │
│          ▼                                                  │
│  ┌───────────────────────────────────────────┐              │
│  │ 3. Spatial Context Check                  │              │
│  │    - Is content appropriate for location? │              │
│  │    - School zones: stricter filtering     │              │
│  │    - Public parks: family-friendly        │              │
│  └───────────────────────────────────────────┘              │
│          │                                                  │
│          ▼                                                  │
│  ┌─────────────┬─────────────┬─────────────┐                │
│  │   APPROVE   │   REVIEW    │   BLOCK     │                │
│  │  Score<0.3  │  0.3-0.7    │  Score>0.7  │                │
│  │             │             │             │                │
│  │  Publish    │  Queue for  │  Reject +   │                │
│  │  immediately│  human      │  notify     │                │
│  │             │  review     │  user       │                │
│  └─────────────┴─────────────┴─────────────┘                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Moderation API Call:**

```javascript
// OpenAI Moderation API integration
async function moderateContent(text, imageUrl = null) {
  const results = {
    score: 0,
    flags: {},
    action: 'approve'
  };

  // Text moderation
  if (text) {
    const textMod = await openai.moderations.create({
      input: text
    });

    const categories = textMod.results[0].category_scores;
    results.flags.text = categories;

    // Calculate combined text score
    results.score = Math.max(
      categories.hate * 1.5,
      categories.harassment * 1.2,
      categories.violence * 1.3,
      categories.sexual * 1.4,
      categories['self-harm'] * 2.0
    );
  }

  // Image moderation
  if (imageUrl) {
    const imageMod = await openai.chat.completions.create({
      model: 'gpt-4o',
      messages: [{
        role: 'user',
        content: [
          { type: 'text', text: 'Analyze this image for content moderation. Rate each category 0-1: violence, sexual, hate_symbols, drugs, dangerous. Respond as JSON only.' },
          { type: 'image_url', image_url: { url: imageUrl } }
        ]
      }],
      max_tokens: 200
    });

    const imageScores = JSON.parse(imageMod.choices[0].message.content);
    results.flags.image = imageScores;

    results.score = Math.max(results.score, ...Object.values(imageScores));
  }

  // Determine action
  if (results.score > 0.7) {
    results.action = 'block';
  } else if (results.score > 0.3) {
    results.action = 'review';
  }

  return results;
}
```

#### FR-AI-003: Semantic Search

**Priority:** Medium
**Description:** The system SHOULD support natural language search for discovering content.

**Search Implementation:**

```javascript
// Semantic search using embeddings
async function semanticSearch(query, userLocation, limit = 20) {
  // 1. Generate query embedding
  const embedding = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: query
  });

  // 2. Search vector database
  const results = await db.$queryRaw`
    SELECT
      p.*,
      pa.lat,
      pa.lng,
      1 - (p.embedding <=> ${embedding.data[0].embedding}::vector) as similarity,
      ST_Distance(
        ST_SetSRID(ST_MakePoint(pa.lng, pa.lat), 4326)::geography,
        ST_SetSRID(ST_MakePoint(${userLocation.lng}, ${userLocation.lat}), 4326)::geography
      ) as distance_meters
    FROM posts p
    JOIN place_anchors pa ON p.place_anchor_id = pa.id
    WHERE
      p.is_deleted = false
      AND p.embedding IS NOT NULL
    ORDER BY
      (1 - (p.embedding <=> ${embedding.data[0].embedding}::vector)) *
      EXP(-ST_Distance(...) / 5000)
      DESC
    LIMIT ${limit}
  `;

  return results;
}
```

---

## 3.6 User Profile (FR-PROF)

### 3.6.1 Requirements

#### FR-PROF-001: Profile Display

**Priority:** High
**Description:** The system SHALL display user profile information.

**Profile Layout:**

```
┌────────────────────────────────────────────────────┐
│                                                    │
│  ┌──────────┐                                      │
│  │          │  @johndoe                            │
│  │  Avatar  │  John Doe                            │
│  │   120px  │  ✅ Verified                         │
│  └──────────┘                                      │
│                                                    │
│  San Francisco, CA · Joined Dec 2024               │
│                                                    │
│  Exploring the city one pin at a time 📍           │
│                                                    │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐             │
│  │   42    │  │   18    │  │   156   │             │
│  │  Posts  │  │Following│  │Followers│             │
│  └─────────┘  └─────────┘  └─────────┘             │
│                                                    │
│  [Edit Profile]  [Share]                           │
│                                                    │
├────────────────────────────────────────────────────┤
│ [Posts]  [Places]  [Reactions]                     │
├────────────────────────────────────────────────────┤
│                                                    │
│  ┌───────────────────────────────────────────┐     │
│  │ User's posts in grid or list view         │     │
│  └───────────────────────────────────────────┘     │
│                                                    │
└────────────────────────────────────────────────────┘
```

#### FR-PROF-002: Profile Editing

**Priority:** High
**Description:** Users SHALL be able to edit their profile information.

**Editable Fields:**

| Field | Max Length | Validation |
|-------|------------|------------|
| Display Name | 50 chars | Alphanumeric + spaces |
| Username | 30 chars | Lowercase, alphanumeric, underscores |
| Bio | 160 chars | Free text |
| Avatar | N/A | Image, max 5MB |
| Location | 100 chars | Optional, free text |

---

> [Next: User Interface Specifications →](./04-user-interface-specifications.md)
