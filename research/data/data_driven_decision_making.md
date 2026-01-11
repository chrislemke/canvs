# Data-Driven Decision Making Framework for CANVS

> "Decide on metrics, not feelings."

This document provides actionable frameworks for building a data-driven culture at CANVS, from day one through scale.

---

## Table of Contents

1. [Building a Data-Driven Culture](#1-building-a-data-driven-culture)
2. [Key Decision Frameworks](#2-key-decision-frameworks)
3. [Experimentation Framework](#3-experimentation-framework)
4. [Data-Driven Product Development](#4-data-driven-product-development)
5. [Organizational Practices](#5-organizational-practices)
6. [Tools for Data-Driven Teams](#6-tools-for-data-driven-teams)
7. [From Day One Implementation](#7-from-day-one-implementation)
8. [CANVS-Specific Considerations](#8-canvs-specific-considerations)

---

## 1. Building a Data-Driven Culture

### 1.1 Metrics-First Decision Making

**Core Principle**: Base decisions on facts supported by data rather than assumptions. Using facts reduces chances of failure and increases likelihood of success.

**Why It Matters**:
- Companies using data for decision-making are **23x more likely to outperform competitors**
- **19x more likely** to see above-average profitability
- McKinsey Global Institute research confirms these findings

**Implementation Steps**:

1. **Define Clear Questions First**
   - What decision needs to be made?
   - What data would change the decision?
   - What threshold triggers action?

2. **Establish Data Quality Standards**
   - Implement data validation rules
   - Regular data audits
   - Single source of truth for each metric

3. **Create Decision Documentation**
   - Record what data informed each major decision
   - Track outcomes against predictions
   - Build institutional learning

### 1.2 Data Democratization

**Definition**: Making data accessible to everyone, regardless of technical abilities. Every team member can get data they need, when needed, without asking for help.

**Benefits**:
- +10% revenue growth
- +40% improvement in time to market
- +35% increase in new customer acquisition

**Implementation**:

```
Level 1 (Week 1-4):    Everyone can view key dashboards
Level 2 (Month 2-3):   Team leads can create custom reports
Level 3 (Month 4-6):   Anyone can query data with guidance
Level 4 (Month 7+):    Self-service analytics culture
```

**Keys to Success**:
- Invest in data literacy training
- Present data in clear, understandable formats
- Balance accessibility with governance
- Start with one "source of truth" for metrics

### 1.3 Hypothesis-Driven Development

**Framework**: Treat product development as a series of experiments to determine whether expected outcomes will be achieved.

**Hypothesis Format**:
```
We believe that [capability/change]
Will result in [expected outcome]
We will know we have succeeded when [measurable signal]
```

**Example for CANVS**:
```
We believe that showing AR content previews in map view
Will result in increased content discovery
We will know we have succeeded when we see a 15% increase
in users who view previews then navigate to the location
```

**Process**:
1. Generate hypothesis based on user research or data
2. Define expected outcomes and success metrics
3. Design lightweight test (MVP approach)
4. Run test and measure results
5. Learn: proceed, adjust, or discard

**Best Practice**: Test each hypothesis on at least 5 users before broader rollout.

### 1.4 Balancing Intuition with Data

**Framework**: "Strong opinions, loosely held"

| Intuition Appropriate | Data Required |
|-----------------------|---------------|
| Early problem identification | Feature prioritization |
| User empathy insights | Resource allocation |
| Creative solutions | Performance optimization |
| "Something feels off" signals | Strategic pivots |
| Initial hypothesis formation | Validation of assumptions |

**Practical Guidelines**:
- Use intuition to generate hypotheses
- Use data to validate or invalidate them
- Never ignore data that contradicts intuition without investigation
- Document when intuition overrides data (and track outcomes)

---

## 2. Key Decision Frameworks

### 2.1 North Star Metric Framework

**Definition**: A single, company-wide metric that aligns the entire organization and clearly measures customer value delivery.

**Selection Criteria**:
- Indicates user experienced core product value
- Reflects user engagement and activity level
- The "one thing" showing business is heading right direction
- Easy to understand and communicate across teams

**The Key Question**: "Which metric, if it were to increase today, would most accelerate our business flywheel?"

**CANVS North Star Candidates**:

| Metric | Rationale | Pros | Cons |
|--------|-----------|------|------|
| **Moments Per Interaction (MPI)** | Core value = magical AR moments | Directly measures value delivery | Harder to track initially |
| Weekly Active Creators | Creation drives content ecosystem | Easy to measure | Doesn't capture consumer value |
| AR Content Views | Consumption drives engagement | Simple metric | May incentivize quantity over quality |
| Locations with Active Content | Geographic coverage | Shows growth | Doesn't measure engagement depth |

**Recommended**: MPI (Moments Per Interaction) as North Star

**Supporting Input Metrics**:
- New AR content created per week
- Creator retention (creators active 2+ weeks)
- Content discovery rate (content viewed / content available in area)
- Average session duration at AR locations

### 2.2 Input Metrics vs. Output Metrics

**Input Metrics** (Leading): Things within team control, impactable within days
**Output Metrics** (Lagging): Results that follow from inputs

```
CANVS Metric Chain:

INPUTS (Weekly Focus)          OUTPUTS (Monthly/Quarterly Review)
-------------------          ---------------------------------
- Content created            - MAU growth
- Creator onboarding rate    - Revenue
- Feature adoption           - Retention rate
- App sessions               - NPS score
- Support response time      - Creator lifetime value
```

**Stage-Based Focus**:
- **Early stage**: Mostly leading (activation, signups, onboarding)
- **Mid stage**: Mix of both (pipeline, conversions, CAC, LTV)
- **Growth stage**: Mostly lagging + efficiency (ARR, NRR, burn multiple)

### 2.3 Leading vs. Lagging Indicators

**Leading Indicators** (Predictive):
- Session duration and frequency
- Feature adoption rates
- User activation milestones
- Content creation velocity

**Lagging Indicators** (Historical):
- Revenue (MRR/ARR)
- Customer churn rate
- Net Promoter Score
- Sales cycle length

**Power Pairing Strategy**: Always pair a leading indicator with its corresponding lagging outcome.

| Leading Indicator | Lagging Indicator | Why Paired |
|-------------------|-------------------|------------|
| Weekly active creators | Monthly creator retention | Activity predicts retention |
| Content views per session | 30-day user retention | Engagement predicts stickiness |
| Onboarding completion rate | First-week activation | Good start predicts success |
| Support tickets resolved <24h | Customer satisfaction score | Fast support drives satisfaction |

### 2.4 Pirate Metrics (AARRR Framework)

**The Five Stages**:

```
ACQUISITION  -> How do users discover CANVS?
     |
ACTIVATION   -> Do they experience the "aha moment"?
     |
RETENTION    -> Do they keep coming back?
     |
REFERRAL     -> Do they tell others?
     |
REVENUE      -> Do they pay?
```

**CANVS AARRR Implementation**:

| Stage | Primary Metric | Secondary Metrics |
|-------|----------------|-------------------|
| **Acquisition** | App downloads | Source attribution, Install rate by channel |
| **Activation** | First AR content viewed | Onboarding completion, Time to first moment |
| **Retention** | D7 retention | D1, D14, D30 retention curves |
| **Referral** | Viral coefficient | Shares per user, Invite conversion rate |
| **Revenue** | ARPU | Conversion to premium, LTV |

**RARRA Variant (Mobile-First)**:

For CANVS, consider **RARRA** ordering (prioritize retention):
1. **Retention** - Create product people return to
2. **Activation** - Deliver "aha moment" fast
3. **Referral** - Enable easy sharing
4. **Revenue** - Monetize engaged users
5. **Acquisition** - Scale only after above work

**Key Insight**: It costs 5-25x more to acquire new customers than retain existing ones. A 5% retention increase can boost profits by 25-95%.

### 2.5 OKRs with Data

**Structure**:
- **Objectives**: Qualitative, inspirational, challenging
- **Key Results**: Quantitative, measurable, 2-5 per objective

**Grading System**: 0.0 to 1.0 scale
- 1.0 = Exceptional/stretch achieved
- 0.7 = Good job (expected achievement)
- Below 0.5 = Review and learn

**CANVS Example OKR**:

```yaml
Objective: "Make CANVS the most magical way to discover a city"

Key Results:
  KR1: Increase MPI from 2.1 to 3.5 (0.0-1.0 based on achievement)
  KR2: Grow D7 retention from 25% to 40%
  KR3: Launch in 3 new city markets with 100+ content pieces each
  KR4: Achieve 4.5+ App Store rating

Confidence Levels (update weekly):
  KR1: 0.6 (on track)
  KR2: 0.4 (needs intervention)
  KR3: 0.8 (ahead)
  KR4: 0.7 (on track)
```

**Implementation Timeline**:
- Quarter 1: Learn the system (expect mistakes)
- Quarter 2: Refine process and metrics
- Full implementation: 1-2 quarters

---

## 3. Experimentation Framework

### 3.1 A/B Testing Methodology

**Impact**: Startups using A/B testing see performance improve by **30-100%** after a year of use. Effect is **more significant for smaller, younger firms**.

**Core Process**:

```
1. HYPOTHESIS
   "Changing X will improve Y by Z%"
        |
2. DESIGN
   Control vs. Treatment, sample size, duration
        |
3. RUN
   Random assignment, monitor for issues
        |
4. ANALYZE
   Statistical significance, practical significance
        |
5. DECIDE
   Ship, iterate, or discard
```

**Key Parameters**:
- **Statistical Significance**: 95% confidence is standard
- **Statistical Power**: Aim for 80% (chance of detecting real effect)
- **Minimum Detectable Effect (MDE)**: Smallest change worth detecting
- **Duration**: 2-6 weeks typically (minimum 14 days recommended)

**Low-Traffic Strategies** (relevant for early CANVS):
- Limit variants to 2 (A vs. B only)
- Raise MDE to chase bigger wins
- Extend test duration
- Use CUPED (Controlled Experiment Using Pre-Experiment Data) for variance reduction
- Consider sequential testing frameworks (AGILE methodology)

### 3.2 Sample Size Calculations

**Formula Factors**:
- Baseline conversion rate
- Minimum detectable effect
- Statistical significance level (typically 95%)
- Statistical power (typically 80%)

**Free Calculators**:
- [Evan Miller's Calculator](https://www.evanmiller.org/ab-testing/sample-size.html)
- [Optimizely Calculator](https://www.optimizely.com/sample-size-calculator/)
- [Statsig Calculator](https://statsig.com/calculator)

**CANVS Reality Check**:
```
If CANVS has:
- 1,000 DAU
- 10% baseline conversion
- Want to detect 20% relative improvement (10% -> 12%)
- 95% significance, 80% power

Required sample: ~3,900 per variant
At 1,000 DAU with 50/50 split: ~8 days minimum
```

### 3.3 Feature Flags and Gradual Rollouts

**Rollout Strategy**:

```
1% Rollout (Internal)     -> Catch critical bugs
     |
5% Rollout (Beta users)   -> Initial signal on metrics
     |
25% Rollout (Early adopters) -> Statistical significance
     |
50% Rollout (General)     -> Validate at scale
     |
100% Rollout (Full)       -> Ship it
```

**Kill Switch Protocol**:
- Define rollback criteria before launch
- Monitor error rates, crash rates, key metrics
- Automatic rollback if thresholds exceeded

### 3.4 Multi-Armed Bandits for Optimization

**When to Use**:
- Need fast optimization (short campaigns)
- More than 3 variants to test
- Want to minimize opportunity cost during test

**How It Works**: Dynamically allocates traffic to best-performing variants in real-time, learning and adjusting throughout the test.

**A/B Test vs. Multi-Armed Bandit**:

| Aspect | A/B Test | Multi-Armed Bandit |
|--------|----------|-------------------|
| Traffic allocation | Fixed 50/50 | Dynamic based on performance |
| Best for | High-confidence decisions | Quick optimization |
| Sample efficiency | Lower (tests underperformers equally) | Higher (shifts to winners) |
| Statistical rigor | High (clear significance) | Lower (harder to interpret) |
| Variants | 2-3 optimal | 3+ works well |

**Recommendation**: Use A/B testing for strategic decisions, MAB for tactical optimization (e.g., notification copy, button colors).

### 3.5 Geo-Experiments (Location-Based Testing)

**Highly Relevant for CANVS** as a location-based AR app.

**Methodology**:
```
1. Select matched market pairs (similar demographics, behavior)
2. Apply treatment to test markets only
3. Compare treatment vs. control markets
4. Account for natural variation between markets
```

**CANVS Applications**:
- Test new features in specific cities before global rollout
- Compare marketing strategies by region
- Test pricing in isolated markets
- Validate location-specific content strategies

**Testing Approach**:
- Use geofencing to create virtual boundaries
- Simulate different user locations with test tools (Appium, BrowserStack)
- Test location-based notifications, content discovery
- Account for privacy regulations by region

---

## 4. Data-Driven Product Development

### 4.1 Feature Prioritization Using Data

**RICE Scoring Model** (Intercom):

```
RICE Score = (Reach x Impact x Confidence) / Effort
```

| Factor | Description | Scale |
|--------|-------------|-------|
| **Reach** | Users affected per quarter | Actual number |
| **Impact** | Effect on individual user (0.25 minimal to 3 massive) | 0.25, 0.5, 1, 2, 3 |
| **Confidence** | How sure are you? | 100%, 80%, 50% |
| **Effort** | Person-weeks to build | Actual estimate |

**ICE Scoring Model** (Growth Hacking):

```
ICE Score = (Impact + Confidence + Ease) / 3
```

| Factor | Description | Scale |
|--------|-------------|-------|
| **Impact** | Potential effect | 1-10 |
| **Confidence** | Certainty level | 1-10 |
| **Ease** | Implementation simplicity | 1-10 |

**When to Use Each**:
- **RICE**: Quarterly roadmap planning, major features
- **ICE**: Weekly growth experiments, quick wins

### 4.2 Combining User Research with Quantitative Data

**The Qual-Quant Loop**:

```
QUALITATIVE (Why?)          QUANTITATIVE (What?)
        |                           |
User interviews  <-------->  Funnel analysis
Usability tests  <-------->  A/B test results
Support tickets  <-------->  Feature usage data
        |                           |
        +-----> INSIGHTS <----------+
```

**Integration Framework**:

| Data Type | Tells You | Best For |
|-----------|-----------|----------|
| Quantitative | What users do | Finding problems, measuring impact |
| Qualitative | Why users do it | Understanding context, generating solutions |

**CANVS Example**:
- **Quantitative**: 40% of users drop off after first AR experience
- **Qualitative**: User interviews reveal AR content was hard to find
- **Action**: Redesign discovery UX, A/B test new approach

### 4.3 Funnel Analysis

**Purpose**: Identify where users drop off and why.

**CANVS User Funnel**:

```
App Download (100%)
      |
App Open (85%)
      |
Onboarding Complete (60%)
      |
First AR View (35%)  <-- Major drop-off point
      |
Second Session (25%)
      |
Weekly Active (15%)
```

**Analysis Steps**:
1. Map the complete user journey
2. Measure conversion at each step
3. Identify largest drop-off points
4. Hypothesize causes (use qualitative data)
5. Test solutions with A/B tests
6. Iterate and remeasure

**Common Bottlenecks**:
- Confusing navigation
- Too many steps to value
- Poor mobile responsiveness
- Unclear value proposition
- Technical issues (crashes, slow loads)

### 4.4 Cohort Analysis

**Types**:

1. **Acquisition Cohorts**: Grouped by signup date
   - Track retention over time by when users joined
   - Identify if product improvements help new users

2. **Behavioral Cohorts**: Grouped by actions taken
   - Compare users who did X vs. didn't do X
   - Find behaviors that predict retention

**CANVS Cohort Analysis Examples**:

```yaml
Acquisition Cohort Analysis:
  Question: "Is our D7 retention improving?"
  Cohorts: Users who signed up Week 1, Week 2, Week 3...
  Metric: % still active 7 days after signup

Behavioral Cohort Analysis:
  Question: "Does creating content improve retention?"
  Cohorts:
    - Users who created AR content in first week
    - Users who only viewed content
  Metric: D30 retention for each group
```

**Key Metrics to Track in Cohorts**:
- Retention rates (D1, D7, D14, D30)
- Customer Lifetime Value (CLV)
- Feature adoption rates
- Revenue per cohort

### 4.5 Impact Sizing Before Building

**Pre-Build Impact Assessment**:

```
1. Estimate Reach
   - How many users will this affect?
   - What % of total user base?

2. Estimate Impact
   - What metric will improve?
   - By how much? (Be specific)

3. Calculate Confidence
   - What evidence supports this estimate?
   - What assumptions are we making?

4. Compare to Effort
   - Engineering time required
   - Opportunity cost

5. Make Data-Informed Decision
   - Does expected impact justify investment?
   - What would change this decision?
```

---

## 5. Organizational Practices

### 5.1 Weekly Metrics Reviews

**Meeting Structure** (60 minutes):

```
0:00 - 0:10  Metrics Dashboard Review (automated pull)
0:10 - 0:25  Deep Dive on Concerning Trends
0:25 - 0:40  Experiment Results & Decisions
0:40 - 0:55  This Week's Priorities Alignment
0:55 - 1:00  Action Items & Owners
```

**Dashboard Guidelines**:
- Maximum 30 rows across the company
- 5-7 metrics per team lead
- All metrics from system-of-record (no hand-edited slides)
- Automated data refresh

**Meeting Rules**:
- Single owner per meeting
- Shared document with decision log
- If no decisions made, kill the meeting

### 5.2 Data-Informed Roadmap Planning

**Quarterly Planning Process**:

```
Week 1: Data Review
  - Performance against last quarter's goals
  - User feedback analysis
  - Competitive landscape changes
  - Market data updates

Week 2: Hypothesis Generation
  - Based on data, what should we test/build?
  - Prioritize using RICE/ICE
  - Estimate impact

Week 3: Planning
  - Finalize quarterly OKRs
  - Resource allocation
  - Define success metrics for each initiative

Week 4: Alignment
  - Team sync on priorities
  - Set up tracking and dashboards
  - Define experiment calendar
```

### 5.3 Post-Launch Analysis

**30-60-90 Day Review Framework**:

| Day | Focus | Actions |
|-----|-------|---------|
| **30** | Early signal check | Is feature being adopted? Any critical bugs? |
| **60** | Impact assessment | Did metrics move as expected? |
| **90** | Full evaluation | Ship, iterate, or sunset? |

**Post-Launch Checklist**:
- [ ] Adoption rate vs. target
- [ ] Impact on North Star Metric
- [ ] User feedback (NPS, reviews, support tickets)
- [ ] Technical performance (errors, latency)
- [ ] Resource cost vs. expected

### 5.4 Kill Criteria for Features

**Pre-Define Sunset Triggers**:

1. **Metric-Based Triggers**:
   - Usage drops below X% of target
   - Feature adoption plateaus at <Y%
   - No improvement after Z optimization attempts

2. **Knowledge-Based Triggers**:
   - Market change makes feature obsolete
   - Competitive shift eliminates differentiation
   - User feedback consistently negative

**Sunset Decision Framework**:

```yaml
Before Sunsetting, Evaluate:
  user_engagement:
    active_users: "<threshold>"
    session_duration: "<threshold>"
    retention_impact: "measure"

  financial_impact:
    revenue_contribution: "<threshold>"
    maintenance_cost: ">threshold"
    opportunity_cost: "calculate"

  strategic_fit:
    product_vision_alignment: "yes/no"
    technical_debt: "high/medium/low"
```

**Governance**:
- Quarterly review cadence
- Clear decision authority
- Documentation requirements
- Stakeholder communication plan

### 5.5 Success Metrics Definition Before Launch

**PRD Requirement**: No feature ships without defined success metrics.

**Success Metrics Template**:

```yaml
Feature: [Name]
Launch Date: [Date]

Primary Success Metric:
  metric: "[Specific metric]"
  baseline: "[Current value]"
  target: "[Goal value]"
  measurement_period: "[30/60/90 days]"

Secondary Metrics:
  - metric: "[Metric 2]"
    target: "[Value]"
  - metric: "[Metric 3]"
    target: "[Value]"

Guardrail Metrics (must not regress):
  - "[Metric that should not worsen]"
  - "[Another guardrail]"

Kill Criteria:
  - "If [metric] < [value] after [time], sunset"
```

---

## 6. Tools for Data-Driven Teams

### 6.1 Dashboard Tools

**Free/Low-Cost Options**:

| Tool | Best For | Pricing | Notes |
|------|----------|---------|-------|
| **Google Looker Studio** | Google ecosystem | Free | No user limits, drag-and-drop |
| **Metabase** | Self-hosted, SQL teams | Free (self-host) or $100/mo (cloud) | Open source, powerful |
| **Apache Superset** | Enterprise scale | Free (self-host) | More technical setup |

**Recommendations by Stage**:
- **Seed/Pre-seed**: Looker Studio (free, quick setup)
- **Series A**: Metabase (more flexibility, self-host)
- **Series B+**: Evaluate Looker, Tableau, or custom

### 6.2 Experimentation Platforms (Free Options)

| Platform | Free Tier | Best For |
|----------|-----------|----------|
| **GrowthBook** | Unlimited experiments (open source) | Full-featured, visual editor |
| **PostHog** | 1M events/mo | All-in-one analytics + experimentation |
| **Statsig** | Free developer plan | Fast experiment velocity |
| **Unleash** | 125k requests/mo | Feature flags + basic A/B |
| **VWO Starter** | 50k visitors/mo | Visual A/B testing |

**CANVS Recommendation**: Start with **GrowthBook** (open source, comprehensive) or **PostHog** (all-in-one platform).

### 6.3 Product Analytics Tools

| Tool | Free Tier | Strengths |
|------|-----------|-----------|
| **Mixpanel** | 20M events/mo | User journey analysis |
| **Amplitude** | 10M events/mo | Autocapture, cohort analysis |
| **PostHog** | 1M events/mo | Open source, full suite |
| **Heap** | Limited | Auto-capture everything |

### 6.4 Collaboration on Data

**Documentation**:
- **Notion**: Data dictionary, experiment logs
- **Confluence**: More structured documentation

**Data Catalogs** (for later stages):
- Atlan (AI-powered)
- Alation (enterprise)

**Communication**:
- Slack channels for metric alerts
- Weekly async updates in dedicated channel

### 6.5 Alert Systems for Metric Changes

**Set Up Alerts For**:
- Key metrics deviating >X% from baseline
- Error rates exceeding threshold
- A/B test reaching significance
- Feature flag issues

**Tools**:
- Most analytics platforms have built-in alerts
- Slack integrations for real-time notification
- PagerDuty for critical metrics (later stage)

---

## 7. From Day One Implementation

### 7.1 Minimum Viable Analytics (MVA)

**Definition**: Tracking framework providing just enough information for current decisions plus feedback as product develops.

**Day 1 Essentials**:
1. **User Tracking**: Unique user identification
2. **Core Events**: Key actions that matter
3. **Basic Funnel**: Acquisition -> Activation -> Retention

**CANVS Day 1 Events**:

```yaml
Core Events (Track from day 1):
  acquisition:
    - app_installed
    - app_opened
    - signup_started
    - signup_completed

  activation:
    - onboarding_started
    - onboarding_completed
    - first_ar_content_viewed
    - first_location_visited

  engagement:
    - ar_content_viewed
    - ar_content_created
    - session_started
    - session_ended

  retention:
    - return_visit (with days_since_signup)

  revenue:
    - subscription_started
    - purchase_completed
```

### 7.2 MVA Stack Recommendation

```
Week 1-2: Foundation
-----------------------
Analytics: PostHog or Amplitude (free tier)
  - Auto-capture for baseline
  - Manual events for key actions

Data Storage: Built-in (use platform's storage initially)

Dashboard: Looker Studio (free)
  - Connect to analytics platform
  - Build 1 dashboard with key metrics

Week 3-4: Expand
-----------------------
Event tracking: Define and implement full event taxonomy
Alerts: Set up key metric alerts in Slack
Documentation: Create data dictionary in Notion
```

### 7.3 Avoiding Analysis Paralysis

**Common Traps**:
1. Tracking too many things
2. Waiting for perfect data to decide
3. Running tests too long
4. Optimizing for wrong metrics
5. Ignoring data that doesn't fit hypothesis

**Prevention Strategies**:

| Trap | Prevention |
|------|------------|
| Tracking everything | Define 10-15 core events only |
| Waiting for perfect data | Set "good enough" thresholds |
| Tests running forever | Pre-define test duration |
| Wrong metrics | Validate metrics predict business outcomes |
| Confirmation bias | Always define success criteria before looking at data |

**Decision Timeboxes**:
- Tactical decisions: 1-2 days of data
- Feature decisions: 1-2 weeks of data
- Strategic decisions: 1 month+ of data

### 7.4 Data Maturity Progression

**Stage 1: Foundations (Months 1-3)**
- Basic event tracking
- Simple dashboards
- Weekly metric reviews
- Ad-hoc analysis

**Stage 2: Systematization (Months 4-6)**
- Comprehensive event taxonomy
- Automated dashboards
- Regular experimentation
- Cohort analysis

**Stage 3: Optimization (Months 7-12)**
- Predictive metrics
- Self-service analytics
- Data-informed culture
- Advanced experimentation

**Stage 4: Intelligence (Year 2+)**
- Machine learning predictions
- Automated optimization
- Real-time decisioning
- Data products

**Timeline Reality**: Moving between stages typically takes 12-24 months depending on team enablement, technology, and cultural shifts.

---

## 8. CANVS-Specific Considerations

### 8.1 Location-Based Metrics

**Unique to CANVS**:
- Geographic coverage (cities/neighborhoods with content)
- Content density per location
- Location visit patterns
- Travel distance to AR content
- Cross-location engagement

**Geo-Experiment Opportunities**:
- Test new features by city
- Compare marketing effectiveness by region
- Price testing in isolated markets
- Content strategy validation by area

### 8.2 AR-Specific Analytics

**AR Session Metrics**:
- AR session duration
- AR content load time
- AR experience completion rate
- Device performance during AR

**Quality Metrics**:
- AR content rating/feedback
- Report rate (inappropriate content)
- Share rate from AR experience
- Screenshot/recording frequency

### 8.3 Two-Sided Marketplace Considerations

**Creator Metrics**:
- Creator activation rate
- Content creation velocity
- Creator retention
- Creator earnings (if applicable)

**Consumer Metrics**:
- Discovery rate
- Consumption rate
- Return visits
- Conversion to creator

**Marketplace Health**:
- Content supply vs. demand by location
- Creator-consumer ratio
- Content freshness
- Geographic coverage growth

### 8.4 MPI (Moments Per Interaction) Deep Dive

If MPI is CANVS's North Star Metric:

**Definition**: Number of "magical moments" users experience per app session.

**What Counts as a Moment**:
- Viewing AR content that elicits delight
- Creating content successfully
- Sharing with friends
- Discovering unexpected content
- Achieving personal milestone

**Measurement Approach**:
1. Define moment-triggering events
2. Track composite metric
3. Validate with qualitative feedback (does this feel right?)
4. Iterate on definition

**Input Metrics That Drive MPI**:
- Content quality score
- Content relevance (location match)
- App performance (no lag = better moments)
- Discovery UX effectiveness
- Content freshness

---

## Appendix: Quick Reference Cards

### A. Daily Data Checklist

```
[ ] Check key metrics dashboard
[ ] Review any triggered alerts
[ ] Note anomalies for weekly discussion
[ ] Update experiment log if running tests
```

### B. Weekly Review Template

```markdown
## Week of [Date]

### Key Metrics
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| DAU    |        |        |        |
| MPI    |        |        |        |
| D7 Ret |        |        |        |

### Experiments Running
- [Experiment 1]: Status, current results
- [Experiment 2]: Status, current results

### Decisions Made
- [Decision 1]: Based on [data]
- [Decision 2]: Based on [data]

### Next Week Focus
- [ ] Priority 1
- [ ] Priority 2
```

### C. Experiment Brief Template

```markdown
## Experiment: [Name]

### Hypothesis
We believe that [change]
Will result in [outcome]
We will know when [metric] changes by [amount]

### Design
- Control: [description]
- Treatment: [description]
- Sample size: [calculated]
- Duration: [days]
- Success threshold: [criteria]

### Results
- Started: [date]
- Ended: [date]
- Outcome: [ship/iterate/kill]
- Learning: [what we learned]
```

---

## Sources

### Data-Driven Decision Making
- [Asana - Data-Driven Decision Making Guide 2025](https://asana.com/resources/data-driven-decision-making)
- [Atlan - Data-Driven Decision Making](https://atlan.com/data-driven-decision-making/)
- [Tableau - Guide to Data-Driven Decision Making](https://www.tableau.com/learn/articles/data-driven-decision-making)

### North Star Metrics
- [Amplitude - Product North Star Metric](https://amplitude.com/blog/product-north-star-metric)
- [Future/a16z - Choosing Your North Star Metric](https://future.com/north-star-metrics/)
- [Mixpanel - What is a North Star Metric](https://mixpanel.com/blog/north-star-metric/)

### OKRs
- [Twilio Segment - Setting Data-Driven OKRs](https://segment.com/academy/building-data-driven-company/setting-data-driven-OKRs/)
- [Atlassian - OKR Guide](https://www.atlassian.com/agile/agile-at-scale/okr)
- [Asana - What are OKRs](https://asana.com/resources/okr-meaning)

### Experimentation & A/B Testing
- [GrowthBook - Open Guide to A/B Testing](https://docs.growthbook.io/open-guide-to-ab-testing.v1.0.pdf)
- [Harvard Business School - Experimentation and Startup Performance](https://www.hbs.edu/ris/Publication%20Files/AB_Testing_R_R_08b97538-ed3f-413e-bc38-c239b175d868.pdf)
- [Statsig - Best Free A/B Testing Tools](https://www.statsig.com/comparison/best-free-ab-testing-tools)

### Pirate Metrics (AARRR)
- [Purchasely - AARRR Framework Guide 2025](https://www.purchasely.com/blog/aarrr-framework-pirate-metrics-complete-guide-for-2025)
- [Amplitude - Pirate Metrics Framework](https://amplitude.com/blog/pirate-metrics-framework)

### Leading vs Lagging Indicators
- [Amplitude - Leading vs Lagging Indicators](https://amplitude.com/blog/leading-lagging-indicators)
- [Mercury - Leading vs Lagging Indicators](https://mercury.com/blog/leading-versus-lagging-indicators)
- [WaveUp - Leading vs Lagging for Founders](https://waveup.com/blog/leading-vs-lagging-metrics/)

### Feature Prioritization
- [ProductPlan - RICE Scoring Model](https://www.productplan.com/glossary/rice-scoring-model/)
- [ProductLift - RICE vs ICE](https://www.productlift.dev/blog/rice-vs-ice)

### Cohort Analysis
- [Mixpanel - Cohort Analysis Guide](https://mixpanel.com/blog/cohort-analysis/)
- [Userpilot - Cohort Retention Analysis](https://userpilot.com/blog/cohort-retention-analysis/)

### Weekly Metrics Reviews
- [Capitaly - David Sacks Operating Cadence](https://www.capitaly.vc/blog/david-sacks-operating-cadence-weekly-metrics-okrs-ceo-dashboard)
- [Visible.vc - Cadence & Operational Metrics](https://visible.vc/blog/ultimate-report-part-2-cadence-operational-metrics/)

### Minimum Viable Analytics
- [Freshpaint - Minimum Viable Analytics](https://www.freshpaint.io/blog/minimum-viable-analytics-dont-overbuild-your-stack)
- [Phiture - Mobile App Analytics MVA](https://phiture.com/mobilegrowthstack/mobile-app-analytics-519f5719e283/)

### Dashboard Tools
- [Metabase - Open Source BI](https://www.metabase.com/)
- [Valiotti - Top 5 Data Visualization Tools 2025](https://valiotti.com/blog/top-5-data-visualization-tools/)

### Data Democratization
- [Devoteam - Data Democratization with Self-Service Analytics](https://www.devoteam.com/expert-view/how-to-democratise-data-with-self-service-analytics/)
- [Contentsquare - Data Democratization Strategy](https://contentsquare.com/guides/data-maturity/data-democratization/)

### Hypothesis-Driven Development
- [ThoughtWorks - Implementing Hypothesis-Driven Development](https://www.thoughtworks.com/en-us/insights/articles/how-implement-hypothesis-driven-development)
- [Barry O'Reilly - Hypothesis-Driven Development](https://barryoreilly.com/explore/blog/how-to-implement-hypothesis-driven-development/)

### Multi-Armed Bandits
- [Amplitude - Multi-Armed Bandit vs A/B Testing](https://amplitude.com/blog/multi-armed-bandit-vs-ab-testing)
- [VWO - Multi-Armed Bandit Algorithm](https://vwo.com/blog/multi-armed-bandit-algorithm/)

### Feature Sunsetting
- [ProductHQ - How to Sunset a Feature](https://producthq.org/agile/product-management/how-to-sunset-a-feature/)
- [LogRocket - Feature Sunset Guide](https://blog.logrocket.com/product-management/feature-sunset-product-decommissioning-guide/)

### Data Maturity Models
- [Heap - Four Stages of Data Maturity](https://www.heap.io/blog/the-four-stages-of-data-maturity)
- [Contentsquare - Data Maturity Stages](https://contentsquare.com/guides/data-maturity/stages/)
