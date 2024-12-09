SELECT
    a.*,
    leader."name",
    follower.name
FROM
    followers a
    INNER JOIN "user" leader ON leader.id = a.leader_id
    INNER JOIN "user" follower ON follower.id = a.follower_id;

--No recursivo 
SELECT
    *
FROM
    followers
WHERE
    leader_id IN (
        SELECT
            follower_id
        FROM
            followers
        where
            leader_id = 1
    );