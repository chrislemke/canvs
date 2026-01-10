# Onboarding Flow Specification

## Overview

An Onboarding Flow Specification documents the design and implementation details of a product's user onboarding experience. It defines the sequence of steps, screens, and interactions that guide new users from signup to their first moment of value. Effective onboarding is critical—a poor experience can cause up to 80% of users to abandon an app before using it, while products that get onboarding right can increase retention by up to 50%.

## Purpose

- **Define user journey**: Map the complete new user experience
- **Accelerate time-to-value**: Get users to their "aha moment" faster
- **Reduce churn**: Prevent early abandonment
- **Enable personalization**: Segment users for tailored experiences
- **Guide development**: Provide clear specs for implementation
- **Measure success**: Establish baseline for optimization
- **Align teams**: Create shared vision across product, design, and engineering

## When to Create

- **New Products**: Before launching to first users
- **Onboarding Redesign**: When improving existing experience
- **New User Segments**: When serving new customer types
- **Feature Launches**: For major new functionality
- **Conversion Optimization**: When improving signup/activation rates
- **Regular Review**: Annual or quarterly updates

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Defines goals and requirements |
| UX Designer | Designs flow and interactions |
| UX Researcher | Gathers user insights |
| Engineers | Implements the flow |
| Growth/Marketing | Optimizes conversion |
| Customer Success | Provides user feedback |

## Key Components

### 1. User Goals and Context
- Target user personas
- User jobs to be done
- Expected prior knowledge
- Device/platform context

### 2. Activation Definition
- What constitutes "activated"
- Key actions to complete
- Time-to-value targets
- Success metrics

### 3. Flow Stages
- Welcome/value proposition
- Account setup
- Personalization/segmentation
- Core feature introduction
- Guided first action
- Success confirmation

### 4. Screen Specifications
- Content and copy
- UI elements
- Interactions
- Navigation options
- Skip/exit behavior

### 5. Personalization Logic
- Segmentation questions
- Branching logic
- Content adaptation
- Feature prioritization

### 6. Progress Indicators
- Progress bars
- Checklists
- Completion percentage
- Milestone celebrations

## Onboarding Patterns

### Welcome Screens
- Value proposition reinforcement
- Expectations setting
- Quick overview of benefits

### Product Tours
- Guided walkthroughs
- Tooltip sequences
- Contextual highlighting
- Best practice: Keep to 25 words per step

### Checklists
- Task completion tracking
- Progressive disclosure
- Gamification elements
- Clear next actions

### Empty States
- Guidance when content is missing
- Clear CTAs to add first content
- Example data options

### Contextual Help
- Tooltips and hotspots
- In-context guidance
- Help center links
- Chat support access

## Design Principles

### Progressive Disclosure
- Introduce features gradually
- One task at a time
- Don't overwhelm new users
- Reveal complexity over time

### Value First
- Front-load the value proposition
- Show benefits before asking for effort
- Quick wins early in the flow

### Optional, Not Mandatory
- Allow users to skip onboarding
- Support self-exploration
- Re-access onboarding later

### Personalization
- Collect user goals and context
- Adapt flow based on user type
- Customize recommendations
- AI-powered adaptive flows (2025 trend)

## Inputs & Dependencies

- User research and personas
- Activation metrics definition
- Product requirements
- Design system
- Copy/content guidelines
- Analytics implementation plan
- A/B testing framework

## Outputs & Deliverables

- Onboarding flow document
- User flow diagrams
- Screen designs/wireframes
- Copy deck
- Personalization logic
- Success metrics
- Implementation tickets

## Best Practices

1. **Define Activation**: Know what "activated" means before designing.

2. **Keep It Short**: Users don't want full product tours; let them explore.

3. **Show, Don't Tell**: Use interactive elements over text explanations.

4. **Collect Data Wisely**: Ask for personalization info early, but keep it brief.

5. **Celebrate Progress**: Acknowledge completed steps and milestones.

6. **Allow Skip**: Never force users through mandatory onboarding.

7. **Test with Real Users**: Watch someone new try your onboarding.

8. **Iterate Continuously**: Optimize based on drop-off data.

## Common Pitfalls

- **Too Long**: Onboarding that takes too many steps
- **Feature Dump**: Showing everything at once
- **No Skip Option**: Forcing users through the flow
- **Unclear Value**: Not explaining why steps matter
- **No Personalization**: One-size-fits-all approach
- **Ignoring Mobile**: Not optimizing for mobile users
- **No Measurement**: Not tracking completion and drop-off
- **Set and Forget**: Not updating as product evolves

## Metrics to Track

| Metric | Description |
|--------|-------------|
| Completion Rate | % who finish onboarding |
| Step Drop-off | Where users abandon |
| Time to Activate | Duration to first value |
| Day 1 Retention | Users returning day after signup |
| Feature Adoption | Usage of introduced features |

## Tools

### Onboarding Platforms
- **Appcues**: No-code onboarding flows
- **Pendo**: In-app guidance
- **UserGuiding**: User onboarding software
- **Chameleon**: Product tours and tooltips
- **Intercom**: In-app messaging

### Analytics
- **Amplitude**: Product analytics
- **Mixpanel**: User behavior tracking
- **Heap**: Automatic event capture
- **FullStory**: Session replay

### Testing
- **Maze**: User testing
- **UserTesting**: Research platform
- **Hotjar**: Heatmaps and recordings

## Related Documents

- [User Journey Maps](../user-journey-maps/_description.md) - Full user journey context
- [User Stories / Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Implementation details
- [UX Copy / Microcopy Guidelines](../ux-copy-microcopy-guidelines/_description.md) - Content standards
- [Analytics / Telemetry Plan](../analytics-telemetry-plan/_description.md) - Tracking implementation
- [Metric Definitions](../metric-definitions/_description.md) - Success metrics

## Examples & References

### Onboarding Flow Specification Template

```markdown
# Onboarding Flow Specification: [Product Name]

## Overview
- **Target Users**: [Persona descriptions]
- **Activation Definition**: [What makes a user "activated"]
- **Goal**: [Primary onboarding goal]
- **Estimated Duration**: [How long flow takes]

## User Segments

| Segment | Criteria | Flow Variation |
|---------|----------|----------------|
| Solo User | Team size = 1 | Personal setup focus |
| Team Lead | Team size > 1, Admin | Invite flow, workspace setup |
| Team Member | Invited user | Simplified, guided |

## Activation Metrics
- Primary: [e.g., First project created]
- Secondary: [e.g., Team member invited]
- Target: [e.g., 60% reach activation within 7 days]

## Flow Stages

### Stage 1: Welcome (1 screen)
**Purpose**: Reinforce value proposition

**Screen 1.1: Welcome**
- Headline: "Welcome to [Product]"
- Subhead: "Let's get you set up in under 2 minutes"
- CTA: "Get Started"
- Skip: Hidden (first screen)

### Stage 2: Personalization (2-3 screens)
**Purpose**: Collect info to customize experience

**Screen 2.1: Role Selection**
- Question: "What's your primary role?"
- Options: [Product Manager, Designer, Developer, Other]
- Purpose: Customize feature highlights

**Screen 2.2: Goal Selection**
- Question: "What do you want to accomplish first?"
- Options: [Track projects, Collaborate with team, Manage tasks]
- Purpose: Determine first-run experience

### Stage 3: Setup (1-2 screens)
**Purpose**: Essential configuration

**Screen 3.1: Workspace Creation**
- Input: Workspace name
- Input: Upload logo (optional)
- CTA: "Create Workspace"

### Stage 4: First Action (1-2 screens)
**Purpose**: Guide to first value

**Screen 4.1: Create First Project**
- Guided creation flow
- Pre-filled example option
- CTA: "Create Project"

### Stage 5: Success (1 screen)
**Purpose**: Celebrate and guide next steps

**Screen 5.1: You're All Set!
- Celebration animation
- Checklist of next steps
- CTA: "Go to Dashboard"

## Personalization Logic

```
IF role = "Product Manager" THEN
  Show roadmap features first
  Highlight reporting capabilities
ELSE IF role = "Designer" THEN
  Show design collaboration features
  Highlight visual tools
ELSE
  Show general overview
END IF
```

## Copy Deck

| Screen | Element | Copy |
|--------|---------|------|
| 1.1 | Headline | Welcome to [Product] |
| 1.1 | Subhead | Let's get you set up in under 2 minutes |
| 2.1 | Question | What's your primary role? |
| 5.1 | Headline | You're all set! |

## Success Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Completion Rate | 70% | Baseline |
| Time to Complete | <3 min | Baseline |
| Day 1 Retention | 50% | Baseline |
| Activation Rate | 60% | Baseline |
```

### User Flow Diagram

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Welcome   │────▶│    Role     │────▶│    Goal     │
│   Screen    │     │  Selection  │     │  Selection  │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Success   │◀────│   First     │◀────│  Workspace  │
│   Screen    │     │   Project   │     │   Setup     │
└─────────────┘     └─────────────┘     └─────────────┘
      │
      ▼
┌─────────────┐
│  Dashboard  │
└─────────────┘
```

### Further Reading

- [UX Design Institute Onboarding Best Practices](https://www.uxdesigninstitute.com/blog/ux-onboarding-best-practices-guide/)
- [DesignerUp - 200 Onboarding Flows Study](https://designerup.co/blog/i-studied-the-ux-ui-of-over-200-onboarding-flows-heres-everything-i-learned/)
- [UserGuiding Onboarding Best Practices](https://userguiding.com/blog/user-onboarding-best-practices)
- [Appcues User Onboarding Guide](https://www.appcues.com/blog/user-onboarding-ui-ux-patterns)
