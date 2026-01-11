# 10. Technology Stack & Hosting

> [← Back to Index](./index.md) | [← Previous: Non-Functional Requirements](./09-non-functional-requirements.md)

## 10.1 Frontend Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Framework** | Next.js | 15.x | React framework with App Router |
| **Language** | TypeScript | 5.x | Type safety |
| **Styling** | Tailwind CSS | 3.x | Utility-first CSS |
| **State** | Zustand | 4.x | Client state management |
| **Data Fetching** | TanStack Query | 5.x | Server state, caching |
| **Maps** | MapLibre GL JS | 4.x | Interactive maps |
| **Forms** | React Hook Form | 7.x | Form validation |
| **Animation** | Framer Motion | 11.x | UI animations |

## 10.2 Backend Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Platform** | Supabase | Latest | BaaS (Postgres, Auth, Storage, Edge Functions) |
| **Database** | PostgreSQL | 15+ | Primary database |
| **Extensions** | PostGIS, H3, pgvector | Latest | Spatial + AI |
| **Auth** | Supabase Auth (GoTrue) | Latest | Authentication |
| **Storage** | Cloudflare R2 | N/A | Media storage |
| **Edge Functions** | Deno | Latest | Serverless compute |
| **CDN** | Cloudflare | N/A | Static assets, caching |

## 10.3 External Services

| Service | Purpose | Cost Model |
|---------|---------|------------|
| **OpenAI** | Moderation, embeddings | Pay per token |
| **Mapbox/Maptiler** | Map tiles | Pay per request |
| **Resend** | Transactional email | Pay per email |
| **Sentry** | Error tracking | Free tier |
| **Vercel Analytics** | Web analytics | Free tier |

## 10.4 Hosting Recommendations

### 10.4.1 MVP Hosting (Low Cost)

| Component | Service | Monthly Cost |
|-----------|---------|--------------|
| **Frontend** | Vercel (Hobby) | $0 |
| **Backend** | Supabase (Free) | $0 |
| **Media** | Cloudflare R2 (Free tier) | $0 |
| **Domain** | Cloudflare | ~$10/year |
| **Email** | Resend (Free tier) | $0 |
| **Maps** | MapTiler (Free tier) | $0 |
| **Total** | | ~$0-10/month |

### 10.4.2 Production Hosting (Scale)

| Component | Service | Monthly Cost |
|-----------|---------|--------------|
| **Frontend** | Vercel (Pro) | $20 |
| **Backend** | Supabase (Pro) | $25 |
| **Media** | Cloudflare R2 | ~$5-50 |
| **Email** | Resend (Pro) | $20 |
| **Maps** | MapTiler (Flex) | ~$25 |
| **Monitoring** | Sentry (Team) | $26 |
| **Total** | | ~$120-170/month |

## 10.5 Development Environment

**Required Tools:**
- Node.js 20+
- pnpm 8+
- Supabase CLI
- Git

**Environment Variables:**

```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=xxx
SUPABASE_SERVICE_ROLE_KEY=xxx
NEXT_PUBLIC_MAPLIBRE_STYLE_URL=https://tiles.canvs.app/styles/light.json

# Server-only
OPENAI_API_KEY=sk-xxx
CLOUDFLARE_R2_ACCESS_KEY=xxx
CLOUDFLARE_R2_SECRET_KEY=xxx
CLOUDFLARE_R2_BUCKET=canvs-media
RESEND_API_KEY=re_xxx
```

## 10.6 CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test

  deploy-preview:
    if: github.event_name == 'pull_request'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}

  deploy-production:
    if: github.ref == 'refs/heads/main'
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

---

> [Next: Appendices →](./11-appendices.md)
