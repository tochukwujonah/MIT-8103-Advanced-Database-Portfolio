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

-- Debit Account A
UPDATE transaction_lab_accounts
SET balance = balance - 10000
WHERE account_id = 1
  AND balance >= 10000;

-- Credit Account B
UPDATE transaction_lab_accounts
SET balance = balance + 10000
WHERE account_id = 2;

-- Verify the resulting total
SELECT
    SUM(balance) AS total_balance
FROM transaction_lab_accounts;

COMMIT;

-- Verify final balances
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
    v_locked_count INTEGER;
    v_from_balance NUMERIC(18,2);
BEGIN
    -- Validate transfer details
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Transfer amount must be greater than zero';
    END IF;

    IF p_from_account = p_to_account THEN
        RAISE EXCEPTION 'Source and destination accounts must differ';
    END IF;

    -- Lock both accounts in a consistent order
    PERFORM account_id
    FROM transaction_lab_accounts
    WHERE account_id IN (p_from_account, p_to_account)
    ORDER BY account_id
    FOR UPDATE;

    GET DIAGNOSTICS v_locked_count = ROW_COUNT;

    IF v_locked_count <> 2 THEN
        RAISE EXCEPTION 'One or both accounts do not exist';
    END IF;

    -- Check the source account balance
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