
-- =====================================================
-- NAIRABRIDGE: SAMPLE FINANCIAL TRANSACTIONS
-- Portfolio 1 - Database Design and Modelling
-- Currency: NGN
-- =====================================================

BEGIN;

-- 1. INSERT TRANSACTION RECORDS

INSERT INTO transactions
(
    source_account_id,
    destination_account_id,
    transaction_type_id,
    amount,
    reference,
    status,
    narration
)
VALUES

-- Deposit into Chinedu's Savings Account
(
    NULL,
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000001'),
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Deposit'),
    50000.00,
    'NB-TRX-2026-0001',
    'completed',
    'Cash deposit into savings account'
),

-- Withdrawal from Chinedu's Current Account
(
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000002'),
    NULL,
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Withdrawal'),
    25000.00,
    'NB-TRX-2026-0002',
    'completed',
    'Cash withdrawal from current account'
),

-- Transfer from Chinedu to Amina
(
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000002'),
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000003'),
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Transfer'),
    100000.00,
    'NB-TRX-2026-0003',
    'completed',
    'Transfer to another NairaBridge customer'
),

-- Deposit into Tunde's Current Account
(
    NULL,
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000004'),
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Deposit'),
    200000.00,
    'NB-TRX-2026-0004',
    'completed',
    'Funds deposited into current account'
),

-- Withdrawal from Ngozi's Savings Account
(
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000005'),
    NULL,
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Withdrawal'),
    20000.00,
    'NB-TRX-2026-0005',
    'completed',
    'ATM cash withdrawal'
),

-- Transfer from Tunde to Ngozi
(
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000004'),
    (SELECT account_id FROM accounts
     WHERE account_number = '1000000005'),
    (SELECT transaction_type_id FROM transaction_types
     WHERE type_name = 'Transfer'),
    30000.00,
    'NB-TRX-2026-0006',
    'completed',
    'Transfer to another NairaBridge customer'
);


-- 2. UPDATE ACCOUNT BALANCES

UPDATE accounts
SET balance = balance +
    CASE account_number
        WHEN '1000000001' THEN 50000.00
        WHEN '1000000002' THEN -125000.00
        WHEN '1000000003' THEN 100000.00
        WHEN '1000000004' THEN 170000.00
        WHEN '1000000005' THEN 10000.00
        ELSE 0.00
    END
WHERE account_number IN (
    '1000000001',
    '1000000002',
    '1000000003',
    '1000000004',
    '1000000005'
);

COMMIT;


-- 3. VERIFY TRANSACTION RECORDS

SELECT
    t.transaction_id,
    t.reference,
    tt.type_name AS transaction_type,
    src.account_number AS source_account,
    dest.account_number AS destination_account,
    t.amount,
    t.status,
    t.transaction_date,
    t.narration
FROM transactions t
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
LEFT JOIN accounts src
    ON t.source_account_id = src.account_id
LEFT JOIN accounts dest
    ON t.destination_account_id = dest.account_id
ORDER BY t.transaction_id;


-- 4. VERIFY UPDATED ACCOUNT BALANCES

SELECT
    a.account_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    at.type_name AS account_type,
    a.balance,
    a.currency
FROM accounts a
JOIN customers c
    ON a.customer_id = c.customer_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
ORDER BY a.account_number;
