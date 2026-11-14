# NairaBridge Digital Banking System
**MIT 8103 – Advanced Database Systems**  
**Portfolio 1: Database Design and Modelling**

## 1. Project Overview

NairaBridge is a simulated Nigerian digital banking platform designed to demonstrate the use of relational database concepts in managing customer information, bank accounts, financial transactions, and audit activities.

The system uses PostgreSQL as its relational database management system and uses the Nigerian Naira (NGN) as its primary currency.

The database design focuses on data integrity, consistency, reduced redundancy, and the ability to retrieve useful banking information through SQL queries.

## 2. Database Environment

- Database Management System: PostgreSQL
- Database administration tool: pgAdmin 4
- Database name: `nairabridge_banking`
- Primary currency: NGN
- Database model: Relational

## 3. Database Tables

The database consists of six tables:

| Table | Purpose |
|---|---|
| customers | Stores customer personal and contact information |
| account_types | Stores available account categories |
| accounts | Stores customer bank accounts and balances |
| transaction_types | Defines supported transaction categories |
| transactions | Records deposits, withdrawals, and transfers |
| audit_logs | Records activities performed within the system |

## 4. Relationships

The database implements the following relationships:

- One customer can own multiple accounts.
- One account type can be assigned to multiple accounts.
- One account can participate in multiple transactions as either the source or destination account.
- One transaction type can be associated with multiple transactions.
- One customer can have multiple audit log records.

Foreign keys enforce the relationships between the tables.

## 5. Keys and Constraints

The design uses primary keys to uniquely identify records and foreign keys to maintain referential integrity.

Additional constraints include:

- UNIQUE constraints on customer email addresses, phone numbers, account numbers, and transaction references.
- CHECK constraints to validate account balances, transaction amounts, account statuses, customer statuses, and transaction statuses.
- DEFAULT values for selected fields, including timestamps, account balances, and currency.
- Transaction constraints to prevent an account from being both the source and destination of the same transaction.

## 6. Normalisation

The database was designed with the principles of Third Normal Form (3NF) in mind.

**First Normal Form (1NF):** Each table has a primary key, and attributes are stored as individual values rather than repeating groups.

**Second Normal Form (2NF):** All non-key attributes depend on their respective primary keys. The tables use single-column primary keys, eliminating partial dependencies on composite keys.

**Third Normal Form (3NF):** Lookup information such as account types and transaction types is stored separately from the main account and transaction records. This reduces duplication and avoids unnecessary dependencies between non-key attributes.

## 7. Implementation and Testing

The database was implemented in PostgreSQL and populated with fictional Nigerian customer, account, and transaction records.

The implementation was validated through:

- Successful creation of all six tables.
- Successful insertion of sample customer, account, and transaction records.
- Successful execution of a database reconciliation query.
- Seven practical SQL queries covering joins, aggregation, filtering, window functions, date functions, and correlated subqueries.

## 8. Project Scope and Limitations

NairaBridge is an academic simulation. It does not connect to actual banking infrastructure or process real customer funds.

The sample implementation demonstrates database design and querying. It does not yet represent a complete production banking application with automated transaction processing, authentication, or external payment integrations.

## 9. Conclusion

Portfolio 1 establishes the relational database foundation for NairaBridge. The resulting database provides a structured basis for the subsequent portfolio activities involving query optimisation, transaction management, NoSQL data models, and distributed database concepts.
