# NairaBridge – Availability and Consistency

## Availability
NairaBridge aims to keep banking services accessible through monitoring, backup systems, and recovery procedures.

## Practical Simulation
A PostgreSQL `availability_test` table was created with three services:
- Account Services
- Transfers
- Transaction History

The Transfers service was temporarily marked unavailable and subsequently restored.

## Consistency
Database consistency is supported through constraints, transactions, and controlled updates. Logical replication was also tested between the publisher and subscriber databases.

## Limitations
The availability test was a database status simulation, not a real production outage or automatic failover. The replication demonstration ran on one PostgreSQL instance, not separate physical servers.