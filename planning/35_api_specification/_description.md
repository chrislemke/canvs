# API Specification (OpenAPI / GraphQL Schema)

## Overview

An API Specification is a formal document that describes the interface, capabilities, and contract of an Application Programming Interface. For REST APIs, OpenAPI (formerly Swagger) is the industry standard; for GraphQL APIs, the schema definition serves this purpose. The specification defines endpoints, operations, request/response formats, authentication, and error handling—serving as both documentation and a machine-readable contract.

## Purpose

- **Define contracts**: Establish clear interface agreements between systems
- **Enable documentation**: Auto-generate human-readable API docs
- **Support testing**: Enable automated API testing and mocking
- **Generate code**: Create client SDKs and server stubs
- **Facilitate collaboration**: Common understanding between frontend and backend
- **Ensure consistency**: Standard patterns across API endpoints
- **Enable tooling**: Power API gateways, validators, and explorers

## When to Create

- **API Design Phase**: Before implementing new APIs
- **New Endpoints**: When adding functionality
- **API Versioning**: When creating new API versions
- **Integration Projects**: When third parties will consume the API
- **Documentation Updates**: As APIs evolve
- **Contract-First Development**: Design spec before implementation

## Who's Involved

| Role | Responsibility |
|------|----------------|
| API Designer/Architect | Defines API structure and patterns |
| Backend Engineers | Implement and maintain spec |
| Frontend Engineers | Consume API, provide feedback |
| Technical Writer | Enhance documentation |
| QA Engineers | Use spec for testing |
| Developer Relations | Ensure external developer experience |

## Key Components

### OpenAPI Specification

**1. Info & Metadata**
- API title, description, version
- Contact and license information
- Terms of service

**2. Servers**
- Base URLs for different environments
- Server variables

**3. Paths & Operations**
- Endpoints and HTTP methods
- Parameters (path, query, header)
- Request bodies
- Responses (success and error)

**4. Components**
- Reusable schemas (data models)
- Security schemes
- Parameters and responses
- Examples

**5. Security**
- Authentication methods (OAuth, API key, JWT)
- Required scopes
- Security requirements per operation

### GraphQL Schema

**1. Types**
- Object types (entities)
- Input types (for mutations)
- Enums and scalars

**2. Queries**
- Read operations
- Arguments and return types

**3. Mutations**
- Write operations
- Input and return types

**4. Subscriptions**
- Real-time operations

**5. Directives**
- Custom behaviors (@deprecated, @auth, etc.)

## OpenAPI vs GraphQL

| Aspect | OpenAPI (REST) | GraphQL |
|--------|----------------|---------|
| Structure | Multiple endpoints | Single endpoint |
| Data fetching | Fixed responses | Client-specified fields |
| Versioning | URL or header versioning | Schema evolution |
| Caching | HTTP caching | Custom solutions |
| Documentation | Swagger UI, ReDoc | GraphQL Playground, Apollo Studio |

## Inputs & Dependencies

- Product requirements
- Data model/ER diagrams
- Authentication requirements
- Existing API patterns
- Integration requirements
- Performance requirements

## Outputs & Deliverables

- OpenAPI YAML/JSON specification or GraphQL SDL
- Auto-generated documentation
- Client SDKs (optional)
- Server stubs (optional)
- Mock server for testing
- Postman/Insomnia collections

## Best Practices

1. **Design First**: Create spec before implementation.

2. **Use Semantic Versioning**: Version your API clearly.

3. **Be Consistent**: Follow naming conventions throughout.

4. **Document Everything**: Include descriptions, examples, error cases.

5. **Use Reusable Components**: Define schemas once, reference everywhere.

6. **Include Examples**: Real example requests and responses.

7. **Version Control**: Store spec in repository with code.

8. **Validate**: Use linters to catch specification errors.

9. **Generate Docs**: Auto-generate documentation from spec.

## Common Pitfalls

- **Implementation First**: Generating spec from code leads to poor design
- **Incomplete Documentation**: Missing descriptions and examples
- **Inconsistent Naming**: Different conventions across endpoints
- **Missing Error Responses**: Only documenting success cases
- **Outdated Specs**: Code and spec drift apart
- **Over-Engineering**: Too many endpoints for simple needs
- **Ignoring Standards**: Not following OpenAPI or GraphQL conventions
- **No Versioning Strategy**: Breaking changes without version bumps

## Tools

### OpenAPI
- **Design**: Stoplight Studio, SwaggerHub
- **Documentation**: Swagger UI, ReDoc, Redocly
- **Validation**: Spectral, OpenAPI Generator
- **Testing**: Postman, Insomnia, Dredd
- **Mocking**: Prism, Mockoon

### GraphQL
- **Design**: Apollo Studio, GraphQL Editor
- **Documentation**: GraphQL Voyager, SpectaQL
- **Playground**: GraphQL Playground, Apollo Sandbox
- **Validation**: graphql-schema-linter
- **Testing**: Apollo Client DevTools

## Related Documents

- [Architecture Overview](../architecture-overview/_description.md) - System context for API
- [Data Model](../data-model/_description.md) - Data structures behind API
- [Integration Requirements](../integration-requirements/_description.md) - External API needs
- [Security & Privacy Requirements](../security-privacy-requirements/_description.md) - Auth requirements
- [Internal Documentation](../internal-documentation/_description.md) - Developer docs

## Examples & References

### OpenAPI Example (YAML)

```yaml
openapi: 3.0.3
info:
  title: Order API
  version: 1.0.0
  description: API for managing orders

servers:
  - url: https://api.example.com/v1

paths:
  /orders:
    get:
      summary: List orders
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [pending, completed, cancelled]
      responses:
        '200':
          description: List of orders
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Order'
    post:
      summary: Create order
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateOrder'
      responses:
        '201':
          description: Order created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'

components:
  schemas:
    Order:
      type: object
      properties:
        id:
          type: string
          format: uuid
        status:
          type: string
        total:
          type: number
```

### GraphQL Schema Example

```graphql
type Query {
  orders(status: OrderStatus): [Order!]!
  order(id: ID!): Order
}

type Mutation {
  createOrder(input: CreateOrderInput!): Order!
  updateOrderStatus(id: ID!, status: OrderStatus!): Order!
}

type Order {
  id: ID!
  status: OrderStatus!
  total: Float!
  items: [OrderItem!]!
  createdAt: DateTime!
}

input CreateOrderInput {
  items: [OrderItemInput!]!
}

enum OrderStatus {
  PENDING
  PROCESSING
  COMPLETED
  CANCELLED
}
```

### Further Reading

- [OpenAPI Specification](https://spec.openapis.org/oas/v3.1.0)
- [GraphQL Specification](https://spec.graphql.org/)
- "API Design Patterns" - JJ Geewax
- "Designing Web APIs" - Brenda Jin, Saurabh Sahni
