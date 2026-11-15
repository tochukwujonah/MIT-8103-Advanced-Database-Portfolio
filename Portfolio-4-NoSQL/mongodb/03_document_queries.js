
// Database: nairabridge_nosql
// Collection: transaction_activity


// Query: Retrieve all transaction activities for a specific customer (e.g., CUS001) and sort them by the created_at date in descending order.
db.transaction_activity.find().pretty()


// Query: Retrieve all transaction activities with a specific event_type (e.g., "transfer") and a status of "successful".
db.transaction_activity.find({
  status: "successful"
}).pretty()



// Query: Retrieve all transaction activities that occurred within a specific date range (e.g., from 2026-11-10 to 2026-11-15).
db.transaction_activity.find({
  customer_id: "CUS001"
}).pretty()



// Query: Retrieve all transaction activities with an amount greater than a specified value (e.g., 100000).
db.transaction_activity.find({
  amount: { $gt: 100000 }
}).pretty()



// Query: Retrieve all transaction activities that were performed through a specific channel (e.g., "mobile").
db.transaction_activity.find({
  "metadata.channel": "mobile"
}).pretty()