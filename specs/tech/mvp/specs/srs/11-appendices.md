# 11. Appendices

> [← Back to Index](./index.md) | [← Previous: Technology Stack & Hosting](./10-technology-stack-hosting.md)

## Appendix A: API Error Reference

| Error Code | HTTP | Description | Resolution |
|------------|------|-------------|------------|
| `AUTH_INVALID_TOKEN` | 401 | JWT is invalid or expired | Re-authenticate |
| `AUTH_MISSING_TOKEN` | 401 | No authorization header | Include Bearer token |
| `FORBIDDEN_RESOURCE` | 403 | No access to resource | Check permissions |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests | Wait and retry |
| `VALIDATION_FAILED` | 400 | Invalid request data | Check error details |
| `LOCATION_TOO_INACCURATE` | 400 | GPS accuracy >100m | Move to better location |
| `CONTENT_BLOCKED` | 403 | Moderation rejection | Edit content or appeal |
| `RESOURCE_NOT_FOUND` | 404 | Entity doesn't exist | Check ID |
| `DUPLICATE_RESOURCE` | 409 | Already exists | Use existing resource |
| `INTERNAL_ERROR` | 500 | Server error | Report to support |

## Appendix B: Glossary

| Term | Definition |
|------|------------|
| **Anchor** | Geographic point to which content is attached |
| **Bubble** | Cluster of posts at the same location |
| **Drop** | Time-limited ephemeral content (future) |
| **H3** | Hexagonal hierarchical spatial index system |
| **MPI** | Meaningful Place Interaction |
| **Pin** | Individual piece of location-anchored content |
| **Place** | Named location with associated content |
| **Portal** | Link between two physical locations (future) |
| **Reality Filter** | AI-powered content visibility filter |
| **Trail** | Connected sequence of locations (future) |
| **VPS** | Visual Positioning System |

## Appendix C: Design Tokens Reference

```css
/* Complete Design Token Export */
:root {
  /* Colors */
  --color-alabaster: #f0efea;
  --color-ink: #1a1a18;
  --color-terracotta: #d97757;
  --color-sage: #8da399;
  --color-highlighter: #eedc5b;

  /* Typography */
  --font-serif: "Newsreader", Georgia, serif;
  --font-sans: "Inter", -apple-system, sans-serif;
  --font-size-xs: 0.75rem;
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.125rem;
  --font-size-xl: 1.25rem;
  --font-size-2xl: 1.5rem;
  --font-size-3xl: 2rem;

  /* Spacing */
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-5: 1.25rem;
  --space-6: 1.5rem;
  --space-8: 2rem;
  --space-10: 2.5rem;
  --space-12: 3rem;

  /* Borders */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(26, 26, 24, 0.05);
  --shadow-md: 0 4px 6px rgba(26, 26, 24, 0.07);
  --shadow-lg: 0 10px 25px rgba(26, 26, 24, 0.1);

  /* Animation */
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);

  /* Z-Index */
  --z-dropdown: 100;
  --z-modal: 200;
  --z-toast: 300;
  --z-tooltip: 400;
}
```

---

**Document Control:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | January 2025 | CANVS Team | Initial MVP specification |

---

*This document is the authoritative reference for CANVS MVP development. All implementation decisions should align with these specifications.*
