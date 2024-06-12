SELECT
    *
FROM
    countrylanguage
WHERE
    isofficial IS TRUE;

SELECT
    *
FROM
    country;

SELECT
    *
FROM
    continent;

-- !Cuales idiomas se hablan en los continentes
SELECT
    DISTINCT a."language",
    c."name"
FROM
    countrylanguage a
    INNER JOIN country b ON a.countrycode = b.code
    INNER JOIN continent c ON b.continent = c.code
WHERE
    a.isofficial = TRUE;

-- ! Cuantos idiomas
SELECT
    COUNT(*),
    continent
FROM
    (
        SELECT
            DISTINCT a."language",
            c."name" AS continent
        FROM
            countrylanguage a
            INNER JOIN country b ON a.countrycode = b.code
            INNER JOIN continent c ON b.continent = c.code
        WHERE
            a.isofficial = TRUE
    ) as TOTALES
GROUP BY
    2;

--!
SELECT
    DISTINCT a."language",
    d.name,
    c."name"
FROM
    countrylanguage a
    INNER JOIN country b ON a.countrycode = b.code
    INNER JOIN continent c ON b.continent = c.code
    INNER JOIN "language" d ON d.code = a.languagecode
WHERE
    a.isofficial = TRUE