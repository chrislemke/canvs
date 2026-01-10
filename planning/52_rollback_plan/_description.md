# Rollback Plan

## Overview

A Rollback Plan is a documented procedure for reverting a system to a previous known-good state when a deployment or change causes problems. It defines the triggers that warrant a rollback, the exact steps to execute the recovery, and the verification procedures to confirm successful restoration. A well-prepared rollback plan is essential insurance for any deployment, enabling teams to quickly recover from failures and minimize impact to users.

## Purpose

- **Enable recovery**: Provide clear path to restore working state
- **Minimize downtime**: Reduce time to recover from failures
- **Reduce stress**: Give teams confidence during deployments
- **Protect users**: Limit exposure to broken functionality
- **Document procedures**: Ensure anyone can execute recovery
- **Support decisions**: Define clear rollback triggers
- **Meet SLAs**: Maintain service level commitments

## When to Create

- **Every Deployment**: Part of any deployment plan
- **Major Changes**: For significant system modifications
- **Database Migrations**: When schema changes occur
- **Infrastructure Changes**: For cloud/platform updates
- **Third-Party Integrations**: When adding external dependencies
- **Compliance Requirements**: When audit trails are needed

## Who's Involved

| Role | Responsibility |
|------|----------------|
| DevOps Engineer | Creates rollback procedures |
| Release Manager | Decides when to trigger rollback |
| On-Call Engineer | Executes rollback if needed |
| DBA | Handles database rollback |
| Development Lead | Provides application context |
| SRE | Monitors and validates recovery |

## Key Components

### 1. Rollback Triggers
- Error rate thresholds
- Performance degradation limits
- Critical functionality failures
- Security vulnerabilities discovered
- Data integrity issues

### 2. Decision Authority
- Who can authorize rollback
- Escalation path
- Time limits for decisions
- Communication requirements

### 3. Rollback Procedures
- Step-by-step instructions
- Commands to execute
- Order of operations
- Estimated time per step

### 4. Data Recovery
- Database rollback steps
- Data backup locations
- Point-in-time recovery
- Data integrity verification

### 5. Verification Steps
- Health checks
- Functional tests
- Data validation
- User experience verification

### 6. Communication Plan
- Stakeholder notifications
- Status updates
- User communications
- Post-rollback reporting

## Rollback Strategies

### Application Rollback
| Strategy | Time | Complexity | Data Impact |
|----------|------|------------|-------------|
| Container/Image rollback | Seconds | Low | None |
| Blue-Green switch | Seconds | Low | None |
| Feature flag disable | Seconds | Low | None |
| Kubernetes rollback | Minutes | Low | None |
| Full redeploy | Minutes | Medium | None |

### Database Rollback
| Strategy | Time | Complexity | Data Impact |
|----------|------|------------|-------------|
| Migration revert | Minutes | Medium | May lose data |
| Point-in-time restore | Minutes-Hours | High | Loses recent data |
| Backup restore | Hours | High | Loses recent data |
| Forward-fix | Varies | Medium | None |

## Rollback Decision Matrix

| Severity | Error Rate | Latency | Action |
|----------|------------|---------|--------|
| Critical | >5% | >2s | Immediate rollback |
| High | 1-5% | 1-2s | Rollback within 15 min |
| Medium | 0.5-1% | 500ms-1s | Investigate, rollback if no fix |
| Low | <0.5% | <500ms | Monitor, consider forward-fix |

## Inputs & Dependencies

- Deployment plan and steps
- Previous application versions
- Database backups and snapshots
- Infrastructure state backups
- Configuration backups
- Rollback scripts and automation
- Monitoring and alerting setup

## Outputs & Deliverables

- Rollback procedure document
- Tested rollback scripts
- Recovery verification checklist
- Post-rollback report
- Lessons learned documentation
- Updated runbooks

## Best Practices

1. **Test Rollbacks Regularly**: Practice in staging before needing in production.

2. **Automate When Possible**: Scripted rollbacks are faster and more reliable.

3. **Define Clear Triggers**: Unambiguous criteria for when to roll back.

4. **Time-Box Decisions**: Don't wait too long to decide.

5. **Keep Backups Fresh**: Ensure recent backups are available.

6. **Document Database Strategy**: Data rollback is often the hardest part.

7. **Use Feature Flags**: Enable instant rollback of features.

8. **Practice Blameless Culture**: Focus on recovery, not blame.

## Common Pitfalls

- **Untested Plans**: Rollback procedures never verified
- **Missing Backups**: Backups unavailable or corrupted
- **Complex Dependencies**: Rollback affects other systems
- **Data Loss**: Not accounting for data created post-deploy
- **Unclear Authority**: No one authorized to make the call
- **Slow Decisions**: Waiting too long to roll back
- **Incomplete Rollback**: Only partially reverting changes
- **No Communication**: Users and stakeholders not informed

## Modern Rollback Approaches

### Feature Flags
```
- Deploy code with flag disabled
- Enable flag for small % of users
- If issues: disable flag (instant rollback)
- No redeploy needed
```

### Blue-Green Deployment
```
- Blue (current): Serving traffic
- Green (new): Deployed and tested
- Switch traffic to green
- If issues: Switch back to blue (seconds)
```

### Canary Deployment
```
- Deploy to 5% of traffic
- Monitor metrics
- If issues: Route 100% to old version
- Gradually expand if stable
```

## Tools

### Deployment Rollback
- **Kubernetes**: `kubectl rollout undo`
- **Argo CD**: GitOps automatic rollback
- **Octopus Deploy**: Rollback management
- **AWS CodeDeploy**: Automated rollback

### Feature Flags
- **LaunchDarkly**: Feature management
- **Split.io**: Feature delivery
- **Flagsmith**: Open-source flags
- **Unleash**: Feature toggle service

### Database
- **Flyway/Liquibase**: Migration versioning
- **pg_dump/restore**: PostgreSQL backup
- **AWS RDS**: Point-in-time recovery
- **MongoDB Atlas**: Backup and restore

### Monitoring
- **Datadog**: Error and latency alerting
- **PagerDuty**: Incident management
- **Honeycomb**: Observability
- **Grafana**: Metrics dashboards

## Related Documents

- [Deployment Plan](../deployment-plan/_description.md) - Deployment procedures
- [Release Plan](../release-plan/_description.md) - Release coordination
- [Incident Response Playbook](../incident-response-playbook/_description.md) - Incident handling
- [Monitoring & Observability Plan](../monitoring-observability-plan/_description.md) - Detection
- [Runbook / Operations Manual](../runbook-operations-manual/_description.md) - Operational procedures

## Examples & References

### Rollback Plan Template

```markdown
# Rollback Plan: Application v2.5.0

## Quick Reference
- **Rollback Time Estimate**: 10-15 minutes
- **Decision Authority**: Release Manager or On-Call SRE
- **Escalation**: [Name] - [Phone]

## Rollback Triggers

### Automatic Rollback (if configured)
- Error rate >5% for 5 minutes
- P95 latency >2000ms for 5 minutes
- Health check failures >3 consecutive

### Manual Rollback Triggers
- Critical functionality broken
- Data corruption detected
- Security vulnerability identified
- Customer-impacting bugs reported

## Pre-Rollback Checklist
- [ ] Confirm issue is deployment-related
- [ ] Notify on-call team
- [ ] Document observed issues
- [ ] Confirm rollback authority granted

## Rollback Procedures

### Option A: Kubernetes Rollback (Preferred)
**Time: ~5 minutes**

1. Notify team:
   ```
   @channel Starting rollback of v2.5.0 due to [reason]
   ```

2. Roll back API deployment:
   ```bash
   kubectl rollout undo deployment/api -n production
   kubectl rollout status deployment/api -n production
   ```

3. Roll back Web deployment:
   ```bash
   kubectl rollout undo deployment/web -n production
   kubectl rollout status deployment/web -n production
   ```

4. Verify rollback:
   ```bash
   kubectl get pods -n production
   # Confirm all pods running previous version
   ```

### Option B: Database Migration Rollback
**Time: ~15-20 minutes**
**CAUTION: May result in data loss for records created after migration**

1. Put application in maintenance mode:
   ```bash
   kubectl apply -f maintenance-page.yaml
   ```

2. Identify migrations to revert:
   ```bash
   kubectl exec -it migrate-pod -- ./migrate status
   # Note: v2.5.0 applied migrations 46, 47, 48
   ```

3. Revert migrations:
   ```bash
   kubectl exec -it migrate-pod -- ./migrate down 3
   ```

4. Verify migration state:
   ```bash
   kubectl exec -it migrate-pod -- ./migrate status
   # Should show version 45
   ```

5. Roll back application (Option A steps)

6. Remove maintenance mode:
   ```bash
   kubectl delete -f maintenance-page.yaml
   ```

### Option C: Feature Flag Disable
**Time: ~1 minute**
**Use when issue is isolated to new feature**

1. Access LaunchDarkly dashboard
2. Locate flag: `sso-integration-enabled`
3. Set flag to `false` for all environments
4. Verify feature is disabled

## Post-Rollback Verification

### Health Checks
- [ ] API health: `curl https://api.example.com/health`
- [ ] Web health: `curl https://app.example.com/health`
- [ ] All pods running: `kubectl get pods -n production`

### Functional Verification
- [ ] User can log in
- [ ] Core workflows functional
- [ ] No new errors in logs

### Monitoring Verification
- [ ] Error rate returned to normal
- [ ] Latency returned to normal
- [ ] No new alerts firing

## Post-Rollback Communication

### Immediate (within 5 minutes)
```
@channel Rollback of v2.5.0 complete.
- Status: [Successful/Partial]
- Current version: v2.4.2
- User impact: [Description]
- Next steps: [Investigation/Fix timeline]
```

### Follow-up (within 1 hour)
- Update incident ticket
- Notify stakeholders via email
- Schedule post-incident review

## Data Recovery (If Needed)

### Restore from Backup
**CAUTION: This will lose data created after backup**

1. Identify backup to restore:
   ```bash
   aws s3 ls s3://backups/db/
   ```

2. Restore database:
   ```bash
   pg_restore -h prod-db -U admin -d app backup_file.dump
   ```

3. Verify data integrity

## Lessons Learned (Post-Rollback)
To be completed after incident:
- [ ] Root cause identified
- [ ] Timeline documented
- [ ] Action items created
- [ ] Runbook updated
```

### Rollback Decision Tree

```
Issue Detected
     │
     ▼
Is it deployment-related?
     │
   ┌─┴─┐
  No   Yes
   │    │
   ▼    ▼
Debug  Can it be fixed forward in <15 min?
       │
     ┌─┴─┐
    Yes  No
     │    │
     ▼    ▼
   Fix   Is data rollback needed?
   it    │
       ┌─┴─┐
      No   Yes
       │    │
       ▼    ▼
  App      Evaluate data loss
  rollback vs. forward fix
  only
```

### Further Reading

- [FeatBit Modern Rollback Strategies 2025](https://www.featbit.co/articles2025/modern-deploy-rollback-strategies-2025)
- [Octopus Modern Rollback Strategies](https://octopus.com/blog/modern-rollback-strategies)
- [Manifestly Rollback Checklist](https://www.manifest.ly/use-cases/software-development/rollback-plan-checklist)
- "Release It!" - Michael T. Nygard
