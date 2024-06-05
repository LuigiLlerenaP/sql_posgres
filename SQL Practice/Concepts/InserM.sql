--! Insertar datos en la tabla "continent" desde la tabla "country"
--// Utilizamos la cláusula SELECT para obtener los valores únicos de la columna "continent" de la tabla "country".
INSERT INTO
    continent (name)
SELECT
    DISTINCT c.continent
FROM
    country c
ORDER BY
    1 ASC;

-- // Insertar todos los registro en los campos de otra tabla
INSERT INTO
    country_old
SELECT
    *
FROM
    country
ORDER BY
    1 ASC;

ALTER TABLE
    country DROP CONSTRAINT "country_continent_check";

SELECT
    a.name,
    a.continent,
    (
        SELECT
            "code"
        FROM
            continent b
        WHERE
            b."name" = a.continent
    )
FROM
    country a;

--!Update
UPDATE
    country a
SET
    continent = (
        SELECT
            "code"
        FROM
            continent b
        WHERE
            b."name" = a.continent
    );

ALTER TABLE
    country
ALTER COLUMN
    continent TYPE int4 USING continent :: integer;