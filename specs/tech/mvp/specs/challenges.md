# CANVS MVP Technical Challenges Analysis

**Version:** 1.0.0
**Last Updated:** January 2026
**Status:** Research Complete
**Related Document:** [tech_specs.md](./tech_specs.md)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [GPS & Geolocation Challenges](#2-gps--geolocation-challenges)
3. [PWA & Browser Compatibility Challenges](#3-pwa--browser-compatibility-challenges)
4. [Spatial Database & Scaling Challenges](#4-spatial-database--scaling-challenges)
5. [Media Handling Challenges](#5-media-handling-challenges)
6. [Push Notifications & Real-time Challenges](#6-push-notifications--real-time-challenges)
7. [Security & Anti-Spoofing Challenges](#7-security--anti-spoofing-challenges)
8. [Content Moderation Challenges](#8-content-moderation-challenges)
9. [AR/VPS Integration Challenges (MVP v2)](#9-arvps-integration-challenges-mvp-v2)
10. [Infrastructure & Cost Challenges](#10-infrastructure--cost-challenges)
11. [Risk Matrix Summary](#11-risk-matrix-summary)
12. [Recommended Mitigations Priority](#12-recommended-mitigations-priority)
13. [Potential Show-Stoppers](#13-potential-show-stoppers)

---

## 1. Executive Summary

This document provides a comprehensive analysis of technical challenges facing the CANVS MVP implementation. Each challenge is assessed for impact, likelihood, and includes practical solutions.

### 1.1 Critical Findings

| Category | Critical Challenges | Manageable Challenges |
|----------|--------------------|-----------------------|
| GPS/Geolocation | 3 | 4 |
| PWA/Browser | 2 | 5 |
| Database/Scaling | 2 | 4 |
| Media Handling | 1 | 4 |
| Push Notifications | 2 | 3 |
| Security | 3 | 4 |
| Content Moderation | 1 | 3 |
| AR/VPS (v2) | 2 | 3 |

### 1.2 Key Takeaways

1. **GPS precision is the core UX challenge** - Urban environments can degrade accuracy to 30-100m, significantly impacting the location-anchored content experience
2. **iOS PWA limitations require careful UX design** - Push notifications require home screen installation; no true background location
3. **Location spoofing cannot be fully prevented in web** - Accept this and design around it with rate limits, behavioral analysis, and trust systems
4. **Supabase Realtime has scaling limits** - Plan architecture for connection pooling and geographic sharding
5. **8th Wall deprecation affects MVP v2 VPS plans** - Consider native app path for ARCore Geospatial

---

## 2. GPS & Geolocation Challenges

### 2.1 Urban Canyon Effect

**Problem:**
Tall buildings create "urban canyons" that block direct satellite signals and cause multipath interference. GPS signals bounce off glass and metal surfaces, creating false positioning data.

**Technical Details:**
- In dense urban areas, GPS accuracy can degrade from 3-10m to 30-100m
- Multipath interference occurs when reflected signals arrive at the receiver with longer travel times
- Limited satellite visibility in narrow streets reduces position quality
- Some downtown areas may have only 3-4 visible satellites vs 8-12 in open areas

**Impact:** HIGH
**Likelihood:** HIGH (in any urban deployment)

**Solutions:**

1. **Visual Honesty - Display Accuracy Circles:**
```typescript
// Always show the uncertainty to users
function renderAccuracyCircle(map: MapLibreMap, position: GeolocationPosition) {
  const accuracy = position.coords.accuracy;

  map.addSource('accuracy-circle', {
    type: 'geojson',
    data: createCircleGeoJSON(
      position.coords.longitude,
      position.coords.latitude,
      accuracy
    )
  });

  map.addLayer({
    id: 'accuracy-fill',
    type: 'fill',
    source: 'accuracy-circle',
    paint: {
      'fill-color': accuracy <= 20 ? '#22c55e' : accuracy <= 50 ? '#eab308' : '#ef4444',
      'fill-opacity': 0.15
    }
  });
}
```

2. **Accuracy-Gated Actions:**
```typescript
interface LocationState {
  position: GeolocationPosition;
  accuracyTier: 'excellent' | 'good' | 'fair' | 'poor';
  canPost: boolean;
  canUnlock: boolean;
}

function getLocationState(position: GeolocationPosition): LocationState {
  const accuracy = position.coords.accuracy;
  return {
    position,
    accuracyTier: accuracy <= 10 ? 'excellent' : accuracy <= 25 ? 'good' : accuracy <= 50 ? 'fair' : 'poor',
    canPost: accuracy <= 50,     // Only allow posting with ≤50m accuracy
    canUnlock: accuracy <= 100   // Slightly more lenient for unlocking
  };
}
```

3. **User Guidance:**
   - Show "Move outside for better accuracy" prompts
   - Provide accuracy badge: "±18m" or "±45m (approximate)"
   - Disable create button when accuracy exceeds threshold

4. **Google's 3D Mapping Aided Corrections:**
   - Available in 3,850+ cities through Google Play Services
   - Automatically improves accuracy on Android devices
   - No code changes required - benefits are transparent

**References:**
- [Google 3D Mapping Corrections](https://www.gpsworld.com/google-to-improve-urban-gps-accuracy-for-apps/)
- [Sidewalk Matching Research](https://satellite-navigation.springeropen.com/articles/10.1186/s43020-025-00159-8)

---

### 2.2 Indoor Positioning Limitations

**Problem:**
GPS signals cannot penetrate buildings effectively. Indoor positioning relies on WiFi triangulation, which has limited accuracy (20-50m) and inconsistent availability.

**Technical Details:**
- Indoor GPS accuracy typically 50-100m+ (often unusable)
- WiFi triangulation requires known access point locations
- Bluetooth beacons require physical infrastructure
- Cell tower positioning is very coarse (100m+)

**Impact:** HIGH
**Likelihood:** HIGH (users will use app indoors)

**Solutions:**

1. **Venue Association:**
```typescript
// When accuracy is poor, offer venue/building selection
async function handleIndoorLocation(position: GeolocationPosition) {
  if (position.coords.accuracy > 50) {
    // Query nearby venues from OpenStreetMap/Google Places
    const venues = await getNearbyVenues(position.coords.latitude, position.coords.longitude);
    // Let user select their venue
    return showVenueSelector(venues);
  }
}
```

2. **Accept Indoor Limitations:**
   - Clearly communicate that CANVS works best outdoors
   - Allow "approximate" posts with larger unlock radii indoors
   - Consider venue-level anchoring (coffee shop level) vs precise spots

3. **Future: QR Code Anchors:**
   - Businesses could display QR codes that provide precise indoor anchors
   - Creates partnership opportunities
   - Doesn't require GPS at all

---

### 2.3 GPS Drift and Jitter

**Problem:**
Even when stationary, GPS position can "drift" by 5-30 meters due to atmospheric conditions, satellite geometry changes, and signal processing variations.

**Technical Details:**
- Position can shift every few seconds without user movement
- Creates confusing UX when map marker jumps around
- Can cause false "unlock" triggers or unexpected "out of range" states

**Impact:** MEDIUM
**Likelihood:** HIGH

**Solutions:**

1. **Kalman Filtering:**
```typescript
import KalmanFilter from 'kalmanjs';

class PositionSmoother {
  private latFilter = new KalmanFilter({ R: 0.01, Q: 3 });
  private lngFilter = new KalmanFilter({ R: 0.01, Q: 3 });

  smooth(position: GeolocationPosition): { lat: number; lng: number } {
    return {
      lat: this.latFilter.filter(position.coords.latitude),
      lng: this.lngFilter.filter(position.coords.longitude)
    };
  }
}
```

2. **Stationary Detection:**
```typescript
function detectStationary(history: GeolocationPosition[]): boolean {
  if (history.length < 3) return false;
  const recent = history.slice(-5);
  const avgSpeed = recent.reduce((sum, p) => sum + (p.coords.speed || 0), 0) / recent.length;
  return avgSpeed < 0.5; // m/s
}
```

3. **Manual Pin Adjustment:**
   - Allow users to drag their pin within the accuracy radius
   - Builds trust when GPS is imperfect
   - Store user-adjusted position if within reasonable bounds

---

### 2.4 Battery Drain from Location Tracking

**Problem:**
Continuous high-accuracy GPS tracking significantly drains mobile device batteries, creating poor user experience and potential negative reviews.

**Technical Details:**
- High-accuracy GPS uses 100-200mW of power
- Continuous tracking can drain 10-15% battery per hour
- `watchPosition` with `enableHighAccuracy: true` is the most power-hungry mode

**Impact:** MEDIUM
**Likelihood:** HIGH

**Solutions:**

1. **Adaptive Tracking Strategy:**
```typescript
function getLocationConfig(context: 'browse' | 'create' | 'unlock'): PositionOptions {
  switch (context) {
    case 'create':
      return { enableHighAccuracy: true, timeout: 15000, maximumAge: 0 };
    case 'unlock':
      return { enableHighAccuracy: true, timeout: 10000, maximumAge: 5000 };
    case 'browse':
      return { enableHighAccuracy: false, timeout: 30000, maximumAge: 60000 };
  }
}
```

2. **Interval-Based Updates:**
```typescript
class LocationManager {
  private intervalId: number | null = null;

  startTracking(intervalMs: number = 10000) {
    this.intervalId = window.setInterval(() => {
      navigator.geolocation.getCurrentPosition(
        this.handlePosition,
        this.handleError,
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 10000 }
      );
    }, intervalMs);
  }
}
```

---

### 2.5 Permission Denial Rates

**Problem:**
Users increasingly deny location permission requests. Studies show 30-50% denial rates for apps without clear value proposition.

**Impact:** HIGH
**Likelihood:** MEDIUM

**Solutions:**

1. **Pre-Permission Education:**
```typescript
async function requestLocationWithEducation() {
  const userAgreed = await showEducationModal({
    title: "CANVS needs your location",
    message: "To discover memories left by others and leave your own mark on the world, CANVS needs to know where you are.",
    benefits: [
      "Discover pins and capsules near you",
      "Leave memories at meaningful places",
      "Unlock content left by friends"
    ],
    privacyNote: "We only use your location while the app is open."
  });

  if (userAgreed) {
    return navigator.geolocation.getCurrentPosition(...);
  }
}
```

2. **Graceful Degradation:**
   - Offer manual location entry
   - Provide city-level browsing
   - Explain limited features

---

## 3. PWA & Browser Compatibility Challenges

### 3.1 iOS Safari PWA Limitations

**Problem:**
iOS Safari has significant PWA limitations compared to Chrome on Android, affecting push notifications, storage, and background capabilities.

**Technical Details:**
- Push notifications only work if PWA is installed to home screen (iOS 16.4+)
- No background sync capability
- Storage limited to ~50MB for Cache API
- Storage can be evicted after 7 days of inactivity
- No beforeinstallprompt event for install prompts

**Impact:** HIGH
**Likelihood:** CERTAIN (affects all iOS users)

**Solutions:**

1. **Installation Education:**
```typescript
function showInstallInstructions() {
  if (detectiOS() && !isInstalled()) {
    showModal({
      title: "Add CANVS to Home Screen",
      steps: [
        "Tap the Share button at the bottom of Safari",
        "Scroll down and tap 'Add to Home Screen'",
        "Tap 'Add' to confirm"
      ],
      whyNeeded: "Required for push notifications and the best experience"
    });
  }
}
```

2. **Feature-Based Degradation:**
```typescript
const features = {
  pushNotifications: isInstalled() && 'PushManager' in window,
  backgroundSync: 'serviceWorker' in navigator && 'sync' in ServiceWorkerRegistration.prototype,
  persistentStorage: 'storage' in navigator && 'persist' in navigator.storage
};

if (features.persistentStorage) {
  await navigator.storage.persist();
}
```

3. **Alternative Engagement for Non-Installed:**
   - Email notifications as fallback
   - SMS notifications for critical updates
   - Clear "install for notifications" prompts

**Reference:**
- [PWA on iOS - Current Status](https://brainhub.eu/library/pwa-on-ios)

---

### 3.2 Push Notification Reliability on iOS

**Problem:**
iOS web push notifications can be unreliable - they may work initially then stop unexpectedly.

**Technical Details:**
- If user doesn't interact with pushes, iOS may stop delivering them
- Service worker listeners may not trigger reliably after device restarts
- Users can become unexpectedly unsubscribed

**Impact:** HIGH
**Likelihood:** MEDIUM

**Solutions:**

1. **Subscription Health Monitoring:**
```typescript
async function checkPushSubscription() {
  const registration = await navigator.serviceWorker.ready;
  const subscription = await registration.pushManager.getSubscription();

  if (subscription) {
    const isValid = await verifySubscription(subscription);
    if (!isValid) {
      await subscription.unsubscribe();
      await subscribeToPush();
    }
  }
}
```

2. **Multi-Channel Fallback:**
   - Email digest for inactive users
   - In-app notification center
   - "Check for updates" manual refresh

---

### 3.3 Media Capture Cross-Browser Issues

**Problem:**
Camera and microphone APIs behave differently across browsers, and codec support varies significantly.

**Technical Details:**
- MediaRecorder uses Opus on Chrome/Firefox, AAC on Safari
- iOS doesn't support WebM container format
- HEIC images from iOS need conversion

**Impact:** MEDIUM
**Likelihood:** HIGH

**Solutions:**

1. **Codec Detection:**
```typescript
function getRecorderMimeType(): string {
  const types = [
    'audio/webm;codecs=opus',
    'audio/mp4',
    'audio/aac'
  ];
  for (const type of types) {
    if (MediaRecorder.isTypeSupported(type)) return type;
  }
  throw new Error('No supported audio format');
}
```

2. **HEIC Conversion:**
```typescript
import heic2any from 'heic2any';

async function processImage(file: File): Promise<Blob> {
  if (file.type === 'image/heic' || file.name.toLowerCase().endsWith('.heic')) {
    return await heic2any({ blob: file, toType: 'image/jpeg', quality: 0.85 });
  }
  return file;
}
```

---

## 4. Spatial Database & Scaling Challenges

### 4.1 Spatial Query Performance at Scale

**Problem:**
ST_DWithin queries can become slow as the posts table grows to millions of rows, even with spatial indexes.

**Performance Benchmarks:**

| Row Count | Indexed Query | Unindexed Query |
|-----------|--------------|-----------------|
| 10,000 | <10ms | 100-500ms |
| 100,000 | 10-50ms | 1-5 seconds |
| 1,000,000 | 50-200ms | 10-60 seconds |

**Impact:** HIGH
**Likelihood:** HIGH (as user base grows)

**Solutions:**

1. **Proper Index Creation:**
```sql
CREATE INDEX CONCURRENTLY idx_place_anchors_location
ON place_anchors USING GIST (location);

CREATE INDEX idx_place_anchors_h3_res8 ON place_anchors (h3_cell_res8);
CREATE INDEX idx_place_anchors_h3_res9 ON place_anchors (h3_cell_res9);

ANALYZE place_anchors;
```

2. **H3 Pre-Filtering (Hybrid Approach):**
```sql
WITH nearby_cells AS (
  SELECT unnest(h3_grid_disk(
    h3_lat_lng_to_cell($1, $2, 8),
    1
  )) AS cell
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

**Reference:**
- [PostGIS Performance Tips](https://postgis.net/docs/performance_tips.html)
- [5 Principles for High-Performance PostGIS Queries](https://medium.com/@cfvandersluijs/5-principles-for-writing-high-performance-queries-in-postgis-bbea3ffb9830)

---

### 4.2 Supabase Realtime Connection Limits

**Problem:**
Supabase Realtime has connection limits per project. Geographic subscriptions multiply connection needs.

**Technical Details:**
- Free tier: 200 concurrent connections
- Pro tier: 500+ connections
- Each user WebSocket counts as a connection
- RLS checks on CDC can cause bottlenecks

**Impact:** HIGH
**Likelihood:** MEDIUM (at scale)

**Solutions:**

1. **H3-Based Channel Segmentation:**
```typescript
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

2. **Public Broadcast Table Without RLS:**
```sql
CREATE TABLE public.post_broadcasts (
  id UUID PRIMARY KEY,
  h3_cell_res8 TEXT NOT NULL,
  preview TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- No RLS = much faster CDC
```

**Reference:**
- [Supabase Realtime Quotas](https://supabase.com/docs/guides/realtime/quotas)

---

## 5. Media Handling Challenges

### 5.1 Image Compression Quality vs Size

**Problem:**
Finding the right balance between image quality and file size, especially with various source formats.

**Impact:** MEDIUM
**Likelihood:** HIGH

**Solutions:**

```typescript
import imageCompression from 'browser-image-compression';

async function compressImage(file: File): Promise<Blob> {
  const options = {
    maxSizeMB: 0.8,
    maxWidthOrHeight: 1920,
    useWebWorker: true,
    fileType: 'image/webp',
    initialQuality: 0.85
  };
  return await imageCompression(file, options);
}
```

---

### 5.2 Upload Reliability on Poor Networks

**Problem:**
Mobile users often have unstable connections. Uploads can fail partway through.

**Impact:** MEDIUM
**Likelihood:** HIGH

**Solutions:**

1. **Retry with Exponential Backoff:**
```typescript
async function uploadWithRetry(file: Blob, uploadUrl: string, maxRetries = 3): Promise<void> {
  let attempt = 0;
  while (attempt < maxRetries) {
    try {
      const response = await fetch(uploadUrl, { method: 'PUT', body: file });
      if (response.ok) return;
      throw new Error(`Upload failed: ${response.status}`);
    } catch (error) {
      attempt++;
      if (attempt >= maxRetries) throw error;
      await new Promise(r => setTimeout(r, 1000 * Math.pow(2, attempt)));
    }
  }
}
```

2. **Offline Queue with IndexedDB:**
```typescript
class UploadQueue {
  async enqueue(upload: PendingUpload) {
    await idb.set('upload_queue', [...this.queue, upload]);
    if (navigator.onLine) this.processQueue();
  }
}
window.addEventListener('online', () => uploadQueue.processQueue());
```

---

### 5.3 Cloudflare R2 CORS Configuration

**Problem:**
Presigned URL uploads to R2 require proper CORS configuration. Misconfiguration causes upload failures.

**Impact:** MEDIUM
**Likelihood:** HIGH (during setup)

**Solutions:**

```json
{
  "CORSRules": [{
    "AllowedOrigins": ["https://canvs.app", "http://localhost:3000"],
    "AllowedMethods": ["GET", "PUT", "HEAD"],
    "AllowedHeaders": ["content-type", "content-length"],
    "ExposeHeaders": ["ETag"],
    "MaxAgeSeconds": 3600
  }]
}
```

**Reference:**
- [R2 Presigned URLs](https://developers.cloudflare.com/r2/api/s3/presigned-urls/)

---

## 6. Push Notifications & Real-time Challenges

### 6.1 Web Push Subscription Lifecycle

**Problem:**
Web push subscriptions can expire, become invalid, or fail silently.

**Impact:** HIGH
**Likelihood:** HIGH

**Solutions:**

1. **Server-Side 410 Handling:**
```typescript
import webpush from 'web-push';

async function sendNotification(subscription: PushSubscription, payload: object) {
  try {
    await webpush.sendNotification(subscription, JSON.stringify(payload));
  } catch (error) {
    if (error.statusCode === 410 || error.statusCode === 404) {
      await db.from('push_subscriptions').delete().eq('endpoint', subscription.endpoint);
    }
    throw error;
  }
}
```

2. **Periodic Subscription Validation:**
```typescript
async function periodicSubscriptionCheck() {
  const subscription = await getPushSubscription();
  if (subscription) {
    await fetch('/api/push/heartbeat', {
      method: 'POST',
      body: JSON.stringify({ endpoint: subscription.endpoint, lastActive: Date.now() })
    });
  }
}
```

---

## 7. Security & Anti-Spoofing Challenges

### 7.1 GPS Spoofing in Web Context

**Problem:**
Web apps cannot reliably detect GPS spoofing. Users can use browser extensions, developer tools, or modified browsers to fake their location.

**Impact:** HIGH
**Likelihood:** HIGH (for motivated bad actors)

**Critical Insight:** Accept that web apps cannot prevent spoofing. Design mitigations that reduce impact rather than attempting perfect prevention.

**Solutions:**

1. **Rate Limiting:**
```typescript
async function canUserCreatePost(userId: string): Promise<boolean> {
  const recentPosts = await db.from('posts')
    .select('*')
    .eq('author_id', userId)
    .gte('created_at', new Date(Date.now() - 86400000).toISOString());

  const isNewAccount = await isAccountNew(userId);
  const limit = isNewAccount ? 5 : 50;
  return recentPosts.length < limit;
}
```

2. **Behavioral Analysis:**
```typescript
async function detectSuspiciousBehavior(userId: string, newPosition: Position): Promise<RiskLevel> {
  const recentPositions = await getRecentPositions(userId);
  const lastPosition = recentPositions[0];

  if (lastPosition) {
    const distance = haversineDistance(lastPosition, newPosition);
    const timeDiff = (Date.now() - lastPosition.timestamp) / 1000 / 3600;
    const speedKmh = distance / timeDiff;
    if (speedKmh > 1000) return 'high'; // Faster than a jet
  }
  return 'low';
}
```

3. **Trust Scoring:**
```typescript
function calculateTrustScore(factors: TrustFactors): number {
  let score = 0.5;
  score += Math.min(factors.accountAge / 365, 0.2);
  score += Math.min(factors.postsCreated / 100, 0.15);
  score -= (factors.postsReported / factors.postsCreated) * 0.3;
  if (factors.verifiedEmail) score += 0.05;
  if (factors.verifiedPhone) score += 0.1;
  return Math.max(0, Math.min(1, score));
}
```

**Reference:**
- [Location Spoofing Detection](https://www.incognia.com/solutions/detecting-location-spoofing)

---

### 7.2 Magic Link Security

**Problem:**
Magic links can be intercepted, reused, or brute-forced if not properly secured.

**Impact:** HIGH
**Likelihood:** LOW (with proper implementation)

**Solutions:**

```typescript
import crypto from 'crypto';

function generateMagicToken(): string {
  return crypto.randomBytes(32).toString('base64url');
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

async function verifyMagicLink(token: string): Promise<string | null> {
  const tokenHash = hashToken(token);
  const { data: link } = await db.from('magic_links')
    .select('*')
    .eq('token_hash', tokenHash)
    .eq('used', false)
    .gte('expires_at', new Date().toISOString())
    .single();

  if (!link) return null;

  await db.from('magic_links').update({ used: true }).eq('id', link.id);
  return link.email;
}
```

---

## 8. Content Moderation Challenges

### 8.1 OpenAI Moderation API Limitations

**Problem:**
The OpenAI Moderation API, while ~95% accurate overall, has limitations in context understanding and can produce false positives.

**Accuracy by Category:**
- Sexual content: 96.5%
- Violence: 89%
- Harassment: 91%
- Self-harm: 92%

**Impact:** MEDIUM
**Likelihood:** MEDIUM

**Solutions:**

1. **Threshold Tuning:**
```typescript
function evaluateModeration(result: ModerationResult): ModerationDecision {
  const thresholds = {
    hate: 0.7,
    harassment: 0.6,
    'self-harm': 0.3,  // Lower threshold, safety critical
    sexual: 0.5,
    violence: 0.6
  };

  const flaggedCategories = Object.entries(result.categoryScores)
    .filter(([category, score]) => score >= thresholds[category])
    .map(([category]) => category);

  if (flaggedCategories.length === 0) return { action: 'approve' };
  if (flaggedCategories.some(c => c === 'self-harm' || result.categoryScores[c] > 0.9)) {
    return { action: 'reject', reason: flaggedCategories };
  }
  return { action: 'review', reason: flaggedCategories };
}
```

2. **Human Review Queue for Edge Cases**

**Reference:**
- [OpenAI Moderation API](https://platform.openai.com/docs/guides/moderation)

---

## 9. AR/VPS Integration Challenges (MVP v2)

### 9.1 8th Wall Deprecation

**Problem:**
Niantic announced 8th Wall will wind down, with VPS features unavailable after February 2027.

**Impact:** HIGH
**Likelihood:** CERTAIN

**Solutions:**

1. **Native App Path:**
   - Plan for Capacitor or React Native wrapper
   - Use ARCore Geospatial API (native-only)
   - Maintain web PWA for viewing, native for AR creation

2. **Hybrid Architecture:**
```
┌─────────────────────────────────────────────────────────────┐
│                  CANVS Content Platform                      │
└─────────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│    Web PWA          │       │   Native App        │
│  (GPS + viewing)    │       │  (GPS + VPS + AR)   │
└─────────────────────┘       └─────────────────────┘
```

---

### 9.2 ARCore Geospatial API Limitations

**Problem:**
ARCore Geospatial API provides excellent accuracy but has coverage and device limitations.

**Technical Details:**
- VPS coverage limited to Street View areas (93+ countries)
- API quotas: 1,000 sessions/min, 100k requests/min
- Accuracy: ~5m typical, often <1m with VPS
- Native app only (no web support)

**Impact:** MEDIUM
**Likelihood:** HIGH (coverage gaps)

**Solutions:**

1. **Graceful Fallback to GPS:**
```typescript
interface PlaceAnchor {
  id: string;
  gps_location: Geography;
  vps_anchor?: { latitude: number; longitude: number; altitude: number; heading: number; };
  anchor_type: 'gps' | 'vps' | 'hybrid';
}
```

**Reference:**
- [ARCore Geospatial API](https://developers.google.com/ar/develop/geospatial)

---

## 10. Infrastructure & Cost Challenges

### 10.1 Cost Scaling Projections

| Users | Storage | Realtime | Database | Est. Monthly |
|-------|---------|----------|----------|-------------|
| 1,000 | 10GB | 100 conn | Free | ~$50 |
| 10,000 | 100GB | 1,000 conn | Pro | ~$150 |
| 100,000 | 1TB | 10,000 conn | Team | ~$1,500 |

**Solutions:**
- Aggressive image compression (<500KB)
- Content expiration for old posts
- CDN caching optimization
- R2 for media (zero egress costs)

---

## 11. Risk Matrix Summary

| Challenge | Impact | Likelihood | Priority |
|-----------|--------|------------|----------|
| GPS accuracy in urban areas | HIGH | HIGH | **P0** |
| iOS PWA push requirements | HIGH | CERTAIN | **P0** |
| Location spoofing (web) | HIGH | HIGH | **P1** |
| Supabase realtime limits | HIGH | MEDIUM | **P1** |
| 8th Wall deprecation (v2) | HIGH | CERTAIN | **P1** |
| Indoor positioning | HIGH | HIGH | **P2** |
| Content moderation accuracy | MEDIUM | MEDIUM | **P2** |
| GPS battery drain | MEDIUM | HIGH | **P2** |
| Upload reliability | MEDIUM | HIGH | **P2** |
| Database scaling | HIGH | MEDIUM | **P2** |

---

## 12. Recommended Mitigations Priority

### Phase 1: MVP Foundation (Must Have)

1. **Accuracy-aware UX**
   - Display accuracy circles on map
   - Gate posting on accuracy thresholds
   - Provide location improvement guidance

2. **iOS PWA Installation Flow**
   - Pre-permission education modal
   - Clear installation instructions
   - Feature degradation for non-installed

3. **Basic Anti-Abuse**
   - Rate limiting (per user, per location)
   - Basic behavioral checks
   - User reporting system

4. **Content Moderation Pipeline**
   - OpenAI Moderation API integration
   - Human review queue for edge cases

### Phase 2: Robustness (Should Have)

5. **Upload Reliability** - Retry logic, offline queue
6. **Database Optimization** - H3 hybrid indexing
7. **Push Notification Management** - Subscription health monitoring

### Phase 3: Scale Preparation (Nice to Have)

8. **Trust System** - Account age weighting, behavior scoring
9. **Advanced Moderation** - Location-sensitive policies
10. **Native App Planning** - ARCore integration design

---

## 13. Potential Show-Stoppers

### Critical Issues That Could Block Launch

1. **GPS accuracy too poor for core UX**
   - Mitigation: Frame as "works best outdoors", accept approximate locations
   - Fallback: Venue-based anchoring

2. **iOS push notification adoption too low**
   - Mitigation: Email notifications, in-app notifications
   - Fallback: Consider native wrapper earlier

3. **Content moderation failures**
   - Mitigation: Conservative thresholds, rapid response plan
   - Fallback: Manual approval for new users

### Issues That Should NOT Be Show-Stoppers

1. **Location spoofing** - Accept it, rate limit, trust score
2. **Indoor positioning** - Feature limitation, not blocker
3. **Perfect accuracy** - 50m acceptable for MVP

---

## References

### GPS & Geolocation
- [Google 3D Mapping Corrections](https://www.gpsworld.com/google-to-improve-urban-gps-accuracy-for-apps/)
- [Sidewalk Matching Research](https://satellite-navigation.springeropen.com/articles/10.1186/s43020-025-00159-8)

### PWA & Web Platform
- [PWA on iOS - Current Status 2025](https://brainhub.eu/library/pwa-on-ios)
- [MDN: Progressive Web Apps](https://developer.mozilla.org/docs/Web/Progressive_web_apps)

### Database & Spatial
- [PostGIS Performance Tips](https://postgis.net/docs/performance_tips.html)
- [Supabase Realtime Quotas](https://supabase.com/docs/guides/realtime/quotas)

### Security
- [Location Spoofing Detection](https://www.incognia.com/solutions/detecting-location-spoofing)
- [GPS Spoofing Defenses](https://www.okta.com/identity-101/gps-spoofing/)

### Content Moderation
- [OpenAI Moderation API](https://platform.openai.com/docs/guides/moderation)

### AR/VPS
- [ARCore Geospatial API](https://developers.google.com/ar/develop/geospatial)

### Media & Storage
- [Cloudflare R2 Presigned URLs](https://developers.cloudflare.com/r2/api/s3/presigned-urls/)

---

*Document generated: January 2026*
*Research conducted via: Claude Flow multi-agent orchestration*
*Last reviewed: January 2026*
*Next review: Prior to development kickoff*
