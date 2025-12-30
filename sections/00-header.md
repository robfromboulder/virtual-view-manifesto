# The Virtual View Manifesto
**Stop treating SQL views like decoration. Start using them as your application's data contract.**

Classical SQL views are boring schema decoration for hiding joins, adding computed columns, and enforcing permissions. **Virtual views** are different. They're architectural components that decouple applications and agents from physical storage, enable prototyping and testing with static data, allow seamless migration to Iceberg, and support zero-downtime schema evolution. Virtual views can be layered into **hierarchies**, where any layer in the hierarchy can be replaced (even at runtime) without disrupting other layers or active queries.

Unlike using remote microservices or object-to-relational mapping tools (ORMs) to decouple applications and agents from databases, virtual views apply only to the query engine layer of a SQL database, without adding significant latency or serialization overhead. 

Virtual view hierarchies can be implemented using Trino, Starburst Enterprise or Galaxy, Amazon Athena, Presto, and most databases that support SQL views (including Postgresql and MySQL). Trino is used for all examples here.

This manifesto isn't just theory, it provides practical strategies and examples to follow when introducing virtual views into your architecture, and links to free tools to discover and manage view hierarchies with Trino.

> [!CAUTION]
> This is a work in progress and is neither complete nor peer reviewed.

### What's Novel Here

This manifesto synthesizes several existing ideas:
1. **View hierarchies**: Not new, but rarely used systematically
2. **Application-centric organization**: Adapts DDD patterns to data layer
3. **Swappable data providers**: Switch between dev, test, staging, and production environments
4. **Multi-database abstraction**: Use federation capabilities in Trino/Starburst/Athena/Presto
5. **Iceberg migration focus**: Specific, pragmatic, and common use case for adoption

The novelty is the **combination and systematic approach** and documentation as a **repeatable pattern**, not individual techniques. Like the [AJAX pattern](https://en.wikipedia.org/wiki/Ajax_(programming)) for web applications, which used capabilities already available in modern browsers, the capabilities for virtual views are already present in most modern database platforms, without requiring any configuration changes or custom extensions.

### What's Controversial Here

The core idea of being able to replace layers in a virtual view hierarchy, without having to rebuild the entire hierarchy, is not standardized in ANSI/ISO SQL. Runtime behaviors when replacing views do vary between database systems. Existing standards generally assume that view definitions are frozen at creation time and only updated during migrations (when applications are offline).

This manifesto admittedly relies on multi-database platforms like Trino as the "practical standard" for how view replacement at runtime should behave. Even the most restrictive platforms (like Postgresql) generally allow views to be replaced if the column types do not change. But error handling and type checking varies by platform, so take care to validate these details when implementing virtual view hierarchies.

---

## Table of Contents

- [Introduction: Views as Architecture, Not Decoration](#introduction-views-as-architecture-not-decoration)
- [Principles of Virtual View Hierarchies](#principles-of-virtual-view-hierarchies)
- [Use Cases: When Virtual Views Shine](#use-cases-when-virtual-views-shine)
- [Implementation Guide](#implementation-guide)
- [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
- [When NOT to Use Virtual Views](#when-not-to-use-virtual-views)
- [Related Tools](#related-tools)
- [Glossary](#glossary)
