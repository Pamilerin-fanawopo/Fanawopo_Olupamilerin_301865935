// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("activity_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("activity_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "customer_profile_updated",
                    "account_opened"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "audit_logs"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "audit_log_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("activity_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "account_opened",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "transactions",
                    "key": {
                        "transaction_id": 5
                    },
                    "field": "destination_account_id",
                    "value": null
                },
                {
                    "entity": "transactions",
                    "key": {
                        "transaction_id": 5
                    },
                    "field": "amount",
                    "value": 125.5
                }
            ],
            "examples": {
                "source_account_id": "illustrative source_account_id",
                "transaction_reference": "illustrative transaction_reference",
                "status_code": "illustrative status_code",
                "changed_fields": "illustrative changed_fields"
            }
        }
    }
]));
  await db.getCollection("activity_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("activity_events").find({"eventType":"customer_profile_updated"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("activity_events").find({"source.key.audit_log_id":6}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("activity_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("activity_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("activity_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("activity_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("activity_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
