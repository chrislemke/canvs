---
description: Use Claude Flow multi-agent orchestration
allowed-tools: Task, Read, Write, Edit, Bash(*), Glob, Grep, WebSearch, WebFetch, mcp__claude-flow__*, mcp__ruv-swarm__*, mcp__flow-nexus__*
argument-hint: Your task or objective
---

Objective:
```
Don't forget to use Claude Flow for this task.
$ARGUMENTS
You have all the resources you got. Use as many Claude flow agents, etc., and swarms as you want.
```

Available swarm execution strategy: research, development, analysis, testing, optimization, maintenance

Available swarm modes: centralized, distributed, hierarchical, mesh, hybrid

The use of Claude Flow multi-agent orchestration is mandatory. The objective for Claude Flow is defined above. You have all the necessary resources. Create Claude Flow swarms at your own discretion.

## Mandatory Claude Flow MCP orchestration protocol

### 0) Ensure MCP connectivity (must do first)
1. Verify Claude Flow MCP tools are available (any `mcp__claude-flow__*` call should succeed). Claude Flow’s MCP tools are exposed under `mcp__claude-flow__`. :contentReference[oaicite:0]{index=0}
2. If tools are not available, connect/register MCP servers using Claude Code’s MCP management (via CLI or `/mcp`). Claude Code supports MCP servers and discovers their prompts/tools when connected. :contentReference[oaicite:1]{index=1}
   - Core server command (claude-flow): `npx claude-flow@alpha mcp start` :contentReference[oaicite:2]{index=2}
   - Enhanced (optional): `npx ruv-swarm mcp start` :contentReference[oaicite:3]{index=3}
   - Advanced (optional): `npx flow-nexus@latest mcp start` :contentReference[oaicite:4]{index=4}
3. If flow-nexus is not connected or requires auth, proceed with claude-flow (and ruv-swarm if available).

### 1) Orchestrate (Claude Flow) vs execute (Claude Code)
- Use MCP tools to coordinate strategy/topology, decomposition, and monitoring.
- Use Claude Code tools (Task/Read/Write/Edit/Bash/…​) to perform the actual work (file edits, commands, tests). MCP coordinates; Task executes. :contentReference[oaicite:5]{index=5}

### 2) Create the swarm and roles (mandatory)
1. Initialize a swarm using `mcp__claude-flow__swarm_init` (choose topology yourself: hierarchical/mesh/ring/star). :contentReference[oaicite:6]{index=6}
2. Spawn the minimum set of agents needed using `mcp__claude-flow__agent_spawn` (types include coordinator, architect, researcher, coder, tester, reviewer, documenter, etc.). :contentReference[oaicite:7]{index=7}
3. If ruv-swarm / flow-nexus tools are available, you may delegate specialized monitoring/benchmarking/sandboxing to them; otherwise continue with core claude-flow.

### 3) Convert the Objective into an executable plan (mandatory)
- Use `mcp__claude-flow__task_orchestrate` to break the objective into:
  - milestones
  - parallelizable workstreams
  - dependencies
  - definition of done (tests/checks)
  :contentReference[oaicite:8]{index=8}

### 4) Run the work
- For each work item:
  - Use the right agent(s) to propose changes.
  - Apply changes using Claude Code tools (Read/Write/Edit/Bash).
  - Run relevant checks/tests.
- Use `mcp__claude-flow__swarm_status` periodically (or when blocked) to track progress/health. :contentReference[oaicite:9]{index=9}

### 5) Reporting contract (mandatory)
At the end, provide:
- What you built/changed (high-level)
- Files touched (paths)
- Commands run (tests/build/lint)
- How to verify (exact steps)
- Any follow-ups / risks

Proceed now. Use Claude Flow MCP tools first, and use Claude Code tools to execute changes. :contentReference[oaicite:10]{index=10}.
Be aware of KISS & YAGNI.
