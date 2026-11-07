# Portfolio 1 — Database Design and Modelling

I organised the data into customers, accounts, transaction_types, transaction_statuses, transactions, audit_logs. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customers | 1 |
| accounts | 1 |
| transaction_types | 1 |
| transaction_statuses | 1 |
| transactions | 1 |
| audit_logs | 1 |

The 48 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Fanawopo_Olupamilerin_301865935_P1_Design.md)
- [ER diagram](Fanawopo_Olupamilerin_301865935_P1_ERDiagram.md)
- [Normalisation](Fanawopo_Olupamilerin_301865935_P1_Normalisation.md)
- [Schema](Fanawopo_Olupamilerin_301865935_P1_Schema.sql)
- [Sample data](Fanawopo_Olupamilerin_301865935_P1_SampleData.sql)
- [Constraint tests](Fanawopo_Olupamilerin_301865935_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Fanawopo_Olupamilerin_301865935_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

