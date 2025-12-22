---

## Common Pitfalls and Solutions

1. [Type Mismatch Chaos](#pitfall-1-type-mismatch-chaos)
2. [Forgetting to Update Dependent Layers](#pitfall-2-forgetting-to-update-dependent-layers)
3. [Breaking Application Assumptions](#pitfall-3-breaking-application-assumptions)
4. [Permission Confusion](#pitfall-4-permission-confusion)
5. [Attempting to Delete Base Views](#pitfall-5-attempting-to-delete-base-views)
6. [Lost View Definitions](#pitfall-6-lost-view-definitions)
7. [Circular Dependencies](#pitfall-7-circular-dependencies)

---

### Pitfall 1: Type Mismatch Chaos

**Problem**: Replace view without explicit casts, types change, dependent queries break mysteriously. This is the most common problem when migrating view hierarchies or making them dynamically reconfigurable.

**Example**:
```sql
-- Original: Returns BIGINT implicitly from PostgreSQL
CREATE VIEW myapp.users.base AS
SELECT user_id, name, email
FROM postgresql.myapp.users;

-- Replacement: Returns INTEGER from different source (different precision)
CREATE OR REPLACE VIEW myapp.users.base AS
SELECT user_id, name, email
FROM mysql.myapp.users;

-- Dependent views expecting BIGINT start failing
SELECT u.user_id, o.order_id
FROM myapp.users.base u
JOIN myapp.orders.all o ON u.user_id = o.customer_id;  -- Type mismatch error
```

**Solution**: Always use explicit CAST in base views.
```sql
CREATE VIEW myapp.users.base AS
SELECT
  CAST(user_id AS BIGINT) as user_id,
  CAST(name AS VARCHAR) as name,
  CAST(email AS VARCHAR) as email
FROM postgresql.myapp.users;

-- Type is now locked regardless of source
CREATE OR REPLACE VIEW myapp.users.base AS
SELECT
  CAST(user_id AS BIGINT) as user_id,
  CAST(name AS VARCHAR) as name,
  CAST(email AS VARCHAR) as email
FROM mysql.myapp.users;
```

### Pitfall 2: Forgetting to Update Dependent Layers

**Problem**: Replace base view, forget middle layers exist, they break.

**Example**:
```sql
-- Base view
CREATE VIEW myapp.users.base AS
SELECT
  CAST(user_id AS BIGINT) as user_id,
  CAST(name AS VARCHAR) as name
FROM postgresql.myapp.users;

-- Middle layer
CREATE VIEW myapp.users.enriched AS
SELECT
  user_id,
  UPPER(name) as name
FROM myapp.users.base;

-- Top layer
CREATE VIEW myapp.users.all AS
SELECT * FROM myapp.users.enriched;

-- Replace base, add new column
CREATE OR REPLACE VIEW myapp.users.base AS
SELECT
  CAST(user_id AS BIGINT) as user_id,
  CAST(name AS VARCHAR) as name,
  CAST(email AS VARCHAR) as email
FROM postgresql.myapp.users;

-- Middle layer doesn't expose email!
-- Top layer consumers can't access it
```

**Solution**: Use ViewMapper to identify all dependents before making changes. Update layers bottom-up. Try migrations in a development or staging environment prior to running in production.

### Pitfall 3: Breaking Application Assumptions

**Problem**: View replacement changes behavior in ways application doesn't expect.

**Example**:
```sql
-- Original: Always returns rows in id order
CREATE VIEW myapp.events.all AS
SELECT * FROM postgresql.myapp.events
ORDER BY event_id;

-- Replacement: No ORDER BY, application breaks expecting sorted data
CREATE OR REPLACE VIEW myapp.events.all AS
SELECT * FROM iceberg.myapp.events;  -- No ORDER BY!
```

**Solution**:
- Use ViewMapper to identify dependency relationships
- Document view contracts (sort order, NULL behavior, uniqueness)
- Maintain behavior during replacements
- If changing behavior, update application code first
- Add ORDER BY in view if application depends on it (and verify performance)
- Consider sorting data in application code rather than views

### Pitfall 4: Permission Confusion

**Problem**: Users can query view but not underlying tables (or vice versa).

**Example**:
```sql
-- View created by admin with SECURITY INVOKER
CREATE VIEW myapp.users.all
SECURITY INVOKER
AS SELECT * FROM postgresql.myapp.users;

-- User has access to myapp catalog but not postgresql catalog
SELECT * FROM myapp.users.all;  -- Fails with permission error
```

**Solution**:
- Use `SECURITY INVOKER` and grant underlying permissions
- Or use `SECURITY DEFINER` intentionally for controlled privilege escalation
- Document permission requirements clearly in view comments

```sql
COMMENT ON VIEW myapp.users.all IS
'Requires SELECT permission on postgresql.myapp.users table';
```

### Pitfall 5: Attempting to Delete Base Views

**Problem**: Attempting to drop a base view before its dependents.

**Example**:
```sql
-- Create small hierarchy
CREATE VIEW myapp.events.filtered AS SELECT * FROM ...;
CREATE VIEW myapp.events.all AS SELECT * FROM myapp.events.filtered;

-- Try to drop referenced view
DROP VIEW myapp.events.filtered;
-- Error: Cannot drop view 'filtered': depended upon by view 'all'
```

**Solution**: Use ViewMapper to identify all dependents before dropping views.

### Pitfall 6: Lost View Definitions

**Problem**: Views stored in connector that gets decommissioned or isn't working properly at runtime.

**Example**:
```sql
-- Views stored in test PostgreSQL instance
CREATE VIEW test.myapp.users_all AS
SELECT * FROM postgresql.myapp.users;

-- Test instance deleted, all view definitions lost
```

**Solution**:
- Follow Principle 7: choose canonical storage carefully
- Store views in a system that is regularly backed up
- Alternatively export view definitions to version control
- Use `SHOW CREATE VIEW` to inspect definitions

### Pitfall 7: Circular Dependencies

**Problem**: View A → View B → View A

**Trino prevents this**:
```sql
CREATE VIEW a AS SELECT * FROM b;
CREATE VIEW b AS SELECT * FROM a;
-- Error: Circular dependency detected: a -> b -> a
```
