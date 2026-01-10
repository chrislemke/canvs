# Non-Functional Requirements (NFRs)

## Overview

Non-Functional Requirements (NFRs) define how a system should behave, as opposed to what it should do. While functional requirements describe specific features and capabilities, NFRs specify the quality attributes, constraints, and operational characteristics that determine how well the system performs its functions. NFRs cover areas like performance, security, reliability, scalability, usability, and maintainability—the "-ilities" that determine whether a technically correct system is actually fit for purpose.

## Purpose

- **Define quality standards**: Establish measurable criteria for system quality
- **Guide architecture**: Inform technology choices and design patterns
- **Enable testing**: Provide testable acceptance criteria for quality attributes
- **Set expectations**: Align stakeholders on system behavior
- **Manage trade-offs**: Document constraints that require balancing
- **Support operations**: Define operational boundaries and requirements
- **Ensure fitness**: Guarantee the system meets real-world usage needs

## When to Create

- **Requirements Phase**: Early in project planning, alongside functional requirements
- **Architecture Design**: Before making technology decisions
- **Vendor Selection**: When evaluating platforms or services
- **Contract Negotiation**: For SLAs with customers or vendors
- **System Evolution**: When scaling or changing system characteristics
- **Compliance Projects**: When regulatory requirements apply

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Defines business-driven quality needs |
| Software Architect | Translates NFRs to technical requirements |
| DevOps/SRE | Defines operational requirements |
| Security Team | Specifies security requirements |
| QA/Testing | Validates NFRs are testable |
| Business Stakeholders | Approves trade-offs and priorities |

## Key Components

### 1. Performance Requirements
- Response time (latency)
- Throughput (transactions per second)
- Resource utilization (CPU, memory)
- Capacity requirements

### 2. Scalability Requirements
- Horizontal/vertical scaling needs
- Data volume growth projections
- User concurrency requirements
- Geographic distribution needs

### 3. Reliability Requirements
- Uptime targets (99.9%, 99.99%)
- Mean Time Between Failures (MTBF)
- Mean Time To Recovery (MTTR)
- Fault tolerance requirements

### 4. Availability Requirements
- Service level targets
- Maintenance windows
- Disaster recovery requirements
- Failover capabilities

### 5. Security Requirements
- Authentication/authorization needs
- Data encryption requirements
- Compliance constraints
- Audit logging requirements

### 6. Usability Requirements
- Accessibility standards (WCAG)
- Browser/device support
- Internationalization needs
- User training requirements

### 7. Maintainability Requirements
- Code quality standards
- Documentation requirements
- Deployment complexity limits
- Technical debt constraints

### 8. Portability Requirements
- Platform compatibility
- Data migration requirements
- Integration standards
- Vendor lock-in constraints

## Categories of NFRs (FURPS+)

| Category | Examples |
|----------|----------|
| **Functionality** | Security, interoperability |
| **Usability** | Accessibility, learnability, UX |
| **Reliability** | Availability, recoverability, accuracy |
| **Performance** | Speed, efficiency, throughput, capacity |
| **Supportability** | Maintainability, testability, configurability |
| **+** | Design constraints, implementation, interface, physical |

## Writing Testable NFRs

### SMART Criteria
- **Specific**: Clear and unambiguous
- **Measurable**: Quantifiable with metrics
- **Achievable**: Technically feasible
- **Relevant**: Aligned with business needs
- **Time-bound**: Specifies when/under what conditions

### Examples of Good vs Bad NFRs

| Bad | Good |
|-----|------|
| "System should be fast" | "95th percentile response time < 200ms under normal load" |
| "System must be secure" | "All PII encrypted at rest using AES-256" |
| "System should scale" | "Support 10,000 concurrent users with < 5% performance degradation" |
| "High availability required" | "99.95% uptime measured monthly, excluding planned maintenance" |

## Inputs & Dependencies

- Business requirements and constraints
- User expectations and SLAs
- Regulatory and compliance requirements
- Existing system baselines
- Industry benchmarks
- Technical constraints
- Budget and resource limitations

## Outputs & Deliverables

- NFR specification document
- Acceptance criteria for each NFR
- Test cases for NFR validation
- Architecture Decision Records (ADRs)
- SLO/SLI definitions
- Monitoring requirements
- Capacity planning inputs

## Best Practices

1. **Be Specific and Measurable**: Use numbers, not adjectives.

2. **Prioritize Ruthlessly**: Not all NFRs can be maximized; trade-offs are necessary.

3. **Link to Business Value**: Connect each NFR to business impact.

4. **Include Load Conditions**: Specify under what conditions requirements apply.

5. **Plan for Measurement**: Define how each NFR will be validated.

6. **Review with Stakeholders**: Ensure agreement on priorities and trade-offs.

7. **Consider the Lifecycle**: Include requirements for development, deployment, and operations.

8. **Document Trade-offs**: Explain why certain levels were chosen.

## Common Pitfalls

- **Vague Requirements**: "Fast" and "secure" without metrics
- **Unrealistic Targets**: Requiring 99.999% uptime without budget for it
- **Ignoring Trade-offs**: Treating all NFRs as equally important
- **Late Discovery**: Not defining NFRs until implementation
- **No Validation Plan**: NFRs that can't be tested
- **Static Thinking**: Not revisiting NFRs as system evolves
- **Copy-Paste Requirements**: Using generic requirements without context
- **Missing Operational NFRs**: Forgetting deployment, monitoring, support

## Tools

### Documentation
- **Confluence/Notion**: NFR documentation
- **JIRA**: NFR tracking as issues
- **Volere**: NFR template methodology

### Testing
- **k6, JMeter**: Performance testing
- **Gatling**: Load testing
- **Lighthouse**: Web performance/accessibility

### Monitoring
- **Datadog, New Relic**: Application performance monitoring
- **Grafana**: Metrics visualization
- **PagerDuty**: Alerting on NFR violations

## Related Documents

- [Product Requirements Document](../product-requirements-document/_description.md) - Functional requirements context
- [Architecture Overview](../architecture-overview/_description.md) - How NFRs influence architecture
- [SLO/SLI Definition](../slo-sli-definition/_description.md) - Operational NFR targets
- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Security-specific NFRs
- [Test Strategy](../test-strategy/_description.md) - NFR testing approach

## Examples & References

### NFR Template

```markdown
## NFR-001: API Response Time

**Category**: Performance
**Priority**: High

**Requirement**:
The API shall respond to 95% of requests within 200ms and 99% within 500ms under normal load conditions.

**Conditions**:
- Normal load: Up to 1,000 concurrent users
- Peak load: Up to 5,000 concurrent users (relaxed to 500ms/1s)

**Measurement**:
- Measured at the API gateway
- Excludes third-party service latency
- Monitored via Datadog APM

**Rationale**:
User research indicates response times > 500ms significantly impact conversion rates.

**Trade-offs**:
- May require caching layer investment
- Complex queries may need async processing
```

### NFR Specification Table

| ID | Category | Requirement | Target | Priority | Validation |
|----|----------|-------------|--------|----------|------------|
| NFR-001 | Performance | API response time | p95 < 200ms | High | Load test |
| NFR-002 | Availability | System uptime | 99.9% monthly | Critical | Monitoring |
| NFR-003 | Scalability | Concurrent users | 10,000 | Medium | Load test |
| NFR-004 | Security | Encryption at rest | AES-256 | High | Audit |
| NFR-005 | Usability | WCAG compliance | Level AA | Medium | Accessibility audit |

### Further Reading

- "Software Requirements" - Karl Wiegers
- "Non-Functional Requirements in Software Engineering" - Lawrence Chung
- "ISO/IEC 25010" - Software quality model standard
- "FURPS+ Model" - IBM Rational methodology
