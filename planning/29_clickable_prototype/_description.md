# Clickable Prototype

## Overview

A Clickable Prototype is an interactive simulation of a product that allows users to navigate between screens and experience the user interface without functional backend code. Unlike static wireframes or mockups, prototypes enable click-through experiences that demonstrate user flows, interactions, and transitions. They range from simple linked screens to sophisticated simulations with animations and conditional logic.

## Purpose

- **Test usability**: Evaluate designs before development
- **Communicate vision**: Show stakeholders how the product will work
- **Validate flows**: Ensure user journeys make sense
- **Reduce development risk**: Catch problems before coding
- **Enable iteration**: Rapidly refine based on feedback
- **Support sales/funding**: Demonstrate concepts to investors or customers
- **Train users**: Preview new features before launch

## When to Create

- **After Wireframing**: Once structure is defined
- **Before Development**: To validate before building
- **Usability Testing**: For realistic user research
- **Stakeholder Review**: To demonstrate concepts
- **Pitch Presentations**: To show the product vision
- **Design Handoff**: To communicate interactions

## Who's Involved

| Role | Responsibility |
|------|----------------|
| UX/UI Designer | Creates the prototype |
| Product Manager | Reviews flows and requirements |
| UX Researcher | Uses for usability testing |
| Engineering | Reviews for feasibility |
| Stakeholders | Provide feedback |
| Users | Test and validate |

## Key Components

### Linked Screens
Static designs connected by clickable hotspots

### Interactive Elements
- Buttons and links
- Form inputs
- Dropdown menus
- Modals and overlays
- Navigation menus

### Transitions & Animations
- Page transitions
- Micro-interactions
- Loading states
- Animated feedback

### States
- Hover/focus states
- Active/selected states
- Error states
- Empty states
- Loading states

## Prototype Fidelity Levels

### Low-Fidelity Prototype
- Linked wireframes
- Basic click-through flow
- No visual design
- Quick to create

### Medium-Fidelity Prototype
- Styled screens
- Key interactions
- Some animations
- Good for testing core flows

### High-Fidelity Prototype
- Polished visual design
- Realistic interactions
- Complex logic and states
- Near-production feel

## Prototype Scope Considerations

### When to Prototype
- Core user flows
- Complex interactions
- New patterns
- High-risk features
- Usability test scenarios

### When NOT to Prototype
- Simple, standard patterns
- Static content pages
- Well-understood interactions
- When time doesn't permit

## Inputs & Dependencies

- Wireframes or mockups
- User flows and journey maps
- Information Architecture
- Design system components
- User stories and requirements
- Research findings
- Stakeholder feedback

## Outputs & Deliverables

- Interactive prototype (shareable link)
- Prototype documentation
- Flow documentation
- Usability test materials
- Handoff specifications
- Presentation materials

## Best Practices

1. **Prototype the Right Things**: Focus on flows that need validation.

2. **Match Test Fidelity to Goals**: Low-fi for structure, high-fi for polish testing.

3. **Keep Scope Realistic**: Prototype key flows, not the entire product.

4. **Include Real Content**: Realistic content improves test validity.

5. **Test Early and Often**: Don't wait for perfection to get feedback.

6. **Document Limitations**: Note what's simulated vs. functional.

7. **Plan for Maintenance**: Prototypes can become outdated quickly.

8. **Consider Mobile**: Test on actual devices when possible.

## Common Pitfalls

- **Over-Engineering**: Building too much functionality into prototypes
- **Prototype Debt**: Maintaining prototypes that should be replaced by code
- **Misleading Fidelity**: High-fi prototypes that mask UX problems
- **Missing States**: Not showing error, empty, or edge case states
- **Desktop Only**: Forgetting to prototype mobile experiences
- **No Documentation**: Prototypes without context or notes
- **Testing Too Late**: Waiting until high-fi to test
- **Wrong Audience**: Using technical prototypes with non-technical users

## Tools

### Design & Prototyping
- **Figma**: Industry standard, collaborative
- **Sketch + InVision**: Popular combination
- **Adobe XD**: Integrated design and prototype
- **Framer**: Advanced interactions
- **Principle**: Animation-focused

### Quick Prototyping
- **Marvel**: Simple click-through prototypes
- **Proto.io**: Mobile-focused
- **Origami (Facebook)**: Complex interactions

### Code-Based Prototyping
- **Storybook**: Component prototyping
- **CodeSandbox**: Functional prototypes
- **Webflow**: No-code web prototypes

## Related Documents

- [Wireframes](../wireframes/_description.md) - Foundation for prototypes
- [Design System / UI Kit](../design-system-ui-kit/_description.md) - Components used in prototypes
- [UX Research Plan](../ux-research-plan/_description.md) - Testing prototypes
- [User Journey Maps](../user-journey-maps/_description.md) - Flows to prototype
- [User Stories & Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Requirements to validate

## Examples & References

### Prototype Scope Planning

```
FEATURE: Checkout Flow Redesign

PROTOTYPE SCOPE:
✓ Cart review and edit
✓ Shipping address entry
✓ Payment method selection
✓ Order confirmation
✓ Error states for payment failure

OUT OF SCOPE:
✗ Account creation (existing pattern)
✗ Product browsing
✗ Order tracking (separate project)

FIDELITY: High-fidelity
- Full visual design
- Form validation feedback
- Transition animations
- Mobile responsive

TEST SCENARIOS:
1. Complete purchase as guest
2. Apply promo code
3. Encounter payment error
4. Edit cart quantity
```

### Prototype Documentation

| Screen | Interactions | Notes |
|--------|--------------|-------|
| Cart | Edit qty, remove, continue | Real-time total update |
| Shipping | Form validation, address lookup | Auto-complete integration |
| Payment | Card input, saved cards | Stripe elements style |
| Confirm | Order summary, email confirm | PDF receipt option |
| Error | Retry payment, different card | Clear error messaging |

### Usability Testing with Prototypes

**Before Testing:**
- [ ] Prototype covers all test scenarios
- [ ] All hotspots work correctly
- [ ] Realistic content throughout
- [ ] Edge cases represented
- [ ] Works on test device

**During Testing:**
- Note where prototype limitations affect behavior
- Watch for confusion from non-functional elements
- Capture feedback on interactions

**After Testing:**
- Distinguish prototype issues from design issues
- Update prototype based on findings
- Document for design iteration

### Further Reading

- "Prototyping in Figma" - Figma Learn
- "The Guide to Prototyping" - UXPin
- "Prototyping for Usability Testing" - Nielsen Norman Group
- "Interactive Prototypes" - Adobe XD Ideas
