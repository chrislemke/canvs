# Goals & Non-Goals

## Overview

A Goals & Non-Goals document explicitly defines what a product, project, or initiative aims to achieve and—equally important—what it intentionally chooses NOT to pursue. Non-goals are not simply "things we're not doing" but rather deliberate choices to exclude certain outcomes, features, or scope areas to maintain focus and manage expectations. This document creates transparency about project boundaries and helps teams stay focused on what truly matters.

## Purpose

- **Control scope**: Prevent scope creep by clearly defining boundaries
- **Increase transparency**: Make implicit assumptions explicit
- **Focus the team**: Keep effort concentrated on the highest-priority outcomes
- **Manage expectations**: Help stakeholders understand what to expect (and not expect)
- **Enable trade-off discussions**: Provide framework for priority conversations
- **Reduce ambiguity**: Eliminate grey areas about what's included
- **Speed up decisions**: Make it easy to say "no" to out-of-scope requests

## When to Create

- **Project Kickoff**: At the beginning of any significant initiative
- **PRD Creation**: As a core component of product requirements
- **Sprint Planning**: When defining scope for development cycles
- **Stakeholder Alignment**: When expectations need to be managed
- **Scope Negotiations**: When requests exceed available resources
- **Post-Discovery**: After user research reveals prioritization needs

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Primary author, defines and prioritizes goals |
| Engineering Lead | Validates feasibility, contributes technical perspective |
| Design Lead | Ensures goals reflect user outcomes |
| Stakeholders | Review and approve scope boundaries |
| Project Manager | Uses for scope management and planning |
| Team Members | Reference for daily decision-making |

## Key Components

### 1. Goals
Clear statements of what the project aims to achieve:
- **Outcome-focused**: What result or change are we seeking?
- **Measurable**: How will we know we've succeeded?
- **Prioritized**: Which goals are most critical?

### 2. Non-Goals
Explicit statements of what we are NOT trying to do:
- **Intentional exclusions**: Things deliberately out of scope
- **Future considerations**: Things we might do later, but not now
- **Grey areas**: Clarification on potentially ambiguous scope items

### 3. Rationale
Brief explanation of WHY certain items are non-goals:
- Resource constraints
- Strategic focus
- Sequencing decisions
- Risk mitigation

### 4. Review Triggers
Conditions under which non-goals might be reconsidered:
- New information
- Changed priorities
- Completed prerequisites

## Inputs & Dependencies

- Vision Statement and product strategy
- User research and problem statement
- Resource constraints and timelines
- Stakeholder requirements and priorities
- Technical feasibility assessments
- Competitive analysis
- Risk assessment

## Outputs & Deliverables

- Prioritized list of goals with success criteria
- Documented non-goals with rationale
- Scope agreement with stakeholders
- Input for PRDs and sprint planning
- Reference document for scope discussions
- Communication material for team alignment

## Best Practices

1. **Define Non-Goals Early**: The earlier you set them, the less likely you'll be blindsided later.

2. **Be Specific**: Vague non-goals don't help. "Not focusing on mobile" is better than "keeping scope limited."

3. **Explain the Why**: Stakeholders accept non-goals better when they understand the reasoning.

4. **Address Grey Areas**: Call out things that might reasonably be assumed in-scope but aren't.

5. **Use in Discussions**: Reference non-goals when scope creep occurs—they're decision-making tools.

6. **Distinguish Deferrals**: Be clear about "not now" vs. "not ever."

7. **Keep Goals Focused**: Aim for 3-5 primary goals. Too many goals means no priorities.

8. **Make Goals Measurable**: Each goal should have clear success criteria.

9. **Review and Update**: As projects evolve, goals and non-goals may need adjustment.

## Common Pitfalls

- **No Non-Goals**: Failing to document what's out of scope leaves it open to interpretation
- **Vague Goals**: Goals like "improve user experience" without specific, measurable outcomes
- **Too Many Goals**: Having 20 goals is the same as having no priorities
- **Hidden Non-Goals**: Assuming everyone knows what's out of scope when they don't
- **Ignored After Creation**: Not referencing goals/non-goals in ongoing discussions
- **Static Document**: Not updating as new information emerges
- **Missing Rationale**: Not explaining why something is a non-goal
- **Passive Agreement**: Stakeholders not genuinely bought in to non-goals

## Tools & Templates

- **Documentation**: Confluence, Notion, Google Docs
- **Project Tools**: Jira, Linear, Asana with goal-tracking features
- **Templates**: PRD templates often include goals/non-goals sections
- **OKR Tools**: Lattice, Ally, Weekdone for goal tracking
- **Collaboration**: Miro, FigJam for workshop-style goal setting

## Related Documents

- [Scope Definition](../scope-definition/_description.md) - Detailed scope boundaries for MVP
- [Product Requirements Document](../product-requirements-document/_description.md) - Full requirements incorporating goals
- [Vision Statement](../vision-statement/_description.md) - Strategic direction informing goals
- [Milestone Plan](../milestone-plan/_description.md) - Timeline for achieving goals
- [Risk Register](../risk-register/_description.md) - Risks related to goal achievement

## Examples & References

### Example Format

**Goals:**
1. ✅ Reduce user onboarding time from 15 minutes to under 5 minutes
   - *Success Metric*: Average time-to-first-value < 5 min
2. ✅ Achieve 80% activation rate for new users in first week
   - *Success Metric*: Weekly cohort activation tracking
3. ✅ Decrease support tickets related to onboarding by 50%
   - *Success Metric*: Ticket categorization and volume tracking

**Non-Goals:**
1. ❌ Building a mobile onboarding experience
   - *Rationale*: 95% of signups occur on desktop; mobile is a future consideration
2. ❌ Supporting enterprise SSO during onboarding
   - *Rationale*: Complex integration; will be addressed in enterprise tier launch
3. ❌ Personalizing onboarding by industry vertical
   - *Rationale*: Requires content creation for each vertical; focusing on universal flow first

### Non-Goal Categories

| Category | Example |
|----------|---------|
| **Platforms** | "Not supporting legacy browsers (IE11)" |
| **User Segments** | "Not targeting enterprise customers in v1" |
| **Features** | "Not building a recommendation engine" |
| **Integrations** | "Not integrating with Salesforce initially" |
| **Performance** | "Not optimizing for 10K+ concurrent users" |
| **Scope** | "Not addressing billing/payments in this phase" |

### Further Reading

- "Goals & Non-Goals" - The Clever PM
- "What Is a Product Requirements Document?" - Atlassian
- "Project Requirements, Scope, and Deliverables" - ProjectSkillsMentor
- "Goals vs Requirements: What is the Difference?" - PQFORCE Blog
