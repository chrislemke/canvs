# 8. Security Requirements

> [← Back to Index](./index.md) | [← Previous: API Specifications](./07-api-specifications.md)

## 8.1 Data Security

### 8.1.1 Data Classification

| Classification | Data Types | Protection Level |
|----------------|------------|------------------|
| **Public** | Usernames, public posts | Standard encryption |
| **Internal** | Engagement metrics, place data | Access-controlled |
| **Confidential** | Email addresses, settings | Encrypted, access-logged |
| **Restricted** | Auth tokens, location history | Encrypted, minimal retention |

### 8.1.2 Encryption

| Data State | Method |
|------------|--------|
| **At Rest** | AES-256 (Supabase managed) |
| **In Transit** | TLS 1.3 |
| **Passwords** | N/A (passwordless auth) |
| **API Keys** | Environment variables, secrets manager |

## 8.2 Location Privacy

**Location Data Handling:**

```javascript
// Location precision reduction for privacy
function reduceLocationPrecision(lat, lng, level = 'display') {
  const precisionLevels = {
    storage: 6,    // ~10cm precision (for anchoring)
    display: 4,    // ~10m precision (for showing to others)
    export: 2      // ~1km precision (for data export)
  };

  const decimals = precisionLevels[level];

  return {
    lat: Number(lat.toFixed(decimals)),
    lng: Number(lng.toFixed(decimals))
  };
}

// Location anonymization for aggregated data
function anonymizeLocation(lat, lng) {
  // Snap to H3 resolution 6 (~3km hexagons)
  const h3Index = h3.latLngToCell(lat, lng, 6);
  const [centerLat, centerLng] = h3.cellToLatLng(h3Index);

  return { lat: centerLat, lng: centerLng };
}
```

**Privacy Controls:**

| Control | Default | User Configurable |
|---------|---------|-------------------|
| Show exact location to others | No | No |
| Show approximate location | Yes | Yes |
| Include location in export | Anonymized | Yes (exact opt-in) |
| Retain location history | 30 days | Yes (can delete) |

## 8.3 Content Moderation Guardrails

**Moderation Categories:**

| Category | Threshold | Action |
|----------|-----------|--------|
| Hate speech | 0.3 | Auto-block |
| Violence | 0.4 | Auto-block |
| Sexual content | 0.3 | Auto-block |
| Self-harm | 0.2 | Auto-block + alert |
| Harassment | 0.5 | Queue for review |
| Spam | 0.7 | Queue for review |

**Appeal Process (Pseudo Code):**

```
FUNCTION handleModerationAppeal(postId, userId, reason):
    post = database.posts.findById(postId)

    IF post.user_id != userId THEN
        THROW ForbiddenError("Can only appeal own posts")
    END IF

    IF post.appeal_count >= 2 THEN
        THROW RateLimitError("Maximum appeals reached")
    END IF

    // Create appeal record
    appeal = database.appeals.create({
        post_id: postId,
        user_id: userId,
        reason: reason,
        status: 'pending',
        created_at: now()
    })

    // Queue for human review
    queue.add('moderation_appeal', {
        appeal_id: appeal.id,
        priority: 'high'
    })

    // Update post
    database.posts.update(postId, {
        appeal_count: post.appeal_count + 1,
        last_appeal_at: now()
    })

    RETURN appeal
```

## 8.4 Anti-Abuse Measures

### 8.4.1 Location Spoofing Prevention

```javascript
// Location validation
async function validateLocation(claimedLocation, userContext) {
  const checks = [];

  // 1. Check for impossible movement
  if (userContext.lastKnownLocation) {
    const distance = haversineDistance(
      userContext.lastKnownLocation,
      claimedLocation
    );
    const timeDiff = Date.now() - userContext.lastLocationTime;
    const speed = distance / (timeDiff / 1000); // meters per second

    if (speed > 300) { // >1000 km/h is impossible
      checks.push({
        type: 'impossible_speed',
        passed: false,
        message: 'Location change too fast'
      });
    }
  }

  // 2. Check accuracy plausibility
  if (claimedLocation.accuracy < 1) {
    checks.push({
      type: 'suspicious_accuracy',
      passed: false,
      message: 'Accuracy too precise'
    });
  }

  // 3. Check for known spoofing signatures
  // (specific patterns from spoofing apps)

  // 4. IP geolocation sanity check
  const ipLocation = await getIpGeolocation(userContext.ip);
  if (ipLocation) {
    const ipDistance = haversineDistance(ipLocation, claimedLocation);
    if (ipDistance > 500000) { // >500km discrepancy
      checks.push({
        type: 'ip_mismatch',
        passed: false,
        message: 'Location does not match network'
      });
    }
  }

  return {
    valid: checks.every(c => c.passed),
    checks,
    trustScore: calculateTrustScore(checks)
  };
}
```

### 8.4.2 Spam Prevention

| Measure | Limit |
|---------|-------|
| Posts per hour | 10 |
| Comments per hour | 30 |
| Reactions per minute | 20 |
| New accounts posting delay | 5 minutes |
| Duplicate content detection | Reject if >80% similar within 24h |

## 8.5 GDPR/CCPA Compliance

**Data Subject Rights:**

| Right | Implementation |
|-------|----------------|
| **Access** | Export all user data as JSON |
| **Rectification** | Edit profile, delete individual posts |
| **Erasure** | Full account deletion within 30 days |
| **Portability** | Download all data in machine-readable format |
| **Restriction** | Pause account without deletion |

**Data Export Format:**

```json
{
  "export_date": "2025-01-15T00:00:00Z",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "display_name": "John Doe",
    "created_at": "2024-06-01T00:00:00Z"
  },
  "posts": [...],
  "comments": [...],
  "reactions": [...],
  "places_followed": [...],
  "settings": {...},
  "location_history": [
    {
      "lat": 37.77,
      "lng": -122.42,
      "timestamp": "2025-01-10T12:00:00Z"
    }
  ]
}
```

---

> [Next: Non-Functional Requirements →](./09-non-functional-requirements.md)
