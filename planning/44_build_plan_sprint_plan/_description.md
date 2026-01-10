# Build Plan / Sprint Plan

## Overview

A Build Plan or Sprint Plan is a tactical document that defines what work will be accomplished during a specific development iteration (sprint) and how that work will be achieved. In Agile methodology, sprint planning is a time-boxed event that kicks off each sprint, resulting in a clear sprint goal, a selected set of backlog items, and a shared understanding of how the team will deliver them. This document captures the outcomes of that planning session.

## Purpose

- **Define scope**: Establish what will be delivered in the sprint
- **Set goals**: Create a focused, measurable sprint objective
- **Allocate work**: Assign tasks based on team capacity
- **Create commitment**: Build team agreement on deliverables
- **Enable tracking**: Provide baseline for progress measurement
- **Reduce ambiguity**: Clarify priorities and expectations
- **Support coordination**: Align team members on approach

## When to Create

- **Sprint Start**: At the beginning of each sprint/iteration
- **Release Planning**: When planning a series of sprints
- **Project Kickoff**: Initial build plan for project phases
- **Re-Planning**: When significant scope changes occur
- **Quarterly Planning**: For PI (Program Increment) planning in SAFe

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Owner | Defines sprint goal, prioritizes backlog |
| Scrum Master | Facilitates planning, ensures process |
| Development Team | Estimates, commits, plans implementation |
| Tech Lead | Provides technical guidance on approach |
| Stakeholders | May provide context (not usually in meeting) |

## Key Components

### 1. Sprint Goal
- Single, clear objective for the sprint
- Measurable and achievable
- Provides focus and direction
- Example: "Implement user authentication flow"

### 2. Sprint Backlog
- Selected Product Backlog Items (PBIs)
- Committed user stories
- Story points or estimates
- Priority order

### 3. Capacity Planning
- Team availability (hours/days)
- Vacation and time-off adjustments
- Meeting overhead calculations
- Historical velocity reference

### 4. Task Breakdown
- Stories broken into tasks
- Task estimates (hours)
- Technical approach notes
- Dependencies identified

### 5. Acceptance Criteria
- Clear "done" criteria for each item
- Testable conditions
- Definition of Done applied

### 6. Dependencies & Risks
- External dependencies
- Cross-team dependencies
- Identified risks
- Blockers to address

## Sprint Planning Structure

### Part 1: The What (1 hour per week of sprint)
- Product Owner presents prioritized backlog
- Team discusses and clarifies items
- Sprint goal is defined
- Items are selected based on capacity

### Part 2: The How (1 hour per week of sprint)
- Team breaks stories into tasks
- Technical approach is discussed
- Tasks are estimated
- Potential issues are identified

### The 3-5-3 Rule
- **3-9** team members
- **1-4** week sprints
- **2 hours** planning per week of sprint

## Estimation Techniques

| Technique | Description | Best For |
|-----------|-------------|----------|
| Story Points | Relative sizing using Fibonacci | Complex work |
| T-Shirt Sizing | S, M, L, XL categories | Quick estimation |
| Planning Poker | Team consensus through cards | Avoiding anchoring |
| Ideal Hours | Time-based estimates | Familiar work |
| Dot Voting | Quick prioritization | Many items |

## Inputs & Dependencies

- Prioritized Product Backlog
- Team velocity history
- Team capacity for sprint
- Definition of Ready criteria
- Technical context and constraints
- Previous sprint retrospective insights
- Release goals and roadmap

## Outputs & Deliverables

- Sprint Goal statement
- Sprint Backlog with committed items
- Task breakdown for each story
- Updated burndown/sprint board
- Identified risks and dependencies
- Team commitment

## Best Practices

1. **Define Clear Sprint Goal**: Create singular, measurable objectives like "Implement user authentication flow" or "Reduce API latency by 15%."

2. **Lock Scope After Planning**: Once the sprint begins, protect the scope from changes.

3. **Use Historical Data**: Reference velocity trends and past sprint data.

4. **Account for Availability**: Factor in vacations, meetings, and non-sprint work.

5. **Break Down Large Items**: No story should exceed half the sprint capacity.

6. **Include Buffer**: Don't plan to 100% capacity; leave room for unexpected work.

7. **Apply Planning Poker**: Prevent anchoring bias with simultaneous estimates.

8. **Document Dependencies**: Identify and communicate cross-team dependencies early.

## Common Pitfalls

- **Overcommitment**: Committing to more than capacity allows
- **Vague Goals**: Sprint goals that aren't measurable
- **Missing Key Participants**: Planning without PO, SM, or developers
- **No Capacity Adjustment**: Ignoring team availability changes
- **Incomplete Stories**: Bringing unready items into sprint
- **Skipping Breakdown**: Not decomposing stories into tasks
- **Ignoring Velocity**: Planning without historical reference
- **Scope Creep Acceptance**: Allowing changes mid-sprint

## Tools

### Agile Project Management
- **Jira**: Sprint boards, backlog management
- **Azure DevOps**: Sprint planning, boards
- **Linear**: Modern issue tracking
- **Monday.com**: Work management
- **ClickUp**: Agile project management

### Planning Support
- **Miro/Mural**: Remote planning collaboration
- **Planning Poker Apps**: Estimation tools
- **Confluence**: Documentation

### AI Tools (2025)
- AI-powered estimation suggestions
- Automated backlog prioritization
- Historical pattern analysis

## Related Documents

- [Backlog](../backlog/_description.md) - Source of sprint items
- [User Stories / Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Story format
- [Definition of Ready / Done](../definition-of-ready-done/_description.md) - Entry/exit criteria
- [High-Level Product Roadmap](../high-level-product-roadmap/_description.md) - Strategic context
- [Release Plan](../release-plan/_description.md) - Release goals

## Examples & References

### Sprint Plan Template

```markdown
# Sprint 14 Plan

## Sprint Information
- **Sprint Duration**: 2024-02-05 to 2024-02-16 (2 weeks)
- **Team Capacity**: 8 developers × 8 days × 6 hours = 384 hours
- **Planned Velocity**: 34 story points (based on 3-sprint average)

## Sprint Goal
Implement complete user authentication flow including signup,
login, password reset, and session management.

## Committed Stories

| ID | Story | Points | Owner | Status |
|----|-------|--------|-------|--------|
| US-101 | User signup with email verification | 8 | Alice | To Do |
| US-102 | User login with JWT tokens | 5 | Bob | To Do |
| US-103 | Password reset flow | 5 | Charlie | To Do |
| US-104 | Session management and logout | 3 | Alice | To Do |
| US-105 | OAuth integration (Google) | 8 | Bob | To Do |
| BUG-42 | Fix login redirect issue | 2 | Charlie | To Do |
| TECH-15 | Add auth rate limiting | 3 | Alice | To Do |

**Total Committed**: 34 points

## Dependencies
- [ ] OAuth credentials from Google Cloud team (@Diana, ETA: Feb 6)
- [ ] Email service API access (@DevOps, ETA: Feb 5)

## Risks
1. OAuth integration may require additional time for testing
2. Email service quotas need verification

## Definition of Done Applied
All stories must meet team DoD including:
- Code reviewed and approved
- Unit tests passing (>80% coverage)
- Integration tests added
- Documentation updated
```

### Sprint Capacity Calculator

| Team Member | Days Available | Focus Factor | Effective Hours |
|-------------|----------------|--------------|-----------------|
| Alice | 10 | 0.8 | 48 |
| Bob | 8 | 0.8 | 38.4 |
| Charlie | 10 | 0.8 | 48 |
| Diana | 6 | 0.8 | 28.8 |
| **Total** | | | **163.2 hours** |

### Further Reading

- [Atlassian Sprint Planning Guide](https://www.atlassian.com/agile/scrum/sprint-planning)
- "Scrum Guide" - Schwaber & Sutherland
- "Agile Estimating and Planning" - Mike Cohn
- [Monday.com Sprint Planning Guide 2025](https://monday.com/blog/rnd/sprint-planning/)
