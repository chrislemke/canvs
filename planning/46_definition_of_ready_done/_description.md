# Definition of Ready (DoR) / Definition of Done (DoD)

## Overview

The Definition of Ready (DoR) and Definition of Done (DoD) are team agreements that establish criteria for when work items are ready to begin and when they are considered complete. The DoD is a formal part of Scrum that defines when a Product Backlog Item becomes a potentially releasable increment. The DoR is an optional but helpful practice that ensures items are sufficiently prepared before entering a sprint. Together, they create a quality framework that improves predictability and reduces rework.

## Purpose

### Definition of Done
- **Define completion**: Establish when an increment is truly finished
- **Ensure quality**: Build quality standards into the process
- **Create transparency**: Everyone knows what "done" means
- **Enable release**: Ensure increments are potentially shippable
- **Reduce rework**: Catch issues before items are declared complete

### Definition of Ready
- **Prepare items**: Ensure sufficient detail before sprint commitment
- **Reduce clarification**: Minimize questions during development
- **Enable estimation**: Items are clear enough to estimate
- **Improve planning**: More accurate sprint planning
- **Prevent waste**: Avoid starting on incomplete items

## When to Create

- **Team Formation**: When establishing team working agreements
- **Project Start**: Before the first sprint
- **Process Review**: During retrospectives if quality issues arise
- **Team Evolution**: When team composition or context changes
- **Scaling**: When coordinating across multiple teams

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Scrum Team | Collaboratively defines and agrees |
| Scrum Master | Facilitates creation, ensures adherence |
| Product Owner | Contributes business perspective |
| Developers | Define technical criteria |
| QA/Test | Contributes quality criteria |
| Stakeholders | May provide input on release criteria |

## Key Components

### Definition of Done

**Code Quality**
- Code reviewed and approved
- Coding standards followed
- Static analysis passed
- No critical security issues

**Testing**
- Unit tests written and passing
- Integration tests passing
- Test coverage meets threshold
- Exploratory testing completed

**Documentation**
- Code comments where needed
- API documentation updated
- User documentation updated (if applicable)

**Deployment**
- Builds successfully
- Deploys to staging environment
- Smoke tests passing
- Feature flags configured

**Acceptance**
- Acceptance criteria met
- Product Owner reviewed
- No known defects

### Definition of Ready

**Requirements**
- User story clearly written
- Acceptance criteria defined
- Dependencies identified
- Mockups/wireframes attached (if UI)

**Estimation**
- Story estimated by team
- Fits within sprint capacity
- No larger than X story points

**Understanding**
- Team understands the requirement
- Technical approach discussed
- Questions resolved with PO

## DoD vs DoR Comparison

| Aspect | Definition of Ready | Definition of Done |
|--------|---------------------|-------------------|
| Scrum Status | Optional/external tool | Part of Scrum Guide |
| Focus | Entry criteria | Exit criteria |
| Timing | Before sprint | End of sprint |
| Applied to | Backlog items entering sprint | Completed items |
| Risk | Can create waterfall-like gates | Generally positive |
| Owner | Team agreement | Scrum Team commitment |

## Crafting Effective Definitions

### INVEST Criteria (for stories)
- **I**ndependent: Can be developed separately
- **N**egotiable: Details can be discussed
- **V**aluable: Delivers value to user
- **E**stimable: Can be estimated
- **S**mall: Fits in a sprint
- **T**estable: Has clear test criteria

### SMART for DoD Items
- **S**pecific: Clear and unambiguous
- **M**easurable: Can be objectively verified
- **A**chievable: Realistic for the team
- **R**elevant: Contributes to quality
- **T**ime-bound: Applied within sprint

## Inputs & Dependencies

- Team capabilities and context
- Organizational standards
- Regulatory requirements
- Technical constraints
- Quality expectations
- Release criteria
- Previous experience and retrospectives

## Outputs & Deliverables

- Documented DoR checklist
- Documented DoD checklist
- Team working agreement
- Visible poster or wiki page
- Checklist integrated into tools

## Best Practices

1. **Collaborative Creation**: Build definitions together as a team.

2. **Start Simple, Evolve**: Begin with basics and add criteria over time.

3. **Make Visible**: Post definitions where team can see them.

4. **Review Regularly**: Revisit during retrospectives.

5. **Apply Consistently**: Hold all items to the same standard.

6. **Customize to Context**: Adapt to team's technology and domain.

7. **Balance Rigor and Practicality**: Don't make criteria impossible to meet.

8. **Avoid DoR as Gate**: Use DoR as guideline, not strict checkpoint.

## Common Pitfalls

### Definition of Done
- Too vague (e.g., "tested" without specifics)
- Too ambitious (impossible to meet every sprint)
- Not enforced consistently
- Not updated as team matures

### Definition of Ready
- Used as strict gate (creates waterfall)
- Too many requirements (nothing is ever "ready")
- Blamed for slow refinement
- Becomes bureaucratic checklist

## Tools

### Documentation
- **Confluence/Notion**: Team documentation
- **Wiki**: Central reference
- **Jira**: Custom fields for DoD/DoR checklists
- **Physical Poster**: Visible in team space

### Enforcement
- **Jira Workflows**: Require checklist completion
- **PR Templates**: Include DoD checklist
- **Automation**: CI/CD enforced criteria

## Related Documents

- [Backlog](../backlog/_description.md) - Items that need DoR
- [Build Plan / Sprint Plan](../build-plan-sprint-plan/_description.md) - Planning with DoR
- [User Stories / Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Story format
- [QA Checklist](../qa-checklist/_description.md) - Testing criteria
- [Test Strategy](../test-strategy/_description.md) - Testing standards

## Examples & References

### Definition of Ready Example

```markdown
# Definition of Ready

A backlog item is Ready when:

## Requirements
- [ ] User story follows format: "As a [user], I want [goal], so that [benefit]"
- [ ] Acceptance criteria are defined and testable
- [ ] UI mockups attached (for UI stories)
- [ ] Dependencies identified and resolved or planned

## Clarity
- [ ] Team understands what to build
- [ ] Questions answered by Product Owner
- [ ] Edge cases discussed

## Sizing
- [ ] Story is estimated by the team
- [ ] Story is small enough to complete in one sprint
- [ ] Story is independent (can be developed without other stories)
```

### Definition of Done Example

```markdown
# Definition of Done

An item is Done when:

## Code
- [ ] Code complete and follows team conventions
- [ ] Code reviewed by at least one team member
- [ ] Code merged to main branch
- [ ] No unresolved comments in review

## Testing
- [ ] Unit tests written (>80% coverage for new code)
- [ ] All tests passing (unit, integration, e2e)
- [ ] Edge cases tested
- [ ] Manual testing completed in staging

## Documentation
- [ ] README updated if needed
- [ ] API documentation updated if needed
- [ ] Release notes drafted

## Deployment
- [ ] Deployed to staging environment
- [ ] Smoke tests passing
- [ ] No increase in error rates

## Acceptance
- [ ] Acceptance criteria verified
- [ ] Product Owner has reviewed
- [ ] No known bugs
```

### DoD Evolution by Team Maturity

| Stage | Example DoD Items |
|-------|------------------|
| Forming | Code reviewed, tests passing, builds |
| Storming | +Coverage threshold, +documentation |
| Norming | +Security scan, +performance check |
| Performing | +Automated deployment, +feature flags |

### Further Reading

- [Atlassian DoD Guide](https://www.atlassian.com/agile/project-management/definition-of-done)
- [Atlassian DoR Guide](https://www.atlassian.com/agile/project-management/definition-of-ready)
- [Scrum.org DoD vs DoR](https://www.scrum.org/resources/blog/what-difference-between-definition-done-dod-and-definition-ready-dor)
- "Scrum Guide" - Schwaber & Sutherland
- [Scrum Alliance DoR Pros/Cons](https://resources.scrumalliance.org/Article/pros-cons-definition-ready)
