-- Show related customers, accounts, transactions records (up to 20).
SELECT t0."customer_id" AS "customers_customer_id",
       t0."full_name" AS "customers_full_name",
       t1."account_id" AS "accounts_account_id",
       t1."account_number" AS "accounts_account_number",
       t2."transaction_id" AS "transactions_transaction_id",
       t2."reference" AS "transactions_reference"
FROM portfolio."customers" t0
JOIN portfolio."accounts" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."transactions" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."customer_id", t1."account_id", t2."transaction_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."customer_id" AS "customers_customer_id",
       t0."full_name" AS "customers_full_name",
       t1."account_id" AS "accounts_account_id",
       t1."account_number" AS "accounts_account_number",
       t2."transaction_id" AS "transactions_transaction_id",
       t2."reference" AS "transactions_reference"
FROM portfolio."customers" t0
JOIN portfolio."accounts" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."transactions" t2 ON t2."account_id" = t1."account_id"
ORDER BY t0."customer_id", t1."account_id", t2."transaction_id"
LIMIT 20;

-- Find transaction_statuses records where code matches "successful" (up to 20).
SELECT * FROM portfolio."transaction_statuses"
WHERE "code" IS NOT DISTINCT FROM 'successful'
ORDER BY "transaction_status_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."transaction_statuses"
WHERE "code" IS NOT DISTINCT FROM 'successful'
ORDER BY "transaction_status_id"
LIMIT 20;

-- Count transactions records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

-- Show related audit_logs, customers, transactions records (up to 20).
SELECT t0."audit_log_id" AS "audit_logs_audit_log_id",
       t0."activity" AS "audit_logs_activity",
       t1."customer_id" AS "customers_customer_id",
       t1."full_name" AS "customers_full_name",
       t2."transaction_id" AS "transactions_transaction_id",
       t2."reference" AS "transactions_reference"
FROM portfolio."audit_logs" t0
JOIN portfolio."customers" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."transactions" t2 ON t0."transaction_id" = t2."transaction_id"
ORDER BY t0."audit_log_id", t1."customer_id", t2."transaction_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."audit_log_id" AS "audit_logs_audit_log_id",
       t0."activity" AS "audit_logs_activity",
       t1."customer_id" AS "customers_customer_id",
       t1."full_name" AS "customers_full_name",
       t2."transaction_id" AS "transactions_transaction_id",
       t2."reference" AS "transactions_reference"
FROM portfolio."audit_logs" t0
JOIN portfolio."customers" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."transactions" t2 ON t0."transaction_id" = t2."transaction_id"
ORDER BY t0."audit_log_id", t1."customer_id", t2."transaction_id"
LIMIT 20;
