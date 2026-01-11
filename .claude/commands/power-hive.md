---
description: Intelligent hive-mind orchestration - analyzes objectives, selects optimal topology/mode, executes with auto-scaling
allowed-tools: Task, Read, Write, Bash(*), Glob, Grep, AskUserQuestion, TodoWrite, mcp__claude-flow__*
argument-hint: <objective>
---

# Power Hive Orchestrator

**Objective:** $ARGUMENTS

You are an intelligent hive-mind orchestrator. Analyze the objective, select optimal configuration, and execute a Claude Flow hive-mind.

## Phase 1: Objective Analysis

### 1.1 Parse the Objective
Analyze `$ARGUMENTS` for:
- Core task description
- Implied scope and deliverables
- Technical domain indicators
- Complexity signals

### 1.2 Check for Ambiguity
If the objective is vague or missing critical information, use `AskUserQuestion` to clarify:
- **Scope**: What's included/excluded?
- **Deliverables**: What specific outputs are expected?
- **Constraints**: Tech stack, dependencies, limitations?
- **Success criteria**: How will completion be measured?

Only ask questions if genuinely needed. Skip if the objective is clear.

## Phase 2: Task Classification

### 2.1 Determine Task Type
Analyze keywords in the objective to classify:

| Type | Keywords | Topology | Mode |
|------|----------|----------|------|
| Full-stack development | build, create, app, frontend, backend, web | **mesh** | **hybrid** |
| Complex integration | integrate, connect, API, service, third-party | **mesh** | **adaptive** |
| Enterprise application | enterprise, scale, production, distributed | **hierarchical** | **hybrid** |
| Microservices | microservice, container, kubernetes, docker | **hierarchical** | **parallel** |
| Mobile application | mobile, iOS, Android, react-native, flutter | **mesh** | **parallel** |
| CI/CD pipeline | deploy, pipeline, workflow, github actions, automation | **ring** | **sequential** |
| Data processing | data, ETL, processing, transform, batch | **ring** | **sequential** |
| Machine learning | ML, model, training, prediction, AI, neural | **hierarchical** | **adaptive** |
| Simple/prototype | simple, prototype, test, poc, demo, quick | **star** | **parallel** |

### 2.2 Assess Complexity
Rate complexity (1-5) based on:
- Number of components/services
- Integration points
- State management requirements
- Testing complexity
- Security considerations

**Complexity to Agent Count:**
- Low (1-2): 5 agents
- Medium (3): 8 agents
- High (4): 11 agents
- Very High (5): 15 agents

### 2.3 Identify Challenges
Document potential pitfalls relevant to the objective:
- Integration complexity
- State management
- Testing requirements
- Performance bottlenecks
- Security concerns
- Dependency management
- Error handling
- Scalability issues

## Phase 3: Present Analysis and Confirm

Before proceeding, present your analysis summary:

```
## Analysis Summary

**Objective:** [refined objective]

**Classification:**
- Type: [task type]
- Complexity: [1-5] ([description])

**Selected Configuration:**
- Topology: [mesh|hierarchical|ring|star]
  Rationale: [why this topology fits]
- Mode: [parallel|sequential|adaptive|hybrid]
  Rationale: [why this mode fits]
- Agent Count: [number]

**Identified Challenges:**
1. [challenge 1] - Mitigation: [approach]
2. [challenge 2] - Mitigation: [approach]
```

Use `AskUserQuestion` to confirm:
- Question: "Proceed with this hive-mind configuration?"
- Options: "Yes, proceed", "Modify configuration", "Cancel"

If user selects "Modify configuration", ask what they want to change (topology, mode, or agent count) and update accordingly.

## Phase 4: Initialize Hive

After confirmation, check if hive needs initialization:

```bash
ls -la .hive-mind 2>/dev/null || echo "NEEDS_INIT"
```

If `.hive-mind` folder does NOT exist, run:
```bash
npx claude-flow@alpha hive init --topology [selected_topology] --agents [agent_count] --memory-size 1GB --neural-patterns enabled
```

## Phase 5: Execute Orchestration

Run the orchestration command with the selected mode:
```bash
npx claude-flow@alpha orchestrate "[objective]" --auto-scale --[selected_mode]
```

Where `[selected_mode]` is one of: `parallel`, `sequential`, `adaptive`, `hybrid`

## Phase 6: Summary Report

After execution, provide a structured report:

```
## Hive-Mind Execution Report

### Configuration Used
| Setting | Value |
|---------|-------|
| Topology | [value] |
| Mode | [value] |
| Agents | [value] |
| Auto-scale | enabled |

### Execution Status
- Initialization: [success/skipped]
- Orchestration: [success/failed]
- Duration: [time if available]

### Outputs Generated
- [list any outputs or artifacts created]

### Recommendations
- [next steps or follow-up actions]
```

## Execution Checklist
- [ ] Objective analyzed and clarified
- [ ] Task classified (type, complexity)
- [ ] Configuration selected (topology, mode, agents)
- [ ] Challenges identified with mitigations
- [ ] User confirmation obtained
- [ ] Hive initialized (if needed)
- [ ] Orchestration executed
- [ ] Summary report generated
