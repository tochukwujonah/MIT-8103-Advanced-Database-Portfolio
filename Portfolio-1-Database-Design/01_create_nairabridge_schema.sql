
-- =====================================================
-- NAIRABRIDGE DIGITAL BANKING SYSTEM
-- Portfolio 1: Database Design and Modelling
-- Database: nairabridge_banking
-- =====================================================

-- 1. CUSTOMERS
CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    CONSTRAINT chk_customer_status
        CHECK (status IN ('active', 'inactive', 'suspended'))
);

-- 2. ACCOUNT TYPES
CREATE TABLE account_types (
    account_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- 3. ACCOUNTS
CREATE TABLE accounts (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    account_type_id INTEGER NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance NUMERIC(18,2) NOT NULL DEFAULT 0.00,
    currency CHAR(3) NOT NULL DEFAULT 'NGN',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_account_type
        FOREIGN KEY (account_type_id)
        REFERENCES account_types(account_type_id),

    CONSTRAINT chk_account_balance
        CHECK (balance >= 0),

    CONSTRAINT chk_account_status
        CHECK (status IN ('active', 'inactive', 'frozen', 'closed'))
);

-- 4. TRANSACTION TYPES
CREATE TABLE transaction_types (
    transaction_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT
);

-- 5. TRANSACTIONS
CREATE TABLE transactions (
    transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_account_id BIGINT,
    destination_account_id BIGINT,
    transaction_type_id INTEGER NOT NULL,
    amount NUMERIC(18,2) NOT NULL,
    reference VARCHAR(100) NOT NULL UNIQUE,
    transaction_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    narration TEXT,

    CONSTRAINT fk_transaction_source
        FOREIGN KEY (source_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transaction_destination
        FOREIGN KEY (destination_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transaction_type
        FOREIGN KEY (transaction_type_id)
        REFERENCES transaction_types(transaction_type_id),

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT chk_transaction_status
        CHECK (status IN ('pending', 'completed', 'failed', 'reversed')),

    CONSTRAINT chk_transaction_accounts
        CHECK (
            (source_account_id IS NOT NULL
             OR destination_account_id IS NOT NULL)
            AND
            (source_account_id IS NULL
             OR destination_account_id IS NULL
             OR source_account_id <> destination_account_id)
        )
);

-- 6. AUDIT LOGS
CREATE TABLE audit_logs (
    audit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT,
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    entity_reference VARCHAR(100),
    action_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    details TEXT,

    CONSTRAINT fk_audit_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE SET NULL
);

