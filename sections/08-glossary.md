---

## Glossary

**Virtual View**: A view organized by application or feature rather than physical schema, designed to be swappable between different implementations while maintaining a consistent interface.

**View Hierarchy**: A directed acyclic graph (DAG) of views depending on other views, creating layers of abstraction. Each layer serves a specific purpose and can be replaced independently.

**Layer**: A level in a view hierarchy with single responsibility (e.g., entry point, filtering, merging, normalization). Layers are owned by single actors and replaced independently.

**Application Catalog**: A Trino catalog containing views organized around application or feature needs rather than physical storage structure. Named by domain (e.g., `myapp`, `analytics`, `ecommerce`).

**Physical Schema**: The actual table structure in databases like PostgreSQL, MySQL, Iceberg, etc. Virtual views abstract over these to hide physical details from applications.

**Canonical Connector**: The authoritative storage location for virtual view definitions. Could be Iceberg, ViewZoo, or any stable connector chosen during project setup.

**Invoker Permissions** (`SECURITY INVOKER`): View security mode where queries execute with permissions of the querying user, not the view creator. Follows principle of least privilege.

**Definer Permissions** (`SECURITY DEFINER`): View security mode where queries execute with permissions of the view creator. Can be privilege escalation vector if misused.

**Static View**: A view returning hardcoded data using `VALUES` clause, useful for prototyping before infrastructure exists or for testing edge cases.

**Hybrid View**: A view merging multiple physical sources, typically combining old and new storage with `UNION ALL` during migrations.

**DAG (Directed Acyclic Graph)**: Graph structure where edges have direction and no cycles exist. View hierarchies must be DAGs to prevent infinite loops.
