WITH RECURSIVE bosses As (
    -- Init
    SELECT
        id,
        name,
        reports_to
    from
        employees
    where
        id = 1
    UNION
    -- recursive
)
SELECT
    *
FROM
    bosses;