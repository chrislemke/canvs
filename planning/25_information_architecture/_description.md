# Information Architecture (IA)

## Overview

Information Architecture (IA) is the structural design of information environments—the practice of organizing, labeling, and structuring content to help users find what they need and accomplish their goals. In digital product design, IA serves as the blueprint that guides how content is categorized, how navigation works, and how users move through an interface. The IA documentation typically includes site maps, content hierarchies, taxonomies, and navigation models.

## Purpose

- **Enable findability**: Help users find information efficiently
- **Organize content**: Create logical structure for large amounts of content
- **Guide navigation**: Define how users move through the product
- **Scale gracefully**: Create structure that accommodates growth
- **Align teams**: Provide shared vocabulary and structure
- **Inform design**: Blueprint for wireframes and prototypes
- **Improve UX**: Reduce cognitive load and confusion

## When to Create

- **New Product Design**: Before wireframing and UI design
- **Site Redesign**: When restructuring existing products
- **Content Strategy**: When organizing large content libraries
- **Product Scaling**: When adding significant new features
- **Navigation Improvements**: When users can't find things
- **Platform Consolidation**: When merging multiple products

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Information Architect | Leads IA design and documentation |
| UX Designer | Translates IA into interface design |
| Content Strategist | Defines content types and taxonomy |
| Product Manager | Ensures IA supports product goals |
| Developer | Implements navigation and structure |
| Users | Validate IA through testing |

## Key Components

### 1. Site Map / Structure Diagram
Visual hierarchy of all pages/screens and their relationships

### 2. Content Inventory
Comprehensive list of all content types and items

### 3. Taxonomy
Classification system for content (categories, tags)

### 4. Labeling System
Consistent names for navigation and content

### 5. Navigation Model
How users move between sections (global, local, contextual)

### 6. Search System
How search works and what's searchable

### 7. Metadata Schema
How content is described and connected

### 8. User Flows
How users move through key tasks

## IA Structure Types

### Hierarchical (Tree)
- Top-down structure with parent-child relationships
- Most common for websites and apps
- Example: Main menu → Category → Subcategory → Item

### Sequential (Linear)
- Step-by-step paths
- Used for processes (checkout, onboarding)
- Example: Step 1 → Step 2 → Step 3 → Complete

### Matrix
- Multiple ways to access content
- Filter by different attributes
- Example: Products filtered by price, size, color

### Database-Driven
- Dynamic content relationships
- User-generated connections
- Example: Related items, recommendations

### Hub-and-Spoke
- Central hub with connected sections
- Common in mobile apps
- Example: Home screen → Features → Back to home

## Site Map Components

### Page Numbering Convention
```
1.0 Home
2.0 Products
  2.1 Product Category A
    2.1.1 Product Detail
  2.2 Product Category B
3.0 About
4.0 Contact
```

### Page Documentation
- Page name and number
- Page goal/purpose
- Key content elements
- Functionality requirements
- Parent/child relationships

## Inputs & Dependencies

- User research and personas
- Content audit/inventory
- Business requirements
- Competitive analysis
- Search analytics (existing products)
- Card sorting results
- Tree testing results
- Jobs-to-be-done

## Outputs & Deliverables

- Site map/structure diagram
- Content inventory spreadsheet
- Taxonomy documentation
- Navigation specifications
- Labeling guidelines
- User flow diagrams
- IA documentation for development
- Card sort and tree test results

## Best Practices

1. **User-Centered**: Structure should reflect user mental models, not org charts.

2. **Test with Users**: Card sorting and tree testing validate IA decisions.

3. **Use Clear Labels**: Navigation labels should be obvious and consistent.

4. **Keep It Flat**: Minimize depth—ideally 3-4 levels maximum.

5. **Plan for Growth**: Design structure that accommodates new content.

6. **Document Thoroughly**: IA is the foundation—document it well.

7. **Consider Multiple Entry Points**: Users don't always start at the homepage.

8. **Balance Breadth and Depth**: Too many top-level items is as bad as too deep.

## Common Pitfalls

- **Org-Chart Structure**: Organizing by company departments, not user needs
- **Too Deep**: Requiring too many clicks to reach content
- **Inconsistent Labels**: Same thing called different names
- **Untested Assumptions**: IA based on internal guesses, not user research
- **No Room to Grow**: Structure that breaks with new content
- **Jargon**: Using internal language users don't understand
- **Neglecting Search**: Treating search as an afterthought
- **Static Thinking**: Not planning for personalization or dynamic content

## IA Research Methods

### Card Sorting
Users group content cards into categories they create (open) or predefined (closed)

### Tree Testing
Users navigate a text-only hierarchy to find items, validating structure

### First-Click Testing
Track where users first click to complete tasks

### Analytics Review
Analyze search queries and navigation paths in existing products

## Tools & Templates

- **Diagramming**: Miro, Figma, Lucidchart, Omnigraffle
- **Site Mapping**: WriteMaps, FlowMapp, Slickplan
- **Card Sorting**: Optimal Workshop, UserZoom
- **Tree Testing**: Optimal Workshop, Treejack
- **Documentation**: Confluence, Notion

## Related Documents

- [User Journey Maps](../user-journey-maps/_description.md) - Journeys through the IA
- [Wireframes](../wireframes/_description.md) - IA brought to visual form
- [UX Research Plan](../ux-research-plan/_description.md) - Research to validate IA
- [Product Requirements Document](../product-requirements-document/_description.md) - Requirements shaping IA
- [User Stories & Acceptance Criteria](../user-stories-acceptance-criteria/_description.md) - Features within IA

## Examples & References

### Site Map Example

```
                         ┌──────────────────┐
                         │    1.0 HOME      │
                         └────────┬─────────┘
        ┌──────────────────┬──────┴───────┬──────────────────┐
        ▼                  ▼              ▼                  ▼
┌───────────────┐  ┌───────────────┐  ┌───────────┐  ┌───────────────┐
│ 2.0 PRODUCTS  │  │ 3.0 SOLUTIONS │  │ 4.0 ABOUT │  │ 5.0 RESOURCES │
└───────┬───────┘  └───────────────┘  └───────────┘  └───────┬───────┘
        │                                                      │
   ┌────┴────┐                                           ┌────┴────┐
   ▼         ▼                                           ▼         ▼
┌──────┐  ┌──────┐                                   ┌──────┐  ┌──────┐
│ 2.1  │  │ 2.2  │                                   │ 5.1  │  │ 5.2  │
│ Cat A│  │ Cat B│                                   │ Blog │  │ Docs │
└──┬───┘  └──────┘                                   └──────┘  └──────┘
   │
   ▼
┌──────┐
│2.1.1 │
│Detail│
└──────┘
```

### Content Inventory Template

| ID | Page Name | URL | Parent | Content Type | Owner | Status |
|----|-----------|-----|--------|--------------|-------|--------|
| 1.0 | Home | / | - | Landing | Marketing | Live |
| 2.0 | Products | /products | 1.0 | Hub | Product | Live |
| 2.1 | Analytics | /products/analytics | 2.0 | Product | Product | Draft |

### Navigation Specification

**Global Navigation:**
- Products (dropdown with categories)
- Solutions (dropdown with use cases)
- Pricing (single page)
- Resources (dropdown: Blog, Docs, Community)
- Sign In (utility)

**Footer Navigation:**
- Company: About, Careers, Press, Contact
- Legal: Terms, Privacy, Security
- Social: Twitter, LinkedIn, GitHub

### Further Reading

- "The UX Process for Information Architecture" - Toptal
- "Information Architecture vs. Sitemaps" - Nielsen Norman Group
- "What Is Information Architecture?" - Figma
- "How to Create Information Architecture for Web Design" - AltexSoft
- "Information Architecture: For the Web and Beyond" - Rosenfeld, Morville, Arango
