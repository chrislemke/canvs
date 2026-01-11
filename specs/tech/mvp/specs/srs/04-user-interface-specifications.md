# 4. User Interface Specifications

> [← Back to Index](./index.md) | [← Previous: Functional Requirements](./03-functional-requirements.md)

## 4.1 Design System

### 4.1.1 Color Palette

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| **Alabaster** | `#f0efea` | Background, cards |
| **Ink** | `#1a1a18` | Primary text |
| **Terracotta** | `#d97757` | Primary action, photo markers |
| **Sage** | `#8da399` | Secondary action, text markers |
| **Highlighter** | `#eedc5b` | Notifications, badges |

**Color Usage in CSS:**

```css
:root {
  /* Core Colors */
  --color-alabaster: #f0efea;
  --color-ink: #1a1a18;
  --color-terracotta: #d97757;
  --color-sage: #8da399;
  --color-highlighter: #eedc5b;

  /* Semantic Colors */
  --color-background: var(--color-alabaster);
  --color-text-primary: var(--color-ink);
  --color-text-secondary: rgba(26, 26, 24, 0.6);
  --color-text-muted: rgba(26, 26, 24, 0.4);
  --color-primary: var(--color-terracotta);
  --color-secondary: var(--color-sage);
  --color-accent: var(--color-highlighter);

  /* State Colors */
  --color-success: #4CAF50;
  --color-warning: #FFC107;
  --color-error: #F44336;
  --color-info: var(--color-sage);

  /* Surface Colors */
  --color-surface: #ffffff;
  --color-surface-elevated: #fafafa;
  --color-divider: rgba(26, 26, 24, 0.1);
}
```

### 4.1.2 Typography

| Element | Font | Size | Weight | Line Height |
|---------|------|------|--------|-------------|
| **H1** | Newsreader | 32px | 400 | 1.2 |
| **H2** | Newsreader | 24px | 400 | 1.3 |
| **H3** | Newsreader | 20px | 500 | 1.3 |
| **Body** | Inter | 16px | 400 | 1.5 |
| **Body Small** | Inter | 14px | 400 | 1.4 |
| **Caption** | Inter | 12px | 500 | 1.3 |
| **Button** | Inter | 14px | 600 | 1.0 |

**Typography CSS:**

```css
:root {
  --font-serif: "Newsreader", Georgia, "Times New Roman", serif;
  --font-sans: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

.heading-1 {
  font-family: var(--font-serif);
  font-size: 2rem;
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

.body {
  font-family: var(--font-sans);
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
}
```

### 4.1.3 Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | 4px | Tight grouping |
| `--space-sm` | 8px | Related elements |
| `--space-md` | 16px | Standard padding |
| `--space-lg` | 24px | Section separation |
| `--space-xl` | 32px | Page margins |
| `--space-2xl` | 48px | Major sections |

### 4.1.4 Animation

| Property | Value |
|----------|-------|
| **Duration Fast** | 150ms |
| **Duration Normal** | 300ms |
| **Duration Slow** | 500ms |
| **Ease Default** | `cubic-bezier(0.4, 0, 0.2, 1)` |
| **Ease Out Expo** | `cubic-bezier(0.16, 1, 0.3, 1)` |
| **Ease Spring** | `cubic-bezier(0.34, 1.56, 0.64, 1)` |

```css
:root {
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Standard transition */
.transition-default {
  transition: all var(--duration-normal) var(--ease-out-expo);
}
```

### 4.1.5 Shadows

```css
:root {
  --shadow-sm: 0 1px 2px rgba(26, 26, 24, 0.05);
  --shadow-md: 0 4px 6px rgba(26, 26, 24, 0.07), 0 2px 4px rgba(26, 26, 24, 0.05);
  --shadow-lg: 0 10px 25px rgba(26, 26, 24, 0.1), 0 4px 10px rgba(26, 26, 24, 0.05);
  --shadow-xl: 0 20px 40px rgba(26, 26, 24, 0.15);
}
```

## 4.2 Component Library

### 4.2.1 Buttons

**Primary Button:**

```jsx
// React Component
function PrimaryButton({ children, onClick, disabled, loading }) {
  return (
    <button
      className="btn-primary"
      onClick={onClick}
      disabled={disabled || loading}
    >
      {loading ? <Spinner size="sm" /> : children}
    </button>
  );
}

// CSS
.btn-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 24px;
  background: var(--color-terracotta);
  color: white;
  font-family: var(--font-sans);
  font-size: 14px;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all var(--duration-fast) var(--ease-out-expo);
}

.btn-primary:hover:not(:disabled) {
  background: #c86548;
  transform: translateY(-1px);
  box-shadow: var(--shadow-md);
}

.btn-primary:active:not(:disabled) {
  transform: translateY(0);
}

.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

**Button Variants:**

| Variant | Background | Text | Border |
|---------|------------|------|--------|
| Primary | Terracotta | White | None |
| Secondary | Sage | White | None |
| Outline | Transparent | Ink | 1px Ink |
| Ghost | Transparent | Ink | None |
| Danger | #F44336 | White | None |

### 4.2.2 Input Fields

```jsx
function TextField({
  label,
  placeholder,
  value,
  onChange,
  error,
  maxLength,
  multiline
}) {
  const Component = multiline ? 'textarea' : 'input';

  return (
    <div className={`text-field ${error ? 'text-field--error' : ''}`}>
      {label && <label className="text-field__label">{label}</label>}
      <Component
        className="text-field__input"
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        maxLength={maxLength}
      />
      {maxLength && (
        <span className="text-field__counter">
          {value.length}/{maxLength}
        </span>
      )}
      {error && <span className="text-field__error">{error}</span>}
    </div>
  );
}

// CSS
.text-field__input {
  width: 100%;
  padding: 12px 16px;
  font-family: var(--font-sans);
  font-size: 16px;
  color: var(--color-ink);
  background: var(--color-surface);
  border: 1px solid var(--color-divider);
  border-radius: 8px;
  transition: all var(--duration-fast);
}

.text-field__input:focus {
  outline: none;
  border-color: var(--color-terracotta);
  box-shadow: 0 0 0 3px rgba(217, 119, 87, 0.1);
}

.text-field--error .text-field__input {
  border-color: var(--color-error);
}
```

### 4.2.3 Cards

```jsx
function PostCard({ post, author, engagement, distance }) {
  return (
    <article className="post-card">
      <header className="post-card__header">
        <Avatar src={author.avatarUrl} size="40" />
        <div className="post-card__meta">
          <span className="post-card__author">@{author.username}</span>
          <span className="post-card__time">
            {formatRelativeTime(post.createdAt)} · 📍 {formatDistance(distance)}
          </span>
        </div>
      </header>

      <p className="post-card__content">{post.content}</p>

      {post.mediaUrl && (
        <div className="post-card__media">
          <img
            src={post.mediaUrl}
            alt=""
            loading="lazy"
          />
        </div>
      )}

      <footer className="post-card__footer">
        <ReactionButton
          count={engagement.reactionCount}
          active={engagement.userReaction}
        />
        <CommentButton count={engagement.commentCount} />
        <LocationBadge name={post.placeAnchor.name} />
      </footer>
    </article>
  );
}

// CSS
.post-card {
  background: var(--color-surface);
  border-radius: 12px;
  padding: var(--space-md);
  box-shadow: var(--shadow-sm);
  transition: all var(--duration-normal) var(--ease-out-expo);
}

.post-card:hover {
  box-shadow: var(--shadow-md);
}

.post-card__media img {
  width: 100%;
  aspect-ratio: 16/9;
  object-fit: cover;
  border-radius: 8px;
  margin-top: var(--space-sm);
}
```

## 4.3 Page Layouts

### 4.3.1 App Shell

```
┌────────────────────────────────────────────────────┐
│                    STATUS BAR                      │
├────────────────────────────────────────────────────┤
│                                                    │
│                                                    │
│                                                    │
│                                                    │
│                   MAIN CONTENT                     │
│                   (scrollable)                     │
│                                                    │
│                                                    │
│                                                    │
│                                                    │
├────────────────────────────────────────────────────┤
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌───────┐ │
│  │ Map  │  │ Feed │  │  +   │  │Notif │  │Profile│ │
│  └──────┘  └──────┘  └──────┘  └──────┘  └───────┘ │
│                  BOTTOM NAV                        │
└────────────────────────────────────────────────────┘
```

**Bottom Navigation Component:**

```jsx
function BottomNav({ activeTab, onNavigate }) {
  const tabs = [
    { id: 'map', icon: MapIcon, label: 'Map' },
    { id: 'feed', icon: FeedIcon, label: 'Feed' },
    { id: 'create', icon: PlusIcon, label: 'Post', accent: true },
    { id: 'notifications', icon: BellIcon, label: 'Alerts', badge: unreadCount },
    { id: 'profile', icon: UserIcon, label: 'Profile' }
  ];

  return (
    <nav className="bottom-nav">
      {tabs.map(tab => (
        <button
          key={tab.id}
          className={`bottom-nav__item ${activeTab === tab.id ? 'active' : ''}`}
          onClick={() => onNavigate(tab.id)}
        >
          <tab.icon className={tab.accent ? 'accent' : ''} />
          <span>{tab.label}</span>
          {tab.badge > 0 && <span className="badge">{tab.badge}</span>}
        </button>
      ))}
    </nav>
  );
}

// CSS
.bottom-nav {
  display: flex;
  justify-content: space-around;
  align-items: center;
  height: 64px;
  background: var(--color-surface);
  border-top: 1px solid var(--color-divider);
  padding-bottom: env(safe-area-inset-bottom);
}

.bottom-nav__item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 8px 16px;
  color: var(--color-text-muted);
  transition: color var(--duration-fast);
}

.bottom-nav__item.active {
  color: var(--color-terracotta);
}

.bottom-nav__item .accent {
  width: 44px;
  height: 44px;
  background: var(--color-terracotta);
  color: white;
  border-radius: 50%;
  padding: 10px;
}
```

### 4.3.2 Map View Layout

```
┌────────────────────────────────────────────────────┐
│ ┌─────────────────────────────────────────────┐    │
│ │                 SEARCH BAR                  │    │
│ └─────────────────────────────────────────────┘    │
│ ┌────┐                                   ┌─────┐   │
│ │Filt│                                   │Layrs│   │
│ └────┘                                   └─────┘   │
│                                                    │
│                                                    │
│                                                    │
│               INTERACTIVE MAP                      │
│                                                    │
│           📍  📍       📍                           │
│              📍     📍                              │
│                  (3) cluster                       │
│                                                    │
│                                          ┌────┐    │
│                                          │ 🧭 │    │
│                                          ├────┤    │
│                                          │ +  │    │
│                                          │ -  │    │
│                                          └────┘    │
│                                                    │
│ ┌──────────────────────────────────────────────┐   │
│ │          POST PREVIEW CARD                   │   │
│ │  (slides up when marker tapped)              │   │
│ └──────────────────────────────────────────────┘   │
├────────────────────────────────────────────────────┤
│                  BOTTOM NAV                        │
└────────────────────────────────────────────────────┘
```

---

> [Next: Database Architecture →](./05-database-architecture.md)
