# Wireframes

## Overview

Wireframes are low-fidelity visual representations of a user interface that outline the structure, layout, and functionality of a page or screen without detailed visual design. They focus on information hierarchy, content placement, and user flow rather than colors, typography, or imagery. Wireframes serve as a blueprint for design and development, enabling rapid iteration and stakeholder alignment before investing in high-fidelity design.

## Purpose

- **Define structure**: Establish page layout and content hierarchy
- **Enable rapid iteration**: Test ideas quickly without design investment
- **Facilitate discussion**: Create shared understanding among stakeholders
- **Validate concepts**: Test usability before visual design
- **Guide development**: Provide structural reference for implementation
- **Reduce waste**: Catch problems early before costly revisions
- **Document requirements**: Visual specification of interface needs

## When to Create

- **After IA, Before Visual Design**: Once structure is defined
- **Concept Exploration**: When exploring multiple approaches
- **Stakeholder Alignment**: To get early buy-in on direction
- **Usability Testing**: For early prototype testing
- **Feature Definition**: When specifying new features
- **Handoff Preparation**: Before detailed design begins

## Who's Involved

| Role | Responsibility |
|------|----------------|
| UX Designer | Creates wireframes |
| Product Manager | Reviews for requirements alignment |
| Engineering | Reviews for feasibility |
| Stakeholders | Provide feedback on direction |
| Users | Validate through testing |

## Key Components

### Structural Elements
- Page/screen layout
- Content blocks and hierarchy
- Navigation elements
- Input fields and forms
- Buttons and actions
- Headers and footers

### Annotations
- Behavior notes
- Interaction descriptions
- Content requirements
- Conditional logic
- Edge cases

### Not Included (in Low-Fi)
- Colors and branding
- Actual images
- Final typography
- Pixel-perfect spacing
- Visual polish

## Wireframe Fidelity Levels

### Low-Fidelity (Sketches)
- Hand-drawn or very basic digital
- Boxes and placeholder content
- Quick to create, easy to discard
- Best for early exploration

### Medium-Fidelity
- Cleaner digital wireframes
- Rough sizing and spacing
- Placeholder text and images
- Good for stakeholder review

### High-Fidelity (Detailed)
- Precise layout and sizing
- Real content (or realistic)
- Interaction states
- Good for development handoff

## Wireframe Types

### Page Wireframes
Individual page/screen layouts

### Flow Wireframes
Connected screens showing user paths

### Component Wireframes
Reusable UI components in isolation

### Responsive Wireframes
Same content across breakpoints (desktop, tablet, mobile)

## Inputs & Dependencies

- Information Architecture
- User flows and journey maps
- User stories and requirements
- Content inventory
- Research insights
- Technical constraints
- Brand guidelines (for context)

## Outputs & Deliverables

- Wireframe files (Figma, Sketch, etc.)
- Annotated wireframes
- Wireflow documents
- Presentation for stakeholders
- Prototype (if linked)
- Handoff documentation

## Best Practices

1. **Start Low-Fi**: Begin with sketches before going digital.

2. **Focus on Structure**: Don't get distracted by visual details.

3. **Use Real Content**: When possible, use real content to test layout.

4. **Annotate Thoroughly**: Explain behavior that isn't obvious visually.

5. **Test Early**: Use wireframes for early usability testing.

6. **Show States**: Include error states, empty states, loading states.

7. **Consider Responsive**: Think about different screen sizes.

8. **Iterate Quickly**: Wireframes should be disposable—don't get precious.

9. **Version Control**: Track iterations for reference.

## Common Pitfalls

- **Too Polished Too Soon**: Adding visual design before structure is right
- **Missing Annotations**: Wireframes without explanation
- **Ignoring Edge Cases**: Only showing happy path
- **No Real Content**: Using "Lorem ipsum" when real content matters
- **Single Device**: Forgetting mobile or desktop
- **No States**: Missing error, empty, or loading conditions
- **Skipping Wireframes**: Jumping straight to high-fidelity
- **Treating as Final**: Not iterating based on feedback

## Tools

### Digital Wireframing
- **Figma**: Industry standard, collaborative
- **Sketch**: Mac-based, robust features
- **Adobe XD**: Part of Adobe ecosystem
- **Balsamiq**: Low-fi wireframe specialist
- **Whimsical**: Quick wireframes and flows

### Quick Sketching
- **Pen and Paper**: Still fastest for early ideas
- **Miro/FigJam**: Digital whiteboarding
- **Excalidraw**: Hand-drawn style digital

### Prototyping
- **Figma Prototyping**: Built-in to Figma
- **InVision**: Click-through prototypes
- **Principle**: Animated prototypes

## Related Documents

- [Information Architecture](../information-architecture/_description.md) - Structure that wireframes visualize
- [User Stories & Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Requirements wireframes address
- [Clickable Prototype](../clickable-prototype/_description.md) - Interactive version of wireframes
- [Design System / UI Kit](../design-system-ui-kit/_description.md) - Visual design applied to wireframes
- [Product Requirements Document](../product-requirements-document/_description.md) - Requirements context

## Examples & References

### Wireframe Annotation Example

```
┌─────────────────────────────────────────────────────────────┐
│ [Logo]                          [Search] [Account] [Cart]   │
├─────────────────────────────────────────────────────────────┤
│ Home > Products > [Category] > [Product Name]               │ ← Breadcrumb
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    Product Title                          │
│  │             │    ★★★★☆ (42 reviews)                     │
│  │   [Image]   │                                           │
│  │             │    $99.00                                  │
│  │             │                                           │
│  └─────────────┘    [Size Dropdown ▼]                      │ ← Required selection
│                                                             │   before Add to Cart
│  [○] [○] [○] [○]    [Quantity: 1 ▼]                       │   is enabled
│  Image thumbs                                               │
│                     [████ Add to Cart ████]                │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ Description │ Specifications │ Reviews (42)                 │ ← Tab interface
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ [Tab content area - changes based on selected tab]         │
│                                                             │
└─────────────────────────────────────────────────────────────┘

ANNOTATIONS:
1. Image gallery: Main image with thumbnail navigation
2. Size selection required before Add to Cart enables
3. Reviews tab shows count; clicking scrolls to review section
4. Mobile: Stack image above product info, tabs become accordion
```

### Wireframe Fidelity Comparison

| Low-Fi | Mid-Fi | High-Fi |
|--------|--------|---------|
| Boxes with X | Grayscale shapes | Accurate layout |
| "Image here" | Placeholder images | Real or realistic |
| Rough spacing | Approximate grid | Precise spacing |
| Hand-drawn feel | Clean lines | Development-ready |

### Further Reading

- "Wireframing 101" - Nielsen Norman Group
- "The Guide to Wireframing" - UXPin
- "Wireframes vs. Prototypes" - Adobe XD Ideas
- "How to Create a Wireframe" - Figma
