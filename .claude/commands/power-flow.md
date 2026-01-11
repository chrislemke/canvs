---
description: Claude Flow multi-agent orchestration with full MCP toolkit (87+ tools)
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash(*), Glob, Grep, WebSearch, WebFetch, TodoRead, TodoWrite, mcp__claude-flow__*, mcp__ruv-swarm__*, mcp__flow-nexus__*
argument-hint: <objective> [--strategy <strategy>] [--topology <topology>] [--agents <count>]
---

# Claude Flow Multi-Agent Orchestration

## Objective
$ARGUMENTS

---

## 🔒 CRITICAL: MCP Coordinates, Claude Code Executes

**ABSOLUTE RULE**: MCP tools coordinate strategy and orchestration. Claude Code tools (Task/Read/Write/Edit/Bash) perform ALL actual work.

```
MCP Tools = Brain (planning, coordination, monitoring)
Claude Code = Hands (file operations, commands, tests)
```

---

## Phase 0: MCP Connectivity Check (MANDATORY FIRST STEP)

Before ANY orchestration, verify MCP server connectivity:

```javascript
// 1. Test connectivity with a simple call
mcp__claude-flow__swarm_status({})

// 2. If tools unavailable, guide user to connect:
// Core server (required):
//   claude mcp add claude-flow npx claude-flow@alpha mcp start
// Enhanced (optional):
//   claude mcp add ruv-swarm npx ruv-swarm mcp start
// Cloud features (optional):
//   claude mcp add flow-nexus npx flow-nexus@latest mcp start
```

If MCP tools fail, inform user and suggest running: `npx claude-flow@alpha init --force`

---

## Phase 1: Swarm Initialization

### 1.1 Initialize Swarm Topology

```javascript
mcp__claude-flow__swarm_init({
  topology: "mesh" | "hierarchical" | "ring" | "star",  // Required
  strategy: "auto" | "research" | "development" | "analysis" | "testing" | "optimization" | "maintenance",
  maxAgents: 8  // Adjust based on task complexity (3-5 simple, 8-12 complex, 15-20 enterprise)
})
```

**Topology Selection Guide:**
| Topology | Best For | Characteristics |
|----------|----------|-----------------|
| `mesh` | Collaborative tasks, research | Peer-to-peer, high communication |
| `hierarchical` | Enterprise, complex projects | Queen-led, delegated work |
| `ring` | Pipeline workflows | Sequential, ordered processing |
| `star` | Centralized coordination | Hub-and-spoke, coordinator-centric |

### 1.2 Spawn Specialized Agents

```javascript
// Core agent types (spawn based on task needs)
mcp__claude-flow__agent_spawn({
  type: "coordinator" | "researcher" | "coder" | "analyst" | "architect" |
        "tester" | "reviewer" | "optimizer" | "documenter" | "monitor" | "specialist",
  name: "descriptive-agent-name",
  swarmId: "from-swarm-init",
  capabilities: ["specific", "skills", "array"]
})
```

**Recommended Agent Compositions:**

| Task Type | Agents to Spawn |
|-----------|-----------------|
| Research | coordinator, researcher (x2), analyst, documenter |
| Development | coordinator, architect, coder (x2-3), tester, reviewer |
| Analysis | coordinator, analyst (x2), researcher, documenter |
| Testing | coordinator, tester (x3), reviewer, documenter |
| Optimization | coordinator, optimizer, analyst, coder, tester |
| Full-Stack | coordinator, architect, coder (x3), tester (x2), reviewer, documenter |

---

## Phase 2: Task Orchestration & Planning

### 2.1 Decompose Objective into Executable Plan

```javascript
mcp__claude-flow__task_orchestrate({
  task: "Detailed task description from objective",
  strategy: "parallel" | "sequential" | "adaptive" | "balanced",
  priority: "low" | "medium" | "high" | "critical",
  dependencies: ["task-id-1", "task-id-2"]  // For complex workflows
})
```

### 2.2 Create Workflow (for complex multi-step tasks)

```javascript
mcp__claude-flow__workflow_create({
  name: "workflow-name",
  steps: [
    { id: "step-1", action: "research", agent: "researcher" },
    { id: "step-2", action: "design", agent: "architect", depends: ["step-1"] },
    { id: "step-3", action: "implement", agent: "coder", depends: ["step-2"] },
    { id: "step-4", action: "test", agent: "tester", depends: ["step-3"] }
  ],
  triggers: ["on-complete", "on-error"]
})
```

---

## Phase 3: Memory & Context Management

### 3.1 Store Project Context

```javascript
mcp__claude-flow__memory_usage({
  action: "store",
  key: "project-context",
  value: JSON.stringify({
    objective: "...",
    requirements: [...],
    decisions: [...],
    stack: [...]
  }),
  namespace: "current-project",
  ttl: 86400  // 24 hours
})
```

### 3.2 Search Existing Knowledge

```javascript
mcp__claude-flow__memory_search({
  pattern: "relevant-keyword*",
  namespace: "project-namespace"
})
```

### 3.3 Memory Operations Reference

| Action | Use Case |
|--------|----------|
| `store` | Save decisions, context, requirements |
| `retrieve` | Get specific stored data |
| `list` | View all keys in namespace |
| `delete` | Clean up completed work |
| `search` | Find related memories by pattern |

---

## Phase 4: Execution with Hooks

### 4.1 Pre-Task Hook (Start of Work)

```bash
npx claude-flow@alpha hooks pre-task --description "[task-description]"
npx claude-flow@alpha hooks session-restore --session-id "swarm-[id]"  # If resuming
```

### 4.2 During Work (After Each Significant Operation)

```bash
npx claude-flow@alpha hooks post-edit --file "[filepath]" --memory-key "agent/[step]"
npx claude-flow@alpha hooks notify --message "[decision-or-progress]"
```

### 4.3 Post-Task Hook (End of Work)

```bash
npx claude-flow@alpha hooks post-task --task-id "[task]" --analyze-performance true
npx claude-flow@alpha hooks session-end --export-metrics true
```

---

## Phase 5: Work Execution (Claude Code Tools)

**CRITICAL: Batch operations in SINGLE messages for 6x performance**

```javascript
// ✅ CORRECT: Single message with all operations
[BatchTool - Message 1]:
  mcp__claude-flow__swarm_init({ topology: "mesh", maxAgents: 6 })
  mcp__claude-flow__agent_spawn({ type: "researcher" })
  mcp__claude-flow__agent_spawn({ type: "coder" })
  mcp__claude-flow__agent_spawn({ type: "tester" })
  Task("Researcher: Analyze requirements. Use hooks.")
  Task("Coder: Implement solution. Use hooks.")
  Task("Tester: Write and run tests. Use hooks.")
  TodoWrite({ todos: [...all-todos-at-once...] })

// ❌ WRONG: Split across messages (6x slower!)
Message 1: mcp__claude-flow__swarm_init
Message 2: Task("researcher")
Message 3: TodoWrite (single todo)
```

---

## Phase 6: Dynamic Agent Architecture (DAA)

### 6.1 Create Dynamic Agents

```javascript
mcp__claude-flow__daa_agent_create({
  agent_type: "specialized-type",
  capabilities: ["cap1", "cap2"],
  resources: { memory: "512MB", priority: "high" }
})
```

### 6.2 Capability Matching

```javascript
mcp__claude-flow__daa_capability_match({
  task_requirements: ["python", "ml", "optimization"],
  available_agents: ["agent-1", "agent-2"]
})
```

### 6.3 Inter-Agent Communication

```javascript
mcp__claude-flow__daa_communication({
  from: "agent-source",
  to: "agent-target",
  message: {
    type: "task_handoff" | "status_update" | "data_share",
    payload: {...}
  }
})
```

### 6.4 Consensus Mechanisms

```javascript
mcp__claude-flow__daa_consensus({
  agents: ["agent-1", "agent-2", "agent-3"],
  proposal: {
    action: "merge-branches",
    rationale: "All tests passing"
  }
})
```

---

## Phase 7: Neural & Learning Tools

### 7.1 Train Coordination Patterns

```javascript
mcp__claude-flow__neural_train({
  pattern_type: "coordination" | "optimization" | "prediction",
  training_data: JSON.stringify({
    scenarios: [
      { agents: 3, tasks: 10, completion_time: 45 },
      { agents: 5, tasks: 20, completion_time: 60 }
    ]
  }),
  epochs: 100
})
```

### 7.2 Make Predictions

```javascript
mcp__claude-flow__neural_predict({
  modelId: "coordination-model",
  input: JSON.stringify({
    task_complexity: 0.8,
    available_agents: 5,
    time_constraint: 0.6
  })
})
```

### 7.3 Pattern Recognition

```javascript
mcp__claude-flow__pattern_recognize({
  data: [
    { timestamp: Date.now(), value: 0.8, category: "performance" },
    { timestamp: Date.now() - 1000, value: 0.7, category: "performance" }
  ],
  patterns: ["anomaly", "trend", "cycle"]
})
```

### 7.4 Adaptive Learning

```javascript
mcp__claude-flow__learning_adapt({
  experience: {
    task_type: "code_review",
    duration: 1500,
    success: true,
    patterns_detected: ["optimization_opportunity"]
  }
})
```

---

## Phase 8: Performance Monitoring & Analysis

### 8.1 Check Swarm Status

```javascript
mcp__claude-flow__swarm_status({})  // Get current swarm state
mcp__claude-flow__agent_list({})    // List all active agents
mcp__claude-flow__agent_metrics({}) // Get agent performance data
```

### 8.2 Performance Reports

```javascript
mcp__claude-flow__performance_report({
  format: "summary" | "detailed" | "json",
  timeframe: "1h" | "24h" | "7d"
})
```

### 8.3 Bottleneck Analysis

```javascript
mcp__claude-flow__bottleneck_analyze({
  component: "task-orchestration" | "memory" | "agents" | "swarm",
  metrics: ["latency", "throughput", "cpu-usage", "memory-usage"]
})
```

### 8.4 Trend Analysis

```javascript
mcp__claude-flow__trend_analysis({
  metric: "response-time" | "completion-rate" | "error-rate",
  period: "7d" | "30d"
})
```

### 8.5 Run Benchmarks

```javascript
mcp__claude-flow__benchmark_run({
  suite: "swarm-coordination" | "neural-performance" | "memory-efficiency"
})
```

---

## Phase 9: SPARC Development Modes

For structured development workflows, use SPARC modes:

```javascript
mcp__claude-flow__sparc_mode({
  mode: "dev" | "api" | "ui" | "test" | "refactor" | "specification" | "pseudocode" | "architecture",
  task_description: "Detailed task description",
  options: {
    parallel: true,
    memory_enhanced: true
  }
})
```

**SPARC Mode Reference:**
| Mode | Purpose |
|------|---------|
| `specification` | Define requirements, acceptance criteria |
| `pseudocode` | Design algorithms, logic flow |
| `architecture` | System design, component structure |
| `dev` | General development |
| `api` | API-focused development |
| `ui` | UI/frontend development |
| `test` | Testing and validation |
| `refactor` | Code optimization |

---

## Phase 10: Workflow Automation

### 10.1 Parallel Execution

```javascript
mcp__claude-flow__parallel_execute({
  tasks: [
    { id: "task-1", action: "research" },
    { id: "task-2", action: "analyze" },
    { id: "task-3", action: "prototype" }
  ],
  maxConcurrent: 3
})
```

### 10.2 Batch Processing

```javascript
mcp__claude-flow__batch_process({
  items: ["item1", "item2", "item3"],
  operation: "transform" | "validate" | "analyze",
  concurrent: true
})
```

### 10.3 Workflow Templates

```javascript
mcp__claude-flow__workflow_template({
  action: "get" | "list" | "apply",
  template: "ci-cd" | "code-review" | "deployment"
})
```

---

## Complete MCP Tools Reference (87+ Tools)

### Swarm Tools (~27)
| Tool | Purpose |
|------|---------|
| `swarm_init` | Initialize swarm with topology |
| `swarm_status` | Get swarm health and metrics |
| `swarm_monitor` | Real-time monitoring |
| `agent_spawn` | Create specialized agents |
| `agent_list` | List active agents |
| `agent_metrics` | Agent performance data |
| `task_orchestrate` | Complex task workflows |
| `task_results` | Get task outcomes |

### Memory Tools (~12)
| Tool | Purpose |
|------|---------|
| `memory_usage` | Store/retrieve/list/delete/search |
| `memory_search` | Pattern-based search |
| `memory_analytics` | Usage statistics |
| `memory_export` | Export memories |
| `memory_import` | Import memories |

### Neural Tools (~15)
| Tool | Purpose |
|------|---------|
| `neural_train` | Train coordination patterns |
| `neural_predict` | Make predictions |
| `neural_patterns` | Analyze patterns |
| `neural_save` | Save trained models |
| `neural_optimize` | WASM SIMD optimization |
| `neural_inference` | Run inference |
| `pattern_recognize` | Pattern recognition |
| `cognitive_behavior` | Behavior analysis |
| `learning_adapt` | Adaptive learning |
| `neural_compress` | Model compression |
| `neural_ensemble` | Create ensembles |
| `neural_transfer` | Transfer learning |
| `neural_explain` | AI explainability |

### DAA Tools (~8)
| Tool | Purpose |
|------|---------|
| `daa_agent_create` | Dynamic agent creation |
| `daa_capability_match` | Match capabilities to tasks |
| `daa_resource_alloc` | Resource allocation |
| `daa_lifecycle_manage` | Agent lifecycle |
| `daa_communication` | Inter-agent messaging |
| `daa_consensus` | Consensus mechanisms |

### Workflow Tools (~9)
| Tool | Purpose |
|------|---------|
| `workflow_create` | Create custom workflows |
| `workflow_execute` | Execute workflows |
| `workflow_export` | Export definitions |
| `workflow_template` | Manage templates |
| `parallel_execute` | Concurrent tasks |
| `batch_process` | Batch operations |
| `pipeline_create` | CI/CD pipelines |
| `scheduler_manage` | Task scheduling |
| `event_trigger` | Event triggers |

### Performance Tools (~10)
| Tool | Purpose |
|------|---------|
| `performance_report` | System metrics |
| `bottleneck_analyze` | Find bottlenecks |
| `benchmark_run` | Run benchmarks |
| `trend_analysis` | Analyze trends |

### System Tools (~6)
| Tool | Purpose |
|------|---------|
| `sparc_mode` | SPARC development |
| `terminal_exec` | Execute commands |
| `config_manage` | Configuration |
| `feature_detect` | Feature detection |

---

## Mandatory Final Report

At task completion, provide:

### Summary
```
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
- Topology: [used topology]
- Agents: [count and types]
- Duration: [execution time]
- Tasks completed: [count]

### Follow-ups / Risks
- [Any pending items or identified risks]
```

---

## Quick Start Templates

### Research Task
```javascript
mcp__claude-flow__swarm_init({ topology: "mesh", strategy: "research", maxAgents: 5 })
mcp__claude-flow__agent_spawn({ type: "coordinator", name: "research-lead" })
mcp__claude-flow__agent_spawn({ type: "researcher", name: "primary-researcher" })
mcp__claude-flow__agent_spawn({ type: "researcher", name: "secondary-researcher" })
mcp__claude-flow__agent_spawn({ type: "analyst", name: "data-analyst" })
mcp__claude-flow__agent_spawn({ type: "documenter", name: "report-writer" })
mcp__claude-flow__task_orchestrate({ task: "...", strategy: "adaptive", priority: "high" })
```

### Development Task
```javascript
mcp__claude-flow__swarm_init({ topology: "hierarchical", strategy: "development", maxAgents: 8 })
mcp__claude-flow__agent_spawn({ type: "coordinator", name: "dev-lead" })
mcp__claude-flow__agent_spawn({ type: "architect", name: "system-architect" })
mcp__claude-flow__agent_spawn({ type: "coder", name: "backend-dev" })
mcp__claude-flow__agent_spawn({ type: "coder", name: "frontend-dev" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "qa-engineer" })
mcp__claude-flow__agent_spawn({ type: "reviewer", name: "code-reviewer" })
mcp__claude-flow__sparc_mode({ mode: "dev", task_description: "..." })
```

### Testing Task
```javascript
mcp__claude-flow__swarm_init({ topology: "mesh", strategy: "testing", maxAgents: 6 })
mcp__claude-flow__agent_spawn({ type: "coordinator", name: "test-lead" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "unit-tester" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "integration-tester" })
mcp__claude-flow__agent_spawn({ type: "tester", name: "e2e-tester" })
mcp__claude-flow__agent_spawn({ type: "analyst", name: "coverage-analyst" })
mcp__claude-flow__sparc_mode({ mode: "test", task_description: "..." })
```

---

## Principles

1. **KISS**: Keep It Simple, Stupid - don't over-engineer
2. **YAGNI**: You Aren't Gonna Need It - implement only what's required
3. **Batch Operations**: Combine related tool calls in single messages
4. **MCP Coordinates, Claude Code Executes**: Never confuse roles
5. **Use Hooks**: Maintain context across operations
6. **Monitor Progress**: Check `swarm_status` when blocked
7. **Store Decisions**: Use memory for important context
8. **Verify First**: Always check MCP connectivity before orchestration

---

**Proceed now with Claude Flow orchestration.**
