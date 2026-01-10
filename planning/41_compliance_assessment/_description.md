# Compliance Assessment

## Overview

A Compliance Assessment is a systematic evaluation of how well an organization's systems, processes, and controls meet regulatory requirements, industry standards, and internal policies. It identifies gaps between current state and required compliance levels, documents findings, and provides a roadmap for achieving and maintaining compliance. Compliance assessments are essential for organizations operating in regulated industries or handling sensitive data.

## Purpose

- **Identify gaps**: Discover where current state falls short of requirements
- **Reduce risk**: Mitigate legal, financial, and reputational risks
- **Guide remediation**: Provide actionable path to compliance
- **Enable certification**: Prepare for formal audits and certifications
- **Demonstrate due diligence**: Show stakeholders commitment to compliance
- **Inform decisions**: Help prioritize compliance investments
- **Maintain trust**: Build customer and partner confidence

## When to Create

- **New Regulations**: When new compliance requirements apply
- **System Changes**: Before major system implementations
- **Pre-Audit Preparation**: Before formal compliance audits
- **Annual Reviews**: Regular compliance health checks
- **New Markets**: When expanding to regulated jurisdictions
- **Customer Requirements**: When enterprise customers require compliance proof
- **Due Diligence**: During mergers, acquisitions, or funding rounds

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Compliance Officer | Leads assessment, interprets requirements |
| Legal Counsel | Provides regulatory interpretation |
| Security Team | Assesses security-related controls |
| IT/Engineering | Provides technical control information |
| Privacy Officer | Addresses data privacy requirements |
| External Auditors | Conducts independent assessment (optional) |

## Key Components

### 1. Scope Definition
- Regulations and standards in scope
- Systems and processes covered
- Organizational boundaries
- Time period assessed

### 2. Regulatory Requirements Mapping
- List of applicable regulations
- Specific requirements/articles
- Control objectives
- Interpretation of requirements

### 3. Current State Assessment
- Existing controls inventory
- Evidence of implementation
- Control effectiveness
- Documentation review

### 4. Gap Analysis
- Requirements vs. current state
- Identified gaps by severity
- Root cause analysis
- Risk implications

### 5. Remediation Plan
- Gap closure activities
- Priority and sequencing
- Resource requirements
- Responsible parties

### 6. Evidence Collection
- Control documentation
- Policy documents
- Technical configurations
- Process evidence
- Test results

## Common Compliance Frameworks

### Data Privacy
| Framework | Region | Focus |
|-----------|--------|-------|
| GDPR | EU/EEA | Personal data protection |
| CCPA/CPRA | California | Consumer privacy rights |
| HIPAA | US Healthcare | Protected health information |
| PIPEDA | Canada | Personal information protection |

### Security Standards
| Standard | Focus | Certification |
|----------|-------|---------------|
| SOC 2 | Service organization controls | Audit report |
| ISO 27001 | Information security management | Certification |
| PCI DSS | Payment card data security | Certification |
| NIST CSF | Cybersecurity framework | Self-assessment |

### Industry-Specific
| Standard | Industry | Focus |
|----------|----------|-------|
| FedRAMP | US Government | Cloud security |
| HITRUST | Healthcare | Security framework |
| SOX | Public companies | Financial controls |
| GLBA | Financial services | Data protection |

## Assessment Methodologies

### Control-Based Assessment
1. Map requirements to control objectives
2. Identify controls addressing each objective
3. Test control design and effectiveness
4. Document gaps and findings

### Risk-Based Assessment
1. Identify regulatory risks
2. Prioritize based on likelihood and impact
3. Assess controls for high-risk areas
4. Focus remediation on critical gaps

### Process-Based Assessment
1. Map business processes to regulations
2. Walk through process controls
3. Identify gaps in process coverage
4. Recommend process improvements

## Gap Severity Ratings

| Severity | Description | Action |
|----------|-------------|--------|
| Critical | Material violation, immediate risk | Immediate remediation required |
| High | Significant gap, likely finding in audit | Remediate before audit |
| Medium | Partial compliance, improvement needed | Planned remediation |
| Low | Minor gap, best practice improvement | Optional improvement |
| Observation | Recommendation, not a gap | Consider for improvement |

## Inputs & Dependencies

- Applicable regulations and standards
- Organizational policies and procedures
- System documentation
- Previous audit reports
- Risk assessments
- Security assessments
- Vendor contracts and certifications
- Training records

## Outputs & Deliverables

- Compliance assessment report
- Gap analysis matrix
- Remediation roadmap
- Evidence repository
- Control mapping documentation
- Risk register updates
- Executive summary for leadership
- Audit-ready documentation

## Best Practices

1. **Start with Scope**: Clearly define what's in and out of scope.

2. **Map Requirements First**: Understand what's required before assessing.

3. **Gather Evidence**: Document everything with timestamps and sources.

4. **Involve Stakeholders**: Compliance is not just the security team's job.

5. **Prioritize by Risk**: Focus on gaps that create the most exposure.

6. **Use Frameworks**: Leverage established control frameworks (e.g., NIST).

7. **Plan for Continuous Compliance**: Assessment is ongoing, not one-time.

8. **Automate Where Possible**: Use GRC tools to maintain compliance state.

## Common Pitfalls

- **Scope Creep**: Trying to assess everything at once
- **Paper Compliance**: Policies exist but aren't followed
- **Checkbox Mentality**: Meeting letter, not spirit, of requirements
- **Evidence Gaps**: Claims without documentation
- **Static Assessment**: Not updating as regulations change
- **Siloed Efforts**: Departments working independently
- **Audit Panic**: Scrambling before audits vs. continuous compliance
- **Ignoring Vendors**: Not assessing third-party compliance

## Tools

### GRC Platforms
- **Vanta**: Automated compliance monitoring
- **Drata**: Continuous compliance automation
- **Secureframe**: SOC 2 and compliance automation
- **OneTrust**: Privacy and compliance management
- **ServiceNow GRC**: Enterprise GRC platform

### Assessment Tools
- **AuditBoard**: Audit management
- **Tugboat Logic**: Security assurance
- **Hyperproof**: Compliance operations

### Evidence Collection
- **Notion/Confluence**: Policy documentation
- **Jira**: Remediation tracking
- **Cloud tools**: AWS Config, Azure Policy

## Related Documents

- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Security controls
- [Threat Model](../threat-model/_description.md) - Security risk analysis
- [Risk Register](../risk-register/_description.md) - Risk documentation
- [Vendor / Third-Party Contracts](../vendor-third-party-contracts/_description.md) - Vendor compliance
- [Legal Docs](../legal-docs/_description.md) - Legal requirements

## Examples & References

### Gap Analysis Matrix

| Req ID | Requirement | Current State | Gap | Severity | Remediation | Owner | Due Date |
|--------|-------------|---------------|-----|----------|-------------|-------|----------|
| GDPR-32 | Encryption at rest | Partial - DB encrypted, files not | Files unencrypted | High | Enable S3 encryption | DevOps | 2024-03-01 |
| SOC2-CC6.1 | Logical access controls | Implemented | None | N/A | Maintain | IT | Ongoing |
| PCI-3.4 | Mask PAN when displayed | Not implemented | Full gap | Critical | Implement masking | Dev | 2024-02-15 |
| HIPAA-164.312 | Audit controls | Partial - limited logging | Incomplete logs | Medium | Expand audit logging | Security | 2024-04-01 |

### Compliance Assessment Report Template

```markdown
# Compliance Assessment Report

## Executive Summary
- **Assessment Date**: [Date]
- **Scope**: [Regulations/systems assessed]
- **Overall Compliance Status**: [Percentage/Rating]
- **Critical Gaps**: [Count]
- **Estimated Remediation Effort**: [Summary]

## Scope & Methodology
### In Scope
- [Systems, regulations, time period]

### Methodology
- [Control testing approach]
- [Evidence collection process]
- [Rating criteria]

## Findings Summary

| Severity | Count |
|----------|-------|
| Critical | 2 |
| High | 5 |
| Medium | 8 |
| Low | 3 |

## Detailed Findings

### Finding 1: [Title]
- **Regulation**: [Reference]
- **Requirement**: [Description]
- **Current State**: [Observation]
- **Gap**: [What's missing]
- **Severity**: [Rating]
- **Evidence**: [What was reviewed]
- **Recommendation**: [How to remediate]
- **Target Date**: [When]

## Remediation Roadmap

### Phase 1: Critical & High (30 days)
[List of priority remediations]

### Phase 2: Medium (90 days)
[List of medium-priority remediations]

### Phase 3: Low & Continuous (Ongoing)
[List of lower-priority items]

## Appendices
- A: Evidence Index
- B: Control Mapping Matrix
- C: Detailed Test Results
```

### Control Mapping Example

| SOC 2 Criteria | Control Objective | Control Activity | Evidence |
|----------------|-------------------|------------------|----------|
| CC6.1 | Logical access | RBAC implementation | Access control policy, role matrix |
| CC6.2 | User provisioning | Onboarding process | HR workflow, access request tickets |
| CC6.3 | Access removal | Offboarding process | Termination checklist, access reviews |
| CC7.1 | Change management | Change control process | Change tickets, approval records |

### Further Reading

- "IT Auditing Using Controls to Protect Information Assets" - Mike Kegerreis
- ISACA COBIT Framework
- AICPA SOC 2 Guide
- NIST SP 800-53 Security Controls
- ISO 27001/27002 Standards
