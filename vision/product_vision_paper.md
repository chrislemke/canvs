# CANVS - It’s the world: The Spatial Social Layer

## Product Vision Paper & Strategic Roadmap (2026–2030)

**Tagline:** *The end of the feed. The beginning of the world.*

---

## 0. Executive Summary: What CANVS Is

CANVS is a **persistent, AR-native social layer anchored to physical places**. Instead of consuming life through a decontextualized feed, people experience content **where it belongs**: at the location it refers to, at the scale it happened, with the atmosphere that gave it meaning.

CANVS turns the planet into an **addressable surface**: every bench, alley, beach, mural, café table, trailhead, and plaza becomes a node in a living network of memories, knowledge, art, and coordination.

This idea is now feasible because the enabling stack has matured:

* **World-scale AR anchoring is real and productized.** Visual Positioning Systems (VPS) combine GPS with vision-based localization to place content far more reliably than GPS alone.
* **Persistent, shareable AR at real-world locations is shipping.** Modern AR platforms can lock content to places in a way that multiple people can reliably see over time.
* **Consumers and creators are being trained for location-anchored AR.** Place-anchored AR content creation is becoming mainstream.
* **Spatial computing hardware is moving from “demo” to “platform.”** Headsets and smart glasses are evolving into everyday computing surfaces.

CANVS is designed to become **glass-native**: as AR glasses and spatial computers transition into everyday devices, CANVS becomes an always-available layer—less like an app, more like a **new default interface for place**.

---

## 1. Manifesto: The End of the Feed, the Beginning of the World

We are building the **Internet of Places**.

Today’s social platforms are optimized for **infinite scrolling**, not for human life. They isolate us inside algorithmic loops and replace lived reality with mediated content.

CANVS flips the direction of attention:

* The feed is not the home screen. **The world is.**
* Content is not something you “go find.” It’s something you **encounter**, because you are there.
* Meaning is not manufactured by engagement hacks. Meaning is **in context**.

A story about a sunset is powerful anywhere.
A story about a sunset becomes *inevitable* when you’re sitting in the exact place it happened—at the same angle, the same horizon line, the same wind.

**Vision:** CANVS is the social operating layer for spatial computing.
When the world becomes a canvas, CANVS provides the paint.

---

## 2. The Problem: Context Loss and the “Ghost Event”

**Things happen at places.**
But digital memory is usually detached from the physical world.

A first kiss. A perfect skate trick. A protest that changed someone’s life. A conversation that flipped a career. A hidden café that felt like finding oxygen.

Then the moment ends—and the meaning becomes invisible.

**Status quo:**
Someone stands at that place two weeks later and sees… concrete. The emotion is gone. The story exists somewhere in a cloud account, if at all. It’s not “there.” It’s nowhere.

**The gap:**
We walk through a world full of invisible meaning, unable to perceive the human layers that already exist all around us.

---

## 3. The Solution: Persistent Emotional Anchoring

CANVS makes moments **spatially persistent**.

Not as a gimmick, but as a new medium:
**Place becomes the index.**

CANVS enables:

* **Reality Time Capsules:** content (text, audio, video, 3D captures, sketches) pinned to real-world locations so future visitors can “open” the moment where it happened.
* **Asynchronous presence:** you can experience a moment later, not by “watching a video,” but by seeing the memory **in situ**, aligned to the geometry of the world.

This depends on a real technical foundation: **world-locked anchoring**.

* GPS alone often breaks immersion due to drift and urban multipath.
* Modern stacks combine GPS with vision-based localization (VPS) and mapping for stable placement.
* Reliable persistence requires multi-tier anchoring, re-localization, and confidence-aware rendering.

---

## 4. The Product Thesis: “The Spatial Social Layer”

CANVS is not:

* a traditional social network (feed-first)
* a maps app (utility-first)
* a game (loop-first)

CANVS is a new primitive:

### The world as a browsable interface

A **Spatial Browser** that lets you “read” places the way you read websites.

If the 1990s internet was made of pages and links, the spatial internet is made of:

* **Places**
* **Anchors**
* **Layers**
* **Memories**
* **Paths**
* **Social context**
* **AI mediation**

---

## 5. Core Experience: The Spatial Browser

### 5.1 Three modes (one mental model)

1. **AR Mode (“Magic Window / Glass View”)**
   You look at the world and see location-anchored content where it belongs.

2. **Map Mode (“Spatial Radar”)**
   You see nearby layers, hotspots, and trails. Map is not the product—it’s the minimap.

3. **Time Mode (“Temporal Scrub”)**
   Slide through time to see what happened here: yesterday, last summer, 10 years ago.

### 5.2 The fundamental interaction: “Look → Understand → Act”

CANVS is built around “micro-encounters”:

* see a story
* feel something
* reply, add context, or create your own layer
* move on, carrying the place with you

The goal is not infinite consumption.
The goal is **meaningful place interactions**.

**North Star metric proposal:**
**MPI/week = Meaningful Place Interactions per user per week**
(Opening a capsule, leaving a voice note, contributing to a utility marker, participating in a local thread, etc.)

---

## 6. Core Building Blocks: Spatial Primitives

### A. Pins

Simple anchors: notes, photos, audio, links, “hidden menu” tips, warnings, micro-stories.

### B. Bubbles (Group Memory Objects)

A shared container anchored to a place.

Examples:

* “We used to meet here every Friday.”
* “This bench is where she told me yes.”
* “We found this spot during our first week in this city.”

### C. Time Capsules

Richer artifacts: multi-media + 3D capture + timeline.

### D. Trails

A sequence of anchors that forms a narrative route:

* “My break-up walk.”
* “Best street art within 12 minutes.”
* “The city through immigrant food.”
* “A grief trail for remembrance.”

### E. Drops (Geo-fenced Releases)

Music, artwork, collectibles, or messages that only unlock at a location and time.

### F. Portals

A place anchored to another place via story logic:

* “If you liked this, go to that.”
* “This spot is the sibling of that spot.”

---

## 7. Deep-Tech Foundation: How This Becomes Real

### 7.1 World-scale localization: GPS is not enough

**Reality:** GPS drift breaks immersion.

Modern AR stacks solve this via **visual localization** and mapping.

**Design implication for CANVS:**
Build a **multi-tier anchoring strategy**:

1. **Coarse localization** (GPS / map alignment) for discovery and approximate placement
2. **VPS localization** (when available) for world alignment
3. **Local SLAM anchoring** for stable, low-jitter placement in the user’s immediate session
4. **Re-localization & drift correction** for persistence across time and devices

### 7.2 The “AR Cloud” is the macro concept

The “AR Cloud” describes a persistent, spatially accurate digital copy of the world (a “digital twin”) that enables shared AR experiences across users and time.

**CANVS interpretation:**
We don’t need to own the entire AR Cloud. We need to own the **social meaning layer** that lives on top of it.

### 7.3 Positioning abstraction: “Anchor Runtime”

In practice, CANVS should treat positioning vendors as interchangeable backends.

CANVS creates its own stable concept:

* **CANVS Anchor ID** (a persistent identifier)
* **Anchor bundles** (multi-representation: lat/long/alt + visual features + local map fragments + constraints)
* **Confidence-aware rendering** (content fades in only when tracking confidence is sufficient)

### 7.4 3D capture becomes a native media type (not a luxury)

To “freeze” moments, CANVS should support **spatial capture formats**:

* Quick scan (phone LiDAR / photogrammetry)
* “Spatial clips” (short 3D snapshots)
* High-fidelity capture for creators

**Product implication:**
Time capsules evolve from “video pinned to a spot” into “walkable memory fragments.”

### 7.5 Web-native distribution is a force multiplier

“Open in browser” becomes a growth lever: a location-locked experience shared via link, not installation.

### 7.6 Hardware agnosticism is not optional

Spatial computing hardware is diversifying (headsets, AR glasses, smart glasses with displays).

CANVS should architect for **portable XR**:

* Use standards where possible.
* Treat the phone as the bootstrapping device, but maintain a “glass-first” UX philosophy.

---

## 8. LLM Agents as the “Reality Filter” (Not a Chatbot)

In a world where every place can hold content, the core product is not creation—it’s **filtering**.

CANVS needs a personal AI layer that feels like:

* “my taste”
* “my friends”
* “my values”
* “my mental state”
* “my intent right now”

### 8.1 The Agent’s job

* Summarize the layer you’re in
* Surface what matters
* Prevent overwhelm
* Prevent harm
* Turn raw spatial data into *felt relevance*

### 8.2 Example features (agent-native)

* **Friend-memory surfacing:** “Your friend left a note here 3 years ago.”
* **Emotion search:** “Show me places where people reported feeling calm.”
* **Context compression:** Turn 400 nearby anchors into 5 meaningful options.
* **Path generation:** “Give me a 30-minute walk that ends somewhere optimistic.”

### 8.3 Safety-aware personalization

The agent is also a safety filter:

* suppress stalking-like patterns
* reduce accidental over-sharing
* warn if a user is about to publish to a sensitive location context

(See “Safety & Governance” below.)

---

## 9. Emotional & Social Use Cases: Re-enchanting Reality

### Category 1: Shared Memories (Emotional Layer)

**1) The Skating Bubble**
Friends leave a group bubble at the rink. Years later, someone returns alone and opens it—hearing laughter and seeing spatial clips aligned to the ice.

**2) Sunset Stories**
A global atlas of romance: “Sit here at 19:42. Perfect angle.”

**3) Grief & Remembrance**
Digital candles and memories anchored to meaningful places—lasting, revisitable, shareable with chosen people.

**4) Letters to Future Me**
A capsule you can only open when you physically return.

### Category 2: Hyper-Local Utility (Useful Layer)

**1) Surf Intelligence**
AR markers: hazards, entry points, wind advice.

**2) Hidden Menu Layer**
Recommendations pinned to a specific table or counter: “Order it this way.”

**3) Accessibility Layer**
User-generated accessibility notes anchored precisely: step-free entrances, quiet hours, safe seating, lighting warnings.

### Category 3: Urban Culture & Play (Creative Layer)

**1) Street Art Living Threads**
Discussions float *in front of* murals—timelines, artist credits, community response—without touching the wall.

**2) Flashmob Countdown / Location Drops**
Exclusive content appears when a place “activates” at a time.

**3) Civic Layer (Citizen Signals)**
Hazards, unsafe corners, mutual aid requests, neighborhood alerts.

---

## 10. Societal Impact: Why the World Needs This

### 10.1 Movement and “Touching Grass”

Location-based AR can drive real-world activity. CANVS generalizes that mechanism beyond a single game loop:

* content requires presence
* presence requires movement
* movement increases serendipity and social contact

### 10.2 Economic revitalization

Location-anchored digital layers can improve discovery and drive attention to local businesses.

CANVS can become the “local discovery layer” that is emotional, not transactional.

### 10.3 The map data itself becomes strategic

Planet-scale spatial mapping is increasingly viewed as a core asset for future devices like smart glasses and robots.

CANVS rides that wave—while specializing in the **human meaning graph**.

---

## 11. Trust, Safety, and Governance: The Layer Must Be Safe by Design

A spatial social layer amplifies both beauty and risk. The design must assume adversarial use.

### 11.1 Location privacy is high stakes

Location data can enable re-identification, inference of sensitive information, and physical threats.

**CANVS principle:**
Precision is a privilege, not a default.

### 11.2 Anti-stalking posture (non-negotiable)

**CANVS must implement:**

* private-by-default creation modes
* audience controls (self / friends / groups / public)
* proximity-based visibility limits
* strong reporting and rapid takedown
* “shadow banning” for suspicious behavioral patterns
* location obfuscation options (“near here” instead of exact)
* hard blocks that prevent re-appearance in shared spaces

### 11.3 Property, nuisance, and crowd externalities

Location-based experiences can generate real-world conflict.

**CANVS mitigation model:**

* **Private Space Shield:** strong exclusion zones and owner claims
* **Noise budgets:** limit visibility/activation of high-traffic anchors
* **Event throttles:** prevent “stampede mechanics” near residences
* **Local governance:** trusted community moderators, verified stewards
* **“Good citizen” design:** discourage congregating mechanics in sensitive places

### 11.4 Moderation needs to be spatially aware

Unlike a feed, harmful content in CANVS is **attached to a place**. Moderation needs:

* geofenced rules (schools, hospitals, memorial sites)
* content type constraints by zone
* age gating
* contextual integrity (e.g., memorial vs nightlife area)

---

## 12. Monetization: Non-Intrusive, Spatial-Native, Opt-In

CANVS monetizes *without becoming a billboard apocalypse*.

### 12.1 Spatial-native brand objects

Not popups. **Objects with physical logic**:

* collectibles
* AR mini-experiences
* limited drops
* “try before you buy” overlays
* “story objects” that belong to a location

### 12.2 Local business toolkit (the “Digital Footfall Engine”)

* claim your place
* publish offers as spatial objects
* enable “community moments” (e.g., secret menu, local trivia)
* get aggregated analytics (privacy-preserving)

### 12.3 Events as high-intensity loops

CANVS can enable “micro-events” at neighborhood scale and “macro-events” for cities.

### 12.4 Premium

* personal memory vaults
* high-fidelity time capsules
* private group spaces
* advanced AI filters
* creator tools (capture, editing, moderation features)

---

## 13. Strategic Roadmap (2026–2030)

### 2026: Build the Core Loop (Phone-first, World-locked)

* MVP Spatial Browser (AR + map + time)
* Core primitives: pins, bubbles, capsules
* Anchor runtime v1 (multi-provider; confidence-aware rendering)
* Safety foundations (private by default, exclusions, rapid reporting)
* Pilot city strategy focused on areas with strong localization support

**Success looks like:**
People revisit places because CANVS *changes what the place feels like*.

### 2027: Scale the Meaning Graph (LLM + social)

* AI “Reality Filter” v1: summarization, semantic search, friend-memory surfacing
* Trails, drops, portals
* Local business claims + creator marketplace
* Web-native sharing for certain experiences (link opens AR view)

### 2028: Glass-Native Transition

* Early integrations for spatial computing platforms
* Always-on lightweight layer UX (“glanceable place context”)
* Spatial audio cues, hands-free capture
* Shared experiences in co-located sessions

### 2029: Platformization

* Public SDK for “place apps” (third-party layers)
* Verified civic layers (cities, museums, campuses)
* Standards alignment (portable XR workflows)

### 2030: The Spatial Social OS

* CANVS becomes the default “meaning layer” across devices
* Places become queryable, navigable, and emotionally legible
* The feed is obsolete as a primary social interface

---

## 14. The Big Opportunity: Why This Can Become a Once-a-Decade Platform

The social internet has had multiple eras:

1. **Web pages** (static)
2. **Feeds** (social graphs + algorithmic distribution)
3. **Messaging** (private networks)
4. **Spatial** (place as interface)

CANVS is built for the spatial era.

The infrastructure is converging:

* AR anchoring stacks exist across major ecosystems
* The AR Cloud concept supports persistent shared experiences
* Spatial computing devices are accelerating beyond labs
* Location-based AR has demonstrated real-world behavior change at scale

This creates a window where a “spatial social layer” can become:

* **the default discovery interface for cities**
* **the default memory interface for human life**
* **the default coordination layer for communities**
* **the default canvas for creators**
* **the default AR layer for glasses**

---

## 15. Conclusion: Build the Layer

CANVS is not “another app.”

It is a bet that the next interface is not a rectangle, not a feed, not a timeline.

It’s the world.

A world where no moment is lost—because the place remembers.
