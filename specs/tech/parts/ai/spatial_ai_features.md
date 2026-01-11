# Spatial AI Features for CANVS

## Comprehensive Research Document for Location Intelligence, Spatial Reasoning, AR Optimization, and Path Intelligence

**Version:** 1.0.0
**Date:** January 2026
**Status:** Research Complete
**Related Documents:**
- [AI Implementation Architecture](./ai_implementation_architecture.md)
- [Visionary Feature Integrations](./visionary_feature_integrations.md)
- [Tech Specs](../../mvp/specs/tech_specs.md)
- [VPS Research](../../../research/visual_positioning_systems/intro.md)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Location Intelligence](#2-location-intelligence)
3. [Spatial Reasoning](#3-spatial-reasoning)
4. [AR Content Optimization](#4-ar-content-optimization)
5. [Path and Trail Intelligence](#5-path-and-trail-intelligence)
6. [Implementation Priorities](#6-implementation-priorities)
7. [Edge vs Cloud Processing Strategy](#7-edge-vs-cloud-processing-strategy)
8. [AR Framework Integration Matrix](#8-ar-framework-integration-matrix)

---

## 1. Executive Summary

### Purpose

This document provides comprehensive research on spatial AI features that enable CANVS to understand, interpret, and optimize content placement within physical spaces. These capabilities transform CANVS from a simple location-tagged content platform into an intelligent spatial social layer.

### The Four Pillars of Spatial AI

| Pillar | Primary Goal | MVP Priority |
|--------|--------------|--------------|
| **Location Intelligence** | Understand place context and semantics | High |
| **Spatial Reasoning** | Comprehend 3D space and relationships | Medium |
| **AR Content Optimization** | Optimal content placement in AR | Low (v2) |
| **Path Intelligence** | Navigate and chain spatial experiences | Medium |

### Key Technical Constraints

Based on CANVS architecture:
- **MVP v1**: GPS-only with ~5-15m accuracy (urban canyon: 30-100m)
- **MVP v2**: VPS-enhanced with ARCore Geospatial API (~1-5m accuracy)
- **Stack**: Next.js PWA, Supabase, PostGIS, H3 hexagonal indexing
- **AR Runtime**: 8th Wall (web), ARKit/ARCore (native) - note 8th Wall deprecation Feb 2027

---

## 2. Location Intelligence

### 2.1 Place Type Classification

**Value Proposition:**
Automatically understand what type of place the user is at (cafe, park, museum, etc.) to contextualize content, suggest appropriate posting formats, and filter relevant nearby memories.

**Technical Implementation:**

```typescript
interface PlaceClassification {
  primaryType: PlaceType;           // e.g., 'restaurant', 'park', 'museum'
  secondaryTypes: PlaceType[];      // e.g., ['outdoor_dining', 'family_friendly']
  confidence: number;               // 0-1 classification confidence
  source: 'google_places' | 'osm' | 'foursquare' | 'ml_inference';
  semanticCategory: 'social' | 'work' | 'transit' | 'nature' | 'culture' | 'commerce';
}

// Implementation approach
async function classifyPlace(location: GeoPoint): Promise<PlaceClassification> {
  // 1. Query cached POI data from H3 cell
  const cachedPOIs = await getCachedPOIsForCell(locationToH3(location, 9));

  // 2. Reverse geocode if no cached data
  const placesData = cachedPOIs.length > 0
    ? cachedPOIs
    : await googlePlaces.nearbySearch({ location, radius: 50 });

  // 3. ML-based refinement using location features
  const features = extractLocationFeatures(location, placesData);
  const mlClassification = await edgeClassifier.classify(features);

  // 4. Merge sources with confidence weighting
  return mergeClassifications(placesData, mlClassification);
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment | Accuracy |
|---------------|---------|------------|----------|
| **Google Places API** | Primary POI data | Cloud | ~95% for mapped places |
| **Overture Maps Foundation** | Open POI data backup | Cloud/Self-hosted | ~85% coverage |
| **Custom Place2Vec** | Semantic place embeddings | Edge (Core ML/TFLite) | ~88% for place type |
| **BERT-based classifier** | Text-based place understanding | Cloud (GPT-4o-mini) | ~92% |

**AR Framework Integration:**

- **ARKit**: `ARGeoAnchor` provides location; combine with Core Location for place context
- **ARCore**: `Geospatial API` + Google Places integration native
- **8th Wall**: Use `XR8.GeoAnchorSystem` with external Places API calls

**Edge vs Cloud Processing:**

| Operation | Edge | Cloud | Recommendation |
|-----------|------|-------|----------------|
| POI lookup | Cache hit | API call | Edge-first with cache |
| Classification | TFLite model | GPT-4o-mini | Edge for common types |
| Semantic enrichment | - | Claude/GPT-4o | Cloud only |

---

### 2.2 Ambient Conditions Prediction

**Value Proposition:**
Predict environmental conditions (lighting, noise level, crowd density, weather impact) to optimize content consumption experience and suggest ideal viewing times.

**Technical Implementation:**

```typescript
interface AmbientConditions {
  lighting: {
    level: 'dark' | 'dim' | 'moderate' | 'bright' | 'harsh';
    naturalLight: boolean;
    predictedAt: Date;
  };
  noise: {
    level: 'quiet' | 'moderate' | 'loud' | 'very_loud';
    type: 'traffic' | 'crowd' | 'nature' | 'indoor' | 'mixed';
  };
  crowding: {
    density: 'empty' | 'sparse' | 'moderate' | 'crowded' | 'packed';
    predictedWaitTime: number; // minutes
  };
  weather: {
    condition: string;
    temperature: number;
    precipitation: boolean;
    uvIndex: number;
  };
}

// Prediction model combining multiple signals
async function predictAmbientConditions(
  location: GeoPoint,
  targetTime: Date
): Promise<AmbientConditions> {
  const [
    weatherData,
    popularTimesData,
    sunPosition,
    historicalNoise
  ] = await Promise.all([
    weatherAPI.getForecast(location, targetTime),
    googlePlaces.getPopularTimes(location),
    calculateSunPosition(location, targetTime),
    getHistoricalNoiseData(location, targetTime.getHours())
  ]);

  return {
    lighting: predictLighting(sunPosition, weatherData, getPlaceType(location)),
    noise: predictNoise(historicalNoise, popularTimesData, targetTime),
    crowding: predictCrowding(popularTimesData, targetTime),
    weather: formatWeather(weatherData)
  };
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Source |
|---------------|---------|--------|
| **OpenWeatherMap API** | Weather prediction | Cloud API |
| **Google Popular Times** | Crowd density prediction | Google Places API |
| **SunCalc.js** | Solar position calculation | npm package (edge) |
| **Custom LSTM model** | Noise level prediction | Edge (TFLite) |
| **Ambient Light Sensor API** | Real-time light detection | Device sensor |

**AR Framework Integration:**

- **ARKit**: Access `ARFrame.lightEstimate` for real-time ambient light
- **ARCore**: Use `LightEstimate` from `Frame` object
- **8th Wall**: `XR8.canvasWidth` for camera-based light estimation

**Edge vs Cloud Processing:**

| Data Type | Source | Processing |
|-----------|--------|------------|
| Current lighting | Device sensor | Edge |
| Weather | API | Cloud (cached 1hr) |
| Popular times | Google API | Cloud (cached 24hr) |
| Noise prediction | Historical + ML | Edge model |

---

### 2.3 Optimal Viewing Angle Suggestions

**Value Proposition:**
Recommend the best position and orientation for viewing AR content based on scene geometry, lighting conditions, and content type.

**Technical Implementation:**

```typescript
interface ViewingSuggestion {
  position: {
    lat: number;
    lng: number;
    altitude: number; // meters above ground
    accuracy: number;
  };
  orientation: {
    heading: number;    // compass degrees
    pitch: number;      // vertical angle
    distance: number;   // meters from content
  };
  reasoning: string;
  alternativeViews: ViewingSuggestion[];
}

// Calculate optimal viewing parameters
function calculateOptimalViewingAngle(
  contentAnchor: SpatialAnchor,
  contentType: 'text' | 'image' | 'model_3d' | 'audio',
  contentDimensions: Dimensions3D,
  userHeight: number = 1.7 // default eye height in meters
): ViewingSuggestion {
  // Ideal viewing distance based on content size
  const contentSize = Math.max(contentDimensions.width, contentDimensions.height);
  const idealDistance = calculateIdealDistance(contentSize, contentType);

  // Optimal angle for readability (typically 0-30 degrees below horizontal)
  const verticalOffset = contentAnchor.altitude - userHeight;
  const idealPitch = Math.atan2(verticalOffset, idealDistance) * (180 / Math.PI);

  // Consider lighting direction
  const sunDirection = getSunDirection(contentAnchor.location, new Date());
  const idealHeading = calculateHeadingAwayFromSun(sunDirection, contentAnchor);

  return {
    position: offsetPosition(contentAnchor.location, idealDistance, idealHeading),
    orientation: {
      heading: (idealHeading + 180) % 360, // Face the content
      pitch: clamp(idealPitch, -45, 45),
      distance: idealDistance
    },
    reasoning: `Optimal distance of ${idealDistance.toFixed(1)}m for ${contentType} content`,
    alternativeViews: generateAlternativeViews(contentAnchor, contentDimensions)
  };
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment |
|---------------|---------|------------|
| **Custom heuristics** | Basic angle calculation | Edge (JavaScript) |
| **Scene geometry from LiDAR** | Obstacle detection | Edge (ARKit) |
| **Place footprint data** | Accessible positions | Cloud (OSM/Places) |
| **Computer vision (YOLO)** | Crowd/obstacle detection | Edge (Core ML) |

**AR Framework Integration:**

- **ARKit**: Use `ARWorldTrackingConfiguration` with `sceneReconstruction` for geometry
- **ARCore**: Use `Depth API` for scene understanding
- **8th Wall**: Limited - use `XR8.Threejs.xrScene()` for basic scene access

---

### 2.4 Location Personality Profiling

**Value Proposition:**
Build semantic profiles of locations based on aggregated content, user interactions, and temporal patterns to enable discovery of places with specific "vibes" or characteristics.

**Technical Implementation:**

```typescript
interface LocationPersonality {
  h3Cell: string;                    // H3 resolution 9 cell ID

  // Semantic attributes (0-1 scale)
  attributes: {
    romantic: number;
    adventurous: number;
    peaceful: number;
    nostalgic: number;
    artistic: number;
    social: number;
    professional: number;
    family_friendly: number;
    nightlife: number;
    nature: number;
  };

  // Temporal patterns
  peakTimes: {
    weekday: HourRange[];
    weekend: HourRange[];
  };

  // Content statistics
  contentStats: {
    totalPosts: number;
    avgEngagement: number;
    dominantCategories: string[];
    emotionalTone: 'positive' | 'neutral' | 'mixed';
  };

  // Update metadata
  lastUpdated: Date;
  confidence: number;
}

// Build location personality from aggregated content
async function buildLocationPersonality(h3Cell: string): Promise<LocationPersonality> {
  // 1. Fetch all content in this cell
  const content = await fetchContentForCell(h3Cell, { limit: 1000 });

  // 2. Generate embeddings for content if not cached
  const embeddings = await getOrGenerateEmbeddings(content);

  // 3. Classify content into personality attributes
  const attributeScores = await classifyAttributes(content, embeddings);

  // 4. Analyze temporal patterns
  const temporalPatterns = analyzeTemporalPatterns(content);

  // 5. Calculate aggregate statistics
  const stats = calculateContentStats(content);

  return {
    h3Cell,
    attributes: normalizeScores(attributeScores),
    peakTimes: temporalPatterns,
    contentStats: stats,
    lastUpdated: new Date(),
    confidence: calculateConfidence(content.length)
  };
}

// Find locations matching personality query
async function findLocationsByPersonality(
  query: string,
  userLocation: GeoPoint,
  radiusKm: number
): Promise<LocationMatch[]> {
  // 1. Parse query into attribute weights
  const queryEmbedding = await generateQueryEmbedding(query);
  const attributeWeights = await parseQueryToAttributes(query);

  // 2. Get H3 cells in radius
  const cells = h3.gridDisk(h3.latLngToCell(userLocation.lat, userLocation.lng, 9),
    Math.ceil(radiusKm / 0.2)); // ~200m per res9 cell

  // 3. Fetch location personalities
  const personalities = await getLocationPersonalities(cells);

  // 4. Score and rank by similarity
  return personalities
    .map(p => ({
      cell: p.h3Cell,
      score: calculatePersonalityMatch(p.attributes, attributeWeights),
      personality: p
    }))
    .sort((a, b) => b.score - a.score)
    .slice(0, 20);
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment |
|---------------|---------|------------|
| **text-embedding-3-small** | Content embeddings | Cloud (OpenAI) |
| **Custom attribute classifier** | Multi-label classification | Cloud (Claude) |
| **Sentence Transformers** | Semantic similarity | Edge (ONNX) |
| **pgvector** | Vector similarity search | Cloud (Supabase) |

**Edge vs Cloud Processing:**

| Operation | Frequency | Processing |
|-----------|-----------|------------|
| Personality building | Batch (daily) | Cloud |
| Personality lookup | Per request | Edge (cached) |
| Query parsing | Per search | Cloud (LLM) |
| Similarity scoring | Per search | Edge (after fetch) |

---

## 3. Spatial Reasoning

### 3.1 Occlusion-Aware Content Placement

**Value Proposition:**
Ensure AR content is placed in visible locations that don't clip through walls, objects, or other environmental features, creating a more believable and usable AR experience.

**Technical Implementation:**

```typescript
interface OcclusionResult {
  isOccluded: boolean;
  occlusionPercentage: number;      // 0-100
  occludingElements: OccludingElement[];
  suggestedAlternatives: Pose3D[];
  visibilityScore: number;          // 0-1, 1 = fully visible
}

interface OccludingElement {
  type: 'wall' | 'furniture' | 'person' | 'vegetation' | 'vehicle' | 'unknown';
  boundingBox: BoundingBox3D;
  distance: number;
}

// Check content visibility from user position
function checkOcclusion(
  contentPose: Pose3D,
  userPosition: Vector3,
  sceneGeometry: SceneMesh
): OcclusionResult {
  // Cast rays from user to content corners
  const contentCorners = getContentBoundingCorners(contentPose);
  const occlusionResults = contentCorners.map(corner => {
    const ray = createRay(userPosition, corner);
    return castRayAgainstScene(ray, sceneGeometry);
  });

  // Calculate visibility percentage
  const visibleCorners = occlusionResults.filter(r => !r.hit).length;
  const visibilityScore = visibleCorners / contentCorners.length;

  // Identify occluding elements
  const occluders = occlusionResults
    .filter(r => r.hit)
    .map(r => classifyOccluder(r.hitPoint, r.hitNormal, sceneGeometry));

  return {
    isOccluded: visibilityScore < 0.8,
    occlusionPercentage: (1 - visibilityScore) * 100,
    occludingElements: deduplicateOccluders(occluders),
    suggestedAlternatives: visibilityScore < 0.8
      ? findAlternativePlacements(contentPose, sceneGeometry)
      : [],
    visibilityScore
  };
}

// Find better placement if occluded
function findAlternativePlacements(
  originalPose: Pose3D,
  sceneGeometry: SceneMesh,
  maxSearchRadius: number = 2.0
): Pose3D[] {
  const candidates: Pose3D[] = [];

  // Grid search around original position
  for (let dx = -maxSearchRadius; dx <= maxSearchRadius; dx += 0.5) {
    for (let dy = -maxSearchRadius; dy <= maxSearchRadius; dy += 0.5) {
      for (let dz = -0.5; dz <= 0.5; dz += 0.25) {
        const candidatePose = offsetPose(originalPose, dx, dy, dz);

        // Check if candidate is valid
        if (isValidPlacement(candidatePose, sceneGeometry)) {
          const occlusion = checkOcclusion(candidatePose, getUserPosition(), sceneGeometry);
          if (occlusion.visibilityScore > 0.9) {
            candidates.push({
              ...candidatePose,
              score: occlusion.visibilityScore
            });
          }
        }
      }
    }
  }

  return candidates.sort((a, b) => b.score - a.score).slice(0, 5);
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment |
|---------------|---------|------------|
| **ARKit Scene Reconstruction** | Real-time mesh generation | Edge (iOS 14+) |
| **ARCore Depth API** | Depth maps for occlusion | Edge (Android) |
| **LiDAR Scanner** | High-precision geometry | Edge (iPhone Pro) |
| **MiDaS/DPT** | Monocular depth estimation | Edge (TFLite) |
| **Three.js Raycaster** | Ray-mesh intersection | Edge (JavaScript) |

**AR Framework Integration:**

```swift
// ARKit Scene Reconstruction (iOS)
let configuration = ARWorldTrackingConfiguration()
configuration.sceneReconstruction = .meshWithClassification
configuration.frameSemantics = .sceneDepth

// Check occlusion using scene anchors
func checkOcclusion(from: simd_float3, to: simd_float3) -> Bool {
    let raycastQuery = ARRaycastQuery(
        origin: from,
        direction: normalize(to - from),
        allowing: .existingPlaneGeometry,
        alignment: .any
    )

    let results = session.raycast(raycastQuery)
    return results.first.map {
        distance($0.worldTransform.columns.3.xyz, from) < distance(to, from)
    } ?? false
}
```

```java
// ARCore Depth API (Android)
Frame frame = session.update();
DepthImage depthImage = frame.acquireDepthImage16Bits();

// Sample depth at content screen position
int depthMm = depthImage.getDepthInMillimeters(contentScreenX, contentScreenY);
float contentDistance = calculateContentDistance(contentPose, cameraPose);

boolean isOccluded = (depthMm / 1000.0f) < contentDistance;
```

**Edge vs Cloud:**

All occlusion processing must be edge-based for real-time performance:
- Scene mesh generation: Edge (ARKit/ARCore native)
- Raycasting: Edge (GPU-accelerated)
- Alternative placement search: Edge (optimized grid search)

---

### 3.2 Semantic Scene Understanding

**Value Proposition:**
Understand what objects and surfaces exist in the scene to enable intelligent content placement (e.g., place restaurant review near the restaurant entrance, not on a tree).

**Technical Implementation:**

```typescript
interface SemanticScene {
  planes: SemanticPlane[];
  objects: DetectedObject[];
  regions: SemanticRegion[];
  sceneType: 'indoor' | 'outdoor' | 'mixed';
  navigableArea: Polygon[];
}

interface SemanticPlane {
  id: string;
  type: 'floor' | 'wall' | 'ceiling' | 'table' | 'seat' | 'door' | 'window';
  geometry: PlaneGeometry;
  area: number;           // square meters
  suitableForContent: boolean;
  placementRecommendation: 'preferred' | 'acceptable' | 'avoid';
}

interface DetectedObject {
  id: string;
  label: string;          // e.g., 'chair', 'plant', 'sign'
  confidence: number;
  boundingBox: BoundingBox3D;
  semanticAnchorType: 'anchor_to' | 'avoid' | 'neutral';
}

// Build semantic scene model
async function buildSemanticScene(
  arFrame: ARFrame,
  sceneAnchors: ARAnchor[]
): Promise<SemanticScene> {
  // 1. Extract planes with classification (ARKit 4+)
  const classifiedPlanes = sceneAnchors
    .filter(isPlaneAnchor)
    .map(anchor => ({
      id: anchor.identifier,
      type: classifyPlane(anchor.classification),
      geometry: anchor.geometry,
      area: calculatePlaneArea(anchor),
      suitableForContent: evaluatePlacementSuitability(anchor),
      placementRecommendation: getPlacementRecommendation(anchor.classification)
    }));

  // 2. Detect objects using vision model
  const cameraImage = arFrame.capturedImage;
  const detections = await objectDetector.detect(cameraImage);

  // 3. Project 2D detections to 3D using depth
  const depthMap = arFrame.sceneDepth?.depthMap;
  const objects3D = await project2DTo3D(detections, depthMap, arFrame.camera);

  // 4. Identify semantic regions
  const regions = identifyRegions(classifiedPlanes, objects3D);

  return {
    planes: classifiedPlanes,
    objects: objects3D,
    regions,
    sceneType: determineSceneType(classifiedPlanes),
    navigableArea: extractNavigableArea(classifiedPlanes)
  };
}

// Find optimal anchor point for content
function findSemanticAnchor(
  scene: SemanticScene,
  contentType: ContentType,
  preferredSemantics: string[]
): AnchorRecommendation {
  // Score each plane based on content requirements
  const scoredPlanes = scene.planes
    .filter(p => p.suitableForContent)
    .map(plane => ({
      plane,
      score: calculateSemanticScore(plane, contentType, preferredSemantics)
    }))
    .sort((a, b) => b.score - a.score);

  if (scoredPlanes.length === 0) {
    return { type: 'floating', reason: 'No suitable surfaces detected' };
  }

  const best = scoredPlanes[0];
  return {
    type: 'surface',
    planeId: best.plane.id,
    position: calculateOptimalPosition(best.plane, contentType),
    orientation: calculateOptimalOrientation(best.plane, scene),
    reason: `Anchored to ${best.plane.type} with score ${best.score.toFixed(2)}`
  };
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment | Performance |
|---------------|---------|------------|-------------|
| **ARKit Plane Classification** | Plane semantic labels | Edge (iOS) | Native, real-time |
| **ARCore Scene Semantics** | Outdoor scene parsing | Edge (Android) | ~30fps |
| **YOLO v8** | Object detection | Edge (Core ML/TFLite) | ~60fps mobile |
| **Segment Anything (SAM)** | Instance segmentation | Cloud/Edge | ~1-2 sec per frame |
| **DeepLab v3** | Semantic segmentation | Edge (TFLite) | ~100ms |
| **Custom scene classifier** | Scene type detection | Edge | ~10ms |

**AR Framework Integration:**

```swift
// ARKit Plane Classification
func classifyPlane(_ classification: ARPlaneAnchor.Classification) -> String {
    switch classification {
    case .wall: return "wall"
    case .floor: return "floor"
    case .ceiling: return "ceiling"
    case .table: return "table"
    case .seat: return "seat"
    case .door: return "door"
    case .window: return "window"
    case .none, .notAvailable: return "unknown"
    @unknown default: return "unknown"
    }
}
```

---

### 3.3 Indoor/Outdoor Detection

**Value Proposition:**
Accurately determine if user is indoors or outdoors to adjust GPS confidence, enable appropriate AR features, and contextualize content recommendations.

**Technical Implementation:**

```typescript
interface IndoorOutdoorResult {
  environment: 'indoor' | 'outdoor' | 'semi_outdoor' | 'underground' | 'unknown';
  confidence: number;
  signals: EnvironmentSignal[];
  gpsReliability: 'high' | 'medium' | 'low' | 'none';
  recommendedPositioning: 'gps' | 'wifi' | 'bluetooth' | 'vps' | 'dead_reckoning';
}

interface EnvironmentSignal {
  source: 'gps' | 'light' | 'barometer' | 'magnetometer' | 'wifi' | 'vision' | 'audio';
  value: any;
  weight: number;
  indication: 'indoor' | 'outdoor' | 'neutral';
}

// Multi-signal indoor/outdoor detection
async function detectIndoorOutdoor(
  sensors: SensorData,
  cameraFrame?: ImageData
): Promise<IndoorOutdoorResult> {
  const signals: EnvironmentSignal[] = [];

  // GPS signal strength
  const gpsSignal = evaluateGPSSignal(sensors.gps);
  signals.push({
    source: 'gps',
    value: gpsSignal,
    weight: 0.3,
    indication: gpsSignal.accuracy < 10 ? 'outdoor' :
                gpsSignal.accuracy > 50 ? 'indoor' : 'neutral'
  });

  // Ambient light level
  const lightLevel = sensors.ambientLight?.lux ?? 0;
  signals.push({
    source: 'light',
    value: lightLevel,
    weight: 0.2,
    indication: lightLevel > 5000 ? 'outdoor' :
                lightLevel < 500 ? 'indoor' : 'neutral'
  });

  // Barometric pressure stability
  if (sensors.barometer) {
    const pressureVariance = calculatePressureVariance(sensors.barometer.history);
    signals.push({
      source: 'barometer',
      value: pressureVariance,
      weight: 0.15,
      indication: pressureVariance < 0.1 ? 'indoor' :
                  pressureVariance > 0.5 ? 'outdoor' : 'neutral'
    });
  }

  // Magnetic field anomalies (indoor buildings have distortions)
  const magneticAnomaly = calculateMagneticAnomaly(sensors.magnetometer);
  signals.push({
    source: 'magnetometer',
    value: magneticAnomaly,
    weight: 0.1,
    indication: magneticAnomaly > 0.3 ? 'indoor' : 'neutral'
  });

  // WiFi availability (more APs usually indoor)
  const wifiCount = sensors.wifi?.accessPoints.length ?? 0;
  signals.push({
    source: 'wifi',
    value: wifiCount,
    weight: 0.1,
    indication: wifiCount > 10 ? 'indoor' :
                wifiCount < 2 ? 'outdoor' : 'neutral'
  });

  // Vision-based detection (sky, ceiling)
  if (cameraFrame) {
    const visionResult = await visionDetector.detectEnvironment(cameraFrame);
    signals.push({
      source: 'vision',
      value: visionResult,
      weight: 0.15,
      indication: visionResult.hasSky ? 'outdoor' :
                  visionResult.hasCeiling ? 'indoor' : 'neutral'
    });
  }

  // Weighted voting
  const indoorScore = signals
    .filter(s => s.indication === 'indoor')
    .reduce((sum, s) => sum + s.weight, 0);

  const outdoorScore = signals
    .filter(s => s.indication === 'outdoor')
    .reduce((sum, s) => sum + s.weight, 0);

  const environment = outdoorScore > indoorScore + 0.2 ? 'outdoor' :
                      indoorScore > outdoorScore + 0.2 ? 'indoor' : 'semi_outdoor';

  return {
    environment,
    confidence: Math.abs(outdoorScore - indoorScore) + 0.5,
    signals,
    gpsReliability: environment === 'outdoor' ? 'high' :
                    environment === 'semi_outdoor' ? 'medium' : 'low',
    recommendedPositioning: getRecommendedPositioning(environment, signals)
  };
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment |
|---------------|---------|------------|
| **MobileNet Scene Classification** | Sky/ceiling detection | Edge (TFLite/Core ML) |
| **Custom sensor fusion model** | Multi-sensor classification | Edge (TensorFlow Lite) |
| **iOS Indoor Maps** | Apple's indoor detection | Edge (iOS native) |
| **Google Fused Location Provider** | Android sensor fusion | Edge (Android native) |

**Edge vs Cloud:**
All indoor/outdoor detection must be edge-based for:
- Real-time responsiveness
- Offline functionality
- Privacy (sensor data stays on device)

---

### 3.4 Multi-Floor Building Understanding

**Value Proposition:**
Distinguish between floors in multi-story buildings to prevent content from different floors mixing, enable floor-specific navigation, and improve location accuracy in vertical spaces.

**Technical Implementation:**

```typescript
interface FloorEstimate {
  floor: number;                     // 0 = ground, positive = above, negative = below
  confidence: number;
  buildingId: string | null;         // If known building
  method: 'barometer' | 'wifi_fingerprint' | 'vps' | 'user_input' | 'elevator_detection';
  altitude: {
    absolute: number;                // Meters above sea level
    relative: number;                // Meters above ground floor
  };
}

interface BuildingModel {
  id: string;
  name: string;
  groundFloorAltitude: number;      // Meters above sea level
  floorHeight: number;              // Average meters per floor
  totalFloors: number;
  hasBasement: boolean;
  wifiFingerprints?: FloorFingerprint[];
}

// Estimate current floor
async function estimateFloor(
  sensors: SensorData,
  knownBuilding?: BuildingModel
): Promise<FloorEstimate> {
  // Method 1: Barometric altitude (most common)
  const baroAltitude = sensors.barometer
    ? calculateAltitudeFromPressure(sensors.barometer.pressure, sensors.barometer.seaLevelPressure)
    : null;

  // Method 2: WiFi fingerprinting (if available)
  const wifiFloor = knownBuilding?.wifiFingerprints
    ? matchWifiFingerprint(sensors.wifi, knownBuilding.wifiFingerprints)
    : null;

  // Method 3: Elevator detection (change in altitude without horizontal movement)
  const elevatorChange = detectElevatorMovement(sensors.accelerometer, sensors.barometer);

  // Method 4: VPS floor detection (if ARCore Geospatial Creator building)
  const vpsFloor = await checkVPSFloorData(sensors.gps);

  // Combine estimates
  if (knownBuilding) {
    const relativeAltitude = baroAltitude - knownBuilding.groundFloorAltitude;
    const estimatedFloor = Math.round(relativeAltitude / knownBuilding.floorHeight);

    return {
      floor: clamp(estimatedFloor, -2, knownBuilding.totalFloors),
      confidence: wifiFloor ? 0.9 : 0.7,
      buildingId: knownBuilding.id,
      method: wifiFloor ? 'wifi_fingerprint' : 'barometer',
      altitude: {
        absolute: baroAltitude,
        relative: relativeAltitude
      }
    };
  }

  // Unknown building - use heuristics
  return {
    floor: estimateFloorFromAltitudeChange(sensors.barometer.history),
    confidence: 0.5,
    buildingId: null,
    method: 'barometer',
    altitude: {
      absolute: baroAltitude,
      relative: 0 // Unknown reference
    }
  };
}

// Detect vertical movement (elevator, stairs)
function detectElevatorMovement(
  accelerometer: AccelerometerData[],
  barometer: BarometerData[]
): { detected: boolean; direction: 'up' | 'down' | 'none'; floors: number } {
  const altitudeChange = barometer[barometer.length - 1].altitude - barometer[0].altitude;
  const horizontalMovement = calculateHorizontalMovement(accelerometer);

  // Elevator: significant altitude change with minimal horizontal movement
  if (Math.abs(altitudeChange) > 2 && horizontalMovement < 5) {
    return {
      detected: true,
      direction: altitudeChange > 0 ? 'up' : 'down',
      floors: Math.round(Math.abs(altitudeChange) / 3.5) // ~3.5m per floor average
    };
  }

  return { detected: false, direction: 'none', floors: 0 };
}
```

**ML Models and Packages:**

| Model/Package | Purpose | Deployment |
|---------------|---------|------------|
| **CMAltimeter (iOS)** | Barometric altitude | Edge (iOS native) |
| **SensorManager (Android)** | Barometer/accelerometer | Edge (Android native) |
| **Indoor Atlas SDK** | WiFi fingerprint mapping | Cloud + Edge |
| **Custom elevator detector** | Motion pattern recognition | Edge (TFLite) |

---

## 4. AR Content Optimization

### 4.1 Monocular Depth Estimation

**Value Proposition:**
Estimate scene depth from a single camera image on devices without LiDAR or dedicated depth sensors, enabling occlusion and placement features for all users.

**Technical Implementation:**

```typescript
interface DepthMap {
  width: number;
  height: number;
  data: Float32Array;               // Depth values in meters
  confidence: Float32Array;         // Per-pixel confidence 0-1
  minDepth: number;
  maxDepth: number;
  timestamp: number;
}

// Generate depth map from camera frame
async function estimateDepth(
  cameraFrame: ImageData,
  cameraIntrinsics: CameraIntrinsics
): Promise<DepthMap> {
  // Resize input to model expected size
  const inputTensor = preprocessForDepth(cameraFrame, 384, 384);

  // Run inference
  const rawDepth = await depthModel.predict(inputTensor);

  // Post-process: scale to metric depth
  const metricDepth = applyMetricScaling(rawDepth, cameraIntrinsics);

  // Generate confidence map
  const confidence = estimateDepthConfidence(metricDepth);

  return {
    width: 384,
    height: 384,
    data: metricDepth,
    confidence,
    minDepth: findMin(metricDepth),
    maxDepth: findMax(metricDepth),
    timestamp: Date.now()
  };
}

// Sample depth at specific screen coordinate
function sampleDepth(
  depthMap: DepthMap,
  screenX: number,
  screenY: number,
  screenWidth: number,
  screenHeight: number
): { depth: number; confidence: number } {
  // Map screen coordinates to depth map coordinates
  const depthX = Math.floor((screenX / screenWidth) * depthMap.width);
  const depthY = Math.floor((screenY / screenHeight) * depthMap.height);

  const index = depthY * depthMap.width + depthX;

  return {
    depth: depthMap.data[index],
    confidence: depthMap.confidence[index]
  };
}

// Use depth for content placement
function placeContentAtDepth(
  screenTapPoint: Point2D,
  depthMap: DepthMap,
  camera: Camera
): Pose3D {
  const { depth, confidence } = sampleDepth(depthMap, screenTapPoint.x, screenTapPoint.y);

  if (confidence < 0.5) {
    throw new Error('Low confidence depth - ask user to move');
  }

  // Unproject screen point to 3D using depth
  const worldPoint = camera.unproject(screenTapPoint, depth);

  // Estimate surface normal from surrounding depth values
  const normal = estimateSurfaceNormal(depthMap, screenTapPoint.x, screenTapPoint.y);

  return {
    position: worldPoint,
    rotation: quaternionFromNormal(normal),
    scale: { x: 1, y: 1, z: 1 }
  };
}
```

**ML Models and Packages:**

| Model | Input Size | Speed (Mobile) | Accuracy | Size |
|-------|------------|----------------|----------|------|
| **MiDaS v3.1** | 384x384 | ~100ms | High (relative) | ~100MB |
| **DPT-Hybrid** | 384x384 | ~150ms | Very High | ~350MB |
| **Depth Anything v2** | 518x518 | ~80ms | State-of-art | ~97MB |
| **ZoeDepth** | 384x512 | ~120ms | High (metric) | ~340MB |
| **FastDepth** | 224x224 | ~20ms | Moderate | ~5MB |

**Recommendation for CANVS:**
- **Primary**: Depth Anything v2 (best quality, reasonable speed)
- **Fallback**: FastDepth for low-end devices
- **LiDAR devices**: Use native ARKit/ARCore depth (preferred)

**AR Framework Integration:**

```swift
// ARKit native depth (iPhone 12 Pro+)
if let sceneDepth = frame.sceneDepth {
    let depthMap = sceneDepth.depthMap
    let confidenceMap = sceneDepth.confidenceMap

    // Sample depth at point
    let depthValue = sampleDepth(depthMap, at: screenPoint)
}

// Fallback to ML depth estimation
else {
    let mlDepth = await depthEstimator.predict(frame.capturedImage)
}
```

```kotlin
// ARCore Depth API (Android)
val frame = session.update()

if (session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
    val depthImage = frame.acquireDepthImage16Bits()
    val confidenceImage = frame.acquireRawDepthConfidenceImage()

    // Use native depth
} else {
    // Fallback to ML depth
    val mlDepth = depthEstimator.estimate(frame.image)
}
```

**8th Wall Integration:**

```javascript
// 8th Wall depth estimation
XR8.addCameraPipelineModule({
  name: 'depth-estimation',
  onProcessCpu: ({ frameBufferRgba, frameBufferWidth, frameBufferHeight }) => {
    // Run depth model on camera frame
    const depthResult = await depthModel.predict(frameBufferRgba);

    // Store for use in rendering
    currentDepthMap = depthResult;
  }
});
```

---

### 4.2 Anchor Point Detection

**Value Proposition:**
Automatically identify good anchoring surfaces and points in the scene for stable AR content placement, reducing user effort and improving placement quality.

**Technical Implementation:**

```typescript
interface AnchorCandidate {
  position: Vector3;
  normal: Vector3;
  type: 'horizontal' | 'vertical' | 'angled';
  surfaceType: 'floor' | 'wall' | 'table' | 'ceiling' | 'unknown';
  area: number;                     // Square meters of available surface
  stability: number;                // 0-1, tracking stability score
  suitability: {
    text: number;
    image: number;
    model3d: number;
    video: number;
  };
}

// Detect and rank anchor candidates
async function detectAnchorCandidates(
  arFrame: ARFrame,
  contentType: ContentType
): Promise<AnchorCandidate[]> {
  const candidates: AnchorCandidate[] = [];

  // Get detected planes from AR system
  const planes = arFrame.detectedPlanes;

  for (const plane of planes) {
    // Calculate suitability scores
    const suitability = calculateSuitability(plane, contentType);

    // Evaluate tracking stability
    const stability = evaluatePlaneStability(plane, previousFrames);

    if (stability > 0.7) { // Only consider stable planes
      candidates.push({
        position: plane.center,
        normal: plane.normal,
        type: classifyPlaneOrientation(plane.normal),
        surfaceType: plane.classification,
        area: calculatePlaneArea(plane),
        stability,
        suitability
      });
    }
  }

  // Also detect feature points for smaller content
  const featurePoints = arFrame.rawFeaturePoints;
  const clusteredPoints = clusterFeaturePoints(featurePoints, 0.1);

  for (const cluster of clusteredPoints) {
    if (cluster.points.length > 20) { // Sufficient features for tracking
      const normal = estimateNormalFromPoints(cluster.points);

      candidates.push({
        position: cluster.centroid,
        normal,
        type: classifyPlaneOrientation(normal),
        surfaceType: 'unknown',
        area: 0.1, // Approximate small area
        stability: cluster.points.length / 100,
        suitability: {
          text: 0.6,
          image: 0.5,
          model3d: 0.3,
          video: 0.4
        }
      });
    }
  }

  // Rank by suitability for content type
  return candidates
    .sort((a, b) => b.suitability[contentType] - a.suitability[contentType])
    .slice(0, 10);
}

// Calculate suitability scores
function calculateSuitability(
  plane: DetectedPlane,
  contentType: ContentType
): Record<ContentType, number> {
  const baseScore = plane.area > 0.5 ? 1.0 : plane.area * 2;

  return {
    text: baseScore * (plane.classification === 'wall' ? 1.0 : 0.7),
    image: baseScore * (plane.classification === 'wall' ? 1.0 : 0.8),
    model3d: baseScore * (plane.classification === 'floor' || plane.classification === 'table' ? 1.0 : 0.5),
    video: baseScore * (plane.classification === 'wall' ? 1.0 : 0.6)
  };
}
```

**ML Models and Packages:**

| Component | Technology | Purpose |
|-----------|------------|---------|
| **ARKit Plane Detection** | Native iOS | Primary plane detection |
| **ARCore Plane Detection** | Native Android | Primary plane detection |
| **8th Wall SLAM** | WebXR | Web-based plane detection |
| **ORB-SLAM3** | Open source | Backup/custom SLAM |
| **SuperPoint + SuperGlue** | Neural feature detection | Enhanced feature matching |

---

### 4.3 Visibility and Readability Prediction

**Value Proposition:**
Predict whether AR content will be visible and readable given current environmental conditions, suggesting optimizations or alternative placements.

**Technical Implementation:**

```typescript
interface VisibilityPrediction {
  overallScore: number;             // 0-1
  factors: {
    lighting: VisibilityFactor;
    contrast: VisibilityFactor;
    distance: VisibilityFactor;
    angle: VisibilityFactor;
    occlusion: VisibilityFactor;
    motion: VisibilityFactor;
  };
  recommendations: VisibilityRecommendation[];
  optimalConditions: {
    timeOfDay: string[];
    weather: string[];
    distance: { min: number; max: number };
  };
}

interface VisibilityFactor {
  score: number;
  issue: string | null;
  severity: 'none' | 'minor' | 'moderate' | 'severe';
}

// Predict content visibility
async function predictVisibility(
  contentPose: Pose3D,
  contentConfig: ContentConfig,
  userPose: Pose3D,
  environmentData: EnvironmentData
): Promise<VisibilityPrediction> {
  const factors: VisibilityPrediction['factors'] = {
    lighting: evaluateLighting(contentPose, environmentData.light, contentConfig),
    contrast: evaluateContrast(contentConfig.colors, environmentData.backgroundColor),
    distance: evaluateDistance(contentPose, userPose, contentConfig),
    angle: evaluateViewingAngle(contentPose, userPose),
    occlusion: await checkOcclusionScore(contentPose, userPose, environmentData.sceneGeometry),
    motion: evaluateMotionBlur(userPose.velocity, contentConfig)
  };

  // Calculate overall score
  const weights = {
    lighting: 0.2,
    contrast: 0.2,
    distance: 0.2,
    angle: 0.15,
    occlusion: 0.15,
    motion: 0.1
  };

  const overallScore = Object.entries(factors).reduce(
    (sum, [key, factor]) => sum + factor.score * weights[key],
    0
  );

  // Generate recommendations
  const recommendations = generateRecommendations(factors, contentConfig);

  return {
    overallScore,
    factors,
    recommendations,
    optimalConditions: calculateOptimalConditions(contentPose, contentConfig)
  };
}

// Evaluate lighting conditions
function evaluateLighting(
  contentPose: Pose3D,
  lightData: LightEstimate,
  contentConfig: ContentConfig
): VisibilityFactor {
  const ambientIntensity = lightData.ambientIntensity; // 0-2000 lux typical

  // Different content types have different lighting needs
  const thresholds = {
    text: { min: 100, max: 10000, optimal: 500 },
    image: { min: 50, max: 20000, optimal: 1000 },
    video: { min: 50, max: 5000, optimal: 200 },
    model3d: { min: 100, max: 50000, optimal: 2000 }
  };

  const threshold = thresholds[contentConfig.type];

  if (ambientIntensity < threshold.min) {
    return {
      score: ambientIntensity / threshold.min,
      issue: 'Too dark for comfortable viewing',
      severity: ambientIntensity < threshold.min / 2 ? 'severe' : 'moderate'
    };
  }

  if (ambientIntensity > threshold.max) {
    return {
      score: threshold.max / ambientIntensity,
      issue: 'Direct sunlight reducing visibility',
      severity: ambientIntensity > threshold.max * 2 ? 'severe' : 'moderate'
    };
  }

  // In optimal range
  const optimalDistance = Math.abs(ambientIntensity - threshold.optimal);
  const optimalRange = threshold.max - threshold.min;

  return {
    score: 1 - (optimalDistance / optimalRange) * 0.3,
    issue: null,
    severity: 'none'
  };
}

// Generate visibility recommendations
function generateRecommendations(
  factors: VisibilityPrediction['factors'],
  contentConfig: ContentConfig
): VisibilityRecommendation[] {
  const recommendations: VisibilityRecommendation[] = [];

  if (factors.lighting.severity !== 'none') {
    if (factors.lighting.issue?.includes('dark')) {
      recommendations.push({
        type: 'content_adjustment',
        action: 'Increase content brightness or add glow effect',
        priority: factors.lighting.severity === 'severe' ? 'high' : 'medium'
      });
    } else {
      recommendations.push({
        type: 'timing',
        action: 'Content best viewed in morning or evening',
        priority: 'low'
      });
    }
  }

  if (factors.distance.severity !== 'none') {
    recommendations.push({
      type: 'user_guidance',
      action: `Move ${factors.distance.issue?.includes('far') ? 'closer' : 'back'} for optimal viewing`,
      priority: 'medium'
    });
  }

  if (factors.contrast.severity !== 'none') {
    recommendations.push({
      type: 'content_adjustment',
      action: 'Add background or outline for better contrast',
      priority: factors.contrast.severity === 'severe' ? 'high' : 'medium'
    });
  }

  return recommendations;
}
```

**ML Models and Packages:**

| Model/Technology | Purpose | Deployment |
|------------------|---------|------------|
| **ARKit Light Estimation** | Ambient lighting analysis | Edge (iOS) |
| **ARCore Lighting Estimation** | Ambient + directional light | Edge (Android) |
| **Custom contrast analyzer** | Text/background contrast | Edge (JavaScript) |
| **Motion blur predictor** | Readability under motion | Edge (heuristic) |

---

### 4.4 Scale and Positioning Recommendations

**Value Proposition:**
Automatically calculate optimal scale and position for AR content based on viewing distance, content type, and environmental context.

**Technical Implementation:**

```typescript
interface ScaleRecommendation {
  scale: Vector3;
  position: Vector3;
  rotation: Quaternion;
  reasoning: string;
  alternatives: {
    scale: Vector3;
    useCase: string;
  }[];
}

// Calculate optimal scale for content
function calculateOptimalScale(
  contentType: ContentType,
  contentDimensions: Dimensions,
  viewingDistance: number,
  surfaceType: SurfaceType
): ScaleRecommendation {
  // Base scale on human perception and readability
  const MIN_TEXT_HEIGHT_DEG = 0.3;  // Minimum text angular size in degrees
  const OPTIMAL_TEXT_HEIGHT_DEG = 0.7;
  const MAX_CONTENT_FOV_PERCENT = 0.6;  // Don't fill more than 60% of FOV

  let optimalScale: Vector3;
  let reasoning: string;

  switch (contentType) {
    case 'text':
      // Text needs to be readable at distance
      const textHeightM = 2 * viewingDistance * Math.tan((OPTIMAL_TEXT_HEIGHT_DEG * Math.PI) / 360);
      const textScale = textHeightM / contentDimensions.height;
      optimalScale = { x: textScale, y: textScale, z: 1 };
      reasoning = `Text scaled for readability at ${viewingDistance.toFixed(1)}m`;
      break;

    case 'image':
    case 'video':
      // Images/video: balance visibility with context
      const imageAngularSize = 30; // degrees
      const imageSizeM = 2 * viewingDistance * Math.tan((imageAngularSize * Math.PI) / 360);
      const imageScale = Math.min(
        imageSizeM / Math.max(contentDimensions.width, contentDimensions.height),
        3.0 // Max 3x original size
      );
      optimalScale = { x: imageScale, y: imageScale, z: 1 };
      reasoning = `Image scaled to ${imageAngularSize}deg visual angle`;
      break;

    case 'model_3d':
      // 3D models: consider surface and context
      const maxDimension = Math.max(
        contentDimensions.width,
        contentDimensions.height,
        contentDimensions.depth
      );

      // Scale based on surface type
      const surfaceScales = {
        floor: Math.min(1.0, 2.0 / maxDimension),   // Human-scale max
        table: Math.min(0.3, 0.5 / maxDimension),   // Tabletop scale
        wall: Math.min(0.5, 1.0 / maxDimension),    // Moderate wall size
        floating: Math.min(0.4, 0.8 / maxDimension) // Floating reasonable size
      };

      const modelScale = surfaceScales[surfaceType] || 0.5;
      optimalScale = { x: modelScale, y: modelScale, z: modelScale };
      reasoning = `3D model scaled for ${surfaceType} placement`;
      break;

    default:
      optimalScale = { x: 1, y: 1, z: 1 };
      reasoning = 'Default scale';
  }

  // Calculate position offset based on content and surface
  const position = calculatePositionOffset(contentType, optimalScale, surfaceType, viewingDistance);

  // Calculate rotation to face user
  const rotation = calculateFacingRotation(surfaceType);

  return {
    scale: optimalScale,
    position,
    rotation,
    reasoning,
    alternatives: generateAlternativeScales(contentType, viewingDistance)
  };
}

// Position offset based on content type
function calculatePositionOffset(
  contentType: ContentType,
  scale: Vector3,
  surfaceType: SurfaceType,
  viewingDistance: number
): Vector3 {
  const scaledHeight = scale.y * 1.0; // Assume 1m base height

  switch (surfaceType) {
    case 'floor':
      // Raise content to eye level for viewing
      return {
        x: 0,
        y: 1.5 - scaledHeight / 2, // Eye level minus half height
        z: viewingDistance
      };

    case 'wall':
      // Center on wall at eye level
      return {
        x: 0,
        y: 1.5, // Eye level
        z: 0.05 // Slight offset from wall
      };

    case 'table':
      // Above table surface
      return {
        x: 0,
        y: 0.75 + scaledHeight / 2, // Table height + half content height
        z: 0
      };

    default:
      // Floating in front of user
      return {
        x: 0,
        y: 1.5,
        z: viewingDistance
      };
  }
}
```

**ML Models and Packages:**

| Component | Purpose | Implementation |
|-----------|---------|----------------|
| **Custom heuristics** | Basic scale calculation | Edge (TypeScript) |
| **User preference learning** | Personalized scaling | Cloud (user profiles) |
| **A/B testing framework** | Optimize recommendations | Cloud (analytics) |
| **Accessibility adjustments** | Vision impairment scaling | Edge (device settings) |

---

## 5. Path and Trail Intelligence

### 5.1 Walkable Path Generation

**Value Proposition:**
Generate pedestrian-safe walking routes between points of interest, considering sidewalks, crosswalks, pedestrian zones, and avoiding obstacles.

**Technical Implementation:**

```typescript
interface WalkablePath {
  waypoints: GeoPoint[];
  totalDistance: number;            // meters
  estimatedDuration: number;        // seconds
  segments: PathSegment[];
  accessibility: AccessibilityInfo;
  safetyScore: number;              // 0-1
  scenicScore: number;              // 0-1
}

interface PathSegment {
  start: GeoPoint;
  end: GeoPoint;
  type: 'sidewalk' | 'crosswalk' | 'pedestrian_zone' | 'shared_road' | 'trail' | 'indoor';
  surface: 'paved' | 'gravel' | 'grass' | 'stairs' | 'ramp';
  lighting: 'well_lit' | 'moderate' | 'dark';
  width: number;                    // meters
  elevation: number;                // meters above sea level
  slope: number;                    // degrees
}

// Generate walkable path between points
async function generateWalkablePath(
  origin: GeoPoint,
  destination: GeoPoint,
  preferences: PathPreferences
): Promise<WalkablePath[]> {
  // 1. Get pedestrian network from OSM/Overture
  const pedestrianGraph = await getPedestrianNetwork(origin, destination);

  // 2. Add CANVS-specific waypoints (content locations)
  if (preferences.includeCANVSContent) {
    const contentWaypoints = await getContentAlongPath(origin, destination, preferences.contentRadius);
    pedestrianGraph.addWaypoints(contentWaypoints);
  }

  // 3. Calculate multiple route options
  const routes = await calculateRoutes(pedestrianGraph, origin, destination, {
    fastest: true,
    scenic: preferences.preferScenic,
    accessible: preferences.accessibilityRequired,
    safest: preferences.preferSafe
  });

  // 4. Enrich routes with segment details
  const enrichedRoutes = await Promise.all(
    routes.map(route => enrichRouteDetails(route))
  );

  // 5. Score and rank routes
  return enrichedRoutes
    .map(route => ({
      ...route,
      safetyScore: calculateSafetyScore(route),
      scenicScore: calculateScenicScore(route, preferences)
    }))
    .sort((a, b) => {
      // Multi-factor ranking
      const scoreA = preferences.preferScenic ? a.scenicScore :
                     preferences.preferSafe ? a.safetyScore :
                     1 / a.totalDistance;
      const scoreB = preferences.preferScenic ? b.scenicScore :
                     preferences.preferSafe ? b.safetyScore :
                     1 / b.totalDistance;
      return scoreB - scoreA;
    });
}

// Enrich route with detailed segment information
async function enrichRouteDetails(route: RawRoute): Promise<WalkablePath> {
  const segments: PathSegment[] = [];

  for (let i = 0; i < route.points.length - 1; i++) {
    const start = route.points[i];
    const end = route.points[i + 1];

    // Get way tags from OSM
    const wayData = await getWayData(start, end);

    // Get elevation data
    const elevationData = await getElevation([start, end]);

    segments.push({
      start,
      end,
      type: classifyWayType(wayData),
      surface: wayData.surface || 'paved',
      lighting: await getLightingInfo(start, end),
      width: parseFloat(wayData.width) || 1.5,
      elevation: elevationData[0],
      slope: calculateSlope(elevationData)
    });
  }

  return {
    waypoints: route.points,
    totalDistance: route.distance,
    estimatedDuration: calculateWalkingTime(route.distance, segments),
    segments,
    accessibility: evaluateAccessibility(segments)
  };
}
```

**ML Models and Packages:**

| Service/Package | Purpose | Type |
|-----------------|---------|------|
| **OpenStreetMap Overpass API** | Pedestrian network data | Cloud API |
| **Overture Maps Foundation** | High-quality road network | Cloud/Self-hosted |
| **OSRM (foot profile)** | Pedestrian routing engine | Self-hosted |
| **GraphHopper** | Multi-modal routing | Cloud/Self-hosted |
| **Mapbox Directions API** | Turn-by-turn directions | Cloud API |
| **Google Elevation API** | Terrain elevation data | Cloud API |

**AR Framework Integration:**

```typescript
// Visualize path in AR
async function visualizePathInAR(
  path: WalkablePath,
  arSession: ARSession
): Promise<void> {
  // Convert path to AR anchors
  const pathAnchors = await Promise.all(
    path.waypoints.map(async (point, index) => {
      // Create geo anchor at each waypoint
      const anchor = await arSession.createGeoAnchor({
        latitude: point.lat,
        longitude: point.lng,
        altitude: point.altitude || 0
      });

      // Add visual marker
      const marker = createPathMarker(index, path.waypoints.length);
      anchor.attach(marker);

      return anchor;
    })
  );

  // Draw connecting lines between waypoints
  for (let i = 0; i < pathAnchors.length - 1; i++) {
    const line = createPathLine(pathAnchors[i], pathAnchors[i + 1]);
    arSession.scene.add(line);
  }
}
```

---

### 5.2 POI Chaining and Sequencing

**Value Proposition:**
Automatically create optimized sequences of points of interest for tours, trails, and explorations based on thematic connections, logical order, and physical proximity.

**Technical Implementation:**

```typescript
interface POIChain {
  title: string;
  description: string;
  pois: ChainedPOI[];
  totalDistance: number;
  estimatedDuration: number;        // minutes
  theme: string;
  difficultyLevel: 'easy' | 'moderate' | 'challenging';
  optimalTimeOfDay: string[];
}

interface ChainedPOI {
  poi: POI;
  order: number;
  connectionReason: string;         // Why this POI follows the previous
  transitionDistance: number;       // meters from previous POI
  suggestedDuration: number;        // minutes at this POI
  content: SpatialContent[];        // CANVS content at this location
}

// Generate themed POI chain
async function generatePOIChain(
  seedPOIs: POI[],
  theme: string,
  constraints: ChainConstraints
): Promise<POIChain> {
  // 1. Expand seed POIs with related locations
  const expandedPOIs = await expandWithRelatedPOIs(seedPOIs, theme, constraints.maxPOIs);

  // 2. Score POIs for theme relevance
  const scoredPOIs = await Promise.all(
    expandedPOIs.map(async poi => ({
      poi,
      themeScore: await calculateThemeRelevance(poi, theme),
      engagementScore: await getEngagementScore(poi),
      contentAvailable: await hasCANVSContent(poi)
    }))
  );

  // 3. Filter by minimum relevance
  const relevantPOIs = scoredPOIs.filter(
    p => p.themeScore > 0.5 && (p.engagementScore > 0.3 || p.contentAvailable)
  );

  // 4. Optimize visiting order (modified TSP with constraints)
  const orderedPOIs = optimizeVisitingOrder(
    relevantPOIs,
    constraints.startPoint,
    constraints.endPoint,
    constraints.maxDistance
  );

  // 5. Generate transitions and connections
  const chain: ChainedPOI[] = [];
  for (let i = 0; i < orderedPOIs.length; i++) {
    const poi = orderedPOIs[i];
    const previousPOI = i > 0 ? orderedPOIs[i - 1] : null;

    chain.push({
      poi: poi.poi,
      order: i + 1,
      connectionReason: previousPOI
        ? await generateConnectionReason(previousPOI.poi, poi.poi, theme)
        : 'Starting point',
      transitionDistance: previousPOI
        ? calculateDistance(previousPOI.poi.location, poi.poi.location)
        : 0,
      suggestedDuration: estimateDuration(poi),
      content: await getContentAtLocation(poi.poi.location, 50)
    });
  }

  // 6. Calculate totals
  const totalDistance = chain.reduce((sum, p) => sum + p.transitionDistance, 0);
  const totalDuration = chain.reduce((sum, p) => sum + p.suggestedDuration + p.transitionDistance / 80, 0);

  return {
    title: await generateChainTitle(chain, theme),
    description: await generateChainDescription(chain, theme),
    pois: chain,
    totalDistance,
    estimatedDuration: totalDuration,
    theme,
    difficultyLevel: calculateDifficulty(chain, totalDistance),
    optimalTimeOfDay: determineOptimalTimes(chain)
  };
}

// Optimize visiting order using modified TSP
function optimizeVisitingOrder(
  pois: ScoredPOI[],
  startPoint: GeoPoint | null,
  endPoint: GeoPoint | null,
  maxDistance: number
): ScoredPOI[] {
  // Use greedy nearest neighbor with quality weighting
  const ordered: ScoredPOI[] = [];
  const remaining = [...pois];

  // Start from specified point or highest-scored POI
  let current = startPoint
    ? findNearestPOI(remaining, startPoint)
    : remaining.reduce((best, p) =>
        p.themeScore > best.themeScore ? p : best
      );

  ordered.push(current);
  remaining.splice(remaining.indexOf(current), 1);

  let totalDistance = 0;

  while (remaining.length > 0 && totalDistance < maxDistance) {
    // Find next POI balancing distance and quality
    const next = findBestNext(current, remaining, {
      distanceWeight: 0.3,
      qualityWeight: 0.7
    });

    const addedDistance = calculateDistance(
      current.poi.location,
      next.poi.location
    );

    if (totalDistance + addedDistance > maxDistance) break;

    ordered.push(next);
    remaining.splice(remaining.indexOf(next), 1);
    totalDistance += addedDistance;
    current = next;
  }

  // Optionally route to end point
  if (endPoint) {
    const endPOI = findNearestPOI(remaining, endPoint);
    if (endPOI && calculateDistance(current.poi.location, endPOI.poi.location) + totalDistance <= maxDistance * 1.1) {
      ordered.push(endPOI);
    }
  }

  return ordered;
}
```

**ML Models and Packages:**

| Component | Purpose | Deployment |
|-----------|---------|------------|
| **Claude/GPT-4** | Theme relevance scoring | Cloud |
| **Custom embeddings** | POI semantic similarity | Cloud (pgvector) |
| **OR-Tools** | TSP optimization | Edge/Cloud |
| **LLM chain generation** | Connection narratives | Cloud |

---

### 5.3 Time and Distance Estimation

**Value Proposition:**
Provide accurate walking time estimates considering terrain, crowds, user pace, and route characteristics.

**Technical Implementation:**

```typescript
interface TimeEstimate {
  duration: number;                 // seconds
  confidence: number;               // 0-1
  breakdown: {
    walking: number;
    waiting: number;                // crosswalks, crowds
    viewing: number;                // POI engagement time
    resting: number;                // suggested breaks
  };
  factors: TimeFactor[];
  arrivalWindow: {
    earliest: Date;
    mostLikely: Date;
    latest: Date;
  };
}

interface TimeFactor {
  name: string;
  impact: number;                   // multiplier or additive seconds
  type: 'multiplier' | 'additive';
  description: string;
}

// Estimate travel time with multiple factors
async function estimateTravelTime(
  path: WalkablePath,
  userProfile: UserProfile,
  currentConditions: EnvironmentConditions
): Promise<TimeEstimate> {
  const BASE_WALKING_SPEED = 1.4; // m/s average human walking speed

  const factors: TimeFactor[] = [];
  let speedMultiplier = 1.0;
  let additionalTime = 0;

  // User pace preference
  const paceMultipliers = {
    slow: 0.8,
    moderate: 1.0,
    fast: 1.2,
    athletic: 1.4
  };
  speedMultiplier *= paceMultipliers[userProfile.pace] || 1.0;
  factors.push({
    name: 'User pace',
    impact: paceMultipliers[userProfile.pace],
    type: 'multiplier',
    description: `${userProfile.pace} walking pace`
  });

  // Terrain factors
  for (const segment of path.segments) {
    // Slope adjustment (Tobler's hiking function simplified)
    if (Math.abs(segment.slope) > 5) {
      const slopeMultiplier = 1 + (Math.abs(segment.slope) - 5) * 0.04;
      speedMultiplier *= slopeMultiplier;
      factors.push({
        name: 'Terrain slope',
        impact: slopeMultiplier,
        type: 'multiplier',
        description: `${segment.slope.toFixed(1)}deg slope`
      });
    }

    // Stairs
    if (segment.surface === 'stairs') {
      speedMultiplier *= 0.6;
      factors.push({
        name: 'Stairs',
        impact: 0.6,
        type: 'multiplier',
        description: 'Stair navigation'
      });
    }

    // Crosswalk waiting time
    if (segment.type === 'crosswalk') {
      additionalTime += 30; // Average 30 second wait
      factors.push({
        name: 'Crosswalk',
        impact: 30,
        type: 'additive',
        description: 'Signal wait time'
      });
    }
  }

  // Weather impact
  if (currentConditions.weather) {
    if (currentConditions.weather.precipitation) {
      speedMultiplier *= 0.85;
      factors.push({
        name: 'Weather',
        impact: 0.85,
        type: 'multiplier',
        description: 'Precipitation slowing'
      });
    }
    if (currentConditions.weather.temperature > 30 || currentConditions.weather.temperature < 0) {
      speedMultiplier *= 0.9;
      factors.push({
        name: 'Temperature',
        impact: 0.9,
        type: 'multiplier',
        description: 'Extreme temperature'
      });
    }
  }

  // Crowd density
  if (currentConditions.crowding?.density === 'crowded') {
    speedMultiplier *= 0.7;
    factors.push({
      name: 'Crowds',
      impact: 0.7,
      type: 'multiplier',
      description: 'High pedestrian density'
    });
  }

  // Calculate base walking time
  const effectiveSpeed = BASE_WALKING_SPEED * speedMultiplier;
  const walkingTime = path.totalDistance / effectiveSpeed;

  // Add content viewing time if applicable
  const viewingTime = path.segments
    .filter(s => s.hasCANVSContent)
    .reduce((sum, s) => sum + 60, 0); // 60 seconds per content location

  // Calculate suggested rest time for long paths
  const restingTime = path.totalDistance > 2000
    ? Math.floor(path.totalDistance / 1000) * 120 // 2 min rest per km
    : 0;

  const totalDuration = walkingTime + additionalTime + viewingTime + restingTime;

  // Calculate confidence based on data quality
  const confidence = calculateConfidence(path, currentConditions);

  // Calculate arrival window
  const now = new Date();
  const varianceMultiplier = 1 - confidence;

  return {
    duration: totalDuration,
    confidence,
    breakdown: {
      walking: walkingTime,
      waiting: additionalTime,
      viewing: viewingTime,
      resting: restingTime
    },
    factors,
    arrivalWindow: {
      earliest: new Date(now.getTime() + totalDuration * (1 - varianceMultiplier) * 1000),
      mostLikely: new Date(now.getTime() + totalDuration * 1000),
      latest: new Date(now.getTime() + totalDuration * (1 + varianceMultiplier) * 1000)
    }
  };
}
```

**ML Models and Packages:**

| Component | Purpose | Deployment |
|-----------|---------|------------|
| **Tobler's hiking function** | Slope-adjusted speed | Edge (math) |
| **Google Popular Times** | Crowd prediction | Cloud API |
| **Historical path data** | User pace learning | Cloud (user analytics) |
| **Weather API** | Condition factors | Cloud API |

---

### 5.4 Accessibility-Aware Routing

**Value Proposition:**
Generate routes that accommodate mobility needs including wheelchair access, avoiding stairs, minimizing elevation changes, and identifying accessible amenities.

**Technical Implementation:**

```typescript
interface AccessibilityProfile {
  mobilityAid: 'none' | 'cane' | 'walker' | 'wheelchair_manual' | 'wheelchair_powered';
  maxSlope: number;                 // degrees
  maxStepHeight: number;            // cm
  requiresRestStops: boolean;
  maxDistanceWithoutRest: number;   // meters
  avoidances: ('stairs' | 'cobblestones' | 'gravel' | 'crowds' | 'construction')[];
  requirements: ('curb_cuts' | 'tactile_paving' | 'audio_signals' | 'wide_paths')[];
}

interface AccessibleRoute {
  path: WalkablePath;
  accessibilityScore: number;       // 0-1
  issues: AccessibilityIssue[];
  alternatives: AccessibleRoute[];
  amenities: AccessibleAmenity[];
  restStops: RestStop[];
}

interface AccessibilityIssue {
  location: GeoPoint;
  type: 'barrier' | 'warning' | 'inconvenience';
  description: string;
  severity: 'blocking' | 'difficult' | 'minor';
  workaround?: string;
}

// Generate accessibility-aware route
async function generateAccessibleRoute(
  origin: GeoPoint,
  destination: GeoPoint,
  profile: AccessibilityProfile
): Promise<AccessibleRoute> {
  // 1. Get pedestrian network with accessibility tags
  const accessibleGraph = await getAccessibleNetwork(origin, destination, profile);

  // 2. Filter edges based on profile requirements
  const filteredGraph = filterGraphForAccessibility(accessibleGraph, profile);

  // 3. Calculate route with accessibility cost function
  const route = await calculateAccessibleRoute(
    filteredGraph,
    origin,
    destination,
    buildAccessibilityCostFunction(profile)
  );

  // 4. Identify remaining issues
  const issues = await identifyAccessibilityIssues(route, profile);

  // 5. Find accessible amenities along route
  const amenities = await findAccessibleAmenities(route, profile);

  // 6. Plan rest stops if needed
  const restStops = profile.requiresRestStops
    ? planRestStops(route, profile.maxDistanceWithoutRest, amenities)
    : [];

  // 7. Calculate accessibility score
  const accessibilityScore = calculateAccessibilityScore(route, issues, profile);

  // 8. Generate alternative routes if issues exist
  let alternatives: AccessibleRoute[] = [];
  if (issues.some(i => i.severity === 'difficult')) {
    alternatives = await generateAlternativeRoutes(
      origin, destination, profile, route, 3
    );
  }

  return {
    path: route,
    accessibilityScore,
    issues,
    alternatives,
    amenities,
    restStops
  };
}

// Build cost function that penalizes inaccessible features
function buildAccessibilityCostFunction(
  profile: AccessibilityProfile
): (edge: GraphEdge) => number {
  return (edge: GraphEdge) => {
    let cost = edge.distance; // Base cost is distance

    // Slope penalty
    if (edge.slope > profile.maxSlope) {
      cost += 1000000; // Effectively infinite (blocked)
    } else if (edge.slope > profile.maxSlope * 0.7) {
      cost *= 3; // Heavy penalty for steep slopes
    } else if (edge.slope > profile.maxSlope * 0.5) {
      cost *= 1.5; // Moderate penalty
    }

    // Surface penalties
    const surfacePenalties: Record<string, number> = {
      'paved': 1.0,
      'asphalt': 1.0,
      'concrete': 1.0,
      'gravel': profile.mobilityAid.includes('wheelchair') ? 5.0 : 1.5,
      'cobblestone': profile.mobilityAid.includes('wheelchair') ? 10.0 : 2.0,
      'grass': profile.mobilityAid.includes('wheelchair') ? 100.0 : 2.0,
      'sand': 100.0,
      'stairs': profile.mobilityAid !== 'none' ? 1000000 : 1.0
    };
    cost *= surfacePenalties[edge.surface] || 1.0;

    // Width requirements for wheelchairs
    if (profile.mobilityAid.includes('wheelchair') && edge.width < 1.2) {
      cost *= 5;
    }

    // Curb cut requirements
    if (profile.requirements.includes('curb_cuts') &&
        edge.type === 'crosswalk' &&
        !edge.hasCurbCuts) {
      cost += 1000000;
    }

    return cost;
  };
}

// OSM accessibility tag parsing
function parseAccessibilityTags(tags: Record<string, string>): EdgeAccessibility {
  return {
    wheelchair: tags.wheelchair === 'yes' || tags.wheelchair === 'designated',
    tactilePaving: tags.tactile_paving === 'yes',
    handrail: tags.handrail === 'yes' || tags.handrail === 'both',
    curb: tags['curb:type'] || tags.curb,
    incline: parseIncline(tags.incline),
    surface: tags.surface,
    width: parseFloat(tags.width) || null,
    steps: tags.highway === 'steps' || parseInt(tags.step_count) > 0,
    stepCount: parseInt(tags.step_count) || 0,
    ramp: tags.ramp === 'yes',
    elevator: tags.highway === 'elevator' || tags.amenity === 'elevator'
  };
}
```

**ML Models and Packages:**

| Service/Data | Purpose | Type |
|--------------|---------|------|
| **OpenStreetMap** | Accessibility tags (wheelchair, tactile_paving, etc.) | Open data |
| **Wheelmap.org API** | Wheelchair accessibility ratings | Cloud API |
| **Project Sidewalk** | Crowdsourced accessibility data | Dataset |
| **Google Places** | Wheelchair accessible flag | Cloud API |
| **Custom slope analyzer** | Elevation-based slope calculation | Edge/Cloud |
| **OpenRouteService** | Wheelchair routing profile | Cloud API |

---

## 6. Implementation Priorities

### MVP v1 (GPS-Only PWA)

| Feature | Priority | Complexity | Value |
|---------|----------|------------|-------|
| Place Type Classification | High | Low | High |
| Indoor/Outdoor Detection | High | Medium | High |
| Location Personality Profiling | Medium | Medium | High |
| Ambient Conditions (time-based) | Low | Low | Medium |
| Basic Path Generation | Medium | Medium | Medium |
| Time Estimation | Medium | Low | Medium |

### MVP v2 (VPS-Enhanced)

| Feature | Priority | Complexity | Value |
|---------|----------|------------|-------|
| Monocular Depth Estimation | High | High | High |
| Anchor Point Detection | High | Medium | High |
| Occlusion-Aware Placement | High | High | High |
| Semantic Scene Understanding | Medium | High | High |
| Scale/Position Recommendations | Medium | Medium | High |
| Viewing Angle Suggestions | Low | Medium | Medium |

### Future Versions

| Feature | Timeline | Dependency |
|---------|----------|------------|
| Full AR Content Optimization | v2.5 | VPS + LiDAR adoption |
| Multi-Floor Understanding | v3 | Indoor VPS |
| Accessibility Routing | v2 | OSM data quality |
| POI Chaining | v2 | Content density |
| Visibility Prediction | v2.5 | Depth estimation |

---

## 7. Edge vs Cloud Processing Strategy

### Decision Matrix

| Feature | Latency Requirement | Privacy Sensitivity | Compute Intensity | Recommendation |
|---------|---------------------|---------------------|-------------------|----------------|
| Place Classification | Low | Low | Low | Edge (cached) |
| Indoor/Outdoor | High | Medium | Low | Edge |
| Location Personality | Low | Low | High | Cloud (batch) |
| Depth Estimation | High | Low | High | Edge (GPU) |
| Scene Understanding | High | Low | High | Edge (Neural Engine) |
| Occlusion Detection | Real-time | Low | High | Edge |
| Path Generation | Medium | Low | Medium | Cloud |
| Accessibility Routing | Medium | Low | Medium | Cloud |
| POI Chaining | Low | Low | High | Cloud |
| Time Estimation | Low | Low | Low | Edge |

### Hybrid Processing Pattern

```typescript
// Standard hybrid processing pattern for spatial AI features
async function processWithHybridStrategy<T>(
  feature: string,
  input: any,
  edgeProcessor: (input: any) => Promise<T | null>,
  cloudProcessor: (input: any) => Promise<T>,
  cacheKey?: string
): Promise<T> {
  // Check cache first
  if (cacheKey) {
    const cached = await cache.get(cacheKey);
    if (cached) return cached as T;
  }

  // Try edge processing
  try {
    const edgeResult = await edgeProcessor(input);
    if (edgeResult !== null) {
      if (cacheKey) await cache.set(cacheKey, edgeResult, 3600);
      return edgeResult;
    }
  } catch (e) {
    console.warn(`Edge processing failed for ${feature}:`, e);
  }

  // Fall back to cloud
  const cloudResult = await cloudProcessor(input);
  if (cacheKey) await cache.set(cacheKey, cloudResult, 3600);
  return cloudResult;
}
```

---

## 8. AR Framework Integration Matrix

### Feature Availability by Framework

| Feature | ARKit (iOS) | ARCore (Android) | 8th Wall (Web) | WebXR (Web) |
|---------|-------------|------------------|----------------|-------------|
| Plane Detection | Native | Native | Native | Limited |
| Plane Classification | Native (v4+) | Limited | No | No |
| Scene Reconstruction | Native (LiDAR) | Depth API | No | No |
| Depth Estimation | Native/ML | Native/ML | ML only | ML only |
| Light Estimation | Native | Native | Limited | Limited |
| Geo Anchors | Native (v4.5+) | Native (Geospatial) | Native | No |
| Object Detection | Vision + ML | ML | ML | ML |
| Scene Semantics | Native (v6+) | Partial | No | No |
| Occlusion | Native | Native | Limited | No |

### 8th Wall Deprecation Impact

8th Wall is deprecated as of February 2027. Migration strategy:

1. **Primary Alternative**: WebXR Device API with polyfills
2. **VPS Alternative**: Niantic Lightship ARDK (if web support added)
3. **Fallback**: Native apps for VPS-dependent features

```typescript
// Feature detection and fallback pattern
function getARCapabilities(): ARCapabilities {
  if (isARKitAvailable()) {
    return {
      geoAnchors: true,
      sceneReconstruction: hasLiDAR(),
      planeClassification: true,
      depthEstimation: true,
      source: 'arkit'
    };
  }

  if (isARCoreAvailable()) {
    return {
      geoAnchors: true,
      sceneReconstruction: false,
      planeClassification: false,
      depthEstimation: true, // Depth API
      source: 'arcore'
    };
  }

  if (is8thWallAvailable() && !is8thWallDeprecated()) {
    return {
      geoAnchors: true,
      sceneReconstruction: false,
      planeClassification: false,
      depthEstimation: 'ml_only',
      source: '8thwall'
    };
  }

  if (isWebXRAvailable()) {
    return {
      geoAnchors: false,
      sceneReconstruction: false,
      planeClassification: false,
      depthEstimation: 'ml_only',
      source: 'webxr'
    };
  }

  // No AR - use map-only mode
  return {
    geoAnchors: false,
    sceneReconstruction: false,
    planeClassification: false,
    depthEstimation: false,
    source: 'none'
  };
}
```

---

## References

### Academic Papers
- Ranftl et al. "Vision Transformers for Dense Prediction" (DPT/MiDaS)
- Yang et al. "Depth Anything" (2024)
- Bochkovskiy et al. "YOLOv4: Optimal Speed and Accuracy"
- Tobler, W. "Three Presentations on Geographical Analysis and Modeling" (hiking function)

### AR Platform Documentation
- [ARKit Documentation](https://developer.apple.com/documentation/arkit)
- [ARCore Documentation](https://developers.google.com/ar)
- [8th Wall Documentation](https://www.8thwall.com/docs) (until deprecation)
- [WebXR Device API](https://developer.mozilla.org/en-US/docs/Web/API/WebXR_Device_API)

### Spatial Data Sources
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Overture Maps Foundation](https://overturemaps.org/)
- [Google Places API](https://developers.google.com/maps/documentation/places)
- [Wheelmap.org](https://wheelmap.org/)

### ML Model Repositories
- [TensorFlow Hub](https://tfhub.dev/)
- [Hugging Face Models](https://huggingface.co/models)
- [Core ML Models](https://developer.apple.com/machine-learning/models/)
- [MediaPipe Solutions](https://developers.google.com/mediapipe)

---

*Document generated: January 2026*
*Author: CANVS Technical Architecture Team*
*Next review: Prior to MVP v2 development*
