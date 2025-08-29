.tables

-- INNER JOIN : only show records that exist in both tables

-- Basic INNER JOIN: Show posts with usernames

SELECT
    u.username,
    p.caption,
    p.created_at
FROM posts p
RIGHT JOIN users u ON p.user_id = u.id
LIMIT 5

SELECT * FROM posts


-- You have two tables:
-- Customers
-- | CustomerID | Name |
-- |------------|--------|
-- | 1 | Ali |
-- | 2 | Sadaf |
-- | 3 | Zain |
-- Orders
-- | OrderID | CustomerID | Product |
-- |---------|------------|-------------|
-- | 101 | 1 | Laptop |
-- | 102 | 3 | Phone |
-- | 103 | 1 | Keyboard |

-- It matches rows from both tables only when they have something in common.
-- Here, the CustomerID is the common column

-- First, see how many users are in total in the db
SELECT COUNT(*) as total_users FROM users;

-- users with their post counts using a LEFT JOIN
SELECT
    u.username,
    u.bio,
    COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username, u.bio
ORDER BY post_count DESC;

-- users with their post counts using a INNER JOIN
SELECT
    u.username,
    u.bio,
    COUNT(p.id) as post_count
FROM users u
INNER JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username, u.bio
ORDER BY post_count DESC
LIMIT 5;


-- Posts wih usernames and comment counts
SELECT 
    u.username,
    p.caption,
    COUNT(c.id) as comment_count
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, u.username, p.caption
ORDER BY comment_count DESC

SELECT * FROM users

