-- Active: 1716520831018@@127.0.0.1@5432@playground-db
-- !índice 
-- //Estructura de datos que se crea en una o más columnas de una tabla.
-- //Facilita la búsqueda rápida y eficiente de datos al crear una referencia ordenada de los valores en esas columnas.
-- //Los índices son especialmente útiles para mejorar el rendimiento de consultas y aplicaciones.
--*
-- Puede haber indices duplicados e indices únicos 
-- Tiene peso el crear indices por que tiene peso ya que se crea una referencia 
-- Aplicar el indice cuando se esta creando si ya hay registros se puede demorar muchos hasta agrupar 
SELECT
    *
FROM
    country
where
    continent = 'Africa';

CREATE UNIQUE INDEX "unique_country_name" on country(name);

CREATE INDEX "country_continent" on country(continent);

SELECT
    *
FROM
    city
where
    name = 'Jinzhou'
    AND countrycode = 'CHN'
    AND district = 'Liaoning';

UPDATE
    city
SET
    name = 'Jinzhou Old'
WHERE
    id = 1944;

--! Indice compuesto
CREATE UNIQUE INDEX "unique_name_countrycode_district" ON city(name, countrycode, district);

CREATE INDEX "index_district" ON city (district);