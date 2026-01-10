# Architecture Overview (C4 or Equivalent)

## Overview

An Architecture Overview document provides a high-level visual and written description of a software system's structure. Using frameworks like the C4 model (Context, Containers, Components, Code), it captures how the system is organized, how components interact, and how it relates to external systems and users. This document bridges communication between technical and non-technical stakeholders, ensuring everyone understands how the system is built.

## Purpose

- **Communicate structure**: Visualize how the system is organized
- **Align understanding**: Create shared mental model across teams
- **Guide development**: Inform implementation decisions
- **Enable onboarding**: Help new team members understand the system
- **Support decision-making**: Provide context for architectural changes
- **Document for compliance**: Meet audit and regulatory requirements
- **Facilitate discussion**: Enable meaningful architecture conversations

## When to Create

- **New System Design**: Before building a new system
- **Major Changes**: When making significant architectural changes
- **Team Onboarding**: For new team member reference
- **Documentation Updates**: Regular maintenance of existing docs
- **External Review**: For audits, acquisitions, or partnerships
- **Strategic Planning**: When evaluating system capabilities

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Software Architect | Creates and maintains diagrams |
| Tech Lead | Contributes component-level detail |
| Development Team | Validates accuracy |
| DevOps/Platform | Documents infrastructure |
| Product Manager | Reviews for non-technical clarity |
| Security | Reviews security boundaries |

## C4 Model Levels

### Level 1: System Context
**Audience**: All stakeholders (technical and non-technical)
**Shows**:
- The system as a single box
- Users/personas who use it
- External systems it interacts with
- High-level relationships

### Level 2: Container Diagram
**Audience**: Technical stakeholders
**Shows**:
- Applications and data stores within the system
- Web apps, APIs, databases, message queues
- How containers communicate
- Technology choices

### Level 3: Component Diagram
**Audience**: Developers working on the system
**Shows**:
- Major structural building blocks within a container
- How components interact
- Key abstractions and responsibilities

### Level 4: Code Diagram
**Audience**: Developers needing detail
**Shows**:
- Class diagrams or equivalent
- Usually auto-generated from code
- Often skipped (too detailed to maintain)

## Additional C4 Diagrams

### System Landscape
- Shows all systems in an enterprise
- Useful for portfolio view

### Dynamic Diagram
- Shows runtime behavior
- Request/response flows
- Sequence of interactions

### Deployment Diagram
- Shows infrastructure
- Servers, cloud services, containers
- Network topology

## Key Components of Architecture Documentation

### 1. Context & Scope
- System boundaries
- Users and external systems
- What the system does (briefly)

### 2. Architectural Decisions
- Key technology choices
- Patterns applied
- Trade-offs made

### 3. Quality Attributes
- How architecture supports NFRs
- Scalability, security, reliability approaches

### 4. Diagrams
- C4 or equivalent visualizations
- Deployment views
- Data flow diagrams

### 5. Technology Stack
- Languages, frameworks, databases
- Cloud services
- Third-party integrations

## Inputs & Dependencies

- Product requirements
- Non-functional requirements
- Technical constraints
- Team capabilities
- Existing systems to integrate
- Security and compliance requirements

## Outputs & Deliverables

- C4 diagrams (Context, Container, Component)
- Deployment diagrams
- Architecture documentation
- Technology stack summary
- Integration map
- Living documentation in wiki/repo

## Best Practices

1. **Start with Context**: Begin at the highest level and zoom in.

2. **Keep It Up to Date**: Outdated architecture docs are dangerous.

3. **Use Standard Notation**: C4, UML, or consistent custom notation.

4. **Match Detail to Audience**: Different diagrams for different readers.

5. **Include a Legend**: Explain your notation and symbols.

6. **Version Control Diagrams**: Store in repo alongside code.

7. **Don't Over-Document**: Levels 1-2 are usually sufficient.

8. **Make It Accessible**: Store where team can find and update it.

## Common Pitfalls

- **Too Much Detail**: Creating diagrams nobody can understand
- **Too Abstract**: Missing important structural information
- **Static Documentation**: Not updating as system evolves
- **Inconsistent Notation**: Different symbols meaning different things
- **Missing Context**: Diagrams without explanation
- **Code-Level Only**: Only showing classes, not bigger picture
- **Inaccessible**: Diagrams locked in someone's laptop
- **No Tooling**: Hand-drawn diagrams that can't be updated

## Tools

### Diagramming
- **C4-specific**: Structurizr, IcePanel, C4-PlantUML
- **General**: Lucidchart, draw.io, Miro, Figma
- **As-code**: PlantUML, Mermaid, Structurizr DSL

### Documentation
- **Wikis**: Confluence, Notion, GitBook
- **Repos**: README.md, /docs folder

## Related Documents

- [Technical Discovery / Feasibility Notes](../technical-discovery-feasibility/_description.md) - Research informing architecture
- [API Specification](../api-specification/_description.md) - API design details
- [Data Model](../data-model/_description.md) - Database structure
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Architecture drivers
- [Integration Requirements](../integration-requirements/_description.md) - External system connections
- [Decision Log](../decision-log/_description.md) - Architecture Decision Records

## Examples & References

### C4 Context Diagram Example

```
                           ┌───────────────────────────────────────┐
                           │                                       │
                           │  ┌─────────────────────────────────┐  │
    ┌─────────┐            │  │                                 │  │
    │  User   │───────────▶│  │       E-Commerce System         │  │
    │(Person) │            │  │                                 │  │
    └─────────┘            │  └─────────────────────────────────┘  │
                           │                │                      │
                           │                │                      │
                           └────────────────│──────────────────────┘
                                            │
                                            ▼
              ┌──────────────────┐    ┌──────────────────┐
              │   Payment        │    │    Email         │
              │   Gateway        │    │    Provider      │
              │   (External)     │    │    (External)    │
              └──────────────────┘    └──────────────────┘
```

### C4 Container Diagram Example

```
┌────────────────────────────────────────────────────────────────┐
│                     E-Commerce System                          │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │ Web App     │    │ API         │    │ Worker      │        │
│  │ (React)     │───▶│ (Node.js)   │───▶│ (Node.js)   │        │
│  │ Port 443    │    │ Port 3000   │    │             │        │
│  └─────────────┘    └─────────────┘    └─────────────┘        │
│                            │                  │                │
│                            ▼                  ▼                │
│                     ┌─────────────┐    ┌─────────────┐        │
│                     │ PostgreSQL  │    │ Redis       │        │
│                     │ (Database)  │    │ (Cache)     │        │
│                     └─────────────┘    └─────────────┘        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Further Reading

- [C4 Model](https://c4model.com/) - Official C4 model documentation
- "The C4 Model for Software Architecture" - InfoQ
- "Understanding the C4 Model" - Sheldon Cohen, Medium
- "Software Architecture for Developers" - Simon Brown
