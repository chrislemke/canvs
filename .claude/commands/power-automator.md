---
description: Intelligent workflow automation with objective analysis, task decomposition, and agent orchestration
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, TodoWrite
argument-hint: <objective>
---

# Power Automation

Analyze the objective, decompose it into tasks, assign agents, generate a workflow, and execute it.

**Objective:** $ARGUMENTS

---

## Phase 1: Objective Analysis

Analyze the provided objective for clarity and completeness.

**Check for ambiguities:**
- Is the scope clear? (what's included/excluded)
- Are deliverables defined? (what should be produced)
- Are there constraints? (time, technology, dependencies)
- Is success criteria clear? (how to know when done)

**If ANY ambiguity exists:** Use `AskUserQuestion` to clarify before proceeding.

**Store the refined objective for later phases.**

---

## Phase 2: Deep Analysis

### 2.1 Classification

Classify the objective type by analyzing keywords:

| Type | Keywords |
|------|----------|
| **DEVELOPMENT** | build, create, implement, code, API, app, feature, deploy, fix, refactor |
| **RESEARCH** | research, analyze, investigate, compare, study, review, explore, evaluate |
| **HYBRID** | Contains BOTH development AND research keywords |

### 2.2 Task Decomposition

Break the objective into 4-8 discrete tasks. For each task define:
- `id`: Unique slug (e.g., `api-design`, `data-analysis`)
- `name`: Human-readable name
- `description`: What the task accomplishes
- `type`: design | implementation | testing | research | analysis | synthesis | documentation
- `dependencies`: Array of task IDs this depends on
- `parallel`: true if can run alongside other tasks with same dependencies

### 2.3 Agent Selection

Match tasks to the most appropriate agents:

| Agent | Best For |
|-------|----------|
| `planner` | Task planning, architecture decisions |
| `researcher` | Information gathering, analysis |
| `coder` | Code implementation |
| `backend-dev` | API, server, database work |
| `system-architect` | System design, architecture |
| `tester` | Test creation, quality assurance |
| `reviewer` | Code review, quality checks |
| `api-docs` | Documentation generation |
| `ml-developer` | Machine learning tasks |
| `specification` | Requirements analysis |
| `pseudocode` | Algorithm design |

### 2.4 Agent Assignment

Assign one primary agent to each task based on capability match.

### 2.5 Store Analysis

Use `TodoWrite` to track the decomposed tasks with their assignments.

---

## Phase 3: Template Selection

Based on classification from 2.1:

| Classification | Template Path |
|----------------|---------------|
| DEVELOPMENT | `.claude/commands/power_automation_examples/development.json` |
| RESEARCH | `.claude/commands/power_automation_examples/research.json` |
| HYBRID | Read BOTH templates; research tasks first, then development tasks |

Read the selected template(s) to understand the structure.

---

## Phase 4: Custom Workflow Generation

Create a new workflow JSON file customized to the objective.

### Workflow Structure
```json
{
  "name": "<slugified-objective>-workflow",
  "description": "<objective description>",
  "version": "1.0",
  "variables": {
    "project_name": "<extracted or inferred>",
    "objective": "<the refined objective>"
  },
  "agents": [
    {
      "id": "<agent-id>",
      "type": "<coordinator|implementer|tester|researcher|analyst>",
      "name": "<Agent Name>",
      "capabilities": ["<relevant>", "<capabilities>"]
    }
  ],
  "tasks": [
    {
      "id": "<task-id>",
      "name": "<Task Name>",
      "type": "<task-type>",
      "description": "<task description>",
      "assignTo": "<agent-id>",
      "depends": ["<dependency-task-ids>"],
      "parallel": <true|false>,
      "claudePrompt": "<detailed prompt for the agent>",
      "input": { "<variable references>" },
      "output": { "<expected outputs>" }
    }
  ],
  "settings": {
    "maxConcurrency": 3,
    "timeout": 1800000,
    "retryPolicy": "immediate",
    "failurePolicy": "<see below>",
    "outputFormat": "stream-json"
  }
}
```

### Failure Policy by Type
- **DEVELOPMENT**: `"failurePolicy": "fail-fast"` - Stop on first error
- **RESEARCH**: `"failurePolicy": "continue"` - Skip failed tasks, continue with rest
- **HYBRID**: Use `"continue"` for research phase, `"fail-fast"` for development phase

### Save Location
```bash
mkdir -p claude-flow-workflows
```
Save to: `claude-flow-workflows/<slug>-workflow.json`

---

## Phase 5: Workflow Execution

Execute the generated workflow:

```bash
npx claude-flow@alpha automation run-workflow claude-flow-workflows/<slug>-workflow.json --non-interactive --executor
```

Monitor the execution output for progress and any errors.

---

## Phase 6: Summary Report

After execution completes, provide a summary:

```
## Workflow Execution Summary

**Objective:** <original objective>
**Type:** <DEVELOPMENT | RESEARCH | HYBRID>
**Workflow:** claude-flow-workflows/<slug>-workflow.json

### Tasks Executed
| Task | Agent | Status |
|------|-------|--------|
| <task name> | <agent> | <completed/failed/skipped> |

### Agents Used
- <agent list with their roles>

### Outputs
- <list of generated outputs/files>

### Warnings/Errors
- <any issues encountered>
```

---

## Execution Checklist

1. [ ] Analyzed objective for ambiguities
2. [ ] Classified as DEVELOPMENT / RESEARCH / HYBRID
3. [ ] Decomposed into 4-8 tasks with dependencies
4. [ ] Matched tasks to appropriate agents
5. [ ] Read template(s) for structure reference
6. [ ] Generated custom workflow JSON
7. [ ] Saved workflow to claude-flow-workflows/
8. [ ] Executed workflow with claude-flow
9. [ ] Provided summary report

## Principles

1. **KISS** - Keep It Simple, Stupid
2. **YAGNI** - Implement only what's required
