# Assumptions & Hypotheses Log

## Overview

An Assumptions & Hypotheses Log is a living document that captures, tracks, and validates the beliefs and assumptions underlying product decisions. Every product is built on assumptions about customers, markets, technology, and business models—many of which are untested. This log makes those assumptions explicit, prioritizes them by risk, and tracks validation efforts. It's a cornerstone of lean product development and continuous discovery.

## Purpose

- **Surface hidden beliefs**: Make implicit assumptions explicit and visible
- **Reduce risk**: Identify and address the riskiest assumptions early
- **Guide research**: Focus discovery efforts on what matters most
- **Enable learning**: Track what's validated vs. still assumed
- **Prevent costly mistakes**: Catch wrong assumptions before major investment
- **Create transparency**: Share uncertainty openly with stakeholders
- **Support decision-making**: Provide evidence basis for product decisions

## When to Create

- **Product Inception**: At the very start of new product development
- **Discovery Phase**: Throughout continuous product discovery
- **Before Major Investments**: Before committing significant resources
- **Sprint Planning**: When defining what to test in upcoming sprints
- **Pivot Considerations**: When reassessing fundamental strategy
- **Post-Launch**: As new assumptions emerge during scaling

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Maintains the log, prioritizes assumptions |
| UX Research | Designs and conducts validation experiments |
| Design | Tests usability assumptions through prototypes |
| Engineering | Validates feasibility assumptions |
| Data/Analytics | Provides quantitative validation |
| All Team Members | Contribute assumptions from their domain |

## Key Components

### 1. Assumption Statement
A clear, testable statement of what is believed to be true

### 2. Category
- **Value**: Will customers want this?
- **Usability**: Can customers use this?
- **Feasibility**: Can we build this?
- **Viability**: Can this be a sustainable business?

### 3. Risk Level
Assessment of impact if the assumption is wrong (High/Medium/Low)

### 4. Evidence Level
Current state of validation:
- Untested
- Some evidence
- Validated
- Invalidated

### 5. Validation Plan
How the assumption will be tested:
- Method (interview, prototype, experiment, data analysis)
- Success criteria
- Timeline

### 6. Validation Results
- What was learned
- Evidence collected
- Next steps

## Assumption Mapping Framework

### The 2x2 Matrix (Gothelf & Seiden)
- **X-axis**: Evidence level (have evidence ↔ no evidence)
- **Y-axis**: Importance (low risk ↔ high risk)

**Quadrants**:
1. **Test First** (Top-left): High risk, no evidence → immediate priority
2. **Keep Watching** (Top-right): High risk, some evidence → monitor closely
3. **Deprioritize** (Bottom-left): Low risk, no evidence → test later
4. **Validated** (Bottom-right): Low risk, evidence exists → move forward

## Risk Categories (Cagan Framework)

### Value Risk
"Will the customer buy this or choose to use it?"

### Usability Risk
"Can the user figure out how to use it?"

### Feasibility Risk
"Can our engineers build what we need with the time, skills, and technology available?"

### Business Viability Risk
"Does this solution work for the various aspects of our business (sales, marketing, finance, legal, etc.)?"

## Inputs & Dependencies

- Product vision and strategy
- Problem statement and JTBD
- Market research
- Stakeholder requirements
- Technical assessments
- Business model canvas
- Competitive analysis
- Team experience and intuition

## Outputs & Deliverables

- Prioritized list of assumptions
- Assumption map/matrix visualization
- Validation experiment plans
- Test cards documenting experiments
- Learning cards documenting results
- Evidence repository
- Regular status updates for stakeholders

## Best Practices

1. **Capture Early and Often**: Document assumptions as soon as they're identified.

2. **Be Specific**: Vague assumptions can't be tested. "Users want X" is better than "Users will like it."

3. **Prioritize by Risk**: Focus on assumptions that, if wrong, would derail the product.

4. **Test the Riskiest First**: Don't validate easy assumptions while ignoring hard ones.

5. **Define Success Criteria**: Know what "validated" looks like before you test.

6. **Use Cheap Tests First**: Start with interviews before building prototypes.

7. **Document Everything**: Record methodology, results, and learnings for future reference.

8. **Share Openly**: Transparency about uncertainty builds trust and invites contribution.

9. **Iterate**: Validating one assumption often reveals new ones.

## Common Pitfalls

- **Hidden Assumptions**: Keeping critical beliefs implicit
- **Confirmation Bias**: Designing experiments to prove you're right
- **Testing Easy Things**: Validating low-risk assumptions while avoiding hard ones
- **No Success Criteria**: Not defining what "validated" means upfront
- **Ignoring Invalidation**: Dismissing results that contradict beliefs
- **Premature Validation**: Claiming validation without sufficient evidence
- **Static Log**: Not updating as new assumptions emerge
- **All Talk, No Test**: Documenting assumptions but never testing them

## Tools & Templates

### Test Card Template
```
Hypothesis: We believe that [assumption]
To verify this, we will [experiment]
And measure [metric]
We are right if [success criteria]
```

### Learning Card Template
```
We believed that [assumption]
We tested by [experiment]
We measured [metric]
We learned [findings]
Therefore, we will [next steps]
```

### Tools
- **Documentation**: Notion, Confluence, Google Sheets
- **Visualization**: Miro (Assumption Mapping template), FigJam
- **Research**: Maze, UserTesting, Dovetail
- **Experiment Tracking**: Jira, Linear, Productboard

## Related Documents

- [Problem Statement](../problem-statement/_description.md) - Core assumptions about the problem
- [Target Customer Personas](../target-customer-personas/_description.md) - Assumptions about users
- [UX Research Plan](../ux-research-plan/_description.md) - Research to validate assumptions
- [Research Findings Report](../research-findings-report/_description.md) - Validation results
- [Risk Register](../risk-register/_description.md) - Risks tied to unvalidated assumptions

## Examples & References

### Example Assumption Log Entry

| ID | Assumption | Category | Risk | Evidence | Validation Plan | Status |
|---|---|---|---|---|---|---|
| A1 | Freelancers spend 5+ hrs/week on invoicing | Value | High | Some (3 interviews) | Survey of 100 freelancers | Validated |
| A2 | Users will pay $20/month for automation | Viability | High | None | Landing page test | In Progress |
| A3 | We can build invoice scanning in 2 sprints | Feasibility | Medium | Low | Engineering spike | Pending |
| A4 | Users prefer Slack integration over email | Value | Low | None | A/B test post-MVP | Deferred |

### Assumption Mapping Example

```
                 High Risk
                     │
     ┌───────────────┼───────────────┐
     │  TEST FIRST   │  KEEP WATCHING │
     │    (A2)       │     (A1)       │
     │               │                │
     ├───────────────┼───────────────┤
No   │  DEPRIORITIZE │   VALIDATED    │
Evidence             │                Evidence
     │    (A4)       │                │
     │               │                │
     └───────────────┼───────────────┘
                     │
                 Low Risk
```

### Further Reading

- "Assumption Mapping: How To Test Product Assumptions" - Maze
- "Product Hypothesis Validation Process & Examples" - Boldare
- "How to Test Product Assumptions Before Building Features" - Get Product People
- "4 Common Product Discovery Mistakes" - Ant Murphy
- "Lean UX" - Jeff Gothelf & Josh Seiden
- "Inspired" & "Empowered" - Marty Cagan
