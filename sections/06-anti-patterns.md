---

## When NOT to Use Virtual Views

The previous section covered mistakes to avoid when using virtual views. This section is different. It identifies scenarios where the virtual view pattern itself may not be the right architectural choice.

These aren't failures of implementation, they're legitimate decisions to skip the abstraction entirely. Virtual views solve specific problems, and when those problems don't exist, the overhead isn't justified. Recognizing these boundaries separates pragmatic thinking from cargo-cult architecture.

Virtual views are typically contraindicated for:
1. [Single-Layer Hierarchies](#anti-pattern-1-single-layer-hierarchies)
2. [Performance-Critical Hot Paths](#anti-pattern-2-performance-critical-hot-paths)
3. [Ad-Hoc Analytics and Exploration](#anti-pattern-3-ad-hoc-analytics-and-exploration)

---

### Anti-Pattern 1: Single-Layer Hierarchies

**Symptom**: View has no dependents, will never have multiple versions, exists in isolation. No filtering, no computed columns, view created "just because."

**Problem**: You don't have a hierarchy, just a view. The overhead may not be worth it.

**Example**:
```sql
-- This isn't a hierarchy, just one view
-- No layers, no swappability, no real abstraction
-- Just an extra indirection
CREATE VIEW myapp.config.config SECURITY INVOKER AS
SELECT key, value FROM postgresql.myapp.config;
```

**When it becomes worthwhile**:
- When adding more layers
- When adding filtered or computed columns
- When planning to swap implementations (prototype → prod)

**Rule**: A single view is meh. A hierarchy with swappable layers is powerful. One view pretending to be a hierarchy may be overhead without benefit, unless you're confident that layers will be added in the future.

---

### Anti-Pattern 2: Performance-Critical Hot Paths

**Symptom**: Microsecond latency requirements, extremely high query volume, proven bottleneck.

**Problem**: Views add query planning overhead (usually negligible, but matters at extremes) and may not allow the level of control needed for advanced queries.

**When direct access is justified**:
- High-frequency trading systems (submillisecond latency)
- Real-time bidding platforms (thousands of queries per second)
- You've profiled and proven views are the bottleneck (not the database, not the network)

**Example**:
```python
# Ultra-low-latency requirement
@endpoint("/bid")
def process_bid(request):
    # Direct access acceptable - every microsecond counts
    # This query runs 10,000+ times per second
    result = query(
        "SELECT price, quantity FROM postgresql.market.bids "
        "WHERE symbol = ? ORDER BY price LIMIT 1",
        symbol
    )
    return compute_bid(result)

# vs. normal application endpoint
@endpoint("/orders")
def get_orders(user_id):
    # Virtual view preferred - flexibility over microseconds
    # This query runs 100 times per second
    result = query(
        "SELECT * FROM myapp.orders.all WHERE user_id = ?",
        user_id
    )
    return result
```

**Rule of thumb**: If you can't measure the view overhead in your application profile (< 1% of query time), it doesn't matter. Use virtual views for flexibility.

**When overhead actually matters**:
- Queries must complete in < 10ms end-to-end
- Query volume > 10,000 QPS per Trino node
- You've measured (not assumed) that views are the bottleneck

**The pragmatic approach**:
1. Default to virtual views for flexibility
2. Profile your application under realistic load
3. Optimize to direct access only when measurements prove it's necessary
4. Document why direct access was chosen

---

### Anti-Pattern 3: Ad-Hoc Analytics and Exploration

**Symptom**: Data scientists need to explore data, build one-off reports, and run administrative queries, outside the established structure of application and feature hierarchies.

**Problem**: Virtual views add indirection that confuses exploratory analysis. Fixed structure limits flexibility.

**Better approach**: Allow direct schema access for power users.

**Example**:
```sql
-- Data scientist exploring patterns
-- Better to query physical tables directly for flexibility
SELECT 
  event_type,
  COUNT(*) as event_count,
  percentile_cont(0.95) WITHIN GROUP (ORDER BY duration) as p95_duration,
  AVG(duration) as avg_duration
FROM postgresql.raw.events
WHERE event_time > CURRENT_DATE - INTERVAL '7' DAYS
  AND user_agent LIKE '%Chrome%'  -- Exploring browser-specific patterns
  AND duration > 0
GROUP BY event_type
HAVING COUNT(*) > 100
ORDER BY event_count DESC;

-- Virtual view would constrain exploration unnecessarily
-- Data scientist doesn't know what columns they need yet
```

**When to use virtual views for analytics**:
- Shared dashboards with stable queries
- Recurring reports run on schedule
- Production data products consumed by applications
- When consistent interface is valuable

**When to allow direct access**:
- Exploratory data analysis
- One-off ad-hoc queries
- Data quality investigations
- Schema discovery and profiling
