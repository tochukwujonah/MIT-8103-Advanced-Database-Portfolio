// Database: nairabridge_nosql
// Collection: transaction_activity


// Aggregation Query: Calculate the total number of transaction activities and the total amount for each status (e.g., "successful", "failed", "pending") and sort the results by the total number of activities in descending order.
db.transaction_activity.aggregate([
  {
    $group: {
      _id: "$status",
      total_activities: { $sum: 1 },
      total_amount: { $sum: "$amount" }
    }
  },
  {
    $sort: { total_activities: -1 }
  }
]);



// Aggregation Query: Calculate the total number of transaction activities and the total amount for each event_type (e.g., "transfer", "deposit", "withdrawal") and sort the results by the total amount in descending order.
db.transaction_activity.aggregate([
  {
    $group: {
      _id: "$event_type",
      transaction_count: { $sum: 1 },
      total_amount: { $sum: "$amount" }
    }
  },
  {
    $sort: { total_amount: -1 }
  }
]);



// Aggregation Query: Calculate the total number of transaction activities, the total transaction value, the average transaction value, the highest transaction value, and the lowest transaction value across all transactions.
db.transaction_activity.aggregate([
  {
    $group: {
      _id: null,
      total_activities: { $sum: 1 },
      total_transaction_value: { $sum: "$amount" },
      average_transaction_value: { $avg: "$amount" },
      highest_transaction: { $max: "$amount" },
      lowest_transaction: { $min: "$amount" }
    }
  }
]);