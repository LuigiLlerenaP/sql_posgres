-- !Consideraciones para usar UNION en SQL:
-- *1. Mismo número de columnas.
-- *2. Tipos de datos compatibles.
-- *3. Elimina duplicados (usar UNION ALL para incluir duplicados).
-- //Ejemplo de uso:
SELECT
    * -- Selecciona todas las columnas
FROM
    continent
WHERE
    name LIKE '%America' -- Filtra continentes que contienen 'America'
UNION
SELECT
    * -- Selecciona todas las columnas
FROM
    continent
WHERE
    code IN (3, 4) -- Filtra continentes con código 3 o 4
ORDER BY
    name ASC;

-- Ordena el resultado por nombre ascendente