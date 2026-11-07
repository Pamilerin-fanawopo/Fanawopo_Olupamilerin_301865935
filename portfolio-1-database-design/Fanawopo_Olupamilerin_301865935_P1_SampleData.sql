-- Fictional sample records for FinTrust Customer and Financial Records.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at") VALUES (1, 'Alex Morgan', 'alex.morgan@example.test', '+1-555-0101', '2024-01-15T10:00:00Z');
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description") VALUES (3, 'deposit', 'Funds deposited into an account');
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description") VALUES (4, 'successful', 'Transaction completed successfully');
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at") VALUES (2, 1, 'FT-100001', 'checking', 850.75, 'active', '2024-01-16');
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at") VALUES (5, 'FTX-2024-0001', 2, NULL, 3, 4, 125.5, '2024-02-01T12:30:00Z');
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details") VALUES (6, 1, 5, 'deposit_recorded', '2024-02-01T12:30:01Z', 'Deposit recorded successfully');
COMMIT;
