# Metric Definitions

## Overview

Metric Definitions document the precise specifications for how product and business metrics are calculated, including data sources, formulas, dimensions, and interpretation guidelines. Clear metric definitions ensure that everyone in the organization understands what each metric means and how it's measured, preventing confusion and enabling consistent, reliable analysis. While every KPI is a metric, not every metric is a KPI—this document covers both.

## Purpose

- **Create shared understanding**: Everyone uses metrics the same way
- **Enable accurate analysis**: Clear formulas prevent calculation errors
- **Support decision-making**: Reliable data drives better decisions
- **Prevent confusion**: Avoid debates about what metrics mean
- **Enable self-service**: Teams can calculate metrics independently
- **Support auditing**: Document data lineage for compliance
- **Facilitate onboarding**: Help new team members understand key metrics

## When to Create

- **Analytics Setup**: When establishing measurement practice
- **New Metrics**: When defining new KPIs or metrics
- **Data Issues**: After inconsistencies are discovered
- **Team Scaling**: When enabling self-serve analytics
- **Compliance Needs**: When audit trails are required
- **Regular Review**: Annual metric definition review

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Defines what to measure and business context |
| Data Analyst | Specifies formulas and data sources |
| Data Engineer | Ensures data availability and quality |
| Finance | Aligns on financial metrics |
| Leadership | Approves key metric definitions |
| All Teams | Use metrics consistently |

## Key Components

### 1. Metric Identification
- Metric name
- Unique identifier
- Category/grouping
- Owner/steward

### 2. Definition
- Business definition (plain language)
- Technical definition (formula)
- Numerator and denominator (for ratios)
- Units and precision

### 3. Data Specification
- Data source(s)
- Fields/columns used
- Filters and exclusions
- Calculation timing

### 4. Dimensions
- Available breakdowns (e.g., by country, plan)
- Segment definitions
- Time granularity

### 5. Interpretation
- What good looks like (targets)
- How to use the metric
- Caveats and limitations
- Related metrics

## Metric Categories

### Product Metrics
| Category | Examples |
|----------|----------|
| Engagement | DAU, MAU, sessions |
| Activation | Activation rate, time to value |
| Retention | Day 7/30/90 retention |
| Feature Usage | Feature adoption, frequency |

### Business Metrics
| Category | Examples |
|----------|----------|
| Revenue | MRR, ARR, ARPU |
| Growth | User growth rate, revenue growth |
| Efficiency | CAC, LTV, payback period |
| Health | Churn rate, NPS, CSAT |

### Operational Metrics
| Category | Examples |
|----------|----------|
| Support | Ticket volume, resolution time |
| Engineering | Deploy frequency, lead time |
| Sales | Pipeline, win rate, ACV |

## KPIs vs Metrics

| Aspect | KPIs | Metrics |
|--------|------|---------|
| Purpose | Measure strategic outcomes | Measure activities/outputs |
| Quantity | Few (3-5 key ones) | Many |
| Audience | Leadership, stakeholders | Teams, analysts |
| Frequency | Regular reporting | As needed |
| Example | Monthly Active Users | Page views per session |

## Metric Quality Criteria

### SMART Metrics
- **S**pecific: Clear, unambiguous definition
- **M**easurable: Can be quantified
- **A**chievable: Realistic targets possible
- **R**elevant: Aligned to business goals
- **T**ime-bound: Defined time period

### Data Quality Requirements
- Accurate: Reflects reality
- Complete: No missing data
- Timely: Available when needed
- Consistent: Same calculation everywhere

## Inputs & Dependencies

- Business goals and strategy
- Data sources and availability
- Stakeholder requirements
- Industry benchmarks
- Historical baselines
- Tool capabilities

## Outputs & Deliverables

- Metric definitions document
- Data dictionary
- Calculation formulas
- Dashboard specifications
- Benchmark targets
- Interpretation guidelines

## Best Practices

1. **Use Plain Language**: Define in terms anyone can understand.

2. **Document Formulas Precisely**: Leave no ambiguity in calculations.

3. **Specify Time Windows**: Be clear about what time period applies.

4. **Include Examples**: Show sample calculations.

5. **Document Edge Cases**: How to handle unusual situations.

6. **Version Control**: Track changes to definitions over time.

7. **Centralize Definitions**: Single source of truth.

8. **Review Regularly**: Audit metrics for continued relevance.

## Common Pitfalls

- **Inconsistent Definitions**: Same metric calculated differently
- **Undefined Terms**: Ambiguous language in definitions
- **Missing Time Bounds**: No specified period
- **No Ownership**: Unclear who maintains definition
- **Stale Definitions**: Metrics that no longer apply
- **Too Many Metrics**: Overwhelming number tracked
- **Vanity Metrics**: Metrics that look good but don't inform action
- **No Context**: Metrics without targets or benchmarks

## Common Metrics Definitions

### DAU/MAU Ratio
```
DAU/MAU = Daily Active Users / Monthly Active Users

Active = User logged in and performed at least one action
Time: DAU = single day, MAU = trailing 30 days
Target: 20%+ considered good engagement
```

### Retention Rate
```
Day N Retention = Users active on Day N / Users who signed up N days ago

Example: Day 7 Retention
Users active on day 7 after signup / Total users who signed up 7 days ago
Target: Day 1: 40%+, Day 7: 25%+, Day 30: 15%+
```

### Churn Rate
```
Monthly Churn Rate = (Customers at start - Customers at end + New customers) / Customers at start

Or: Lost MRR / Starting MRR
Target: <5% monthly for SaaS
```

## Tools

### Data Catalogs
- **Atlan**: Data catalog and governance
- **Collibra**: Data intelligence
- **DataHub**: Open-source data catalog
- **Alation**: Data catalog

### Documentation
- **Notion/Confluence**: Documentation
- **dbt docs**: Data model documentation
- **Looker**: Explore/field descriptions

### Analytics
- **Looker**: Semantic layer with LookML
- **Amplitude**: Built-in metric definitions
- **Mixpanel**: Custom metrics

## Related Documents

- [Analytics / Telemetry Plan](../analytics-telemetry-plan/_description.md) - Data collection
- [SLO / SLI Definition](../slo-sli-definition/_description.md) - Service level metrics
- [Goals and Non-Goals](../goals-and-non-goals/_description.md) - Strategic alignment
- [Experimentation Plan](../experimentation-plan/_description.md) - Success metrics for experiments

## Examples & References

### Metric Definition Template

```markdown
# Metric Definition: Monthly Active Users (MAU)

## Overview
| Field | Value |
|-------|-------|
| Metric ID | PROD-001 |
| Category | Engagement |
| Owner | Product Analytics |
| Last Updated | 2024-01-15 |
| Status | Active |

## Business Definition
The count of unique users who have performed at least one
meaningful action in the product within the last 30 days.

## Technical Definition

### Formula
```
MAU = COUNT(DISTINCT user_id)
WHERE event_timestamp >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
AND event_type IN ('feature_used', 'content_created', 'project_updated')
```

### Numerator
Distinct users with qualifying activity

### Time Window
Trailing 30 days from the reporting date

### Qualifying Actions
- Feature used (any feature interaction)
- Content created (new content added)
- Project updated (project modifications)

### Exclusions
- System-generated events
- API-only activity
- Internal/test accounts

## Data Source
- **Table**: `analytics.events`
- **Key Fields**: user_id, event_type, event_timestamp
- **Update Frequency**: Real-time
- **Data Freshness**: 1-hour lag

## Dimensions
| Dimension | Values |
|-----------|--------|
| Plan Type | Free, Pro, Enterprise |
| Region | NA, EMEA, APAC |
| Platform | Web, iOS, Android |
| User Tenure | New (<30d), Established (30-90d), Mature (>90d) |

## Interpretation

### Targets
| Segment | Target | Current |
|---------|--------|---------|
| Overall | 100,000 | 85,000 |
| Enterprise | 10,000 | 8,500 |
| Pro | 40,000 | 35,000 |

### Benchmarks
- Industry average for SaaS: varies widely
- Our historical growth: 5-8% MoM

### How to Use
- Track overall product health
- Compare across segments
- Correlate with feature launches

### Caveats
- Does not reflect depth of engagement
- Can be inflated by one-time users
- Use with DAU/MAU ratio for fuller picture

## Related Metrics
- DAU (Daily Active Users)
- DAU/MAU Ratio (Stickiness)
- Retention Rate
- WAU (Weekly Active Users)

## Change History
| Date | Change | Author |
|------|--------|--------|
| 2024-01-15 | Added API exclusion | @analyst |
| 2023-06-01 | Updated qualifying events | @pm |
| 2023-01-01 | Initial definition | @data |
```

### Metric Catalog Example

| Metric | Category | Formula | Owner |
|--------|----------|---------|-------|
| MAU | Engagement | COUNT(DISTINCT active users, 30d) | Product |
| DAU | Engagement | COUNT(DISTINCT active users, 1d) | Product |
| Activation Rate | Activation | Activated users / Signups | Growth |
| Day 7 Retention | Retention | Active D7 / Signup cohort | Product |
| MRR | Revenue | SUM(monthly recurring revenue) | Finance |
| Churn Rate | Revenue | Lost MRR / Starting MRR | Finance |
| NPS | Satisfaction | Promoters% - Detractors% | CX |
| CSAT | Satisfaction | Satisfied / Total responses | Support |

### Further Reading

- [Pendo - 10 KPIs for Product Leaders](https://www.pendo.io/resources/the-10-kpis-every-product-leader-needs-to-know/)
- [Contentsquare Product Analytics Metrics](https://contentsquare.com/guides/product-analytics/metrics/)
- [Product School - Metrics for PM](https://productschool.com/blog/analytics/metrics-product-management)
- [AltexSoft - Product Management KPIs](https://www.altexsoft.com/blog/15-key-product-management-metrics-and-kpis/)
