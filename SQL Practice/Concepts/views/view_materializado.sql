CREATE MATERIALIZED VIEW comments_per_week_mat AS (
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

REFRESH MATERIALIZED VIEW comments_per_week_mat;

SELECT
    *
FROM
    comments_per_week_mat;