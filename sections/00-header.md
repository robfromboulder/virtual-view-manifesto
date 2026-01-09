# The Virtual View Manifesto
**Stop treating SQL views like decoration. Start using them as your application's data contract.**

Classical SQL views are boring schema decoration for hiding joins, adding computed columns, and enforcing permissions. **Virtual views** are different. They're architectural components that decouple applications and agents from physical storage, enable prototyping and testing with static data, allow seamless migration to Iceberg, and support zero-downtime schema evolution. Virtual views are layered into **hierarchies**, where any layer in the hierarchy can be replaced (even at runtime) without disrupting other layers or active queries.

For SQL-native applications and data platforms, virtual views provide an alternative to ORMs and microservices for decoupling applications and agents from physical storage, operating at the database layer rather than in application code. 

Virtual view hierarchies can be implemented using Trino, Starburst Enterprise or Galaxy, Amazon Athena, Presto, and most databases that support SQL views (including PostgreSQL and MySQL). Trino is used for all examples here.

This manifesto isn't just theory, it provides practical strategies and examples to follow when introducing virtual views into your architecture, and links to free tools to discover and manage view hierarchies with Trino.

> [!CAUTION]
> This is a work in progress and is neither complete nor peer reviewed.

---

## Table of Contents

- [Introduction: Views as Architecture, Not Decoration](#introduction-views-as-architecture-not-decoration)
- [Principles of Virtual View Hierarchies](#principles-of-virtual-view-hierarchies)
- [Use Cases: When Virtual Views Shine](#use-cases-when-virtual-views-shine)
- [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
- [When NOT to Use Virtual Views](#when-not-to-use-virtual-views)
- [Related Tools](#related-tools)
- [Glossary](#glossary)
