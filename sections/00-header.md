<a href="#"><img src=".github/images/m000-manifesto.svg" width="100%" alt="The Virtual View Manifesto. Stop treating SQL views like decoration. Use them as data contracts for apps and agents. 8 organizing principles: views belong to apps and agents; every view has multiple versions; apps usually query views; every view has one owner; never change column types; use invoker permissions; store views in one canonical place; map complexity, don't memorize it. A layer cake in section: postgresql.myapp.* tables, base views, a versioned layer, and myapp.* views; the versioned layer and base views are each a replaceable layer, with a lit candle for apps and agents running queries. Shaded parts mark test data in every layer. Three panels: 1, view hierarchy in service, orders served from v1: stable views as data contract, pointing at myapp.*. 2, zero-downtime migration, running queries keep v1: orders_v2 swapped into the middle layer as orders_v1 floats out, swap in new version. 3, Iceberg scale-out, federation between PG and Iceberg, with base views v3 and iceberg.myapp.* added below postgresql: add iceberg storage layer. Three phases, no downtime, no one changed the app. Title block: virtual-view-manifesto, version v0.70, scale enterprise, revision date 2026-10-12, license CC0."></a>

[![Claude Code](https://img.shields.io/badge/Built%20with%20Claude%20Code-6366f1?logo=claude&logoColor=white)](https://claude.ai/code)
[![Contributing](https://img.shields.io/badge/contributions-welcome-green.svg)](https://github.com/robfromboulder/virtual-view-manifesto/blob/main/CONTRIBUTING.md)
[![License](https://img.shields.io/github/license/robfromboulder/virtual-view-manifesto)](https://github.com/robfromboulder/virtual-view-manifesto/blob/main/LICENSE)

Classical SQL views are boring schema decoration for hiding joins, adding computed columns, and enforcing permissions. **Virtual views** are different. They're architectural components that decouple applications and agents from physical storage, enable prototyping and testing with static data, allow seamless migration to Iceberg, and support zero-downtime schema evolution. Virtual views are layered into **hierarchies**, where any layer in the hierarchy can be replaced (even at runtime) without disrupting other layers or active queries.

For SQL-native applications and data platforms, virtual views provide an alternative to ORMs and microservices for decoupling applications and agents from physical storage. Virtual views operate at the query engine layer rather than in application code, and require no extra network calls. 

Virtual views can be implemented using Trino, Starburst Enterprise or Galaxy, Amazon Athena, Presto, and most databases that support SQL views (including PostgreSQL and MySQL). Trino is used for all examples here.

This manifesto isn't just theory, it provides practical strategies and examples to follow when introducing virtual views into your architecture, and links to free tools to discover and manage view hierarchies with Trino.

> [!NOTE]
> This project is not officially endorsed or supported by Starburst.

---

## Table of Contents

- [Introduction: Views as Architecture, Not Decoration](#introduction-views-as-architecture-not-decoration)
- [Principles of Virtual View Hierarchies](#principles-of-virtual-view-hierarchies)
- [Use Cases: When Virtual Views Shine](#use-cases-when-virtual-views-shine)
- [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
- [When NOT to Use Virtual Views](#when-not-to-use-virtual-views)
- [Related Tools](#related-tools)
- [Glossary](#glossary)
