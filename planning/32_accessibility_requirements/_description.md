# Accessibility Requirements

## Overview

An Accessibility Requirements document defines the standards, guidelines, and criteria that a product must meet to be usable by people with disabilities. It typically references WCAG (Web Content Accessibility Guidelines) as the baseline standard and outlines specific requirements for visual, auditory, motor, and cognitive accessibility. This document ensures that accessibility is built into the product from the start rather than retrofitted later.

## Purpose

- **Ensure inclusion**: Make products usable by people with disabilities
- **Meet legal requirements**: Comply with ADA, Section 508, and other laws
- **Define standards**: Establish clear accessibility criteria
- **Guide design/development**: Provide actionable requirements
- **Enable testing**: Create testable accessibility criteria
- **Reduce risk**: Avoid costly retrofitting and legal issues
- **Expand market**: Reach the 15%+ of users with disabilities

## When to Create

- **Project Inception**: At the start of new products
- **Before Design**: To inform design decisions
- **Pre-Development**: Before engineering begins
- **Audit/Remediation**: When addressing existing issues
- **Compliance Review**: When updating to new standards
- **Regular Review**: As WCAG and laws evolve

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Accessibility Specialist | Defines requirements and standards |
| UX Designer | Designs accessible interfaces |
| Developer | Implements accessible code |
| QA | Tests for accessibility compliance |
| Product Manager | Ensures requirements are prioritized |
| Legal/Compliance | Validates regulatory requirements |

## Key Components

### 1. Compliance Level Target
- WCAG 2.1 Level A (minimum)
- WCAG 2.1 Level AA (standard recommendation)
- WCAG 2.2 Level AA (current best practice)
- Any additional standards (ADA, Section 508, EN 301 549)

### 2. WCAG Principles (POUR)

**Perceivable**
Information must be presentable in ways users can perceive
- Text alternatives for non-text content
- Captions for video/audio
- Adaptable content structure
- Distinguishable (color contrast, text resize)

**Operable**
Interface must be operable by all users
- Keyboard accessible
- Enough time to interact
- No seizure-inducing content
- Navigable (skip links, focus order)
- Input modalities (touch, voice)

**Understandable**
Information and interface must be understandable
- Readable text
- Predictable behavior
- Input assistance (error prevention, suggestions)

**Robust**
Content must be robust enough for assistive technologies
- Valid, semantic HTML
- Compatible with current and future tools

### 3. Specific Requirements by Category

**Visual**
- Color contrast ratios (4.5:1 text, 3:1 UI)
- Text sizing (up to 200%)
- No color-only information
- Screen reader compatibility

**Auditory**
- Captions for video
- Transcripts for audio
- Visual alternatives for audio cues

**Motor**
- Keyboard-only navigation
- Large touch targets (44x44px minimum)
- No timing constraints
- Focus indicators

**Cognitive**
- Clear, simple language
- Consistent navigation
- Error prevention and recovery
- Reduced motion options

### 4. Testing Requirements
- Automated testing (axe, WAVE)
- Manual testing procedures
- Assistive technology testing
- User testing with disabled users

## Conformance Levels

| Level | Description | Requirement |
|-------|-------------|-------------|
| A | Minimum | 30 success criteria |
| AA | Standard | A + 20 more criteria |
| AAA | Highest | AA + 28 more criteria |

Note: Level AAA is typically aspirational, not required.

## Key WCAG 2.2 Success Criteria

### Level A (Must Have)
- 1.1.1 Non-text Content (alt text)
- 1.3.1 Info and Relationships (semantic HTML)
- 2.1.1 Keyboard
- 2.4.1 Bypass Blocks (skip links)
- 4.1.2 Name, Role, Value (ARIA)

### Level AA (Should Have)
- 1.4.3 Contrast (Minimum) - 4.5:1
- 1.4.4 Resize Text - 200%
- 2.4.6 Headings and Labels
- 2.4.7 Focus Visible
- 3.3.3 Error Suggestion

### New in WCAG 2.2
- 2.4.11 Focus Not Obscured
- 2.5.7 Dragging Movements
- 2.5.8 Target Size (Minimum)
- 3.2.6 Consistent Help
- 3.3.7 Redundant Entry

## Inputs & Dependencies

- Legal/regulatory requirements
- Target user research
- Design system constraints
- Technical platform capabilities
- Existing accessibility audit (if available)
- Industry-specific standards

## Outputs & Deliverables

- Accessibility requirements document
- WCAG compliance checklist
- Testing protocols
- Remediation priority list (if auditing existing product)
- Component accessibility specifications
- Training materials for team

## Best Practices

1. **Start Early**: Build accessibility in from the beginning.

2. **Use Semantic HTML**: Proper elements provide built-in accessibility.

3. **Test with Real Users**: Include disabled users in research.

4. **Automate Where Possible**: But know automated testing catches ~30% of issues.

5. **Train the Team**: Everyone should understand basics.

6. **Document in Design System**: Bake accessibility into components.

7. **Create a Culture**: Accessibility is everyone's responsibility.

8. **Plan for Assistive Technology**: Test with screen readers, keyboard, voice control.

## Common Pitfalls

- **Retrofitting**: Trying to fix accessibility after launch
- **Automation Only**: Relying only on automated testing
- **ARIA Overuse**: Adding ARIA when semantic HTML would work
- **Ignoring Keyboard**: Assuming mouse/touch is sufficient
- **Color-Only Information**: Using only color to convey meaning
- **Missing Focus States**: No visible focus indicator
- **Poor Error Messages**: Inaccessible form validation
- **Assuming Compliance = Usability**: Meeting criteria doesn't guarantee good UX

## Testing Tools

### Automated
- **axe DevTools**: Browser extension
- **WAVE**: Web accessibility evaluator
- **Lighthouse**: Built into Chrome DevTools
- **Pa11y**: Command-line and CI integration

### Screen Readers
- **NVDA**: Windows (free)
- **JAWS**: Windows (commercial)
- **VoiceOver**: macOS/iOS (built-in)
- **TalkBack**: Android (built-in)

### Other Tools
- **Color contrast checkers**: WebAIM, Stark
- **Keyboard testing**: Manual Tab/Enter testing
- **Screen magnification**: OS built-in features

## Related Documents

- [Design System / UI Kit](../design-system-ui-kit/_description.md) - Accessible components
- [UX Copy / Microcopy Guidelines](../ux-copy-microcopy-guidelines/_description.md) - Clear language
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Technical requirements
- [Test Plan](../test-plan/_description.md) - Accessibility testing
- [QA Checklist](../qa-checklist/_description.md) - Pre-release validation

## Examples & References

### Accessibility Checklist Example

**Perceivable**
- [ ] Images have meaningful alt text
- [ ] Videos have captions
- [ ] Color contrast meets 4.5:1 (text) and 3:1 (UI)
- [ ] Text can be resized to 200% without loss

**Operable**
- [ ] All functionality available via keyboard
- [ ] Focus order is logical
- [ ] Focus indicator is visible
- [ ] No keyboard traps
- [ ] Touch targets are 44x44px minimum

**Understandable**
- [ ] Page language is declared
- [ ] Navigation is consistent
- [ ] Error messages are clear and specific
- [ ] Labels are associated with inputs

**Robust**
- [ ] HTML validates
- [ ] ARIA is used correctly
- [ ] Works with screen readers

### Color Contrast Quick Reference

| Element | Minimum Ratio | Example |
|---------|---------------|---------|
| Body text | 4.5:1 | #595959 on white |
| Large text (18pt+) | 3:1 | #767676 on white |
| UI components | 3:1 | Button borders, icons |
| Focus indicator | 3:1 | Against background |

### Further Reading

- "WCAG 2.2 Quick Reference" - W3C
- "ADA Website Compliance in 2025" - AccessiBe
- "Web Accessibility Guidelines" - WebAIM
- "Accessibility for Everyone" - Laura Kalbag
- "Inclusive Design Patterns" - Heydon Pickering
- "A Web for Everyone" - Sarah Horton & Whitney Quesenbery
