# 7. API Specifications

> [← Back to Index](./index.md) | [← Previous: Authentication & User Account System](./06-authentication-user-account-system.md)

## 7.1 API Architecture

**Base URL:** `https://api.canvs.app/v1`

**Authentication:** Bearer token (Supabase JWT)

**Format:** JSON (application/json)

## 7.2 Endpoints

### 7.2.1 Posts API

#### GET /posts/nearby

Fetch posts near a location.

**Request:**
```http
GET /posts/nearby?lat=37.7749&lng=-122.4194&radius=5000&limit=20&offset=0
Authorization: Bearer <jwt_token>
```

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| lat | number | Yes | Latitude (-90 to 90) |
| lng | number | Yes | Longitude (-180 to 180) |
| radius | number | No | Radius in meters (default: 5000, max: 50000) |
| limit | number | No | Results per page (default: 20, max: 100) |
| offset | number | No | Pagination offset |
| filter | string | No | Filter type: 'all', 'following', 'photos' |

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "content": "Amazing view from here!",
      "media_url": "https://cdn.canvs.app/posts/xxx_full.webp",
      "media_thumbnail_url": "https://cdn.canvs.app/posts/xxx_thumb.webp",
      "created_at": "2025-01-15T10:30:00Z",
      "author": {
        "id": "uuid",
        "username": "johndoe",
        "avatar_url": "https://cdn.canvs.app/avatars/xxx.webp",
        "is_verified": false
      },
      "place": {
        "id": "uuid",
        "lat": 37.7749,
        "lng": -122.4194,
        "name": "Golden Gate Park",
        "distance_meters": 150
      },
      "engagement": {
        "reaction_count": 24,
        "comment_count": 8,
        "user_reaction": "❤️"
      },
      "feed_score": 0.847
    }
  ],
  "pagination": {
    "offset": 0,
    "limit": 20,
    "has_more": true
  }
}
```

#### POST /posts

Create a new post.

**Request:**
```http
POST /posts
Authorization: Bearer <jwt_token>
Content-Type: multipart/form-data

{
  "content": "Beautiful sunset! 🌅",
  "lat": 37.7749,
  "lng": -122.4194,
  "accuracy": 8.5,
  "place_name": "Pier 39",
  "media": <file>
}
```

**Validation Rules (Pseudo Code):**

```
FUNCTION validatePostRequest(request):
    errors = []

    // Content validation
    IF request.content IS NULL AND request.media IS NULL THEN
        errors.add("Post must have content or media")
    END IF

    IF request.content IS NOT NULL THEN
        IF length(request.content) > 500 THEN
            errors.add("Content exceeds 500 characters")
        END IF
    END IF

    // Location validation
    IF request.lat IS NULL OR request.lng IS NULL THEN
        errors.add("Location is required")
    ELSE
        IF request.lat < -90 OR request.lat > 90 THEN
            errors.add("Invalid latitude")
        END IF
        IF request.lng < -180 OR request.lng > 180 THEN
            errors.add("Invalid longitude")
        END IF
    END IF

    IF request.accuracy > 100 THEN
        errors.add("Location accuracy too low for posting")
    END IF

    // Media validation
    IF request.media IS NOT NULL THEN
        IF request.media.size > 10 * 1024 * 1024 THEN
            errors.add("Media file too large (max 10MB)")
        END IF

        allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/heic']
        IF request.media.type NOT IN allowedTypes THEN
            errors.add("Unsupported media type")
        END IF
    END IF

    IF errors.length > 0 THEN
        THROW ValidationError(errors)
    END IF

    RETURN true
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "content": "Beautiful sunset! 🌅",
    "media_url": "https://cdn.canvs.app/posts/xxx_full.webp",
    "created_at": "2025-01-15T18:45:00Z",
    "place": {
      "id": "uuid",
      "lat": 37.7749,
      "lng": -122.4194,
      "name": "Pier 39"
    }
  }
}
```

#### DELETE /posts/:id

Delete a post (soft delete).

**Request:**
```http
DELETE /posts/uuid
Authorization: Bearer <jwt_token>
```

**Authorization (Pseudo Code):**

```
FUNCTION authorizePostDeletion(userId, postId):
    post = database.posts.findById(postId)

    IF post IS NULL THEN
        THROW NotFoundError("Post not found")
    END IF

    IF post.user_id != userId THEN
        user = database.users.findById(userId)
        IF NOT user.is_admin THEN
            THROW ForbiddenError("Cannot delete others' posts")
        END IF
    END IF

    RETURN true
```

### 7.2.2 Reactions API

#### POST /posts/:postId/reactions

Add or toggle reaction.

**Request:**
```http
POST /posts/uuid/reactions
Authorization: Bearer <jwt_token>

{
  "emoji": "❤️"
}
```

**Response:**
```json
{
  "data": {
    "action": "added",
    "emoji": "❤️",
    "reaction_count": 25
  }
}
```

### 7.2.3 Comments API

#### GET /posts/:postId/comments

Get comments for a post.

**Request:**
```http
GET /posts/uuid/comments?limit=20&offset=0
Authorization: Bearer <jwt_token>
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "content": "Great photo!",
      "created_at": "2025-01-15T19:00:00Z",
      "author": {
        "id": "uuid",
        "username": "janedoe",
        "avatar_url": "https://cdn.canvs.app/avatars/xxx.webp"
      }
    }
  ],
  "pagination": {
    "offset": 0,
    "limit": 20,
    "total": 8,
    "has_more": false
  }
}
```

#### POST /posts/:postId/comments

Add a comment.

**Request:**
```http
POST /posts/uuid/comments
Authorization: Bearer <jwt_token>

{
  "content": "Love this place!"
}
```

### 7.2.4 Places API

#### GET /places/:id

Get place details.

**Request:**
```http
GET /places/uuid
Authorization: Bearer <jwt_token>
```

**Response:**
```json
{
  "data": {
    "id": "uuid",
    "lat": 37.7749,
    "lng": -122.4194,
    "name": "Golden Gate Park",
    "address": "501 Stanyan St, San Francisco, CA",
    "post_count": 156,
    "follower_count": 42,
    "is_following": true,
    "recent_posts": [...]
  }
}
```

#### POST /places/:id/follow

Follow a place.

**Request:**
```http
POST /places/uuid/follow
Authorization: Bearer <jwt_token>
```

#### DELETE /places/:id/follow

Unfollow a place.

**Request:**
```http
DELETE /places/uuid/follow
Authorization: Bearer <jwt_token>
```

### 7.2.5 User API

#### GET /users/me

Get current user profile.

#### PATCH /users/me

Update current user profile.

**Request:**
```http
PATCH /users/me
Authorization: Bearer <jwt_token>

{
  "display_name": "John Doe",
  "bio": "Explorer 🌍",
  "reality_filter_level": 50
}
```

#### GET /users/:username

Get user profile by username.

## 7.3 Error Responses

**Error Format:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "content",
        "message": "Content exceeds 500 characters"
      }
    ]
  }
}
```

**Error Codes:**

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Request validation failed |
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource already exists |
| `RATE_LIMITED` | 429 | Too many requests |
| `MODERATION_BLOCKED` | 403 | Content blocked by moderation |
| `LOCATION_REQUIRED` | 400 | Location accuracy too low |
| `SERVER_ERROR` | 500 | Internal server error |

## 7.4 Rate Limiting

| Endpoint Category | Rate Limit | Window |
|-------------------|------------|--------|
| **Read (GET)** | 100 requests | Per minute |
| **Write (POST/PATCH)** | 30 requests | Per minute |
| **Media Upload** | 10 requests | Per minute |
| **Auth** | 5 requests | Per 15 minutes |

**Rate Limit Headers:**
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1705340400
```

---

> [Next: Security Requirements →](./08-security-requirements.md)
