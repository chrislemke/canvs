# 6. Authentication & User Account System

> [← Back to Index](./index.md) | [← Previous: Database Architecture](./05-database-architecture.md)

## 6.1 Authentication Methods

| Method | Provider | MVP Status |
|--------|----------|------------|
| **Magic Link (Email)** | Supabase Auth | ✅ Primary |
| **Google OAuth** | Supabase Auth | ✅ Included |
| **Apple Sign-In** | Supabase Auth | ✅ Included |
| **Password** | Supabase Auth | ❌ Deferred |
| **Phone/SMS** | Supabase Auth | ❌ Deferred |

## 6.2 Authentication Flow

### 6.2.1 Magic Link Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    MAGIC LINK AUTH FLOW                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. User enters email                                       │
│     ┌─────────────────────────────────────────────────┐     │
│     │  Enter your email                               │     │
│     │  ┌───────────────────────────────────────────┐  │     │
│     │  │ user@example.com                          │  │     │
│     │  └───────────────────────────────────────────┘  │     │
│     │               [Send Magic Link]                 │     │
│     └─────────────────────────────────────────────────┘     │
│                          │                                  │
│                          ▼                                  │
│  2. Supabase sends email with link                          │
│     ┌─────────────────────────────────────────────────┐     │
│     │  From: noreply@canvs.app                        │     │
│     │  Subject: Sign in to CANVS                      │     │
│     │                                                 │     │
│     │  Click here to sign in:                         │     │
│     │  https://canvs.app/auth/callback?token=xxx      │     │
│     │                                                 │     │
│     │  This link expires in 1 hour.                   │     │
│     └─────────────────────────────────────────────────┘     │
│                          │                                  │
│                          ▼                                  │
│  3. User clicks link, redirected to callback                │
│     ┌─────────────────────────────────────────────────┐     │
│     │  /auth/callback?token=xxxxx                     │     │
│     │                                                 │     │
│     │  - Verify token with Supabase                   │     │
│     │  - Exchange for session                         │     │
│     │  - Check if new user → onboarding               │     │
│     │  - Existing user → redirect to app              │     │
│     └─────────────────────────────────────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.2.2 OAuth Flow

```javascript
// OAuth sign-in handler
async function signInWithOAuth(provider) {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: provider, // 'google' or 'apple'
    options: {
      redirectTo: `${window.location.origin}/auth/callback`,
      queryParams: {
        access_type: 'offline',
        prompt: 'consent'
      }
    }
  });

  if (error) {
    throw new AuthError(error.message);
  }

  // User is redirected to provider
  // After auth, redirected back to /auth/callback
}

// Auth callback handler
async function handleAuthCallback() {
  const { data: { session }, error } = await supabase.auth.getSession();

  if (error || !session) {
    redirect('/login?error=auth_failed');
    return;
  }

  // Check if user profile exists
  const { data: profile } = await supabase
    .from('users')
    .select('id, username')
    .eq('id', session.user.id)
    .single();

  if (!profile?.username) {
    // New user - redirect to onboarding
    redirect('/onboarding');
  } else {
    // Existing user - redirect to app
    redirect('/map');
  }
}
```

## 6.3 User Onboarding

**Onboarding Steps (New Users):**

```
Step 1: Choose Username
┌────────────────────────────────────────────────────┐
│              WELCOME TO CANVS                      │
├────────────────────────────────────────────────────┤
│                                                    │
│  Choose your username                              │
│                                                    │
│  ┌────────────────────────────────────────────┐    │
│  │ @                                          │    │
│  └────────────────────────────────────────────┘    │
│  ✓ 3-30 characters                                 │
│  ✓ Letters, numbers, underscores only              │
│                                                    │
│              [Continue →]                          │
│                                                    │
└────────────────────────────────────────────────────┘

Step 2: Location Permission
┌────────────────────────────────────────────────────┐
│              ENABLE LOCATION                       │
├────────────────────────────────────────────────────┤
│                                                    │
│       🗺️                                           │
│                                                    │
│  CANVS uses your location to show you              │
│  content and let you post to places                │
│                                                    │
│  Your precise location is never shared             │
│  with other users.                                 │
│                                                    │
│         [Enable Location Access]                   │
│                                                    │
│           Skip for now                             │
│                                                    │
└────────────────────────────────────────────────────┘

Step 3: Complete
┌────────────────────────────────────────────────────┐
│              YOU'RE ALL SET!                       │
├────────────────────────────────────────────────────┤
│                                                    │
│       ✅                                           │
│                                                    │
│  Welcome to CANVS, @username!                      │
│                                                    │
│  Start exploring content around you                │
│  or create your first post.                        │
│                                                    │
│         [Explore the Map →]                        │
│                                                    │
└────────────────────────────────────────────────────┘
```

## 6.4 Session Management

```javascript
// Session configuration
const sessionConfig = {
  // Access token expires in 1 hour
  accessTokenLifetime: 3600,

  // Refresh token expires in 30 days
  refreshTokenLifetime: 30 * 24 * 3600,

  // Auto-refresh when 5 minutes remaining
  refreshThreshold: 300
};

// Session refresh logic
async function initializeAuth() {
  // Get initial session
  const { data: { session } } = await supabase.auth.getSession();

  // Listen for auth changes
  supabase.auth.onAuthStateChange((event, session) => {
    switch (event) {
      case 'SIGNED_IN':
        handleSignIn(session);
        break;
      case 'SIGNED_OUT':
        handleSignOut();
        break;
      case 'TOKEN_REFRESHED':
        updateStoredSession(session);
        break;
      case 'USER_UPDATED':
        handleUserUpdate(session);
        break;
    }
  });

  // Set up automatic token refresh
  if (session) {
    setupTokenRefresh(session);
  }
}

function setupTokenRefresh(session) {
  const expiresAt = new Date(session.expires_at * 1000);
  const now = new Date();
  const msUntilRefresh = expiresAt - now - (sessionConfig.refreshThreshold * 1000);

  if (msUntilRefresh > 0) {
    setTimeout(async () => {
      await supabase.auth.refreshSession();
    }, msUntilRefresh);
  }
}
```

## 6.5 Security Measures

| Measure | Implementation |
|---------|----------------|
| **Rate Limiting** | 5 login attempts per email per 15 minutes |
| **Token Storage** | HttpOnly cookies for web, secure storage for mobile |
| **Session Invalidation** | Revoke all sessions on password change |
| **IP Logging** | Log IP and user agent for security audit |
| **Suspicious Activity** | Flag logins from new locations/devices |

---

> [Next: API Specifications →](./07-api-specifications.md)
