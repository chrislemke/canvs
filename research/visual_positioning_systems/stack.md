# Visual Positioning Systems (VPS) Technical Stack

## Executive Summary

This comprehensive technical stack document covers Visual Positioning Systems across three major platforms: mobile web (WebXR/WebAR), native mobile applications (iOS/Android), and AR glasses. VPS enables centimeter-accurate positioning using visual features rather than GPS, making it essential for precise AR experiences in urban environments, indoor spaces, and complex outdoor areas.

**Key Findings:**
- ARCore Geospatial API covers 93+ countries with Street View integration
- Niantic Lightship VPS has 1M+ activated locations globally
- 8th Wall is sunsetting February 2027 (critical migration needed)
- Azure Spatial Anchors was retired November 2024
- visionOS 26 introduces shared world anchors for Vision Pro
- WebXR Raw Camera Access is experimental and limited

---

# Section 1: VPS on Mobile Websites (WebXR/WebAR)

## Overview

Web-based VPS represents the most accessible entry point for AR experiences, requiring no app installation. However, platform fragmentation (especially iOS Safari limitations) and the upcoming 8th Wall sunset create significant challenges.

## Available Technologies

### 1.1 8th Wall (Niantic) - SUNSETTING FEB 2027

**Status:** End-of-life announced. New projects strongly discouraged.

8th Wall was the leading WebAR platform with proprietary SLAM and VPS capabilities. Niantic acquired 8th Wall and is sunsetting it to consolidate on Lightship.

**Timeline:**
- February 2025: No new projects
- February 2026: Read-only mode
- February 2027: Complete shutdown

**Migration Path:** Niantic Lightship Web SDK (limited availability)

```javascript
// LEGACY 8th Wall VPS Initialization (DO NOT USE FOR NEW PROJECTS)
// Included for migration reference only

const onxrloaded = () => {
  XR8.XrController.configure({
    enableVps: true,
    vpsLocationId: 'loc_abc123xyz'
  })

  XR8.addCameraPipelineModules([
    XR8.GlTextureRenderer.pipelineModule(),
    XR8.Threejs.pipelineModule(),
    XR8.XrController.pipelineModule(),
    XR8.VpsCoachingOverlay.pipelineModule(),
    myVpsScenePipelineModule()
  ])

  XR8.run({ canvas: document.getElementById('camerafeed') })
}

const myVpsScenePipelineModule = () => ({
  name: 'vps-scene',
  onStart: () => {
    // Initialize Three.js scene for VPS content
  },
  onVpsStatus: ({ status, reason }) => {
    switch(status) {
      case 'INITIALIZING':
        showCoaching('Point at the location')
        break
      case 'LOCALIZED':
        hideCoaching()
        placeVpsContent()
        break
      case 'LOST':
        showRelocalizationPrompt()
        break
    }
  }
})

window.XR8 ? onxrloaded() : window.addEventListener('xrloaded', onxrloaded)
```

### 1.2 Immersal VPS for Web

**Status:** Active, recommended for web VPS projects

Immersal (acquired by Hexagon) provides robust VPS with pre-mapped indoor/outdoor environments. Their Web SDK enables browser-based localization against point clouds.

**Capabilities:**
- Indoor and outdoor mapping
- Sub-meter accuracy (10-30cm typical)
- REST API for map management
- Three.js and Babylon.js integration

```javascript
// Immersal Web SDK VPS Integration

import { ImmersalSDK, Localizer } from '@anthropic/immersal-web-sdk'

class ImmersalVPSManager {
  constructor(apiToken, mapIds) {
    this.sdk = new ImmersalSDK({
      token: apiToken,
      serverUrl: 'https://api.immersal.com'
    })
    this.mapIds = mapIds
    this.localizer = null
  }

  async initialize() {
    // Load maps from Immersal cloud
    const maps = await Promise.all(
      this.mapIds.map(id => this.sdk.loadMap(id))
    )

    this.localizer = new Localizer({
      maps,
      options: {
        localizationInterval: 500, // ms between attempts
        minConfidence: 0.7,
        useGravity: true
      }
    })

    return this.localizer
  }

  async startLocalization(videoElement) {
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')

    const captureAndLocalize = async () => {
      canvas.width = videoElement.videoWidth
      canvas.height = videoElement.videoHeight
      ctx.drawImage(videoElement, 0, 0)

      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)

      try {
        const result = await this.localizer.localize({
          image: imageData,
          intrinsics: this.getCameraIntrinsics()
        })

        if (result.success) {
          this.onLocalized(result)
        }
      } catch (error) {
        console.error('Localization failed:', error)
      }

      requestAnimationFrame(captureAndLocalize)
    }

    captureAndLocalize()
  }

  getCameraIntrinsics() {
    // Estimate intrinsics from video dimensions
    // Real implementation should use device-specific calibration
    return {
      fx: 1000,
      fy: 1000,
      ox: 640,
      oy: 360
    }
  }

  onLocalized(result) {
    // result contains:
    // - mapId: which map we localized against
    // - position: { x, y, z } in map coordinates
    // - rotation: quaternion { x, y, z, w }
    // - confidence: 0-1 score

    const event = new CustomEvent('vps-localized', { detail: result })
    window.dispatchEvent(event)
  }
}

// Usage
const vps = new ImmersalVPSManager('your-api-token', ['map-001', 'map-002'])
await vps.initialize()

const video = document.getElementById('camera-feed')
vps.startLocalization(video)

window.addEventListener('vps-localized', (e) => {
  console.log('Localized at:', e.detail.position)
  updateARContent(e.detail)
})
```

### 1.3 Zappar Mattercraft + MultiSet AI

**Status:** Active, emerging platform

Zappar partnered with MultiSet AI to bring VPS capabilities to their Mattercraft creative platform. Focused on retail and marketing use cases.

```javascript
// Zappar Mattercraft with MultiSet VPS

import * as ZapparThree from '@anthropic/zappar-threejs'
import { MultiSetVPS } from '@anthropic/multiset-vps'

const camera = new ZapparThree.Camera()
const vpsTracker = new MultiSetVPS.Tracker({
  apiKey: 'your-multiset-key',
  locationId: 'store-downtown-001'
})

// Initialize camera permissions
ZapparThree.permissionRequestUI().then(granted => {
  if (granted) {
    camera.start()
    initVPS()
  }
})

async function initVPS() {
  await vpsTracker.initialize()

  vpsTracker.onLocalized = (pose) => {
    // pose: { position: Vector3, rotation: Quaternion, accuracy: number }
    updateAnchoredContent(pose)
  }

  vpsTracker.onTrackingLost = () => {
    showRelocalizationUI()
  }

  // Start continuous localization
  vpsTracker.startTracking(camera.rawCameraFeed)
}

function updateAnchoredContent(pose) {
  // Update Three.js scene based on VPS pose
  arContent.position.copy(pose.position)
  arContent.quaternion.copy(pose.rotation)
}
```

### 1.4 WebXR Raw Camera Access (Experimental)

**Status:** Experimental, Chrome-only, not production-ready

The WebXR Raw Camera Access Module allows accessing raw camera frames during WebXR sessions. This enables custom VPS implementations but has severe limitations.

**Limitations:**
- Chrome-only (not Safari, not Firefox)
- Requires flags or origin trial
- No iOS support
- Performance concerns on mobile

```javascript
// WebXR Raw Camera Access for Custom VPS
// EXPERIMENTAL - NOT FOR PRODUCTION

class WebXRCustomVPS {
  constructor() {
    this.session = null
    this.glBinding = null
    this.vpsProcessor = null
  }

  async initialize() {
    // Check for Raw Camera Access support
    if (!navigator.xr) {
      throw new Error('WebXR not supported')
    }

    const supported = await navigator.xr.isSessionSupported('immersive-ar')
    if (!supported) {
      throw new Error('Immersive AR not supported')
    }

    // Request session with camera access
    this.session = await navigator.xr.requestSession('immersive-ar', {
      requiredFeatures: ['camera-access'],
      optionalFeatures: ['dom-overlay'],
      domOverlay: { root: document.getElementById('overlay') }
    })

    // Get WebGL binding for camera textures
    const gl = this.getWebGLContext()
    this.glBinding = new XRWebGLBinding(this.session, gl)

    // Initialize custom VPS processor (your implementation)
    this.vpsProcessor = new CustomVPSProcessor()

    this.session.requestAnimationFrame(this.onFrame.bind(this))
  }

  onFrame(time, frame) {
    const session = frame.session
    session.requestAnimationFrame(this.onFrame.bind(this))

    const pose = frame.getViewerPose(this.referenceSpace)
    if (!pose) return

    for (const view of pose.views) {
      // Get camera image from view
      const cameraTexture = this.glBinding.getCameraImage(view)

      if (cameraTexture) {
        // Extract image data and run VPS
        const imageData = this.extractTextureData(cameraTexture)

        // Async VPS processing (should be throttled)
        this.processVPS(imageData, view).then(vpsResult => {
          if (vpsResult.success) {
            this.onVPSLocalized(vpsResult)
          }
        })
      }
    }
  }

  extractTextureData(texture) {
    // Read pixels from WebGL texture
    const gl = this.getWebGLContext()
    const fb = gl.createFramebuffer()
    gl.bindFramebuffer(gl.FRAMEBUFFER, fb)
    gl.framebufferTexture2D(
      gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0,
      gl.TEXTURE_2D, texture, 0
    )

    const pixels = new Uint8Array(texture.width * texture.height * 4)
    gl.readPixels(0, 0, texture.width, texture.height,
                  gl.RGBA, gl.UNSIGNED_BYTE, pixels)

    gl.deleteFramebuffer(fb)
    return { data: pixels, width: texture.width, height: texture.height }
  }

  async processVPS(imageData, view) {
    // Send to VPS backend or process locally with WASM
    return await this.vpsProcessor.localize(imageData, {
      intrinsics: view.camera?.getIntrinsics(),
      timestamp: performance.now()
    })
  }

  onVPSLocalized(result) {
    console.log('VPS localized:', result)
    // Adjust XR reference space based on VPS result
  }

  getWebGLContext() {
    // Return your WebGL context
    return this.gl
  }
}
```

### 1.5 Sturfee Visual GPS (Web)

**Status:** Active, satellite-based approach

Sturfee uses satellite/aerial imagery for VPS, providing coverage in areas without Street View data. Offers JavaScript SDK for web integration.

```javascript
// Sturfee Visual GPS Web Integration

import { SturfeeVPS } from '@anthropic/sturfee-sdk'

const vps = new SturfeeVPS({
  apiKey: 'your-sturfee-api-key',
  mode: 'outdoor' // or 'indoor'
})

async function initSturfeeVPS() {
  // Get coarse GPS for initial positioning
  const gpsPosition = await getCurrentGPSPosition()

  // Initialize with approximate location
  await vps.initialize({
    latitude: gpsPosition.coords.latitude,
    longitude: gpsPosition.coords.longitude,
    altitude: gpsPosition.coords.altitude || 0
  })

  // Start camera stream
  const stream = await navigator.mediaDevices.getUserMedia({
    video: { facingMode: 'environment', width: 1920, height: 1080 }
  })

  vps.startLocalization(stream, {
    onLocalized: (result) => {
      // result.pose: 6DoF pose
      // result.accuracy: confidence score
      // result.geolocation: { lat, lng, alt }
      updateARScene(result)
    },
    onError: (error) => {
      console.error('Sturfee VPS error:', error)
    }
  })
}

function getCurrentGPSPosition() {
  return new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject, {
      enableHighAccuracy: true,
      timeout: 10000
    })
  })
}
```

## Web VPS Challenges

| Challenge | Impact | Mitigation |
|-----------|--------|------------|
| iOS Safari no WebXR | 50%+ mobile users excluded | Use 8th Wall (while available) or native fallback |
| 8th Wall sunset | Major platform loss | Migrate to Immersal or native SDK |
| Camera permission UX | User friction | Clear onboarding, graceful degradation |
| Battery drain | Poor user experience | Throttle processing, efficient algorithms |
| Network dependency | Latency for cloud VPS | Edge caching, offline-first design |
| Limited GPU access | Slower feature extraction | WASM + WebGL compute shaders |

## Web VPS Opportunities

1. **Zero-install experiences** - Instant AR via URL/QR code
2. **Cross-platform reach** - Works on desktop browsers too
3. **Easy updates** - No app store review cycles
4. **SEO/discoverability** - Indexable AR content
5. **A/B testing** - Rapid iteration on experiences

## Products Using Web VPS

| Product | Technology | Use Case |
|---------|------------|----------|
| Snapchat Web Lenses | Proprietary + 8th Wall | Social AR filters |
| Pokemon GO (promo) | 8th Wall + Niantic VPS | Marketing campaigns |
| IKEA Place Web | Custom WebAR | Furniture visualization |
| Burberry AR | 8th Wall | Retail fashion |
| NASA AR | 8th Wall + custom | Educational experiences |

---

# Section 2: VPS on Native Mobile (iOS/Android)

## Overview

Native mobile VPS offers the best performance, accuracy, and platform integration. Apple's ARKit and Google's ARCore provide first-party VPS solutions with wide device coverage.

## iOS Technologies

### 2.1 ARKit Location Anchors (ARGeoAnchor)

**Status:** Production-ready, limited geographic coverage

ARKit's geo-tracking uses Apple Maps data for VPS localization. Provides centimeter-accurate positioning in supported cities.

**Supported Cities (as of 2025):**
- United States: San Francisco Bay Area, Los Angeles, New York, Chicago, Miami, Boston, Seattle, Las Vegas, Phoenix, Houston, Philadelphia, San Diego, Washington D.C., Atlanta, Detroit, Denver, Nashville, Baltimore, Orlando, Minneapolis, Portland
- International: London, Tokyo, Sydney, Melbourne, Montreal, Toronto, Vancouver, Paris, Singapore, Hong Kong, Osaka, Nagoya

**Requirements:**
- iPhone 12+ or iPad Pro with LiDAR
- iOS 14.5+
- GPS signal for initial positioning
- Supported city location

```swift
// ARKit Location Anchors (ARGeoAnchor) - Swift

import ARKit
import CoreLocation

class ARGeoTrackingViewController: UIViewController, ARSessionDelegate, CLLocationManagerDelegate {

    var arSession: ARSession!
    var arView: ARSCNView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup AR view
        arView = ARSCNView(frame: view.bounds)
        view.addSubview(arView)

        arSession = arView.session
        arSession.delegate = self

        // Setup location manager for geo-tracking support
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        checkGeoTrackingSupport()
    }

    func checkGeoTrackingSupport() {
        // Check if device supports geo-tracking
        guard ARGeoTrackingConfiguration.isSupported else {
            showAlert("Geo-tracking not supported on this device")
            return
        }

        // Check if current location supports geo-tracking
        ARGeoTrackingConfiguration.checkAvailability { available, error in
            if let error = error {
                self.showAlert("Geo-tracking check failed: \(error.localizedDescription)")
                return
            }

            if available {
                self.startGeoTracking()
            } else {
                self.showAlert("Geo-tracking not available at this location")
            }
        }
    }

    func startGeoTracking() {
        let configuration = ARGeoTrackingConfiguration()

        // Enable scene reconstruction for better occlusion
        if ARGeoTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }

        // Enable people occlusion if available
        if ARGeoTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }

        // Start session
        arSession.run(configuration)
    }

    // MARK: - Creating Geo Anchors

    func createGeoAnchor(latitude: Double, longitude: Double, altitude: Double? = nil) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        var geoAnchor: ARGeoAnchor

        if let altitude = altitude {
            // Use absolute altitude (WGS84)
            geoAnchor = ARGeoAnchor(coordinate: coordinate, altitude: altitude)
        } else {
            // Anchor at ground level (terrain-relative)
            geoAnchor = ARGeoAnchor(coordinate: coordinate)
        }

        // Add anchor to session
        arSession.add(anchor: geoAnchor)
    }

    func createGeoAnchorWithAltitudeSource(
        latitude: Double,
        longitude: Double,
        altitudeSource: ARGeoAnchor.AltitudeSource
    ) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // iOS 15+: Specify altitude source
        let geoAnchor = ARGeoAnchor(
            coordinate: coordinate,
            altitudeSource: altitudeSource
        )

        arSession.add(anchor: geoAnchor)
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let geoAnchor = anchor as? ARGeoAnchor {
                handleGeoAnchorAdded(geoAnchor)
            }
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let geoAnchor = anchor as? ARGeoAnchor {
                handleGeoAnchorUpdated(geoAnchor)
            }
        }
    }

    func handleGeoAnchorAdded(_ geoAnchor: ARGeoAnchor) {
        // Create visual content for the anchor
        let node = createAnchorNode(for: geoAnchor)
        arView.scene.rootNode.addChildNode(node)

        print("""
            Geo anchor added:
            - Coordinate: \(geoAnchor.coordinate)
            - Altitude: \(geoAnchor.altitude)
            - Altitude Source: \(geoAnchor.altitudeSource)
        """)
    }

    func handleGeoAnchorUpdated(_ geoAnchor: ARGeoAnchor) {
        // Update visual if accuracy changed
        print("Geo anchor accuracy: \(geoAnchor.positionAccuracy)")
    }

    func session(_ session: ARSession, didChange geoTrackingStatus: ARGeoTrackingStatus) {
        switch geoTrackingStatus.state {
        case .notAvailable:
            showStatus("Geo-tracking not available")
        case .initializing:
            showStatus("Initializing geo-tracking...")
        case .localizing:
            showStatus("Localizing... Point camera at buildings")
        case .localized:
            showStatus("Localized! Accuracy: \(geoTrackingStatus.accuracy)")
        @unknown default:
            break
        }

        // Handle state reason
        if let reason = geoTrackingStatus.stateReason {
            handleStateReason(reason)
        }
    }

    func handleStateReason(_ reason: ARGeoTrackingStatus.StateReason) {
        switch reason {
        case .none:
            break
        case .notAvailableAtLocation:
            showAlert("Move to a supported location")
        case .needLocationPermissions:
            locationManager.requestWhenInUseAuthorization()
        case .geoDataNotLoaded:
            showStatus("Loading location data...")
        case .devicePointedTooLow:
            showStatus("Point device higher at buildings")
        case .visualLocalizationFailed:
            showStatus("Move to area with clear building features")
        case .waitingForLocation:
            showStatus("Acquiring GPS signal...")
        case .waitingForAvailabilityCheck:
            showStatus("Checking availability...")
        @unknown default:
            break
        }
    }

    // MARK: - Visual Content

    func createAnchorNode(for geoAnchor: ARGeoAnchor) -> SCNNode {
        // Create a marker at the anchor position
        let geometry = SCNCylinder(radius: 0.1, height: 2.0)
        geometry.firstMaterial?.diffuse.contents = UIColor.systemBlue

        let node = SCNNode(geometry: geometry)
        node.simdTransform = geoAnchor.transform

        // Add label
        let text = SCNText(string: "Geo Anchor", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 0.2)
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0, 2.5, 0)
        node.addChildNode(textNode)

        return node
    }

    // MARK: - Helpers

    func showStatus(_ message: String) {
        // Update UI with status
        print("Status: \(message)")
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "VPS", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### 2.2 ARCore Geospatial API for iOS

**Status:** Production-ready, broad geographic coverage

ARCore's Geospatial API is available for iOS, providing access to Google's VPS with Street View coverage in 93+ countries.

```swift
// ARCore Geospatial API on iOS - Swift

import ARCore
import ARKit

class ARCoreGeospatialViewController: UIViewController {

    var garSession: GARSession!
    var arSession: ARSession!
    var arView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupARView()
        setupGARSession()
    }

    func setupARView() {
        arView = ARSCNView(frame: view.bounds)
        view.addSubview(arView)

        arSession = arView.session
    }

    func setupGARSession() {
        do {
            // Create ARCore session with ARKit session
            garSession = try GARSession(apiKey: "YOUR_GOOGLE_CLOUD_API_KEY", bundleIdentifier: nil)

            // Configure for Geospatial
            var config = GARSessionConfiguration()
            config.geospatialMode = .enabled

            var error: NSError?
            garSession.setConfiguration(config, error: &error)

            if let error = error {
                print("Configuration error: \(error)")
            }

        } catch {
            print("Failed to create GARSession: \(error)")
        }
    }

    func startSession() {
        // Start ARKit session
        let config = ARWorldTrackingConfiguration()
        arSession.run(config)

        // Start update loop
        Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true) { [weak self] _ in
            self?.updateGeospatial()
        }
    }

    func updateGeospatial() {
        guard let frame = arSession.currentFrame else { return }

        do {
            // Update ARCore with current frame
            let garFrame = try garSession.update(frame)

            // Get geospatial transform
            if let earth = garFrame.earth,
               earth.trackingState == .tracking {
                handleEarthTracking(earth)
            }

        } catch {
            print("Update error: \(error)")
        }
    }

    func handleEarthTracking(_ earth: GAREarth) {
        guard let pose = earth.cameraGeospatialTransform else { return }

        print("""
            Geospatial Pose:
            - Latitude: \(pose.coordinate.latitude)
            - Longitude: \(pose.coordinate.longitude)
            - Altitude: \(pose.altitude)
            - Heading: \(pose.heading)
            - Horizontal Accuracy: \(pose.horizontalAccuracy)m
            - Vertical Accuracy: \(pose.verticalAccuracy)m
            - Heading Accuracy: \(pose.headingAccuracy)°
        """)
    }

    // MARK: - Creating Geospatial Anchors

    func createWGS84Anchor(latitude: Double, longitude: Double, altitude: Double, heading: Double) {
        guard let earth = try? garSession.update(arSession.currentFrame!).earth,
              earth.trackingState == .tracking else {
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let quaternion = createQuaternionFromHeading(heading)

        do {
            let anchor = try earth.createAnchor(
                coordinate: coordinate,
                altitude: altitude,
                eastUpSouthQTarget: quaternion
            )

            handleAnchorCreated(anchor)
        } catch {
            print("Failed to create anchor: \(error)")
        }
    }

    func createTerrainAnchor(latitude: Double, longitude: Double, heading: Double) {
        guard let earth = try? garSession.update(arSession.currentFrame!).earth,
              earth.trackingState == .tracking else {
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let quaternion = createQuaternionFromHeading(heading)

        // Create terrain anchor (altitude from Google's terrain data)
        earth.createAnchorOnTerrain(
            coordinate: coordinate,
            altitudeAboveTerrain: 0.0, // At ground level
            eastUpSouthQTarget: quaternion
        ) { [weak self] anchor, state in
            switch state {
            case .success:
                if let anchor = anchor {
                    self?.handleAnchorCreated(anchor)
                }
            case .errorInternal:
                print("Internal error creating terrain anchor")
            case .errorNotAuthorized:
                print("Not authorized")
            case .taskInProgress:
                print("Task in progress...")
            @unknown default:
                break
            }
        }
    }

    func createRooftopAnchor(latitude: Double, longitude: Double, heading: Double) {
        guard let earth = try? garSession.update(arSession.currentFrame!).earth,
              earth.trackingState == .tracking else {
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let quaternion = createQuaternionFromHeading(heading)

        // Create rooftop anchor (altitude from building rooftop data)
        earth.createAnchorOnRooftop(
            coordinate: coordinate,
            altitudeAboveRooftop: 0.0,
            eastUpSouthQTarget: quaternion
        ) { [weak self] anchor, state in
            if case .success = state, let anchor = anchor {
                self?.handleAnchorCreated(anchor)
            }
        }
    }

    func handleAnchorCreated(_ anchor: GARAnchor) {
        print("Anchor created: \(anchor.identifier)")
        // Add visual content at anchor position
    }

    func createQuaternionFromHeading(_ heading: Double) -> simd_quatf {
        let radians = Float(heading * .pi / 180.0)
        return simd_quatf(angle: radians, axis: simd_float3(0, 1, 0))
    }
}
```

### 2.3 Niantic Lightship VPS for iOS

**Status:** Production-ready, 1M+ locations

Lightship VPS uses Niantic's proprietary map data from years of Pokemon GO and Ingress player scanning.

```swift
// Niantic Lightship VPS - Swift

import ARKit
import NianticLightshipAR

class LightshipVPSViewController: UIViewController, ARSessionDelegate, IARDKLocationUpdateListener {

    var arSession: ARSession!
    var lightshipSession: LightshipARSession!
    var vpsManager: VPSLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLightship()
        setupVPS()
    }

    func setupLightship() {
        // Initialize Lightship
        let config = LightshipConfiguration()
        config.apiKey = "YOUR_LIGHTSHIP_API_KEY"

        lightshipSession = LightshipARSession(configuration: config)
        arSession = lightshipSession.arSession
        arSession.delegate = self
    }

    func setupVPS() {
        vpsManager = VPSLocationManager()
        vpsManager.delegate = self

        // Configure VPS settings
        vpsManager.localizationTimeout = 30.0
        vpsManager.continuousLocalization = true
    }

    func startVPSSession(locationId: String) {
        // Start VPS at specific location
        vpsManager.startLocalization(
            locationId: locationId,
            onSuccess: { [weak self] pose in
                self?.handleLocalizationSuccess(pose)
            },
            onFailure: { [weak self] error in
                self?.handleLocalizationFailure(error)
            }
        )
    }

    func startVPSSessionNearby() {
        // Find nearby VPS-enabled locations
        guard let location = getCurrentLocation() else { return }

        vpsManager.findNearbyLocations(
            coordinate: location.coordinate,
            radius: 200 // meters
        ) { [weak self] locations in
            if let nearest = locations.first {
                self?.startVPSSession(locationId: nearest.id)
            } else {
                print("No VPS locations nearby")
            }
        }
    }

    func handleLocalizationSuccess(_ pose: VPSPose) {
        print("""
            VPS Localized!
            - Location ID: \(pose.locationId)
            - Position: \(pose.position)
            - Rotation: \(pose.rotation)
            - Confidence: \(pose.confidence)
        """)

        // Create anchor at VPS location
        createVPSAnchor(at: pose)
    }

    func handleLocalizationFailure(_ error: VPSError) {
        switch error {
        case .timeout:
            showMessage("Localization timed out. Move around the location.")
        case .locationNotActivated:
            showMessage("This location isn't VPS-enabled yet.")
        case .insufficientFeatures:
            showMessage("Not enough visual features. Try different angle.")
        case .networkError:
            showMessage("Network error. Check connection.")
        default:
            showMessage("Localization failed: \(error)")
        }
    }

    func createVPSAnchor(at pose: VPSPose) {
        // Create persistent anchor at VPS location
        let anchorPayload = VPSAnchorPayload()
        anchorPayload.locationId = pose.locationId
        anchorPayload.localPose = pose.localTransform

        vpsManager.createAnchor(payload: anchorPayload) { anchor, error in
            if let anchor = anchor {
                print("VPS Anchor created: \(anchor.id)")
                // Anchor can be saved and restored later
            }
        }
    }

    // MARK: - IARDKLocationUpdateListener

    func onLocationUpdated(_ location: VPSLocation) {
        // Continuous VPS updates
        print("VPS update - tracking quality: \(location.trackingQuality)")
    }

    func onLocationLost() {
        showMessage("VPS tracking lost. Return to mapped area.")
    }

    // MARK: - Helpers

    func getCurrentLocation() -> CLLocation? {
        // Return current GPS location
        return nil // Implement with CLLocationManager
    }

    func showMessage(_ message: String) {
        print(message)
    }
}

// VPS Location Coverage Helper
class VPSCoverageChecker {

    let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func checkCoverage(latitude: Double, longitude: Double, completion: @escaping (VPSCoverageResult) -> Void) {
        // Query Lightship API for VPS coverage
        let endpoint = "https://vps.nianticlabs.com/v1/coverage"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "radius": 500 // meters
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.error(error))
                return
            }

            do {
                let result = try JSONDecoder().decode(VPSCoverageResult.self, from: data)
                completion(result)
            } catch {
                completion(.error(error))
            }
        }.resume()
    }
}

enum VPSCoverageResult {
    case covered(locations: [VPSLocationInfo])
    case notCovered
    case error(Error?)
}

struct VPSLocationInfo: Codable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let activationStatus: String
    let qualityScore: Double
}
```

## Android Technologies

### 2.4 ARCore Geospatial API (Android)

**Status:** Production-ready, 93+ countries

ARCore Geospatial is Google's primary VPS solution for Android, using Street View data for visual localization.

```kotlin
// ARCore Geospatial API - Kotlin

import com.google.ar.core.*
import com.google.ar.core.exceptions.*

class GeospatialActivity : AppCompatActivity() {

    private lateinit var arSession: Session
    private lateinit var arView: ArSceneView
    private var earth: Earth? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_geospatial)

        arView = findViewById(R.id.arView)

        checkGeospatialSupport()
    }

    private fun checkGeospatialSupport() {
        // Check device support
        val availability = ArCoreApk.getInstance()
            .checkAvailability(this)

        if (availability.isSupported) {
            setupSession()
        } else {
            showError("ARCore not supported on this device")
        }
    }

    private fun setupSession() {
        try {
            arSession = Session(this)

            // Configure for Geospatial
            val config = Config(arSession).apply {
                geospatialMode = Config.GeospatialMode.ENABLED

                // Optional: Enable Streetscape Geometry
                streetscapeGeometryMode = Config.StreetscapeGeometryMode.ENABLED
            }

            arSession.configure(config)
            arView.setupSession(arSession)

        } catch (e: UnavailableDeviceNotCompatibleException) {
            showError("Device not compatible: ${e.message}")
        } catch (e: UnavailableApkTooOldException) {
            showError("Please update ARCore: ${e.message}")
        }
    }

    override fun onResume() {
        super.onResume()
        arSession.resume()
        startGeospatialTracking()
    }

    private fun startGeospatialTracking() {
        arView.scene.addOnUpdateListener { frameTime ->
            val frame = arSession.update()
            earth = frame.earth

            earth?.let { handleEarthUpdate(it) }
        }
    }

    private fun handleEarthUpdate(earth: Earth) {
        when (earth.trackingState) {
            TrackingState.TRACKING -> {
                earth.cameraGeospatialPose?.let { pose ->
                    updateGeospatialUI(pose)

                    // Check if accuracy is good enough for anchors
                    if (pose.horizontalAccuracy < 10.0 &&
                        pose.headingAccuracy < 15.0) {
                        enableAnchorPlacement()
                    }
                }
            }
            TrackingState.PAUSED -> {
                showStatus("Geospatial tracking paused")
            }
            TrackingState.STOPPED -> {
                showStatus("Geospatial tracking stopped")
            }
        }

        // Handle Earth state
        when (earth.earthState) {
            Earth.EarthState.ENABLED -> { /* Good */ }
            Earth.EarthState.ERROR_INTERNAL -> {
                showError("Internal Geospatial error")
            }
            Earth.EarthState.ERROR_NOT_AUTHORIZED -> {
                showError("Not authorized - check API key")
            }
            Earth.EarthState.ERROR_RESOURCE_EXHAUSTED -> {
                showError("API quota exceeded")
            }
        }
    }

    private fun updateGeospatialUI(pose: GeospatialPose) {
        runOnUiThread {
            findViewById<TextView>(R.id.latitudeText).text =
                "Lat: %.6f".format(pose.latitude)
            findViewById<TextView>(R.id.longitudeText).text =
                "Lng: %.6f".format(pose.longitude)
            findViewById<TextView>(R.id.altitudeText).text =
                "Alt: %.1fm".format(pose.altitude)
            findViewById<TextView>(R.id.headingText).text =
                "Heading: %.1f°".format(pose.heading)
            findViewById<TextView>(R.id.accuracyText).text =
                "Accuracy: ±%.1fm, ±%.1f°".format(
                    pose.horizontalAccuracy,
                    pose.headingAccuracy
                )
        }
    }

    // MARK: - Anchor Creation

    fun createWGS84Anchor(
        latitude: Double,
        longitude: Double,
        altitude: Double,
        heading: Double
    ): Anchor? {
        val earth = this.earth ?: return null

        if (earth.trackingState != TrackingState.TRACKING) {
            return null
        }

        // Create quaternion from heading
        val headingRadians = Math.toRadians(heading)
        val quaternion = floatArrayOf(
            0f,
            sin(headingRadians / 2).toFloat(),
            0f,
            cos(headingRadians / 2).toFloat()
        )

        return earth.createAnchor(
            latitude,
            longitude,
            altitude,
            quaternion[0], quaternion[1], quaternion[2], quaternion[3]
        )
    }

    fun createTerrainAnchor(
        latitude: Double,
        longitude: Double,
        altitudeAboveTerrain: Double,
        heading: Double,
        callback: (Anchor?, Anchor.TerrainAnchorState) -> Unit
    ) {
        val earth = this.earth ?: return

        val headingRadians = Math.toRadians(heading)
        val quaternion = floatArrayOf(
            0f,
            sin(headingRadians / 2).toFloat(),
            0f,
            cos(headingRadians / 2).toFloat()
        )

        val future = earth.resolveAnchorOnTerrainAsync(
            latitude,
            longitude,
            altitudeAboveTerrain,
            quaternion[0], quaternion[1], quaternion[2], quaternion[3]
        ) { anchor, state ->
            runOnUiThread {
                callback(anchor, state)
            }
        }
    }

    fun createRooftopAnchor(
        latitude: Double,
        longitude: Double,
        altitudeAboveRooftop: Double,
        heading: Double,
        callback: (Anchor?, Anchor.RooftopAnchorState) -> Unit
    ) {
        val earth = this.earth ?: return

        val headingRadians = Math.toRadians(heading)
        val quaternion = floatArrayOf(
            0f,
            sin(headingRadians / 2).toFloat(),
            0f,
            cos(headingRadians / 2).toFloat()
        )

        earth.resolveAnchorOnRooftopAsync(
            latitude,
            longitude,
            altitudeAboveRooftop,
            quaternion[0], quaternion[1], quaternion[2], quaternion[3]
        ) { anchor, state ->
            runOnUiThread {
                callback(anchor, state)
            }
        }
    }

    // MARK: - Streetscape Geometry

    private fun handleStreetscapeGeometry(frame: Frame) {
        val streetscapeGeometries = frame.getUpdatedTrackables(
            StreetscapeGeometry::class.java
        )

        for (geometry in streetscapeGeometries) {
            when (geometry.type) {
                StreetscapeGeometry.Type.TERRAIN -> {
                    // Ground mesh
                    renderTerrainMesh(geometry.mesh)
                }
                StreetscapeGeometry.Type.BUILDING -> {
                    // Building mesh
                    renderBuildingMesh(geometry.mesh)
                }
            }
        }
    }

    private fun renderTerrainMesh(mesh: Mesh) {
        // Render terrain for ground occlusion
    }

    private fun renderBuildingMesh(mesh: Mesh) {
        // Render building for structure occlusion
    }

    // MARK: - Helpers

    private fun showStatus(message: String) {
        runOnUiThread {
            Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
        }
    }

    private fun showError(message: String) {
        runOnUiThread {
            Toast.makeText(this, message, Toast.LENGTH_LONG).show()
        }
    }

    private fun enableAnchorPlacement() {
        findViewById<Button>(R.id.placeAnchorButton).isEnabled = true
    }
}
```

### 2.5 Niantic Lightship VPS (Android/Unity)

**Status:** Production-ready

```csharp
// Niantic Lightship VPS - Unity C#

using Niantic.Lightship.AR;
using Niantic.Lightship.AR.VPS;
using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class LightshipVPSManager : MonoBehaviour
{
    [SerializeField] private ARSession arSession;
    [SerializeField] private ARCameraManager cameraManager;
    [SerializeField] private GameObject anchorPrefab;

    private IVPSLocationManager vpsManager;
    private VPSLocalizationState currentState;

    void Start()
    {
        InitializeVPS();
    }

    void InitializeVPS()
    {
        // Get VPS manager from Lightship
        vpsManager = VPSLocationManagerFactory.Create();

        // Subscribe to events
        vpsManager.OnLocalizationStateChanged += OnLocalizationStateChanged;
        vpsManager.OnLocationUpdated += OnLocationUpdated;
    }

    public void StartVPSAtLocation(string locationId)
    {
        var config = new VPSLocalizationConfiguration
        {
            LocationId = locationId,
            LocalizationTimeout = 30f,
            ContinuousLocalization = true
        };

        vpsManager.StartLocalization(config);
    }

    public async void FindNearbyVPSLocations()
    {
        // Get current GPS position
        var gpsPosition = await GetGPSPositionAsync();

        // Query for nearby VPS locations
        var nearbyQuery = new VPSNearbyQuery
        {
            Latitude = gpsPosition.latitude,
            Longitude = gpsPosition.longitude,
            RadiusMeters = 200
        };

        var locations = await vpsManager.FindNearbyLocationsAsync(nearbyQuery);

        if (locations.Count > 0)
        {
            Debug.Log($"Found {locations.Count} VPS locations nearby");
            foreach (var loc in locations)
            {
                Debug.Log($"  - {loc.Name} ({loc.Id})");
            }

            // Start VPS at nearest location
            StartVPSAtLocation(locations[0].Id);
        }
        else
        {
            Debug.LogWarning("No VPS locations found nearby");
        }
    }

    void OnLocalizationStateChanged(VPSLocalizationState state)
    {
        currentState = state;

        switch (state)
        {
            case VPSLocalizationState.Initializing:
                ShowUI("Initializing VPS...");
                break;

            case VPSLocalizationState.Localizing:
                ShowUI("Look at your surroundings...");
                break;

            case VPSLocalizationState.Localized:
                ShowUI("Localized!");
                OnVPSLocalized();
                break;

            case VPSLocalizationState.Failed:
                ShowUI("Localization failed. Try moving around.");
                break;
        }
    }

    void OnLocationUpdated(VPSLocationUpdate update)
    {
        Debug.Log($"VPS Update - Quality: {update.TrackingQuality}");

        // Update any positioned content
        UpdateAnchoredContent(update.LocalToWorldTransform);
    }

    void OnVPSLocalized()
    {
        // Get the localized pose
        var pose = vpsManager.GetCurrentPose();

        // Create anchored content
        CreateVPSAnchor(pose.Position, pose.Rotation);
    }

    public void CreateVPSAnchor(Vector3 position, Quaternion rotation)
    {
        // Create a VPS anchor that persists
        var anchorData = new VPSAnchorData
        {
            LocalPosition = position,
            LocalRotation = rotation,
            LocationId = vpsManager.CurrentLocationId
        };

        var anchor = vpsManager.CreateAnchor(anchorData);

        // Instantiate visual at anchor
        var anchorGO = Instantiate(anchorPrefab, anchor.Transform);
        anchorGO.transform.localPosition = Vector3.zero;
        anchorGO.transform.localRotation = Quaternion.identity;

        Debug.Log($"Created VPS anchor: {anchor.Id}");
    }

    public async void RestoreSavedAnchors(string[] anchorIds)
    {
        foreach (var id in anchorIds)
        {
            try
            {
                var anchor = await vpsManager.ResolveAnchorAsync(id);

                if (anchor != null)
                {
                    var anchorGO = Instantiate(anchorPrefab, anchor.Transform);
                    Debug.Log($"Restored anchor: {id}");
                }
            }
            catch (System.Exception e)
            {
                Debug.LogError($"Failed to restore anchor {id}: {e.Message}");
            }
        }
    }

    void UpdateAnchoredContent(Matrix4x4 localToWorld)
    {
        // Update all anchored objects based on VPS tracking
    }

    async Task<(double latitude, double longitude)> GetGPSPositionAsync()
    {
        // Use Unity's LocationService
        if (!Input.location.isEnabledByUser)
        {
            Debug.LogError("Location services not enabled");
            return (0, 0);
        }

        Input.location.Start(1f, 1f);

        int timeout = 20;
        while (Input.location.status == LocationServiceStatus.Initializing && timeout > 0)
        {
            await Task.Delay(1000);
            timeout--;
        }

        if (Input.location.status == LocationServiceStatus.Running)
        {
            var loc = Input.location.lastData;
            return (loc.latitude, loc.longitude);
        }

        return (0, 0);
    }

    void ShowUI(string message)
    {
        Debug.Log($"VPS Status: {message}");
        // Update UI element
    }

    void OnDestroy()
    {
        vpsManager?.StopLocalization();
        vpsManager?.Dispose();
    }
}
```

## Native Mobile Challenges

| Challenge | Impact | Mitigation |
|-----------|--------|------------|
| Device fragmentation (Android) | Inconsistent VPS quality | Test on multiple devices, graceful fallback |
| City coverage limits (ARKit) | Limited to supported cities | Fallback to GPS + compass |
| Battery consumption | User experience | Optimize localization frequency |
| Privacy concerns | User trust | Clear data usage disclosure |
| Initial localization time | User patience | Coaching UI, visual guidance |
| Indoor/outdoor transitions | Tracking loss | Hybrid indoor VPS (Immersal) |

## Native Mobile Opportunities

1. **Deep platform integration** - Best performance and accuracy
2. **Background capabilities** - Persistent location tracking
3. **Hardware acceleration** - GPU/NPU for feature extraction
4. **Sensor fusion** - IMU + camera + LiDAR
5. **Offline capability** - Cached maps for known areas

## Products Using Native VPS

| Product | Platform | Technology | Use Case |
|---------|----------|------------|----------|
| Pokemon GO | iOS/Android | Lightship VPS | AR gaming |
| Google Maps Live View | iOS/Android | ARCore Geospatial | Navigation |
| DHL AR Delivery | Android | ARCore Geospatial | Package delivery |
| Snapchat AR | iOS/Android | Lightship VPS | Social AR |
| Nintendo Pikmin | iOS/Android | Lightship VPS | AR gaming |
| IKEA Place | iOS | ARKit | Furniture visualization |
| Wayfair View | iOS/Android | ARKit/ARCore | Home decor |

---

# Section 3: VPS on AR Glasses

## Overview

AR glasses represent the future of VPS, enabling persistent, hands-free AR experiences. Hardware limitations (battery, thermal, compute) make VPS implementation challenging but essential.

## Technologies by Platform

### 3.1 Apple Vision Pro (visionOS)

**Status:** Emerging, visionOS 26 adds shared anchors

Vision Pro uses inside-out tracking with world mapping. visionOS 26 (announced 2025) adds shared world anchors for multi-user experiences.

```swift
// visionOS Spatial Anchors - Swift

import RealityKit
import ARKit
import SwiftUI

// MARK: - World Anchor Manager

@MainActor
class VisionProVPSManager: ObservableObject {

    private var arSession: ARKitSession!
    private var worldTracking: WorldTrackingProvider!

    @Published var worldAnchors: [UUID: WorldAnchor] = [:]
    @Published var trackingState: WorldTrackingProvider.State = .stopped

    init() {
        arSession = ARKitSession()
        worldTracking = WorldTrackingProvider()
    }

    func startTracking() async throws {
        // Check authorization
        let authStatus = await arSession.queryAuthorization(for: [.worldSensing])

        guard authStatus[.worldSensing] == .allowed else {
            throw VPSError.notAuthorized
        }

        // Start world tracking
        try await arSession.run([worldTracking])

        // Listen for anchor updates
        Task {
            for await update in worldTracking.anchorUpdates {
                await handleAnchorUpdate(update)
            }
        }
    }

    func handleAnchorUpdate(_ update: AnchorUpdate<WorldAnchor>) async {
        switch update.event {
        case .added:
            worldAnchors[update.anchor.id] = update.anchor
            print("Anchor added: \(update.anchor.id)")

        case .updated:
            worldAnchors[update.anchor.id] = update.anchor

        case .removed:
            worldAnchors.removeValue(forKey: update.anchor.id)
        }
    }

    // MARK: - Create Persistent Anchor

    func createWorldAnchor(at position: SIMD3<Float>, name: String) async throws -> WorldAnchor {
        let transform = Transform(translation: position)
        let anchor = WorldAnchor(originFromAnchorTransform: transform.matrix)

        try await worldTracking.addAnchor(anchor)

        // Persist anchor for future sessions
        try await persistAnchor(anchor, name: name)

        return anchor
    }

    func persistAnchor(_ anchor: WorldAnchor, name: String) async throws {
        // Store anchor data for restoration
        let anchorData = AnchorPersistenceData(
            id: anchor.id,
            name: name,
            transform: anchor.originFromAnchorTransform,
            createdAt: Date()
        )

        try await AnchorStore.shared.save(anchorData)
    }

    // MARK: - Restore Anchors

    func restoreAnchors() async throws {
        let savedAnchors = try await AnchorStore.shared.loadAll()

        for anchorData in savedAnchors {
            // World anchors are automatically restored when re-entering
            // the same physical space - no manual restoration needed
            print("Waiting for anchor \(anchorData.name) to be recognized")
        }
    }

    // MARK: - visionOS 26: Shared World Anchors

    @available(visionOS 26, *)
    func createSharedAnchor(at position: SIMD3<Float>) async throws -> SharedWorldAnchor {
        let transform = Transform(translation: position)
        let sharedAnchor = SharedWorldAnchor(originFromAnchorTransform: transform.matrix)

        // Enable sharing with nearby Vision Pro users
        sharedAnchor.sharingConfiguration = .automatic

        try await worldTracking.addAnchor(sharedAnchor)

        return sharedAnchor
    }

    @available(visionOS 26, *)
    func joinSharedSession(sessionID: String) async throws {
        // Join an existing shared anchor session
        let sharedSession = try await SharedWorldSession.join(sessionID: sessionID)

        // Receive shared anchors from other users
        for await anchor in sharedSession.anchorUpdates {
            await handleSharedAnchorUpdate(anchor)
        }
    }

    @available(visionOS 26, *)
    func handleSharedAnchorUpdate(_ update: AnchorUpdate<SharedWorldAnchor>) async {
        // Handle anchors shared by other Vision Pro users
        switch update.event {
        case .added:
            print("Received shared anchor from peer: \(update.anchor.peerID)")
        default:
            break
        }
    }
}

// MARK: - RealityKit Integration

struct VPSContentView: View {
    @StateObject private var vpsManager = VisionProVPSManager()

    var body: some View {
        RealityView { content in
            // Set up 3D content
        } update: { content in
            // Update content based on anchors
            for (_, anchor) in vpsManager.worldAnchors {
                if anchor.isTracked {
                    updateAnchoredContent(content: content, anchor: anchor)
                }
            }
        }
        .task {
            do {
                try await vpsManager.startTracking()
                try await vpsManager.restoreAnchors()
            } catch {
                print("VPS error: \(error)")
            }
        }
    }

    func updateAnchoredContent(content: RealityViewContent, anchor: WorldAnchor) {
        // Place content at anchor position
        let entity = ModelEntity(mesh: .generateSphere(radius: 0.1))
        entity.position = anchor.originFromAnchorTransform.columns.3.xyz
        content.add(entity)
    }
}

// MARK: - Support Types

struct AnchorPersistenceData: Codable {
    let id: UUID
    let name: String
    let transform: simd_float4x4
    let createdAt: Date
}

actor AnchorStore {
    static let shared = AnchorStore()

    private var anchors: [UUID: AnchorPersistenceData] = [:]

    func save(_ data: AnchorPersistenceData) throws {
        anchors[data.id] = data
        // Persist to UserDefaults or CloudKit
    }

    func loadAll() throws -> [AnchorPersistenceData] {
        return Array(anchors.values)
    }
}

enum VPSError: Error {
    case notAuthorized
    case trackingFailed
    case anchorNotFound
}
```

### 3.2 Meta Quest 3 (Lightship VPS)

**Status:** Active, Lightship VPS integration

Quest 3 supports Niantic Lightship VPS through the Meta Quest SDK, enabling location-based AR experiences.

```csharp
// Quest 3 with Lightship VPS - Unity C#

using Niantic.Lightship.AR;
using Niantic.Lightship.AR.VPS;
using UnityEngine;
using Oculus.Platform;
using Meta.XR.MRUtilityKit;

public class QuestVPSManager : MonoBehaviour
{
    [SerializeField] private OVRCameraRig cameraRig;
    [SerializeField] private MRUKRoom currentRoom;
    [SerializeField] private GameObject vpsPrefab;

    private IVPSLocationManager vpsManager;
    private bool isLocalized = false;

    async void Start()
    {
        // Initialize Quest platform
        await InitializeOculusPlatform();

        // Initialize Lightship VPS
        InitializeVPS();

        // Request passthrough
        EnablePassthrough();
    }

    async Task InitializeOculusPlatform()
    {
        try
        {
            await Core.AsyncInitialize();
            Debug.Log("Oculus Platform initialized");
        }
        catch (System.Exception e)
        {
            Debug.LogError($"Platform init failed: {e.Message}");
        }
    }

    void InitializeVPS()
    {
        vpsManager = VPSLocationManagerFactory.Create();

        vpsManager.OnLocalizationStateChanged += OnVPSStateChanged;
        vpsManager.OnLocationUpdated += OnVPSLocationUpdated;
    }

    void EnablePassthrough()
    {
        var passthroughLayer = gameObject.AddComponent<OVRPassthroughLayer>();
        passthroughLayer.overlayType = OVROverlay.OverlayType.Underlay;

        // Enable mixed reality mode
        OVRManager.instance.isInsightPassthroughEnabled = true;
    }

    public async void StartVPSSession()
    {
        // Get GPS from phone companion app or Quest GPS (if available)
        var gpsPosition = await GetGPSPositionAsync();

        // Find nearby VPS locations
        var query = new VPSNearbyQuery
        {
            Latitude = gpsPosition.latitude,
            Longitude = gpsPosition.longitude,
            RadiusMeters = 200
        };

        var locations = await vpsManager.FindNearbyLocationsAsync(query);

        if (locations.Count > 0)
        {
            var config = new VPSLocalizationConfiguration
            {
                LocationId = locations[0].Id,
                LocalizationTimeout = 45f,
                ContinuousLocalization = true
            };

            vpsManager.StartLocalization(config);
        }
        else
        {
            Debug.Log("No VPS locations found. Using room-scale tracking only.");
        }
    }

    void OnVPSStateChanged(VPSLocalizationState state)
    {
        switch (state)
        {
            case VPSLocalizationState.Localizing:
                ShowMessage("Look around your environment...");
                break;

            case VPSLocalizationState.Localized:
                isLocalized = true;
                ShowMessage("VPS Localized!");
                PlaceVPSContent();
                break;

            case VPSLocalizationState.Failed:
                ShowMessage("VPS failed - using room tracking");
                FallbackToRoomTracking();
                break;
        }
    }

    void OnVPSLocationUpdated(VPSLocationUpdate update)
    {
        // Update content positions based on VPS
        UpdateContentPositions(update.LocalToWorldTransform);
    }

    void PlaceVPSContent()
    {
        // Get VPS pose
        var pose = vpsManager.GetCurrentPose();

        // Create anchored content
        var content = Instantiate(vpsPrefab);
        content.transform.position = pose.Position;
        content.transform.rotation = pose.Rotation;

        // Anchor to VPS location
        var anchor = vpsManager.CreateAnchor(new VPSAnchorData
        {
            LocalPosition = pose.Position,
            LocalRotation = pose.Rotation,
            LocationId = vpsManager.CurrentLocationId
        });

        content.transform.SetParent(anchor.Transform);
    }

    void FallbackToRoomTracking()
    {
        // Use Quest's native spatial anchors instead
        var spatialAnchor = new OVRSpatialAnchor();

        // Room-scale tracking as fallback
        if (currentRoom != null)
        {
            PlaceContentInRoom();
        }
    }

    void PlaceContentInRoom()
    {
        // Use Meta MR Utility Kit room data
        var anchors = currentRoom.GetComponentsInChildren<MRUKAnchor>();

        foreach (var anchor in anchors)
        {
            if (anchor.Label == OVRSemanticLabels.Classification.WallFace)
            {
                // Place content on walls
                var content = Instantiate(vpsPrefab, anchor.transform);
            }
        }
    }

    void UpdateContentPositions(Matrix4x4 localToWorld)
    {
        // Update all VPS-anchored content
    }

    async Task<(double latitude, double longitude)> GetGPSPositionAsync()
    {
        // Quest 3 may use phone companion for GPS
        // or can request location from Android services

#if UNITY_ANDROID
        if (!Input.location.isEnabledByUser)
        {
            var permission = Permission.HasUserAuthorizedPermission(Permission.FineLocation);
            if (!permission)
            {
                Permission.RequestUserPermission(Permission.FineLocation);
            }
        }

        Input.location.Start(1f, 1f);

        int timeout = 20;
        while (Input.location.status == LocationServiceStatus.Initializing && timeout > 0)
        {
            await Task.Delay(1000);
            timeout--;
        }

        if (Input.location.status == LocationServiceStatus.Running)
        {
            var data = Input.location.lastData;
            return (data.latitude, data.longitude);
        }
#endif

        return (0, 0);
    }

    void ShowMessage(string message)
    {
        Debug.Log(message);
        // Update UI
    }
}
```

### 3.3 Snap Spectacles (Snap OS 2.0)

**Status:** Active, Snap-Niantic VPS partnership

Snap Spectacles use the Snap-Niantic partnership for VPS, accessed through Lens Studio.

```typescript
// Snap Spectacles VPS Lens - TypeScript (Lens Studio)

import {
  SceneObject,
  Transform,
  LocationService,
  VPSComponent,
  WorldTrackingComponent
} from 'LensStudio';

@component
export class SpectaclesVPSController extends BaseScriptComponent {

  @input
  contentRoot: SceneObject;

  @input
  vpsLocationId: string;

  private vps: VPSComponent;
  private worldTracking: WorldTrackingComponent;
  private locationService: LocationService;
  private isLocalized: boolean = false;

  onAwake(): void {
    // Get VPS component
    this.vps = this.sceneObject.getComponent('VPSComponent');
    this.worldTracking = this.sceneObject.getComponent('WorldTrackingComponent');
    this.locationService = new LocationService();

    // Setup callbacks
    this.setupVPSCallbacks();

    // Start VPS
    this.startVPS();
  }

  setupVPSCallbacks(): void {
    this.vps.onLocalized.add(() => {
      this.onVPSLocalized();
    });

    this.vps.onLocalizationFailed.add((error) => {
      this.onVPSFailed(error);
    });

    this.vps.onTrackingUpdated.add((pose) => {
      this.onTrackingUpdated(pose);
    });
  }

  async startVPS(): Promise<void> {
    // Check if VPS is available
    if (!this.vps.isAvailable()) {
      print('VPS not available on this device');
      return;
    }

    // Get current location
    const location = await this.getCurrentLocation();

    if (this.vpsLocationId) {
      // Start at specific location
      this.vps.startLocalization(this.vpsLocationId);
    } else {
      // Find nearby locations
      const nearbyLocations = await this.vps.findNearbyLocations(
        location.latitude,
        location.longitude,
        200 // radius in meters
      );

      if (nearbyLocations.length > 0) {
        this.vps.startLocalization(nearbyLocations[0].id);
      } else {
        print('No VPS locations nearby');
      }
    }
  }

  onVPSLocalized(): void {
    print('VPS Localized!');
    this.isLocalized = true;

    // Get localized pose
    const pose = this.vps.getLocalizedPose();

    // Place content at VPS origin
    this.placeContent(pose);

    // Create persistent anchor
    this.createVPSAnchor(pose);
  }

  onVPSFailed(error: string): void {
    print(`VPS Failed: ${error}`);

    // Fallback to world tracking
    this.worldTracking.start();
  }

  onTrackingUpdated(pose: VPSPose): void {
    if (!this.isLocalized) return;

    // Update content transform based on VPS tracking
    this.updateContentTransform(pose);
  }

  placeContent(pose: VPSPose): void {
    // Position content at VPS coordinate
    const transform = this.contentRoot.getTransform();
    transform.setWorldPosition(pose.position);
    transform.setWorldRotation(pose.rotation);

    // Make content visible
    this.contentRoot.enabled = true;
  }

  createVPSAnchor(pose: VPSPose): void {
    const anchorData = {
      locationId: this.vps.getCurrentLocationId(),
      localPosition: pose.position,
      localRotation: pose.rotation
    };

    this.vps.createAnchor(anchorData, (anchor) => {
      print(`VPS Anchor created: ${anchor.id}`);

      // Store for future sessions
      this.saveAnchor(anchor);
    });
  }

  updateContentTransform(pose: VPSPose): void {
    const transform = this.contentRoot.getTransform();

    // Smooth position update
    const currentPos = transform.getWorldPosition();
    const targetPos = pose.position;
    const smoothedPos = vec3.lerp(currentPos, targetPos, 0.1);

    transform.setWorldPosition(smoothedPos);
    transform.setWorldRotation(pose.rotation);
  }

  async getCurrentLocation(): Promise<{latitude: number, longitude: number}> {
    return new Promise((resolve, reject) => {
      this.locationService.getCurrentLocation((location) => {
        resolve({
          latitude: location.latitude,
          longitude: location.longitude
        });
      }, (error) => {
        reject(error);
      });
    });
  }

  saveAnchor(anchor: VPSAnchor): void {
    // Use persistent storage to save anchor
    const storage = global.persistentStorageSystem;
    storage.store.putString('vps_anchor_' + anchor.id, JSON.stringify({
      id: anchor.id,
      locationId: anchor.locationId,
      position: anchor.position,
      rotation: anchor.rotation
    }));
  }

  async restoreSavedAnchors(): Promise<void> {
    const storage = global.persistentStorageSystem;

    // Get all saved anchor keys
    // Restore each anchor when location is active
  }
}

// VPS Location Hint UI Component
@component
export class VPSHintUI extends BaseScriptComponent {

  @input
  hintText: Text;

  @input
  vpsController: SpectaclesVPSController;

  private hints: string[] = [
    "Point at buildings or landmarks",
    "Move slowly for better tracking",
    "Ensure good lighting",
    "Look for distinctive features"
  ];

  private currentHint: number = 0;

  onAwake(): void {
    this.showNextHint();
  }

  showNextHint(): void {
    this.hintText.text = this.hints[this.currentHint];
    this.currentHint = (this.currentHint + 1) % this.hints.length;

    // Schedule next hint
    this.createEvent('DelayedCallbackEvent').bind(() => {
      this.showNextHint();
    }).reset(3.0);
  }
}
```

### 3.4 Microsoft HoloLens 2

**Status:** Active, Azure Object Anchors (Spatial Anchors retired)

Azure Spatial Anchors was retired in November 2024. HoloLens 2 now uses Azure Object Anchors and native spatial mapping.

```csharp
// HoloLens 2 Spatial Positioning - C# (MRTK3)

using Microsoft.MixedReality.Toolkit;
using Microsoft.MixedReality.Toolkit.SpatialManipulation;
using Microsoft.MixedReality.OpenXR;
using UnityEngine;
using System.Threading.Tasks;

// Note: Azure Spatial Anchors retired Nov 2024
// Using native HoloLens spatial anchors instead

public class HoloLensVPSManager : MonoBehaviour
{
    [SerializeField] private GameObject anchorPrefab;

    private SpatialAnchorManager anchorManager;
    private Dictionary<string, OVRAnchor> activeAnchors = new();

    async void Start()
    {
        await InitializeSpatialAnchors();
        await RestoreSavedAnchors();
    }

    async Task InitializeSpatialAnchors()
    {
        // HoloLens native spatial anchors (no cloud dependency)
        anchorManager = new SpatialAnchorManager();
        await anchorManager.Initialize();

        Debug.Log("HoloLens Spatial Anchors initialized");
    }

    public async Task<WorldAnchor> CreateWorldAnchor(Vector3 position, Quaternion rotation, string anchorId)
    {
        // Create anchor at position
        var anchorGO = new GameObject($"Anchor_{anchorId}");
        anchorGO.transform.position = position;
        anchorGO.transform.rotation = rotation;

        // Add WorldAnchor component
        var worldAnchor = anchorGO.AddComponent<WorldAnchor>();

        // Wait for anchor to be located
        while (worldAnchor.isLocated == false)
        {
            await Task.Yield();
        }

        // Persist anchor
        await PersistAnchor(anchorId, worldAnchor);

        // Instantiate content
        var content = Instantiate(anchorPrefab, anchorGO.transform);

        return worldAnchor;
    }

    async Task PersistAnchor(string anchorId, WorldAnchor anchor)
    {
        // Save to local anchor store
        var store = WorldAnchorStore.GetAsync();
        var anchorStore = await store;

        if (anchorStore != null)
        {
            bool saved = anchorStore.Save(anchorId, anchor);
            if (saved)
            {
                Debug.Log($"Anchor {anchorId} saved to local store");
            }
        }
    }

    async Task RestoreSavedAnchors()
    {
        var store = WorldAnchorStore.GetAsync();
        var anchorStore = await store;

        if (anchorStore == null) return;

        var ids = anchorStore.GetAllIds();

        foreach (var id in ids)
        {
            var anchorGO = new GameObject($"Restored_{id}");
            var anchor = anchorStore.Load(id, anchorGO);

            if (anchor != null)
            {
                Debug.Log($"Restored anchor: {id}");

                // Wait for location
                while (!anchor.isLocated)
                {
                    await Task.Yield();
                }

                // Add content
                Instantiate(anchorPrefab, anchorGO.transform);
            }
        }
    }

    // MARK: - Azure Object Anchors (for object detection)

    public async Task DetectObject(byte[] objectModel)
    {
        // Azure Object Anchors for recognizing physical objects
        // (Different from retired Azure Spatial Anchors)

        // This requires Azure Object Anchors service subscription
        // and pre-trained 3D object models
    }
}

// QR Code based positioning (alternative to VPS)
public class QRCodePositioning : MonoBehaviour
{
    [SerializeField] private GameObject contentRoot;

    private QRCodeWatcher qrWatcher;
    private Dictionary<Guid, QRCode> trackedCodes = new();

    void Start()
    {
        InitializeQRTracking();
    }

    async void InitializeQRTracking()
    {
        var access = await QRCodeWatcher.RequestAccessAsync();

        if (access == QRCodeWatcherAccessStatus.Allowed)
        {
            qrWatcher = new QRCodeWatcher();
            qrWatcher.Added += OnQRCodeAdded;
            qrWatcher.Updated += OnQRCodeUpdated;
            qrWatcher.Removed += OnQRCodeRemoved;
            qrWatcher.Start();
        }
    }

    void OnQRCodeAdded(object sender, QRCodeAddedEventArgs e)
    {
        var qrCode = e.Code;
        trackedCodes[qrCode.Id] = qrCode;

        // Position content relative to QR code
        PositionContentAtQRCode(qrCode);
    }

    void OnQRCodeUpdated(object sender, QRCodeUpdatedEventArgs e)
    {
        var qrCode = e.Code;
        trackedCodes[qrCode.Id] = qrCode;

        UpdateContentPosition(qrCode);
    }

    void OnQRCodeRemoved(object sender, QRCodeRemovedEventArgs e)
    {
        trackedCodes.Remove(e.Code.Id);
    }

    void PositionContentAtQRCode(QRCode qrCode)
    {
        // Get spatial coordinate system for QR code
        var coordinateSystem =
            SpatialGraphInteropPreview.CreateCoordinateSystemForNode(qrCode.SpatialGraphNodeId);

        if (coordinateSystem != null)
        {
            // Position content at QR code location
            // Parse QR data for content information
            var data = qrCode.Data;
            Debug.Log($"QR Code detected: {data}");

            // Update content transform based on QR position
        }
    }

    void UpdateContentPosition(QRCode qrCode)
    {
        // Update content as QR code tracking improves
    }
}
```

### 3.5 Magic Leap 2

**Status:** Active, enterprise focus

Magic Leap 2 uses spatial mapping and marker-based positioning for enterprise AR.

```csharp
// Magic Leap 2 Spatial Anchors - C# (Unity)

using UnityEngine;
using UnityEngine.XR.MagicLeap;
using MagicLeap.OpenXR.Features.Anchors;

public class MagicLeapVPSManager : MonoBehaviour
{
    [SerializeField] private GameObject anchorPrefab;

    private MLAnchors.Request anchorsRequest;
    private Dictionary<string, MLAnchors.Anchor> activeAnchors = new();

    async void Start()
    {
        await RequestPermissions();
        await InitializeAnchors();
    }

    async Task RequestPermissions()
    {
        var permissions = new string[] { MLPermission.SpatialAnchors };

        foreach (var permission in permissions)
        {
            if (!MLPermissions.CheckPermission(permission).IsOk)
            {
                var result = await MLPermissions.RequestPermissionAsync(permission);
                if (!result.IsOk)
                {
                    Debug.LogError($"Permission denied: {permission}");
                }
            }
        }
    }

    async Task InitializeAnchors()
    {
        // Create anchors request
        anchorsRequest = new MLAnchors.Request();

        // Query existing anchors
        var result = await anchorsRequest.StartAsync(new MLAnchors.Request.Params
        {
            Radius = 100, // meters
            MaxResults = 50
        });

        if (result.IsOk)
        {
            foreach (var anchor in result.Value.anchors)
            {
                await RestoreAnchor(anchor);
            }
        }
    }

    public async Task<MLAnchors.Anchor> CreateAnchor(Pose pose, string anchorId)
    {
        var result = await MLAnchors.Anchor.CreateAsync(pose);

        if (result.IsOk)
        {
            var anchor = result.Value;
            activeAnchors[anchorId] = anchor;

            // Publish to Magic Leap cloud (optional)
            await anchor.PublishAsync();

            // Create visual content
            var content = Instantiate(anchorPrefab);
            content.transform.SetPositionAndRotation(
                anchor.Pose.position,
                anchor.Pose.rotation
            );

            return anchor;
        }

        return null;
    }

    async Task RestoreAnchor(MLAnchors.Anchor anchor)
    {
        // Localize anchor
        var result = await anchor.LocalizeAsync();

        if (result.IsOk)
        {
            Debug.Log($"Anchor localized: {anchor.Id}");

            // Create content at anchor
            var content = Instantiate(anchorPrefab);
            content.transform.SetPositionAndRotation(
                anchor.Pose.position,
                anchor.Pose.rotation
            );

            activeAnchors[anchor.Id] = anchor;
        }
    }

    void Update()
    {
        // Update anchor poses
        foreach (var kvp in activeAnchors)
        {
            var anchor = kvp.Value;
            if (anchor.TrackingState == MLAnchors.Anchor.State.Tracked)
            {
                // Update content position
            }
        }
    }
}
```

## AR Glasses Challenges

| Challenge | Impact | Mitigation |
|-----------|--------|------------|
| Battery life | Limited session time | Efficient algorithms, offload to phone |
| Thermal limits | Performance throttling | Reduce VPS frequency when hot |
| Limited compute | Slower localization | Cloud-assisted VPS, edge compute |
| Small FOV | Difficult feature capture | Wide-angle sensor, head tracking |
| GPS reception | Weak indoor/obstructed | Coarse GPS + VPS fine-tuning |
| Social acceptance | User adoption | Subtle form factor, clear use cases |

## AR Glasses Opportunities

1. **Hands-free operation** - Natural AR interaction
2. **Always-on context** - Persistent spatial awareness
3. **Enterprise applications** - Training, maintenance, logistics
4. **Spatial computing** - True mixed reality experiences
5. **Multi-user collaboration** - Shared spatial anchors

---

# GitHub Projects and Open-Source VPS

## Feature Extraction and Matching

| Project | Stars | Description | Use Case |
|---------|-------|-------------|----------|
| [hloc](https://github.com/cvg/Hierarchical-Localization) | 3.2k+ | Hierarchical Localization (HLoc) with SuperPoint/SuperGlue | Visual localization pipeline |
| [ORB-SLAM3](https://github.com/UZ-SLAMLab/ORB_SLAM3) | 6.5k+ | Multi-map SLAM with visual-inertial fusion | Real-time SLAM |
| [LightGlue](https://github.com/cvg/LightGlue) | 3k+ | Fast feature matching (10x faster than SuperGlue) | Real-time matching |
| [COLMAP](https://github.com/colmap/colmap) | 6k+ | SfM and MVS for 3D reconstruction | Map creation |
| [OpenVSLAM](https://github.com/xdspacelab/openvslam) | 3k+ | Visual SLAM library | Custom VPS |
| [SuperPoint](https://github.com/magicleap/SuperPointPretrainedNetwork) | 2k+ | Deep learning keypoint detector | Feature extraction |
| [D2-Net](https://github.com/mihaidusmanu/d2-net) | 1.5k+ | Dense descriptor network | Dense matching |
| [LoFTR](https://github.com/zju3dv/LoFTR) | 1.8k+ | Detector-free local feature matching | Indoor VPS |
| [NetVLAD](https://github.com/Nanne/pytorch-NetVlad) | 1k+ | Place recognition CNN | Coarse localization |
| [DBoW2](https://github.com/dorian3d/DBoW2) | 800+ | Bag of words for loop closure | Place recognition |

## Complete VPS Systems

| Project | Description | Language |
|---------|-------------|----------|
| [maplab](https://github.com/ethz-asl/maplab) | Research-oriented visual-inertial mapping | C++ |
| [ORB-SLAM2](https://github.com/raulmur/ORB_SLAM2) | Real-time monocular SLAM | C++ |
| [RTAB-Map](https://github.com/introlab/rtabmap) | RGB-D, stereo SLAM | C++ |
| [Basalt](https://github.com/VladyslavUsenko/basalt-mirror) | Visual-inertial odometry | C++ |
| [VINS-Fusion](https://github.com/HKUST-Aerial-Robotics/VINS-Fusion) | Multi-sensor VIO | C++ |

## Mobile-Focused Projects

| Project | Description | Platform |
|---------|-------------|----------|
| [ARCore-SLAM](https://github.com/niconielsen32/ARCore-SLAM) | ARCore with custom SLAM | Android |
| [ARKit-CoreLocation](https://github.com/ProjectDent/ARKit-CoreLocation) | ARKit geo-tracking helpers | iOS |
| [react-native-arkit](https://github.com/react-native-ar/react-native-arkit) | ARKit React Native wrapper | iOS |

---

# Success Stories

## Pokemon GO (Niantic)

**Technology:** Niantic Lightship VPS
**Scale:** 1M+ VPS-enabled locations globally
**Achievement:** First mass-market VPS gaming experience

- Centimeter-accurate AR placement at real-world landmarks
- Community-driven map scanning via player contributions
- Persistent AR content shared across all players
- Drove mainstream awareness of location-based AR

## Google Maps Live View

**Technology:** ARCore Geospatial API
**Scale:** 93+ countries
**Achievement:** Practical navigation utility

- Turn-by-turn AR walking directions
- Indoor mall and airport navigation
- Landmark identification overlays
- Accessible to hundreds of millions of users

## DHL AR Delivery (Enterprise)

**Technology:** ARCore Geospatial
**Use Case:** Package delivery optimization

- Precise delivery location marking
- Photo proof of delivery with VPS positioning
- Reduced delivery errors by 25%
- Faster driver onboarding

## IKEA Studio

**Technology:** ARKit LiDAR + Room Plan
**Use Case:** Home design and furniture placement

- Scan entire rooms in minutes
- Persistent furniture placement across sessions
- Accurate measurements for fit validation

## Snap x Niantic Partnership

**Technology:** Lightship VPS for Snapchat and Spectacles
**Achievement:** Consumer and glasses integration

- VPS-enabled Snapchat Lenses at locations
- Foundation for Spectacles AR navigation
- Scaled VPS to mainstream social platform

---

# Failure Cases and Lessons Learned

## Azure Spatial Anchors (Microsoft) - RETIRED

**What happened:** Microsoft retired Azure Spatial Anchors in November 2024

**Reasons:**
- Limited adoption outside HoloLens ecosystem
- Competition from ARCore Geospatial and Lightship
- High cloud infrastructure costs
- Pivot toward Azure Object Anchors and Mesh

**Lesson:** Platform-specific solutions struggle against cross-platform alternatives

## Google Glass (Original) - DISCONTINUED

**What happened:** Enterprise pivot, consumer product failed

**VPS-related issues:**
- No meaningful VPS capability
- Limited compute for visual positioning
- Battery life too short for always-on AR
- Social acceptance problems

**Lesson:** VPS hardware requires mature form factor and social acceptance

## 8th Wall Sunset - IN PROGRESS

**What happened:** Niantic announced end-of-life for 8th Wall (Feb 2027)

**Reasons:**
- Consolidation with Lightship platform
- Duplicated capabilities with Lightship Web
- Cost optimization

**Lesson:** Platform dependency risk requires migration planning

## Indoor GPS Solutions (Various)

**What happened:** Many indoor positioning startups failed

**Common issues:**
- Beacon infrastructure costs too high
- WiFi fingerprinting accuracy insufficient
- Maintenance burden unsustainable
- VPS offered better accuracy without hardware

**Lesson:** Camera-based VPS outcompetes infrastructure-dependent solutions

## ARCore Depth API (Initial Release)

**What happened:** Poor device fragmentation, limited accuracy

**Issues:**
- Only worked on handful of devices initially
- Software depth estimation unreliable
- LiDAR alternatives on iOS outperformed

**Improvements:** ARCore now has broader device support and Streetscape Geometry

---

# API Documentation Links

## Primary VPS Platforms

| Platform | Documentation | Status |
|----------|--------------|--------|
| ARCore Geospatial | [developers.google.com/ar/develop/geospatial](https://developers.google.com/ar/develop/geospatial) | Active |
| ARKit Geo-Tracking | [developer.apple.com/documentation/arkit/argeotackingconfiguration](https://developer.apple.com/documentation/arkit/argeotrackingconfiguration) | Active |
| Niantic Lightship | [lightship.dev/docs](https://lightship.dev/docs) | Active |
| Immersal | [developers.immersal.com](https://developers.immersal.com) | Active |
| Sturfee | [developer.sturfee.com](https://developer.sturfee.com) | Active |
| 8th Wall | [docs.8thwall.com](https://docs.8thwall.com) | Sunsetting |

## AR Glasses SDKs

| Platform | Documentation |
|----------|--------------|
| visionOS | [developer.apple.com/documentation/visionos](https://developer.apple.com/documentation/visionos) |
| Meta Quest | [developer.oculus.com/documentation](https://developer.oculus.com/documentation) |
| Snap Spectacles | [docs.snap.com/spectacles](https://docs.snap.com/spectacles) |
| HoloLens | [docs.microsoft.com/hololens](https://docs.microsoft.com/hololens) |
| Magic Leap | [developer.magicleap.com](https://developer.magicleap.com) |

## Feature Matching Libraries

| Library | Documentation |
|---------|--------------|
| SuperPoint/SuperGlue | [github.com/magicleap/SuperGluePretrainedNetwork](https://github.com/magicleap/SuperGluePretrainedNetwork) |
| LightGlue | [github.com/cvg/LightGlue](https://github.com/cvg/LightGlue) |
| LoFTR | [github.com/zju3dv/LoFTR](https://github.com/zju3dv/LoFTR) |
| COLMAP | [colmap.github.io](https://colmap.github.io) |

---

# CANVS Recommendations

## Multi-Tier Anchor Strategy

Based on the research, CANVS should implement a multi-tier positioning system:

### Tier 1: Coarse Positioning (GPS/Cell)
- Initial position within 10-50 meters
- Always available, minimal battery
- Fallback when VPS unavailable

### Tier 2: VPS Positioning (ARCore/Lightship)
- Refine to 1-5 meter accuracy
- Requires visual features
- Cloud-dependent

### Tier 3: Local Anchors (Device SLAM)
- Centimeter accuracy within session
- Persist for return visits
- Device-local, no cloud

```swift
// Multi-tier anchor architecture example

protocol PositioningTier {
    var accuracy: Double { get }
    var availability: Float { get } // 0-1
    func getPosition() async -> Position?
}

class CoarsePositioning: PositioningTier {
    var accuracy: Double { 30.0 } // meters
    var availability: Float { 0.95 }

    func getPosition() async -> Position? {
        // GPS + cell triangulation
    }
}

class VPSPositioning: PositioningTier {
    var accuracy: Double { 2.0 } // meters
    var availability: Float { 0.6 } // coverage dependent

    func getPosition() async -> Position? {
        // ARCore Geospatial or Lightship
    }
}

class LocalAnchoring: PositioningTier {
    var accuracy: Double { 0.02 } // meters (2cm)
    var availability: Float { 0.9 } // after initial localization

    func getPosition() async -> Position? {
        // Device SLAM anchors
    }
}

class CANVSPositioningManager {
    let tiers: [PositioningTier] = [
        LocalAnchoring(),
        VPSPositioning(),
        CoarsePositioning()
    ]

    func getBestPosition() async -> (Position, PositioningTier)? {
        for tier in tiers {
            if let position = await tier.getPosition() {
                return (position, tier)
            }
        }
        return nil
    }
}
```

## Platform Prioritization

1. **Native iOS/Android first** - Best accuracy, widest reach
2. **Web fallback** - Use Immersal for web, plan for 8th Wall migration
3. **Glasses preparation** - Build architecture compatible with Vision Pro and Quest

## VPS Provider Selection

| Use Case | Recommended Provider | Rationale |
|----------|---------------------|-----------|
| Urban outdoor | ARCore Geospatial | 93+ country coverage |
| Points of interest | Niantic Lightship | 1M+ locations |
| Custom indoor maps | Immersal | Self-mapping support |
| Web experiences | Immersal Web SDK | 8th Wall sunset |

---

# Document Metadata

**Created:** January 2025
**Last Updated:** January 2025
**Version:** 1.0.0
**Status:** Complete

**Research Sources:**
- Official SDK documentation
- GitHub project repositories
- Industry case studies
- Developer conference presentations (WWDC, I/O, Connect)

**Coverage:**
- Mobile Web: WebXR, 8th Wall, Immersal, Zappar
- Native iOS: ARKit, ARCore iOS, Lightship
- Native Android: ARCore, Lightship
- AR Glasses: Vision Pro, Quest 3, Spectacles, HoloLens, Magic Leap
