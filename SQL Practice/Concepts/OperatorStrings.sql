-- Active: 1715738880073@@127.0.0.1@5432
--
SELECT
    user_id,
    UPPER(first_name) AS "upper_name",
    LOWER(last_name) AS "lower_name",
    LENGTH (email) AS "LENGTH",
    (20 / 2) AS "Constante",
    CONCAT_WS ('=', first_name, last_name) AS "Full Name",
    -- El inicio es el separador que tendrán todos
    CONCAT (first_name, ' ', last_name) AS "Full Name 2"
FROM
    users;

SELECT
    *
FROM
    users;

SELECT
    u.last_name,
    -- Selecciona los primeros cuatro caracteres del apellido
    SUBSTRING(u.last_name, 1, 4) AS first_four_characters,
    -- Encuentra la posición de 'B' en el apellido
    POSITION('B' IN u.last_name) AS position_of_B,
    -- Selecciona el apellido hasta la primera ocurrencia de 'y'
    SUBSTRING(
        u.last_name,
        1,
        CASE
            WHEN POSITION('y' IN u.last_name) > 0 THEN POSITION('y' IN u.last_name)
            ELSE LENGTH (u.last_name)
        END
    ) AS last_name_until_y,
    -- Selecciona el primer nombre hasta la primera ocurrencia de 'm'
    SUBSTRING(
        u.first_name,
        1,
        CASE
            WHEN POSITION('m' IN u.first_name) > 0 THEN POSITION('m' IN u.first_name)
            ELSE LENGTH (u.first_name)
        END
    ) AS first_name_until_m
FROM
    users AS u;

-- Modificación de tabla existente y agregar una columna
ALTER TABLE
    users
ADD
    COLUMN nickname VARCHAR(100);

--Modificación de tabla existente y agregar una constrain a un campo 
ALTER TABLE
    users
ADD
    CONSTRAINT unique_nickname UNIQUE(nickname);

-- 1. Eliminar la restricción de unicidad existente
ALTER TABLE
    users DROP CONSTRAINT unique_nickname;

SELECT
    CONCAT_WS(
        '$',
        SUBSTRING(first_name, 1, POSITION('e' IN first_name)),
        SUBSTRING(first_name, 1, POSITION('a' IN first_name)),
        SUBSTRING(last_name, 3, POSITION('e' IN last_name))
    )
FROM
    users;

UPDATE
    users
SET
    nickname = CONCAT_WS(
        '$',
        SUBSTRING(first_name, 1, POSITION('e' IN first_name)),
        SUBSTRING(first_name, 1, POSITION('a' IN first_name)),
        SUBSTRING(last_name, 3, POSITION('e' IN last_name))
    );

SELECT
    *
FROM
    USERS;