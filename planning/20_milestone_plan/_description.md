# Milestone Plan (MVP → Beta → GA)

## Overview

A Milestone Plan documents the key checkpoints and phases a product will progress through from initial concept to full market launch. It defines what must be achieved at each stage—typically MVP (Minimum Viable Product), Alpha, Beta, and GA (General Availability)—along with the criteria for advancement between stages. This plan provides stakeholders with visibility into the product journey and helps teams understand what "done" looks like at each phase.

## Purpose

- **Define phases**: Establish clear stages in the product development journey
- **Set expectations**: Communicate what will be delivered at each milestone
- **Gate decisions**: Create go/no-go checkpoints before major investments
- **Coordinate teams**: Align engineering, design, marketing, and support
- **Manage risk**: Incremental releases reduce risk of large failures
- **Enable learning**: Built-in feedback loops at each stage
- **Track progress**: Measure advancement toward launch

## When to Create

- **Project Kickoff**: At the start of product development
- **After Discovery**: Once scope and approach are defined
- **Planning Cycles**: During quarterly or annual planning
- **Strategic Reviews**: When presenting plans to leadership
- **Investor Updates**: When communicating product progress

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Defines milestones and criteria |
| Engineering Lead | Validates technical feasibility and timing |
| Design Lead | Ensures UX milestones are included |
| QA Lead | Defines quality gates for each phase |
| Marketing | Plans market-facing activities per milestone |
| Customer Success | Prepares for each phase of customer exposure |
| Leadership | Approves milestone definitions |

## Key Components

### 1. Milestone Definitions
Clear description of each phase and its purpose

### 2. Entry Criteria
What must be true to START this phase

### 3. Exit Criteria
What must be achieved to COMPLETE this phase

### 4. Deliverables
Specific outputs expected at each milestone

### 5. Audience
Who will use/see the product at this stage

### 6. Success Metrics
How success will be measured at each phase

### 7. Timeline (Optional)
Target dates if applicable

## Common Product Milestones

### Pre-MVP Milestones
- **Concept**: Problem and solution validated
- **Prototype**: Clickable prototype for testing
- **Technical Spike**: Feasibility confirmed

### MVP (Minimum Viable Product)
- Core features only—minimum set to test value proposition
- Internal users or very limited external users
- Focus on validating core assumptions
- Rough edges acceptable, core must work

### Alpha
- Feature-complete for core use cases
- Internal testing by team and trusted employees
- Bug discovery and major usability issues addressed
- Quality level: functional but not polished

### Private Beta
- Controlled external release to select customers
- Real-world usage data and feedback
- Performance and scale testing
- Quality level: stable for limited use

### Public Beta
- Broader external availability
- Pricing and packaging tested
- Support and documentation in place
- Quality level: ready for wider use with known limitations

### GA (General Availability)
- Full public launch
- All features complete and polished
- Full support and documentation
- Marketing and sales enabled
- Quality level: production-ready

### Post-GA
- Iterations based on launch feedback
- Feature expansion
- Scale improvements

## Inputs & Dependencies

- Product vision and strategy
- Scope Definition (MVP scope)
- Technical architecture and feasibility
- Resource availability
- Market timing requirements
- Quality and compliance requirements
- Go-to-market planning

## Outputs & Deliverables

- Milestone plan document
- Phase-gate checklist for each milestone
- Timeline visualization (Gantt or roadmap)
- Success metrics dashboard
- Go/no-go decision framework
- Stakeholder communication plan

## Best Practices

1. **Define Clear Criteria**: Ambiguous milestone criteria lead to endless debates.

2. **Be Realistic About MVP**: The "M" in MVP is minimum—resist feature creep.

3. **Include Quality Gates**: Each phase should have explicit quality requirements.

4. **Plan for Feedback Loops**: Build time for learning and iteration between phases.

5. **Involve All Functions**: Milestones aren't just about engineering.

6. **Document Decisions**: Record what's included and excluded at each milestone.

7. **Communicate Widely**: Keep stakeholders updated on milestone progress.

8. **Stay Flexible on Dates**: Scope and quality matter more than hitting dates.

## Common Pitfalls

- **MVP Bloat**: Adding features that don't test core hypotheses
- **Skipping Stages**: Rushing from Alpha to GA without proper beta
- **Vague Criteria**: "It's ready when it's ready" doesn't help anyone
- **Quality Debt**: Accumulating bugs that block later milestones
- **Ignoring Feedback**: Not incorporating beta feedback before GA
- **Marketing Timing**: Marketing not aligned with technical readiness
- **Support Readiness**: Launching without adequate support preparation
- **Date-Driven**: Hitting dates at expense of quality and scope

## Tools & Templates

- **Project Management**: Jira, Linear, Asana with milestone features
- **Visualization**: Gantt charts, roadmap tools
- **Documentation**: Confluence, Notion for milestone criteria
- **Checklists**: Google Sheets, Notion for gate checklists

## Related Documents

- [Scope Definition](../scope-definition/_description.md) - What's in each milestone
- [High-Level Product Roadmap](../high-level-product-roadmap/_description.md) - Strategic context
- [Product Requirements Document](../product-requirements-document/_description.md) - Detailed requirements
- [Launch Readiness Checklist](../launch-readiness-checklist/_description.md) - GA readiness criteria
- [Test Strategy](../test-strategy/_description.md) - Quality gates per milestone
- [Beta Program Plan](../beta-program-plan/_description.md) - Beta phase details

## Examples & References

### Milestone Plan Example

```
MILESTONE        │ SCOPE           │ AUDIENCE        │ EXIT CRITERIA
─────────────────┼─────────────────┼─────────────────┼─────────────────
MVP              │ Core workflow   │ 10 internal     │ ✓ Core flow works
(Month 2)        │ only            │ users           │ ✓ 3+ use cases tested
                 │                 │                 │ ✓ Core value validated
─────────────────┼─────────────────┼─────────────────┼─────────────────
Alpha            │ All v1 features │ Full team +     │ ✓ All features work
(Month 4)        │                 │ 20 friendlies   │ ✓ No P0 bugs
                 │                 │                 │ ✓ <3s load time
─────────────────┼─────────────────┼─────────────────┼─────────────────
Private Beta     │ v1 + key        │ 50 customers    │ ✓ NPS > 30
(Month 5)        │ integrations    │ (invite-only)   │ ✓ <5% churn
                 │                 │                 │ ✓ Support trained
─────────────────┼─────────────────┼─────────────────┼─────────────────
Public Beta      │ Full v1         │ Public signup   │ ✓ 500+ users
(Month 7)        │                 │ with waitlist   │ ✓ 99.5% uptime
                 │                 │                 │ ✓ Pricing validated
─────────────────┼─────────────────┼─────────────────┼─────────────────
GA               │ Production-     │ General public  │ ✓ All docs complete
(Month 8)        │ ready           │                 │ ✓ Marketing ready
                 │                 │                 │ ✓ Sales enabled
```

### Phase Gate Checklist (Beta → GA Example)

**Product Readiness**
- [ ] All P0/P1 bugs resolved
- [ ] Performance meets SLOs
- [ ] Security review complete
- [ ] Accessibility audit passed

**Commercial Readiness**
- [ ] Pricing finalized
- [ ] Billing system tested
- [ ] Terms of service approved
- [ ] Privacy policy updated

**Go-to-Market Readiness**
- [ ] Website updated
- [ ] Press materials ready
- [ ] Sales team trained
- [ ] Support documentation complete

### Further Reading

- "MVP Development Roadmap: Key Milestones and Deliverables" - F22 Labs
- "Roadmap Milestones: Definitions and Examples for PMs" - Aha!
- "The Product Development Journey: From Discovery to Launch" - Walturn
- "How to Use Product Roadmap Milestones" - Visor
