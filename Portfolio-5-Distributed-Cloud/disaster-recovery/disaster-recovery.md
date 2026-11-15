# NairaBridge – Disaster Recovery

## Backup Strategy
The PostgreSQL publisher database was backed up using pgAdmin in Custom format.

## Recovery Strategy
The backup can be restored using pgAdmin or PostgreSQL's `pg_restore` utility.

## Recovery Objectives
- **RPO:** Maximum acceptable data loss measured in time.
- **RTO:** Maximum acceptable time to restore services.

## Additional Protection
A production deployment would use scheduled backups, WAL archiving, point-in-time recovery (PITR), off-site backup storage, and periodic restore testing.

## Practical Evidence
A backup of `nairabridge_publisher` was successfully created.

## Limitation
The backup was created locally. Off-site backup storage and a full disaster recovery exercise were not implemented.