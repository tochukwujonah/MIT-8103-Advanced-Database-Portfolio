

// Database: nairabridge_nosql
// Collection: transaction_activity
//Implementing a key-value model for storing system configuration settings in MongoDB
// Each document represents a configuration setting with a unique key and its corresponding value.



db.createCollection("system_config")



// Inserting configuration settings into the system_config collection
db.system_config.insertMany([
  {
    key: "application_name",
    value: "NairaBridge Digital Banking System",
    category: "general"
  },
  {
    key: "default_currency",
    value: "NGN",
    category: "financial"
  },
  {
    key: "maximum_transfer_limit",
    value: 5000000,
    category: "financial"
  },
  {
    key: "maintenance_mode",
    value: false,
    category: "system"
  },
  {
    key: "support_email",
    value: "support@nairabridge.example",
    category: "support"
  }
])

// Querying configuration settings by key
db.system_config.findOne({
  key: "maximum_transfer_limit"
})


// Querying configuration settings by category
db.system_config.find({
  category: "financial"
})