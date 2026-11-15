# NairaBridge – Distributed and Cloud Database Portfolio

## Overview
This portfolio explores distributed database concepts using the NairaBridge Digital Banking System.

## Practical Implementations
1. **Logical Replication:** PostgreSQL publisher and subscriber databases; tested INSERT, UPDATE, and DELETE replication.
2. **Sharding:** Created two logical customer shards and tested automatic shard routing.
3. **Availability:** Simulated a service outage and recovery.
4. **Disaster Recovery:** Created a PostgreSQL custom-format database backup.

## Conceptual Documentation
- Distributed database architecture
- Availability and consistency
- Disaster recovery strategy
- CAP theorem

## Tools
- PostgreSQL 18.6
- pgAdmin 4
- SQL and PL/pgSQL

## Limitations
The replication and sharding demonstrations ran on a single PostgreSQL instance. No physical multi-node deployment, cloud hosting, or automatic failover was implemented.

## Conclusion
This portfolio demonstrates practical understanding of logical replication, horizontal sharding, availability, backup and recovery, and distributed database trade-offs.