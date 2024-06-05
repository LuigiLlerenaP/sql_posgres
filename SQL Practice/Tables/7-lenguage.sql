-- Active: 1716520831018@@127.0.0.1@5432@playground-db
-- Tarea con countryLanguage
-- Crear la tabla de language
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;

-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT nextval('language_code_seq' :: regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE
    countrylanguage
ADD
    COLUMN languagecode varchar(3);

-- Empezar con el select para confirmar lo que vamos a 
SELECT
    DISTINCT "language"
FROM
    countrylanguage
ORDER BY
    "language";

INSERT INTO
    "language" (name)
SELECT
    DISTINCT "language"
FROM
    countrylanguage
ORDER BY
    "language" ASC;

SELECT
    *
FROM
    city;

DELETE FROM
    city
WHERE
    id = 7;

-- Actualizar todos los registros
-- Cambiar tipo de dato en countrylanguage - language code por int4
-- Crear el foreign key y constraints de no nulo el language_code
-- Revisar lo creado