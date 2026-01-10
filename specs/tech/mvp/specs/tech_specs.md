# CANVS MVP Technical Specifications

**Version:** 1.0.0
**Last Updated:** January 2026
**Status:** Planning

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Architecture Overview](#2-architecture-overview)
3. [Frontend Technology Stack](#3-frontend-technology-stack)
4. [Backend Technology Stack](#4-backend-technology-stack)
5. [Geolocation System](#5-geolocation-system)
6. [Mapping & Visualization](#6-mapping--visualization)
7. [Spatial Database & Indexing](#7-spatial-database--indexing)
8. [Media Handling](#8-media-handling)
9. [Authentication System](#9-authentication-system)
10. [Push Notifications](#10-push-notifications)
11. [Content Moderation](#11-content-moderation)
12. [Security & Anti-Spoofing](#12-security--anti-spoofing)
13. [MVP v2: Vision Anchoring Technologies](#13-mvp-v2-vision-anchoring-technologies)
14. [Infrastructure & Deployment](#14-infrastructure--deployment)
15. [API Design](#15-api-design)
16. [Integration Summary](#16-integration-summary)
17. [Risk Assessment & Mitigations](#17-risk-assessment--mitigations)
18. [Next Steps & Future Considerations](#18-next-steps--future-considerations)

---

## 1. Executive Summary

### 1.1 Purpose

This document provides comprehensive technical specifications for building the CANVS Minimum Viable Product (MVP). CANVS is a location-anchored social platform that enables users to leave, discover, and interact with content attached to physical places.

### 1.2 MVP Scope

**MVP v1 (GPS-only, Mobile Web):**
- Progressive Web App (PWA) accessible via mobile browsers
- GPS-based location anchoring with accuracy handling
- Core features: create pins, capsules, discover nearby content, share links
- Location-based content unlocking mechanism

**MVP v2 (Vision-anchored precision):**
- Enhanced positioning using Visual Positioning Systems (VPS)
- Sub-meter accuracy in supported areas
- Transition path toward full spatial computing

### 1.3 Key Technical Decisions Summary

| Component | Recommended Technology | Rationale |
|-----------|----------------------|-----------|
| Frontend Framework | Next.js 15 + React | Official PWA support, SSR, performance |
| Mapping Library | MapLibre GL JS | Open-source, vector tiles, GPU-accelerated |
| Database | PostgreSQL + PostGIS | Proven spatial queries, enterprise-grade |
| Spatial Index | H3 + PostGIS GiST | Fast queries, privacy-friendly bucketing |
| Object Storage | Cloudflare R2 | Zero egress fees, global CDN |
| Authentication | Supabase Auth | Magic links, OTP, integrated with PostgreSQL |
| Backend Runtime | Supabase + Edge Functions | Real-time capabilities, serverless |

---

## 2. Architecture Overview

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                                 │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              Next.js PWA (React + TypeScript)                │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐   │   │
│  │  │Geolocation│ │  MapLibre│ │  Media   │ │Service Worker│   │   │
│  │  │   API    │ │  GL JS   │ │ Capture  │ │   + Cache    │   │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   │ HTTPS
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         API LAYER                                    │
│  ┌────────────────────────────────────────────────────────────────┐│
│  │                    Supabase Backend                             ││
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐  ││
│  │  │  REST    │ │ Realtime │ │   Auth   │ │  Edge Functions  │  ││
│  │  │   API    │ │WebSocket │ │ (Magic)  │ │  (Moderation)    │  ││
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────────┘  ││
│  └────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                                   │
│  ┌───────────────────┐  ┌───────────────────┐  ┌─────────────────┐ │
│  │ PostgreSQL+PostGIS│  │  Cloudflare R2    │  │    External     │ │
│  │   + H3 Extension  │  │  (Media Storage)  │  │     APIs        │ │
│  │                   │  │                   │  │ ┌─────────────┐ │ │
│  │ • Users           │  │ • Images (WebP)   │  │ │ Nominatim   │ │ │
│  │ • PlaceAnchors    │  │ • Audio (Opus)    │  │ │ OpenAI Mod  │ │ │
│  │ • Posts           │  │ • Thumbnails      │  │ │ Push (VAPID)│ │ │
│  │ • Capsules        │  │                   │  │ └─────────────┘ │ │
│  └───────────────────┘  └───────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Data Flow Overview

1. **Content Creation Flow:**
   ```
   User taps "Create" → Geolocation API captures position + accuracy →
   User adds text/media → Client compresses media → Upload to R2 →
   Store anchor + post in PostgreSQL → Return shareable URL
   ```

2. **Content Discovery Flow:**
   ```
   User opens app → Geolocation API gets position → Query PostgreSQL
   (ST_DWithin + H3 cell) → Filter by unlock radius → Return nearby
   content → Render on MapLibre + list view
   ```

3. **Content Unlock Flow:**
   ```
   User approaches location → Continuous position updates → Calculate
   distance to anchor → When distance < unlock_radius → Reveal full
   content → Track unlock event
   ```

---

## 3. Frontend Technology Stack

### 3.1 Framework: Next.js 15 with React

**Why Next.js:**
- Official PWA support added in late 2024 without external dependencies ([Next.js Docs](https://nextjs.org/docs/app/guides/progressive-web-apps))
- Server-side rendering improves initial load and SEO for shared links
- Built-in code splitting and performance optimizations
- React ecosystem provides extensive component libraries
- TypeScript support out of the box

**Configuration:**
```typescript
// next.config.js
const withPWA = require('next-pwa')({
  dest: 'public',
  register: true,
  skipWaiting: true,
  runtimeCaching: [
    {
      urlPattern: /^https:\/\/api\.canvs\.app\/.*/,
      handler: 'NetworkFirst',
      options: {
        cacheName: 'api-cache',
        expiration: { maxEntries: 50, maxAgeSeconds: 300 }
      }
    },
    {
      urlPattern: /^https:\/\/tiles\..*\/.*/,
      handler: 'CacheFirst',
      options: {
        cacheName: 'map-tiles',
        expiration: { maxEntries: 500, maxAgeSeconds: 86400 }
      }
    }
  ]
});

module.exports = withPWA({
  // Next.js config
});
```

**Challenges:**
- Service worker debugging requires understanding of caching strategies
- PWA install prompts vary by browser/OS
- iOS Safari has specific PWA limitations (no background sync)

**Limitations:**
- No true background location tracking in PWA (must be open)
- Limited access to some native features compared to native apps

### 3.2 Service Worker & Caching Strategy

**Caching Strategies by Content Type:**

| Content Type | Strategy | Rationale |
|-------------|----------|-----------|
| Static assets (JS/CSS) | Cache First | Versioned, rarely changes |
| Map tiles | Cache First | Large, expensive to re-fetch |
| API responses | Network First | Freshness important |
| Media (images/audio) | Stale While Revalidate | Balance freshness + speed |
| Offline fallback | Cache Only | Show custom offline page |

**Implementation with Serwist (Workbox successor):**
```typescript
// sw.ts
import { defaultCache } from '@serwist/next/browser';
import { Serwist } from 'serwist';

const serwist = new Serwist({
  precacheEntries: self.__SW_MANIFEST,
  skipWaiting: true,
  clientsClaim: true,
  navigationPreload: true,
  runtimeCaching: defaultCache
});

serwist.addEventListeners();
```

**Best Practices (2025-2026):**
- Implement versioning for service workers ([MDN Best Practices](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Best_practices))
- Set practical storage limits and expiration policies
- Provide custom offline page for connection loss scenarios
- Use IndexedDB for structured offline data (pending posts queue)

### 3.3 PWA Manifest Configuration

```json
{
  "name": "CANVS - Leave Your Mark",
  "short_name": "CANVS",
  "description": "Discover and leave location-anchored memories",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#000000",
  "theme_color": "#6366F1",
  "orientation": "portrait",
  "icons": [
    { "src": "/icons/192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/icons/maskable.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ],
  "permissions": ["geolocation"]
}
```

**Critical for iOS:** The `"display": "standalone"` is **required** for Web Push to work on iOS 16.4+ ([WebKit Blog](https://webkit.org/blog/13878/web-push-for-web-apps-on-ios-and-ipados/)).

### 3.4 UI Framework Recommendation

**Tailwind CSS + Radix UI Primitives:**
- Tailwind: Utility-first, minimal bundle size, mobile-first by default
- Radix UI: Accessible, unstyled primitives for complex components
- Combined: Fast development, consistent design, accessible

**Alternative:** shadcn/ui (Tailwind + Radix components pre-built)

---

## 4. Backend Technology Stack

### 4.1 Primary Backend: Supabase

**Why Supabase:**
- Open-source Firebase alternative built on PostgreSQL
- Native PostGIS support for spatial queries ([Supabase PostGIS Docs](https://supabase.com/docs/guides/database/extensions/postgis))
- Real-time subscriptions via WebSocket for live updates
- Built-in authentication with magic links
- Edge Functions for serverless compute
- Row Level Security (RLS) for fine-grained access control

**Architecture:**
```
Supabase Project
├── Database (PostgreSQL 15)
│   ├── PostGIS extension
│   ├── H3 extension (pg_h3)
│   └── pgvector (future: semantic search)
├── Auth
│   ├── Magic link (email)
│   ├── OTP (phone)
│   └── Social providers (future)
├── Storage (for smaller files)
├── Realtime (WebSocket)
└── Edge Functions (Deno)
```

**Real-time Capabilities:**
```typescript
// Subscribe to nearby content updates
const subscription = supabase
  .channel('nearby-posts')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'posts',
      filter: `h3_cell_res8=eq.${userH3Cell}`
    },
    (payload) => {
      // Handle new post in user's area
    }
  )
  .subscribe();
```

**Challenges:**
- Vendor lock-in (mitigated by open-source, self-hostable)
- Edge Function cold starts (~200-500ms)
- Real-time connections count against plan limits

### 4.2 API Design Philosophy

**REST vs GraphQL Decision:**

For MVP v1, **REST with Supabase auto-generated API** is recommended:
- Faster to implement
- Supabase auto-generates REST endpoints from tables
- PostgREST provides filtering, pagination, embedding
- GraphQL can be added later via PostGraphile if needed

**API Structure:**
```
/rest/v1/
├── users
├── place_anchors
│   └── ?lat=40.7&lon=-74.0&radius=500 (custom RPC)
├── posts
├── capsules
├── reactions
├── comments
└── reports
```

### 4.3 Edge Functions (Serverless)

**Use Cases:**
1. **Content Moderation Pipeline:**
   ```typescript
   // supabase/functions/moderate-content/index.ts
   import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
   import OpenAI from 'openai';

   serve(async (req) => {
     const { text, imageUrl } = await req.json();

     const openai = new OpenAI();
     const moderation = await openai.moderations.create({
       model: 'omni-moderation-latest',
       input: [
         { type: 'text', text },
         { type: 'image_url', image_url: { url: imageUrl } }
       ]
     });

     return new Response(JSON.stringify({
       flagged: moderation.results[0].flagged,
       categories: moderation.results[0].categories
     }));
   });
   ```

2. **Reverse Geocoding Proxy:**
   ```typescript
   // Cache Nominatim responses, rate-limit, fallback
   ```

3. **Push Notification Dispatch:**
   ```typescript
   // VAPID-signed Web Push to subscribed devices
   ```

---

## 5. Geolocation System

### 5.1 Browser Geolocation API

**Core API Usage:**
```typescript
interface GeolocationPosition {
  coords: {
    latitude: number;      // Degrees
    longitude: number;     // Degrees
    accuracy: number;      // Meters (95% confidence)
    altitude?: number;     // Meters
    altitudeAccuracy?: number;
    heading?: number;      // Degrees from north
    speed?: number;        // m/s
  };
  timestamp: number;       // Unix timestamp
}

// Get current position with high accuracy
navigator.geolocation.getCurrentPosition(
  (position) => handlePosition(position),
  (error) => handleError(error),
  {
    enableHighAccuracy: true,  // Use GPS over WiFi
    timeout: 10000,            // 10 second timeout
    maximumAge: 0              // Fresh reading required
  }
);

// Watch position for continuous updates
const watchId = navigator.geolocation.watchPosition(
  (position) => handlePosition(position),
  (error) => handleError(error),
  {
    enableHighAccuracy: true,
    timeout: 15000,
    maximumAge: 5000  // Accept 5-second-old readings
  }
);
```

**API Requirements:**
- **HTTPS required:** Geolocation API only works in secure contexts ([MDN](https://developer.mozilla.org/docs/Web/API/Geolocation_API))
- **User permission required:** Browser prompts user; denial should gracefully degrade

### 5.2 Accuracy Characteristics & Handling

**Typical Accuracy by Environment:**

| Environment | Typical Accuracy | Primary Source |
|------------|-----------------|----------------|
| Open outdoor | 3-10m | GPS |
| Urban street | 10-30m | GPS + WiFi |
| Dense urban (canyon) | 30-100m | WiFi + Cell + GPS multipath |
| Indoor | 20-50m | WiFi triangulation |
| Indoor no WiFi | 100m+ | Cell tower only |

**Urban Canyon Problem:**
> "Tall buildings and narrow streets can obstruct signals and cause multipath interference, where signals bounce off structures and lead to errors. This phenomenon, known as 'urban canyon' effect, can significantly degrade GPS precision in cities." ([GPS Accuracy Article](https://www.taoglas.com/blogs/precision-matters-exploring-the-importance-of-gps-precision-accuracy/))

**Implementation Strategy:**

```typescript
// AccuracyAwareLocation.ts
interface LocationState {
  position: GeolocationPosition | null;
  accuracyTier: 'excellent' | 'good' | 'fair' | 'poor';
  canPost: boolean;
  canUnlock: boolean;
}

function classifyAccuracy(meters: number): LocationState['accuracyTier'] {
  if (meters <= 10) return 'excellent';
  if (meters <= 25) return 'good';
  if (meters <= 50) return 'fair';
  return 'poor';
}

function calculateLocationState(position: GeolocationPosition): LocationState {
  const accuracy = position.coords.accuracy;
  const tier = classifyAccuracy(accuracy);

  return {
    position,
    accuracyTier: tier,
    canPost: accuracy <= 50,    // Only allow posting with ≤50m accuracy
    canUnlock: accuracy <= 100  // Allow unlock attempts with ≤100m
  };
}
```

**UI Treatment:**
- Always display accuracy circle on map (visual honesty)
- Show accuracy badge: "±18m" or "±45m (approximate)"
- Disable create button when accuracy > threshold
- Provide tips: "Move outside for better accuracy"

### 5.3 GPS Drift Mitigation

**Strategies:**

1. **Kalman Filtering (Advanced):**
   ```typescript
   // Smooth position over time, reduce jitter
   // Implementation: kalman-filter npm package
   ```

2. **Stationary Detection:**
   ```typescript
   // If speed ≈ 0 and positions vary wildly, user is stationary
   // Use time-weighted average of recent readings
   ```

3. **Allow Manual Pin Adjustment:**
   ```typescript
   // Let user drag pin within ±accuracy_radius on map
   // This builds trust when GPS is imperfect
   ```

### 5.4 Emerging Technologies (GPS L5)

> "New signals like GPS L5 reduce multipath interference for better urban accuracy."

**Status (2025-2026):**
- GPS L5 band available on newer smartphones (iPhone 12+, Pixel 5+)
- Browser Geolocation API automatically benefits if device supports it
- No code changes needed; accuracy simply improves on capable devices

---

## 6. Mapping & Visualization

### 6.1 MapLibre GL JS (Recommended)

**Why MapLibre GL JS:**
- Open-source fork of Mapbox GL JS (BSD license)
- GPU-accelerated vector tile rendering via WebGL
- Smaller bundle than alternatives for large datasets
- Active community, growing adoption ([Geoapify Comparison](https://www.geoapify.com/map-libraries-comparison-leaflet-vs-maplibre-gl-vs-openlayers-trends-and-statistics/))
- Smooth rotation, pitch, and 3D terrain support

**Performance Characteristics (2025 Research):**
> "For large datasets MapLibre is faster due to its usage of WebGL technology." ([Jawg Blog](https://blog.jawg.io/maplibre-gl-vs-leaflet-choosing-the-right-tool-for-your-interactive-map/))
> "For 50,000 or more [features], Mapbox GL JS rendered them the quickest, followed by OpenLayers, MapLibre GL JS and Leaflet." ([MDPI Study](https://www.mdpi.com/2220-9964/14/9/336))

**Basic Setup:**
```typescript
import maplibregl from 'maplibre-gl';
import 'maplibre-gl/dist/maplibre-gl.css';

const map = new maplibregl.Map({
  container: 'map',
  style: 'https://api.maptiler.com/maps/streets-v2/style.json?key=YOUR_KEY',
  center: [userLng, userLat],
  zoom: 15,
  pitch: 0,
  attributionControl: false
});

// Add user location with accuracy circle
map.on('load', () => {
  // Accuracy circle (GeoJSON circle polygon)
  map.addSource('accuracy-circle', {
    type: 'geojson',
    data: createCircleGeoJSON(userLng, userLat, accuracyMeters)
  });

  map.addLayer({
    id: 'accuracy-fill',
    type: 'fill',
    source: 'accuracy-circle',
    paint: {
      'fill-color': '#6366F1',
      'fill-opacity': 0.15
    }
  });

  // User dot
  new maplibregl.Marker({ color: '#6366F1' })
    .setLngLat([userLng, userLat])
    .addTo(map);
});
```

### 6.2 Map Tile Sources

**Options:**

| Provider | Free Tier | Pricing | Features |
|----------|-----------|---------|----------|
| MapTiler | 100k req/mo | $0.20/1k | High quality, good docs |
| Stadia Maps | 200k req/mo | $0.04/1k | Cost effective |
| OpenMapTiles (self-host) | Unlimited | Server cost | Full control |
| Protomaps | Custom | S3 cost | Single PMTiles file |

**Recommendation:** Start with MapTiler free tier, migrate to Protomaps (self-hosted PMTiles on R2) as traffic grows.

**PMTiles Approach:**
```typescript
// Single file contains all tiles, hosted on CDN
import { PMTiles, Protocol } from 'pmtiles';
import maplibregl from 'maplibre-gl';

const protocol = new Protocol();
maplibregl.addProtocol('pmtiles', protocol.tile);

const map = new maplibregl.Map({
  style: {
    sources: {
      'canvs-base': {
        type: 'vector',
        url: 'pmtiles://https://r2.canvs.app/tiles/planet.pmtiles'
      }
    },
    // ... layer definitions
  }
});
```

### 6.3 Pin Clustering

For areas with many pins, clustering prevents visual overload:

```typescript
map.addSource('posts', {
  type: 'geojson',
  data: postsGeoJSON,
  cluster: true,
  clusterMaxZoom: 14,
  clusterRadius: 50
});

// Cluster circles
map.addLayer({
  id: 'clusters',
  type: 'circle',
  source: 'posts',
  filter: ['has', 'point_count'],
  paint: {
    'circle-color': '#6366F1',
    'circle-radius': ['step', ['get', 'point_count'], 20, 10, 30, 50, 40]
  }
});

// Individual pins
map.addLayer({
  id: 'unclustered-pin',
  type: 'symbol',
  source: 'posts',
  filter: ['!', ['has', 'point_count']],
  layout: {
    'icon-image': 'pin-{category}',
    'icon-size': 0.8
  }
});
```

### 6.4 Alternative: Leaflet (Simpler)

If MapLibre proves too complex for MVP timeline:

```typescript
import L from 'leaflet';

const map = L.map('map').setView([userLat, userLng], 15);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  attribution: '© OSM contributors'
}).addTo(map);

// Accuracy circle
L.circle([userLat, userLng], {
  radius: accuracyMeters,
  fillColor: '#6366F1',
  fillOpacity: 0.15,
  stroke: false
}).addTo(map);
```

**Leaflet Pros:** Simpler API, smaller learning curve, excellent for ≤10k markers
**Leaflet Cons:** Raster tiles only (larger), no WebGL acceleration, less smooth on mobile

---

## 7. Spatial Database & Indexing

### 7.1 PostgreSQL with PostGIS

**Why PostgreSQL + PostGIS:**
- Industry standard for spatial data
- ACID compliance, enterprise reliability
- PostGIS provides geometry types, spatial indexes, distance functions
- Excellent query optimization
- Native support in Supabase

**Enable PostGIS in Supabase:**
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
```

### 7.2 Schema Design

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE,
  phone TEXT,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  trust_score DECIMAL(3,2) DEFAULT 0.50,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Place anchors (location-only, decoupled from content)
CREATE TABLE place_anchors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Precise location (internal use)
  location GEOGRAPHY(POINT, 4326) NOT NULL,

  -- Accuracy at creation time
  accuracy_m DECIMAL(8,2) NOT NULL,

  -- H3 cells for fast nearby queries
  h3_cell_res8 TEXT NOT NULL,   -- ~460m hexagon
  h3_cell_res9 TEXT NOT NULL,   -- ~174m hexagon
  h3_cell_res10 TEXT NOT NULL,  -- ~66m hexagon

  -- Unlock radius for this anchor
  unlock_radius_m INTEGER DEFAULT 75,

  -- Optional venue association
  venue_id TEXT,
  venue_name TEXT,

  -- Privacy: publicly visible location (can be snapped/blurred)
  display_location GEOGRAPHY(POINT, 4326),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES users(id)
);

-- Posts (pins and capsule entries)
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  anchor_id UUID NOT NULL REFERENCES place_anchors(id),
  author_id UUID NOT NULL REFERENCES users(id),

  -- Content
  post_type TEXT NOT NULL CHECK (post_type IN ('pin', 'capsule_entry')),
  category TEXT NOT NULL CHECK (category IN ('memory', 'utility', 'culture')),
  text_content TEXT,

  -- Media references (stored in R2)
  media JSONB DEFAULT '[]',
  -- Example: [{"type": "image", "url": "...", "thumbnail_url": "..."}]

  -- Visibility
  audience TEXT DEFAULT 'nearby' CHECK (audience IN ('private', 'invited', 'nearby', 'public')),

  -- Capsule association
  capsule_id UUID REFERENCES capsules(id),

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,

  -- Moderation
  is_flagged BOOLEAN DEFAULT FALSE,
  moderation_status TEXT DEFAULT 'approved'
);

-- Capsules (containers for multiple entries)
CREATE TABLE capsules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  anchor_id UUID NOT NULL REFERENCES place_anchors(id),
  owner_id UUID NOT NULL REFERENCES users(id),

  title TEXT NOT NULL,
  description TEXT,

  -- Contributors
  contributors UUID[] DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reactions
CREATE TABLE reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  reaction_type TEXT NOT NULL CHECK (reaction_type IN ('love', 'wow', 'sad', 'laugh', 'fire')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(post_id, user_id)  -- One reaction per user per post
);

-- Comments
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES users(id),
  parent_id UUID REFERENCES comments(id),  -- For threading

  text_content TEXT,
  audio_url TEXT,  -- Voice reply

  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_flagged BOOLEAN DEFAULT FALSE
);

-- Content reports
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_id UUID NOT NULL REFERENCES users(id),
  content_type TEXT NOT NULL CHECK (content_type IN ('post', 'comment', 'user')),
  content_id UUID NOT NULL,
  reason TEXT NOT NULL,
  details TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'actioned', 'dismissed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User blocks
CREATE TABLE user_blocks (
  blocker_id UUID NOT NULL REFERENCES users(id),
  blocked_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (blocker_id, blocked_id)
);

-- Push subscriptions
CREATE TABLE push_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  subscription JSONB NOT NULL,  -- Web Push subscription object
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_used_at TIMESTAMPTZ
);
```

### 7.3 Spatial Indexes

**Critical for Performance:**

```sql
-- GiST index on geography columns (PostGIS)
CREATE INDEX idx_place_anchors_location
ON place_anchors USING GIST (location);

-- B-tree indexes on H3 cells (for equality lookups)
CREATE INDEX idx_place_anchors_h3_res8 ON place_anchors (h3_cell_res8);
CREATE INDEX idx_place_anchors_h3_res9 ON place_anchors (h3_cell_res9);
CREATE INDEX idx_place_anchors_h3_res10 ON place_anchors (h3_cell_res10);

-- Compound index for common query pattern
CREATE INDEX idx_posts_anchor_created
ON posts (anchor_id, created_at DESC);

-- After creating indexes, analyze tables
ANALYZE place_anchors;
ANALYZE posts;
```

**Important:** Always run `VACUUM ANALYZE` after bulk inserts to ensure the query planner uses indexes effectively ([PostGIS Optimization](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830)).

### 7.4 Nearby Query Optimization

**ST_DWithin Approach:**

```sql
-- Find posts within 500m of user
-- ST_DWithin uses spatial index automatically
SELECT p.*, pa.location, pa.unlock_radius_m,
       ST_Distance(pa.location, ST_MakePoint($1, $2)::geography) as distance_m
FROM posts p
JOIN place_anchors pa ON p.anchor_id = pa.id
WHERE ST_DWithin(
  pa.location,
  ST_MakePoint($1, $2)::geography,  -- User's lon, lat
  500  -- 500 meters
)
AND p.audience IN ('nearby', 'public')
AND p.is_flagged = FALSE
ORDER BY distance_m ASC
LIMIT 50;
```

**H3 + ST_DWithin Hybrid (Faster for Large Scale):**

```sql
-- First filter by H3 cell (fast B-tree lookup)
-- Then refine with ST_DWithin
WITH nearby_cells AS (
  -- Get H3 cells within radius using h3_grid_disk
  SELECT h3_cell_to_children(
    h3_lat_lng_to_cell($1, $2, 8),  -- User position at res 8
    8
  ) AS cell
  UNION
  SELECT unnest(h3_grid_disk(
    h3_lat_lng_to_cell($1, $2, 8),
    1  -- Include neighboring cells
  ))
)
SELECT p.*, pa.location,
       ST_Distance(pa.location, ST_MakePoint($2, $1)::geography) as distance_m
FROM posts p
JOIN place_anchors pa ON p.anchor_id = pa.id
WHERE pa.h3_cell_res8 IN (SELECT cell FROM nearby_cells)
  AND ST_DWithin(pa.location, ST_MakePoint($2, $1)::geography, 500)
ORDER BY distance_m ASC
LIMIT 50;
```

### 7.5 H3 Hexagonal Indexing

**Why H3:**
- Uber's open-source hexagonal spatial index ([H3 Docs](https://h3geo.org/docs/))
- Hexagons have uniform neighbor distances (unlike square grids)
- Hierarchical: each cell contains 7 child cells
- Fast cell lookups and neighbor calculations
- Privacy-friendly: snap locations to cell centers

> "Query time went from 543 seconds to 1 second" using H3 indexes ([RustProof Labs](https://blog.rustprooflabs.com/2022/06/h3-indexes-on-postgis-data))

**Resolution Guide:**

| Resolution | Avg Hexagon Edge | Area | Use Case |
|------------|-----------------|------|----------|
| 8 | ~461m | 0.74 km² | Regional discovery |
| 9 | ~174m | 0.10 km² | Neighborhood level |
| 10 | ~66m | 0.015 km² | Street level |
| 11 | ~25m | 0.002 km² | Precise unlock zones |

**PostgreSQL H3 Functions:**
```sql
-- Enable H3 extension
CREATE EXTENSION IF NOT EXISTS h3;

-- Get H3 cell from lat/lng
SELECT h3_lat_lng_to_cell(40.7128, -74.0060, 9);
-- Returns: '892a100d2c3ffff'

-- Get cell center (for display)
SELECT h3_cell_to_lat_lng('892a100d2c3ffff');

-- Get neighboring cells (for nearby queries)
SELECT h3_grid_disk('892a100d2c3ffff', 1);

-- Trigger to auto-populate H3 cells on insert
CREATE OR REPLACE FUNCTION set_h3_cells()
RETURNS TRIGGER AS $$
BEGIN
  NEW.h3_cell_res8 := h3_lat_lng_to_cell(
    ST_Y(NEW.location::geometry),
    ST_X(NEW.location::geometry),
    8
  );
  NEW.h3_cell_res9 := h3_lat_lng_to_cell(
    ST_Y(NEW.location::geometry),
    ST_X(NEW.location::geometry),
    9
  );
  NEW.h3_cell_res10 := h3_lat_lng_to_cell(
    ST_Y(NEW.location::geometry),
    ST_X(NEW.location::geometry),
    10
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER place_anchors_h3_trigger
BEFORE INSERT OR UPDATE ON place_anchors
FOR EACH ROW EXECUTE FUNCTION set_h3_cells();
```

### 7.6 Privacy-Preserving Location Display

**Strategy:** Store precise location internally, display snapped/blurred location publicly.

```sql
-- When creating anchor, set display_location to H3 cell center
UPDATE place_anchors
SET display_location = ST_SetSRID(
  ST_MakePoint(
    (h3_cell_to_lat_lng(h3_cell_res9))[2],  -- lng
    (h3_cell_to_lat_lng(h3_cell_res9))[1]   -- lat
  ),
  4326
)::geography
WHERE id = $1;
```

**Result:** Locations shared publicly are ~174m resolution (res 9). Precise location only revealed when user is physically close enough to unlock.

---

## 8. Media Handling

### 8.1 Image Capture & Compression

**Browser Image Capture:**
```typescript
// Using input element (most compatible)
<input
  type="file"
  accept="image/*"
  capture="environment"  // Back camera
  onChange={handleImageSelect}
/>

// Or getUserMedia for more control
const stream = await navigator.mediaDevices.getUserMedia({
  video: { facingMode: 'environment', width: 1920, height: 1080 }
});
```

**Client-Side Compression with browser-image-compression:**

```typescript
import imageCompression from 'browser-image-compression';

async function compressImage(file: File): Promise<Blob> {
  const options = {
    maxSizeMB: 1,             // Target max size
    maxWidthOrHeight: 1920,   // Resize if larger
    useWebWorker: true,       // Non-blocking
    fileType: 'image/webp',   // Output format (if supported)
    initialQuality: 0.8
  };

  const compressedFile = await imageCompression(file, options);
  return compressedFile;
}
```

**WebP Support:**
- Supported in all modern browsers except older Safari
- 25-34% smaller than JPEG at same quality ([WebP FAQ](https://developers.google.com/speed/webp/faq))
- Fallback to JPEG for Safari <14

**HEIC Handling:**
> "Currently there are zero web browsers that support HEIC photos." ([heic2any](https://github.com/alexcorvi/heic2any))

```typescript
import heic2any from 'heic2any';

async function convertHeicIfNeeded(file: File): Promise<Blob> {
  if (file.type === 'image/heic' || file.name.toLowerCase().endsWith('.heic')) {
    const converted = await heic2any({
      blob: file,
      toType: 'image/jpeg',
      quality: 0.85
    });
    return Array.isArray(converted) ? converted[0] : converted;
  }
  return file;
}
```

### 8.2 Audio Recording

**MediaRecorder API:**

```typescript
let mediaRecorder: MediaRecorder;
let audioChunks: Blob[] = [];

async function startRecording() {
  const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

  // Prefer Opus in WebM (smaller, good quality)
  const mimeType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus')
    ? 'audio/webm;codecs=opus'
    : 'audio/mp4';  // Fallback for Safari

  mediaRecorder = new MediaRecorder(stream, { mimeType });

  mediaRecorder.ondataavailable = (event) => {
    audioChunks.push(event.data);
  };

  mediaRecorder.onstop = () => {
    const audioBlob = new Blob(audioChunks, { type: mimeType });
    uploadAudio(audioBlob);
    stream.getTracks().forEach(track => track.stop());
  };

  mediaRecorder.start();
}

function stopRecording() {
  mediaRecorder.stop();
}
```

**Audio Format Strategy:**
- Record as WebM/Opus (Chrome, Firefox) or M4A (Safari)
- No transcoding needed—modern browsers handle both
- ~32kbps Opus = ~240KB per minute = good voice quality

**Safari Technology Preview (2025):**
> "Safari Technology Preview Release 214 introduced support for ALAC and PCM audio codecs in MediaRecorder API." ([AddPipe Blog](https://blog.addpipe.com/record-high-quality-audio-in-safari-with-alac-and-pcm-support-via-mediarecorder/))

For MVP, stick with compressed formats (Opus/AAC) for bandwidth efficiency.

### 8.3 Object Storage: Cloudflare R2

**Why Cloudflare R2:**
- **Zero egress fees** ([R2 Pricing](https://developers.cloudflare.com/r2/pricing/))
- S3-compatible API
- Global CDN included
- Significantly cheaper than AWS S3 for read-heavy workloads

**Pricing (2025):**
| Item | Price |
|------|-------|
| Storage | $0.015/GB/month |
| Class A ops (write) | $4.50/million |
| Class B ops (read) | $0.36/million |
| Egress | **$0** |

> "For a media streaming platform storing 1TB and downloading 10TB each month, AWS S3 costs around $1,050 per month. Cloudflare R2 costs approximately $15 per month." ([Digital Applied](https://www.digitalapplied.com/blog/cloudflare-r2-vs-aws-s3-comparison))

**Upload Implementation:**

```typescript
// Server-side (Edge Function) - Generate presigned URL
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

const s3 = new S3Client({
  region: 'auto',
  endpoint: `https://${ACCOUNT_ID}.r2.cloudflarestorage.com`,
  credentials: {
    accessKeyId: R2_ACCESS_KEY,
    secretAccessKey: R2_SECRET_KEY
  }
});

async function generateUploadUrl(userId: string, filename: string) {
  const key = `media/${userId}/${Date.now()}-${filename}`;

  const command = new PutObjectCommand({
    Bucket: 'canvs-media',
    Key: key,
    ContentType: 'image/webp'
  });

  const url = await getSignedUrl(s3, command, { expiresIn: 300 });
  return { uploadUrl: url, publicUrl: `https://media.canvs.app/${key}` };
}

// Client-side - Upload directly to R2
async function uploadFile(file: Blob, uploadUrl: string) {
  await fetch(uploadUrl, {
    method: 'PUT',
    body: file,
    headers: { 'Content-Type': file.type }
  });
}
```

### 8.4 Thumbnail Generation

**Options:**

1. **Cloudflare Images (Managed):**
   - On-the-fly resizing via URL parameters
   - $5/100k images stored + $1/100k transformations
   - Example: `https://media.canvs.app/image.webp?width=200&height=200`

2. **On-Upload Processing (Edge Function):**
   ```typescript
   // Generate thumbnails at upload time
   // Store original + thumbnail in R2
   ```

**Recommendation:** Use Cloudflare Images for MVP simplicity; migrate to on-upload processing if costs warrant.

---

## 9. Authentication System

### 9.1 Magic Links (Recommended for MVP)

**Why Magic Links:**
- Frictionless: no password to remember
- Secure: no password database to breach
- Email verification built-in
- 61% of organizations plan passwordless adoption in 2025 ([WebProNews](https://www.webpronews.com/magic-links-benefits-and-challenges-in-passwordless-authentication/))

**How It Works:**
1. User enters email
2. Server generates cryptographic token, stores hash in DB
3. Email sent with link containing token
4. User clicks link → token validated → session created
5. Token immediately invalidated (single-use)

**Security Best Practices:**
- Token expiration: 5-15 minutes ([Security Deep Dive](https://guptadeepak.com/mastering-magic-link-security-a-deep-dive-for-developers/))
- Cryptographically secure tokens (e.g., 32 bytes from `crypto.randomBytes`)
- Single-use: delete token after successful authentication
- Rate limit: max 3 requests per email per hour
- HTTPS only for link transmission

### 9.2 Supabase Auth Implementation

```typescript
// Sign in with magic link
const { error } = await supabase.auth.signInWithOtp({
  email: 'user@example.com',
  options: {
    emailRedirectTo: 'https://canvs.app/auth/callback'
  }
});

// Callback page - exchange code for session
const { data: { session }, error } = await supabase.auth.exchangeCodeForSession(code);

// Check authentication state
const { data: { user } } = await supabase.auth.getUser();
```

### 9.3 Phone OTP (Alternative)

For markets where email is less common:

```typescript
const { error } = await supabase.auth.signInWithOtp({
  phone: '+15551234567'
});

// Verify OTP entered by user
const { data: { session }, error } = await supabase.auth.verifyOtp({
  phone: '+15551234567',
  token: '123456',
  type: 'sms'
});
```

**Provider Options:**
- Supabase built-in (Twilio under hood)
- Twilio Verify directly
- AWS SNS

### 9.4 Future: Passkeys

> "Magic links are increasingly overshadowed by passkeys, built on the phishing-resistant WebAuthn standard." ([BayTech Consulting](https://www.baytechconsulting.com/blog/magic-links-ux-security-and-growth-impacts-for-saas-platforms-2025))

**For post-MVP:** Add passkey support as primary auth, magic links as fallback.

### 9.5 Session Management

```typescript
// Supabase handles JWT tokens automatically
// Set up auth state listener
supabase.auth.onAuthStateChange((event, session) => {
  if (event === 'SIGNED_IN') {
    // Update app state
  }
  if (event === 'SIGNED_OUT') {
    // Clear local state
  }
  if (event === 'TOKEN_REFRESHED') {
    // Tokens auto-refreshed
  }
});
```

---

## 10. Push Notifications

### 10.1 Web Push Architecture

**Components:**
1. **VAPID Keys:** Public/private key pair for server identification
2. **Service Worker:** Receives push events when app is closed
3. **PushManager API:** Manages subscriptions
4. **Push Service:** Browser vendor's relay (Google, Apple, Mozilla)

**Flow:**
```
User grants permission → Browser creates subscription →
Subscription sent to server → Server stores subscription →
Event occurs → Server sends push to browser's push service →
Push service delivers to device → Service worker shows notification
```

### 10.2 iOS PWA Requirements (Critical)

> "Push notifications are possible with PWAs on iOS 16.4 or later. Your PWA needs to be installed on the device before displaying the notification prompt." ([Brainhub](https://brainhub.eu/library/pwa-on-ios))

**Requirements for iOS Web Push:**
1. **PWA must be installed** to Home Screen (not browser)
2. **`display: standalone`** in manifest (required!)
3. **User must interact** (button click) to trigger permission prompt
4. **HTTPS** (obviously)

**Implementation Strategy:**

```typescript
// Check if push is supported
const isPushSupported = 'PushManager' in window && 'serviceWorker' in navigator;

// Check if PWA is installed (iOS detection)
const isInstalled = window.matchMedia('(display-mode: standalone)').matches
  || (window.navigator as any).standalone === true;

// Only show "Enable notifications" button if:
// - Push is supported AND
// - App is installed (on iOS) OR is not iOS
function shouldShowNotificationPrompt(): boolean {
  if (!isPushSupported) return false;

  const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);
  if (isIOS && !isInstalled) {
    // Show "Add to Home Screen" prompt instead
    return false;
  }

  return Notification.permission === 'default';
}

// Request permission (must be from user gesture)
async function requestNotificationPermission() {
  const permission = await Notification.requestPermission();

  if (permission === 'granted') {
    await subscribeToPush();
  }
}

// Subscribe to push
async function subscribeToPush() {
  const registration = await navigator.serviceWorker.ready;

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY)
  });

  // Send subscription to server
  await fetch('/api/push/subscribe', {
    method: 'POST',
    body: JSON.stringify(subscription),
    headers: { 'Content-Type': 'application/json' }
  });
}
```

### 10.3 Service Worker Push Handler

```typescript
// sw.ts
self.addEventListener('push', (event) => {
  const data = event.data?.json() ?? {};

  const options: NotificationOptions = {
    body: data.body,
    icon: '/icons/notification.png',
    badge: '/icons/badge.png',
    tag: data.tag || 'default',
    data: { url: data.url },
    actions: data.actions
  };

  event.waitUntil(
    self.registration.showNotification(data.title, options)
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  const url = event.notification.data?.url || '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then((clientList) => {
        // Focus existing window or open new
        for (const client of clientList) {
          if (client.url === url && 'focus' in client) {
            return client.focus();
          }
        }
        return clients.openWindow(url);
      })
  );
});
```

### 10.4 Server-Side Push Sending

```typescript
// Edge Function: Send push notification
import webpush from 'web-push';

webpush.setVapidDetails(
  'mailto:notifications@canvs.app',
  VAPID_PUBLIC_KEY,
  VAPID_PRIVATE_KEY
);

async function sendPushNotification(
  subscription: PushSubscription,
  payload: { title: string; body: string; url: string }
) {
  try {
    await webpush.sendNotification(subscription, JSON.stringify(payload));
  } catch (error) {
    if (error.statusCode === 410) {
      // Subscription expired - remove from database
      await removeSubscription(subscription);
    }
    throw error;
  }
}
```

### 10.5 Notification Use Cases

| Event | Notification |
|-------|--------------|
| Reply to your pin | "Alex replied to your pin at Central Park" |
| New entry in capsule | "New memory added to 'Our Coffee Spot'" |
| Someone unlocked | "3 people discovered your sunset story" |
| Nearby new content | "5 new pins appeared near you" (digest) |

---

## 11. Content Moderation

### 11.1 Moderation Strategy

**Three-Layer Approach:**

1. **Automated Pre-Screening:** AI moderation on upload
2. **Community Reporting:** User-generated flags
3. **Human Review:** Admin dashboard for appeals and edge cases

### 11.2 AI Moderation: OpenAI Moderation API

**Why OpenAI Moderation API:**
- **Free to use** for all developers ([OpenAI Blog](https://openai.com/index/upgrading-the-moderation-api-with-our-new-multimodal-moderation-model/))
- Multimodal: handles text AND images
- Built on GPT-4o, highly accurate
- Categories: hate, harassment, self-harm, sexual, violence, illicit

**Implementation:**

```typescript
import OpenAI from 'openai';

const openai = new OpenAI();

async function moderateContent(
  text?: string,
  imageUrl?: string
): Promise<{ approved: boolean; flags: string[] }> {
  const input: Array<{ type: string; text?: string; image_url?: { url: string } }> = [];

  if (text) {
    input.push({ type: 'text', text });
  }
  if (imageUrl) {
    input.push({ type: 'image_url', image_url: { url: imageUrl } });
  }

  const response = await openai.moderations.create({
    model: 'omni-moderation-latest',
    input
  });

  const result = response.results[0];
  const flags = Object.entries(result.categories)
    .filter(([_, flagged]) => flagged)
    .map(([category]) => category);

  return {
    approved: !result.flagged,
    flags
  };
}
```

**Categories Detected:**
- `hate` / `hate/threatening`
- `harassment` / `harassment/threatening`
- `self-harm` / `self-harm/intent` / `self-harm/instructions`
- `sexual` / `sexual/minors`
- `violence` / `violence/graphic`
- `illicit` / `illicit/violent`

### 11.3 Audio Moderation

For audio content, use AssemblyAI or transcribe first:

```typescript
// Option 1: Transcribe with Whisper, then moderate text
import OpenAI from 'openai';

async function moderateAudio(audioUrl: string) {
  // Transcribe
  const transcription = await openai.audio.transcriptions.create({
    file: await fetch(audioUrl).then(r => r.blob()),
    model: 'whisper-1'
  });

  // Moderate transcription
  return moderateContent(transcription.text);
}
```

### 11.4 Location-Sensitive Moderation

**Geofenced Rules:**

| Location Type | Restrictions |
|--------------|--------------|
| Schools | No adult content, no solicitation |
| Hospitals | No graphic content |
| Residential | No harassment, extra privacy |
| Memorial sites | Extra sensitivity review |
| Government | No political incitement |

**Implementation:**

```typescript
async function checkLocationRestrictions(
  lat: number,
  lng: number
): Promise<{ allowed: boolean; restrictions: string[] }> {
  // Query OSM/Google Places for nearby POIs
  const nearbyPOIs = await reverseGeocode(lat, lng, {
    types: ['school', 'hospital', 'place_of_worship', 'cemetery']
  });

  const restrictions: string[] = [];

  if (nearbyPOIs.some(poi => poi.type === 'school')) {
    restrictions.push('no_adult_content');
    restrictions.push('extra_child_safety');
  }

  return {
    allowed: true,  // Still allowed, just restricted
    restrictions
  };
}
```

### 11.5 Admin Dashboard Requirements

**Minimum Features:**
- Content queue (flagged items)
- User reports list
- Take action: approve / remove / warn user / ban user
- Appeal handling
- Bulk operations
- Audit log

**Database Support:**
```sql
-- Track moderation actions
CREATE TABLE moderation_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  moderator_id UUID NOT NULL REFERENCES users(id),
  target_type TEXT NOT NULL,  -- 'post', 'comment', 'user'
  target_id UUID NOT NULL,
  action TEXT NOT NULL,  -- 'approve', 'remove', 'warn', 'ban'
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 12. Security & Anti-Spoofing

### 12.1 Location Spoofing Threat

> "One rideshare platform had customers lose $40 million after over 800 fraudulent drivers used GPS spoofing apps." ([Fingerprint Blog](https://fingerprint.com/blog/location-spoofing-detection/))

**Threat for CANVS:**
- Users claim to be at locations they're not
- Unlock content without physical presence
- Create spam pins at remote locations

### 12.2 Detection Strategies

**1. Device Attestation (Most Effective):**

```typescript
// Use device integrity APIs
// Android: Play Integrity API
// iOS: App Attest (requires native code)

// For web, check for known spoofing indicators
function detectSpoofingIndicators(): boolean {
  // Check for mock location permission (Android webview)
  // Check for emulator signatures
  // Check for VPN/proxy IP
  return false;  // Simplified
}
```

**2. Behavioral Analysis:**

```typescript
interface LocationHistory {
  lat: number;
  lng: number;
  timestamp: number;
  accuracy: number;
}

function detectImpossibleTravel(history: LocationHistory[]): boolean {
  for (let i = 1; i < history.length; i++) {
    const prev = history[i - 1];
    const curr = history[i];

    const distanceKm = haversineDistance(prev, curr);
    const timeHours = (curr.timestamp - prev.timestamp) / 3600000;
    const speedKmh = distanceKm / timeHours;

    // Max reasonable speed: 1000 km/h (jet aircraft)
    if (speedKmh > 1000) {
      return true;  // Impossible travel detected
    }
  }
  return false;
}
```

**3. Cross-Signal Validation:**

> "Data cross-validation involves comparing GPS data with Wi-Fi and cellular data. If the sources don't match, spoofing may be involved." ([Incognia](https://www.incognia.com/solutions/detecting-location-spoofing))

**4. Rate Limiting by Location:**

```typescript
// Limit pins created from same location in short time
// Prevents "dropping spam while walking" patterns
```

### 12.3 Mitigation Strategies

| Risk Level | Mitigation |
|------------|------------|
| Low | Accept location, proceed normally |
| Medium | Require photo of location, manual review |
| High | Reject action, require re-authentication |

**Practical MVP Approach:**
1. Log all location data with timestamps
2. Implement basic impossible travel detection
3. Rate limit new accounts (5 pins/day)
4. Require minimum accuracy (≤50m) to post
5. Default to "nearby only" visibility (reduces spam incentive)

### 12.4 Rate Limiting Implementation

```sql
-- Rate limit function
CREATE OR REPLACE FUNCTION check_rate_limit(
  p_user_id UUID,
  p_action TEXT,
  p_limit INTEGER,
  p_window_minutes INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
  action_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO action_count
  FROM rate_limit_log
  WHERE user_id = p_user_id
    AND action = p_action
    AND created_at > NOW() - (p_window_minutes || ' minutes')::INTERVAL;

  IF action_count >= p_limit THEN
    RETURN FALSE;  -- Rate limited
  END IF;

  INSERT INTO rate_limit_log (user_id, action)
  VALUES (p_user_id, p_action);

  RETURN TRUE;  -- Allowed
END;
$$ LANGUAGE plpgsql;
```

```typescript
// Before creating pin
const canCreate = await supabase.rpc('check_rate_limit', {
  p_user_id: userId,
  p_action: 'create_pin',
  p_limit: 5,
  p_window_minutes: 1440  // 24 hours
});
```

---

## 13. MVP v2: Vision Anchoring Technologies

### 13.1 Overview

MVP v2 upgrades anchoring from GPS-only to GPS + Visual Positioning System (VPS), achieving sub-meter accuracy in supported areas.

### 13.2 Google ARCore Geospatial API

**Capabilities:**
- Global coverage via Google Street View imagery
- Position accuracy: ~1-5 meters (vs 5-50m GPS) ([ARCore Docs](https://developers.google.com/ar/develop/geospatial))
- Rotation accuracy: ~5 degrees
- Works on 1B+ ARCore-supported devices

**How It Works:**
> "VPS utilizes a global 3D point cloud derived from Google Street View images to accurately localize user devices."

**Coverage:**
- 87+ countries
- Works anywhere Street View coverage exists
- VPS availability can be checked programmatically

**Requirements:**
- Native app (Android/iOS) - NOT available for web
- ARCore/ARKit runtime
- User location permission + camera permission
- Network connection for VPS queries

**Anchor Types:**
- **WGS84 Anchors:** Fixed lat/lng/altitude
- **Terrain Anchors:** Aligned to ground surface
- **Rooftop Anchors:** Aligned to building tops

### 13.3 Niantic Lightship VPS for Web

**Unique Advantage:** Works in **web browsers** via 8th Wall integration.

> "For the first time ever, 8th Wall developers have access to the 3D mesh of a location for use in their AR scene." ([Niantic Blog](https://nianticlabs.com/news/lightship-vps-web))

**Key Features:**
- Centimeter-level precision at VPS-activated locations
- 3D mesh access for occlusion and physics
- 100,000+ VPS-activated locations at launch
- Browser-based (no app install)

**Critical 2025 Update:**
> "Niantic announced they're winding down 8th Wall. Hosted services will remain available through February 28, 2027. Features that rely on Niantic Spatial services - including VPS - will not be available after that date." ([8th Wall Blog](https://www.8thwall.com/blog/post/202888018234/8th-wall-update-engine-distribution-and-open-source-plans))

**Implication for CANVS:** If pursuing web-based VPS, monitor 8th Wall transition. Consider native app path for long-term VPS needs.

### 13.4 Indoor Anchoring Options

**Challenge:** GPS doesn't work indoors; VPS requires outdoor Street View coverage.

**Solutions:**

1. **ARCore Cloud Anchors:**
   - Share anchors across devices
   - Persist for days/weeks
   - Requires scanning location first
   - Works indoor and outdoor

2. **QR/NFC Markers:**
   - Most reliable for "table-level" precision
   - Requires physical markers
   - Businesses can deploy markers voluntarily

3. **WiFi Fingerprinting:**
   - Indoor positioning using WiFi signal strengths
   - Accuracy: 2-5 meters indoors
   - Requires fingerprint database

### 13.5 Web vs Native Decision Matrix

| Factor | Web (PWA) | Native (iOS/Android) |
|--------|-----------|---------------------|
| Distribution | Instant via link | App store approval |
| Onboarding | Zero friction | Install required |
| ARCore Geospatial | ❌ Not available | ✅ Full support |
| WebXR | Partial (no iOS Safari) | ✅ Full ARKit/ARCore |
| 8th Wall VPS | ✅ (until 2027) | ✅ |
| Background location | ❌ Limited | ✅ Full |
| Push notifications | ✅ (with caveats) | ✅ Full |
| Development cost | Lower | Higher |

**Recommendation:**
- **MVP v1:** Web PWA only (validates core concept)
- **MVP v2:** Thin native wrapper (Capacitor/React Native) for ARCore Geospatial, while keeping web for content viewing

### 13.6 Hybrid Architecture for MVP v2

```
┌─────────────────────────────────────────────────────────────┐
│                  CANVS Content Platform                      │
│                 (Same backend for both)                      │
└─────────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│    Web PWA          │       │   Native App        │
│  (GPS + viewing)    │       │  (GPS + VPS + AR)   │
│                     │       │                     │
│ • Browse content    │       │ • Full AR mode      │
│ • Create (GPS only) │       │ • VPS anchoring     │
│ • Unlock (GPS)      │       │ • High precision    │
│ • Share links       │       │ • Indoor anchors    │
└─────────────────────┘       └─────────────────────┘
```

---

## 14. Infrastructure & Deployment

### 14.1 Recommended Stack

| Component | Service | Rationale |
|-----------|---------|-----------|
| Frontend hosting | Vercel | Next.js native, global CDN |
| Database | Supabase | Managed PostgreSQL + PostGIS |
| Object storage | Cloudflare R2 | Zero egress, global |
| Edge Functions | Supabase Edge / Cloudflare Workers | Low latency |
| DNS | Cloudflare | DDoS protection, fast |
| Monitoring | Sentry + Supabase Dashboard | Error tracking |

### 14.2 Environment Setup

```bash
# .env.local (client-safe)
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
NEXT_PUBLIC_MAPLIBRE_KEY=xxx
NEXT_PUBLIC_VAPID_PUBLIC_KEY=xxx

# .env (server-only)
SUPABASE_SERVICE_ROLE_KEY=eyJ...
R2_ACCOUNT_ID=xxx
R2_ACCESS_KEY=xxx
R2_SECRET_KEY=xxx
VAPID_PRIVATE_KEY=xxx
OPENAI_API_KEY=xxx
```

### 14.3 Deployment Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Build
        run: npm run build

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

### 14.4 Cost Estimates (MVP Scale)

**Assumptions:** 10,000 MAU, 50,000 posts, 100GB media

| Service | Monthly Cost |
|---------|-------------|
| Supabase Pro | $25 |
| Vercel Pro | $20 |
| Cloudflare R2 (100GB + 10M reads) | $5 |
| MapTiler (200k tiles) | $0 (free tier) |
| OpenAI Moderation | $0 (free) |
| Nominatim (self-hosted) | $10 (VPS) |
| **Total** | **~$60/month** |

---

## 15. API Design

### 15.1 Core Endpoints

```yaml
# Supabase auto-generates REST from tables, but custom RPC for complex queries

# Auth
POST /auth/v1/otp                     # Send magic link
POST /auth/v1/token?grant_type=code   # Exchange code for session

# Place Anchors
GET  /rest/v1/rpc/nearby_anchors      # Custom function with PostGIS
POST /rest/v1/place_anchors           # Create anchor

# Posts
GET  /rest/v1/posts?anchor_id=eq.{id}  # Posts at anchor
POST /rest/v1/posts                     # Create post
PATCH /rest/v1/posts?id=eq.{id}        # Update post

# Capsules
GET  /rest/v1/capsules?id=eq.{id}
POST /rest/v1/capsules
POST /rest/v1/capsules/add_entry       # RPC

# Interactions
POST /rest/v1/reactions
POST /rest/v1/comments
GET  /rest/v1/comments?post_id=eq.{id}

# Reports
POST /rest/v1/reports

# Media
POST /rest/v1/rpc/get_upload_url       # Presigned R2 URL
```

### 15.2 Nearby Query RPC

```sql
-- Custom RPC for nearby posts
CREATE OR REPLACE FUNCTION nearby_posts(
  user_lat DOUBLE PRECISION,
  user_lng DOUBLE PRECISION,
  radius_m INTEGER DEFAULT 500,
  limit_count INTEGER DEFAULT 50
)
RETURNS TABLE (
  post_id UUID,
  anchor_id UUID,
  post_type TEXT,
  category TEXT,
  text_content TEXT,
  media JSONB,
  author_name TEXT,
  author_avatar TEXT,
  distance_m DOUBLE PRECISION,
  unlock_radius_m INTEGER,
  is_unlocked BOOLEAN,
  reaction_counts JSONB,
  comment_count BIGINT,
  created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.anchor_id,
    p.post_type,
    p.category,
    p.text_content,
    p.media,
    u.display_name,
    u.avatar_url,
    ST_Distance(pa.location, ST_MakePoint(user_lng, user_lat)::geography) as distance_m,
    pa.unlock_radius_m,
    (ST_Distance(pa.location, ST_MakePoint(user_lng, user_lat)::geography) <= pa.unlock_radius_m) as is_unlocked,
    (SELECT jsonb_object_agg(reaction_type, cnt)
     FROM (SELECT reaction_type, COUNT(*) as cnt
           FROM reactions WHERE post_id = p.id
           GROUP BY reaction_type) r) as reaction_counts,
    (SELECT COUNT(*) FROM comments WHERE post_id = p.id) as comment_count,
    p.created_at
  FROM posts p
  JOIN place_anchors pa ON p.anchor_id = pa.id
  JOIN users u ON p.author_id = u.id
  WHERE ST_DWithin(pa.location, ST_MakePoint(user_lng, user_lat)::geography, radius_m)
    AND p.audience IN ('nearby', 'public')
    AND p.is_flagged = FALSE
    AND p.moderation_status = 'approved'
  ORDER BY distance_m ASC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;
```

### 15.3 API Response Format

```typescript
// Successful response
{
  "data": [...],
  "meta": {
    "total": 42,
    "limit": 50,
    "offset": 0
  }
}

// Error response
{
  "error": {
    "code": "LOCATION_ACCURACY_TOO_LOW",
    "message": "Location accuracy must be within 50 meters to create content",
    "details": {
      "current_accuracy_m": 78,
      "required_accuracy_m": 50
    }
  }
}
```

---

## 16. Integration Summary

### 16.1 Technology Integration Diagram

```
┌────────────────────────────────────────────────────────────────────────┐
│                           CLIENT (Next.js PWA)                         │
│                                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌────────────┐│
│  │ Geolocation  │  │ MapLibre GL  │  │  Media APIs  │  │  Service   ││
│  │     API      │  │     JS       │  │ (Camera/Mic) │  │   Worker   ││
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬─────┘│
│         │                 │                 │                 │       │
└─────────┼─────────────────┼─────────────────┼─────────────────┼───────┘
          │                 │                 │                 │
          ▼                 ▼                 ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                            NETWORK LAYER                                │
│                                                                         │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│   │  Supabase   │  │  MapTiler   │  │ Cloudflare  │  │   Web Push  │  │
│   │    REST     │  │   Tiles     │  │     R2      │  │   Service   │  │
│   └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │
└──────────┼────────────────┼────────────────┼────────────────┼──────────┘
           │                │                │                │
           ▼                ▼                ▼                ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                            BACKEND LAYER                                 │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │                         SUPABASE                                    │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐ │ │
│  │  │  PostgreSQL  │  │   Realtime   │  │     Edge Functions       │ │ │
│  │  │  + PostGIS   │  │  (WebSocket) │  │  ┌──────────────────┐   │ │ │
│  │  │  + H3        │  │              │  │  │ Content Moderation│   │ │ │
│  │  └──────────────┘  └──────────────┘  │  │ (OpenAI API)      │   │ │ │
│  │                                       │  └──────────────────┘   │ │ │
│  │  ┌──────────────┐  ┌──────────────┐  │  ┌──────────────────┐   │ │ │
│  │  │     Auth     │  │   Storage    │  │  │ Reverse Geocoding │   │ │ │
│  │  │ (Magic Link) │  │   (Small)    │  │  │ (Nominatim)       │   │ │ │
│  │  └──────────────┘  └──────────────┘  │  └──────────────────┘   │ │ │
│  │                                       └──────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────┘
```

### 16.2 Data Flow: Create Pin

```
1. User taps "Create" button
   │
2. Check geolocation accuracy
   │ ◄── If accuracy > 50m: show "Move outside" prompt
   │
3. User adds text + photo
   │
4. Client compresses image (WebP, <1MB)
   │
5. Request presigned upload URL
   │ ──► Supabase Edge Function
   │ ◄── Returns R2 presigned URL
   │
6. Upload image directly to R2
   │ ──► Cloudflare R2
   │ ◄── Returns public URL
   │
7. Create place_anchor + post
   │ ──► Supabase REST API
   │     │
   │     ▼
   │     Trigger: moderate content (async)
   │     │ ──► OpenAI Moderation API
   │     │
   │     Trigger: set H3 cells
   │     │
   │     Trigger: set display_location (privacy)
   │ ◄── Returns post ID + shareable URL
   │
8. Show success + share prompt
```

---

## 17. Risk Assessment & Mitigations

### 17.1 Technical Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| GPS accuracy insufficient for UX | High | Medium | Display accuracy circle, allow manual adjustment, frame as feature |
| iOS PWA limitations | Medium | High | Prioritize Android, provide clear iOS install instructions |
| 8th Wall deprecation (v2) | High | Confirmed | Plan native path for VPS, monitor alternatives |
| Supabase outage | High | Low | Use multi-region, implement offline queue |
| Location spoofing | Medium | Medium | Rate limits, behavioral detection, community reporting |
| Content moderation backlog | Medium | Medium | Auto-approve low-risk, human review for flagged |

### 17.2 Business Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Users don't want location-based social | Critical | MVP validates this; pivot to utility if needed |
| Safety incidents at locations | High | Strong moderation, geofencing, rapid response |
| Competitors with better positioning | Medium | Focus on emotional use cases, community |
| Vendor lock-in | Medium | Use open standards, self-hostable alternatives |

### 17.3 Privacy & Legal Risks

| Risk | Mitigation |
|------|------------|
| User location data breach | Encrypt at rest, minimal retention, H3 snapping |
| Stalking/harassment via location | Private by default, block functionality, proximity limits |
| GDPR/CCPA compliance | Data export, deletion, consent management |
| Trespass/nuisance claims | Geofencing sensitive areas, clear ToS |

---

## 18. Next Steps & Future Considerations

### 18.1 MVP v1 Development Phases

**Phase 1: Foundation (Weeks 1-4)**
- [ ] Set up Supabase project with PostGIS + H3
- [ ] Create Next.js PWA scaffold
- [ ] Implement authentication (magic links)
- [ ] Basic map view with MapLibre

**Phase 2: Core Features (Weeks 5-8)**
- [ ] Geolocation service with accuracy handling
- [ ] Create pin flow + media upload to R2
- [ ] Nearby discovery (list + map)
- [ ] Unlock radius mechanism

**Phase 3: Social Layer (Weeks 9-10)**
- [ ] Reactions and comments
- [ ] User profiles
- [ ] Capsule creation

**Phase 4: Safety & Polish (Weeks 11-12)**
- [ ] Content moderation pipeline
- [ ] Reporting and blocking
- [ ] Push notifications
- [ ] Admin dashboard MVP
- [ ] Performance optimization

### 18.2 Post-MVP Enhancements

**Short-term (3-6 months):**
- Place naming via reverse geocoding
- Audio replies
- Follower system
- Event-based capsules
- Improved offline support

**Medium-term (6-12 months):**
- Native apps (Capacitor/React Native)
- ARCore Geospatial integration
- Advanced anti-spoofing
- Creator tools
- Analytics dashboard

**Long-term (12+ months):**
- AI Reality Filter (semantic search, recommendations)
- Trails feature (connected pins)
- Business tools
- Passkey authentication
- Indoor anchoring

### 18.3 Alternative Technology Paths

**If Supabase doesn't scale:**
- Migrate to self-hosted PostgreSQL + PostgREST
- Consider CockroachDB for multi-region

**If MapLibre too complex:**
- Start with Leaflet, migrate later

**If R2 insufficient:**
- AWS S3 with CloudFront (higher cost)
- Backblaze B2 + Cloudflare CDN

**If native required sooner:**
- Capacitor (wrap PWA)
- React Native (full native)
- Flutter (if team has Dart experience)

---

## References

### Core Documentation
- [MDN: Geolocation API](https://developer.mozilla.org/docs/Web/API/Geolocation_API)
- [MDN: Service Workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)
- [Next.js: PWA Guide](https://nextjs.org/docs/app/guides/progressive-web-apps)
- [Supabase: PostGIS Docs](https://supabase.com/docs/guides/database/extensions/postgis)
- [H3: Introduction](https://h3geo.org/docs/)
- [PostGIS: ST_DWithin](https://postgis.net/docs/ST_DWithin.html)
- [Cloudflare R2: Pricing](https://developers.cloudflare.com/r2/pricing/)
- [OpenAI: Moderation API](https://platform.openai.com/docs/guides/moderation)
- [WebKit: Web Push for iOS](https://webkit.org/blog/13878/web-push-for-web-apps-on-ios-and-ipados/)

### Research & Comparisons
- [MapLibre vs Leaflet Comparison](https://blog.jawg.io/maplibre-gl-vs-leaflet-choosing-the-right-tool-for-your-interactive-map/)
- [PostGIS Query Optimization](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830)
- [H3 Performance Benefits](https://blog.rustprooflabs.com/2022/06/h3-indexes-on-postgis-data)
- [PWA Best Practices 2025](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Best_practices)
- [Magic Link Security](https://guptadeepak.com/mastering-magic-link-security-a-deep-dive-for-developers/)
- [Location Spoofing Detection](https://fingerprint.com/blog/location-spoofing-detection/)

### AR/VPS Technologies
- [ARCore Geospatial API](https://developers.google.com/ar/develop/geospatial)
- [Niantic Lightship VPS](https://lightship.dev/docs/ardk/features/lightship_vps/)
- [8th Wall Platform Update](https://www.8thwall.com/blog/post/202888018234/8th-wall-update-engine-distribution-and-open-source-plans)

---

*Document generated: January 2026*
*Last reviewed: January 2026*
*Next review: Prior to development kickoff*
