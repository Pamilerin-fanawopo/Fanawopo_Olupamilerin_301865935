# FinTrust Customer and Financial Records — database design

My case study records customers, accounts, transaction_types, transaction_statuses, transactions, audit_logs.

## Users

- Customers managing their accounts and transactions
- FinTrust staff reviewing account activity
- Database administrators maintaining records

## Main operations

- Register customers and open accounts
- Record deposits, withdrawals and transfers
- Track transaction types and statuses
- Review financial activity and audit records

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Stores customer identity and contact information. |
| accounts | Stores customer-owned accounts, account numbers, balances and account status. |
| transaction_types | Defines supported transaction categories. |
| transaction_statuses | Defines supported transaction processing statuses. |
| transactions | Records transaction references, amounts, times, accounts, types and statuses. |
| audit_logs | Records important customer actions and, when applicable, the related transaction. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| phone | TEXT |  | No |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## accounts

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| account_type | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| opened_at | DATE |  | Yes |
- customer_id → customers.customer_id
- Unique key: (account_number).

## transaction_types

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transaction_type_id | BIGINT | PK | Yes |
| code | TEXT | Unique | Yes |
| description | TEXT |  | Yes |
- Unique key: (code).

## transaction_statuses

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transaction_status_id | BIGINT | PK | Yes |
| code | TEXT | Unique | Yes |
| description | TEXT |  | Yes |
- Unique key: (code).

## transactions

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| transaction_id | BIGINT | PK | Yes |
| reference | TEXT | Unique | Yes |
| account_id | BIGINT | FK | Yes |
| destination_account_id | BIGINT | FK | No |
| transaction_type_id | BIGINT | FK | Yes |
| transaction_status_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
- account_id → accounts.account_id
- destination_account_id → accounts.account_id
- transaction_type_id → transaction_types.transaction_type_id
- transaction_status_id → transaction_statuses.transaction_status_id
- Unique key: (reference).

## audit_logs

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| audit_log_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| transaction_id | BIGINT | FK | No |
| activity | TEXT |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
| details | TEXT |  | No |
- customer_id → customers.customer_id
- transaction_id → transactions.transaction_id

## Relationships and business rules

- Each customer email address must be unique.
- Each account number must identify only one account.
- An account balance cannot be below zero.
- Each account customer identifier must reference an existing customer.
- A transaction reference can be recorded only once, including when concurrent requests attempt the same reference.
- A recorded transaction amount must be greater than zero.
- Each transaction source account must reference an existing account.
- A non-null transfer destination must reference an existing account.
- Each transaction type identifier must reference an existing transaction type.
- Each transaction status identifier must reference an existing transaction status.
- Each audit log customer identifier must reference an existing customer.
- A non-null audit log transaction identifier must reference an existing transaction.

## Assumptions

- The six named areas are modeled as six entities; account type, account status and audit activity are scalar attributes.
- Each entity has one single-column primary key. Key values are assigned from a shared identifier space and are globally unique across entities.
- All amounts use one project-wide currency and are stored as exact decimals.
- Timestamps use UTC. Account opening is recorded as a date; transaction and audit events use timestamps.
- A transaction records its source account and an optional destination account, which is used for transfers.
- Balance changes, transaction records and related audit records are committed atomically. Transactions represent financial activity; audit logs record important actions.
- Transaction type and status lookup rows contain codes for deposits, withdrawals, transfers, pending, successful and failed.
- Worked normalization example: use accounts as the relation with a foreign key to customers. Store customer contact details once in customers and reference the customer from accounts, avoiding repeated customer details in account rows.
- Separate benchmark plan: generate 50000 synthetic transaction rows and compare the same occurred_at date-range filter before and after adding a B-tree index on occurred_at; record query plans and elapsed time under the same data and query conditions.

