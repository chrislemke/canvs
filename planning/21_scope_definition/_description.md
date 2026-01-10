# Scope Definition (MVP Scope + Out-of-Scope)

## Overview

A Scope Definition document clearly articulates what will and will not be included in a product release, with particular emphasis on MVP (Minimum Viable Product) scope. It distinguishes between "must-have" features essential to test the core value proposition and "nice-to-have" features that can wait for later releases. By explicitly documenting both in-scope and out-of-scope items, this document prevents scope creep, aligns stakeholders, and enables focused execution.

## Purpose

- **Focus development**: Concentrate resources on what matters most
- **Prevent scope creep**: Establish clear boundaries that resist expansion
- **Align stakeholders**: Create shared understanding of deliverables
- **Manage expectations**: Be explicit about what won't be included
- **Enable estimation**: Clear scope enables more accurate estimates
- **Speed delivery**: Less scope means faster time-to-market
- **Reduce risk**: Smaller scope reduces complexity and risk

## When to Create

- **Discovery Phase**: After research, before development begins
- **MVP Definition**: When defining the minimum viable product
- **Release Planning**: Before each major release
- **Scope Negotiations**: When resources or timeline are constrained
- **Stakeholder Alignment**: When expectations need to be managed

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Leads scope definition and prioritization |
| Engineering Lead | Validates feasibility, identifies dependencies |
| Design Lead | Ensures UX coherence at the scoped level |
| Stakeholders | Provide input, approve final scope |
| QA Lead | Ensures scope is testable |
| Business Owner | Validates business requirements are met |

## Key Components

### 1. Purpose Statement
Why this scope is being defined (MVP, v2, specific release)

### 2. Success Criteria
How we'll know if this scope achieves its goals

### 3. In-Scope (Must-Have)
Features absolutely required for this release:
- Core functionality
- Essential user flows
- Minimum quality requirements
- Critical integrations

### 4. In-Scope (Should-Have)
Features included if time/resources allow:
- Important but not critical
- Enhanced versions of must-haves
- Secondary user flows

### 5. Out-of-Scope (Won't-Have - This Release)
Explicitly excluded items:
- Features deferred to later releases
- Functionality beyond current priorities
- Nice-to-have enhancements

### 6. Out-of-Scope (Won't-Have - Ever)
Things this product will never do:
- Clarifies product boundaries
- Prevents recurring discussions

### 7. Dependencies & Constraints
External factors affecting scope:
- Technical dependencies
- Resource constraints
- Timeline requirements
- Third-party limitations

### 8. Risks
Risks associated with this scope:
- What might force scope changes
- What's uncertain

## Prioritization Frameworks

### MoSCoW Method
- **Must**: Essential for release
- **Should**: Important but not critical
- **Could**: Nice to have
- **Won't**: Not this release

### RICE Scoring
- **Reach**: How many users affected
- **Impact**: How much it affects them
- **Confidence**: How sure are we
- **Effort**: How much work is required

### Value vs. Effort Matrix
- High value, low effort → Do first
- High value, high effort → Plan carefully
- Low value, low effort → Do if time
- Low value, high effort → Don't do

## Inputs & Dependencies

- Product vision and strategy
- Goals & Non-Goals
- User research and Jobs-to-be-Done
- Technical feasibility assessment
- Resource and timeline constraints
- Stakeholder requirements
- Competitive analysis

## Outputs & Deliverables

- Scope definition document
- Feature list with prioritization
- Out-of-scope list with rationale
- Dependencies and risks register
- Stakeholder sign-off
- Input for PRD and user stories

## Best Practices

1. **Start with Value**: Focus on what validates the core hypothesis.

2. **Be Ruthless About "Must"**: Everything feels important—prioritize brutally.

3. **Document Out-of-Scope**: Explicit exclusions prevent future arguments.

4. **Include Rationale**: Explain WHY things are in or out.

5. **Get Sign-Off**: Ensure stakeholders formally agree to scope.

6. **Revisit After Discovery**: Scope should reflect what you learned in research.

7. **Protect the MVP**: Resist pressure to add "just one more thing."

8. **Plan for Later**: Out-of-scope isn't never—it's "not now."

## Common Pitfalls

- **Feature Creep**: Allowing scope to expand without proper review
- **Vague Boundaries**: Unclear definitions of what's in vs. out
- **MVP Bloat**: Adding features that don't test core value
- **No Rationale**: Decisions without documented reasoning
- **Verbal Agreements**: Not getting formal sign-off on scope
- **Ignoring Dependencies**: Not accounting for technical prerequisites
- **Perfection Over Progress**: Holding back release for polish
- **Stakeholder Surprises**: Not communicating what's excluded

## Tools & Templates

- **Documentation**: Notion, Confluence, Google Docs
- **Prioritization**: Productboard, Aha!, spreadsheets with scoring
- **Collaboration**: Miro for scope workshops
- **Tracking**: Jira, Linear for scope management

## Related Documents

- [Goals & Non-Goals](../goals-and-non-goals/_description.md) - Strategic context for scope
- [Product Requirements Document](../product-requirements-document/_description.md) - Detailed requirements
- [High-Level Product Roadmap](../high-level-product-roadmap/_description.md) - Where out-of-scope items go
- [Milestone Plan](../milestone-plan/_description.md) - Scope per milestone
- [User Stories & Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Scope detail

## Examples & References

### MVP Scope Document Example

```
PROJECT: Customer Portal v1.0 (MVP)
DATE: Q1 2025
GOAL: Validate that customers will self-serve common support tasks

SUCCESS CRITERIA:
- 20% of support tickets deflected to self-serve
- NPS > 30 for portal experience
- <3 min average task completion time

┌─────────────────────────────────────────────────────────────────┐
│ IN-SCOPE (MUST-HAVE)                                            │
├─────────────────────────────────────────────────────────────────┤
│ ✓ User authentication (SSO)                                     │
│ ✓ View account status and usage                                 │
│ ✓ Download invoices (last 12 months)                            │
│ ✓ Update billing information                                    │
│ ✓ Submit and track support tickets                              │
│ ✓ Mobile-responsive design                                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ IN-SCOPE (SHOULD-HAVE, IF TIME PERMITS)                         │
├─────────────────────────────────────────────────────────────────┤
│ ○ Usage analytics dashboard                                     │
│ ○ Email notifications for ticket updates                        │
│ ○ Knowledge base search                                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ OUT-OF-SCOPE (v1.0 - Planned for v2.0)                         │
├─────────────────────────────────────────────────────────────────┤
│ ✗ Live chat with support agents                                 │
│   Rationale: Requires staffing changes, separate initiative     │
│                                                                  │
│ ✗ User management / team features                               │
│   Rationale: Adds complexity; single-user MVP first             │
│                                                                  │
│ ✗ Custom branding / white-label                                 │
│   Rationale: Enterprise feature, not needed to validate core    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ OUT-OF-SCOPE (NOT PLANNED)                                      │
├─────────────────────────────────────────────────────────────────┤
│ ✗ Direct payment processing                                     │
│   Rationale: Already handled in main app                        │
│                                                                  │
│ ✗ Native mobile apps                                            │
│   Rationale: Mobile web sufficient for this use case            │
└─────────────────────────────────────────────────────────────────┘
```

### Further Reading

- "MVP Scope: How to Define Your Minimum Viable Product in 4 Steps" - Lemberg Solutions
- "MVP Scoping: When and How to Do It Right" - Upsilon IT
- "How to Define an MVP Scope in 3 Hours" - Toptal
- "5 Essential Steps to Define Minimum Viable Product Scope" - OneSeven Tech
- "Minimum Viable Product: Types, Methods, and Building Stages" - AltexSoft
