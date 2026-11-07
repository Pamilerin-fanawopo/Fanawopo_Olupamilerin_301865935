-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customers pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (1, 'Taylor Reed', 'taylor.reed@example.test', NULL, '2024-03-01T09:00:00Z');

-- 2. customers unique. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (1001, 'Taylor Reed', 'alex.morgan@example.test', NULL, '2024-03-01T09:00:00Z');

-- 3. customers nn customer id. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (NULL, 'Taylor Reed', 'taylor.reed@example.test', NULL, '2024-03-01T09:00:00Z');

-- 4. customers nn full name. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (1002, NULL, 'taylor.reed@example.test', NULL, '2024-03-01T09:00:00Z');

-- 5. customers nn email. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (1003, 'Taylor Reed', NULL, NULL, '2024-03-01T09:00:00Z');

-- 6. customers nn created at. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "phone", "created_at")
VALUES (1004, 'Taylor Reed', 'taylor.reed@example.test', NULL, NULL);

-- 7. accounts pk. Expected: pk_accounts, SQLSTATE 23505.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (2, 1, 'FT-200001', 'savings', 100, 'active', '2024-03-01');

-- 8. accounts unique. Expected: uq_accounts_0, SQLSTATE 23505.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1005, 1, 'FT-100001', 'savings', 100, 'active', '2024-03-01');

-- 9. accounts fk customer. Expected: fk_accounts_0, SQLSTATE 23503.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1006, 999007, 'FT-200002', 'savings', 100, 'active', '2024-03-01');

-- 10. accounts nn account id. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (NULL, 1, 'FT-200003', 'savings', 100, 'active', '2024-03-01');

-- 11. accounts nn customer id. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1007, NULL, 'FT-200004', 'savings', 100, 'active', '2024-03-01');

-- 12. accounts nn account number. Expected: account_number, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1008, 1, NULL, 'savings', 100, 'active', '2024-03-01');

-- 13. accounts nn account type. Expected: account_type, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1009, 1, 'FT-200005', NULL, 100, 'active', '2024-03-01');

-- 14. accounts nn balance. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1010, 1, 'FT-200006', 'savings', NULL, 'active', '2024-03-01');

-- 15. accounts nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1011, 1, 'FT-200007', 'savings', 100, NULL, '2024-03-01');

-- 16. accounts nn opened at. Expected: opened_at, SQLSTATE 23502.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1012, 1, 'FT-200008', 'savings', 100, 'active', NULL);

-- 17. accounts check balance. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."accounts" ("account_id", "customer_id", "account_number", "account_type", "balance", "status", "opened_at")
VALUES (1013, 1, 'FT-200009', 'savings', -1, 'active', '2024-03-01');

-- 18. transaction types pk. Expected: pk_transaction_types, SQLSTATE 23505.
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description")
VALUES (3, 'withdrawal', 'Funds withdrawn from an account');

-- 19. transaction types unique. Expected: uq_transaction_types_0, SQLSTATE 23505.
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description")
VALUES (1014, 'deposit', 'Another deposit description');

-- 20. transaction types nn id. Expected: transaction_type_id, SQLSTATE 23502.
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description")
VALUES (NULL, 'withdrawal', 'Funds withdrawn from an account');

-- 21. transaction types nn code. Expected: code, SQLSTATE 23502.
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description")
VALUES (1015, NULL, 'Funds withdrawn from an account');

-- 22. transaction types nn description. Expected: description, SQLSTATE 23502.
INSERT INTO portfolio."transaction_types" ("transaction_type_id", "code", "description")
VALUES (1016, 'withdrawal', NULL);

-- 23. transaction statuses pk. Expected: pk_transaction_statuses, SQLSTATE 23505.
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description")
VALUES (4, 'pending', 'Transaction is awaiting processing');

-- 24. transaction statuses unique. Expected: uq_transaction_statuses_0, SQLSTATE 23505.
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description")
VALUES (1017, 'successful', 'Another successful status description');

-- 25. transaction statuses nn id. Expected: transaction_status_id, SQLSTATE 23502.
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description")
VALUES (NULL, 'pending', 'Transaction is awaiting processing');

-- 26. transaction statuses nn code. Expected: code, SQLSTATE 23502.
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description")
VALUES (1018, NULL, 'Transaction is awaiting processing');

-- 27. transaction statuses nn description. Expected: description, SQLSTATE 23502.
INSERT INTO portfolio."transaction_statuses" ("transaction_status_id", "code", "description")
VALUES (1019, 'pending', NULL);

-- 28. transactions pk. Expected: pk_transactions, SQLSTATE 23505.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (5, 'FTX-2024-0002', 2, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 29. transactions unique. Expected: uq_transactions_0, SQLSTATE 23505.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1020, 'FTX-2024-0001', 2, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 30. transactions fk source. Expected: fk_transactions_0, SQLSTATE 23503.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1021, 'FTX-2024-0003', 999001, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 31. transactions fk destination. Expected: fk_transactions_1, SQLSTATE 23503.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1022, 'FTX-2024-0004', 2, 999002, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 32. transactions fk type. Expected: fk_transactions_2, SQLSTATE 23503.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1023, 'FTX-2024-0005', 2, NULL, 999003, 4, 25, '2024-02-02T12:30:00Z');

-- 33. transactions fk status. Expected: fk_transactions_3, SQLSTATE 23503.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1024, 'FTX-2024-0006', 2, NULL, 3, 999004, 25, '2024-02-02T12:30:00Z');

-- 34. transactions nn id. Expected: transaction_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (NULL, 'FTX-2024-0007', 2, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 35. transactions nn reference. Expected: reference, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1025, NULL, 2, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 36. transactions nn account id. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1026, 'FTX-2024-0008', NULL, NULL, 3, 4, 25, '2024-02-02T12:30:00Z');

-- 37. transactions nn type id. Expected: transaction_type_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1027, 'FTX-2024-0009', 2, NULL, NULL, 4, 25, '2024-02-02T12:30:00Z');

-- 38. transactions nn status id. Expected: transaction_status_id, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1028, 'FTX-2024-0010', 2, NULL, 3, NULL, 25, '2024-02-02T12:30:00Z');

-- 39. transactions nn amount. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1029, 'FTX-2024-0011', 2, NULL, 3, 4, NULL, '2024-02-02T12:30:00Z');

-- 40. transactions nn occurred at. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1030, 'FTX-2024-0012', 2, NULL, 3, 4, 25, NULL);

-- 41. transactions check amount. Expected: transaction_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."transactions" ("transaction_id", "reference", "account_id", "destination_account_id", "transaction_type_id", "transaction_status_id", "amount", "occurred_at")
VALUES (1031, 'FTX-2024-0013', 2, NULL, 3, 4, 0, '2024-02-02T12:30:00Z');

-- 42. audit logs pk. Expected: pk_audit_logs, SQLSTATE 23505.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (6, 1, NULL, 'account_reviewed', '2024-02-03T08:00:00Z', NULL);

-- 43. audit logs fk customer. Expected: fk_audit_logs_0, SQLSTATE 23503.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (1032, 999005, NULL, 'account_reviewed', '2024-02-03T08:00:00Z', NULL);

-- 44. audit logs fk transaction. Expected: fk_audit_logs_1, SQLSTATE 23503.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (1033, 1, 999006, 'account_reviewed', '2024-02-03T08:00:00Z', NULL);

-- 45. audit logs nn id. Expected: audit_log_id, SQLSTATE 23502.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (NULL, 1, NULL, 'account_reviewed', '2024-02-03T08:00:00Z', NULL);

-- 46. audit logs nn customer id. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (1034, NULL, NULL, 'account_reviewed', '2024-02-03T08:00:00Z', NULL);

-- 47. audit logs nn activity. Expected: activity, SQLSTATE 23502.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (1035, 1, NULL, NULL, '2024-02-03T08:00:00Z', NULL);

-- 48. audit logs nn occurred at. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."audit_logs" ("audit_log_id", "customer_id", "transaction_id", "activity", "occurred_at", "details")
VALUES (1036, 1, NULL, 'account_reviewed', NULL, NULL);
