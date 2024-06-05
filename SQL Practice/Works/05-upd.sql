--!Insertamos registros a la tabla lenguaje con los datos de la tabla country language
language
INSERT INTO
    "language"(name)
SELECT
    DISTINCT "language"
FROM
    countrylanguage
ORDER BY
    1;

SELECT
    *
FROM
    "language";

--!Empezar con el select para configurar lo que  se actualizara 
SELECT
    "language",
    (
        SELECT
            code
        from
            "language" b
        WHERE
            a."language" = b.name
    )
FROM
    countrylanguage a;

--! Actualizar todos los registros 
UPDATE
    countrylanguage a
SET
    languagecode = (
        SELECT
            code
        from
            "language" b
        WHERE
            a."language" = b.name
    );

--!Cambiar tipo de dato en countrylanguage
ALTER TABLE
    countrylanguage
ALTER COLUMN
    languagecode Type int4 USING languagecode :: INTEGER;

SELECT
    *
FROM
    "language";

--!Crear fk y constrain no null
ALTER TABLE
    countrylanguage
ADD
    CONSTRAINT fk_country_code FOREIGN KEY (languagecode) REFERENCES language(code);

ALTER TABLE
    countrylanguage
ALTER COLUMN
    languagecode
SET
    NOT NULL;