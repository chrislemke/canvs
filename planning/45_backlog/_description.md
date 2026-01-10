# Product Backlog

## Overview

The Product Backlog is an ordered list of everything that is known to be needed in a product. It is the single source of work for the development team, containing features, bug fixes, technical work, and knowledge acquisition items. The Product Owner is responsible for the backlog, including its content, availability, and ordering. A well-managed backlog is essential for agile product development, enabling teams to focus on delivering value iteratively.

## Purpose

- **Single source of truth**: Consolidate all work items in one place
- **Prioritize value**: Order items by business value and urgency
- **Enable planning**: Provide input for sprint and release planning
- **Manage scope**: Track all known requirements and ideas
- **Communicate intent**: Share product direction with stakeholders
- **Support estimation**: Enable effort estimation for roadmapping
- **Facilitate transparency**: Make work visible to all stakeholders

## When to Create

- **Product Inception**: At the start of a new product
- **Ongoing**: Continuously throughout product lifecycle
- **Feature Discovery**: When new requirements emerge
- **Sprint Planning**: Refined before each sprint
- **Stakeholder Feedback**: When new needs are identified
- **Bug Reports**: When defects are discovered

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Owner | Accountable for backlog management |
| Scrum Team | Refines items, provides estimates |
| Stakeholders | Contribute requirements and priorities |
| Tech Lead | Adds technical items, identifies dependencies |
| Customers | Source of requirements and feedback |
| UX Team | Contributes design requirements |

## Key Components

### 1. Backlog Items
- User Stories
- Bug fixes
- Technical debt items
- Spikes (research tasks)
- Enablers (infrastructure work)

### 2. Item Attributes
- Unique identifier
- Title and description
- Acceptance criteria
- Priority/order
- Estimate (story points)
- Status
- Labels/tags

### 3. Ordering
- Priority based on value
- Dependencies considered
- Risk and learning prioritized
- MoSCoW or other frameworks

### 4. Refinement State
- Ready for sprint (refined)
- Needs refinement
- Icebox (future consideration)
- Blocked

## Backlog Structure

### Epic → Feature → Story Hierarchy
```
Epic: User Authentication
├── Feature: Social Login
│   ├── Story: Login with Google
│   ├── Story: Login with GitHub
│   └── Story: Link social accounts
├── Feature: Email Authentication
│   ├── Story: Email signup
│   ├── Story: Email verification
│   └── Story: Password reset
```

### DEEP Criteria
- **D**etailed Appropriately: Top items more detailed than bottom
- **E**stimated: Items have effort estimates
- **E**mergent: Backlog evolves over time
- **P**rioritized: Items ordered by value

## Prioritization Frameworks

| Framework | Description |
|-----------|-------------|
| **MoSCoW** | Must-Have, Should-Have, Could-Have, Won't-Have |
| **WSJF** | Weighted Shortest Job First (SAFe) |
| **RICE** | Reach, Impact, Confidence, Effort |
| **Kano Model** | Basic, Performance, Delighters |
| **Value vs Effort** | Simple 2×2 matrix |
| **Cost of Delay** | Economic prioritization |

## Backlog Refinement (Grooming)

### Purpose
- Add detail to items
- Estimate and size items
- Split large items
- Remove obsolete items
- Clarify acceptance criteria

### Cadence
- At least once per sprint
- 60-90 minutes recommended
- 5-10% of sprint capacity

### Participants
- Product Owner (required)
- Development Team (required)
- Scrum Master (facilitator)
- Subject Matter Experts (as needed)

## Inputs & Dependencies

- Product vision and strategy
- Customer feedback
- Stakeholder requests
- Technical requirements
- Bug reports
- Market research
- Competitive analysis
- Retrospective action items

## Outputs & Deliverables

- Prioritized backlog
- Sprint-ready items at top
- Refined stories with acceptance criteria
- Estimated items
- Backlog health metrics
- Release projections

## Best Practices

1. **Single Backlog**: Keep everything in one issue tracker; don't split across systems.

2. **Regular Refinement**: Hold grooming sessions at least once per sprint.

3. **Keep It Manageable**: Remove items that have lost relevance; avoid backlog bloat.

4. **Detail at the Top**: Top items should be sprint-ready; bottom can be less detailed.

5. **Collaborative Approach**: Product Owner should collaborate with team on refinement.

6. **Visualize and Share**: Make backlog accessible and visible to all stakeholders.

7. **Split Large Items**: Break epics into stories that can be completed in one sprint.

8. **Include Technical Debt**: Make technical work visible alongside features.

## Common Pitfalls

- **Backlog Bloat**: Growing too large to manage effectively
- **Stale Items**: Items lingering without updates or refinement
- **Hidden Backlogs**: Multiple systems tracking different work
- **Missing Estimates**: Items without sizing for planning
- **Vague Items**: User stories lacking acceptance criteria
- **No Prioritization**: Unsorted backlog with no clear order
- **PO Isolation**: Product Owner managing alone without team input
- **Feature Factory**: Focus on output rather than outcomes

## Tools

### Agile Project Management
- **Jira**: Industry standard for backlog management
- **Azure DevOps**: Microsoft's work tracking solution
- **Linear**: Modern, fast issue tracking
- **Trello**: Kanban-style boards
- **Asana**: Work management platform
- **ClickUp**: All-in-one project management

### Collaboration
- **Miro/Mural**: Story mapping and refinement
- **ProductBoard**: Feature prioritization
- **Aha!**: Product management platform

## Related Documents

- [User Stories / Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Story format
- [Build Plan / Sprint Plan](../build-plan-sprint-plan/_description.md) - Sprint selection
- [High-Level Product Roadmap](../high-level-product-roadmap/_description.md) - Strategic context
- [Scope Definition](../scope-definition/_description.md) - What's in/out
- [Definition of Ready / Done](../definition-of-ready-done/_description.md) - Item criteria

## Examples & References

### Backlog Item Template

```markdown
## User Story: US-234

**Title**: Password Reset via Email

**As a** registered user
**I want** to reset my password via email
**So that** I can regain access to my account if I forget my password

### Acceptance Criteria
- [ ] User can request password reset from login page
- [ ] System sends reset link to registered email
- [ ] Link expires after 24 hours
- [ ] User can set new password meeting requirements
- [ ] Old password is invalidated upon reset
- [ ] User receives confirmation email after reset

### Details
- **Priority**: High
- **Estimate**: 5 story points
- **Sprint**: 14 (planned)
- **Labels**: authentication, security

### Dependencies
- Email service must be configured (US-201)

### Notes
- Consider rate limiting reset requests
- Link security requirements from SEC-102
```

### Backlog Health Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Total Items | 87 | <100 |
| Refined Items (ready) | 24 | >20 |
| Items >6 months old | 12 | <10 |
| Items without estimates | 15 | <10 |
| Avg. story size | 5.2 pts | 3-8 pts |

### Backlog Prioritization Example

| Priority | ID | Story | Points | Value | MoSCoW |
|----------|-----|-------|--------|-------|--------|
| 1 | US-101 | User login | 5 | High | Must |
| 2 | US-102 | Password reset | 5 | High | Must |
| 3 | US-103 | OAuth login | 8 | Medium | Should |
| 4 | BUG-42 | Fix redirect | 2 | High | Must |
| 5 | US-104 | Account settings | 3 | Medium | Should |
| 6 | US-105 | Dark mode | 5 | Low | Could |

### Further Reading

- [Atlassian Product Backlog Guide](https://www.atlassian.com/agile/scrum/backlogs)
- [Scrum.org Backlog Management Tips](https://www.scrum.org/resources/tips-effective-product-backlog-management)
- "Agile Product Management with Scrum" - Roman Pichler
- "User Story Mapping" - Jeff Patton
