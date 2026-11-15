# NairaBridge Distributed Database Architecture

## 1. Introduction

The NairaBridge Digital Banking System is a simulated Nigerian banking platform designed to support customer accounts, deposits, withdrawals, fund transfers and transaction monitoring.

As the platform grows, a single database server may become a bottleneck or a single point of failure. A distributed database architecture can improve scalability, read performance, availability and disaster recovery.

## 2. Proposed Architecture

The proposed architecture uses PostgreSQL as its relational database management system.

It consists of three database locations:

| Location | Database Role | Responsibility |
|---|---|---|
| Lagos | Primary PostgreSQL server | Handles database writes and primary read operations |
| Abuja | Read replica | Supports reporting and read-heavy operations |
| Port Harcourt | Read replica | Supports regional read operations and reporting |

A separate remote backup storage location is proposed for database backups and disaster recovery.

## 3. Primary Database

The Lagos PostgreSQL server is the primary database.

It is responsible for:
- Customer account updates.
- Deposits and withdrawals.
- Fund transfers.
- Transaction recording.
- Account balance updates.
- Audit logging.

Write operations are directed to the primary database.

## 4. Read Replicas

The Abuja and Port Harcourt database servers are designed as read replicas.

Their responsibilities include:
- Customer transaction history enquiries.
- Reporting and analytics.
- Read-heavy application requests.
- Regional data access.

Replication keeps the replicas updated from the primary database. Depending on the replication mode, updates may not appear immediately.

## 5. Replication Strategy

The proposed design uses PostgreSQL streaming replication.

Asynchronous replication is the initial design choice because it allows the primary database to continue processing transactions without waiting for every replica to confirm receipt.

Replication lag must be monitored, particularly for banking operations where customers expect accurate account balances.

## 6. Backup and Disaster Recovery

Database backups are maintained separately from the primary database.

The proposed strategy includes:
- Scheduled database backups.
- Transaction log archiving.
- Point-in-time recovery.
- Recovery testing.
- Documented failover procedures.

## 7. Availability and Fault Tolerance

The architecture reduces reliance on a single database server by providing additional database copies.

If the primary server becomes unavailable, an eligible replica may be promoted through a controlled failover process.

Promotion must account for replication lag and possible data loss in an asynchronous configuration.

## 8. Scope and Implementation Status

This architecture is a proposed distributed database design for the NairaBridge Digital Banking System.

The practical PostgreSQL configuration and testing evidence will be documented separately as the implementation progresses. The three-city architecture should not be interpreted as three already operational servers.

## 9. Conclusion

The proposed distributed architecture provides a foundation for scaling NairaBridge while improving read capacity, resilience and disaster recovery readiness.