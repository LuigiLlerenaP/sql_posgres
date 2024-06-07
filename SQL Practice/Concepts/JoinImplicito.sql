-- !JOIN implícito:
-- *Combina filas de dos o más tablas basado en una condición.
SELECT
    -- Selecciona el nombre del país
    a.name AS "Country Name",
    b.name AS "Continent Name" -- Selecciona el nombre del continente
FROM
    country a,
    -- Tabla de países
    continent b -- Tabla de continentes
WHERE
    a.continent = b.code -- Relaciona país y continente por código
ORDER BY
    2;

-- Ordena el resultado por la segunda columna (nombre del continente)