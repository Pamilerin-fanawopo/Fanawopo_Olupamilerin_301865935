# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection activity_events for customer_profile_updated and account_opened events. These are fictional event examples based on customers, accounts, transactions, audit_logs.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related customers, accounts, transactions details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "customer_profile_updated",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "audit_logs",
        "key": {
            "audit_log_id": 6
        },
        "snapshot": {
            "audit_log_id": 6,
            "customer_id": 1,
            "transaction_id": 5,
            "activity": "deposit_recorded",
            "occurred_at": "2024-02-01T12:30:01Z",
            "details": "Deposit recorded successfully"
        }
    },
    "embedded": {
        "customers": [
            {
                "key": {
                    "customer_id": 1
                },
                "snapshot": {
                    "customer_id": 1,
                    "full_name": "Alex Morgan",
                    "email": "alex.morgan@example.test",
                    "phone": "+1-555-0101",
                    "created_at": "2024-01-15T10:00:00Z"
                },
                "via": [
                    "audit_logs.customer_id → customers",
                    "audit_logs.transaction_id → transactions.account_id → accounts.customer_id → customers"
                ]
            }
        ],
        "accounts": [
            {
                "key": {
                    "account_id": 2
                },
                "snapshot": {
                    "account_id": 2,
                    "customer_id": 1,
                    "account_number": "FT-100001",
                    "account_type": "checking",
                    "balance": 850.75,
                    "status": "active",
                    "opened_at": "2024-01-16"
                },
                "via": [
                    "audit_logs.transaction_id → transactions.account_id → accounts"
                ]
            }
        ],
        "transactions": [
            {
                "key": {
                    "transaction_id": 5
                },
                "snapshot": {
                    "transaction_id": 5,
                    "reference": "FTX-2024-0001",
                    "account_id": 2,
                    "destination_account_id": null,
                    "transaction_type_id": 3,
                    "transaction_status_id": 4,
                    "amount": 125.5,
                    "occurred_at": "2024-02-01T12:30:00Z"
                },
                "via": [
                    "audit_logs.transaction_id → transactions"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("activity_events").find({"eventType":"customer_profile_updated"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "customer_profile_updated",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "audit_log_id": 6
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("activity_events").find({"source.key.audit_log_id":6}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "customer_profile_updated",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "audit_log_id": 6
    }
  },
  {
    "_id": "event_000002",
    "eventType": "account_opened",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "audit_log_id": 6
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("activity_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "customer_profile_updated",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "audit_log_id": 6
    }
  },
  {
    "_id": "event_000002",
    "eventType": "account_opened",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "audit_log_id": 6
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("activity_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| account_opened | 1 |
| customer_profile_updated | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Fanawopo_Olupamilerin_301865935_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Fanawopo_Olupamilerin_301865935_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

