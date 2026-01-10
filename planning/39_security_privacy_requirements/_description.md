# Security & Privacy Requirements

## Overview

Security and Privacy Requirements define how a system protects data, prevents unauthorized access, and ensures user privacy. Security requirements address confidentiality, integrity, and availability (the CIA triad), while privacy requirements focus on how personal data is collected, processed, stored, and shared. These requirements are increasingly driven by regulations (GDPR, CCPA, HIPAA) and are essential for building trust with users and meeting legal obligations.

## Purpose

- **Protect data**: Define how sensitive information is secured
- **Ensure compliance**: Meet legal and regulatory requirements
- **Build trust**: Demonstrate commitment to user privacy
- **Prevent breaches**: Establish controls to prevent security incidents
- **Guide development**: Inform secure coding practices
- **Enable audits**: Provide documentation for security assessments
- **Manage risk**: Identify and mitigate security risks

## When to Create

- **Project Inception**: Before any system design begins
- **New Features**: When handling new types of data
- **Compliance Requirements**: When regulations apply (GDPR, HIPAA, SOC 2)
- **Third-Party Integrations**: When sharing data with external systems
- **Security Reviews**: Before security audits or penetration tests
- **Data Classification**: When categorizing sensitive data

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Security Engineer | Defines security controls and requirements |
| Privacy Officer/DPO | Ensures privacy compliance |
| Software Architect | Designs secure architecture |
| Legal/Compliance | Interprets regulatory requirements |
| Product Manager | Balances security with usability |
| DevOps/SRE | Implements infrastructure security |

## Key Components

### 1. Authentication Requirements
- Authentication methods (passwords, MFA, SSO)
- Password policies
- Session management
- Account recovery processes

### 2. Authorization Requirements
- Role-based access control (RBAC)
- Permission models
- API authorization
- Resource-level access control

### 3. Data Protection Requirements
- Encryption at rest and in transit
- Key management
- Data masking and anonymization
- Secure data deletion

### 4. Privacy Requirements
- Data collection minimization
- Purpose limitation
- User consent mechanisms
- Data subject rights (access, deletion, portability)
- Privacy by design principles

### 5. Audit & Logging Requirements
- Audit trail requirements
- Log retention policies
- Security event logging
- Access logging

### 6. Network Security
- Firewall requirements
- Network segmentation
- API security (rate limiting, input validation)
- DDoS protection

### 7. Compliance Requirements
- Regulatory requirements (GDPR, CCPA, HIPAA, PCI-DSS)
- Industry standards (SOC 2, ISO 27001)
- Contractual security requirements

### 8. Incident Response
- Breach notification requirements
- Incident detection capabilities
- Response time requirements

## Security Frameworks

| Framework | Focus | Use Case |
|-----------|-------|----------|
| OWASP | Application security | Web/API security |
| NIST CSF | Enterprise security | Comprehensive security program |
| ISO 27001 | Information security management | Certification |
| SOC 2 | Service organization controls | SaaS providers |
| CIS Controls | Prioritized security actions | Implementation guidance |

## Privacy Regulations

| Regulation | Region | Key Requirements |
|------------|--------|------------------|
| GDPR | EU/EEA | Consent, data rights, DPO, breach notification |
| CCPA/CPRA | California | Disclosure, opt-out, data rights |
| HIPAA | US Healthcare | PHI protection, BAAs, security safeguards |
| PIPEDA | Canada | Consent, purpose limitation, safeguards |
| LGPD | Brazil | Similar to GDPR, data rights, DPO |

## Inputs & Dependencies

- Regulatory requirements applicable to your business
- Data classification (what data you handle)
- Threat model and risk assessment
- Industry standards and benchmarks
- Customer security requirements
- Existing security policies
- Third-party security assessments

## Outputs & Deliverables

- Security requirements specification
- Privacy requirements document
- Data classification matrix
- Security controls matrix
- Privacy impact assessment (PIA)
- Security architecture documentation
- Compliance mapping documentation

## Best Practices

1. **Security by Design**: Build security in from the start, not as an afterthought.

2. **Privacy by Default**: Collect minimum data necessary; default to privacy-protective settings.

3. **Defense in Depth**: Layer multiple security controls.

4. **Least Privilege**: Grant minimum access necessary for each role.

5. **Data Minimization**: Only collect and retain data you need.

6. **Regular Reviews**: Security requirements evolve with threats and regulations.

7. **Document Everything**: Maintain clear records for audits.

8. **Test Security**: Validate requirements through penetration testing and audits.

## Common Pitfalls

- **Security Afterthought**: Adding security late in development
- **Checkbox Compliance**: Meeting letter of regulations without spirit
- **Over-Collection**: Gathering more data than needed
- **Forgotten Data**: Not tracking where personal data flows
- **Weak Authentication**: Insufficient identity verification
- **No Encryption**: Data unprotected at rest or in transit
- **Insufficient Logging**: Can't detect or investigate incidents
- **Third-Party Risk**: Not vetting vendor security practices

## Tools

### Security Testing
- **OWASP ZAP**: Web application security scanner
- **Burp Suite**: Security testing platform
- **Snyk**: Dependency vulnerability scanning
- **SonarQube**: Code security analysis

### Privacy Management
- **OneTrust**: Privacy management platform
- **TrustArc**: Privacy compliance
- **Osano**: Consent management

### Compliance
- **Vanta**: SOC 2 automation
- **Drata**: Compliance automation
- **Secureframe**: Security compliance platform

### Secrets Management
- **HashiCorp Vault**: Secrets management
- **AWS Secrets Manager**: Cloud secrets
- **1Password Teams**: Credential management

## Related Documents

- [Threat Model](../threat-model/_description.md) - Security threat analysis
- [Compliance Assessment](../compliance-assessment/_description.md) - Regulatory compliance
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Broader quality requirements
- [Architecture Overview](../architecture-overview/_description.md) - Security architecture
- [Risk Register](../risk-register/_description.md) - Security risk tracking

## Examples & References

### Security Requirement Template

```markdown
## SEC-001: Multi-Factor Authentication

**Category**: Authentication
**Priority**: Critical
**Regulation**: SOC 2, GDPR (where applicable)

**Requirement**:
All user accounts with access to sensitive data must support and
encourage multi-factor authentication (MFA).

**Implementation**:
- Support TOTP authenticator apps
- Support SMS as backup (with security warnings)
- Support hardware security keys (WebAuthn)
- MFA required for admin accounts

**Acceptance Criteria**:
- [ ] MFA enrollment flow implemented
- [ ] MFA verification on login implemented
- [ ] Recovery flow for lost MFA devices
- [ ] Admin accounts cannot disable MFA
```

### Privacy Requirement Template

```markdown
## PRIV-001: Right to Deletion (GDPR Art. 17)

**Category**: Data Subject Rights
**Regulation**: GDPR, CCPA

**Requirement**:
Users must be able to request deletion of their personal data,
and the system must process deletions within 30 days.

**Implementation**:
- Self-service deletion in account settings
- Email-based deletion request option
- Automated deletion workflow
- Deletion confirmation to user
- Cascade deletion to backup systems within 90 days

**Exceptions**:
- Legal hold requirements
- Fraud prevention data (anonymized)
- Financial records (legal retention)

**Verification**:
- Quarterly audit of deletion requests
- Deletion completion logging
```

### Data Classification Matrix

| Classification | Examples | Encryption | Access | Retention |
|----------------|----------|------------|--------|-----------|
| Public | Marketing content | Optional | Any | Indefinite |
| Internal | Internal docs | In transit | Employees | Business need |
| Confidential | Customer data | At rest + transit | Role-based | Policy-defined |
| Restricted | PII, PHI, PCI | AES-256 + strict | Need-to-know | Minimum required |

### Further Reading

- OWASP Application Security Verification Standard (ASVS)
- NIST Privacy Framework
- "Security Engineering" - Ross Anderson
- "Data and Goliath" - Bruce Schneier
- IAPP (International Association of Privacy Professionals) resources
