# Column-Family Data Model – Apache Cassandra

## Overview
The NairaBridge Digital Banking System uses Apache Cassandra as its reference implementation for a column-family (wide-column) data model.

## Business Use Case
The model is designed to support customer transaction-history retrieval, particularly where the banking application needs to retrieve a customer's transactions in chronological order.

## Schema Design
- Keyspace: `nairabridge`
- Table: `customer_transaction_history`
- Partition key: `customer_id`
- Clustering columns: `transaction_date`, `activity_id`

## Design Rationale
Cassandra stores related customer transaction records within partitions determined by the partition key. Clustering columns organise records within each partition.

This approach supports scalable transaction-history retrieval and is suitable for workloads involving large volumes of customer activity.

## Implementation Status
The Cassandra schema and example CQL queries have been designed and documented as a column-family model. They have not been executed against a live Cassandra server. The working NoSQL implementation for this portfolio is MongoDB.

## Limitations
The design is optimised for customer-based transaction retrieval. Other access patterns, such as retrieving all failed transactions across every customer, may require a separate Cassandra table designed around that query.