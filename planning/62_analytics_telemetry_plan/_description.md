# Analytics / Telemetry Plan

## Overview

An Analytics and Telemetry Plan defines how product usage data will be collected, stored, analyzed, and used to inform product decisions. Telemetry refers to the automated collection of data from users' interactions with the product, while analytics transforms that data into actionable insights. A well-designed plan ensures that the right data is captured to answer important questions while respecting user privacy and maintaining data quality.

## Purpose

- **Measure success**: Track whether product goals are being achieved
- **Understand behavior**: Learn how users actually use the product
- **Identify issues**: Detect problems through usage patterns
- **Inform decisions**: Enable data-driven product decisions
- **Validate hypotheses**: Test assumptions with real data
- **Optimize experience**: Improve based on user behavior
- **Support AI**: Provide reliable data for AI-powered features

## When to Create

- **Product Planning**: Before building features
- **New Features**: As part of feature specification
- **Product Launch**: Before releasing to users
- **Analytics Maturity**: When establishing analytics practice
- **Privacy Reviews**: When updating data practices
- **Regular Review**: Quarterly analytics audits

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Defines what to measure and why |
| Data Engineer | Implements data collection infrastructure |
| Data Analyst/Scientist | Analyzes data and provides insights |
| Engineers | Instruments code with tracking |
| Privacy/Legal | Reviews data collection compliance |
| UX Researcher | Uses data to inform research |

## Key Components

### 1. Measurement Strategy
- Business goals and KPIs
- Product metrics framework
- Success criteria
- Metric ownership

### 2. Event Taxonomy
- Event naming conventions
- Event properties/attributes
- Event hierarchy
- Documentation standards

### 3. Data Collection
- Instrumentation approach
- SDK selection
- Data pipeline architecture
- Quality assurance

### 4. Privacy and Compliance
- Consent management
- Data retention policies
- Anonymization approach
- Regulatory compliance

### 5. Analysis and Reporting
- Dashboard design
- Self-serve analytics
- Report cadence
- Insight distribution

## Event Taxonomy Structure

### Naming Convention
```
[object]_[action]
```

**Examples:**
- `user_signed_up`
- `project_created`
- `subscription_upgraded`
- `feature_used`

### Event Properties
```json
{
  "event": "project_created",
  "timestamp": "2024-01-15T10:30:00Z",
  "user_id": "user_123",
  "properties": {
    "project_type": "personal",
    "template_used": true,
    "team_size": 5
  }
}
```

## Data Pipeline Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────▶│   Event     │────▶│    Data     │
│   (Web/App) │     │   Collector │     │   Warehouse │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Actions   │◀────│  Analytics  │◀────│    BI /     │
│   & Alerts  │     │    Layer    │     │  Dashboard  │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Privacy Considerations

### Consent Management
- Obtain consent before collecting
- Provide opt-out mechanisms
- Honor user preferences
- Document consent decisions

### Data Minimization
- Collect only what's needed
- Avoid personally identifiable information (PII)
- Anonymize where possible
- Define retention periods

### Regulatory Compliance
- GDPR (EU)
- CCPA (California)
- Other regional requirements
- Industry-specific rules

## Inputs & Dependencies

- Product requirements
- Business goals and KPIs
- Privacy requirements
- Technical architecture
- Analytics tool selection
- Team analytics literacy
- Budget constraints

## Outputs & Deliverables

- Analytics implementation plan
- Event taxonomy documentation
- Data dictionary
- Privacy impact assessment
- Dashboards and reports
- Analysis playbooks
- Training materials

## Best Practices

1. **Start with Questions**: Know what decisions data will inform before instrumenting.

2. **Create a Taxonomy**: Standardized event naming prevents confusion.

3. **Design for Quality**: Validate instrumentation before shipping.

4. **Document Everything**: Maintain a data dictionary for all events.

5. **Respect Privacy**: Build privacy in from the start.

6. **Avoid Data Overload**: Collect what you need, not everything possible.

7. **Build for Self-Serve**: Enable teams to answer their own questions.

8. **Validate Regularly**: Audit data quality periodically.

## Common Pitfalls

- **No Clear Questions**: Collecting data without knowing why
- **Inconsistent Naming**: Events named differently across features
- **Missing Context**: Events without enough properties
- **Data Quality Issues**: Broken or missing instrumentation
- **Privacy Violations**: Collecting more than permitted
- **Analysis Silos**: Data not accessible to those who need it
- **Alert Fatigue**: Too many meaningless alerts
- **Stale Dashboards**: Reports no one looks at

## Metrics Framework

### AARRR (Pirate Metrics)
| Stage | Metrics |
|-------|---------|
| Acquisition | Signups, visits, sources |
| Activation | Onboarding completion, first action |
| Retention | DAU/MAU, return rate, churn |
| Referral | Invites sent, viral coefficient |
| Revenue | Conversion, LTV, ARPU |

### North Star + Input Metrics
- **North Star**: Single metric that best captures product value
- **Input Metrics**: Leading indicators that drive the North Star

## Tools

### Analytics Platforms
- **Amplitude**: Product analytics
- **Mixpanel**: Event analytics
- **Heap**: Auto-capture analytics
- **PostHog**: Open-source analytics

### Data Infrastructure
- **Segment**: Customer data platform
- **Snowflake**: Data warehouse
- **BigQuery**: Cloud data warehouse
- **dbt**: Data transformation

### Visualization
- **Looker**: Business intelligence
- **Tableau**: Data visualization
- **Metabase**: Open-source BI
- **Mode**: Analytics platform

### Event Tracking
- **Snowplow**: Event collection
- **RudderStack**: Customer data platform
- **Keen.io**: Event data platform

## Related Documents

- [Metric Definitions](../metric-definitions/_description.md) - Metric specifications
- [Monitoring & Observability Plan](../monitoring-observability-plan/_description.md) - System monitoring
- [Customer Feedback Collection Plan](../customer-feedback-collection-plan/_description.md) - Qualitative data
- [Experimentation Plan](../experimentation-plan/_description.md) - A/B testing
- [SLO / SLI Definition](../slo-sli-definition/_description.md) - Service metrics

## Examples & References

### Analytics Plan Template

```markdown
# Analytics Plan: [Feature/Product Name]

## Overview
- **Owner**: [Name]
- **Last Updated**: [Date]
- **Analytics Tool**: [e.g., Amplitude]

## Business Context
### Goals
- Increase activation rate by 20%
- Identify top drop-off points in onboarding

### Key Questions
1. What % of users complete onboarding?
2. Where do users drop off?
3. Which onboarding steps correlate with retention?

## Event Taxonomy

### User Journey Events

| Event Name | Trigger | Properties | Priority |
|------------|---------|------------|----------|
| user_signed_up | Account created | signup_source, plan_type | P0 |
| onboarding_started | First login | - | P0 |
| onboarding_step_completed | Each step done | step_name, time_spent | P0 |
| onboarding_completed | All steps done | total_time, steps_skipped | P0 |
| first_project_created | First project | template_used | P0 |

### Event Details

#### user_signed_up
- **Description**: User creates new account
- **Trigger**: Successful account creation
- **Properties**:
  - `signup_source` (string): "organic", "referral", "paid"
  - `plan_type` (string): "free", "pro", "enterprise"
  - `referral_code` (string, optional): If referred

### User Properties
| Property | Type | Description |
|----------|------|-------------|
| user_id | string | Unique user identifier |
| created_at | datetime | Account creation date |
| plan_type | string | Current subscription plan |
| team_size | integer | Number of team members |

## Dashboard Requirements

### Onboarding Dashboard
- Funnel: Signup → Step 1 → Step 2 → Complete
- Completion rate by cohort
- Average time per step
- Drop-off by step

### Key Metrics
| Metric | Definition | Target |
|--------|------------|--------|
| Activation Rate | Users completing onboarding within 7 days | 60% |
| Day 7 Retention | Users returning 7 days after signup | 40% |
| Time to Activate | Median time from signup to activation | <10 min |

## Privacy Considerations
- No PII in event properties
- User can opt-out via settings
- Data retained for 12 months
- Anonymize after 30 days for inactive users

## Implementation Plan
1. [ ] Add Amplitude SDK
2. [ ] Implement event tracking
3. [ ] Create QA dashboard for validation
4. [ ] Build production dashboards
5. [ ] Document in data dictionary
```

### Event Documentation Template

```markdown
## Event: feature_used

### Description
Tracked when a user engages with a product feature.

### Trigger
User clicks/activates the feature.

### Properties
| Property | Type | Required | Description |
|----------|------|----------|-------------|
| feature_name | string | Yes | Name of the feature |
| feature_category | string | Yes | Category grouping |
| entry_point | string | No | Where user accessed from |
| success | boolean | Yes | Whether action succeeded |

### Example Payload
```json
{
  "event": "feature_used",
  "user_id": "user_123",
  "timestamp": "2024-01-15T10:30:00Z",
  "properties": {
    "feature_name": "export_csv",
    "feature_category": "data_export",
    "entry_point": "toolbar",
    "success": true
  }
}
```
```

### Further Reading

- [The New Stack - Data Telemetry](https://thenewstack.io/data-telemetry-is-the-lifeline-of-modern-analytics-and-ai/)
- [Keboola Telemetry Guide](https://www.keboola.com/blog/a-comprehensive-guide-to-telemetry)
- [ChaosSearch - Telemetry for PLG](https://www.chaossearch.io/blog/what-is-data-ops-application-improvement)
- "Lean Analytics" - Alistair Croll & Benjamin Yoskovitz
