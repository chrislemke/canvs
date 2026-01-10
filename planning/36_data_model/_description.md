# Data Model / ER Diagram

## Overview

A Data Model document describes the structure, relationships, and constraints of data within a system. Entity-Relationship (ER) Diagrams visualize entities (tables), their attributes (columns), and the relationships between them. This documentation serves as the blueprint for database design, ensuring data integrity, guiding development, and enabling effective communication about data structures.

## Purpose

- **Design databases**: Plan database structure before implementation
- **Document structure**: Provide reference for current data architecture
- **Communicate design**: Share understanding across teams
- **Ensure integrity**: Define relationships and constraints
- **Support migration**: Guide schema changes and migrations
- **Enable analysis**: Support data analysis and reporting needs
- **Facilitate onboarding**: Help new team members understand data

## When to Create

- **New System Design**: Before building database schema
- **Feature Development**: When adding new data requirements
- **Schema Changes**: Before making database modifications
- **Integration Projects**: When connecting to external data
- **Data Migration**: When moving between systems
- **Documentation Updates**: As data structures evolve

## Who's Involved

| Role | Responsibility |
|------|----------------|
| Database Designer/DBA | Creates and maintains data model |
| Software Architect | Ensures alignment with system architecture |
| Backend Engineers | Implement and work with the model |
| Data Engineers | Design for analytics and reporting |
| Product Manager | Validates business requirements |

## Key Components

### 1. Entities (Tables)
- Name and description
- Business purpose
- Primary key

### 2. Attributes (Columns)
- Name and data type
- Constraints (NOT NULL, UNIQUE)
- Default values
- Description

### 3. Relationships
- One-to-one
- One-to-many
- Many-to-many
- Foreign keys

### 4. Constraints
- Primary keys
- Foreign keys
- Unique constraints
- Check constraints

### 5. Indexes
- Primary indexes
- Secondary indexes
- Full-text indexes

### 6. Data Types
- Standard types for the DBMS
- Custom types (enums, etc.)

## ER Diagram Notation

### Entities
Rectangles representing tables/objects

### Attributes
Listed within entities or as ovals

### Relationships
Lines connecting entities with cardinality notation:
- `1` - One
- `N` or `*` - Many
- `0..1` - Zero or one (optional)
- `1..*` - One or more

### Common Notations
- **Crow's Foot**: Most popular for databases
- **Chen**: Academic, conceptual
- **UML Class Diagrams**: Software-focused

## Model Levels

### Conceptual Model
- High-level business entities
- No technical details
- For business stakeholders

### Logical Model
- Detailed entities and relationships
- Attributes with types
- Platform-independent

### Physical Model
- Database-specific implementation
- Actual table and column names
- Indexes and constraints

## Inputs & Dependencies

- Product requirements
- User stories and features
- Existing data structures
- Integration requirements
- Reporting/analytics needs
- Compliance requirements (GDPR, etc.)

## Outputs & Deliverables

- ER diagrams (multiple levels)
- Data dictionary
- Schema definitions (SQL DDL)
- Migration scripts
- Documentation in wiki/repo
- Relationship matrix

## Best Practices

1. **Start Conceptual**: Begin with business concepts, then add detail.

2. **Normalize Appropriately**: Balance normalization with query performance.

3. **Document Everything**: Include descriptions for tables and columns.

4. **Use Consistent Naming**: Follow naming conventions throughout.

5. **Version Control**: Track schema changes over time.

6. **Include Indexes**: Document indexes for key queries.

7. **Consider Growth**: Design for future data volume.

8. **Review with Stakeholders**: Validate business requirements.

## Common Pitfalls

- **Over-Normalization**: Too many joins hurt performance
- **Under-Normalization**: Data redundancy causes inconsistency
- **Missing Relationships**: Foreign keys not properly defined
- **No Documentation**: Cryptic column names without explanation
- **Ignoring Scale**: Not considering data volume growth
- **Schema Drift**: Code and documentation out of sync
- **Generic Naming**: Columns like "value1", "data", etc.
- **Missing Constraints**: No validation at database level

## Tools

### Diagramming
- **dbdiagram.io**: Code-based ER diagrams
- **DrawSQL**: Visual database design
- **Lucidchart**: General diagramming with ER support
- **ERDPlus**: Free ER diagram tool
- **DBeaver**: Database tool with ER diagrams

### Database Tools
- **MySQL Workbench**: MySQL modeling
- **pgModeler**: PostgreSQL modeling
- **DataGrip**: JetBrains database IDE
- **DbVisualizer**: Multi-database tool

### Documentation
- **Schema Spy**: Auto-generated documentation
- **Dataedo**: Data documentation platform

## Related Documents

- [Architecture Overview](../architecture-overview/_description.md) - System context
- [API Specification](../api-specification/_description.md) - API data structures
- [Product Requirements Document](../product-requirements-document/_description.md) - Data requirements
- [Non-Functional Requirements](../non-functional-requirements/_description.md) - Performance needs
- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Data protection

## Examples & References

### ER Diagram Example (Crow's Foot Notation)

```
┌─────────────────┐       ┌─────────────────┐
│     User        │       │     Order       │
├─────────────────┤       ├─────────────────┤
│ PK id           │       │ PK id           │
│    email        │       │ FK user_id      │───┐
│    name         │       │    status       │   │
│    created_at   │◄──────│    total        │   │
└─────────────────┘   1:N │    created_at   │   │
                          └─────────────────┘   │
                                  │             │
                                  │ 1:N         │
                                  ▼             │
                          ┌─────────────────┐   │
                          │   OrderItem     │   │
                          ├─────────────────┤   │
                          │ PK id           │   │
                          │ FK order_id     │───┘
                          │ FK product_id   │───┐
                          │    quantity     │   │
                          │    price        │   │
                          └─────────────────┘   │
                                                │
                          ┌─────────────────┐   │
                          │    Product      │   │
                          ├─────────────────┤   │
                          │ PK id           │◄──┘
                          │    name         │
                          │    price        │
                          │    sku          │
                          └─────────────────┘
```

### Data Dictionary Example

| Table | Column | Type | Null | Description |
|-------|--------|------|------|-------------|
| users | id | UUID | No | Primary key |
| users | email | VARCHAR(255) | No | Unique user email |
| users | name | VARCHAR(100) | No | Display name |
| users | created_at | TIMESTAMP | No | Account creation time |
| orders | id | UUID | No | Primary key |
| orders | user_id | UUID | No | FK to users.id |
| orders | status | ENUM | No | pending, completed, cancelled |
| orders | total | DECIMAL(10,2) | No | Order total in USD |

### dbdiagram.io Syntax Example

```
Table users {
  id uuid [pk]
  email varchar(255) [unique, not null]
  name varchar(100) [not null]
  created_at timestamp [default: `now()`]
}

Table orders {
  id uuid [pk]
  user_id uuid [ref: > users.id]
  status order_status [not null]
  total decimal(10,2) [not null]
  created_at timestamp [default: `now()`]
}

enum order_status {
  pending
  completed
  cancelled
}
```

### Further Reading

- "ER Diagram (ERD) - Definition & Overview" - Lucidchart
- "What is Entity Relationship Diagram (ERD)?" - Visual Paradigm
- "Database Design for Mere Mortals" - Michael J. Hernandez
- "SQL Antipatterns" - Bill Karwin
