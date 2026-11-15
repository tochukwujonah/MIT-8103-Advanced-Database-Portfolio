
// Database: nairabridge_nosql
// Collection: transaction_activity
// Single document insertion example
{
  "activity_id": "ACT001",
  "customer_id": "CUS001",
  "account_number": "0123456789",
  "event_type": "transfer",
  "amount": 150000,
  "currency": "NGN",
  "status": "successful",
  "created_at": {
    "$date": "2026-11-10T09:30:00Z"
  },
  "metadata": {
    "channel": "mobile",
    "beneficiary": "CUS002",
    "description": "Family support"
  }
}


// Database: nairabridge_nosql
// Collection: transaction_activity
// Multiple document insertion example

use nairabridge_nosql

db.transaction_activity.insertMany([
  {
    activity_id: "ACT002",
    customer_id: "CUS002",
    account_number: "0123456790",
    event_type: "deposit",
    amount: 250000,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-10T10:15:00Z"),
    metadata: {
      channel: "branch",
      teller_id: "TELL001",
      description: "Cash deposit"
    }
  },
  {
    activity_id: "ACT003",
    customer_id: "CUS001",
    account_number: "0123456789",
    event_type: "withdrawal",
    amount: 20000,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-10T11:00:00Z"),
    metadata: {
      channel: "ATM",
      terminal_id: "ATM001"
    }
  },
  {
    activity_id: "ACT004",
    customer_id: "CUS003",
    account_number: "0123456791",
    event_type: "transfer",
    amount: 75000,
    currency: "NGN",
    status: "pending",
    created_at: ISODate("2026-11-11T08:20:00Z"),
    metadata: {
      channel: "internet_banking",
      beneficiary: "CUS004",
      description: "School fees"
    }
  },
  {
    activity_id: "ACT005",
    customer_id: "CUS004",
    account_number: "0123456792",
    event_type: "bill_payment",
    amount: 35000,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-11T09:45:00Z"),
    metadata: {
      channel: "mobile",
      biller: "Electricity",
      provider: "IKEDC"
    }
  },
  {
    activity_id: "ACT006",
    customer_id: "CUS002",
    account_number: "0123456790",
    event_type: "transfer",
    amount: 120000,
    currency: "NGN",
    status: "failed",
    created_at: ISODate("2026-11-11T12:30:00Z"),
    metadata: {
      channel: "mobile",
      beneficiary: "CUS005",
      failure_reason: "Insufficient funds"
    }
  },
  {
    activity_id: "ACT007",
    customer_id: "CUS005",
    account_number: "0123456793",
    event_type: "airtime_purchase",
    amount: 5000,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-12T07:15:00Z"),
    metadata: {
      channel: "mobile",
      network: "MTN",
      phone_number: "08030000001"
    }
  },
  {
    activity_id: "ACT008",
    customer_id: "CUS003",
    account_number: "0123456791",
    event_type: "transfer",
    amount: 500000,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-12T14:00:00Z"),
    metadata: {
      channel: "internet_banking",
      beneficiary: "CUS001",
      description: "Business payment",
      approval_level: 2
    },
    risk_assessment: {
      risk_level: "medium",
      reviewed: true
    }
  },
  {
    activity_id: "ACT009",
    customer_id: "CUS001",
    account_number: "0123456789",
    event_type: "account_inquiry",
    amount: 0,
    currency: "NGN",
    status: "successful",
    created_at: ISODate("2026-11-13T10:10:00Z"),
    metadata: {
      channel: "USSD",
      session_id: "USS001"
    }
  },
  {
    activity_id: "ACT010",
    customer_id: "CUS005",
    account_number: "0123456793",
    event_type: "transfer",
    amount: 45000,
    currency: "NGN",
    status: "reversed",
    created_at: ISODate("2026-11-13T16:25:00Z"),
    metadata: {
      channel: "mobile",
      beneficiary: "CUS002",
      reversal_reason: "Beneficiary bank unavailable"
    }
  }
]);