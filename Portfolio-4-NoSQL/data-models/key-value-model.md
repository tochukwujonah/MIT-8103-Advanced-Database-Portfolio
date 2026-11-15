# Key-Value Data Model – NairaBridge Digital Banking System

## 1. Overview
The NairaBridge Digital Banking System demonstrates the key-value data model using MongoDB.

The model stores application configuration settings as individual records, with each record containing a unique key and its corresponding value.

## 2. Database Design
- **Database:** `nairabridge_nosql`
- **Collection:** `system_config`
- **Database type:** Key-value access pattern implemented using MongoDB documents.

## 3. Configuration Records
The collection contains five configuration records:

| Key | Value | Category |
|---|---|---|
| application_name | NairaBridge Digital Banking System | general |
| default_currency | NGN | financial |
| maximum_transfer_limit | 5000000 | financial |
| maintenance_mode | false | system |
| support_email | support@nairabridge.example | support |

## 4. Implementation
Five configuration records were inserted into the `system_config` collection.

The implementation was verified using:
- A lookup of `maximum_transfer_limit` by key.
- Retrieval of configuration records belonging to the `financial` category.

The maximum transfer limit lookup returned 5,000,000, while the financial category query returned two records.

## 5. Suitability
A key-value access pattern is useful for retrieving application settings, feature flags, system preferences and configuration values.

For NairaBridge, it provides a straightforward way to organise frequently accessed application configuration.

## 6. Limitations
This implementation uses MongoDB documents to demonstrate key-value access. It is not a separate Redis or dedicated key-value database deployment.

For large-scale, high-speed configuration caching, a dedicated key-value database such as Redis could be considered.