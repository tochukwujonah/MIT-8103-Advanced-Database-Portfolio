
-- =====================================================
-- NAIRABRIDGE: REFERENCE DATA
-- Portfolio 1 - Database Design and Modelling
-- =====================================================

-- Account types
INSERT INTO account_types (type_name, description)
VALUES
    ('Savings', 'Personal savings account'),
    ('Current', 'Everyday banking and payment account'),
    ('Fixed Deposit', 'Account for funds held for a fixed period')
ON CONFLICT (type_name) DO NOTHING;


-- Transaction types
INSERT INTO transaction_types (type_name, description)
VALUES
    ('Deposit', 'Funds deposited into an account'),
    ('Withdrawal', 'Funds withdrawn from an account'),
    ('Transfer', 'Funds transferred between accounts')
ON CONFLICT (type_name) DO NOTHING;


-- Verify account types
SELECT * FROM account_types ORDER BY account_type_id;

-- Verify transaction types
SELECT * FROM transaction_types ORDER BY transaction_type_id;
