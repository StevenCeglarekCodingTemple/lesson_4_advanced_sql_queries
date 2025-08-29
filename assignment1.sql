-- **Task**: Write a query to find users and their account information (email) along with how many people they follow.

-- **Requirements**:
-- - Show username, email, and count of people they follow
-- - Include users even if they don't follow anyone
-- - Order by follower count (descending)
-- - Limit to top 5 users

-- **Expected Output**: A table with username, email, and following count.

-- **Hint**: You'll need to JOIN users, accounts, and following tables.

SELECT * FROM users
SELECT * FROM accounts
SELECT * FROM following

SELECT
    u.username,
    a.email,
    COUNT(f.followed_id) as follower_count
FROM users u
INNER JOIN accounts a ON u.id = a.user_id
LEFT JOIN following f ON u.id = f.followed_id
GROUP BY u.username, a.email, f.followed_id
ORDER BY follower_count DESC;
