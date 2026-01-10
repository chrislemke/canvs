# Technical Discovery / Feasibility Notes

## Overview

Technical Discovery and Feasibility Notes document the findings from exploratory technical work conducted before committing to full implementation. This includes technical spikes, proof-of-concepts, architecture exploration, and feasibility assessments. The goal is fact-finding—answering specific technical questions to reduce risk and inform decisions without producing production code.

## Purpose

- **Reduce risk**: Identify technical challenges before they derail projects
- **Inform decisions**: Provide evidence for technology and architecture choices
- **Enable estimation**: Better understand effort required for implementation
- **Avoid surprises**: Discover constraints and dependencies early
- **Document learnings**: Capture knowledge for future reference
- **Validate assumptions**: Test hypotheses about technical feasibility

## When to Create

- **Before Major Projects**: When evaluating new technologies or architectures
- **New Integration**: When connecting to unfamiliar third-party systems
- **Complex Features**: When implementing technically challenging functionality
- **Technology Decisions**: When choosing between alternative approaches
- **After ADS/Discovery Sessions**: Before engineering sprints begin
- **Uncertainty Reduction**: When technical unknowns are high

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Technical Lead/Architect | Leads discovery, synthesizes findings |
| Engineers | Conduct spikes and experiments |
| Product Manager | Defines questions to answer, uses findings |
| DevOps/Platform | Contributes infrastructure perspective |
| Security | Reviews security implications |

## Key Components

### 1. Problem Statement / Goals
- Why this discovery is being conducted
- Specific questions to answer
- What decision this will inform
- Success criteria for the spike

### 2. Scope & Constraints
- Time-boxed duration (typically 1-3 days)
- What's in and out of scope
- Assumptions going in
- Known constraints

### 3. Approach
- Methodology used
- Technologies/tools evaluated
- Environment setup requirements
- Testing approach

### 4. Findings
- Answers to the posed questions
- Technical observations
- Performance characteristics
- Limitations discovered
- Integration challenges

### 5. Evidence
- Test results and data
- Code samples (not production code)
- Screenshots or diagrams
- Benchmark results

### 6. Recommendations
- Recommended approach based on findings
- Trade-offs between options
- Risks and mitigation strategies
- Next steps

### 7. Appendix
- Detailed test results
- Configuration details
- Reproducibility instructions

## Types of Technical Discovery

### Technical Spike
- Short, focused exploration
- Answers specific technical question
- Produces findings document, not code

### Proof of Concept (PoC)
- Demonstrates feasibility of approach
- Slightly more substantial than spike
- May produce working prototype

### Architecture Spike
- Explores system design options
- Evaluates patterns and structures
- Informs architecture decisions

### Integration Spike
- Tests third-party integration feasibility
- Evaluates API capabilities
- Identifies integration challenges

### Performance Spike
- Tests performance characteristics
- Identifies bottlenecks
- Establishes baseline metrics

## Inputs & Dependencies

- Product requirements and context
- Technical questions to answer
- Access to technologies being evaluated
- Test environment
- Time allocation
- Previous research or documentation

## Outputs & Deliverables

- Technical findings document
- Recommendations for next steps
- Go/no-go decision input
- Updated risk assessment
- Estimation input
- Knowledge transfer materials

## Best Practices

1. **Time-Box Strictly**: Set clear time limits and stick to them.

2. **Define Questions Upfront**: Know what you're trying to answer before starting.

3. **Focus on Fact-Finding**: The goal is learning, not decision-making.

4. **Document Thoroughly**: Capture setup, process, and results for reproducibility.

5. **Don't Build Production Code**: Spike code is disposable—resist the temptation to polish.

6. **Include Evidence**: Support findings with data, not just opinions.

7. **Share Learnings**: Present findings to the broader team.

8. **Update Based on Results**: Adjust plans based on what you learned.

## Common Pitfalls

- **Scope Creep**: Letting the spike expand beyond its original questions
- **Production Creep**: Trying to make spike code production-ready
- **No Time-Box**: Running indefinitely without deadlines
- **Vague Goals**: Starting without clear questions to answer
- **No Documentation**: Conducting discovery without capturing learnings
- **Ignoring Results**: Proceeding despite concerning findings
- **Solo Effort**: Not sharing knowledge with the team
- **Confirmation Bias**: Only looking for evidence that supports preferred approach

## Tools

- **Documentation**: Confluence, Notion, Markdown in repo
- **Diagramming**: Miro, Lucidchart, draw.io
- **Testing**: Postman, JMeter for performance
- **Code**: Disposable repos, sandbox environments

## Related Documents

- [Architecture Overview](../architecture-overview/_description.md) - Architecture decisions informed by discovery
- [API Specification](../api-specification/_description.md) - API design following integration spikes
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Performance requirements validation
- [Risk Register](../risk-register/_description.md) - Technical risks identified
- [Decision Log](../decision-log/_description.md) - Decisions based on findings

## Examples & References

### Technical Spike Document Template

```
# Technical Spike: [Title]

## Overview
- **Date**: [Date]
- **Duration**: [Time spent]
- **Author**: [Name]
- **Status**: Complete / In Progress

## Problem Statement
[Why are we doing this spike?]

## Questions to Answer
1. [Specific question 1]
2. [Specific question 2]
3. [Specific question 3]

## Approach
[How did we explore this?]

## Findings

### Question 1: [Question]
**Answer**: [Finding]
**Evidence**: [Data/results supporting this]

### Question 2: [Question]
**Answer**: [Finding]
**Evidence**: [Data/results supporting this]

## Recommendations
Based on findings, we recommend [approach] because [rationale].

## Risks & Concerns
- [Risk 1]
- [Risk 2]

## Next Steps
- [ ] [Action item]
- [ ] [Action item]

## Appendix
[Detailed results, configurations, code snippets]
```

### Spike Result Summary Example

| Question | Finding | Confidence | Impact |
|----------|---------|------------|--------|
| Can API X handle 1000 req/s? | Yes, tested to 1500 | High | Proceed |
| Does library Y support feature Z? | Partial - requires workaround | Medium | Proceed with caution |
| Is vendor integration feasible? | No - missing critical capability | High | Explore alternatives |

### Further Reading

- "Technical Spike" - Microsoft Engineering Fundamentals Playbook
- "Engineering Feasibility Spikes" - Microsoft Engineering Playbook
- "Technical Feasibility Study in Software Engineering" - Apriorit
- "Spike (software development)" - Wikipedia
