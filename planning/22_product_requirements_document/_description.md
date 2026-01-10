# Product Requirements Document (PRD)

## Overview

A Product Requirements Document (PRD) is a comprehensive document that defines what a product should do, who it's for, and why it matters. It serves as the single source of truth for product teams, articulating objectives, features, functionality, user stories, and acceptance criteria. The PRD bridges strategy and execution, translating business goals and customer needs into actionable requirements for design and engineering teams.

## Purpose

- **Define requirements**: Clearly specify what needs to be built
- **Align stakeholders**: Create shared understanding across teams
- **Guide development**: Provide reference for design and engineering decisions
- **Reduce ambiguity**: Eliminate confusion about what's expected
- **Track progress**: Measure delivery against documented requirements
- **Enable estimation**: Support effort and timeline planning
- **Document decisions**: Record what was decided and why

## When to Create

- **Pre-Development**: Before design and engineering work begins
- **Feature Planning**: For each significant feature or initiative
- **Release Planning**: Aggregating requirements for a release
- **Ongoing Updates**: As a living document throughout development

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Primary author, owns the PRD |
| Engineering Lead | Reviews for feasibility, adds technical context |
| Design Lead | Contributes UX requirements, validates flows |
| QA Lead | Reviews acceptance criteria for testability |
| Stakeholders | Provide input on business requirements |
| Data/Analytics | Defines success metrics and tracking |

## Key Components

### 1. Overview
- Document status, owner, version
- Quick summary of what this PRD covers
- Link to related documents

### 2. Problem Statement
- What problem are we solving?
- Who has this problem?
- Why does it matter?

### 3. Objectives & Success Metrics
- What outcomes are we seeking?
- How will we measure success?
- Key performance indicators (KPIs)

### 4. User Context
- Target personas
- User scenarios and use cases
- Jobs-to-be-done

### 5. Scope
- What's included (in-scope)
- What's excluded (out-of-scope)
- Assumptions and constraints

### 6. Requirements
- Functional requirements (what the system does)
- Non-functional requirements (performance, security, etc.)
- User stories with acceptance criteria
- Wireframes or design references

### 7. Technical Considerations
- Architecture implications
- Dependencies and integrations
- Data requirements
- Technical constraints

### 8. Open Questions
- Unresolved issues
- Areas needing more research
- Decisions pending

### 9. Timeline & Milestones
- Key dates (if applicable)
- Dependencies
- Phased delivery plan

## PRD Styles

### Traditional PRD
- Comprehensive, detailed specification
- All requirements upfront
- Better for waterfall or regulated environments

### Lean/Agile PRD
- Living document that evolves
- Higher-level with linked user stories
- Just enough detail for the next iteration
- Emphasizes outcomes over specifications

### Feature Brief
- Lightweight single-feature documentation
- Links to larger product PRD
- Quick turnaround

## Inputs & Dependencies

- Product vision and strategy
- Scope Definition
- User research and personas
- Technical feasibility assessment
- Design explorations
- Competitive analysis
- Stakeholder requirements

## Outputs & Deliverables

- Comprehensive PRD document
- Linked user stories in backlog
- Design requirements and wireframes
- Technical specifications (or links to them)
- Success metrics dashboard
- Go/no-go decision support

## Best Practices

1. **Keep It Living**: PRDs should evolve—update as you learn.

2. **Link, Don't Duplicate**: Reference detailed docs rather than copying.

3. **Focus on "What" and "Why"**: Leave "How" to engineering.

4. **Make It Collaborative**: PRDs improve with input from all roles.

5. **Be Concise**: Long PRDs don't get read. Keep it scannable.

6. **Include Acceptance Criteria**: Clear criteria enable testing and validation.

7. **Use Visuals**: Wireframes, flowcharts, and diagrams communicate faster.

8. **Prioritize Requirements**: Not all requirements are equal—indicate priority.

9. **Track Changes**: Maintain version history for accountability.

## Common Pitfalls

- **Too Long**: PRDs that nobody reads because they're overwhelming
- **Too Detailed**: Prescribing implementation rather than outcomes
- **Static**: Not updating as understanding evolves
- **Missing "Why"**: Requirements without context for the problem
- **Untestable Criteria**: Acceptance criteria that can't be verified
- **Solo Author**: PRD written without cross-functional input
- **Feature Bloat**: Including requirements beyond scope
- **Missing Metrics**: No way to measure if requirements achieved goals

## Tools & Templates

### Documentation Tools
- **Notion**: Popular for modern PRDs
- **Confluence**: Standard for enterprise teams
- **Google Docs**: Simple, collaborative
- **Coda**: Flexible document/database hybrid

### Product Management Tools
- **Productboard**: PRDs connected to roadmap
- **Aha!**: Comprehensive requirements management
- **Linear**: Lightweight specs with issues

### Templates
- Product School PRD Template
- Aha! PRD Templates
- Notion PRD Templates
- Chisel PRD Templates

## Related Documents

- [Scope Definition](../scope-definition/_description.md) - What's included/excluded
- [User Stories & Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Detailed requirements
- [Goals & Non-Goals](../goals-and-non-goals/_description.md) - Objectives context
- [Wireframes](../wireframes/_description.md) - Visual requirements
- [Technical Discovery / Feasibility Notes](../technical-discovery-feasibility/_description.md) - Technical context
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Performance, security, etc.

## Examples & References

### PRD Structure Example

```
# [Feature/Product Name] PRD

## Meta
- **Status**: Draft | In Review | Approved
- **Owner**: [PM Name]
- **Last Updated**: [Date]
- **Related**: [Links to design, tech spec, etc.]

## 1. Overview
Brief 2-3 sentence summary of what this PRD covers.

## 2. Problem Statement
### Customer Pain Point
[Description of the problem]

### Evidence
- [User research finding]
- [Support ticket data]
- [Competitive gap]

## 3. Goals & Success Metrics
| Goal | Metric | Target |
|------|--------|--------|
| Reduce friction | Task completion rate | >90% |
| Improve satisfaction | NPS | +10 points |

## 4. Scope
### In Scope
- [Feature 1]
- [Feature 2]

### Out of Scope
- [Not included item] - Rationale

## 5. Requirements
### User Stories
As a [user], I want [action] so that [benefit].

**Acceptance Criteria:**
- [ ] Given [context], when [action], then [result]
- [ ] [Additional criteria]

### Non-Functional Requirements
- Page load < 2 seconds
- Support 1,000 concurrent users

## 6. Open Questions
- [ ] How will we handle edge case X?
- [ ] Pending legal review on feature Y
```

### Further Reading

- "The Only PRD Template You Need" - Product School
- "PRD Templates: What To Include for Success" - Aha!
- "How to Write a PRD: Your Complete Guide" - Perforce
- "What is a Product Requirements Document?" - Atlassian
- "Writing PRDs and Product Requirements" - Carlin Yuen
