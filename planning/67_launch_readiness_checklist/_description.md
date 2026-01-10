# Launch Readiness Checklist

## Overview

A Launch Readiness Checklist is a comprehensive verification document that ensures all necessary preparations are complete before a product or feature goes live. It serves as a final quality gate that catches critical issues—broken flows, missing documentation, untrained support teams, or compliance gaps—before they impact customers. A well-executed readiness review reduces the risk of launch failures and ensures a smooth customer experience from day one.

## Purpose

- **Verify completeness**: Confirm all launch activities are done
- **Reduce risk**: Catch issues before they affect customers
- **Align teams**: Ensure cross-functional readiness
- **Enable go/no-go**: Provide data for launch decision
- **Document readiness**: Create audit trail
- **Build confidence**: Launch with certainty
- **Prevent rework**: Avoid post-launch scrambles

## When to Create

- **Pre-Launch**: 2-4 weeks before planned launch
- **Major Releases**: For significant product updates
- **New Products**: Before initial market entry
- **Market Expansion**: When entering new regions
- **Platform Changes**: After major migrations
- **Compliance Changes**: When regulations require updates

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Owns checklist completion |
| Engineering Lead | Verifies technical readiness |
| QA Lead | Confirms quality gates met |
| Marketing | Validates marketing materials |
| Support | Confirms support readiness |
| Legal/Compliance | Approves regulatory items |
| Operations | Confirms operational readiness |

## Key Components

### 1. Product Readiness
- Feature completeness
- Quality verification
- Performance validation
- Security review

### 2. Technical Readiness
- Infrastructure capacity
- Deployment procedures
- Monitoring and alerting
- Rollback plan

### 3. Go-to-Market Readiness
- Marketing materials
- Sales enablement
- Pricing and billing
- Distribution channels

### 4. Operations Readiness
- Support documentation
- Support team training
- Escalation procedures
- Known issues documented

### 5. Legal and Compliance
- Terms of service
- Privacy policy
- Regulatory requirements
- Contracts and agreements

### 6. Communication Readiness
- Internal announcements
- External communications
- Press/PR materials
- Customer notifications

## Checklist Categories

### Product & Engineering
- [ ] All planned features complete and tested
- [ ] No P1/P2 bugs open
- [ ] Performance testing passed
- [ ] Security review completed
- [ ] Accessibility requirements met
- [ ] Beta feedback addressed
- [ ] Feature flags configured

### Infrastructure & Operations
- [ ] Infrastructure scaled for expected load
- [ ] Monitoring and alerting configured
- [ ] Runbooks and playbooks updated
- [ ] On-call schedule confirmed
- [ ] Rollback procedures tested
- [ ] Disaster recovery verified
- [ ] Third-party dependencies confirmed

### Documentation & Support
- [ ] User documentation published
- [ ] API documentation complete
- [ ] Support team trained
- [ ] FAQ and knowledge base updated
- [ ] Support tickets routing configured
- [ ] Escalation paths documented

### Marketing & Sales
- [ ] Website/landing page live
- [ ] Marketing materials approved
- [ ] Sales team trained
- [ ] Demo environment ready
- [ ] Pricing confirmed in system
- [ ] Analytics tracking implemented

### Legal & Compliance
- [ ] Terms of service updated
- [ ] Privacy policy updated
- [ ] Cookie consent configured
- [ ] Regulatory requirements met
- [ ] Contracts executed (partners, vendors)
- [ ] Export compliance verified

### Communication
- [ ] Internal launch email scheduled
- [ ] Customer announcement ready
- [ ] Press release (if applicable)
- [ ] Social media posts scheduled
- [ ] Partner notifications sent

## Go/No-Go Criteria

### Go Criteria
- All critical checklist items complete
- No blocking issues identified
- All stakeholders approve
- Rollback plan verified

### No-Go Triggers
- P1 bugs unresolved
- Critical documentation missing
- Support team not trained
- Legal review not complete
- Performance targets not met

## Inputs & Dependencies

- Beta program results
- QA testing results
- Security review findings
- Marketing plans
- Sales enablement materials
- Support training status
- Legal approvals

## Outputs & Deliverables

- Completed checklist
- Go/no-go recommendation
- Risk summary
- Launch day runbook
- Post-launch monitoring plan
- Communication schedule

## Best Practices

1. **Start Early**: Begin checklist review 2-4 weeks before launch.

2. **Assign Owners**: Each item should have a responsible person.

3. **Use Templates**: Standardize across launches.

4. **Hold Review Meeting**: Formal go/no-go discussion.

5. **Document Exceptions**: Record any accepted risks.

6. **Plan for Issues**: Have contingency plans ready.

7. **Communicate Status**: Keep stakeholders informed.

8. **Learn and Iterate**: Improve checklist after each launch.

## Common Pitfalls

- **Last-Minute Rush**: Completing items at the last minute
- **Checkbox Mentality**: Checking without verifying
- **Missing Stakeholders**: Forgetting key team input
- **Incomplete Items**: Partially done marked as complete
- **No Contingency**: No plan for launch-day issues
- **Poor Communication**: Teams not aligned on status
- **Ignored Risks**: Launching despite red flags
- **No Ownership**: Unclear who approves each section

## Tools

### Checklists
- **Notion/Confluence**: Documentation
- **Asana/Monday.com**: Task tracking
- **Google Sheets**: Simple checklists
- **ClickUp**: Project management
- **Jira**: Issue tracking

### Communication
- **Slack/Teams**: Team coordination
- **Email**: Stakeholder updates
- **Statuspage**: External status

### Monitoring
- **Datadog/New Relic**: Launch monitoring
- **PagerDuty**: Incident management

## Related Documents

- [Release Plan](../release-plan/_description.md) - Release coordination
- [Deployment Plan](../deployment-plan/_description.md) - Technical deployment
- [Beta Program Plan](../beta-program-plan/_description.md) - Pre-launch testing
- [Rollback Plan](../rollback-plan/_description.md) - Recovery procedures
- [Sales Enablement Pack](../sales-enablement-pack/_description.md) - Sales materials

## Examples & References

### Launch Readiness Checklist Template

```markdown
# Launch Readiness Checklist: [Product/Feature]

## Launch Information
- **Product/Feature**: [Name]
- **Planned Launch Date**: [Date]
- **Launch Owner**: [Name]
- **Review Meeting**: [Date/Time]

## Status Summary
| Category | Status | Owner | Notes |
|----------|--------|-------|-------|
| Product | 🟢 Ready | @pm | All features complete |
| Engineering | 🟢 Ready | @eng | Deployed to staging |
| QA | 🟡 In Progress | @qa | Final regression running |
| Marketing | 🟢 Ready | @mkt | Materials approved |
| Support | 🟡 In Progress | @support | Training tomorrow |
| Legal | 🟢 Ready | @legal | All docs approved |

---

## 1. Product Readiness

### Feature Completeness
- [x] All MVP features implemented
- [x] User acceptance testing complete
- [x] Beta feedback addressed
- [x] Edge cases handled

### Quality
- [x] No open P1 bugs
- [x] No open P2 bugs (or accepted risk)
- [x] Regression testing passed
- [ ] Final smoke test (scheduled)

### Performance
- [x] Load testing passed (2x expected traffic)
- [x] Page load times within targets
- [x] API response times within SLA

### Security
- [x] Security review completed
- [x] Penetration testing passed
- [x] Vulnerability scan clean
- [x] Data encryption verified

---

## 2. Technical Readiness

### Infrastructure
- [x] Production environment provisioned
- [x] Auto-scaling configured
- [x] CDN configured
- [x] SSL certificates valid

### Deployment
- [x] Deployment runbook complete
- [x] Deployment tested in staging
- [x] Rollback procedure verified
- [x] Feature flags configured

### Monitoring
- [x] Dashboards created
- [x] Alerts configured
- [x] On-call schedule confirmed
- [x] Runbooks updated

---

## 3. Go-to-Market Readiness

### Marketing
- [x] Landing page published
- [x] Blog post drafted
- [x] Email campaign scheduled
- [x] Social posts scheduled

### Sales
- [x] Sales team trained
- [x] Battle cards distributed
- [x] Demo environment ready
- [x] Pricing in system

### Pricing & Billing
- [x] Pricing confirmed
- [x] Billing integration tested
- [x] Invoicing configured

---

## 4. Support Readiness

### Documentation
- [x] Help center articles published
- [x] API documentation complete
- [x] Getting started guide ready

### Support Team
- [ ] Support team trained
- [x] FAQ prepared
- [x] Escalation paths documented
- [x] Ticket routing configured

---

## 5. Legal & Compliance

- [x] Terms of service updated
- [x] Privacy policy updated
- [x] Cookie consent configured
- [x] GDPR compliance verified
- [x] Data processing agreements signed

---

## 6. Communication

### Internal
- [ ] All-hands announcement scheduled
- [x] Slack announcement prepared
- [x] Leadership briefed

### External
- [x] Customer email drafted
- [x] Press release (if applicable)
- [x] Partner notifications sent

---

## Go/No-Go Decision

### Blocking Items
1. Support training (scheduled for tomorrow)
2. Final smoke test (scheduled for launch morning)

### Accepted Risks
1. Minor UI inconsistency in edge case (P3, will fix post-launch)

### Decision
- [ ] GO - Approved for launch
- [ ] NO-GO - Launch delayed

**Decision Made By**: _______________
**Date**: _______________
```

### Further Reading

- [Airtable Product Launch Checklist](https://www.airtable.com/articles/product-launch-checklist)
- [OCM Go-Live Checklist](https://www.ocmsolution.com/go-live-checklist/)
- [Orb SaaS Product Launch Checklist](https://www.withorb.com/blog/product-launch-checklist)
- [Product School Launch Checklist Guide](https://productschool.com/blog/product-marketing/product-launch-checklist-for-product-marketers)
