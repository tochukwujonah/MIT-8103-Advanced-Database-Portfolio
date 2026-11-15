-- =====================================================
-- NAIRABRIDGE DIGITAL BANKING SYSTEM
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 3: TRANSACTIONS AND CONCURRENCY
-- Database: nairabridge_banking
-- DBMS: PostgreSQL
-- =====================================================

-- Topics:
-- 1. Transaction Management
-- 2. ACID Properties
-- 3. COMMIT and ROLLBACK
-- 4. Concurrent Transactions
-- 5. Transaction Isolation
-- 6. Locking and Concurrency Control
-- =====================================================



-- =====================================================
-- PORTFOLIO 3: TRANSACTION TEST ENVIRONMENT
-- =====================================================

CREATE TABLE IF NOT EXISTS transaction_lab_accounts (
    account_id INTEGER PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL,
    balance NUMERIC(18,2) NOT NULL
        CHECK (balance >= 0)
);

INSERT INTO transaction_lab_accounts
    (account_id, account_name, balance)
VALUES
    (1, 'NairaBridge Test Account A', 100000.00),
    (2, 'NairaBridge Test Account B', 50000.00)
ON CONFLICT (account_id) DO NOTHING;

-- Verify the test accounts
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;


-- =====================================================
-- PORTFOLIO 3: ROLLBACK DEMONSTRATION
-- =====================================================

BEGIN;

-- Debit Account A
UPDATE transaction_lab_accounts
SET balance = balance - 20000
WHERE account_id = 1;

-- Credit Account B
UPDATE transaction_lab_accounts
SET balance = balance + 20000
WHERE account_id = 2;

-- Inspect the temporary transaction results
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;

-- Undo both updates
ROLLBACK;

-- Verify the original balances are restored
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;



-- =====================================================
-- PORTFOLIO 3: COMMIT DEMONSTRATION
-- =====================================================

BEGIN;

-- Debit Account A
UPDATE transaction_lab_accounts
SET balance = balance - 20000
WHERE account_id = 1;

-- Credit Account B
UPDATE transaction_lab_accounts
SET balance = balance + 20000
WHERE account_id = 2;

-- Verify balances before committing
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;

-- Permanently save both updates
COMMIT;

-- Verify committed balances
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;



-- =====================================================
-- PORTFOLIO 3: TRANSACTION FAILURE DEMONSTRATION
-- =====================================================

BEGIN;

-- This update is valid
UPDATE transaction_lab_accounts
SET balance = balance - 10000
WHERE account_id = 1;

-- This update deliberately violates the CHECK constraint
UPDATE transaction_lab_accounts
SET balance = -5000
WHERE account_id = 2;

-- This statement will not execute successfully
SELECT *
FROM transaction_lab_accounts;

-- Recover the transaction
ROLLBACK;

-- Verify that original committed balances remain
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;


-- =====================================================
-- PORTFOLIO 3: ACID CONSISTENCY TEST
-- =====================================================

BEGIN;

UPDATE transaction_lab_accounts
SET balance = balance - 10000
WHERE account_id = 1
  AND balance >= 10000;

DO $$
BEGIN
    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Debit failed: insufficient funds or account missing';
    END IF;
END;
$$;

UPDATE transaction_lab_accounts
SET balance = balance + 10000
WHERE account_id = 2;

DO $$
BEGIN
    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Credit failed: destination account missing';
    END IF;
END;
$$;

SELECT SUM(balance) AS total_balance
FROM transaction_lab_accounts;

COMMIT;

SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;



-- =====================================================
-- PORTFOLIO 3: SAFE BANKING TRANSFER FUNCTION
-- =====================================================

CREATE OR REPLACE FUNCTION transfer_lab_funds(
    p_from_account INTEGER,
    p_to_account INTEGER,
    p_amount NUMERIC(18,2)
)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_account_id INTEGER;
    v_from_balance NUMERIC(18,2);
BEGIN

    -- Validate transfer details
    IF p_from_account IS NULL OR p_to_account IS NULL THEN
        RAISE EXCEPTION 'Account IDs cannot be NULL';
    END IF;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Transfer amount must be greater than zero';
    END IF;

    IF p_from_account = p_to_account THEN
        RAISE EXCEPTION 'Source and destination accounts must differ';
    END IF;

    -- Lock both accounts in ascending ID order
    FOR v_account_id IN
        SELECT account_id
        FROM transaction_lab_accounts
        WHERE account_id IN (p_from_account, p_to_account)
        ORDER BY account_id
    LOOP

        PERFORM 1
        FROM transaction_lab_accounts
        WHERE account_id = v_account_id
        FOR UPDATE;

    END LOOP;

    -- Confirm that both accounts exist
    IF (
        SELECT COUNT(*)
        FROM transaction_lab_accounts
        WHERE account_id IN (p_from_account, p_to_account)
    ) <> 2 THEN
        RAISE EXCEPTION 'One or both accounts do not exist';
    END IF;

    -- Check source account balance
    SELECT balance
    INTO v_from_balance
    FROM transaction_lab_accounts
    WHERE account_id = p_from_account;

    IF v_from_balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;

    -- Debit source account
    UPDATE transaction_lab_accounts
    SET balance = balance - p_amount
    WHERE account_id = p_from_account;

    -- Credit destination account
    UPDATE transaction_lab_accounts
    SET balance = balance + p_amount
    WHERE account_id = p_to_account;

    RETURN 'Transfer completed successfully';

END;
$$;


-- =====================================================
-- PORTFOLIO 3: READ COMMITTED ISOLATION
-- SESSION 1
-- =====================================================

BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Update Account A without committing
UPDATE transaction_lab_accounts
SET balance = 60000
WHERE account_id = 1;

-- Session 1 sees its own uncommitted update
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1;

-- Keep transaction open until Session 2 performs its first read

COMMIT;


-- =====================================================
-- PORTFOLIO 3: READ COMMITTED ISOLATION
-- SESSION 2
-- =====================================================

BEGIN;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Should see the previously committed balance
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1;

-- Run this again after Session 1 commits
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1;

COMMIT;


-- =====================================================
-- PORTFOLIO 3: REPEATABLE READ ISOLATION
-- SESSION 2
-- =====================================================

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Establish the transaction snapshot
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1;

-- Keep the transaction open


-- =====================================================
-- PORTFOLIO 3: REPEATABLE READ ISOLATION
-- SESSION 1
-- =====================================================

BEGIN;

UPDATE transaction_lab_accounts
SET balance = 55000
WHERE account_id = 1;

COMMIT;

-- Repeat the read within the original transaction
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1;

COMMIT;

-- =====================================================
-- PORTFOLIO 3: ROW-LEVEL LOCKING
-- SESSION 1
-- =====================================================

BEGIN;

SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1
FOR UPDATE;

-- Keep transaction open while Session 2 attempts its update

COMMIT;


-- =====================================================
-- PORTFOLIO 3: ROW-LEVEL LOCKING
-- SESSION 2
-- =====================================================

BEGIN;

UPDATE transaction_lab_accounts
SET balance = balance - 5000
WHERE account_id = 1;

COMMIT;


-- =====================================================
-- PORTFOLIO 3: DEADLOCK DEMONSTRATION
-- SESSION 1
-- =====================================================

BEGIN;

SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1
FOR UPDATE;

-- After Session 2 locks Account B, run:
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 2
FOR UPDATE;



-- =====================================================
-- PORTFOLIO 3: DEADLOCK DEMONSTRATION
-- SESSION 2
-- =====================================================

BEGIN;

SELECT *
FROM transaction_lab_accounts
WHERE account_id = 2
FOR UPDATE;

-- After Session 1 requests Account B, run:
SELECT *
FROM transaction_lab_accounts
WHERE account_id = 1
FOR UPDATE;


-- =====================================================
-- PORTFOLIO 3: CONSISTENT LOCK ORDERING
-- =====================================================

BEGIN;

SELECT *
FROM transaction_lab_accounts
WHERE account_id IN (1, 2)
ORDER BY account_id
FOR UPDATE;

SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;

COMMIT;


-- =====================================================
-- PORTFOLIO 3: SUCCESSFUL TRANSFER TEST
-- =====================================================

BEGIN;

SELECT transfer_lab_funds(1, 2, 10000.00);

COMMIT;

-- Verify account balances
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;



-- =====================================================
-- PORTFOLIO 3: FAILED TRANSFER TEST
-- =====================================================

BEGIN;

SELECT transfer_lab_funds(1, 2, 100000.00);

-- Expected: Insufficient funds
-- The error aborts this transaction.

ROLLBACK;

-- Verify that balances remain unchanged
SELECT *
FROM transaction_lab_accounts
ORDER BY account_id;


-- =====================================================
-- PORTFOLIO 3: SERIALIZABLE ISOLATION
-- TEST TABLE
-- =====================================================

DROP TABLE IF EXISTS on_call_doctors;

CREATE TABLE on_call_doctors (
    doctor_id INTEGER PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    is_on_call BOOLEAN NOT NULL
);

INSERT INTO on_call_doctors
VALUES
(1, 'Doctor A', TRUE),
(2, 'Doctor B', TRUE);

SELECT *
FROM on_call_doctors
ORDER BY doctor_id;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT COUNT(*)
FROM on_call_doctors
WHERE is_on_call = TRUE;

UPDATE on_call_doctors
SET is_on_call = FALSE
WHERE doctor_id = 1;

-- Commit after Session 2 has performed its update
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT COUNT(*)
FROM on_call_doctors
WHERE is_on_call = TRUE;

UPDATE on_call_doctors
SET is_on_call = FALSE
WHERE doctor_id = 2;

-- Attempt to commit after Session 1 commits
COMMIT;


SELECT *
FROM on_call_doctors
ORDER BY doctor_id;