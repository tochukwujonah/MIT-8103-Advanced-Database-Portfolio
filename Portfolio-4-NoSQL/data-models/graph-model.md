# Graph Data Model – NairaBridge Digital Banking System

## 1. Overview
The NairaBridge Digital Banking System demonstrates a graph-style data model using MongoDB collections.

The model represents customers and bank accounts as nodes, while ownership and transfer activities are represented as relationships between nodes.

## 2. Database Design
- **Database:** `nairabridge_nosql`
- **Nodes collection:** `graph_nodes`
- **Relationships collection:** `graph_relationships`
- **Implementation:** MongoDB

## 3. Graph Nodes
Six nodes were created:

- Three customer nodes: CUS001, CUS002 and CUS003.
- Three account nodes: ACC001, ACC002 and ACC003.

Each node contains a unique `node_id` and a `node_type`, together with relevant customer or account information.

## 4. Graph Relationships
Six relationships were created:

| Relationship type | Count | Description |
|---|---:|---|
| OWNS | 3 | Customer account ownership |
| TRANSFERRED_TO | 2 | Completed customer transfers |
| ATTEMPTED_TRANSFER_TO | 1 | Unsuccessful transfer attempt |

The transfer relationships also store the associated activity ID, amount and currency.

## 5. Implementation and Verification
MongoDB collections were used to store graph nodes and relationships.

The implementation was verified by:
- Counting the graph nodes.
- Counting the graph relationships.
- Retrieving completed transfer relationships.
- Retrieving attempted transfer relationships.
- Using MongoDB `$lookup` aggregation to retrieve sender and beneficiary names from the node collection.

## 6. Suitability
The graph model is useful for exploring relationships between customers, accounts and transfers.

Potential banking applications include customer relationship analysis, transaction-network exploration and identifying connections between accounts.

## 7. Limitations
This is a graph-style implementation using MongoDB collections. It is not a native graph database implementation.

A graph-native database such as Neo4j could provide more specialised graph traversal and relationship-analysis capabilities for larger and more complex networks.