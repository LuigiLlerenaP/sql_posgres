-- Active: 1716520831018@@127.0.0.1@5432@mediumDB
-- nombre de la tabla en memoria 
-- podemos epecificar que campos vamos a querer
WITH RECURSIVE count_down (val) AS (
    --Inicialización => valor inicial 
    VALUES
        (10)
    UNION
    -- Query recursivo 
    SELECT
        val -1
    FROM
        count_down
    where
        val > 1
) -- select de los campos
SELECT
    *
FROM
    count_down;

-- Tarea
WITH RECURSIVE count_up(valInit) AS (
    VALUES
        (0)
    UNION
    SELECT
        valInit + 1
    FROM
        count_up
    WHERE
        valInit < 10
)
SELECT
    *
FROM
    count_up;

WITH RECURSIVE multiplication_table (base, i, rest) AS (
    -- Init multiplication_table
    VALUES
        (5, 1, 5)
    UNION
    -- recursive 
    SELECT
        base,
        i + 1,
        (i + 1) * base
    FROM
        multiplication_table
    WHERE
        i < 10
)
SELECT
    *
from
    multiplication_table;