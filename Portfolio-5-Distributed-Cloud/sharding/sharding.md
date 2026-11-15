# NairaBridge – Sharding

## Sharding Strategy
NairaBridge uses simulated horizontal sharding to distribute customer records across two logical shards.

## Shard Allocation
- Shard 1: Odd customer ID numbers.
- Shard 2: Even customer ID numbers.

## Implementation
Two PostgreSQL tables were created:
- `customers_shard_1`
- `customers_shard_2`

A PL/pgSQL function, `route_customer`, automatically directs new customer records to the appropriate shard.

## Testing
- Inserted six sample customers across both shards.
- Retrieved records across both shards using `UNION ALL`.
- Tested automatic routing with customer `CUS007`.
- Confirmed successful insertion into Shard 1.

## Limitation
This is a logical sharding simulation on one PostgreSQL instance, not a physically distributed deployment. A production implementation would distribute shards across separate database servers and provide routing, monitoring, and failover mechanisms.