-- =====================================================
-- NAIRABRIDGE DIGITAL BANKING SYSTEM
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: QUERY PROCESSING AND OPTIMISATION
-- Database: nairabridge_banking
-- DBMS: PostgreSQL
-- =====================================================



-- =====================================================
-- STEP 2: BASELINE QUERY PERFORMANCE
-- TEST 1: CUSTOMER TRANSACTION HISTORY
-- =====================================================

EXPLAIN ANALYZE
SELECT
    t.transaction_id,
    t.reference,
    tt.type_name AS transaction_type,
    t.amount,
    t.transaction_date,
    t.status,
    t.narration
FROM transactions t
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE t.status = 'completed'
ORDER BY t.transaction_date DESC;





-- =====================================================
-- STEP 3: INDEXING EXPERIMENT
-- INDEX ON TRANSACTION STATUS AND DATE
-- =====================================================

CREATE INDEX idx_transactions_status_date
ON transactions (status, transaction_date DESC);

ANALYZE transactions;


-- =====================================================
-- STEP 4.1: CREATE PERFORMANCE TEST TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS transaction_performance_test (
    benchmark_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference VARCHAR(40) NOT NULL,
    status VARCHAR(20) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount NUMERIC(18,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL
);

-- Clear previous benchmark records if rerunning
TRUNCATE TABLE transaction_performance_test
RESTART IDENTITY;

-- =====================================================
-- STEP 4.2: INSERT 20,000 SIMULATED TRANSACTIONS
-- =====================================================

INSERT INTO transaction_performance_test (
    reference,
    status,
    transaction_type,
    amount,
    transaction_date
)
SELECT
    'NB-BENCH-' || LPAD(series_number::TEXT, 6, '0'),

    CASE
        WHEN series_number % 10 = 0 THEN 'failed'
        WHEN series_number % 5 = 0 THEN 'pending'
        ELSE 'completed'
    END,

    CASE
        WHEN series_number % 3 = 0 THEN 'Deposit'
        WHEN series_number % 3 = 1 THEN 'Withdrawal'
        ELSE 'Transfer'
    END,

    1000 + (series_number % 500000)::NUMERIC / 100,

    TIMESTAMP '2025-01-01 00:00:00'
        + (series_number % 600) * INTERVAL '1 day'
        + (series_number % 86400) * INTERVAL '1 second'

FROM GENERATE_SERIES(1, 20000) AS series_number;

-- Refresh table statistics
ANALYZE transaction_performance_test;



-- =====================================================
-- STEP 5: BASELINE PERFORMANCE WITHOUT INDEX
-- =====================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    benchmark_id,
    reference,
    status,
    transaction_type,
    amount,
    transaction_date
FROM transaction_performance_test
WHERE status = 'completed'
ORDER BY transaction_date DESC;



-- =====================================================
-- STEP 6: SELECTIVE QUERY BASELINE
-- FAILED TRANSACTIONS
-- =====================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    benchmark_id,
    reference,
    status,
    transaction_type,
    amount,
    transaction_date
FROM transaction_performance_test
WHERE status = 'failed'
ORDER BY transaction_date DESC;


-- =====================================================
-- STEP 7: CREATE COVERING COMPOSITE INDEX
-- =====================================================

CREATE INDEX idx_benchmark_status_date_covering
ON transaction_performance_test (status, transaction_date DESC)
INCLUDE (benchmark_id, reference, transaction_type, amount);

ANALYZE transaction_performance_test;

VACUUM (ANALYZE) transaction_performance_test;