INSERT INTO
    continent (code, name)
VALUES
    (9, 'North Asia'),
    (10, 'Central Asia'),
    (11, 'South Asia');

SELECT
    *
FROM
    continent
WHERE
    name IN ('North Asia', 'Central Asia', 'South Asia');

--Inner Join
SELECT
    a.name AS "Country Name",
    b.name AS "Continent Name"
FROM
    country a
    INNER JOIN continent b ON a.continent = b.code
ORDER BY
    1 ASC;

-- Full outer join
SELECT
    a.name as "Country Name",
    a.continent as "Continent code",
    b.name as "Continent Name"
FROM
    country a FULL
    OUTER JOIN continent b ON a.continent = b.code
ORDER BY
    1 DESC;

--!Right outer join 
SELECT
    a.name as "Country Name",
    a.continent as "Continent code",
    b.name as "Continent Name"
FROM
    country a
    RIGHT JOIN continent b ON a.continent = b.code
WHERE
    a.code IS NULL
ORDER BY
    3 ASC;

--!Agregación join
SELECT
    COUNT(a.*),
    b.name
FROM
    country a
    RIGHT JOIN continent b on a.continent = b.code
GROUP BY
    b.name
ORDER BY
    1 ASC;