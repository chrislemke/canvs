# Test Plan

## Overview

A Test Plan is a detailed, project-specific document that defines the scope, approach, resources, and schedule for testing a particular release, feature, or system. While the test strategy provides organization-wide testing philosophy, the test plan translates that into specific activities for a given project. It answers the questions of what will be tested, how, when, and by whom for a specific testing effort.

## Purpose

- **Define scope**: Specify what features/areas will be tested
- **Plan activities**: Schedule testing tasks and milestones
- **Allocate resources**: Assign testers and tools to tasks
- **Identify risks**: Document testing risks and mitigations
- **Set criteria**: Establish entry/exit criteria
- **Enable communication**: Share plan with stakeholders
- **Track progress**: Provide baseline for monitoring

## When to Create

- **Sprint/Release Start**: At the beginning of development
- **Feature Development**: For significant new features
- **Major Changes**: When system changes significantly
- **Regression Planning**: For regression test cycles
- **UAT Preparation**: Before user acceptance testing
- **Go-Live Preparation**: Before production deployment

## Who's Involved

| Role | Responsibility |
|------|----------------|
| QA Lead | Authors and owns test plan |
| Test Engineers | Execute tests, provide input |
| Product Manager | Defines features and priorities |
| Developers | Provide technical context |
| DevOps | Environment support |
| Stakeholders | Review and approve plan |

## Key Components

### 1. Introduction
- Purpose of this test plan
- Project overview
- References to related documents

### 2. Test Scope
- Features in scope
- Features out of scope
- Test levels included

### 3. Test Strategy (Project-Specific)
- Testing approach for this project
- Test types to be performed
- Automation approach

### 4. Test Environment
- Environment requirements
- Hardware/software specifications
- Test data requirements
- Environment availability

### 5. Test Schedule
- Testing phases and milestones
- Start and end dates
- Dependencies

### 6. Resource Plan
- Team members and roles
- Training needs
- Tool requirements

### 7. Test Cases
- Test case summary or reference
- Coverage matrix
- Traceability to requirements

### 8. Entry/Exit Criteria
- Conditions to start testing
- Conditions to end testing
- Release criteria

### 9. Risk Assessment
- Testing risks identified
- Mitigation strategies
- Contingency plans

### 10. Deliverables
- Test artifacts to produce
- Reports and metrics
- Sign-off requirements

## Test Plan Types

| Type | Scope | Duration |
|------|-------|----------|
| Master Test Plan | Entire project | Project lifecycle |
| Level Test Plan | Specific test level | Per level |
| Sprint Test Plan | Single sprint | 1-4 weeks |
| Feature Test Plan | Single feature | Feature development |
| Regression Test Plan | Regression testing | Per release |

## Entry and Exit Criteria

### Entry Criteria (Examples)
- Requirements are approved and baselined
- Test environment is available and stable
- Test data is prepared
- Code is deployed to test environment
- Unit tests are passing
- Build is successful

### Exit Criteria (Examples)
- All planned tests executed
- Critical and high bugs fixed
- Test coverage targets met
- No open P1/P2 defects
- Performance benchmarks met
- Sign-off obtained

## Inputs & Dependencies

- Requirements documentation
- Test strategy
- Project schedule
- Resource availability
- Test environment specs
- Risk assessment
- Previous test results

## Outputs & Deliverables

- Approved test plan document
- Test case specifications
- Test execution schedule
- Environment setup documentation
- Test data specifications
- Status reports template
- Final test summary report

## Best Practices

1. **Keep It Concise**: A short plan can outperform a 50-page document.

2. **Stakeholder Alignment**: Hold kickoff workshop to get buy-in.

3. **Clear Criteria**: Define unambiguous entry/exit criteria.

4. **Traceability**: Link tests to requirements.

5. **Risk-Based Focus**: Prioritize testing based on risk.

6. **Regular Updates**: Keep plan current as project evolves.

7. **Realistic Schedule**: Account for rework and delays.

8. **Template Consistency**: Use standard template across projects.

## Common Pitfalls

- **Overly Long**: Documents that no one reads
- **Vague Criteria**: Unclear when testing starts/stops
- **No Updates**: Static document that drifts from reality
- **Missing Risks**: Not identifying potential testing issues
- **Unrealistic Schedule**: Underestimating testing time
- **Unclear Scope**: Ambiguous about what's tested
- **No Sign-Off**: Testing starts without approval
- **Ignored Plan**: Created but not followed

## Tools

### Test Management
- **TestRail**: Test case and plan management
- **Zephyr**: Jira test management
- **qTest**: Enterprise test management
- **Xray**: Jira native test management
- **Azure Test Plans**: Microsoft test management

### Documentation
- **Confluence**: Documentation and collaboration
- **Notion**: Modern documentation
- **Google Docs**: Collaborative editing

### Automation
- **Jira**: Test plan tracking as epics/issues
- **Azure DevOps**: Integrated test planning

## Related Documents

- [Test Strategy](../test-strategy/_description.md) - Organizational testing approach
- [QA Checklist](../qa-checklist/_description.md) - Testing checklists
- [User Stories / Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Requirements
- [Release Plan](../release-plan/_description.md) - Release context
- [Definition of Ready / Done](../definition-of-ready-done/_description.md) - Quality criteria

## Examples & References

### Test Plan Template

```markdown
# Test Plan: [Project/Feature Name]

## Document Information
- **Version**: 1.0
- **Author**: [Name]
- **Date**: [Date]
- **Status**: Draft / Approved

## 1. Introduction

### 1.1 Purpose
This test plan describes the testing approach for [feature/release].

### 1.2 Scope
**In Scope:**
- User authentication (login, logout, password reset)
- User profile management
- Session handling

**Out of Scope:**
- Third-party integrations
- Admin functionality
- Legacy API endpoints

### 1.3 References
- PRD: [Link]
- Technical Design: [Link]
- Test Strategy: [Link]

## 2. Test Approach

### 2.1 Test Types
| Type | Description | Priority |
|------|-------------|----------|
| Functional | Verify feature requirements | High |
| Integration | API and service integration | High |
| Regression | Existing functionality | Medium |
| Performance | Load and response times | Medium |
| Security | Auth and session security | High |

### 2.2 Automation
- New API tests: Automated (Postman/Newman)
- UI flows: Automated (Playwright)
- Exploratory: Manual

## 3. Test Environment

### 3.1 Environment Details
| Environment | URL | Purpose |
|-------------|-----|---------|
| QA | qa.example.com | Functional testing |
| Staging | staging.example.com | UAT, Performance |

### 3.2 Test Data
- Synthetic user accounts (10 test users)
- Sample data set from prod (anonymized)

## 4. Test Schedule

| Phase | Start | End | Milestone |
|-------|-------|-----|-----------|
| Test preparation | Feb 1 | Feb 3 | Test cases ready |
| Functional testing | Feb 4 | Feb 10 | Feature testing complete |
| Regression testing | Feb 11 | Feb 13 | Regression pass |
| UAT | Feb 14 | Feb 16 | UAT sign-off |
| Go-live | Feb 17 | - | Production release |

## 5. Resources

| Role | Name | Responsibility |
|------|------|----------------|
| QA Lead | Alice | Plan owner, coordination |
| Test Engineer | Bob | Functional testing |
| Test Engineer | Charlie | Automation |
| Dev Support | Diana | Bug fixes, questions |

## 6. Entry/Exit Criteria

### Entry Criteria
- [ ] Feature development complete
- [ ] Unit tests passing
- [ ] Deployed to QA environment
- [ ] Test data available

### Exit Criteria
- [ ] All test cases executed
- [ ] Zero P1/P2 open defects
- [ ] >95% test cases passed
- [ ] Performance targets met
- [ ] Product Owner sign-off

## 7. Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Environment instability | Medium | High | Backup environment |
| Resource unavailability | Low | Medium | Cross-training |
| Late code delivery | Medium | High | Parallel testing |

## 8. Deliverables
- Test case specifications
- Test execution reports
- Defect reports
- Final test summary report
```

### Test Case Coverage Matrix

| Requirement | Test Cases | Automated | Status |
|-------------|------------|-----------|--------|
| REQ-001: Login | TC-001, TC-002, TC-003 | Yes | Ready |
| REQ-002: Logout | TC-010, TC-011 | Yes | Ready |
| REQ-003: Password Reset | TC-020, TC-021, TC-022 | Partial | In Progress |
| REQ-004: Session Timeout | TC-030 | Yes | Ready |

### Further Reading

- [TestRail - How to Create a Test Plan](https://www.testrail.com/blog/create-a-test-plan/)
- [Atlassian Test Plan Template](https://www.atlassian.com/software/confluence/resources/guides/how-to/test-plan)
- [Katalon Test Plan Guide 2025](https://katalon.com/resources-center/blog/test-plan-template)
- "Lessons Learned in Software Testing" - Kaner, Bach, Pettichord
