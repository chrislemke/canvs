# Runbook / Operations Manual

## Overview

A Runbook (also called an Operations Manual or Standard Operating Procedures) is a set of documented procedures for routine operational tasks and incident response. Runbooks provide step-by-step instructions that enable any qualified operator to perform complex tasks consistently and correctly. They reduce reliance on tribal knowledge, accelerate onboarding, and ensure that critical operations are performed consistently regardless of who executes them.

## Purpose

- **Ensure consistency**: Standardize how tasks are performed
- **Reduce MTTR**: Provide proven recovery paths during incidents
- **Enable delegation**: Allow any qualified person to execute procedures
- **Accelerate onboarding**: Turn shadowing into contribution faster
- **Reduce errors**: Minimize human mistakes in complex procedures
- **Support automation**: Provide basis for automated runbooks
- **Document knowledge**: Capture expertise before it's lost

## When to Create

- **New Systems**: Before launching production services
- **Repeated Tasks**: When procedures are performed regularly
- **Complex Operations**: For multi-step or risky procedures
- **Post-Incident**: When incidents reveal procedure gaps
- **Knowledge Transfer**: Before team members leave
- **Automation Prep**: Before automating manual procedures

## Who's Involved

| Role | Responsibility |
|------|----------------|
| SRE/DevOps | Authors and maintains runbooks |
| Subject Matter Experts | Provides procedure details |
| Operations Team | Executes runbooks |
| On-Call Engineers | Uses runbooks during incidents |
| Engineering Manager | Reviews and approves |
| New Team Members | Validates clarity during onboarding |

## Key Components

### 1. Overview
- Purpose of the runbook
- When to use it
- Business context and importance
- Owner and last updated date

### 2. Prerequisites
- Required access and permissions
- Tools and environment setup
- Dependencies and pre-conditions
- Approvals needed

### 3. Step-by-Step Procedures
- Numbered, action-first steps
- Copy-paste ready commands
- Expected outputs at each step
- Decision points and branching

### 4. Verification Steps
- How to confirm success
- Expected system state
- Monitoring checks
- Validation commands

### 5. Rollback Procedures
- How to revert changes
- When to initiate rollback
- Recovery steps
- State restoration

### 6. Troubleshooting
- Common issues and solutions
- Error messages and meanings
- Escalation criteria
- Support contacts

## Runbook Types

### Operational Runbooks
- Routine maintenance tasks
- Scheduled jobs
- Regular health checks
- Capacity management

### Incident Response Runbooks
- Alert-specific procedures
- Diagnostic steps
- Remediation actions
- Recovery verification

### Deployment Runbooks
- Release procedures
- Configuration changes
- Database migrations
- Rollback steps

### Security Runbooks
- Security incident response
- Access provisioning/deprovisioning
- Certificate rotation
- Vulnerability remediation

## Writing Effective Procedures

### Good Practices
```markdown
## Step 3: Restart the API service

1. Connect to the production cluster:
   ```bash
   kubectl config use-context production
   ```

2. Restart the API deployment:
   ```bash
   kubectl rollout restart deployment/api -n production
   ```

3. Verify pods are restarting:
   ```bash
   kubectl get pods -n production -l app=api
   ```
   **Expected output:** Pods should show status `Running` within 2 minutes

4. Confirm health check passes:
   ```bash
   curl -s https://api.example.com/health | jq .status
   ```
   **Expected output:** `"healthy"`
```

### What to Avoid
- Vague instructions ("restart the service")
- Missing expected outputs
- Assumed knowledge without explanation
- Commands without context
- No verification steps

## Runbook Automation

### Levels of Automation
| Level | Description | Example |
|-------|-------------|---------|
| Manual | Human follows steps | Complex troubleshooting |
| Semi-Automated | Human triggers automation | One-click restart |
| Fully Automated | System triggers on event | Auto-scaling |

### Candidates for Automation
- High-frequency tasks
- Time-sensitive operations
- Error-prone procedures
- Tasks with clear success criteria

## Inputs & Dependencies

- System architecture documentation
- Monitoring and alerting setup
- Access control information
- Change management procedures
- Incident response playbooks
- Vendor documentation

## Outputs & Deliverables

- Runbook documents
- Procedure templates
- Training materials
- Automation scripts
- Quick reference cards
- Updated based on feedback

## Best Practices

1. **Be Precise**: Use exact commands that can be copied and pasted.

2. **Include Expected Outputs**: Show what success looks like at each step.

3. **Add Context**: Explain why steps matter, not just what to do.

4. **Include Rollback**: Always document how to undo changes.

5. **Keep Updated**: Review and update after every use.

6. **Test Regularly**: Validate procedures work as documented.

7. **Use Visuals**: Include diagrams, screenshots, and flowcharts.

8. **Version Control**: Store runbooks alongside code.

## Common Pitfalls

- **Stale Documentation**: Runbooks that don't match current systems
- **Too Much Detail**: Overwhelming operators with unnecessary info
- **Too Little Detail**: Missing critical steps or context
- **No Testing**: Procedures never validated
- **Hidden Location**: Runbooks that can't be found during incidents
- **No Ownership**: Unclear who maintains each runbook
- **Copy-Paste Errors**: Commands that don't work as documented
- **Missing Prerequisites**: Assuming access or tools

## Tools

### Documentation Platforms
- **Confluence**: Wiki-based documentation
- **Notion**: Modern documentation
- **GitBook**: Developer-focused docs
- **Markdown in Git**: Version-controlled docs

### Runbook Automation
- **Rundeck**: Job scheduler and runbook automation
- **Ansible**: IT automation platform
- **StackStorm**: Event-driven automation
- **Octopus Deploy**: Deployment automation
- **PagerDuty Runbook Automation**: Automated incident response

### AI-Assisted
- **Kubiya.ai**: AI-powered runbook execution
- **Shoreline.io**: Automated remediation

## Related Documents

- [Incident Response Playbook](../incident-response-playbook/_description.md) - Incident procedures
- [Deployment Plan](../deployment-plan/_description.md) - Deployment procedures
- [Rollback Plan](../rollback-plan/_description.md) - Recovery procedures
- [Monitoring & Observability Plan](../monitoring-observability-plan/_description.md) - System monitoring
- [Internal Documentation](../internal-documentation/_description.md) - Documentation standards

## Examples & References

### Runbook Template

```markdown
# Runbook: Database Failover

## Overview
- **Purpose**: Failover primary database to standby replica
- **Owner**: Database Team (@dba-oncall)
- **Last Updated**: 2024-01-15
- **Estimated Duration**: 15-20 minutes
- **Risk Level**: High (production impact)

## When to Use
- Primary database unresponsive for >5 minutes
- Scheduled maintenance requiring database restart
- Primary showing corruption or severe performance issues

## Prerequisites
- [ ] VPN connected to production network
- [ ] Database admin credentials available
- [ ] kubectl access to production cluster
- [ ] Approved change ticket (except emergencies)
- [ ] Notify #platform-team before starting

## Procedure

### Step 1: Verify Current State (2 min)

1. Check primary database status:
   ```bash
   psql -h primary.db.internal -U admin -c "SELECT pg_is_in_recovery();"
   ```
   **Expected:** `f` (false = primary)

2. Check replica status:
   ```bash
   psql -h replica.db.internal -U admin -c "SELECT pg_is_in_recovery();"
   ```
   **Expected:** `t` (true = replica)

3. Check replication lag:
   ```bash
   psql -h replica.db.internal -U admin -c \
     "SELECT now() - pg_last_xact_replay_timestamp() AS lag;"
   ```
   **Expected:** Less than 10 seconds

### Step 2: Prepare for Failover (3 min)

1. Put application in maintenance mode:
   ```bash
   kubectl apply -f maintenance-mode.yaml
   ```

2. Stop writes to primary:
   ```bash
   psql -h primary.db.internal -U admin -c \
     "ALTER SYSTEM SET default_transaction_read_only = on;"
   psql -h primary.db.internal -U admin -c "SELECT pg_reload_conf();"
   ```

3. Wait for replica to catch up:
   ```bash
   # Repeat until lag is 0
   psql -h replica.db.internal -U admin -c \
     "SELECT now() - pg_last_xact_replay_timestamp();"
   ```

### Step 3: Promote Replica (5 min)

1. Promote replica to primary:
   ```bash
   psql -h replica.db.internal -U admin -c "SELECT pg_promote();"
   ```

2. Verify new primary accepts writes:
   ```bash
   psql -h replica.db.internal -U admin -c "SELECT pg_is_in_recovery();"
   ```
   **Expected:** `f` (false = now primary)

3. Update DNS to point to new primary:
   ```bash
   aws route53 change-resource-record-sets \
     --hosted-zone-id ZONE123 \
     --change-batch file://failover-dns.json
   ```

### Step 4: Verify and Resume (5 min)

1. Test application connectivity:
   ```bash
   curl -s https://api.example.com/health | jq .database
   ```
   **Expected:** `"connected"`

2. Remove maintenance mode:
   ```bash
   kubectl delete -f maintenance-mode.yaml
   ```

3. Verify transactions processing:
   ```bash
   # Check application logs for database errors
   kubectl logs -l app=api --since=5m | grep -i "database error"
   ```
   **Expected:** No recent database errors

## Verification Checklist
- [ ] New primary accepting writes
- [ ] Application connected to new primary
- [ ] No errors in application logs
- [ ] Monitoring shows normal metrics

## Rollback
If failover fails:
1. Revert DNS to original primary (if still healthy)
2. Remove read-only setting on original primary
3. Escalate to DBA team

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Replica won't promote | Check for replication conflicts, review PostgreSQL logs |
| DNS not updating | Verify Route53 permissions, check propagation |
| App can't connect | Check security groups, verify connection string |

## Escalation
- DBA On-Call: @dba-oncall (PagerDuty)
- Database Vendor: [Support Portal Link]
- VP Engineering: @vp-eng (for extended outages >30 min)
```

### Quick Reference Card

```markdown
## Database Failover - Quick Reference

1. Verify: `psql -h primary -c "SELECT pg_is_in_recovery();"`
2. Maintenance mode: `kubectl apply -f maintenance-mode.yaml`
3. Stop writes: `ALTER SYSTEM SET default_transaction_read_only = on;`
4. Promote replica: `SELECT pg_promote();`
5. Update DNS: `aws route53 change-resource-record-sets...`
6. Resume: `kubectl delete -f maintenance-mode.yaml`

**Escalation**: @dba-oncall | **Full Runbook**: [Link]
```

### Further Reading

- [SolarWinds Runbook Template Guide](https://www.solarwinds.com/sre-best-practices/runbook-template)
- [Atlassian DevOps Runbook Template](https://www.atlassian.com/software/confluence/templates/devops-runbook)
- [Squadcast Runbook Best Practices](https://www.squadcast.com/sre-best-practices/runbook-template)
- [Engini.io Runbook Automation Guide 2025](https://engini.io/blog/runbook-automation/)
