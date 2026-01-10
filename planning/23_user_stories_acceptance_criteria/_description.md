# User Stories + Acceptance Criteria

## Overview

User Stories with Acceptance Criteria are the primary method for capturing requirements in agile product development. A User Story describes a feature from the end-user's perspective, following the format "As a [user], I want [action], so that [benefit]." Acceptance Criteria define the specific conditions that must be met for the story to be considered complete. Together, they translate high-level requirements into actionable, testable work items.

## Purpose

- **Capture requirements**: Document what needs to be built from user perspective
- **Enable discussion**: Stories are conversation starters, not specifications
- **Drive development**: Guide implementation with clear goals
- **Enable testing**: Acceptance criteria define what "done" means
- **Prioritize work**: Sized and scoped for sprint planning
- **Maintain focus**: Keep user needs central to development
- **Support estimation**: Well-defined stories enable accurate estimates

## When to Create

- **Backlog Grooming**: During regular backlog refinement sessions
- **Sprint Planning**: Before pulling stories into a sprint
- **Discovery Output**: After user research identifies needs
- **PRD Breakdown**: Decomposing PRD into user stories
- **Feature Planning**: When defining a new feature or epic

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Owner/PM | Writes user stories, prioritizes |
| Development Team | Reviews, estimates, implements |
| QA Engineer | Validates acceptance criteria are testable |
| Designer | Provides UX context and designs |
| Stakeholders | Provide input on requirements |

## Key Components

### User Story Format

The Connextra template (standard format):
> "As a [type of user], I want to [perform some action], so that I can [achieve some goal/benefit]."

**Elements:**
- **Who**: The user or persona
- **What**: The action or feature
- **Why**: The benefit or value

### The 3 C's

1. **Card**: Written story (the format above)
2. **Conversation**: Discussion that clarifies the story
3. **Confirmation**: Acceptance criteria that verify completion

### INVEST Criteria

Good stories should be:
- **I**ndependent: Minimally dependent on other stories
- **N**egotiable: Details can be discussed
- **V**aluable: Delivers value to users or business
- **E**stimable: Team can estimate effort
- **S**mall: Completable in one sprint (often < 1 week)
- **T**estable: Has clear acceptance criteria

## Acceptance Criteria Formats

### Given/When/Then (Gherkin)
```
Given [initial context/precondition]
When [action is performed]
Then [expected outcome]
```

**Example:**
```
Given I am logged in as a registered user
When I click the "Download Invoice" button
Then a PDF invoice downloads to my device
And the invoice contains my account details
```

### Checklist Format
```
- [ ] User can see their current balance
- [ ] Balance updates within 5 seconds of transaction
- [ ] Negative balances display in red
```

### Rule-Based Format
```
Rule: Invoices are only visible to account owners
- Account owner can view their invoices
- Account admin can view all team invoices
- Regular team members cannot view invoices
```

## Inputs & Dependencies

- Product Requirements Document
- User personas and Jobs-to-be-Done
- Scope Definition
- Design mockups and wireframes
- Technical constraints
- Previous sprint feedback

## Outputs & Deliverables

- User stories in backlog tool (Jira, Linear, etc.)
- Acceptance criteria for each story
- Story point estimates
- Dependencies mapped
- Sprint-ready backlog

## Best Practices

### For User Stories

1. **Focus on Users**: Write from the user's perspective, not technical tasks.

2. **Include the Why**: The "so that" clause provides crucial context.

3. **Keep Stories Small**: Stories should be completable in 1-5 days.

4. **Make Them Independent**: Minimize dependencies between stories.

5. **Stories, Not Tasks**: "Log in" is a story; "Create login API endpoint" is a task.

### For Acceptance Criteria

1. **Be Specific**: Criteria should be unambiguous and testable.

2. **Keep It Minimal**: 2-5 criteria per story is typical.

3. **Write Before Development**: Define done BEFORE work begins.

4. **Use Plain Language**: Avoid technical jargon stakeholders won't understand.

5. **Make It Testable**: Every criterion should have a clear pass/fail.

6. **Collaborate**: Involve developers and QA in criteria definition.

## Common Pitfalls

### Story Pitfalls
- **Too Big**: Epics masquerading as stories
- **Technical Stories**: "As a developer, I want..." (these are tasks)
- **Missing Benefit**: Omitting the "so that" clause
- **Vague Users**: "As a user" instead of specific persona
- **Solution Prescribing**: Dictating implementation in the story

### Acceptance Criteria Pitfalls
- **Too Vague**: Criteria that can't be objectively tested
- **Too Many**: Overwhelming lists that indicate story is too big
- **Missing Edge Cases**: Not considering error states and boundaries
- **Written After**: Defining "done" after development starts
- **Technical Specs**: Implementation details instead of outcomes

## Story vs. Acceptance Criteria vs. Tasks

| Level | Example | Purpose |
|-------|---------|---------|
| **Epic** | "User Account Management" | Strategic grouping |
| **Story** | "As a user, I want to reset my password..." | User-facing need |
| **Acceptance Criteria** | "Given I click reset, then email sends in < 30s" | Definition of done |
| **Task** | "Create password reset API endpoint" | Implementation work |

## Tools & Templates

- **Backlog Tools**: Jira, Linear, Asana, Azure DevOps
- **Collaboration**: Miro, FigJam for story mapping
- **Documentation**: Confluence, Notion for story details
- **Templates**: Aha! User Story Templates, Inflectra templates

## Related Documents

- [Product Requirements Document](../product-requirements-document/_description.md) - Source of requirements
- [Scope Definition](../scope-definition/_description.md) - What's in/out of scope
- [Target Customer Personas](../target-customer-personas/_description.md) - Who the stories are for
- [Definition of Ready / Definition of Done](../definition-of-ready-done/_description.md) - Story readiness criteria
- [Test Plan](../test-plan/_description.md) - How stories will be tested

## Examples & References

### Example User Stories with Acceptance Criteria

**Story 1: Invoice Download**
> As a customer, I want to download my invoices as PDFs, so that I can submit them for expense reimbursement.

**Acceptance Criteria:**
```
Given I am logged into my account
When I navigate to Billing > Invoices
Then I see a list of all invoices from the past 12 months

Given I am viewing my invoice list
When I click the download icon on an invoice
Then a PDF downloads with filename format: "Invoice-[number]-[date].pdf"

Given the PDF has downloaded
Then it contains: company logo, invoice number, line items, total, and payment status
```

---

**Story 2: Password Reset**
> As a user who forgot my password, I want to reset it via email, so that I can regain access to my account.

**Acceptance Criteria:**
- [ ] Reset link is sent within 30 seconds of request
- [ ] Link expires after 24 hours
- [ ] Link can only be used once
- [ ] New password must meet complexity requirements
- [ ] User is logged in after successful reset
- [ ] Old password no longer works after reset

### Further Reading

- "User Stories with Examples and a Template" - Atlassian
- "Acceptance Criteria for User Stories in Agile" - AltexSoft
- "What is Acceptance Criteria?" - ProductPlan
- "Acceptance Criteria Explained" - IntelliSoft
- "How To Write Excellent Acceptance Criteria" - The Product Manager
- "User Stories Applied" - Mike Cohn
