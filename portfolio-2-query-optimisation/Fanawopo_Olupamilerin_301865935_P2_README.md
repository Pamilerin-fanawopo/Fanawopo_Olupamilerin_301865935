# FinTrust Customer and Financial Records — SQL queries

## 1. Show related customers, accounts, transactions records (up to 20).

```sql
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
```

| customers_customer_id | customers_full_name | accounts_account_id | accounts_account_number | transactions_transaction_id | transactions_reference |
| --- | --- | --- | --- | --- | --- |
| 1 | Alex Morgan | 2 | FT-100001 | 5 | FTX-2024-0001 |

## 2. Find transaction_statuses records where code matches "successful" (up to 20).

```sql
SELECT * FROM portfolio."transaction_statuses"
WHERE "code" IS NOT DISTINCT FROM 'successful'
ORDER BY "transaction_status_id"
LIMIT 20;
```

| transaction_status_id | code | description |
| --- | --- | --- |
| 4 | successful | Transaction completed successfully |

## 3. Count transactions records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."transactions"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 2 | 1 |

## 4. Show related audit_logs, customers, transactions records (up to 20).

```sql
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
```

| audit_logs_audit_log_id | audit_logs_activity | customers_customer_id | customers_full_name | transactions_transaction_id | transactions_reference |
| --- | --- | --- | --- | --- | --- |
| 6 | deposit_recorded | 1 | Alex Morgan | 5 | FTX-2024-0001 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.4 | 2.298, 2.409, 2.4 | Sort → Seq Scan | 274 |
| After index | 0.282 | 0.282, 0.275, 0.288 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.4 ms to 0.282 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.271..2.274 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.015..2.237 rows=50 loops=1)
Planning Time: 0.285 ms
Execution Time: 2.298 ms
```

### Before index, run 2

```text
Sort (actual time=2.382..2.385 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.015..2.344 rows=50 loops=1)
Planning Time: 0.335 ms
Execution Time: 2.409 ms
```

### Before index, run 3

```text
Sort (actual time=2.374..2.377 rows=50 loops=1)
  Seq Scan on transactions (actual time=0.014..2.341 rows=50 loops=1)
Planning Time: 0.283 ms
Execution Time: 2.4 ms
```

### After index, run 1

```text
Sort (actual time=0.228..0.231 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.034..0.193 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=50 loops=1)
Planning Time: 0.575 ms
Execution Time: 0.282 ms
```

### After index, run 2

```text
Sort (actual time=0.223..0.225 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.034..0.187 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.018 rows=50 loops=1)
Planning Time: 0.514 ms
Execution Time: 0.275 ms
```

### After index, run 3

```text
Sort (actual time=0.237..0.239 rows=50 loops=1)
  Bitmap Heap Scan on transactions (actual time=0.032..0.203 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.457 ms
Execution Time: 0.288 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Fanawopo_Olupamilerin_301865935_P2_Queries.sql, then Fanawopo_Olupamilerin_301865935_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Fanawopo_Olupamilerin_301865935_P2_QueryResults.png) · [Index comparison](screenshots/Fanawopo_Olupamilerin_301865935_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

