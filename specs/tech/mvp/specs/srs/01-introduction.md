# 1. Introduction

> [← Back to Index](./index.md)

## 1.1 Purpose

This Software Requirements Specification (SRS) defines the complete functional, technical, and design requirements for CANVS—a location-based social platform that enables users to discover, create, and share content anchored to physical places. This document serves as the definitive reference for the development team to implement the Minimum Viable Product (MVP).

## 1.2 Scope

### 1.2.1 In-Scope (MVP)

| Feature Category | Included Components |
|------------------|---------------------|
| **Map Mode** | Interactive map view, place discovery, clustering, geolocation tracking |
| **Timeline Mode** | Chronological feed of nearby content, filters, infinite scroll |
| **Post Creation** | Text, photo, emoji reactions, location anchoring |
| **User Accounts** | Email magic link auth, Google OAuth, Apple Sign-In, profile management |
| **Core Interactions** | View posts, react with emojis, comment on posts, follow places |
| **AI Features** | Reality Filter (content filtering), AI moderation, semantic search |
| **Notifications** | In-app notifications, email digests |

### 1.2.2 Out-of-Scope (Future Phases)

| Feature Category | Deferred Components |
|------------------|---------------------|
| **AR Mode** | WebXR camera overlay, 3D object placement, VPS anchoring |
| **Time Capsules** | Future-dated content, group unlocking |
| **Trails** | Connected location narratives |
| **Portals** | Cross-location linking |
| **Drops** | Time-limited ephemeral content |
| **Push Notifications** | Native push (requires native app wrapper for iOS) |
| **Monetization** | Premium features, business accounts |

## 1.3 Definitions, Acronyms, and Abbreviations

### 1.3.1 Domain Terms

| Term | Definition |
|------|------------|
| **Pin** | A piece of content (post) anchored to a specific geographic location |
| **Bubble** | A clustered group of pins at the same or nearby location |
| **Place Anchor** | A persistent geographic point (lat/lng + H3 index) to which content is attached |
| **Reality Filter** | AI-powered content visibility filter based on user preferences |
| **MPI** | Meaningful Place Interaction—the North Star engagement metric |
| **H3 Index** | Uber's hierarchical hexagonal spatial indexing system |
| **Geofence** | Virtual boundary around a geographic point for triggering actions |

### 1.3.2 Technical Acronyms

| Acronym | Expansion |
|---------|-----------|
| **PWA** | Progressive Web Application |
| **VPS** | Visual Positioning System (not Virtual Private Server) |
| **SLAM** | Simultaneous Localization and Mapping |
| **PostGIS** | PostgreSQL extension for geographic objects |
| **JWT** | JSON Web Token |
| **TOTP** | Time-based One-Time Password |
| **RLS** | Row-Level Security (PostgreSQL) |
| **CDN** | Content Delivery Network |

## 1.4 References

| Document | Description |
|----------|-------------|
| `vision/product_vision_paper.md` | Product vision and strategic direction |
| `specs/tech/mvp/specs/tech_specs.md` | Technical architecture specifications |
| `specs/tech/mvp/specs/challenges.md` | Technical challenges and mitigations |
| `specs/tech/mvp/specs/ai_features.md` | AI feature specifications |
| `research/gps_precision/intro.md` | GPS and positioning research |

## 1.5 Document Conventions

- **MUST** / **SHALL**: Mandatory requirement
- **SHOULD**: Strongly recommended
- **MAY**: Optional enhancement
- `code formatting`: Technical identifiers, code, or commands
- **Bold**: Important terms or emphasis

---

> [Next: System Overview →](./02-system-overview.md)
