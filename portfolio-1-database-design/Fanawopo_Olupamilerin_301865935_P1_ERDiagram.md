# FinTrust Customer and Financial Records — ER diagram

```mermaid
erDiagram
    direction LR
    customers {
        bigint customer_id PK
        text full_name
        text email UK
        text phone "Optional"
        timestamptz created_at
    }
    accounts {
        bigint account_id PK
        bigint customer_id FK
        text account_number UK
        text account_type
        numeric balance
        text status
        date opened_at
    }
    transaction_types {
        bigint transaction_type_id PK
        text code UK
        text description
    }
    transaction_statuses {
        bigint transaction_status_id PK
        text code UK
        text description
    }
    transactions {
        bigint transaction_id PK
        text reference UK
        bigint account_id FK
        bigint destination_account_id FK "Optional"
        bigint transaction_type_id FK
        bigint transaction_status_id FK
        numeric amount
        timestamptz occurred_at
    }
    audit_logs {
        bigint audit_log_id PK
        bigint customer_id FK
        bigint transaction_id FK "Optional"
        text activity
        timestamptz occurred_at
        text details "Optional"
    }
    customers ||--o{ accounts : "customer_id"
    accounts ||--o{ transactions : "account_id"
    accounts o|--o{ transactions : "destination_account_id"
    transaction_types ||--o{ transactions : "transaction_type_id"
    transaction_statuses ||--o{ transactions : "transaction_status_id"
    customers ||--o{ audit_logs : "customer_id"
    transactions o|--o{ audit_logs : "transaction_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Fanawopo_Olupamilerin_301865935_ERDiagram.png)
