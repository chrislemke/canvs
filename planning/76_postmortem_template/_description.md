# Postmortem Template

## Overview

A Postmortem (also called Incident Retrospective) is a structured document created after an incident, outage, or significant issue to analyze what happened, why it happened, and how to prevent it from happening again. Originating from Site Reliability Engineering (SRE) practices at Google and Netflix, modern postmortems follow a "blameless" philosophy that focuses on system failures rather than individual fault. Effective postmortems promote organizational learning, psychological safety, and continuous improvement of systems and processes.

## Purpose

- **Learn from incidents**: Extract lessons to improve systems
- **Prevent recurrence**: Identify and address root causes
- **Build knowledge**: Create institutional memory of incidents
- **Improve response**: Enhance incident response processes
- **Foster culture**: Promote psychological safety and learning
- **Meet compliance**: Document incidents for regulatory requirements
- **Share insights**: Spread learnings across the organization

## When to Create

- **Major Incidents**: Any incident affecting customers or SLAs
- **Near Misses**: Close calls that could have been severe
- **Novel Failures**: New types of failures not seen before
- **Repeated Issues**: Recurring problems requiring deeper analysis
- **Security Incidents**: Any security breach or vulnerability exploitation
- **Data Issues**: Data loss, corruption, or exposure events
- **Request**: When leadership or team requests review

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Incident Commander | Leads postmortem process |
| Subject Matter Experts | Provide technical context |
| Responders | Share first-hand experience |
| Product Manager | Provides business context |
| Facilitator | Guides blameless discussion |
| Stakeholders | Review findings and action items |

## Key Components

### 1. Incident Summary
- Brief description of what happened
- Severity and impact
- Duration and timeline
- Services/customers affected
- Business impact

### 2. Timeline
- Chronological sequence of events
- When incident started
- When it was detected
- Key actions taken
- When it was resolved

### 3. Root Cause Analysis
- Technical root cause
- Contributing factors
- What allowed this to happen
- Five Whys analysis

### 4. Impact Assessment
- Customer impact (number affected, duration)
- Business impact (revenue, reputation)
- SLA/SLO impact
- Data impact

### 5. Response Evaluation
- What went well in the response
- What could have gone better
- Detection effectiveness
- Communication effectiveness

### 6. Action Items
- Preventive measures
- Detection improvements
- Process improvements
- Owners and deadlines

### 7. Lessons Learned
- Key takeaways
- Knowledge gaps identified
- Training needs

## Blameless Postmortem Principles

### Core Philosophy
- **Assume Good Intentions**: Everyone did their best with the information they had
- **Focus on Systems**: Blame the process, not the people
- **Psychological Safety**: Create space for honest discussion
- **Learning Orientation**: Goal is improvement, not punishment

### Ground Rules
1. No finger-pointing or blame
2. Focus on "what" and "how," not "who"
3. All perspectives are valuable
4. Mistakes are learning opportunities
5. Silence about problems is the real failure

### Language Patterns

**Avoid**: "Who made this change?" / "Why didn't you catch this?"
**Prefer**: "What allowed this change to have this impact?" / "How can we improve detection?"

## Postmortem Meeting Structure

### Before the Meeting (Facilitator)
1. Gather timeline and initial facts
2. Invite all relevant participants
3. Share pre-read materials
4. Prepare structured agenda

### During the Meeting (60-90 minutes)
| Time | Activity |
|------|----------|
| 5 min | Set ground rules, establish psychological safety |
| 15 min | Walk through timeline |
| 20 min | Root cause discussion |
| 15 min | What went well |
| 15 min | What could improve |
| 15 min | Action items and owners |
| 5 min | Wrap-up and next steps |

### After the Meeting
1. Finalize postmortem document
2. Distribute to stakeholders
3. Track action items to completion
4. Share learnings broadly

## Timing Best Practices

- **Hold within 24-72 hours**: Balance fresh memory with emotional processing
- **Ideal window**: 48 hours after incident resolution
- **Don't delay**: Waiting too long loses important details
- **Follow up**: Review action items at 30 days

## Inputs & Dependencies

- Incident detection alerts
- Response logs and chat transcripts
- Monitoring dashboards
- Timeline of events
- Customer impact data
- Previous related postmortems
- Change logs

## Outputs & Deliverables

- Completed postmortem document
- Prioritized action items with owners
- Updated runbooks (if applicable)
- Shared learnings (blog post, wiki, presentation)
- Tracking tickets for remediation
- Updated incident response procedures

## Best Practices

1. **Maintain Blamelessness**: The single most important factor in effective postmortems.

2. **Document Thoroughly**: Capture enough detail that someone unfamiliar can understand.

3. **Act Quickly**: Hold postmortem while memories are fresh (48-72 hours).

4. **Involve All Responders**: Get multiple perspectives on what happened.

5. **Follow Through**: Track action items to completion—unfinished items undermine trust.

6. **Share Widely**: Spread learnings across the organization, not just the team.

7. **Review Action Items**: Check progress at 30 days; close items or explain delays.

8. **Celebrate Learning**: Recognize that identifying problems is valuable, not shameful.

## Common Pitfalls

- **Blame Focus**: Turning into a witch hunt instead of learning exercise
- **Superficial Analysis**: Not getting to true root causes
- **No Follow-Through**: Action items that never get completed
- **Limited Audience**: Not sharing learnings broadly enough
- **Waiting Too Long**: Losing details by delaying the postmortem
- **Single Perspective**: Not including all relevant participants
- **Document Rot**: Creating docs no one reads or maintains
- **Punishment**: Using findings to penalize people

## Beyond Prevention: Complete Analysis

Effective postmortems don't just ask "how do we prevent this?" but also:
- How do we **detect** this faster?
- How do we **respond** more effectively?
- How do we **recover** more quickly?
- How do we **communicate** better during incidents?

## Building Postmortem Culture

### Leadership Actions
- Participate in postmortems regularly
- Model blameless language
- Celebrate learning from failure
- Ensure action items get resourced
- Share postmortems in all-hands

### Team Actions
- Volunteer for postmortem facilitation
- Contribute honestly to discussions
- Review and learn from others' postmortems
- Follow through on action items
- Suggest improvements to the process

## Tools

### Postmortem Platforms
- **Rootly**: Incident management with postmortems
- **FireHydrant**: Incident response platform
- **incident.io**: Incident management
- **Jeli**: Incident analysis platform

### Documentation
- **Notion**: Collaborative documents
- **Confluence**: Team documentation
- **Google Docs**: Collaborative writing
- **GitHub**: Version-controlled postmortems

### Timeline Reconstruction
- **Slack/Teams**: Chat history
- **PagerDuty**: Alert and response logs
- **Datadog**: Monitoring data
- **Git**: Change history

## Related Documents

- [Incident Response Playbook](../incident-response-playbook/_description.md) - Response procedures
- [Runbook / Operations Manual](../runbook-operations-manual/_description.md) - Operational procedures
- [Risk Register](../risk-register/_description.md) - Risk tracking
- [Monitoring & Observability Plan](../monitoring-observability-plan/_description.md) - Detection
- [SLO/SLI Definition](../slo-sli-definition/_description.md) - Service levels

## Examples & References

### Postmortem Template

```markdown
# Incident Postmortem: [Title]

**Date**: [Incident date]
**Author**: [Name]
**Incident Lead**: [Name]
**Status**: Draft / Final

---

## Summary

[2-3 sentence description of what happened, impact, and resolution]

**Severity**: SEV-1 / SEV-2 / SEV-3 / SEV-4
**Duration**: [Start time] - [End time] ([X hours Y minutes])
**Impact**: [Brief impact statement]

---

## Timeline (All times in UTC)

| Time | Event |
|------|-------|
| HH:MM | [First sign of issue] |
| HH:MM | Alert triggered: [description] |
| HH:MM | [Action taken] |
| HH:MM | [Escalation/communication] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix deployed] |
| HH:MM | [Incident resolved] |

---

## Impact

### Customer Impact
- **Users affected**: [Number]
- **Duration of impact**: [Time]
- **Degradation type**: [Full outage / Partial / Performance]

### Business Impact
- **SLA impact**: [Yes/No, details]
- **Revenue impact**: [Estimate if known]
- **Reputation impact**: [Assessment]

---

## Root Cause

[Detailed explanation of the root cause. What specifically failed
and why?]

### Contributing Factors
1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

### Five Whys
1. Why did [symptom] happen? → [Because...]
2. Why did [cause 1] happen? → [Because...]
3. Why did [cause 2] happen? → [Because...]
4. Why did [cause 3] happen? → [Because...]
5. Why did [cause 4] happen? → [Root cause]

---

## What Went Well

- [Thing that worked well in detection or response]
- [Effective communication or coordination]
- [Quick thinking or good decisions]

## What Could Be Improved

- [Gap in detection or alerting]
- [Response process issue]
- [Communication breakdown]
- [Documentation gap]

---

## Action Items

| Priority | Action | Owner | Due Date | Status |
|----------|--------|-------|----------|--------|
| P0 | [Immediate fix] | @name | [Date] | ⬜ |
| P1 | [Prevention measure] | @name | [Date] | ⬜ |
| P1 | [Detection improvement] | @name | [Date] | ⬜ |
| P2 | [Process improvement] | @name | [Date] | ⬜ |

---

## Lessons Learned

1. [Key lesson 1]
2. [Key lesson 2]
3. [Key lesson 3]

---

## References

- [Link to incident Slack channel]
- [Link to monitoring dashboard]
- [Link to related postmortems]
- [Link to customer communication]
```

### Severity Definitions

```markdown
# Incident Severity Levels

## SEV-1 (Critical)
- Complete service outage
- Data loss or breach
- Major customer impact
- Requires immediate executive attention

## SEV-2 (High)
- Significant degradation
- Major feature unavailable
- Substantial customer impact
- Requires immediate engineering attention

## SEV-3 (Medium)
- Partial degradation
- Minor feature unavailable
- Limited customer impact
- Requires prompt attention

## SEV-4 (Low)
- Minor issue
- Workaround available
- Minimal customer impact
- Normal priority resolution
```

### Further Reading

- [Google SRE Book: Postmortem Culture](https://sre.google/sre-book/postmortem-culture/)
- [Atlassian Blameless Postmortem Guide](https://www.atlassian.com/incident-management/postmortem/blameless)
- [Rootly Postmortem Meeting Guide 2025](https://rootly.com/incident-postmortems/meeting-guide)
- "The Field Guide to Understanding Human Error" - Sidney Dekker
