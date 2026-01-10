# SLO / SLI Definition

## Overview

Service Level Objectives (SLOs) and Service Level Indicators (SLIs) are fundamental concepts in Site Reliability Engineering (SRE) that define and measure service reliability. An SLI is a quantitative measure of a service attribute (like latency or availability), while an SLO is a target value or range for that SLI. Together, they create a framework for balancing reliability with feature velocity, enabling data-driven decisions about where to invest engineering effort.

## Purpose

- **Define reliability targets**: Establish measurable service quality goals
- **Measure performance**: Track actual service behavior against targets
- **Enable decisions**: Inform trade-offs between reliability and velocity
- **Create accountability**: Establish shared understanding of expectations
- **Support error budgets**: Enable calculated risk-taking
- **Align teams**: Unite development and operations on shared goals
- **Inform SLAs**: Provide basis for customer commitments

## When to Create

- **New Services**: Before launching services to production
- **SRE Adoption**: When implementing SRE practices
- **Service Maturity**: When moving from reactive to proactive reliability
- **Customer Commitments**: When defining SLAs
- **Reliability Issues**: After incidents reveal measurement gaps
- **Quarterly Review**: Regular refinement of targets

## Who's Involved

| Role | Responsibility |
|------|----------------|
| SRE/DevOps | Defines SLIs and implements measurement |
| Service Owner | Approves SLO targets |
| Product Manager | Provides user perspective on reliability |
| Engineering Lead | Commits to reliability investment |
| Business Stakeholders | Align SLOs with business needs |
| Customers | Provide feedback on experience |

## Key Concepts

### SLI (Service Level Indicator)
A carefully defined quantitative measure of service level.

**Characteristics:**
- Measurable and observable
- Reflects user experience
- Collected consistently
- Comparable over time

**Common SLIs:**
- Request latency
- Error rate
- Availability
- Throughput
- Durability

### SLO (Service Level Objective)
A target value or range for an SLI.

**Components:**
- **Metric**: The SLI being measured
- **Target**: The goal (e.g., 99.9%)
- **Window**: The time period (e.g., 30 days)

**Example:** "99.9% of requests complete in under 200ms over 30 days"

### SLA (Service Level Agreement)
A contract with consequences for missing SLOs.

**Includes:**
- SLO targets (usually more lenient than internal SLOs)
- Financial penalties or credits
- Legal obligations

### Error Budget
The allowed amount of unreliability.

**Formula:** Error Budget = 100% - SLO Target

**Example:** 99.9% SLO = 0.1% error budget = ~43 minutes/month of downtime

## SLI Categories

### Availability SLIs
```
Successful requests / Total requests

Example: 99.95% of requests return non-5xx status
```

### Latency SLIs
```
Requests faster than threshold / Total requests

Example: 99% of requests complete in <200ms
```

### Throughput SLIs
```
Processed items / Expected items

Example: 99.9% of queued jobs processed within 1 hour
```

### Quality SLIs
```
Correct responses / Total responses

Example: 99.99% of search results return relevant matches
```

### Freshness SLIs
```
Data updates within threshold / Total data

Example: 99% of data records updated within 10 minutes
```

## Choosing SLOs

### Start with User Experience
- What does "working" mean to users?
- What latency is acceptable?
- What errors are tolerable?

### Consider Business Impact
- Revenue impact of degradation
- Customer satisfaction thresholds
- Competitive requirements

### Set Realistic Targets
- Based on historical data
- Achievable with current architecture
- Allow for improvement over time

### Avoid Extremes
- Not too aggressive (creates burnout)
- Not too lenient (allows poor experience)

## Error Budget Policy

### When Budget is Healthy
- Ship features freely
- Take calculated risks
- Experiment with changes

### When Budget is Low
- Slow down feature releases
- Focus on reliability improvements
- Increase testing and review

### When Budget is Exhausted
- Feature freeze
- All hands on reliability
- Postmortem on budget burn

## Inputs & Dependencies

- Historical service metrics
- User experience requirements
- Business requirements
- Architecture constraints
- Monitoring capabilities
- Incident history
- Competitive benchmarks

## Outputs & Deliverables

- SLI definitions document
- SLO target specifications
- Error budget calculations
- Monitoring dashboards
- Alerting configurations
- Reporting mechanisms
- Review cadence

## Best Practices

1. **Measure User Experience**: SLIs should reflect what users care about.

2. **Start Conservative**: Set achievable SLOs, then tighten over time.

3. **Use Error Budgets**: Balance reliability with development velocity.

4. **Review Regularly**: Adjust SLOs as service and requirements evolve.

5. **Set SLA Buffers**: Internal SLOs should be stricter than external SLAs.

6. **Limit SLO Count**: Focus on 2-4 key SLOs per service.

7. **Document Rationale**: Explain why targets were chosen.

8. **Alert on Burn Rate**: Alert when error budget is being consumed too quickly.

## Common Pitfalls

- **Too Many SLOs**: Tracking everything instead of what matters
- **Unrealistic Targets**: SLOs that can't be met with current architecture
- **No Error Budget**: Not using SLOs to make release decisions
- **Internal-Only SLIs**: Measuring what's easy, not what users experience
- **Static SLOs**: Never reviewing or adjusting targets
- **No Consequences**: SLOs without error budget policies
- **Misaligned Incentives**: Teams not incentivized to meet SLOs
- **Perfect Targets**: 100% SLOs that allow no room for improvement

## Tools

### SLO Platforms
- **Nobl9**: SLO management platform
- **Datadog SLOs**: Integrated SLO tracking
- **Honeycomb SLOs**: Query-based SLOs
- **Google Cloud SLOs**: GCP native SLOs

### Monitoring
- **Prometheus**: Metrics collection
- **Grafana**: Visualization
- **New Relic**: APM with SLOs
- **Dynatrace**: AI-powered SLOs

### Error Budget
- **Sloth**: Prometheus SLO generator
- **OpenSLO**: Open standard for SLOs
- **SLO Generator**: Google Cloud SLO tools

## Related Documents

- [Monitoring & Observability Plan](../monitoring-observability-plan/_description.md) - Measurement infrastructure
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Reliability requirements
- [Incident Response Playbook](../incident-response-playbook/_description.md) - Responding to SLO violations
- [Architecture Overview](../architecture-overview/_description.md) - System design
- [Risk Register](../risk-register/_description.md) - Reliability risks

## Examples & References

### SLO Specification Template

```markdown
# SLO Specification: Payment API

## Service Information
- **Service**: Payment Processing API
- **Owner**: Payments Team
- **Tier**: Critical (Revenue-impacting)

## SLO 1: Availability

### SLI Definition
**Type**: Availability
**Description**: Proportion of successful HTTP requests

**Formula**:
```
count of requests returning 2xx/3xx / count of all requests
```

**Measurement**:
- Source: Load balancer access logs
- Exclusions: Health check endpoints, admin endpoints
- Window: Rolling 30 days

### SLO Target
- **Target**: 99.95%
- **Error Budget**: 0.05% = ~22 minutes/month

### Rationale
Based on historical analysis, service typically achieves 99.97%.
99.95% allows for planned maintenance and minor incidents while
maintaining customer satisfaction above 90% threshold.

## SLO 2: Latency

### SLI Definition
**Type**: Latency (p99)
**Description**: 99th percentile request duration for payment processing

**Formula**:
```
count of requests completing in <500ms / count of all requests
```

**Measurement**:
- Source: Application metrics
- Scope: /api/payments/process endpoint only
- Window: Rolling 30 days

### SLO Target
- **Target**: 99% of requests under 500ms
- **Error Budget**: 1% of requests may exceed 500ms

### Rationale
User research indicates payment latency >500ms significantly
impacts checkout completion rates. Historical p99 is ~350ms.

## Error Budget Policy

### Budget Consumption Thresholds
| Budget Remaining | Action |
|------------------|--------|
| >50% | Normal operations |
| 25-50% | Increased review of risky changes |
| 10-25% | Feature freeze for this service |
| <10% | All hands on reliability |

### Budget Reset
- Monthly rolling window
- No carryover of unused budget

## Alerting

### Error Budget Burn Rate Alerts
| Burn Rate | Window | Alert |
|-----------|--------|-------|
| 14.4x | 1 hour | Page on-call |
| 6x | 6 hours | Page on-call |
| 1x | 3 days | Slack notification |

## Review Schedule
- **Weekly**: Error budget consumption review
- **Monthly**: SLO target evaluation
- **Quarterly**: Full SLO specification review
```

### SLO Dashboard Metrics

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Availability (30d) | 99.97% | 99.95% | ✅ Healthy |
| P99 Latency (30d) | 98.5% | 99% | ⚠️ Warning |
| Error Budget Used | 42% | <100% | ✅ Healthy |
| Days Until Budget Exhausted | 18 | >7 | ✅ Healthy |

### SLI Query Examples

**Prometheus Availability SLI:**
```promql
sum(rate(http_requests_total{job="payment-api",status!~"5.."}[30d]))
/
sum(rate(http_requests_total{job="payment-api"}[30d]))
```

**Prometheus Latency SLI:**
```promql
sum(rate(http_request_duration_seconds_bucket{job="payment-api",le="0.5"}[30d]))
/
sum(rate(http_request_duration_seconds_count{job="payment-api"}[30d]))
```

### Further Reading

- [Google SRE Book - SLOs](https://sre.google/sre-book/service-level-objectives/)
- [Atlassian SLA vs SLO vs SLI](https://www.atlassian.com/incident-management/kpis/sla-vs-slo-vs-sli)
- [Dynatrace SLO Guide](https://www.dynatrace.com/news/blog/what-are-slos/)
- [Nobl9 SLO Best Practices](https://www.nobl9.com/service-level-objectives)
- "Implementing Service Level Objectives" - Alex Hidalgo
