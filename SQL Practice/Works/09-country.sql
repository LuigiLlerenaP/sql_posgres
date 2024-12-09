-- El país con mas ciudades
-- Total : ciudades  , Nombre: país
--! Step one  
SELECT
    *
FROM
    country
WHERE
    code = 'CHN';

SELECT
    *
FROM
    city
WHERE
    id = 594;

SELECT
    count(*),
    countrycode
FROM
    city
GROUP BY
    2
ORDER BY
    1 DESC;

--! Step two
SELECT
    *
FROM
    country a
    INNER JOIN city b ON a.capital = b.id
ORDER BY
    1 ASC;

---
SELECT
    count(*),
    b.name as "Country"
FROM
    city a
    INNER JOIN country b ON a.countrycode = b.code
GROUP BY
    2
ORDER BY
    1 DESC;