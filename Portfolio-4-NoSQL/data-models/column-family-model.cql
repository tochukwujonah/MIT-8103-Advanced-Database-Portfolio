
-- =====================================================
-- NAIRABRIDGE DIGITAL BANKING SYSTEM
-- PORTFOLIO 4: COLUMN-FAMILY DATA MODEL
-- DBMS: APACHE CASSANDRA
-- =====================================================

-- Create the keyspace
CREATE KEYSPACE IF NOT EXISTS nairabridge
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
};

-- Select the keyspace
USE nairabridge;

-- Customer transaction history
CREATE TABLE IF NOT EXISTS customer_transaction_history (
    customer_id TEXT,
    transaction_date TIMESTAMP,
    activity_id TEXT,
    event_type TEXT,
    amount DECIMAL,
    currency TEXT,
    status TEXT,
    channel TEXT,
    PRIMARY KEY (
        customer_id,
        transaction_date,
        activity_id
    )
)
WITH CLUSTERING ORDER BY (
    transaction_date DESC,
    activity_id ASC
);




-- Retrieve all transactions for a customer
SELECT *
FROM customer_transaction_history
WHERE customer_id = 'CUS001';

-- Retrieve transactions for a customer
-- within a date range
SELECT *
FROM customer_transaction_history
WHERE customer_id = 'CUS001'
AND transaction_date >= '2026-11-01'
AND transaction_date < '2026-12-01';

-- Retrieve a particular customer's successful transactions
-- Note: status filtering requires an appropriate
-- Cassandra index or a separately designed query table.
