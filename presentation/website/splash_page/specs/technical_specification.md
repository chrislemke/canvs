# CANVS Splash Website - Technical Specification

**Version:** 1.0.0
**Date:** 2026-01-10
**Purpose:** Developer implementation guide for the CANVS Node.js splash website

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technology Stack](#2-technology-stack)
3. [Project Structure](#3-project-structure)
4. [Internationalization (i18n)](#4-internationalization-i18n)
5. [Design System Implementation](#5-design-system-implementation)
6. [Component Specifications](#6-component-specifications)
7. [Page Sections](#7-page-sections)
8. [JavaScript Functionality](#8-javascript-functionality)
9. [Build & Development](#9-build--development)
10. [Deployment](#10-deployment)
11. [Performance Requirements](#11-performance-requirements)
12. [Accessibility](#12-accessibility)

---

## 1. Project Overview

### 1.1 Purpose
A bilingual (English/German) splash website for the CANVS project - "The Spatial Social Layer". The site serves to:
- Communicate the product vision and value proposition
- Hook stakeholders and potential collaborators
- Provide a professional landing page for investor/partner outreach

### 1.2 Key Features
- **Dynamic Node.js server** with server-side rendering
- **Bilingual support** (EN/DE) with URL-based language switching
- **Smooth scroll navigation** with anchor links
- **Paper-texture aesthetic** following the "Digital Humanism" design philosophy
- **Responsive design** (mobile-first approach)
- **Animated elements** with scroll-triggered reveals

### 1.3 Design Philosophy
> "Digital Humanism - Tactile artifacts that feel like physical objects"

The design mimics cold press paper with subtle grain textures, hand-drawn button styles, and warm earth-tone colors.

---

## 2. Technology Stack

### 2.1 Core Technologies

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Runtime** | Node.js 20+ LTS | Stable, mature ecosystem |
| **Framework** | Express.js 4.x | Minimal, flexible, well-documented |
| **Templating** | Nunjucks | Template inheritance, i18n filters, familiar syntax |
| **CSS** | Tailwind CSS 3.x + CSS Variables | Design system preservation with utility classes |
| **JavaScript** | Vanilla JS (ES6+) | No framework overhead, simple interactions |
| **Build Tool** | esbuild | Fast compilation, minimal config |
| **i18n** | i18next + i18next-fs-backend | Industry standard, file-based translations |

### 2.2 Dependencies

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "nunjucks": "^3.2.4",
    "i18next": "^23.x",
    "i18next-fs-backend": "^2.3.x",
    "i18next-http-middleware": "^3.5.x",
    "compression": "^1.7.4",
    "helmet": "^7.x"
  },
  "devDependencies": {
    "tailwindcss": "^3.4.x",
    "esbuild": "^0.20.x",
    "nodemon": "^3.x",
    "concurrently": "^8.x"
  }
}
```

---

## 3. Project Structure

```
splash_page/
├── src/
│   ├── server.js              # Express application entry
│   ├── config/
│   │   ├── i18n.js            # i18next configuration
│   │   └── app.js             # Express middleware setup
│   ├── routes/
│   │   └── index.js           # Route definitions
│   ├── locales/
│   │   ├── en/
│   │   │   └── translation.json
│   │   └── de/
│   │       └── translation.json
│   ├── views/
│   │   ├── layouts/
│   │   │   └── base.njk       # Base template
│   │   ├── partials/
│   │   │   ├── navigation.njk
│   │   │   ├── hero.njk
│   │   │   ├── manifesto.njk
│   │   │   ├── solution.njk
│   │   │   ├── experience.njk
│   │   │   ├── primitives.njk
│   │   │   ├── usecases.njk
│   │   │   ├── impact.njk
│   │   │   ├── roadmap.njk
│   │   │   ├── cta.njk
│   │   │   └── footer.njk
│   │   └── pages/
│   │       └── index.njk      # Home page
│   └── public/
│       ├── css/
│       │   ├── input.css      # Tailwind input
│       │   └── styles.css     # Compiled output
│       ├── js/
│       │   └── main.js        # Client-side JS
│       ├── images/
│       │   └── og-image.png   # Social sharing image
│       └── fonts/             # Self-hosted fonts (optional)
├── package.json
├── tailwind.config.js
├── esbuild.config.js
├── .env.example
└── README.md
```

---

## 4. Internationalization (i18n)

### 4.1 URL Strategy

**Path-based URLs** (recommended for SEO):

| Language | URL Pattern |
|----------|-------------|
| English | `/en/` or `/en` |
| German | `/de/` or `/de` |
| Root redirect | `/` → Browser language detection → `/en/` or `/de/` |

### 4.2 Language Detection Flow

```
User visits /
    ↓
Check Accept-Language header
    ↓
├── Contains "de" → Redirect to /de/
└── Otherwise → Redirect to /en/
```

### 4.3 i18next Configuration

```javascript
// src/config/i18n.js
import i18next from 'i18next';
import Backend from 'i18next-fs-backend';
import middleware from 'i18next-http-middleware';
import path from 'path';

i18next
  .use(Backend)
  .use(middleware.LanguageDetector)
  .init({
    fallbackLng: 'en',
    supportedLngs: ['en', 'de'],
    preload: ['en', 'de'],
    backend: {
      loadPath: path.join(__dirname, '../locales/{{lng}}/translation.json')
    },
    detection: {
      order: ['path', 'header'],
      lookupPath: 'lng',
      lookupFromPathIndex: 0
    }
  });

export default i18next;
```

### 4.4 Route Configuration

```javascript
// src/routes/index.js
router.get('/', (req, res) => {
  const lang = req.acceptsLanguages('de', 'en') || 'en';
  res.redirect(`/${lang}/`);
});

router.get('/:lng/', (req, res) => {
  const { lng } = req.params;
  if (!['en', 'de'].includes(lng)) {
    return res.redirect('/en/');
  }
  res.render('pages/index', {
    t: req.t,
    lng,
    alternateLng: lng === 'en' ? 'de' : 'en'
  });
});
```

### 4.5 Translation File Structure

```json
// src/locales/en/translation.json
{
  "meta": {
    "title": "CANVS - The World is a Blank Page",
    "description": "The Spatial Social Layer - Building the Internet of Places"
  },
  "nav": {
    "manifesto": "Manifesto",
    "experience": "Experience",
    "impact": "Impact",
    "roadmap": "Roadmap",
    "cta": "Join the Vision"
  },
  "hero": {
    "tagline": "Spatial Social Layer - 2026-2030",
    "headline": "The world is",
    "headline_highlight": "a blank page.",
    "description": "We are building the Internet of Places. Not a feed that scrolls forever, but a layer of meaning that stays where you leave it.",
    "cta_primary": "Explore the Vision",
    "cta_secondary": "Read the Paper"
  }
  // ... (see content_spec.yaml for complete content)
}
```

### 4.6 Template Usage

```nunjucks
{# views/partials/hero.njk #}
<section id="hero" class="hero-section">
  <span class="tagline">{{ t('hero.tagline') }}</span>
  <h1 class="hero-title">
    {{ t('hero.headline') }} <em class="text-terracotta">{{ t('hero.headline_highlight') }}</em>
  </h1>
  <p class="hero-description">{{ t('hero.description') }}</p>
</section>
```

### 4.7 Language Toggle Component

```nunjucks
{# views/partials/navigation.njk #}
<div class="language-toggle">
  <a href="/en/" class="lang-btn {% if lng == 'en' %}active{% endif %}">EN</a>
  <a href="/de/" class="lang-btn {% if lng == 'de' %}active{% endif %}">DE</a>
</div>
```

---

## 5. Design System Implementation

### 5.1 CSS Custom Properties

```css
/* src/public/css/input.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  /* Primary Colors */
  --alabaster: #F0EFEA;
  --ink: #1A1A18;
  --terracotta: #D97757;
  --sage: #8DA399;
  --highlighter: #EEDC5B;

  /* Derived Colors */
  --ink-light: rgba(26, 26, 24, 0.6);
  --ink-lighter: rgba(26, 26, 24, 0.15);
  --alabaster-translucent: rgba(240, 239, 234, 0.95);

  /* Typography */
  --font-serif: 'Newsreader', Georgia, serif;
  --font-sans: 'Inter', sans-serif;
}
```

### 5.2 Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  content: ['./src/views/**/*.njk', './src/public/js/**/*.js'],
  theme: {
    extend: {
      colors: {
        alabaster: 'var(--alabaster)',
        ink: 'var(--ink)',
        terracotta: 'var(--terracotta)',
        sage: 'var(--sage)',
        highlighter: 'var(--highlighter)',
        'ink-light': 'var(--ink-light)',
        'ink-lighter': 'var(--ink-lighter)',
      },
      fontFamily: {
        serif: ['Newsreader', 'Georgia', 'serif'],
        sans: ['Inter', 'sans-serif'],
      },
      fontSize: {
        'hero': 'clamp(3.5rem, 8vw, 7rem)',
        'section': 'clamp(2.5rem, 5vw, 4rem)',
      },
    },
  },
  plugins: [],
}
```

### 5.3 Paper Texture Effect

```css
/* Paper grain overlay - applied to body */
body::before {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.035'/%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 9999;
}
```

### 5.4 Hand-Drawn Button Style

```css
/* "Scribble" button - asymmetric hand-drawn aesthetic */
.btn-scribble {
  background: transparent;
  border: 2px solid var(--ink);
  border-radius: 255px 15px 225px 15px / 15px 225px 15px 255px;
  padding: 14px 32px;
  font-family: var(--font-sans);
  font-weight: 500;
  font-size: 13px;
  letter-spacing: 0.04em;
  color: var(--ink);
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.25, 1, 0.5, 1);
  overflow: hidden;
}

.btn-scribble:hover {
  background: var(--terracotta);
  color: var(--alabaster);
  border-color: var(--terracotta);
  transform: translateY(-3px) rotate(-1deg);
  box-shadow: 4px 4px 0 var(--ink);
}
```

### 5.5 Highlight Effect

```css
/* Marker-style text highlight */
.highlight {
  background: linear-gradient(180deg, transparent 60%, var(--highlighter) 60%);
  padding: 0 4px;
}
```

---

## 6. Component Specifications

### 6.1 Navigation

**Requirements:**
- Fixed position at top
- Transparent initially, becomes solid with blur on scroll
- Logo (SVG icon + "CANVS" text)
- Menu links (anchor scroll)
- CTA button
- Language toggle (fixed position, top-right)

**Scroll Behavior:**
```javascript
// Add class when scrolled past 100px
window.addEventListener('scroll', () => {
  const nav = document.querySelector('.navigation');
  nav.classList.toggle('nav-scrolled', window.scrollY > 100);
});
```

**CSS States:**
```css
.navigation {
  position: fixed;
  top: 0;
  width: 100%;
  padding: 20px 40px;
  z-index: 100;
  background: linear-gradient(to bottom, var(--alabaster) 60%, transparent);
  transition: all 0.3s ease;
}

.navigation.nav-scrolled {
  background: var(--alabaster-translucent);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid var(--ink-lighter);
  padding: 16px 40px;
}
```

### 6.2 Language Toggle

**Position:** Fixed, top-right corner
**Z-index:** 1000 (above navigation)

```css
.language-toggle {
  position: fixed;
  top: 24px;
  right: 24px;
  z-index: 1000;
  display: flex;
  gap: 4px;
  background: var(--alabaster-translucent);
  padding: 6px;
  border-radius: 30px;
  border: 1.5px solid var(--ink-lighter);
  backdrop-filter: blur(10px);
}

.lang-btn {
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.05em;
  color: var(--ink-light);
  transition: all 0.3s ease;
}

.lang-btn.active {
  background: var(--ink);
  color: var(--alabaster);
}
```

### 6.3 Floating Memory Cards (Hero Section)

**Description:** Decorative cards that float with parallax effect on mouse movement.

```css
.floating-card {
  position: absolute;
  background: white;
  padding: 24px;
  border-radius: 4px;
  box-shadow: 0 8px 40px rgba(26, 26, 24, 0.08);
  border: 1px solid rgba(26, 26, 24, 0.05);
  max-width: 280px;
  z-index: 3;
}

.floating-card.card-1 {
  top: 20%;
  right: 8%;
  transform: rotate(3deg);
  animation: float1 6s ease-in-out infinite;
}

.floating-card.card-2 {
  bottom: 25%;
  right: 15%;
  transform: rotate(-2deg);
  animation: float2 7s ease-in-out infinite;
}

@keyframes float1 {
  0%, 100% { transform: rotate(3deg) translateY(0); }
  50% { transform: rotate(3deg) translateY(-15px); }
}

@keyframes float2 {
  0%, 100% { transform: rotate(-2deg) translateY(0); }
  50% { transform: rotate(-2deg) translateY(-20px); }
}
```

### 6.4 Section Cards

**Solution Cards (Dark Background):**
```css
.solution-card {
  background: rgba(240, 239, 234, 0.03);
  border: 1px solid rgba(240, 239, 234, 0.08);
  border-radius: 8px;
  padding: 40px 32px;
  position: relative;
  transition: all 0.4s ease;
}

.solution-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, var(--terracotta), var(--sage));
  opacity: 0;
  transition: opacity 0.4s ease;
}

.solution-card:hover {
  background: rgba(240, 239, 234, 0.06);
  transform: translateY(-8px);
}

.solution-card:hover::before {
  opacity: 1;
}
```

**Primitive Cards (Light Background):**
```css
.primitive-card {
  background: white;
  border: 1px solid rgba(26, 26, 24, 0.06);
  border-radius: 6px;
  padding: 36px 28px;
  transition: all 0.4s ease;
}

.primitive-card:hover {
  transform: translateY(-6px) rotate(-0.5deg);
  box-shadow: 8px 12px 40px rgba(26, 26, 24, 0.08);
  border-color: var(--terracotta);
}
```

---

## 7. Page Sections

### 7.1 Section Overview

| Section | Background | Content Type |
|---------|------------|--------------|
| Hero | Alabaster | Headline, description, CTA, floating cards |
| Manifesto | Gradient (alabaster → sage tint) | Problem statement, manifesto quotes |
| Solution | Ink (dark) | 3 feature cards |
| Experience | Alabaster | 3 mode cards (expandable) |
| Primitives | Gradient (terracotta tint) | 6 primitive cards |
| Use Cases | White | 3 category groups with items |
| Impact | Gradient (sage tint) | 3 impact cards with icons |
| Roadmap | Ink (dark) | Timeline with 5 years |
| CTA | Alabaster | Final call-to-action |
| Footer | Alabaster | Logo, tagline, copyright |

### 7.2 Section Padding

```css
.section {
  padding: 120px 80px;
  position: relative;
}

.section-header {
  max-width: 800px;
  margin-bottom: 80px;
}

/* Responsive adjustments */
@media (max-width: 900px) {
  .section {
    padding: 80px 40px;
  }
}

@media (max-width: 600px) {
  .section {
    padding: 60px 24px;
  }
}
```

### 7.3 Section Header Pattern

Every content section uses this header structure:

```nunjucks
<div class="section-header">
  <span class="section-label">
    <span class="label-line"></span>
    {{ t('section.label') }}
  </span>
  <h2 class="section-title">{{ t('section.title') | safe }}</h2>
  <p class="section-description">{{ t('section.description') }}</p>
</div>
```

```css
.section-label {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--terracotta);
  margin-bottom: 20px;
}

.label-line {
  width: 24px;
  height: 2px;
  background: var(--terracotta);
}

.section-title {
  font-family: var(--font-serif);
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 400;
  line-height: 1.15;
  letter-spacing: -0.01em;
  margin-bottom: 24px;
}

.section-description {
  font-size: 1.15rem;
  color: var(--ink-light);
  max-width: 600px;
  font-weight: 300;
}
```

---

## 8. JavaScript Functionality

### 8.1 Required Features

1. **Smooth Scroll Navigation** - Anchor links scroll smoothly
2. **Scroll-Triggered Animations** - Elements fade in on scroll
3. **Navigation State** - Updates active link based on scroll position
4. **Parallax Cards** - Hero cards follow mouse movement
5. **Mobile Menu Toggle** - Hamburger menu for mobile

### 8.2 Smooth Scroll Implementation

```javascript
// src/public/js/main.js

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', function(e) {
    e.preventDefault();
    const target = document.querySelector(this.getAttribute('href'));
    if (target) {
      const offset = 80; // Account for fixed nav
      const targetPosition = target.offsetTop - offset;
      window.scrollTo({
        top: targetPosition,
        behavior: 'smooth'
      });
    }
  });
});
```

### 8.3 Scroll Animation (Intersection Observer)

```javascript
// Fade-up animation on scroll
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, observerOptions);

document.querySelectorAll('.animate-on-scroll').forEach(el => {
  observer.observe(el);
});
```

```css
/* Animation base state */
.animate-on-scroll {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.animate-on-scroll.visible {
  opacity: 1;
  transform: translateY(0);
}
```

### 8.4 Parallax Effect for Floating Cards

```javascript
// Parallax movement on mouse
const cards = document.querySelectorAll('.floating-card');
document.addEventListener('mousemove', (e) => {
  const x = (e.clientX / window.innerWidth - 0.5) * 20;
  const y = (e.clientY / window.innerHeight - 0.5) * 20;

  cards.forEach((card, index) => {
    const factor = (index + 1) * 0.5;
    card.style.transform = `translate(${x * factor}px, ${y * factor}px) rotate(${card.dataset.rotation || 0}deg)`;
  });
});
```

### 8.5 Active Navigation State

```javascript
// Update active nav link on scroll
const sections = document.querySelectorAll('section[id]');
const navLinks = document.querySelectorAll('.nav-link');

window.addEventListener('scroll', () => {
  let current = '';

  sections.forEach(section => {
    const sectionTop = section.offsetTop - 100;
    if (window.scrollY >= sectionTop) {
      current = section.getAttribute('id');
    }
  });

  navLinks.forEach(link => {
    link.classList.remove('active');
    if (link.getAttribute('href') === `#${current}`) {
      link.classList.add('active');
    }
  });
});
```

---

## 9. Build & Development

### 9.1 NPM Scripts

```json
{
  "scripts": {
    "dev": "concurrently \"npm run watch:css\" \"npm run watch:server\"",
    "watch:css": "tailwindcss -i ./src/public/css/input.css -o ./src/public/css/styles.css --watch",
    "watch:server": "nodemon src/server.js",
    "build:css": "tailwindcss -i ./src/public/css/input.css -o ./src/public/css/styles.css --minify",
    "build": "npm run build:css",
    "start": "node src/server.js",
    "lint": "eslint src/",
    "test": "echo \"No tests specified\""
  }
}
```

### 9.2 Development Workflow

```bash
# Install dependencies
npm install

# Start development (hot reload)
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

### 9.3 Environment Variables

```bash
# .env.example
NODE_ENV=development
PORT=3000
```

---

## 10. Deployment

### 10.1 Recommended Platforms

| Platform | Suitability | Notes |
|----------|-------------|-------|
| **Vercel** | Excellent | Native Node.js support, automatic SSL |
| **Railway** | Excellent | Simple deployment, good pricing |
| **Render** | Good | Free tier available |
| **Heroku** | Good | Established, reliable |

### 10.2 Vercel Configuration

```json
// vercel.json
{
  "version": 2,
  "builds": [
    {
      "src": "src/server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "src/server.js"
    }
  ]
}
```

### 10.3 Production Checklist

- [ ] Set `NODE_ENV=production`
- [ ] Enable compression middleware
- [ ] Configure security headers (Helmet)
- [ ] Set proper cache headers for static assets
- [ ] Configure SSL/HTTPS
- [ ] Add `hreflang` meta tags for SEO
- [ ] Generate `sitemap.xml`
- [ ] Add `robots.txt`

---

## 11. Performance Requirements

### 11.1 Targets

| Metric | Target |
|--------|--------|
| First Contentful Paint | < 1.5s |
| Largest Contentful Paint | < 2.5s |
| Cumulative Layout Shift | < 0.1 |
| Time to Interactive | < 3.5s |

### 11.2 Optimizations

1. **Font Loading:**
   ```html
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link rel="preload" as="style" href="fonts.css">
   ```

2. **Image Optimization:**
   - Use WebP format where possible
   - Lazy load below-fold images
   - Provide responsive sizes

3. **CSS Optimization:**
   - Inline critical CSS
   - Defer non-critical styles
   - Minify production CSS

4. **JavaScript:**
   - Defer non-critical scripts
   - No blocking scripts in `<head>`

---

## 12. Accessibility

### 12.1 Requirements

- WCAG 2.1 AA compliance
- Keyboard navigation support
- Screen reader compatibility
- Color contrast ratio ≥ 4.5:1 for text

### 12.2 Implementation

1. **Semantic HTML:**
   ```html
   <nav role="navigation" aria-label="Main navigation">
   <main role="main">
   <section aria-labelledby="section-title">
   ```

2. **Skip Link:**
   ```html
   <a href="#main-content" class="skip-link">Skip to content</a>
   ```

3. **Focus States:**
   ```css
   a:focus, button:focus {
     outline: 2px solid var(--terracotta);
     outline-offset: 2px;
   }
   ```

4. **Language Attribute:**
   ```html
   <html lang="{{ lng }}">
   ```

5. **Reduced Motion:**
   ```css
   @media (prefers-reduced-motion: reduce) {
     *, *::before, *::after {
       animation-duration: 0.01ms !important;
       transition-duration: 0.01ms !important;
     }
   }
   ```

---

## Appendices

### A. Content Reference

See `specs/content/website_content_spec.yaml` for complete bilingual content structure.

### B. Design System Reference

See `specs/design/design_system.yaml` for complete design tokens and component specifications.

### C. SVG Assets Required

1. **Logo Icon** - Pin-heart-path motif (see design_vision_v4.html)
2. **Section Icons** - Pin, infinity, anchor, bubble, capsule, path, drop, portal
3. **Hero Decoration** - Concentric dashed circles
4. **Impact Icons** - Graph, buildings, network globe

### D. External Resources

- [Google Fonts - Newsreader](https://fonts.google.com/specimen/Newsreader)
- [Google Fonts - Inter](https://fonts.google.com/specimen/Inter)
- [Nunjucks Documentation](https://mozilla.github.io/nunjucks/)
- [i18next Documentation](https://www.i18next.com/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

---

**Document Version:** 1.0.0
**Last Updated:** 2026-01-10
**Author:** Claude (Research Synthesis)
**Status:** Ready for Implementation
