
-- =====================================================
-- NAIRABRIDGE: SAMPLE CUSTOMERS AND ACCOUNTS
-- Portfolio 1 - Database Design and Modelling
-- Currency: NGN
-- =====================================================

-- 1. INSERT SAMPLE CUSTOMERS

INSERT INTO customers
    (first_name, last_name, email, phone, date_of_birth)
VALUES
    ('Chinedu', 'Okafor', 'chinedu.okafor@example.com',
     '07083494670', '1990-04-12'),

    ('Amina', 'Bello', 'amina.bello@example.com',
     '08045678901', '1994-08-23'),

    ('Tunde', 'Adeyemi', 'tunde.adeyemi@example.com',
     '07012345678', '1987-11-05'),

    ('Ngozi', 'Eze', 'ngozi.eze@example.com',
     '07023456789', '1992-02-17'),

    ('Ibrahim', 'Yusuf', 'ibrahim.yusuf@example.com',
     '09045876543', '1996-06-30')

ON CONFLICT (email) DO NOTHING;


-- 2. INSERT SAMPLE ACCOUNTS

INSERT INTO accounts
    (customer_id, account_type_id, account_number, balance)
SELECT
    c.customer_id,
    at.account_type_id,
    v.account_number,
    v.balance
FROM (
    VALUES
        ('chinedu.okafor@example.com', 'Savings', '1000000001', 250000.00::NUMERIC),
        ('chinedu.okafor@example.com', 'Current', '1000000002', 850000.00::NUMERIC),
        ('amina.bello@example.com', 'Savings', '1000000003', 175000.00::NUMERIC),
        ('tunde.adeyemi@example.com', 'Current', '1000000004', 1200000.00::NUMERIC),
        ('ngozi.eze@example.com', 'Savings', '1000000005', 320000.00::NUMERIC),
        ('ibrahim.yusuf@example.com', 'Fixed Deposit', '1000000006', 2000000.00::NUMERIC)
) AS v(email, account_type, account_number, balance)
JOIN customers c
    ON c.email = v.email
JOIN account_types at
    ON at.type_name = v.account_type
ON CONFLICT (account_number) DO NOTHING;


-- 3. VERIFY CUSTOMERS

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    status
FROM customers
ORDER BY customer_id;


-- 4. VERIFY ACCOUNTS

SELECT
    a.account_id,
    a.account_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    at.type_name AS account_type,
    a.balance,
    a.currency,
    a.status
FROM accounts a
JOIN customers c
    ON a.customer_id = c.customer_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
ORDER BY a.account_id;
