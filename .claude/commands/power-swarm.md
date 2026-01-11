---
description: Claude Flow multi-agent orchestration with full MCP toolkit (87+ tools)
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash(*), Glob, Grep, WebSearch, WebFetch, TodoRead, TodoWrite, mcp__claude-flow__*, mcp__ruv-swarm__*, mcp__flow-nexus__*
argument-hint: <objective>
---

# Claude Flow Orchestration

## Objective

Don't forget to use Claude Flow for this task.
$ARGUMENTS
You have all the resources you got. Use as many Claude flow agents,
etc., and swarms as you want.

---

## Core Principle

```
MCP Tools = Brain (planning, coordination, monitoring)
Claude Code = Hands (file operations, commands, tests)
```

**Rule**: MCP coordinates strategy. Claude Code Task tool executes ALL actual work.

---

## Quick Start: Research Task

```javascript
mcp__claude-flow__swarm_init({ topology: "mesh", maxAgents: 5 })
mcp__claude-flow__agent_spawn({ type: "coordinator" })
mcp__claude-flow__agent_spawn({ type: "researcher" })
mcp__claude-flow__agent_spawn({ type: "researcher" })
mcp__claude-flow__agent_spawn({ type: "analyst" })
mcp__claude-flow__agent_spawn({ type: "documenter" })
mcp__claude-flow__task_orchestrate({ task: "...", strategy: "adaptive", priority: "high" })
```

---

## Quick Start: Development Task

```javascript
mcp__claude-flow__swarm_init({ topology: "hierarchical", maxAgents: 8 })
mcp__claude-flow__agent_spawn({ type: "coordinator" })
mcp__claude-flow__agent_spawn({ type: "architect" })
mcp__claude-flow__agent_spawn({ type: "coder", name: "backend-dev" })
mcp__claude-flow__agent_spawn({ type: "coder", name: "frontend-dev" })
mcp__claude-flow__agent_spawn({ type: "tester" })
mcp__claude-flow__agent_spawn({ type: "reviewer" })
mcp__claude-flow__sparc_mode({ mode: "dev", task_description: "..." })
```

---

## Quick Start: Testing Task

```javascript
mcp__claude-flow__swarm_init({ topology: "mesh", maxAgents: 6 })
mcp__claude-flow__agent_spawn({ type: "coordinator" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "unit-tester" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "integration" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "e2e-tester" })
mcp__claude-flow__agent_spawn({ type: "analyst" })
mcp__claude-flow__sparc_mode({ mode: "test", task_description: "..." })
```

---

## Essential Tools

### Swarm & Agents
| Tool | Purpose |
|------|---------|
| `swarm_init` | Initialize topology: mesh, hierarchical, ring, star |
| `agent_spawn` | Create agent: coordinator, researcher, coder, analyst, tester, reviewer, architect, optimizer, documenter |
| `task_orchestrate` | Decompose task with strategy: parallel, sequential, adaptive |
| `agent_list` | List active agents |

### Memory
| Tool | Purpose |
|------|---------|
| `memory_usage` | Store/retrieve with action: store, retrieve, list, search |
| `memory_search` | Find memories by pattern |

### Performance
| Tool | Purpose |
|------|---------|
| `performance_report` | Generate metrics (summary, detailed, json) |
| `bottleneck_analyze` | Identify performance issues |

### Workflow
| Tool | Purpose |
|------|---------|
| `workflow_create` | Define multi-step workflows with dependencies |
| `parallel_execute` | Run independent tasks concurrently |
| `sparc_mode` | Run dev, api, ui, test, or refactor mode |

---

## Batch Execution (6x Performance)

**CRITICAL**: Combine ALL operations in ONE message.

```javascript
// CORRECT: Single message with all operations
[Message 1]:
  mcp__claude-flow__swarm_init({ topology: "mesh" })
  mcp__claude-flow__agent_spawn({ type: "researcher" })
  mcp__claude-flow__agent_spawn({ type: "coder" })
  Task("Research requirements", "researcher")
  Task("Implement solution", "coder")
  TodoWrite({ todos: [...all-todos...] })

// WRONG: Split across messages (6x slower!)
Message 1: swarm_init
Message 2: agent_spawn
Message 3: Task
```

---

## SPARC Modes

| Mode | Purpose |
|------|---------|
| `dev` | General development |
| `api` | API-focused development |
| `ui` | UI/frontend development |
| `test` | Testing and validation |
| `refactor` | Code optimization |

---

## Topology Guide

| Topology | Best For |
|----------|----------|
| `mesh` | Collaborative, peer-to-peer tasks |
| `hierarchical` | Enterprise, delegated workflows |
| `ring` | Sequential pipeline processing |
| `star` | Centralized hub-and-spoke control |

---

## Mandatory Report

At task completion, provide:

```markdown
## Execution Summary

### What Was Built/Changed
- [High-level description]

### Files Touched
- [List of file paths]

### Commands Run
- [Tests, builds, lints executed]

### How to Verify
1. [Exact verification steps]
2. [Expected outcomes]

### Swarm Metrics
- Topology: [used]
- Agents: [count and types]
- Tasks completed: [count]
```

---

## Principles

1. **KISS** - Keep It Simple, Stupid
2. **YAGNI** - Implement only what's required
3. **Batch Operations** - Single message for related calls
4. **MCP Coordinates, Claude Code Executes** - Never confuse roles

---

**Proceed now with Claude Flow orchestration.**
