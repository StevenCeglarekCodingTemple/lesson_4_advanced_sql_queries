-- SCALAR SubQuery -- Only gives one result


SELECT COUNT(f.follower_id) as follower_count
    FROM users u
    LEFT JOIN following f ON u.id = f.followed_id
    GROUP BY u.id


-- First, lets see what the average follower count is

SELECT AVG(follower_count) as avg_followers
FROM (
    SELECT COUNT(f.follower_id) as follower_count
    FROM users u
    LEFT JOIN following f ON u.id = f.followed_id
    GROUP BY u.id
) as follower_stats

-- Now find users with above-average followers
SELECT 
    u.username,
    COUNT(f.follower_id) as follower_count
FROM users u
LEFT JOIN following f ON u.id = f.followed_id
GROUP BY u.id, u.username
HAVING COUNT(f.follower_id) > (
    SELECT AVG(follower_count)
    FROM (
        SELECT COUNT(f2.follower_id) as follower_count
        FROM users u2
        LEFT JOIN following f2 ON u2.id = f2.followed_id
        GROUP BY u2.id
    ) as avg_followers
)
ORDER BY follower_count DESC;


-- Table SubQuery -- returns multiple rows

-- First, find the top 5 most active users (Users with the most posts)
SELECT
    u.id,
    u.username,
    COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username
ORDER BY post_count DESC
LIMIT 5;

-- Now use that result to get all posts from those users
SELECT
    u.username, 
    p.caption,
    p.created_at
FROM posts p
INNER JOIN users u ON p.user_id = u.id
WHERE u.id IN (
    SELECT
    u2.id
    FROM users u2
    LEFT JOIN posts p2 ON u2.id = p2.user_id
    GROUP BY u2.id
    ORDER BY COUNT(p2.id) DESC
    LIMIT 5
)
ORDER BY u.username, p.created_at;

-- Correlated SubQuery --

-- Posts with above-average comments for that user
SELECT
    u.username,
    p.caption,
    COUNT(c.id) as comment_count
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
GROUP BY p.id, u.username, p.caption
HAVING COUNT(c.id) > (
    SELECT AVG(comment_count)
    FROM (
        SELECT COUNT(c2.id) as comment_count
        FROM posts p2
        LEFT JOIN comments c2 ON p2.id = c2.post_id
        -- WHERE p2.user_id = p.user_id
        GROUP BY p2.id
    ) as user_avg
)
ORDER BY u.username, comment_count DESC;

-- Calculate all reaction counts

SELECT COUNT(r2.id) as reaction_count
        FROM posts p2
        LEFT JOIN reactions r2 ON p2.id = r2.post_id
        --WHERE p2.user_id = p.user_id
        GROUP BY p2.id


-- Calculate AVG reactions per post

SELECT AVG(reaction_count)
    FROM (
        SELECT COUNT(r2.id) as reaction_count
        FROM posts p2
        LEFT JOIN reactions r2 ON p2.id = r2.post_id
        --WHERE p2.user_id = p.user_id
        GROUP BY p2.id
    ) as user_avg


SELECT
    u.username,
    p.caption,
    COUNT(r.id) as reaction_count
FROM posts p
INNER JOIN users u ON p.user_id = u.id
LEFT JOIN reactions r ON p.id = r.post_id
GROUP BY p.id, u.username, p.caption
HAVING COUNT(r.id) > (
    SELECT AVG(reaction_count)
    FROM (
        SELECT COUNT(r2.id) as reaction_count
        FROM posts p2
        LEFT JOIN reactions r2 ON p2.id = r2.post_id
        WHERE p2.user_id = p.user_id
        GROUP BY p2.id
    ) as user_avg
)
ORDER BY u.username, reaction_count DESC;

SELECT * FROM reactions