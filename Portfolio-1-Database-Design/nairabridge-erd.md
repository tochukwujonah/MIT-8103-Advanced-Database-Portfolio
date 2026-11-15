
mermaidDiagram
    CUSTOMERS ||--o{ ACCOUNTS : owns
    ACCOUNT_TYPES ||--o{ ACCOUNTS : classifies
    ACCOUNTS ||--o{ TRANSACTIONS : source_account
    ACCOUNTS ||--o{ TRANSACTIONS : destination_account
    TRANSACTION_TYPES ||--o{ TRANSACTIONS : categorises
    CUSTOMERS o|--o{ AUDIT_LOGS : associated_with

    CUSTOMERS {
        bigint customer_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone UK
        date date_of_birth
        timestamp created_at
        varchar status
    }

    ACCOUNT_TYPES {
        int account_type_id PK
        varchar type_name UK
        text description
    }

    ACCOUNTS {
        bigint account_id PK
        bigint customer_id FK
        int account_type_id FK
        varchar account_number UK
        numeric balance
        varchar currency
        timestamp created_at
        varchar status
    }

    TRANSACTION_TYPES {
        int transaction_type_id PK
        varchar type_name UK
        text description
    }

    TRANSACTIONS {
        bigint transaction_id PK
        bigint source_account_id FK
        bigint destination_account_id FK
        int transaction_type_id FK
        numeric amount
        varchar reference UK
        timestamp transaction_date
        varchar status
        text narration
    }

    AUDIT_LOGS {
        bigint audit_id PK
        bigint customer_id FK
        varchar action
        varchar entity_name
        varchar entity_reference
        timestamp action_timestamp
        text details
    }
