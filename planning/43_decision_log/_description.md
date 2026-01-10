# Decision Log (ADRs / Architecture Decision Records)

## Overview

A Decision Log, commonly implemented as Architecture Decision Records (ADRs), is a collection of documents that capture important technical and architectural decisions made during a project's lifecycle. Each record documents the context, rationale, alternatives considered, and consequences of a decision. ADRs create an institutional memory that helps current and future team members understand why the system was built the way it was.

## Purpose

- **Capture context**: Record the circumstances and constraints that led to decisions
- **Document rationale**: Explain why specific choices were made over alternatives
- **Enable onboarding**: Help new team members understand historical decisions
- **Prevent re-litigation**: Avoid repeatedly discussing settled decisions
- **Support evolution**: Provide context for future changes or reversals
- **Create accountability**: Track who made decisions and when
- **Facilitate reviews**: Enable architectural review and governance

## When to Create

- **Architecture Decisions**: When making significant structural choices
- **Technology Selection**: When choosing languages, frameworks, or tools
- **Pattern Adoption**: When implementing design patterns
- **Trade-off Decisions**: When weighing competing concerns
- **Standard Deviations**: When deviating from established patterns
- **Reversals**: When changing or superseding previous decisions
- **Cross-Team Impact**: When decisions affect multiple teams

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Software Architect | Authors and reviews ADRs |
| Tech Lead | Proposes and documents team decisions |
| Senior Engineers | Contribute to decision-making, review ADRs |
| Development Team | Implements decisions, provides input |
| Engineering Manager | Approves significant decisions |
| Product Manager | Provides business context for decisions |

## Key Components

### 1. Title
- Clear, descriptive name
- Often prefixed with number (ADR-001)
- Action-oriented or descriptive

### 2. Status
- **Proposed**: Under discussion
- **Accepted**: Approved and in effect
- **Deprecated**: No longer recommended
- **Superseded**: Replaced by another ADR

### 3. Context
- Problem being addressed
- Constraints and requirements
- Forces at play
- Current situation

### 4. Decision
- The choice that was made
- Clear, unambiguous statement
- What will be done

### 5. Consequences
- Positive outcomes expected
- Negative trade-offs accepted
- Neutral effects
- Future considerations

### 6. Alternatives Considered
- Other options evaluated
- Why they were rejected
- Comparison criteria

## ADR Templates

### Nygard Template (Original)
The most widely used, minimal format:
- Title
- Status
- Context
- Decision
- Consequences

### MADR (Markdown ADR)
More comprehensive format with:
- Title and status
- Context and problem statement
- Decision drivers
- Considered options
- Decision outcome
- Pros and cons of each option

### Y-Statement Template
Decision-focused format:
"In the context of [situation], facing [concern], we decided [decision] to achieve [goal], accepting [trade-offs]."

## ADR Lifecycle

```
Initiating → Researching → Evaluating → Implementing → Maintaining → Sunsetting
```

- **Initiating**: Identify need for decision
- **Researching**: Gather options and information
- **Evaluating**: Compare alternatives, discuss
- **Implementing**: Document and apply decision
- **Maintaining**: Keep ADR current
- **Sunsetting**: Deprecate or supersede when no longer relevant

## Inputs & Dependencies

- Technical requirements and constraints
- System architecture context
- Team expertise and preferences
- Organizational standards
- Previous ADRs in the log
- Industry best practices
- Proof-of-concept results

## Outputs & Deliverables

- Individual ADR documents
- Centralized ADR repository
- Decision timeline
- Architecture rationale documentation
- Onboarding reference material
- Audit trail for compliance

## Best Practices

1. **Focus on Single Decision**: Keep each ADR focused on one decision.

2. **Centralize Storage**: Store ADRs in a location accessible to all team members.

3. **Version Control**: Keep ADRs in the same repository as code.

4. **Write Promptly**: Document decisions while context is fresh.

5. **Include Alternatives**: Show what was considered but not chosen.

6. **Keep Status Updated**: Mark ADRs as superseded when replaced.

7. **Link Related ADRs**: Cross-reference related decisions.

8. **Make Immutable**: Don't edit old ADRs; create new ones to supersede.

## Common Pitfalls

- **Too Detailed**: Over-documenting minor decisions
- **Too Vague**: Not enough context to understand rationale
- **No Follow-Through**: Decisions made but not documented
- **Stale Records**: Not updating status when decisions change
- **Hidden ADRs**: Storing where team can't find them
- **Design Documents Confused**: Mixing exploration with decision
- **No Review Process**: ADRs created without team input
- **Ignoring History**: Not checking existing ADRs before new decisions

## Tools

### ADR Tools
- **adr-tools**: Command-line tool for managing ADRs
- **Log4brains**: ADR management with web UI
- **ADR Manager**: VS Code extension

### Storage
- **Git Repository**: Markdown files in `/docs/adr/` or `/adr/`
- **Confluence**: Wiki-based documentation
- **Notion**: Collaborative documentation

### Templates
- **MADR Templates**: GitHub-hosted templates
- **adr.github.io**: Community templates and resources

## Related Documents

- [Architecture Overview](../architecture-overview/_description.md) - Architectural context
- [Technical Discovery / Feasibility](../technical-discovery-feasibility/_description.md) - Research informing decisions
- [Risk Register](../risk-register/_description.md) - Risk-related decisions
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Constraints on decisions

## Examples & References

### Basic ADR Template

```markdown
# ADR-001: Use PostgreSQL as Primary Database

## Status
Accepted

## Context
We need to choose a primary database for the application.
Requirements include:
- ACID compliance for financial transactions
- JSON support for flexible schema portions
- Strong ecosystem and tooling
- Team familiarity

## Decision
We will use PostgreSQL as our primary database.

## Consequences
### Positive
- Full ACID compliance
- Excellent JSON/JSONB support
- Strong community and documentation
- Team has existing expertise

### Negative
- Requires more operational expertise than managed solutions
- Scaling horizontally is more complex than NoSQL

### Neutral
- Will use managed PostgreSQL service (AWS RDS) to reduce ops burden
```

### MADR Template

```markdown
# Use React for Frontend Framework

## Status
Accepted

## Context and Problem Statement
We need to select a frontend framework for our SPA. The team has
varying levels of experience with different frameworks.

## Decision Drivers
* Developer productivity
* Component ecosystem
* Hiring pool availability
* Long-term maintainability

## Considered Options
1. React
2. Vue.js
3. Angular
4. Svelte

## Decision Outcome
Chosen option: **React**, because it best balances our decision
drivers with the largest ecosystem and hiring pool.

## Pros and Cons of Options

### React
* Good, large ecosystem and community
* Good, most team members have experience
* Bad, requires additional libraries for state management
* Bad, JSX learning curve for some developers

### Vue.js
* Good, gentle learning curve
* Good, excellent documentation
* Bad, smaller ecosystem than React
* Bad, fewer team members with experience
```

### ADR Index Example

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| ADR-001 | Use PostgreSQL as Primary Database | Accepted | 2024-01-15 |
| ADR-002 | Adopt React for Frontend | Accepted | 2024-01-18 |
| ADR-003 | Use REST over GraphQL | Accepted | 2024-01-22 |
| ADR-004 | Switch to GraphQL for Mobile API | Accepted | 2024-06-01 |
| ADR-003 | Use REST over GraphQL | Superseded by ADR-004 | 2024-06-01 |

### Further Reading

- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) - Michael Nygard's original post
- [ADR GitHub Organization](https://adr.github.io/) - Community resources
- [AWS Prescriptive Guidance on ADRs](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html)
- [MADR Templates](https://adr.github.io/madr/)
- "Design It!" - Michael Keeling (includes ADR chapter)
