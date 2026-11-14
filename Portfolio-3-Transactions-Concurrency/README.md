# Portfolio 3 – Transactions and Concurrency Management

**Project:** NairaBridge Digital Banking System  
**Course:** MIT 8103 – Advanced Database Systems  
**Portfolio:** 3 – Transactions and Concurrency Management  
**Database:** PostgreSQL  
**Database Management Tool:** pgAdmin 4  
**Repository:** [MIT-8103-Advanced-Database-Portfolio](https://github.com/tochukwujonah/MIT-8103-Advanced-Database-Portfolio)

---

## 1. Introduction

This portfolio explores transaction management, concurrency control, and database consistency using PostgreSQL.

The practical exercises were conducted using the NairaBridge Digital Banking System, a fictional Nigerian banking database developed for this academic project.

The objective was to understand how database transactions maintain data integrity, how PostgreSQL handles simultaneous database operations, and how transaction isolation levels help prevent inconsistent results.

A separate testing table was created to conduct the experiments without modifying the original banking customer and transaction records.

## 2. Objectives

The key objectives were to:

1. Demonstrate the ACID properties of database transactions.
2. Understand the differences between COMMIT and ROLLBACK.
3. Examine how PostgreSQL handles transaction failures.
4. Explore transaction isolation levels.
5. Demonstrate row-level locking.
6. Identify and examine deadlocks.
7. Understand how consistent lock ordering can reduce deadlock risks.
8. Implement a controlled banking transfer function.
9. Demonstrate atomicity when a transfer fails.
10. Examine Serializable isolation using concurrent transactions.

## 3. Environment and Tools

| Component | Technology |
|---|---|
| Database system | PostgreSQL |
| Database interface | pgAdmin 4 |
| Database | nairabridge_banking |
| Programming language | SQL / PL/pgSQL |
| Version control | Git and GitHub |
| Operating environment | Windows |

## 4. Test Environment and Database Structure

To avoid changing the original NairaBridge banking records, an isolated table named `transaction_lab_accounts` was created.

The table contains two fictional test accounts.

| Account ID | Account Name | Initial Balance |
|---|---|---:|
| 1 | NairaBridge Test Account A | ₦100,000.00 |
| 2 | NairaBridge Test Account B | ₦50,000.00 |
| | **Total** | **₦150,000.00** |

The table includes:
- `account_id`: Primary key identifying each account.
- `account_name`: Name of the test account.
- `balance`: Account balance with a CHECK constraint preventing negative balances.

A separate `on_call_doctors` table was also created to demonstrate Serializable transaction isolation.

## 5. Transaction Management and ACID Properties

The experiments examined the four ACID properties.

### 5.1 Atomicity

Atomicity ensures that a transaction is treated as a single logical unit. Either all its operations succeed, or none of them are committed.

A transfer of ₦20,000 was tested between Account A and Account B.

The transaction was initially rolled back, and the original balances were restored.

A subsequent transfer was committed successfully.

A controlled transfer function was also developed to debit the source account and credit the destination account within the same transaction.

An insufficient-funds scenario was tested by attempting to transfer ₦100,000 from an account holding ₦40,000. PostgreSQL rejected the operation, and the account balances remained unchanged.

### 5.2 Consistency

Consistency ensures that database constraints and business rules remain valid before and after transactions.

A CHECK constraint was implemented to prevent account balances from becoming negative.

An attempted update that would have resulted in a negative balance was rejected by PostgreSQL.

The transaction was rolled back, preserving the last committed account balances.

A balance reconciliation check was also performed to verify that successful transfers preserved the combined balance of the two test accounts.

### 5.3 Isolation

Isolation ensures that concurrent transactions do not improperly interfere with one another.

The following isolation levels were examined:

**Read Committed**

Two separate pgAdmin sessions were used. Session 1 modified Account A without committing immediately.

Session 2 continued to see the previously committed balance. After Session 1 committed, Session 2 could see the updated balance on its next query.

**Repeatable Read**

Session 2 established a transaction snapshot and read Account A's balance.

Session 1 subsequently changed the account balance and committed. Session 2 continued to see its original value within the same transaction.

This demonstrated snapshot consistency.

**Serializable**

Two concurrent transactions were executed using a separate `on_call_doctors` table.

Both transactions initially observed two employees on call. Each transaction attempted to take a different employee off duty.

The final observed table contained:

| Doctor | On Call |
|---|---|
| Doctor A | FALSE |
| Doctor B | TRUE |

The final state preserved the business rule that at least one doctor must remain on call.

### 5.4 Durability

Durability was demonstrated through successful COMMIT operations.

After a transfer was committed, subsequent queries returned the updated account balances rather than the original values.

## 6. Concurrency Control Experiments

### 6.1 Row-Level Locking

The `SELECT ... FOR UPDATE` statement was used to lock an account row.

Session 1 acquired a lock on Account A.

Session 2 attempted to update the same account and had to wait until Session 1 committed.

After the lock was released, Session 2's update proceeded.

This demonstrated PostgreSQL's row-level locking mechanism.

### 6.2 Deadlock Detection

A deadlock was deliberately demonstrated using two database sessions.

- Session 1 acquired a lock on Account A.
- Session 2 acquired a lock on Account B.
- Session 1 then attempted to access Account B.
- Session 2 attempted to access Account A.

This created a circular waiting condition.

PostgreSQL detected the deadlock and returned:

`SQLSTATE 40P01 – deadlock_detected`

The affected sessions were rolled back to restore a clean transaction state.

### 6.3 Consistent Lock Ordering

Consistent lock ordering was examined as a technique for reducing deadlocks.

The approach involved accessing account rows in a consistent order based on their account IDs.

This helps reduce circular waiting conditions when multiple transactions need to lock the same set of records.

## 7. Banking Transfer Function

A PostgreSQL PL/pgSQL function named `transfer_lab_funds` was developed.

The function implements the following controls:

- Rejects null or non-positive transfer amounts.
- Prevents transfers between the same account.
- Locks the source and destination accounts.
- Checks that both accounts exist.
- Checks that the source account has sufficient funds.
- Debits the source account.
- Credits the destination account.

The function was tested using successful and unsuccessful transfer scenarios.

**Successful transfer:** The function processed a transfer of ₦10,000 from Account A to Account B.

**Failed transfer:** An attempted transfer exceeding the source account's available balance was rejected.

These tests demonstrated how database-side validation and transaction management can protect financial data.

## 8. Results and Observations

The experiments produced the following findings:

| Experiment | Observation |
|---|---|
| ROLLBACK | Uncommitted changes were discarded. |
| COMMIT | Changes were permanently committed. |
| Constraint failure | Negative account balances were rejected. |
| ACID consistency | Successful transfer preserved the combined balance. |
| Read Committed | Subsequent reads reflected newly committed changes. |
| Repeatable Read | The transaction retained its original snapshot. |
| Row-level locking | Conflicting updates waited for the existing lock to be released. |
| Deadlock detection | PostgreSQL detected a circular lock dependency and returned SQLSTATE 40P01. |
| Consistent lock ordering | Ordered account locking was examined as a deadlock prevention technique. |
| Successful transfer | The transfer function updated both accounts. |
| Failed transfer | Insufficient funds caused the transfer to fail without changing balances. |
| Serializable isolation | The final observed state retained one employee on call. |

### Final Banking Test Account Balances

After the successful transfer and failed-transfer atomicity test, the final observed balances were:

| Account | Balance |
|---|---:|
| NairaBridge Test Account A | ₦40,000.00 |
| NairaBridge Test Account B | ₦90,000.00 |
| **Combined Balance** | **₦130,000.00** |

The failed transfer did not alter these balances.

## 9. Screenshots and Evidence

Screenshots documenting the practical exercises are stored in the `screenshots/` directory.

Recommended evidence files:

All attached in the screenshots folder

These screenshots provide practical evidence of the SQL operations, transaction outcomes, concurrency behaviour, and final database states.

## 10. Limitations

The experiments were conducted in an isolated academic testing environment.

The transfer function demonstrates basic transaction controls but is not a complete production banking transfer system.

A production implementation would require additional considerations, including:

- Double-entry accounting and ledger records.
- Unique transaction references and idempotency.
- Audit logging and transaction traceability.
- Appropriate permissions and access controls.
- Error handling and transaction monitoring.
- Recovery, backup, and disaster-recovery procedures.
- Further testing under realistic concurrent workloads.

## 11. Conclusion

This portfolio provided practical experience with PostgreSQL transaction management and concurrency control.

The exercises demonstrated how COMMIT and ROLLBACK manage transaction outcomes, how constraints protect database consistency, and how isolation levels influence concurrent transactions.

The row-locking and deadlock experiments highlighted the importance of managing concurrent access to shared records. The banking transfer function further demonstrated how database-side validation can protect financial operations.

Overall, the project strengthened my understanding of ACID properties, transaction isolation, concurrency management, and the role of database integrity controls in financial information systems.

## 12. Reflection

One of the most important lessons from this portfolio was that a database operation can be individually valid but still create an inconsistent outcome when multiple transactions execute concurrently.

The deadlock experiment demonstrated how competing transactions can block one another, while the isolation-level exercises showed how PostgreSQL manages concurrent reads and writes.

I also learned the importance of testing failed transactions, not just successful ones. In a financial application, preventing incorrect or incomplete transfers is as important as successfully processing valid transactions.

The practical exercises provided a stronger foundation for designing reliable database operations in financial systems.

## 13. References

1. PostgreSQL Global Development Group. *PostgreSQL Documentation – Transaction Management*. https://www.postgresql.org/docs/current/tutorial-transactions.html
2. PostgreSQL Global Development Group. *PostgreSQL Documentation – Transaction Isolation*. https://www.postgresql.org/docs/current/transaction-iso.html
3. PostgreSQL Global Development Group. *PostgreSQL Documentation – Explicit Locking*. https://www.postgresql.org/docs/current/explicit-locking.html
4. PostgreSQL Global Development Group. *PostgreSQL Documentation – PL/pgSQL*. https://www.postgresql.org/docs/current/plpgsql.html

## 14. AI Assistance Declaration

Generative AI was used as a supplementary learning and development aid during this portfolio. It assisted with SQL explanations, experiment planning, troubleshooting, and documentation preparation.

The database implementation, execution of SQL statements, practical testing, and review of results were carried out in the PostgreSQL environment.

The submitted work is based on the practical experiments performed and the results observed.

---

**Project:** NairaBridge Digital Banking System  
**Portfolio 3:** Transactions and Concurrency Management  
**Course:** MIT 8103 – Advanced Database Systems