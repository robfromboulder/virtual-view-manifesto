# The Virtual View Manifesto
**Stop treating SQL views like decoration. Start using them as your application's data contract.**

Classical SQL views are boring schema decoration for hiding joins, adding computed columns, and redacting sensitive data. Virtual views are different. They're architectural components that decouple applications from physical storage, enable prototyping and testing with static data, allow seamless migration to Iceberg, and support zero-downtime schema evolution.

While most SQL databases support the implementation of virtual views, Trino's federation capabilities make this pattern particularly powerful. Views in Trino can span multiple connectors, reference any catalog, and unify data through a consistent SQL dialect, without the need for external ETL. Trino is used as the reference platform for all examples here.

If you aren't a Trino user, that's ok! The pattern of virtual views can be applied to Starburst Enterprise or Galaxy, Amazon Athena, Presto, or (with some caveats) to any database that supports SQL views.

This manifesto isn't just theory, it provides practical strategies and examples to follow when introducing virtual views into your architecture, and recommends additional free tools you may find helpful.  
