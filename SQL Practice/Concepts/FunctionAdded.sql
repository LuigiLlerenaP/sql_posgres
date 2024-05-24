-- !! BETWEEN
-- // Filtra los resultados para que incluyan solo los registros cuyo valor en una columna específica se encuentra dentro de un rango.
-- * Ejemplo: SELECT * FROM users WHERE followers BETWEEN 4601 AND 4700;
-- !! ORDER BY
-- // Ordena los resultados de la consulta en un orden específico, ya sea ascendente (ASC) o descendente (DESC).
-- * Ejemplo: SELECT * FROM users ORDER BY followers DESC;
-- !! MAX
-- // Devuelve el valor máximo de una columna específica. Es útil para encontrar el valor más alto en un conjunto de datos.
-- * Ejemplo: SELECT MAX(followers) AS "Max Followers" FROM users;
-- !! MIN
-- // Devuelve el valor mínimo de una columna específica. Es útil para encontrar el valor más bajo en un conjunto de datos.
-- * Ejemplo: SELECT MIN(followers) AS "MIN Followers" FROM users;
-- !! ROUND
-- // Redondea un valor numérico a un número específico de decimales. Es útil para presentar datos de manera más legible.
-- * Ejemplo: SELECT ROUND(AVG(followers)) AS "Round Avg" FROM users;
-- !! AVG
-- // Calcula el valor promedio de una columna numérica. Es útil para encontrar la media aritmética de un conjunto de datos.
-- * Ejemplo: SELECT AVG(followers) AS "Avg Followers" FROM users;
-- !! GROUP BY
-- // Agrupa los resultados de una consulta basándose en una o más columnas. Es útil para agregar datos y obtener estadísticas resumidas para cada grupo.
-- // Cada grupo contiene las filas que tienen los mismos valores en las columnas especificadas.
-- // Después de agrupar los datos, se pueden aplicar funciones de agregado como COUNT, SUM, AVG, MAX, y MIN para obtener estadísticas resumidas de cada grupo.
-- // Es importante que todas las columnas en la cláusula SELECT que no son parte de una función de agregado estén incluidas en la cláusula GROUP BY.
-- * Ejemplo: SELECT country, COUNT(*) FROM users GROUP BY country;
-- !! HAVING
-- // La cláusula HAVING se utiliza en combinación con la cláusula GROUP BY para filtrar los resultados de las funciones de agregación.
-- // Mientras que la cláusula WHERE filtra las filas antes de que se realice la agregación, la cláusula HAVING filtra después de que se realiza la agregación.
-- // Esto significa que puedes utilizar la cláusula HAVING para filtrar los resultados basándote en una condición que se aplica a una función de agregación.
-- * Ejemplo: SELECT country, COUNT(*) FROM users GROUP BY country HAVING COUNT(*) > 5;
-- !! DISTINCT
-- // La cláusula DISTINCT en SQL se utiliza para eliminar duplicados de los resultados de una consulta.
-- // Se puede usar con SELECT para retornar solo valores únicos en los resultados.
-- // Es útil cuando quieres saber qué valores únicos existen en una columna o conjunto de columnas.
-- * Ejemplo: SELECT DISTINCT country FROM users;
-- Consulta para filtrar por seguidores
SELECT
    usr.first_name,
    -- * Selecciona el primer nombre del usuario
    usr.last_name,
    -- * Selecciona el apellido del usuario
    usr.followers,
    -- * Selecciona el número de seguidores del usuario
    usr.following -- * Selecciona el número de personas que el usuario sigue
FROM
    users AS usr -- * Indica la tabla 'users' con un alias 'usr'
WHERE
    usr.followers BETWEEN 4601
    AND 4700 -- * Filtra los usuarios con entre 4601 y 4700 seguidores
ORDER BY
    usr.followers DESC;

-- * Ordena los resultados por número de seguidores en orden descendente
-- Consulta para obtener estadísticas de seguidores
SELECT
    COUNT(usr.*) AS "Total Users",
    -- * Cuenta el número total de usuarios
    MIN(usr.followers) AS "MIN Followers",
    -- * Encuentra el número mínimo de seguidores
    MAX(usr.followers) AS "Max Followers",
    -- * Encuentra el número máximo de seguidores
    AVG(usr.followers) AS "Avg Followers",
    -- * Calcula el promedio de seguidores
    SUM(usr.followers) / COUNT(*) AS "Avg Manual",
    -- * Calcula manualmente el promedio de seguidores
    ROUND(AVG(usr.followers)) AS "Round Avg" -- * Redondea el promedio de seguidores
FROM
    users AS usr;

-- * Indica la tabla 'users' con un alias 'usr'
-- Consulta para agrupar por número de seguidores
SELECT
    COUNT(*),
    -- * Cuenta el número de usuarios
    usr.followers -- * Selecciona el número de seguidores
FROM
    users AS usr -- * Indica la tabla 'users' con un alias 'usr'
WHERE
    usr.followers BETWEEN 4500
    AND 4999 -- * Filtra los usuarios con entre 4500 y 4999 seguidores
GROUP BY
    usr.followers -- * Agrupa los resultados por el número de seguidores
ORDER BY
    usr.followers DESC;

--  Consulta para agrupar usuarios por país y filtrar por conteo de usuarios
SELECT
    COUNT(*) AS user_count,
    -- * Cuenta el número de usuarios en cada país y lo nombra como 'user_count'
    usr.country -- * Selecciona el país del usuario
FROM
    users AS usr -- * Indica la tabla 'users' con un alias 'usr'
GROUP BY
    usr.country -- * Agrupa los resultados por el país del usuario
HAVING
    COUNT(*) BETWEEN 3
    AND 7 -- * Filtra los países que tienen entre 3 y 7 usuarios
ORDER BY
    user_count ASC;

SELECT
    DISTINCT u.country --*Elimina los países repetidos y devuelve valores únicos 
FROM
    users u;

SELECT
    SUBSTRING(
        u.email
        FROM
            '@(.+)$'
    ) AS email_domain_substring,
    -- Extrae el dominio del correo electrónico
    COUNT(*) AS users_per_domain -- Cuenta el número de usuarios para cada dominio
FROM
    users u -- Indica la tabla 'users' con un alias 'u'
GROUP BY
    email_domain_substring -- Agrupa los resultados por el dominio del correo electrónico
HAVING
    COUNT(*) > 1 -- Filtra los dominios que tienen más de un usuario
ORDER BY
    users_per_domain DESC;

-- Ordena los resultados por el número de usuarios en orden descendente