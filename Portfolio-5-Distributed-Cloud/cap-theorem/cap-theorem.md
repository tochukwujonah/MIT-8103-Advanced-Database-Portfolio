# NairaBridge – CAP Theorem

The CAP theorem explains the trade-offs among three distributed database properties:

- **Consistency:** All nodes return the same latest data.
- **Availability:** Every request receives a response.
- **Partition Tolerance:** The system continues operating despite network communication failures between nodes.

## Application to NairaBridge

NairaBridge prioritises consistency for critical banking operations such as transfers, withdrawals, and account balance updates.

During a network partition, some operations may be delayed or temporarily unavailable to prevent inconsistent account balances.

For read-heavy services, controlled asynchronous replication may improve availability, with the possibility of temporarily stale data.

## Conclusion

NairaBridge should prioritise consistency for financial transactions while designing appropriate availability strategies for less critical services.