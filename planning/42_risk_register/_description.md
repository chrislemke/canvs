# Risk Register

## Overview

A Risk Register (also called a Risk Log) is a comprehensive document that identifies, assesses, and tracks risks throughout a project or product lifecycle. It serves as the central repository for all identified risks, their analysis, mitigation strategies, and current status. The risk register enables proactive risk management by making risks visible, ensuring they're addressed systematically, and providing accountability for risk ownership.

## Purpose

- **Identify risks**: Capture potential threats and opportunities
- **Assess impact**: Evaluate likelihood and consequences
- **Track status**: Monitor risk evolution over time
- **Assign ownership**: Ensure accountability for risk management
- **Enable decisions**: Inform project and product decisions
- **Communicate**: Share risk awareness across stakeholders
- **Support compliance**: Document due diligence in risk management
- **Learn**: Build organizational knowledge about risks

## When to Create

- **Project Kickoff**: Initialize at project start
- **Sprint/Phase Planning**: Review and update regularly
- **Major Decisions**: Before significant commitments
- **Risk Events**: When new risks are identified
- **Incident Response**: After incidents to capture lessons
- **Stakeholder Reviews**: For governance and oversight
- **Audits**: For compliance demonstration

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Project/Product Manager | Maintains risk register, facilitates reviews |
| Risk Owners | Responsible for individual risk mitigation |
| Technical Lead | Identifies and assesses technical risks |
| Security Team | Contributes security-related risks |
| Business Stakeholders | Provide business risk context |
| Executive Sponsor | Approves risk appetite and major decisions |

## Key Components

### 1. Risk Identification
- Risk ID (unique identifier)
- Risk title/name
- Detailed description
- Category/type
- Date identified
- Identified by

### 2. Risk Assessment
- Likelihood/probability rating
- Impact/consequence rating
- Risk score (likelihood × impact)
- Risk level (Critical, High, Medium, Low)
- Affected areas/assets

### 3. Risk Response
- Response strategy (Avoid, Mitigate, Transfer, Accept)
- Mitigation actions
- Contingency plan
- Residual risk level

### 4. Ownership & Tracking
- Risk owner
- Action owners
- Due dates
- Current status
- Last review date
- Trend (increasing, stable, decreasing)

## Risk Categories

### Technical Risks
- Technology failures
- Integration challenges
- Performance issues
- Security vulnerabilities
- Technical debt

### Project Risks
- Schedule delays
- Budget overruns
- Scope creep
- Resource constraints
- Dependency failures

### Business Risks
- Market changes
- Competitive threats
- Regulatory changes
- Stakeholder changes
- Strategic shifts

### Operational Risks
- Process failures
- Vendor issues
- Infrastructure problems
- Support challenges
- Knowledge gaps

### External Risks
- Economic conditions
- Legal/regulatory changes
- Natural disasters
- Geopolitical events
- Pandemic/health crises

## Risk Assessment Matrix

### Likelihood Scale
| Rating | Level | Description |
|--------|-------|-------------|
| 5 | Almost Certain | >90% probability |
| 4 | Likely | 61-90% probability |
| 3 | Possible | 31-60% probability |
| 2 | Unlikely | 10-30% probability |
| 1 | Rare | <10% probability |

### Impact Scale
| Rating | Level | Description |
|--------|-------|-------------|
| 5 | Catastrophic | Project failure, major loss |
| 4 | Major | Significant delay/cost, quality impact |
| 3 | Moderate | Manageable impact, workarounds needed |
| 2 | Minor | Small impact, easily addressed |
| 1 | Negligible | Minimal impact |

### Risk Score Matrix

|  | Impact 1 | Impact 2 | Impact 3 | Impact 4 | Impact 5 |
|--|----------|----------|----------|----------|----------|
| **Likelihood 5** | 5 (M) | 10 (M) | 15 (H) | 20 (C) | 25 (C) |
| **Likelihood 4** | 4 (L) | 8 (M) | 12 (H) | 16 (H) | 20 (C) |
| **Likelihood 3** | 3 (L) | 6 (M) | 9 (M) | 12 (H) | 15 (H) |
| **Likelihood 2** | 2 (L) | 4 (L) | 6 (M) | 8 (M) | 10 (M) |
| **Likelihood 1** | 1 (L) | 2 (L) | 3 (L) | 4 (L) | 5 (M) |

(C = Critical, H = High, M = Medium, L = Low)

## Risk Response Strategies

| Strategy | Description | When to Use |
|----------|-------------|-------------|
| **Avoid** | Eliminate the risk entirely | High impact, avoidable cause |
| **Mitigate** | Reduce likelihood or impact | Risk can be controlled |
| **Transfer** | Shift risk to third party | Insurance, contracts |
| **Accept** | Acknowledge and monitor | Low impact or unavoidable |
| **Exploit** (Opportunities) | Take advantage of positive risk | Beneficial uncertainty |

## Inputs & Dependencies

- Project plans and scope
- Technical architecture
- Stakeholder concerns
- Historical project data
- Industry risk databases
- Threat assessments
- Compliance requirements
- Previous lessons learned

## Outputs & Deliverables

- Risk register document/spreadsheet
- Risk dashboard/visualizations
- Top risks report for leadership
- Risk trend analysis
- Mitigation action plans
- Updated project plans
- Input to decision-making

## Best Practices

1. **Regular Reviews**: Update risk register weekly or bi-weekly.

2. **Assign Ownership**: Every risk needs a specific owner.

3. **Be Specific**: Describe risks clearly with cause and effect.

4. **Quantify When Possible**: Use data to support assessments.

5. **Track Actions**: Mitigation plans need due dates and owners.

6. **Report Trends**: Show how risks are evolving over time.

7. **Involve the Team**: Risk identification is everyone's job.

8. **Celebrate Closures**: Acknowledge when risks are successfully mitigated.

## Common Pitfalls

- **Set and Forget**: Not reviewing/updating regularly
- **Too Generic**: Vague risk descriptions without specifics
- **No Ownership**: Risks without assigned owners
- **Analysis Paralysis**: Over-analyzing minor risks
- **Blind Spots**: Missing categories of risks
- **No Action**: Risks identified but never mitigated
- **Single Viewpoint**: Not gathering diverse perspectives
- **Risk Fatigue**: Register becomes too large to be useful

## Tools

### Spreadsheet-Based
- **Excel/Google Sheets**: Simple, accessible
- **Airtable**: More structured spreadsheet alternative
- **Notion**: Flexible database approach

### Project Management
- **Jira**: Risk tracking as issues
- **Asana**: Risk as project tasks
- **Monday.com**: Risk management templates

### Specialized GRC Tools
- **LogicGate**: Risk management platform
- **Resolver**: Enterprise risk management
- **RiskWatch**: Risk assessment software
- **ServiceNow GRC**: Enterprise GRC

### Visualization
- **Power BI/Tableau**: Risk dashboards
- **Miro**: Risk mapping and workshops

## Related Documents

- [Threat Model](../threat-model/_description.md) - Security risk analysis
- [Compliance Assessment](../compliance-assessment/_description.md) - Compliance risks
- [Technical Discovery / Feasibility](../technical-discovery-feasibility/_description.md) - Technical risk exploration
- [Decision Log](../decision-log/_description.md) - Risk-informed decisions
- [Postmortem Template](../postmortem-template/_description.md) - Realized risks

## Examples & References

### Risk Register Template

| ID | Risk | Category | Likelihood | Impact | Score | Level | Response | Mitigation | Owner | Status | Due Date |
|----|------|----------|------------|--------|-------|-------|----------|------------|-------|--------|----------|
| R-001 | Key engineer leaves | Resource | 3 | 4 | 12 | High | Mitigate | Cross-training, documentation | TL | Open | Ongoing |
| R-002 | API vendor deprecation | Technical | 2 | 5 | 10 | Medium | Avoid | Build abstraction layer | Arch | In Progress | 2024-03-15 |
| R-003 | GDPR fine for data breach | Compliance | 2 | 5 | 10 | Medium | Mitigate | Security audit, encryption | Security | Open | 2024-02-28 |
| R-004 | Third-party API outage | Operational | 4 | 3 | 12 | High | Accept | Implement graceful degradation | DevOps | Monitoring | N/A |

### Detailed Risk Entry Example

```markdown
## Risk: R-2024-015

### Basic Information
- **Title**: Database Performance Degradation Under Load
- **Category**: Technical / Performance
- **Date Identified**: 2024-01-15
- **Identified By**: Backend Team
- **Risk Owner**: Database Administrator

### Risk Description
As user growth continues, the primary database may experience
performance degradation during peak hours, leading to increased
latency and potential timeout errors for end users.

### Assessment
- **Likelihood**: 4 (Likely) - Based on current growth trajectory
- **Impact**: 4 (Major) - User experience degradation, potential churn
- **Risk Score**: 16 (High)

### Root Causes
- Single primary database handling all read/write operations
- Growing data volume without archival strategy
- Unoptimized queries identified in recent reviews

### Response Strategy: Mitigate

### Mitigation Actions
| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Implement read replicas | DBA | 2024-02-01 | In Progress |
| Query optimization sprint | Backend | 2024-02-15 | Planned |
| Data archival strategy | DBA | 2024-03-01 | Planned |
| Caching layer implementation | Backend | 2024-03-15 | Planned |

### Contingency Plan
If performance issues occur before mitigation:
1. Scale up database instance (30-minute process)
2. Enable emergency query throttling
3. Communicate with users about known issues

### Residual Risk
After mitigation: Likelihood 2, Impact 3, Score 6 (Medium)

### Tracking
- **Status**: Active - In Mitigation
- **Trend**: Stable (was Increasing)
- **Last Review**: 2024-01-22
- **Next Review**: 2024-01-29
```

### Risk Dashboard Metrics

| Metric | Value |
|--------|-------|
| Total Open Risks | 24 |
| Critical Risks | 2 |
| High Risks | 6 |
| Risks Added This Month | 4 |
| Risks Closed This Month | 3 |
| Overdue Mitigations | 2 |
| Average Days to Close | 21 |

### Further Reading

- "Project Risk Management: A Practical Implementation Approach" - PMI
- "Managing Risk in Organizations" - J. Davidson Frame
- ISO 31000: Risk Management Guidelines
- PMBOK Guide - Risk Management Knowledge Area
- "Waltzing with Bears: Managing Risk on Software Projects" - DeMarco & Lister
