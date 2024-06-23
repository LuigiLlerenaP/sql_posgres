-- 1. Crear una clave foránea en la tabla `city` que hace referencia a la tabla `country`
ALTER TABLE
    city
ADD
    CONSTRAINT fk_country_code FOREIGN KEY (countrycode) REFERENCES country (code);

ALTER TABLE
    countrylanguage
ADD
    CONSTRAINT fk_country_code FOREIGN KEY(countrycode) REFERENCES country (code);

-- 2. Verificar la existencia del código `AFG` en la tabla `country`
SELECT
    *
FROM
    country
WHERE
    code = 'AFG';

-- 3. Seleccionar todas las entradas de la tabla `city` con el código `AFG`
SELECT
    DISTINCT *
FROM
    city
WHERE
    countrycode = 'AFG'
ORDER BY
    name ASC;

SELECT
    *
FROM
    countrylanguage;