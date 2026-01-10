# Pricing & Packaging Strategy

## Overview

A Pricing & Packaging Strategy document defines how your product will be monetized through pricing models, tier structures, feature bundling, and pricing levels. It translates product value into revenue by determining what customers pay for and how. For SaaS and subscription businesses, this includes decisions about pricing models (per-seat, usage-based, flat-rate), tier structures (Good/Better/Best), and the features included in each package.

## Purpose

- **Maximize revenue**: Capture appropriate value for the product
- **Enable segmentation**: Serve different customer segments appropriately
- **Drive growth**: Create upgrade paths that grow with customers
- **Simplify decisions**: Make it easy for customers to understand and choose
- **Support positioning**: Align pricing with market position (premium, value, etc.)
- **Optimize metrics**: Impact key SaaS metrics (ARPU, NRR, CAC payback)
- **Enable sales**: Give sales clear packaging to sell against

## When to Create

- **Pre-Launch**: Before going to market with a new product
- **Pricing Review**: Regular (usually annual) pricing strategy reviews
- **New Segment Entry**: When targeting new customer segments
- **Competitive Response**: When competitor pricing shifts significantly
- **Product Evolution**: When product capabilities significantly change
- **Growth Stage Transitions**: When moving from startup to scale-up

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Product Manager | Leads strategy, defines packaging |
| Finance | Models revenue impact, unit economics |
| Sales | Tests pricing in market, provides feedback |
| Marketing | Positions pricing in market |
| Customer Success | Provides usage and upgrade pattern insights |
| Leadership | Approves pricing strategy |
| Legal | Reviews for compliance |

## Key Components

### 1. Pricing Model
How customers pay:
- **Per-Seat**: Price per user (Slack, Figma)
- **Usage-Based**: Pay for what you use (AWS, Stripe)
- **Flat-Rate**: Single price for full access (Basecamp)
- **Tiered**: Fixed tiers with increasing value (most SaaS)
- **Freemium**: Free tier with paid upgrades
- **Hybrid**: Combination (base + usage, seats + features)

### 2. Tier Structure
Package levels (typically 3-5):
- **Free/Starter**: Entry point, limited features
- **Professional**: Core features for most users
- **Business/Team**: Collaboration, admin features
- **Enterprise**: Custom, security, support

### 3. Feature Packaging
How features are distributed across tiers:
- Core features in lower tiers
- Differentiating features in higher tiers
- Clear upgrade triggers

### 4. Price Points
Actual prices for each tier:
- Benchmark against competitors
- Value-based pricing analysis
- Price elasticity considerations
- Psychological pricing ($99 vs. $100)

### 5. Value Metric
The unit of measure for pricing:
- Per user/seat
- Per transaction
- Per resource (GB, API calls)
- Per active user
- Per workspace/team

### 6. Upgrade Paths
How customers move between tiers:
- Natural growth triggers
- Clear value at each step
- Easy to understand transitions

### 7. Add-Ons & Extras
Features sold separately:
- Premium support
- Advanced features
- Professional services
- Training and onboarding

## Common SaaS Pricing Models

### Good/Better/Best (Most Common)
Three tiers with progressively higher value:
```
┌─────────┐  ┌─────────┐  ┌─────────┐
│  Basic  │  │   Pro   │  │Enterprise│
│ $10/mo  │  │ $30/mo  │  │ Custom  │
│         │  │         │  │         │
│ Core    │  │+ Adv    │  │+ Custom │
│features │  │features │  │ + SLA   │
└─────────┘  └─────────┘  └─────────┘
```

### Usage-Based
Pay for what you consume:
- Popular with infrastructure and API products
- Better aligns cost with value
- More complex to predict revenue

### Hybrid
Combination of models:
- Base subscription + usage
- Per-seat + feature tiers
- Freemium + paid add-ons

## Inputs & Dependencies

- Value Proposition & Differentiators
- Competitive Analysis (competitor pricing)
- Target Customer Personas
- Market Sizing (willingness to pay)
- Product feature inventory
- Cost structure and unit economics
- Customer usage data
- Win/loss analysis on price

## Outputs & Deliverables

- Pricing strategy document
- Tier comparison matrix
- Feature packaging chart
- Price list with justification
- Sales price card
- Website pricing page spec
- Revenue projections
- Competitive pricing comparison

## Best Practices

1. **Align with Value**: Price based on value delivered, not cost to serve.

2. **Keep It Simple**: If customers can't understand pricing in 30 seconds, it's too complex.

3. **Create Clear Upgrades**: Customers should know when and why they'd move to the next tier.

4. **Design for Expansion**: Good packaging incentivizes customers to grow into higher tiers.

5. **Test and Iterate**: Pricing is never "done"—test and adjust based on data.

6. **Consider Psychology**: Anchoring, charm pricing ($99), and tier ordering matter.

7. **Use Consistent Names**: Tier names should match across website, sales, and support.

8. **Reserve Enterprise for True Enterprise**: Don't over-engineer for customers you don't have.

9. **Monitor Key Metrics**: Track impact on conversion, ARPU, churn, and expansion revenue.

## Common Pitfalls

- **Pricing Too Low**: Undervaluing the product hurts perception and revenue
- **Too Many Tiers**: More than 4-5 tiers creates decision paralysis
- **Feature Confusion**: Customers can't understand what's in each tier
- **No Upgrade Path**: Pricing that doesn't grow with customers
- **Misaligned Value Metric**: Charging per-seat when value is per-project
- **Ignoring Competition**: Pricing in a vacuum without market context
- **Set and Forget**: Not reviewing pricing as product and market evolve
- **Hidden Costs**: Surprising customers with add-ons and fees

## Tools & Templates

- **Pricing Tools**: Chargebee, Stripe Billing, ProfitWell
- **Analysis**: Price Intelligently, Ordway
- **Modeling**: Excel, Google Sheets with pricing models
- **Research**: Conjoint analysis tools, survey platforms
- **Competitive Intel**: Kompyte, Klue for competitor pricing

## Related Documents

- [Value Proposition & Differentiators](../value-proposition-differentiators/_description.md) - Value to monetize
- [Competitive Analysis](../competitive-analysis/_description.md) - Competitor pricing
- [Target Customer Personas](../target-customer-personas/_description.md) - Willingness to pay by segment
- [Business Model Outline](../business-model-outline/_description.md) - Overall monetization strategy
- [Scope Definition](../scope-definition/_description.md) - Features to package

## Examples & References

### Tier Comparison Example

| Feature | Free | Pro $29/mo | Team $79/mo | Enterprise |
|---------|------|------------|-------------|------------|
| Projects | 3 | Unlimited | Unlimited | Unlimited |
| Users | 1 | 1 | Up to 10 | Unlimited |
| Storage | 1 GB | 10 GB | 100 GB | Unlimited |
| Integrations | 3 | All | All | All + custom |
| SSO | - | - | ✓ | ✓ |
| SLA | - | - | - | 99.9% |
| Support | Community | Email | Priority | Dedicated |

### Value Metric Decision Framework

| Value Metric | Best For | Examples |
|--------------|----------|----------|
| Per-seat | Collaboration tools | Slack, Figma |
| Per-usage | Infrastructure | AWS, Twilio |
| Per-transaction | Payment/commerce | Stripe, Shopify |
| Flat-rate | Simple products | Basecamp |
| Per-active-user | Variable adoption | Productboard |

### Further Reading

- "The Ultimate Guide to SaaS Pricing Models, Strategies & Psychological Hacks" - Cobloom
- "Pricing and Packaging SaaS: An Introduction" - Alguna
- "9 Steps to Create a Pricing and Packaging Strategy" - Orb
- "7 Strategies for SaaS Pricing & Packaging" - Peak Capital
- "SaaS Tiered Billing & Three-Tier Pricing Strategy Guide" - Maxio
- "Monetizing Innovation" - Madhavan Ramanujam
