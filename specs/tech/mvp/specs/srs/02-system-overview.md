# 2. System Overview

> [← Back to Index](./index.md) | [← Previous: Introduction](./01-introduction.md)

## 2.1 Product Vision

CANVS is a persistent, location-anchored social layer that transforms physical spaces into living canvases for human expression. Unlike ephemeral social platforms, CANVS content remains anchored to places, creating a digital archaeology of human experience.

**Vision Statement:** "Every place has a story. CANVS lets you see it."

## 2.2 System Context

```
┌─────────────────────────────────────────────────────────────────┐
│                         CANVS ECOSYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐        │
│  │   Mobile    │     │   Desktop   │     │   Tablet    │        │
│  │   Browser   │     │   Browser   │     │   Browser   │        │
│  └──────┬──────┘     └──────┬──────┘     └──────┬──────┘        │
│         │                   │                   │               │
│         └───────────────────┼───────────────────┘               │
│                             ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Next.js 15 PWA Frontend                    │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     │    │
│  │  │ Map Mode│  │Timeline │  │ Create  │  │ Profile │     │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘     │    │
│  └──────────────────────────┬──────────────────────────────┘    │
│                             │                                   │
│                             ▼                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   Supabase Backend                      │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐               │    │
│  │  │   Auth   │  │ Database │  │  Storage │               │    │
│  │  │(GoTrue)  │  │(Postgres)│  │   (S3)   │               │    │
│  │  └──────────┘  └──────────┘  └──────────┘               │    │
│  │  ┌──────────────────────────────────────────┐           │    │
│  │  │         Edge Functions (Deno)             │          │    │
│  │  └──────────────────────────────────────────┘           │    │
│  └──────────────────────────┬──────────────────────────────┘    │
│                             │                                   │
│         ┌───────────────────┼───────────────────┐               │
│         ▼                   ▼                   ▼               │
│  ┌───────────┐       ┌───────────┐       ┌───────────┐          │
│  │ OpenAI API│       │Cloudflare │       │  MapLibre │          │
│  │(Moderation│       │    R2     │       │  Tiles    │          │
│  │ + AI)     │       │ (Media)   │       │           │          │
│  └───────────┘       └───────────┘       └───────────┘          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 2.3 User Classes and Characteristics

| User Class | Description | Technical Proficiency | Primary Use |
|------------|-------------|----------------------|-------------|
| **Explorer** | Passive consumer browsing nearby content | Low | Discovering content on map |
| **Creator** | Active user posting content to places | Medium | Creating and sharing posts |
| **Curator** | Power user organizing/moderating content | High | Community management |
| **Administrator** | Platform operator | High | System configuration |

## 2.4 Operating Environment

### 2.4.1 Supported Browsers

| Browser | Minimum Version | Geolocation | Full Support |
|---------|-----------------|-------------|--------------|
| Chrome (Android) | 80+ | ✅ | ✅ |
| Safari (iOS) | 14+ | ✅ | ✅ |
| Firefox | 78+ | ✅ | ✅ |
| Edge | 88+ | ✅ | ✅ |
| Samsung Internet | 12+ | ✅ | ✅ |

### 2.4.2 Device Requirements

| Requirement | Specification |
|-------------|---------------|
| **GPS** | Required for content creation and discovery |
| **Camera** | Required for photo posts |
| **Network** | 3G minimum, 4G/WiFi recommended |
| **Storage** | 50MB for PWA cache |

## 2.5 Design and Implementation Constraints

| Constraint | Rationale |
|------------|-----------|
| **PWA-first architecture** | Maximum reach without app store friction |
| **No native push on iOS** | iOS PWA limitation—use email digests |
| **GPS accuracy variance** | 3-100m depending on environment |
| **Supabase free tier limits** | 500MB database, 1GB storage for MVP |
| **GDPR/CCPA compliance** | Location data is PII—strict handling required |

## 2.6 Assumptions and Dependencies

### 2.6.1 Assumptions

1. Users will grant location permission for core functionality
2. Modern browser adoption >95% of target audience
3. OpenAI API availability for AI features
4. Supabase service reliability >99.9%

### 2.6.2 External Dependencies

| Dependency | Purpose | Fallback |
|------------|---------|----------|
| Supabase | Backend infrastructure | Self-hosted PostgreSQL |
| OpenAI API | AI moderation, search | Rule-based moderation |
| MapLibre | Map rendering | Leaflet.js |
| Cloudflare R2 | Media storage | Supabase Storage |

---

> [Next: Functional Requirements →](./03-functional-requirements.md)
