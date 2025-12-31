
---

## Introduction: Views as Architecture, Not Decoration

### A Quick Primer on Classical SQL Views

SQL views are saved SELECT statements that can be queried like regular tables. Traditional use cases for views are hiding complexity (so that joins and other complex expressions don't have to be repeated over and over in queries) and re-shaping the rows and columns returned by queries.

```mermaid
flowchart TD
    App["Application<br/>(myapp)"] --> Tables[("Physical Tables<br/>(postgresql.myapp.*)")]
    App -.-> Views["SQL Views<br/>(optional)"]
    Views --> Tables
```

**Example of hiding a join**:
```sql
CREATE VIEW customer_orders AS 
SELECT c.name, c.email, o.order_id, o.total, o.order_date
FROM postgresql.myapp.customers c 
JOIN postgresql.myapp.orders o ON c.customer_id = o.customer_id;
```

**Example of adding computed columns**:
```sql
CREATE VIEW users_enhanced AS
SELECT 
  user_id,
  first_name,
  last_name,
  first_name || ' ' || last_name as full_name,
  YEAR(CURRENT_DATE) - YEAR(birth_date) as age
FROM postgresql.myapp.users;
```

**Example of redacting sensitive data**:
```sql
-- Omit SSN column, filter to current user's data
CREATE VIEW my_profile AS
SELECT user_id, name, email, phone
FROM postgresql.myapp.users
WHERE user_id = CURRENT_USER_ID();
```

**Example of caching results (materialized views)**:
```sql
CREATE MATERIALIZED VIEW daily_sales_summary AS
SELECT 
  date_trunc('day', order_date) as day,
  SUM(total) as revenue,
  COUNT(*) as order_count
FROM postgresql.myapp.orders
GROUP BY date_trunc('day', order_date);
```

With these classical use cases, views are just icing on your physical schema to make queries a little easier. Applications mostly use physical tables, except when views are needed for security or convenience.

### The Cost of Tight Coupling to Physical Schemas

When applications query physical schemas directly, tight coupling creates friction:
- Applications must know which connector(s) to query
- Views live in the same database/connector as their tables
- Migrating storage means changing queries wherever they appear

**Example of the migration problem**:
```sql
-- Application queries PostgreSQL directly
SELECT * FROM postgresql.myapp.customers;

-- Want to move to Iceberg? Change the query...
SELECT * FROM iceberg.myapp.customers;

-- Have data in both? Handle the complexity...
SELECT * FROM postgresql.myapp.customers WHERE active = true
UNION ALL
SELECT * FROM iceberg.myapp.customers WHERE active = false;
```

### Why Not Just Use Microservices or ORMs?

Decoupling through microservices or ORMs absolutely works. If every database query in your organization flows through application code (ORMs, data access layers, microservices with ORM-backed models), you may not need virtual views.

But microservices introduce network hops, serialization overhead, and deployment complexity. ORMs add their own abstractions and performance characteristics. For workloads where SQL is already the interface (analytics tools, BI dashboards, notebooks, data science workflows, internal tools), virtual views provide schema isolation at the query engine layer, trading microservice overhead for query planning complexity.

As architectural patterns, virtual views and microservices aren't mutually exclusive. Microservices that query SQL directly (without ORMs) can benefit from virtual views that are defined using standard SQL. This provides decoupling at both the service boundary and the data access layer, often simpler than introducing an ORM.

### The Virtual View Approach

Unlike physical tables and traditional views, virtual views are organized by application or feature, designed to be replaced with different implementations while maintaining the same interface. Virtual views decouple applications from physical storage, through layers of views that can evolve independently, even dynamically at runtime.

Virtual views are always:
- **Application-first** - Named by application domain or feature, not storage technology
- **Detached from physical schemas** - Views are used for most application queries, not physical tables
- **Layered into hierarchies** - Views depend on other views, creating swappable layers
- **Independently replaceable** - Each layer can be swapped without affecting others
- **Multi-connector capable** - Each layer can use one or more (real or fake) data sources

```mermaid
flowchart TD
    App["Application<br/>(myapp)"] --> AppCatalog["Application Catalog<br/>(myapp.[feature].*)"]
    AppCatalog --> Views["Application View<br/>Hierarchy"]
    Views -.-> PG[("PostgreSQL<br/>(warm storage)")]
    Views -.-> Ice[("Iceberg<br/>(cold storage)")]
    Views -.-> Demo[("Predefined<br/>Demo Datasets")]
    Views -.-> Test[("Integration<br/>Test Datasets")]
    Views -.-> Future[("Future<br/>Connectors")]
```

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
