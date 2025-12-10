# The Virtual View Manifesto
**Stop treating Trino views like decoration. Start using them as your application's data contract.**

Classical SQL views are boring schema decoration for hiding joins, adding computed columns, and redacting sensitive data. Virtual views are different. They're architectural components that decouple applications from physical storage, enable prototyping and testing with static data, allow seamless migration to Iceberg, and support zero-downtime schema evolution.

While most SQL databases support views, Trino's federation capabilities make this pattern particularly powerful. Views can span multiple connectors, reference any catalog, and unify data through a consistent SQL dialect. (and without external ETL)

This manifesto isn't just theory, it provides practical examples and strategies to follow when introducing virtual views into your architecture, and recommendations for additional (free) tools you may find helpful.  
