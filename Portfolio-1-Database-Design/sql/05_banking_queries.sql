
--- Query 1: List all customers with their account details, including account type and balance. Order the results by customer name and account number.

SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    a.account_number,
    at.type_name AS account_type,
    a.balance,
    a.currency,
    a.status AS account_status
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
ORDER BY
    customer_name,
    a.account_number;


--- Query 2: Retrieve all transactions for a specific customer, including transaction type, amount, date, and status. Order the results by transaction date in descending order.
    SELECT
    t.transaction_id,
    t.reference,
    c.first_name || ' ' || c.last_name AS customer_name,
    tt.type_name AS transaction_type,
    t.amount,
    t.transaction_date,
    t.status,
    t.narration
FROM transactions t
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
LEFT JOIN accounts a
    ON t.source_account_id = a.account_id
    OR t.destination_account_id = a.account_id
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
ORDER BY
    t.transaction_date DESC;


--- Query 3: Calculate the total number of transactions and the total transaction value for each transaction type. We order the results by total transaction value in descending order.

    SELECT
    tt.type_name AS transaction_type,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_transaction_value,
    AVG(t.amount) AS average_transaction_value,
    MIN(t.amount) AS smallest_transaction,
    MAX(t.amount) AS largest_transaction
FROM transaction_types tt
LEFT JOIN transactions t
    ON tt.transaction_type_id = t.transaction_type_id
    AND t.status = 'completed'
GROUP BY
    tt.type_name
ORDER BY
    total_transaction_value DESC NULLS LAST;


--- Query 4: Here, the goal is to list customers who have more than one account and display their total balance across all accounts. Order the results by total balance in descending order.

    SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS combined_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    COUNT(a.account_id) > 1
ORDER BY
    combined_balance DESC;

---- Query 5: Rank customers based on their total account balance, showing the customer name, total balance, and rank. Here, results are ordered by rank in ascending order.

    SELECT
    a.account_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    at.type_name AS account_type,
    a.balance,
    RANK() OVER (
        ORDER BY a.balance DESC
    ) AS balance_rank
FROM accounts a
JOIN customers c
    ON a.customer_id = c.customer_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
ORDER BY
    balance_rank;


---- Query 6: Calculate the monthly transaction volume and value for each transaction type. The results are grouped by month and transaction type, ordered by month and transaction type.

    SELECT
    DATE_TRUNC('month', t.transaction_date)::date AS transaction_month,
    tt.type_name AS transaction_type,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_value
FROM transactions t
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE t.status = 'completed'
GROUP BY
    DATE_TRUNC('month', t.transaction_date),
    tt.type_name
ORDER BY
    transaction_month,
    transaction_type;


--- Query 7: Identify customers who have not made any transactions in the last 6 months. The results include customer name, email, and the date of their last transaction, ordered by the last transaction date.

    SELECT
    a.account_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    at.type_name AS account_type,
    a.balance,
    a.status
FROM accounts a
JOIN customers c
    ON a.customer_id = c.customer_id
JOIN account_types at
    ON a.account_type_id = at.account_type_id
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions t
    WHERE t.source_account_id = a.account_id
       OR t.destination_account_id = a.account_id
)
ORDER BY
    customer_name;