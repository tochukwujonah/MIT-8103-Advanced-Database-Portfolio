# Portfolio 4 – NoSQL and Advanced Data Models

## NairaBridge Digital Banking System

**Course:** MIT 8103 – Advanced Database Systems  
**Portfolio:** 4 – NoSQL and Advanced Data Models  
**Primary NoSQL Database:** MongoDB  
**Additional Data Model Reference:** Apache Cassandra

---

## 1. Introduction

This portfolio explores NoSQL database technologies and alternative data models using the NairaBridge Digital Banking System, a simulated Nigerian digital banking platform.

The exercise demonstrates four data-model concepts:

1. Document-oriented model
2. Key-value model
3. Graph model
4. Column-family model

MongoDB was used for the practical document, key-value access-pattern and graph-style implementations. Apache Cassandra was used as the reference technology for the column-family schema design.

## 2. Technologies Used

| Technology | Purpose |
|---|---|
| MongoDB | NoSQL database implementation |
| MongoDB Compass | Database administration and visual interface |
| MongoDB Shell (MONGOSH) | Database commands, queries and aggregations |
| Apache Cassandra CQL | Column-family schema design |
| Markdown | Technical documentation |

## 3. Document Data Model

**Database:** `nairabridge_nosql`  
**Collection:** `transaction_activity`

Ten sample banking activity documents were inserted.

The documents contain customer identifiers, account numbers, event types, transaction amounts, currencies, statuses, timestamps and embedded metadata.

The following operations were completed:

- Document insertion and retrieval.
- Filtering by transaction status.
- Filtering by customer ID.
- Filtering by transaction amount.
- Querying embedded metadata.
- Aggregation by transaction status.
- Aggregation by event type.
- Overall transaction statistics.

### Aggregation Results

| Status | Activities | Total Amount |
|---|---:|---:|
| Successful | 7 | ₦960,000 |
| Pending | 1 | ₦75,000 |
| Failed | 1 | ₦120,000 |
| Reversed | 1 | ₦45,000 |

Overall activity statistics:

- Total documents: 10
- Total activity amount: ₦1,200,000
- Average activity amount: ₦120,000
- Maximum activity amount: ₦500,000
- Minimum activity amount: ₦0

## 4. Key-Value Data Model

**Database:** `nairabridge_nosql`  
**Collection:** `system_config`

Five application configuration records were created.

The records cover:

- Application name.
- Default currency.
- Maximum transfer limit.
- Maintenance mode.
- Support email.

Queries were used to retrieve an individual configuration value by key and filter configuration records by category.

This demonstrates a key-value access pattern using MongoDB documents. It is not a separate Redis deployment.

## 5. Graph Data Model

**Database:** `nairabridge_nosql`

Two collections were used:

- `graph_nodes`
- `graph_relationships`

The graph-style model contains customer and account nodes, together with relationships representing ownership and transfer activities.

Relationship types include:

- `OWNS`
- `TRANSFERRED_TO`
- `ATTEMPTED_TRANSFER_TO`

MongoDB aggregation with `$lookup` was used to resolve sender and beneficiary information.

This implementation demonstrates graph-style modelling in MongoDB rather than a native graph database deployment such as Neo4j.

## 6. Column-Family Data Model

**Reference DBMS:** Apache Cassandra

A Cassandra schema was designed for customer transaction-history retrieval.

The design includes:

- Keyspace: `nairabridge`
- Table: `customer_transaction_history`
- Partition key: `customer_id`
- Clustering columns: `transaction_date` and `activity_id`

The schema is designed to organise each customer's transaction history and support chronological retrieval.

**Implementation status:** The CQL schema and example queries were prepared and documented but were not executed against a live Cassandra server.

## 7. Comparison of the Four Data Models

| Data Model | Technology / Implementation | NairaBridge Use Case |
|---|---|---|
| Document | MongoDB | Banking activity records |
| Key-value | MongoDB key-value access pattern | Application configuration |
| Graph | MongoDB graph-style collections | Customer and account relationships |
| Column-family | Apache Cassandra schema design | Customer transaction history |

## 8. Conclusion

This portfolio demonstrates how different NoSQL data models can support different requirements within a digital banking system.

MongoDB provides flexible document storage and aggregation capabilities for banking activity records. The key-value access pattern demonstrates a simple approach to application configuration, while graph-style collections represent relationships between customers and accounts.

The Cassandra schema design illustrates how a wide-column database can organise high-volume customer transaction histories around specific access patterns.

The exercise highlights the importance of selecting a database model based on application requirements, data structure, scalability and query patterns.

## 9. Evidence and Screenshots

The `screenshots` directory contains evidence of the practical implementation, including MongoDB connection, document insertion, query results, aggregation results, configuration records and graph operations.

## 10. AI Assistance Declaration

AI assistance was used as a learning and development aid to explain database concepts, guide implementation, troubleshoot queries and support technical documentation.

The database commands and outputs were reviewed during the practical exercise. The student remains responsible for understanding, verifying and explaining the submitted work.