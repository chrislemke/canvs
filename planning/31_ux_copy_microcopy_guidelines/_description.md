# UX Copy / Microcopy Guidelines

## Overview

UX Copy and Microcopy Guidelines document the standards for writing user interface text across a product. This includes buttons, labels, error messages, onboarding text, tooltips, and all other words users encounter. Good UX copy guides users, reduces confusion, builds trust, and reflects the brand voice. These guidelines ensure consistency and quality in the written elements of the user experience.

## Purpose

- **Guide users**: Help users understand what to do and what's happening
- **Ensure consistency**: Same concepts described the same way
- **Reduce errors**: Clear instructions prevent user mistakes
- **Build trust**: Professional, clear copy increases confidence
- **Express brand**: Voice and tone reflect brand personality
- **Enable scale**: Multiple writers produce consistent copy
- **Improve accessibility**: Clear language helps all users

## When to Create

- **Product Development**: When establishing a new product
- **Design System Creation**: As part of design system documentation
- **Brand Refresh**: When updating voice and tone
- **Internationalization**: When preparing for localization
- **Quality Issues**: When inconsistent copy causes problems
- **Team Growth**: When multiple people write UI copy

## Who's Involved

| Role | Responsibility |
|------|----------------|
| UX Writer / Content Designer | Creates and owns guidelines |
| Product Designer | Applies guidelines to designs |
| Product Manager | Reviews for accuracy and clarity |
| Brand Team | Ensures voice alignment |
| Localization | Uses guidelines for translation |
| Engineering | Implements copy correctly |

## Key Components

### 1. Voice & Tone
- Brand voice characteristics
- Tone variations by context (error vs. success)
- Personality attributes
- Examples of on-brand vs. off-brand

### 2. Writing Principles
- Clarity over cleverness
- User-focused language
- Action-oriented copy
- Conciseness guidelines

### 3. Content Types & Patterns
- Button text
- Form labels and helper text
- Error messages
- Success messages
- Onboarding/empty states
- Tooltips and hints
- Confirmations and dialogs
- Navigation labels

### 4. Grammar & Mechanics
- Capitalization (sentence case vs. title case)
- Punctuation rules
- Contractions (use or avoid)
- Numbers and dates
- Abbreviations

### 5. Inclusive Language
- Gender-neutral language
- Avoiding ableist terms
- Cultural sensitivity
- Plain language for accessibility

### 6. Terminology
- Glossary of product terms
- Preferred words and phrases
- Words to avoid

## Microcopy Categories

### Action Copy
Buttons, links, and CTAs
- "Save" vs "Save changes" vs "Save your progress"
- Use verbs that describe the action

### Instructional Copy
Helper text, tooltips, placeholders
- Explain before user needs help
- Be brief but complete

### Feedback Copy
Success, error, loading states
- Be specific about what happened
- Tell users what to do next

### Empty States
First-run experience, no data
- Explain what will appear
- Suggest an action

### Confirmation Copy
Dialogs asking for confirmation
- Be clear about consequences
- Use specific action labels (not "OK")

## Inputs & Dependencies

- Brand guidelines and voice
- Product strategy and positioning
- User research insights
- Design system components
- Accessibility requirements
- Localization requirements
- Content audit of current copy

## Outputs & Deliverables

- UX writing style guide
- Voice and tone documentation
- Terminology glossary
- Pattern library for copy types
- Error message templates
- Review checklist
- Examples and anti-patterns

## Best Practices

1. **Be Clear, Not Clever**: Users want to complete tasks, not admire wordplay.

2. **Use the User's Language**: Match how users describe things.

3. **Front-Load Information**: Put the most important words first.

4. **Write for Scanning**: Users skim—make copy scannable.

5. **Be Specific in Errors**: "Email required" beats "Error."

6. **Guide, Don't Blame**: "Passwords don't match" not "You entered wrong password."

7. **Test with Users**: Usability test your copy like your designs.

8. **Consider Edge Cases**: What happens when names are very long?

9. **Plan for Translation**: Avoid idioms, allow for text expansion.

## Common Pitfalls

- **Jargon**: Using technical or internal terms users don't know
- **Wordiness**: Too much text that users won't read
- **Inconsistency**: Same action labeled differently in different places
- **Blame Language**: Making users feel bad about errors
- **Missing Context**: Error messages without explanation
- **Over-Personality**: Prioritizing brand voice over clarity
- **Ignoring Edge Cases**: Copy that breaks with unusual data
- **No Guidelines**: Each person writes copy differently

## Tools

- **Writing Tools**: Hemingway Editor, Grammarly
- **Terminology**: Termbases, Airtable glossaries
- **Documentation**: Notion, Confluence, Zeroheight
- **Collaboration**: Figma (for copy in designs), Writer

## Related Documents

- [Design System / UI Kit](../design-system-ui-kit/_description.md) - Where copy lives
- [Brand / Naming Brief](../brand-naming-brief/_description.md) - Voice foundation
- [Accessibility Requirements](../accessibility-requirements/_description.md) - A11y considerations
- [User Documentation](../user-documentation/_description.md) - Extended content
- [Onboarding Flow Spec](../onboarding-flow-spec/_description.md) - First-run copy

## Examples & References

### Error Message Pattern

**Pattern:**
> [What happened] + [Why / What it means] + [What to do]

**Examples:**

❌ Bad: "Error 403"
✓ Good: "You don't have permission to view this page. Contact your admin to request access."

❌ Bad: "Invalid input"
✓ Good: "Email must include @ symbol"

❌ Bad: "Something went wrong"
✓ Good: "We couldn't save your changes. Check your connection and try again."

### Button Copy Guidelines

| Context | Bad | Good |
|---------|-----|------|
| Submit form | "Submit" | "Create account" |
| Confirmation | "Yes" / "No" | "Delete project" / "Keep project" |
| Navigation | "Click here" | "View pricing" |
| Process | "OK" | "Continue to checkout" |

### Voice & Tone Example

**Voice (constant):** Friendly, knowledgeable, respectful

**Tone (varies by context):**

| Context | Tone | Example |
|---------|------|---------|
| Onboarding | Encouraging | "You're all set! Let's explore..." |
| Error | Calm, helpful | "Something went wrong. Let's fix it." |
| Success | Celebratory | "Nice work! Your report is ready." |
| Confirmation | Clear, direct | "This will permanently delete your data." |

### Terminology Glossary Example

| Term | Definition | Usage |
|------|------------|-------|
| Workspace | A container for projects | "Create a new workspace" |
| Dashboard | Overview page with metrics | "Return to dashboard" |
| Team member | Person with workspace access | Not "user" or "collaborator" |

### Further Reading

- "Writing for Interfaces" - Google Material Design
- "Content Design" - Sarah Richards
- "Strategic Writing for UX" - Torrey Podmajersky
- "Microcopy: The Complete Guide" - Kinneret Yifrah
- "Polaris: Content" - Shopify Design System
