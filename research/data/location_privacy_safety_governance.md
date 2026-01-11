# Location Privacy, Safety, and Governance Research for CANVS

## Executive Summary

This research document provides comprehensive analysis of privacy regulations, safety concerns, best practices, and technical measures for AR/location-based social platforms. The findings are specifically applicable to CANVS as a persistent, location-anchored social layer.

**Key Takeaways:**
- Location data is classified as **sensitive personal information** under GDPR, CCPA, and COPPA
- Historical incidents from Pokemon GO, Randonautica demonstrate serious stalking, harassment, and trespassing risks
- Privacy-by-default and location obfuscation are industry best practices
- 2025 sees increased regulatory scrutiny with California AG's location data investigative sweep
- Children's protections significantly strengthened with April 2025 COPPA amendments

---

## 1. Privacy Regulations

### 1.1 GDPR (European Union)

**Key Requirements:**
- Geolocation data is considered **personal data** that can identify an individual
- **Consent must be**: freely given, specific, informed, and unambiguous
- OS-level permissions (iOS/Android) do **not** automatically meet GDPR standards
- Must assess if precise location is necessary (data minimization)
- Requires encryption both in transit (TLS 1.3) and at rest (AES-256)
- Must conduct Data Protection Impact Assessments (DPIAs) for high-risk tracking

**Fines:**
- Up to EUR 20 million or 4% of global annual revenue (whichever is higher)

**Common Mistakes to Avoid:**
- Collecting GPS data before asking permission
- Pre-ticked consent boxes
- Bundling location permissions with other features
- Hiding consent in terms and conditions

**Sources:**
- [Essential guide to mobile app compliance 2025](https://www.didomi.io/blog/mobile-app-compliance-2025)
- [GDPR Location Data](https://www.geoplugin.com/resources/gdpr-location-data-how-to-collect-it-legally-and-avoid-fine/)
- [GDPR Compliance for Apps: 2025 Guide](https://gdprlocal.com/gdpr-compliance-for-apps/)

### 1.2 CCPA/CPRA (California)

**Current Requirements:**
- "Precise geolocation" = location within 1,850-foot radius
- Classified as **sensitive personal information** with additional protections
- Must provide notice when collecting location data
- Consumers have rights to access, delete, or opt out of sale
- Do Not Sell or Share My Personal Information link required

**2025 Enforcement Activity:**
- March 10, 2025: California AG announced investigative sweep targeting location data industry
- Focus on mobile apps collecting/sharing location with third parties
- Apps must provide opt-out through in-app settings (not just website)

**2025 Thresholds:**
- Annual gross revenue > $26,625,000 (adjusted for CPI)
- Processing 100,000+ California residents' data annually
- 50%+ revenue from selling/sharing personal information

**Proposed California Location Privacy Act (AB 1355):**
- Would require opt-in consent before collecting location data
- 20 business days advance notice of privacy policy changes
- "Location data" = street-level location within 5 miles or less
- Bill failed in 2025 but signals regulatory direction

**Sources:**
- [California Proposes CCPA Update on Location Data Rules](https://www.cyberadviserblog.com/2025/03/california-proposes-ccpa-update-on-location-data-rules/)
- [California AG Location Data Investigative Sweep](https://www.clarkhill.com/news-events/news/california-attorney-general-announces-investigative-sweep-while-legislative-proposal-takes-direct-aim-at-business-use-of-location-data/)
- [CCPA Privacy Policy Requirements 2025](https://secureprivacy.ai/blog/ccpa-privacy-policy-requirements-2025)

### 1.3 Apple Platform Policies

**Privacy Policy Requirements:**
- Must include link in App Store Connect metadata AND within app
- Must clearly identify what data is collected, how, and all uses
- Must confirm third parties provide equal protection
- Must explain retention/deletion policies
- Must describe how to revoke consent and request deletion

**Location Data Specifics:**
- Must declare data types based on IP address use
- Data processed only on-device is not "collected" for disclosure
- App Tracking Transparency (ATT) required for cross-app tracking since iOS 14.5

**2025 Updates:**
- New age rating categories (13+, 16+, 18+)
- Must update ratings by January 31, 2026
- November 2025: New guidelines require disclosure of data sharing with third-party AI
- Privacy nutrition labels actively verified against actual app behavior

**Sources:**
- [App Privacy Details - Apple Developer](https://developer.apple.com/app-store/app-privacy-details/)
- [User Privacy and Data Use - Apple Developer](https://developer.apple.com/app-store/user-privacy-and-data-use/)
- [Apple's App Review Guidelines on Third-Party AI](https://techcrunch.com/2025/11/13/apples-new-app-review-guidelines-clamp-down-on-apps-sharing-personal-data-with-third-party-ai/)

### 1.4 Google Play Policies

**Data Safety Requirements:**
- Must complete Data safety form even if no data collection
- Must disclose all data types collected (location, personal info, etc.)
- Must disclose purposes (app functionality, analytics, advertising, etc.)
- Third-party SDK data collection is developer's responsibility
- Privacy policy must be accessible, non-editable, refer to app by name

**Background Location:**
- Must provide clear description of feature requiring background location
- Never request location solely for advertising or analytics
- Only one feature can be declared for background access

**2025 Updates:**
- November 2025: Age Signals API data may only be used for age-appropriate experiences
- Permissions must be necessary for core functionalities

**Sources:**
- [Background Location Permissions - Google Play](https://support.google.com/googleplay/android-developer/answer/9799150)
- [Provide Information for Data Safety - Google Play](https://support.google.com/googleplay/android-developer/answer/10787469)

### 1.5 COPPA (Children's Privacy)

**April 2025 Amendments (Effective June 21, 2025):**
- Expanded definitions of "personal information" and "online contact information"
- New standards for "mixed audience" services
- Enhanced parental notice and consent requirements
- Stricter data retention and security obligations
- Compliance deadline: April 22, 2026

**Location Data Coverage:**
- COPPA applies to longitude/latitude collection from children
- Wireless network identifiers used to infer location are covered
- Precise geolocation creates COPPA exposure with child-directed services

**Recent Enforcement:**
- September 3, 2025: FTC action against Apitor Technology for collecting children's geolocation without parental consent through their robot toy app

**Key Requirements:**
- Verifiable parental consent BEFORE collecting location
- Written information security program appropriate to data sensitivity
- Cannot retain personal information indefinitely
- Must have clear data retention policies

**Sources:**
- [Children's Online Privacy in 2025: Amended COPPA Rule](https://www.loeb.com/en/insights/publications/2025/05/childrens-online-privacy-in-2025-the-amended-coppa-rule)
- [FTC COPPA Rule Amendments 2025](https://www.kirkland.com/publications/kirkland-alert/2025/04/ftc-publishes-coppa-rule)
- [COPPA Compliance 2025 Guide](https://blog.promise.legal/startup-central/coppa-compliance-in-2025-a-practical-guide-for-tech-edtech-and-kids-apps/)

---

## 2. Safety Concerns in Location-Based Apps

### 2.1 Pokemon GO Incidents and Research

**Academic Research Findings:**
- 2023 study established cyber-enabled stalking as main risk event
- In-game features (like postcard sharing) can be exploited by malicious users
- Routine locations (home, work) can be re-identified within days from gift exchanges
- Enables physical stalking of previously unknown persons

**Documented Harassment Cases:**
- Players stalked and followed in cars to their homes
- Aggressive behavior and threats at gym locations
- Families with children targeted by aggressive players
- At least one sexual assault at a game location
- Inappropriate contact with children at Pokestops

**Armed Robberies:**
- O'Fallon, Missouri: 4 men robbed 10-11 players at PokéStops
- Criminals exploited players not paying attention to surroundings

**Intimate Partner Violence:**
- Location data could reveal victim's daily habits
- Could expose safehouse locations
- Creates risk for stalking victims

**Niantic's Response Criticized:**
- Customer service refuses to disclose actions taken to protect victims
- Cites "obligations to the privacy of the stalker"
- No practical assistance once stalking has begun

**Sources:**
- [Criminal Offenses Facilitated through Pokemon GO](https://arxiv.org/abs/2304.02952)
- [Niantic Evades Handling Stalking](https://massivelyop.com/2021/12/27/massively-on-the-go-how-niantic-evades-handling-stalking-and-harassment-in-pokemon-go-and-other-args/)
- [Pokemon GO Gym Harassment Stories](https://www.dexerto.com/pokemon/pokemon-go-players-reveal-frightening-stories-of-harassment-at-gyms-1960785/)

### 2.2 Randonautica Incidents

**Trespassing Issues:**
- Random locations often include private property
- Testing found suggestions like: middle of lakes, backyards, farms, construction zones
- YouTubers sent to abandoned buildings, police called for trespassing
- Users sometimes ignore safety measures and trespass anyway

**Major Incident:**
- West Seattle beach: Users found bag with two dead bodies
- Led to arrest of landlord Michael Lee Dudley for murder

**Safety Guidelines from Randonautica:**
- Never go near train tracks, railways, restricted zones
- Avoid old structures and buildings (structural integrity concerns)
- Use during daylight only
- Look at point on Google Maps before going
- Don't have to go to precise point

**Other Concerns:**
- Users creating conspiracy theories (fake child-trafficking investigations)
- Dangerously obsessive behavior by some users

**Sources:**
- [Randonautica App Guide](https://www.smartsocial.com/post/randonautica-app)
- [Be a Responsible Randonaut](https://www.randonautica.app/be-a-responsible-randonaut)
- [Randonautica - Wikipedia](https://en.wikipedia.org/wiki/Randonautica)

### 2.3 Niantic Safety Measures (2024-2025)

**Anti-Cheating Detection:**
- Advanced algorithms analyze player location data
- Detects suspicious movements (impossible speed)
- June 2024: Strengthened spoofer detection
- Three-strike policy: Warning, 30-day ban, permanent ban

**Location Data Collection:**
- Uses GPS, WiFi, cell tower triangulation
- iOS provides better control (closed system)

**2025 Ownership Change:**
- Niantic selling Pokemon GO to Scopely
- Concerns about fate of location data from millions of players
- Users have logged 30+ billion miles of exploration

**Sources:**
- [Niantic Spatial Privacy Policy](https://www.nianticspatial.com/en/privacy)
- [Pokemon GO Dev Sells Games to Scopely](https://www.animationmagazine.net/2025/03/pokemon-go-dev-niantic-sells-games-to-scopely-raising-questions-about-location-data/)

---

## 3. Best Practices

### 3.1 Location Obfuscation Techniques

**Basic Obfuscation Operators:**
1. Enlarging the radius
2. Shifting the center
3. Reducing the radius
4. Combination approaches

**Precision Levels (Recommended):**
| Use Case | Precision | Approximate Distance |
|----------|-----------|---------------------|
| Storage/Anchoring | 6 decimals | ~10cm |
| Display to Others | 4 decimals | ~10m |
| Data Export | 2 decimals | ~1km |
| Aggregated Data | H3 Resolution 6 | ~3km hexagons |

**Advanced Approaches:**
- Deep-Q networks for predicting user privacy behavior
- Synthetic location trajectories for untrusted apps
- Relevance-based metrics tied to social intimacy level
- Context-aware obfuscation (app category, user frequency)

**Sources:**
- [Location Privacy Through Obfuscation](https://link.springer.com/chapter/10.1007/978-3-540-73538-0_4)
- [Mitigating Location Privacy Attacks](https://petsymposium.org/popets/2019/popets-2019-0020.pdf)

### 3.2 Private-by-Default Approaches

**Industry Standards:**
- Location sharing typically OFF by default
- Only share with trusted friends/family
- Ghost Mode/invisibility options
- Time-limited sharing (auto-expire)

**Snapchat Snap Map Best Practices:**
- Location sharing OFF by default
- Ghost Mode for invisibility
- Choose who sees: all friends, select friends, or no one
- Regular reminders to check location sharing settings
- "Only while using" vs "Always" location options

**Recommended Default Settings:**
| Setting | Default | User Can Change |
|---------|---------|-----------------|
| Share exact location | No | No |
| Share approximate location | No | Yes (opt-in) |
| Location in feed/timeline | Off | Yes |
| Background location | Never | Yes (friends/family only) |
| Location history retention | Minimal (7-30 days) | Yes (can delete) |

**Sources:**
- [Snap Map Privacy & Safety](https://help.snapchat.com/hc/en-us/articles/24547077410580-Snap-Map-Privacy-Safety-Reminder)
- [How Do Default Privacy Settings Match Preferences](https://www.researchgate.net/publication/366028959_How_do_default_privacy_settings_on_social_media_apps_match_people's_actual_preferences)

### 3.3 Geofencing Sensitive Locations

**Locations to Consider:**
- Schools (restrict during hours)
- Hospitals and healthcare facilities
- Places of worship
- Political gathering locations
- Government buildings
- Private residences

**Implementation Approaches:**
- Automatic content restrictions in sensitive zones
- Speed limit triggers near schools
- No location-based advertising near healthcare facilities
- Exclude residential addresses from public content

**Legal Considerations:**
- Massachusetts, Washington proposing bills to restrict geofencing near hospitals, clinics, schools
- Privacy concerns around surveillance
- Balance between safety and functionality

**Sources:**
- [Geofences Around Schools](https://safeschoolroutes.com/geofences-around-schools-a-smart-step-towards-safer-and-cleaner-school-environments/)
- [Geofencing Privacy Violations](https://thelyonfirm.com/blog/geofencing-privacy-location-tracking-lawsuits/)

### 3.4 Age Verification (2025-2026)

**U.S. State Laws Taking Effect:**
| State | Effective Date |
|-------|----------------|
| Texas | Jan 1, 2026 |
| Utah | May 7, 2026 |
| Louisiana | July 1, 2026 |
| California | Jan 1, 2027 |

**Age Categories Required:**
- Child (under 13)
- Young teenager (13-16)
- Older teenager (16-18)
- Adult (18+)

**Implementation:**
- Apple/Google handle verification at app store level
- Developers receive age verification data via APIs
- Gate content, disable purchases, manage consent based on age
- Texas requires age ratings for in-app purchases

**Privacy-Preserving Methods:**
- Zero-knowledge proofs (euCONSENT AgeAware App - April 2025)
- Phone-centric identity verification
- Tokenized communication with authoritative data sources
- No sensitive document uploads required

**Sources:**
- [App Store Age Verification Laws](https://www.privacyworld.blog/2025/10/app-store-age-verification-laws-your-questions-answered/)
- [Age Verification APIs for Apps](https://appbot.co/blog/age-verification-apis-for-apps-google-apple/)
- [Privacy-Preserving Age Verification](https://www.newamerica.org/oti/briefs/exploring-privacy-preserving-age-verification/)

---

## 4. Technical Safety Measures

### 4.1 Shadow Banning Approaches

**Types of Shadow Bans:**
1. **Ghost ban**: Most restrictive, content completely obfuscated
2. **Search ban**: Content excluded from search results
3. **Search suggestion ban**: Account not suggested
4. **Downtiering**: Reduced algorithmic visibility

**Implementation Purposes:**
- Reduce spam and fake account impact
- Prevent manipulation of algorithms
- Avoid direct confrontation with violators
- Allow investigation without alerting bad actors

**Detection Methods (What to Avoid Triggering):**
- Sudden engagement drops
- Disappearance from search results
- Content invisible to others
- Third-party tools can detect (shadowban.eu, Triberr)

**Best Practices:**
- Combine with human moderator review
- Include appeal process
- Document reasoning internally
- Don't use for legitimate speech suppression

**Sources:**
- [Platform Visibility and Content Moderation](https://medium.com/@adnanmasood/platform-visibility-and-content-moderation-algorithms-shadow-bans-governance-3e50ab628d87)
- [Shadowbanning Research](https://link.springer.com/article/10.1007/s12599-024-00905-3)

### 4.2 Anti-Stalking Detection Algorithms

**Key Detection Features:**
- Background and manual scanning for unknown trackers
- Bluetooth distance/direction indicators
- Sound emission for physical location

**Detection Algorithm Approaches:**
- Clustered locations with 150m radius
- Two locations + 30 minutes minimum at high sensitivity
- Static MAC address + changing location + high signal = suspicious
- Reduce false positives from neighbor devices

**Apple/Google Collaboration (2025):**
- iOS 17.5 + Android 6.0+ anti-stalking feature
- Alerts for AirTags and similar tracking devices
- Universal system across both platforms
- Proactive notifications for non-Apple trackers

**Notification Times (by Device):**
| Tracker | Median Notification Delay |
|---------|--------------------------|
| Samsung SmartTag | 70 minutes |
| AirTag | ~480 minutes |
| Tile | 4,413 minutes (3+ days) |

**Limitations:**
- Cannot differentiate "good" vs "bad" tracking
- Not all features work on all phones for all trackers
- Some features not enabled by default

**Sources:**
- [Evaluating Anti-Stalking Features](https://arxiv.org/html/2312.05157v1)
- [iOS 17.5 Anti-Stalking Features](https://www.techsafety.org/blog/2024/4/19/enhanced-security-the-new-anti-stalking-features-of-ios-175)

### 4.3 Content Moderation at Scale

**AR/VR Specific Challenges:**
- Real-time content without lasting records
- Physical space + virtual augmentation collision
- Geofencing for acceptable physical spaces
- Monitoring for defamatory additions to buildings/spaces
- Resolution differences affect content interpretation

**Recommended Thresholds (Based on CANVS SRS):**
| Category | Threshold | Action |
|----------|-----------|--------|
| Hate speech | 0.3 | Auto-block |
| Violence | 0.4 | Auto-block |
| Sexual content | 0.3 | Auto-block |
| Self-harm | 0.2 | Auto-block + alert |
| Harassment | 0.5 | Queue for review |
| Spam | 0.7 | Queue for review |

**Technical Approaches:**
- Machine learning for proactive detection
- User reporting systems
- Queues for human review
- Appeal mechanisms
- Mix of automation and human review

**Sources:**
- [Content Moderation in XR](https://www.law.kuleuven.be/ai-summer-school/blogpost/Blogposts/Content-Moderation-in-Extended-Realities)
- [Content Moderation for AR/VR](https://itif.org/publications/2022/02/28/content-moderation-multi-user-immersive-experiences-arvr-and-future-online/)

### 4.4 Reporting and Takedown Systems

**Legal Requirements:**
- CSAM laws: detect, remove, report illegal material
- Digital Services Act: transparency, victim protections, up to 6% revenue fines
- Safe Harbor requires repeat infringer policy

**Best Practices Framework:**
1. Proactively detect violative content
2. Allow user reporting
3. Manage incoming reports
4. Queue for human decision-making
5. Implement enforcement actions
6. Deter bad actors

**Team Components:**
- Legal advisors for regulatory compliance
- Data scientists for pattern detection
- Human moderators for nuanced decisions
- Automated systems for scale

**Response Times:**
- CSAM: Immediate removal, law enforcement reporting
- Imminent harm: < 1 hour
- Standard violations: < 24 hours
- Appeals: < 7 days

**Sources:**
- [Trust and Safety 101](https://getstream.io/blog/trust-safety/)
- [Digital Trust & Safety Partnership Best Practices](https://dtspartnership.org/best-practices/)
- [Notice-And-Takedown Systems](https://infringio.com/notice-and-takedown-systems-legal-requirements-best-practices)

---

## 5. Industry Guidelines

### 5.1 XR Safety Initiative (XRSI)

**Organization Overview:**
- 501(c)(3) global non-profit Standards Developing Organization
- Founded 2018 by Kavya Pearlman
- Headquarters: San Francisco Bay Area and Torino, Italy
- Focus: privacy, safety, security, and ethics in immersive tech

**The XRSI Privacy & Safety Framework:**
- Free, globally accessible baseline rulebook
- Regulation-agnostic (GDPR, NIST, FERPA, COPPA compatible)
- Layered structure with focus areas, subcategories, and controls
- Designed to adapt to new regulations

**Key Focus Areas:**
- Safety
- Privacy
- Security
- Inclusion
- Human rights
- Responsible innovation

**2025 Developments:**
- AWE USA 2025: Launch of Responsible Data Governance (RDG) 2025v1
- Australia adopted XRSI standards for government positioning

**Child Safety Guidelines:**
- Top 7 Safety Tips for parents
- Recognition that children are at specific risk
- Adults responsible for guiding safe VR relationships

**Sources:**
- [XRSI Privacy & Safety Framework](https://xrsi.org/definition/the-xrsi-privacy-framework)
- [XRSI Research & Standards](https://xrsi.org/research-standards)
- [NIST Extended Reality Standards](https://www.nist.gov/information-technology/extended-reality)

### 5.2 Platform-Specific Guidelines

**Life360 Safety Features:**
- SOS Alerts with precise location
- Crash Detection
- 24/7 Roadside Assistance
- Stolen Phone Protection
- ID Theft Protection
- Family "Circles" for group management

**Snapchat Safety Model:**
- Ghost Mode by default recommendation
- Regular privacy setting reminders
- Family Center parental controls (November 2024)
- Parents can request/share live locations with teens
- Set alerts for specific locations

**Sources:**
- [Life360 App](https://www.life360.com/life360-vs-zenly)
- [Snapchat Safety Steps](https://help.snapchat.com/hc/en-us/articles/7012304746644-What-steps-can-I-take-to-help-protect-my-security-and-safety-on-Snapchat)

---

## 6. CANVS-Specific Recommendations

### 6.1 Regulatory Compliance Checklist

**GDPR:**
- [ ] Explicit opt-in consent before location collection
- [ ] Clear, specific privacy notice at point of collection
- [ ] Data minimization assessment (do we need precise location?)
- [ ] Encryption at rest (AES-256) and in transit (TLS 1.3)
- [ ] DPIA for location tracking
- [ ] Data subject rights implementation (access, deletion, portability)

**CCPA:**
- [ ] Privacy notice identifying location data collection
- [ ] Do Not Sell or Share link in app settings
- [ ] Consumer access, deletion, opt-out rights
- [ ] Update thresholds monitoring (revenue, user count)

**Apple/Google:**
- [ ] Privacy policy in App Store/Play Console AND in-app
- [ ] Data safety form completion
- [ ] App Tracking Transparency integration (if needed)
- [ ] Age rating updated by January 31, 2026
- [ ] Third-party AI data sharing disclosure

**COPPA:**
- [ ] Age gate implementation (13+ minimum)
- [ ] Verifiable parental consent for under-13
- [ ] Written information security program
- [ ] Data retention policy (no indefinite retention)
- [ ] Mixed audience service standards

### 6.2 Safety Feature Recommendations

**Location Privacy:**
1. **Default to Private**: Location sharing OFF by default
2. **Tiered Precision**:
   - Storage: 6 decimal places (~10cm for AR anchoring)
   - Display to others: 4 decimal places (~10m)
   - Export: 2 decimal places (~1km)
3. **Ghost Mode**: Allow users to browse without showing location
4. **Auto-Expire**: Time-limited location sharing options

**Anti-Stalking:**
1. Detect impossible movement (speed > 300 m/s)
2. IP geolocation sanity checks (>500km discrepancy flagged)
3. Pattern detection for repeated viewing of same user's content
4. Block/report functionality with immediate effect
5. Don't disclose reporter identity to reported user

**Geofencing:**
1. Exclude schools during school hours
2. Restrict content creation at hospitals/clinics
3. Flag residential addresses for creator warning
4. Auto-moderate content near sensitive government facilities

**Content Moderation:**
1. AI pre-screening with human review queue
2. Self-harm content: auto-block + crisis resources
3. Location-specific content review (is this place appropriate?)
4. Appeal process with clear timeline
5. Transparency report on moderation actions

### 6.3 Age-Appropriate Design

**Under 13:**
- Block entirely OR require verifiable parental consent
- No precise location storage
- No social features without parent approval

**13-16:**
- Default to most restrictive privacy settings
- Parental notification option for account creation
- Content filtered for age-appropriateness
- No background location tracking

**16-18:**
- Standard privacy defaults
- Enhanced safety reminders
- Opt-in for social features

**18+:**
- Full feature access
- Clear consent for data processing
- Regular privacy setting reminders

### 6.4 Technical Implementation Priorities

**Phase 1 (MVP):**
1. Location precision reduction (already in SRS)
2. Basic consent flow before location access
3. Content moderation with AI + manual review
4. User blocking and reporting
5. Data export capability

**Phase 2:**
1. Ghost Mode / private browsing
2. Geofencing sensitive locations
3. Anti-stalking pattern detection
4. Parental controls integration
5. Enhanced age verification (state law compliance)

**Phase 3:**
1. Advanced obfuscation techniques
2. Real-time safety alerts
3. Third-party safety audit
4. XRSI framework certification

---

## 7. Risk Matrix

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Stalking via location data | Medium | Critical | Obfuscation, Ghost Mode, anti-pattern detection |
| Regulatory fine (GDPR/CCPA) | Medium | High | Compliance checklist, legal review |
| Child safety incident | Low | Critical | COPPA compliance, age gates, parental controls |
| Trespassing incidents | Medium | Medium | Warning screens, private property flags |
| Harassment at locations | Medium | High | Reporting system, moderation, user blocking |
| Data breach exposing locations | Low | Critical | Encryption, minimal retention, access controls |
| Platform rejection (Apple/Google) | Low | High | Policy compliance, privacy disclosure |

---

## 8. Sources Summary

### Regulations
- [GDPR Mobile App Compliance](https://www.didomi.io/blog/mobile-app-compliance-2025)
- [CCPA Location Data Rules 2025](https://www.cyberadviserblog.com/2025/03/california-proposes-ccpa-update-on-location-data-rules/)
- [Apple Developer Privacy](https://developer.apple.com/app-store/user-privacy-and-data-use/)
- [Google Play Data Safety](https://support.google.com/googleplay/android-developer/answer/10787469)
- [COPPA 2025 Amendments](https://www.loeb.com/en/insights/publications/2025/05/childrens-online-privacy-in-2025-the-amended-coppa-rule)

### Safety Research
- [Pokemon GO Criminal Offenses Study](https://arxiv.org/abs/2304.02952)
- [Randonautica Safety](https://www.smartsocial.com/post/randonautica-app)
- [XR Safety Initiative](https://xrsi.org/)

### Technical Best Practices
- [Location Obfuscation Techniques](https://link.springer.com/chapter/10.1007/978-3-540-73538-0_4)
- [Anti-Stalking Detection](https://arxiv.org/html/2312.05157v1)
- [Content Moderation in XR](https://itif.org/publications/2022/02/28/content-moderation-multi-user-immersive-experiences-arvr-and-future-online/)
- [Trust & Safety Best Practices](https://dtspartnership.org/best-practices/)

### Platform Guidelines
- [Snapchat Safety](https://help.snapchat.com/hc/en-us/articles/7012304746644)
- [Life360 Features](https://www.life360.com/)
- [Age Verification APIs](https://appbot.co/blog/age-verification-apis-for-apps-google-apple/)

---

*Research conducted: January 11, 2026*
*Last updated: January 11, 2026*
