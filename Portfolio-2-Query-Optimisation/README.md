### Baseline Execution Plan Analysis

The initial execution plan estimated one row from the transactions table, whereas six rows were returned. After running PostgreSQL's ANALYZE command, the estimated row count increased to six, matching the actual result.

The execution strategy also changed from a Nested Loop join to a Hash Join. PostgreSQL used the updated table statistics to reassess the most suitable join method.

The measured execution time changed from 0.244 ms to 0.288 ms. This small difference is not sufficient to conclude that either execution strategy is faster because the dataset contains only six transactions.

This experiment demonstrates the importance of database statistics in query planning and cardinality estimation.


### Composite Index Experiment

A composite index was created on the `transactions` table using the `status` and `transaction_date` columns in descending date order.

After creating the index and refreshing table statistics, PostgreSQL continued to use a Sequential Scan rather than the newly created index.

The execution time changed from 0.288 ms to 0.290 ms. This negligible difference does not demonstrate a performance improvement.

The likely reason is the small size of the transactions table, which currently contains only six records. PostgreSQL determined that scanning the table sequentially was more economical than using the index.

This experiment demonstrates that indexes do not automatically improve query performance. Their usefulness depends on factors such as table size, data distribution, query selectivity, and planner cost estimates.


### Large Dataset Baseline Performance Test

A benchmark table containing 20,000 simulated transaction records was created to evaluate PostgreSQL query performance.

The baseline query retrieved all completed transactions and sorted them by transaction date in descending order.

The execution plan showed a Sequential Scan across the table, returning 16,000 records and filtering out 4,000 records. PostgreSQL then used quicksort, requiring approximately 1,635 kB of memory.

The measured execution time was 15.632 ms, with 225 shared buffer hits.

The estimated row count of 16,000 matched the actual result, indicating accurate cardinality estimation for this query.

The Sequential Scan was reasonable because the query retrieved 80% of the table. An index may not be more efficient when a large proportion of the records must be retrieved.
