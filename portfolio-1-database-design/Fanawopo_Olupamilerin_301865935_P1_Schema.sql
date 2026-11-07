-- FinTrust Customer and Financial Records: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "customer_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("email")
);
CREATE TABLE portfolio."accounts" (
  "account_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "account_number" text NOT NULL,
  "account_type" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  "opened_at" date NOT NULL,
  CONSTRAINT "pk_accounts" PRIMARY KEY ("account_id"),
  CONSTRAINT "uq_accounts_0" UNIQUE ("account_number")
);
CREATE TABLE portfolio."transaction_types" (
  "transaction_type_id" bigint NOT NULL,
  "code" text NOT NULL,
  "description" text NOT NULL,
  CONSTRAINT "pk_transaction_types" PRIMARY KEY ("transaction_type_id"),
  CONSTRAINT "uq_transaction_types_0" UNIQUE ("code")
);
CREATE TABLE portfolio."transaction_statuses" (
  "transaction_status_id" bigint NOT NULL,
  "code" text NOT NULL,
  "description" text NOT NULL,
  CONSTRAINT "pk_transaction_statuses" PRIMARY KEY ("transaction_status_id"),
  CONSTRAINT "uq_transaction_statuses_0" UNIQUE ("code")
);
CREATE TABLE portfolio."transactions" (
  "transaction_id" bigint NOT NULL,
  "reference" text NOT NULL,
  "account_id" bigint NOT NULL,
  "destination_account_id" bigint,
  "transaction_type_id" bigint NOT NULL,
  "transaction_status_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  CONSTRAINT "pk_transactions" PRIMARY KEY ("transaction_id"),
  CONSTRAINT "uq_transactions_0" UNIQUE ("reference")
);
CREATE TABLE portfolio."audit_logs" (
  "audit_log_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "transaction_id" bigint,
  "activity" text NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "details" text,
  CONSTRAINT "pk_audit_logs" PRIMARY KEY ("audit_log_id")
);
ALTER TABLE portfolio."accounts" ADD CONSTRAINT "fk_accounts_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "fk_transactions_0" FOREIGN KEY ("account_id") REFERENCES portfolio."accounts" ("account_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "fk_transactions_1" FOREIGN KEY ("destination_account_id") REFERENCES portfolio."accounts" ("account_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "fk_transactions_2" FOREIGN KEY ("transaction_type_id") REFERENCES portfolio."transaction_types" ("transaction_type_id");
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "fk_transactions_3" FOREIGN KEY ("transaction_status_id") REFERENCES portfolio."transaction_statuses" ("transaction_status_id");
ALTER TABLE portfolio."audit_logs" ADD CONSTRAINT "fk_audit_logs_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."audit_logs" ADD CONSTRAINT "fk_audit_logs_1" FOREIGN KEY ("transaction_id") REFERENCES portfolio."transactions" ("transaction_id");
ALTER TABLE portfolio."accounts" ADD CONSTRAINT "account_balance_nonnegative" CHECK ("balance" >= 0);
ALTER TABLE portfolio."transactions" ADD CONSTRAINT "transaction_amount_positive" CHECK ("amount" > 0);
COMMIT;
