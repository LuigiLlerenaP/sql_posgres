-- Active: 1716520831018@@127.0.0.1@5432@mediumDB
CREATE VIEW comments_per_week as (
    SELECT
        date_trunc('week', a.created_at) as weeks,
        count(DISTINCT a.post_id) as number_of_post,
        sum (b.counter) as total_claps,
        count(*) as number_of_claps
    FROM
        posts a
        INNER JOIN claps b on b.post_id = a.post_id
    GROUP BY
        1
    ORDER BY
        1 DESC
);

DROP VIEW comments_per_week;

SELECT
    *
FROM
    comments_per_week;

SELECT
    *
FROM
    posts
WHERE
    post_id = 1;

UPDATE
    posts
set
    created_at = '2025-12-21 16:22:33.816'
WHERE
    post_id = 1;