# Document Data Model – NairaBridge Digital Banking System

## 1. Overview
The NairaBridge Digital Banking System uses MongoDB as its document-oriented NoSQL database.

The document model stores transaction activities as flexible, JSON-like BSON documents. Each document represents an individual banking activity.

## 2. Database Design
- **Database:** `nairabridge_nosql`
- **Collection:** `transaction_activity`
- **Database type:** Document-oriented NoSQL database
- **Implementation:** MongoDB

## 3. Document Structure
Each transaction activity document contains:

| Field | Description |
|---|---|
| activity_id | Unique activity identifier |
| customer_id | Customer associated with the activity |
| account_number | Associated bank account |
| event_type | Type of banking activity |
| amount | Transaction amount |
| currency | Transaction currency |
| status | Activity status |
| created_at | Activity timestamp |
| metadata | Embedded activity-specific information |

The `metadata` field is an embedded document that stores additional information such as channel, beneficiary, description and payment provider.

## 4. Implementation
Ten sample transaction activity documents were inserted into the `transaction_activity` collection.

The implementation included:
- Retrieving all transaction activities.
- Filtering activities by status.
- Retrieving activities belonging to a particular customer.
- Filtering activities by transaction amount.
- Querying embedded metadata fields.

## 5. Aggregation
MongoDB aggregation pipelines were used to analyse:
- Transaction amounts grouped by status.
- Activity counts and amounts grouped by event type.
- Overall transaction count, total amount, average amount, maximum and minimum amounts.

## 6. Suitability
The document model is suitable for NairaBridge because banking activities may contain different metadata depending on the transaction type and channel.

MongoDB's flexible document structure allows related information to be stored together, while its query and aggregation capabilities support transaction analysis.

## 7. Limitations
Document databases require careful schema design and validation to maintain data consistency. Complex relationships may also require additional collections and aggregation operations.