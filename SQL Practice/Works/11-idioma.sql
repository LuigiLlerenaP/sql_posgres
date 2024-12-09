select
    *
from
    countrylanguage
where
    isofficial = true;

select
    *
from
    country;

select
    *
from
    continent;

Select
    *
from
    "language";

-- ¿Cuál es el idioma (y código del idioma) oficial más hablado por diferentes países en Europa?
---
SELECT
    COUNT(b.*),
    b."language",
    b.languagecode
FROM
    country a
    INNER JOIN countrylanguage b ON a.code = b.countrycode
WHERE
    a.continent = 5
    AND b.isofficial = true
GROUP BY
    2,
    3
ORDER BY
    1 DESC
LIMIT
    1;

-- Listado de todos los países cuyo idioma oficial es el más hablado de Europa 
-- (no hacer subquery, tomar el código anterior)
SELECT
    *
FROM
    country a
    INNER JOIN countrylanguage b ON a.code = b.countrycode
WHERE
    a.continent = 5
    AND b.isofficial = true
    AND b.languagecode = 135;