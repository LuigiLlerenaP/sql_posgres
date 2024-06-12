-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa
SELECT
    *
FROM
    continent;

SELECT
    *
FROM
    country;

--------! Step one
SELECT
    COUNT(b.continent),
    a.name
FROM
    continent a
    INNER JOIN country b ON a.code = b.continent
WHERE
    a.NAME NOT IN (
        'South America',
        'Central America',
        'North America'
    )
GROUP BY
    2
ORDER BY
    1 ASC;

--------! Step two 
SELECT
    COUNT(b.continent) as "Total",
    'America' as "Continent"
FROM
    continent a
    INNER JOIN country b ON a.code = b.continent
WHERE
    a.NAME IN (
        'South America',
        'Central America',
        'North America'
    );

---! Result 
SELECT
    COUNT(b.continent),
    a.name
FROM
    continent a
    INNER JOIN country b ON a.code = b.continent
WHERE
    a.NAME NOT IN (
        'South America',
        'Central America',
        'North America'
    )
GROUP BY
    a.name
UNION
ALL
SELECT
    COUNT(b.continent),
    'America'
FROM
    continent a
    INNER JOIN country b ON a.code = b.continent
WHERE
    a.NAME IN (
        'South America',
        'Central America',
        'North America'
    )
ORDER BY
    1 ASC;

;