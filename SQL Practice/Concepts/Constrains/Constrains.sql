-- Agregar una restricción de clave primaria (Primary Key Constraint)
-- Una clave primaria es un campo (o combinación de campos) que identifica de manera única cada fila en una tabla.
-- Cada tabla puede tener solo una clave primaria, y esta no puede contener valores nulos.
ALTER TABLE
    country
ADD
    PRIMARY KEY (code);

-- Restricción CHECK
-- Garantiza que los valores en una columna cumplan una condición específica.
ALTER TABLE
    country
ADD
    CHECK (surfacearea >= 0);

-- Restricción CHECK múltiple
-- Verifica si el valor de la columna "continent" está dentro de una lista específica (Asia, Sudamérica, Norteamérica, Europa, África, Australia, Oceanía o Antártida).
ALTER TABLE
    country
ADD
    CHECK (
        (continent = 'Asia' :: TEXT)
        OR (continent = 'South America' :: TEXT)
        OR (continent = 'North America' :: TEXT)
        OR (continent = 'Europe' :: TEXT)
        OR (continent = 'Africa' :: TEXT)
        OR (continent = 'Australia' :: TEXT)
        OR (continent = 'Oceania' :: TEXT)
        OR (continent = 'Antarctica' :: TEXT)
        OR (continent = 'Central America' :: TEXT)
    );

-- Borrar restricción
-- Si necesito modificar algo, primero debes eliminar la restricción existente y luego volver a crearla con las modificaciones necesarias.
-- Reemplaza "nombre_de_la_restricción" con el nombre real de la restricción que deseas eliminar.
ALTER TABLE
    country DROP CONSTRAINT "country_continent_check";

-- Consulta y actualización
-- Selecciona todos los registros de la tabla "country" con el código 'CRI':
SELECT
    *
FROM
    country
WHERE
    code = 'CRI';

-- Cambia el nombre a 'Central America' donde el código es 'CRI':
UPDATE
    country
SET
    continent = 'Central America'
WHERE
    code = 'CRI';

-- Consultar restricciones de la tabla:
-- Para ver los nombres de las restricciones en la tabla "country":
SELECT
    CONSTRAINT_NAME
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE
    TABLE_NAME = 'country';