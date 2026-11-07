# FinTrust Customer and Financial Records — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | accounts records (list) |
| --- | --- |
| 1 | [2] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| accounts.account_id | accounts.customer_id | accounts.account_number | customers.customer_id | customers.full_name |
| --- | --- | --- | --- | --- |
| 2 | 1 | FT-100001 | 1 | Alex Morgan |

Key: account_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## accounts_example

| accounts.account_id | accounts.customer_id | accounts.account_number | customers.customer_id | customers.full_name |
| --- | --- | --- | --- | --- |
| 2 | 1 | FT-100001 | 1 | Alex Morgan |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | full_name | email | phone | created_at |
| --- | --- | --- | --- | --- |
| 1 | Alex Morgan | alex.morgan@example.test | +1-555-0101 | 2024-01-15T10:00:00+00:00 |

## accounts

| account_id | customer_id | account_number | account_type | balance | status | opened_at |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | 1 | FT-100001 | checking | 850.75 | active | 2024-01-16 |

## transaction_types

| transaction_type_id | code | description |
| --- | --- | --- |
| 3 | deposit | Funds deposited into an account |

## transaction_statuses

| transaction_status_id | code | description |
| --- | --- | --- |
| 4 | successful | Transaction completed successfully |

## transactions

| transaction_id | reference | account_id | destination_account_id | transaction_type_id | transaction_status_id | amount | occurred_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | FTX-2024-0001 | 2 | NULL | 3 | 4 | 125.5 | 2024-02-01T12:30:00+00:00 |

## audit_logs

| audit_log_id | customer_id | transaction_id | activity | occurred_at | details |
| --- | --- | --- | --- | --- | --- |
| 6 | 1 | 5 | deposit_recorded | 2024-02-01T12:30:01+00:00 | Deposit recorded successfully |

## Dependencies

- customers: (customer_id) → full_name, email, phone, created_at
- accounts: (account_id) → customer_id, account_number, account_type, balance, status, opened_at
- transaction_types: (transaction_type_id) → code, description
- transaction_statuses: (transaction_status_id) → code, description
- transactions: (transaction_id) → reference, account_id, destination_account_id, transaction_type_id, transaction_status_id, amount, occurred_at
- audit_logs: (audit_log_id) → customer_id, transaction_id, activity, occurred_at, details

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
