# QA Checklist

## Overview

A QA Checklist is a structured list of verification items that testers and developers use to ensure software quality at various stages of the development lifecycle. Unlike comprehensive test cases, checklists provide quick, actionable items that help catch common issues and ensure consistent quality practices. QA checklists serve as quality gates, ensuring nothing critical is missed before advancing to the next stage.

## Purpose

- **Ensure consistency**: Standardize quality checks across team members
- **Prevent oversights**: Catch common issues before they escape
- **Speed up testing**: Enable quick verification without detailed test cases
- **Support onboarding**: Help new team members follow quality standards
- **Create accountability**: Document that checks were performed
- **Enable sign-off**: Provide evidence for quality gates
- **Reduce rework**: Catch issues early in the process

## When to Create

- **Development Process**: During or after feature implementation
- **Code Review**: Before merging code changes
- **Pre-Deployment**: Before releasing to environments
- **Release Validation**: Before production deployment
- **Periodic Audits**: Regular quality health checks
- **New Features**: When establishing quality criteria

## Who's Involved

| Role | Responsibility |
|------|----------------|
| QA Engineer | Creates and executes checklists |
| Developers | Uses checklists during development |
| Tech Lead | Reviews and approves checklist completeness |
| DevOps | Uses deployment checklists |
| Product Owner | Uses acceptance checklists |
| Release Manager | Uses release checklists |

## Types of QA Checklists

### 1. Development Checklist
- Code standards followed
- Unit tests written
- Documentation updated
- Security considerations addressed

### 2. Code Review Checklist
- Code is readable and maintainable
- Error handling is appropriate
- No hardcoded values
- No security vulnerabilities

### 3. Testing Checklist
- Functional requirements verified
- Edge cases tested
- Cross-browser compatibility
- Accessibility compliance

### 4. Pre-Deployment Checklist
- All tests passing
- Configuration verified
- Database migrations tested
- Rollback plan ready

### 5. Release Checklist
- Smoke tests passed
- Performance benchmarks met
- Documentation complete
- Stakeholders notified

### 6. Security Checklist
- Input validation implemented
- Authentication/authorization verified
- Sensitive data protected
- OWASP Top 10 addressed

## Key Components

### Checklist Structure
- **Category**: Grouping of related items
- **Check Item**: Specific verification point
- **Status**: Pass/Fail/N/A
- **Notes**: Comments or observations
- **Verifier**: Person who checked

### Quality Criteria
- Clear and unambiguous items
- Measurable or observable outcomes
- Prioritized by importance
- Actionable and specific

## Inputs & Dependencies

- Quality standards and guidelines
- Test strategy and requirements
- Security requirements
- Accessibility standards
- Performance requirements
- Previous defect patterns
- Regulatory requirements

## Outputs & Deliverables

- Completed checklists with sign-offs
- Issue reports from failed items
- Quality metrics (pass rates)
- Audit trail documentation
- Improvement suggestions

## Best Practices

1. **Keep It Concise**: Focus on critical items; avoid checklist fatigue.

2. **Make Items Specific**: "Test login" is vague; "Verify login with valid credentials" is specific.

3. **Categorize Logically**: Group related items for easier navigation.

4. **Update Regularly**: Evolve checklists based on new learnings.

5. **Automate Where Possible**: Integrate checks into CI/CD pipelines.

6. **Include "Why"**: Help users understand the importance of each item.

7. **Version Control**: Track changes to checklists over time.

8. **Make Accessible**: Store where team can easily find and use.

## Common Pitfalls

- **Too Long**: Checklists that take too long to complete
- **Too Generic**: Items that don't apply to specific context
- **Never Updated**: Stale checklists that miss new concerns
- **Checkbox Mentality**: Checking items without actually verifying
- **Duplicated Effort**: Overlapping with automated tests
- **No Follow-Through**: Finding issues but not tracking resolution
- **Missing Context**: Items without clear verification criteria

## Tools

### Checklist Management
- **Notion/Confluence**: Documentation with checklists
- **Jira**: Custom fields for checklists
- **GitHub Issues/PRs**: PR templates with checklists
- **SafetyCulture (iAuditor)**: Inspection checklists
- **Manifestly**: Team checklist management

### Automation Integration
- **CI/CD Pipelines**: Automated quality gates
- **Linters/Analyzers**: Automated code checks
- **Accessibility Scanners**: Automated a11y checks

## Related Documents

- [Test Strategy](../test-strategy/_description.md) - Testing approach
- [Test Plan](../test-plan/_description.md) - Detailed test planning
- [Definition of Ready / Done](../definition-of-ready-done/_description.md) - Quality criteria
- [Release Plan](../release-plan/_description.md) - Release process
- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Security criteria

## Examples & References

### Development Checklist

```markdown
## Feature Development Checklist

### Code Quality
- [ ] Code follows team style guide
- [ ] No console.log or debug statements
- [ ] No TODO comments without issue reference
- [ ] Functions are appropriately sized (<50 lines)
- [ ] Variable/function names are descriptive

### Testing
- [ ] Unit tests written for new code
- [ ] Unit test coverage >80% for new code
- [ ] Edge cases identified and tested
- [ ] Integration tests added (if applicable)
- [ ] Manual testing completed

### Security
- [ ] Input validation implemented
- [ ] No sensitive data logged
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevention in place
- [ ] Authentication/authorization verified

### Documentation
- [ ] README updated (if applicable)
- [ ] API documentation updated
- [ ] Code comments for complex logic
- [ ] CHANGELOG entry added
```

### Code Review Checklist

```markdown
## Code Review Checklist

### Correctness
- [ ] Logic is correct and handles requirements
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No obvious bugs or issues

### Maintainability
- [ ] Code is readable and self-documenting
- [ ] No code duplication
- [ ] Appropriate abstraction level
- [ ] Follows SOLID principles

### Performance
- [ ] No obvious performance issues
- [ ] Database queries are optimized
- [ ] No unnecessary API calls
- [ ] Appropriate caching considered

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input is validated and sanitized
- [ ] No SQL injection vulnerabilities
- [ ] Authorization checks in place
```

### Pre-Release Checklist

```markdown
## Pre-Release Checklist

### Testing Verification
- [ ] All automated tests passing
- [ ] Regression testing complete
- [ ] Performance testing complete
- [ ] Security scan completed
- [ ] UAT sign-off obtained

### Environment
- [ ] Configuration reviewed for production
- [ ] Environment variables set correctly
- [ ] SSL certificates valid
- [ ] DNS configured correctly

### Deployment
- [ ] Database migration tested
- [ ] Rollback plan documented
- [ ] Deployment runbook reviewed
- [ ] On-call team notified

### Communication
- [ ] Release notes prepared
- [ ] Stakeholders notified
- [ ] Support team briefed
- [ ] Monitoring alerts configured
```

### Web Application Testing Checklist

```markdown
## Web Application QA Checklist

### Functionality
- [ ] All links working (no 404s)
- [ ] Forms submit correctly
- [ ] Validation messages display properly
- [ ] Success/error states handled
- [ ] Search functionality works

### Compatibility
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile browsers (iOS Safari, Chrome)

### Accessibility
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast sufficient
- [ ] Alt text for images
- [ ] Focus states visible

### Performance
- [ ] Page load time <3 seconds
- [ ] Images optimized
- [ ] No console errors
- [ ] Lighthouse score >80

### Security
- [ ] HTTPS enabled
- [ ] Cookies secure and HttpOnly
- [ ] CORS configured correctly
- [ ] CSP headers in place
```

### Further Reading

- [Katalon Web QA Checklist](https://katalon.com/resources-center/blog/web-qa-checklist)
- [Software Testing Help QA Checklist](https://www.softwaretestinghelp.com/software-testing-qa-checklists/)
- [OWASP Testing Checklist](https://owasp.org/www-project-web-security-testing-guide/)
- "The Checklist Manifesto" - Atul Gawande
