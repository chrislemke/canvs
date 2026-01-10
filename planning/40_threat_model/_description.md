# Threat Model

## Overview

A Threat Model is a structured analysis that identifies potential security threats to a system, evaluates their likelihood and impact, and determines appropriate countermeasures. Threat modeling is a proactive security practice that helps teams understand where their system is vulnerable before attackers do. By systematically analyzing threats, teams can prioritize security investments and build more resilient systems.

## Purpose

- **Identify vulnerabilities**: Find security weaknesses before attackers do
- **Prioritize risks**: Focus resources on the most critical threats
- **Guide security design**: Inform architecture and control decisions
- **Enable proactive security**: Shift security left in the development process
- **Facilitate communication**: Create shared understanding of security risks
- **Support compliance**: Demonstrate due diligence for security assessments
- **Reduce costs**: Fix security issues early when they're cheaper to address

## When to Create

- **System Design Phase**: Before building new systems
- **Major Changes**: When adding significant new functionality
- **New Integrations**: When connecting to external systems
- **Security Reviews**: Regular threat model reviews (annually or after changes)
- **Incident Response**: After security incidents to identify gaps
- **Compliance Requirements**: When security assessment is required

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Security Engineer | Leads threat modeling process |
| Software Architect | Provides system design context |
| Developers | Contribute implementation knowledge |
| DevOps/SRE | Adds infrastructure perspective |
| Product Manager | Provides business context |
| QA/Security Testing | Validates threat mitigations |

## Key Components

### 1. System Description
- Architecture diagrams
- Data flow diagrams
- Trust boundaries
- Entry points
- Assets to protect

### 2. Threat Identification
- Potential attackers (threat actors)
- Attack vectors
- Threat scenarios
- Vulnerability analysis

### 3. Threat Assessment
- Likelihood ratings
- Impact ratings
- Risk prioritization
- Threat categorization

### 4. Countermeasures
- Existing controls
- Proposed mitigations
- Residual risk acceptance
- Implementation priorities

### 5. Validation
- Security testing plans
- Penetration test requirements
- Control verification

## Threat Modeling Methodologies

### STRIDE
Microsoft's model categorizing threats by type:
| Category | Description | Example |
|----------|-------------|---------|
| **S**poofing | Pretending to be someone else | Forged authentication |
| **T**ampering | Modifying data or code | SQL injection |
| **R**epudiation | Denying actions | Missing audit logs |
| **I**nformation Disclosure | Exposing information | Data breach |
| **D**enial of Service | Making system unavailable | DDoS attack |
| **E**levation of Privilege | Gaining unauthorized access | Privilege escalation |

### PASTA (Process for Attack Simulation and Threat Analysis)
Seven-stage risk-centric methodology:
1. Define objectives
2. Define technical scope
3. Decompose application
4. Analyze threats
5. Identify vulnerabilities
6. Enumerate attacks
7. Risk and impact analysis

### DREAD (Historical Reference)
Risk rating model (less commonly used today):
- **D**amage potential
- **R**eproducibility
- **E**xploitability
- **A**ffected users
- **D**iscoverability

### Attack Trees
Hierarchical diagrams showing how assets can be attacked

### LINDDUN
Privacy-focused threat modeling (similar structure to STRIDE for privacy)

## Threat Modeling Process

### Step 1: Decompose the Application
- Create architecture diagrams
- Identify entry points
- Map data flows
- Define trust boundaries
- Catalog assets

### Step 2: Identify Threats
- Apply STRIDE to each component
- Consider attacker motivations
- Map attack surfaces
- Use threat libraries/checklists

### Step 3: Rate Threats
- Assess likelihood (1-5 scale)
- Assess impact (1-5 scale)
- Calculate risk score
- Prioritize by risk level

### Step 4: Determine Countermeasures
- Identify existing controls
- Propose new mitigations
- Accept, mitigate, transfer, or avoid
- Document security requirements

### Step 5: Validate
- Review with security team
- Plan security testing
- Verify implementations

## Inputs & Dependencies

- Architecture diagrams
- Data flow documentation
- Security requirements
- Known vulnerabilities database
- Previous threat models
- Compliance requirements
- Incident history

## Outputs & Deliverables

- Threat model document
- Data flow diagrams with trust boundaries
- Threat catalog with ratings
- Countermeasure recommendations
- Security requirements derived from threats
- Security testing requirements
- Risk register updates

## Best Practices

1. **Start Early**: Threat model during design, not after implementation.

2. **Keep It Updated**: Review threat models when systems change.

3. **Be Collaborative**: Include developers, not just security team.

4. **Use Visual Aids**: Data flow diagrams make threats easier to identify.

5. **Focus on High-Value Assets**: Prioritize protecting what matters most.

6. **Think Like an Attacker**: Consider what attackers want and how they'd get it.

7. **Document Assumptions**: Capture what you're assuming about the threat landscape.

8. **Iterate**: Threat modeling is ongoing, not one-time.

## Common Pitfalls

- **Analysis Paralysis**: Spending too much time on unlikely threats
- **Boiling the Ocean**: Trying to model everything at once
- **Ignoring Context**: Not considering business value of assets
- **No Follow-Through**: Creating threat models but not acting on findings
- **Security Silo**: Not involving developers in the process
- **Stale Models**: Not updating after system changes
- **Missing Trust Boundaries**: Not identifying where trust changes
- **Forgetting Insider Threats**: Only considering external attackers

## Tools

### Diagramming
- **draw.io**: Free diagramming with security shapes
- **Lucidchart**: Collaborative diagramming
- **Microsoft Threat Modeling Tool**: Free, STRIDE-based
- **Miro**: Collaborative whiteboarding

### Threat Modeling Platforms
- **OWASP Threat Dragon**: Open-source threat modeling
- **IriusRisk**: Automated threat modeling
- **ThreatModeler**: Enterprise threat modeling
- **Cairis**: Security design modeling

### Threat Intelligence
- **MITRE ATT&CK**: Adversary tactics and techniques
- **OWASP Top 10**: Common web application threats
- **CWE**: Common Weakness Enumeration

## Related Documents

- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Security controls
- [Architecture Overview](../architecture-overview/_description.md) - System architecture
- [Risk Register](../risk-register/_description.md) - Risk tracking
- [Compliance Assessment](../compliance-assessment/_description.md) - Regulatory context
- [Incident Response Playbook](../incident-response-playbook/_description.md) - Response to realized threats

## Examples & References

### Data Flow Diagram with Trust Boundaries

```
┌─────────────────────────────────────────────────────────────────┐
│                        INTERNET (Untrusted)                      │
│                                                                   │
│    ┌──────────┐                                                   │
│    │  User    │                                                   │
│    │ Browser  │                                                   │
│    └────┬─────┘                                                   │
└─────────│─────────────────────────────────────────────────────────┘
          │ HTTPS
══════════│═════════════════════════════════════════════════════════
          │        TRUST BOUNDARY: DMZ
          ▼
┌─────────────────────────────────────────────────────────────────┐
│    ┌──────────────┐        ┌──────────────┐                      │
│    │   WAF/CDN    │───────▶│   API GW     │                      │
│    └──────────────┘        └──────┬───────┘                      │
└─────────────────────────────────────│───────────────────────────┘
══════════════════════════════════════│═════════════════════════════
          │        TRUST BOUNDARY: Internal Network
          ▼
┌─────────────────────────────────────────────────────────────────┐
│    ┌──────────────┐        ┌──────────────┐                      │
│    │  App Server  │───────▶│   Database   │                      │
│    └──────────────┘        └──────────────┘                      │
│                    Internal Network                               │
└─────────────────────────────────────────────────────────────────┘
```

### Threat Catalog Example

| ID | Threat | STRIDE | Asset | Likelihood | Impact | Risk | Mitigation |
|----|--------|--------|-------|------------|--------|------|------------|
| T001 | SQL Injection | Tampering | Database | Medium | High | High | Parameterized queries, WAF |
| T002 | Session Hijacking | Spoofing | User Session | Medium | High | High | HTTPS, secure cookies, session timeout |
| T003 | Brute Force Login | Spoofing | Auth System | High | Medium | High | Rate limiting, MFA, account lockout |
| T004 | Data Exfiltration | Info Disclosure | Customer PII | Low | Critical | High | Encryption, DLP, access logging |
| T005 | DDoS Attack | DoS | API | Medium | High | High | CDN, rate limiting, auto-scaling |

### Threat Analysis Template

```markdown
## Threat: SQL Injection via Search Parameter

**ID**: T-2024-001
**STRIDE Category**: Tampering, Information Disclosure
**Asset**: Customer Database

### Description
Attacker injects malicious SQL via the search input field to extract,
modify, or delete data from the database.

### Attack Vector
1. Attacker identifies search form
2. Crafts malicious SQL payload
3. Submits via search parameter
4. Payload executes against database

### Likelihood: Medium
- Input exists in public-facing form
- Common attack technique
- Automated tools readily available

### Impact: Critical
- Full database access possible
- PII exposure (regulatory impact)
- Data modification/deletion possible

### Existing Controls
- Input validation (partial)
- WAF rules for SQLi patterns

### Recommended Mitigations
1. Use parameterized queries exclusively
2. Implement input validation whitelist
3. Apply least-privilege DB accounts
4. Add query logging for detection

### Residual Risk: Low (if mitigations applied)
```

### Further Reading

- "Threat Modeling: Designing for Security" - Adam Shostack
- OWASP Threat Modeling Cheat Sheet
- Microsoft Threat Modeling Security Fundamentals
- MITRE ATT&CK Framework
- "The Security Development Lifecycle" - Michael Howard
