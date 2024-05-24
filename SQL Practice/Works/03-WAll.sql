-- 1. Cuantos usuarios tenemos con cuentas @google.com
-- Tip: count, like
SELECT
    COUNT(*) AS users_has_domain,
    SUBSTRING(
        u.email
        FROM
            '@(.+)$'
    ) AS domain_user
FROM
    users AS u
WHERE
    u.email LIKE '%google.com'
GROUP BY
    2;

-- 2. De qué países son los usuarios con cuentas de @google.com
-- Tip: distinct
SELECT
    DISTINCT u.country AS "COUNTRY" COUNT(u.country) AS "NUM_USERS"
FROM
    users AS u
WHERE
    u.email LIKE '%@google.com'
GROUP BY
    1;

-- 3. Cuantos usuarios hay por país (country)
-- Tip: Group by
SELECT
    COUNT(*) AS "TOTAL_USERS",
    u.country AS "COUNTRY"
FROM
    users AS u
GROUP BY
    2;

-- 4. Listado de direcciones IP de todos los usuarios de Iceland
-- Campos requeridos first_name, last_name, country, last_connection
SELECT
    u.first_name,
    u.last_name,
    u.country,
    u.last_connection
FROM
    users u
WHERE
    u.country = 'Iceland';

-- 5. Cuantos de esos usuarios (query anterior) tiene dirección IP
-- que inicia en 112.XXX.XXX.XXX
SELECT
    COUNT(*) AS total_ip
FROM
    users u
WHERE
    u.country = 'Iceland'
    AND u.last_connection like '112.%';

-- 6. Listado de usuarios de Iceland, tienen dirección IP
-- que inicia en 112 ó 28 ó 188
-- Tip: Agrupar condiciones entre paréntesis 
SELECT
    u.first_name,
    u.last_name,
    u.country,
    u.last_connection
FROM
    users u
WHERE
    u.country = 'Iceland'
    AND u.last_connection like '112.%'
    OR u.last_connection like '28%'
    OR u.last_connection like '188%';

-- 7. Ordene el resultado anterior, por apellido (last_name) ascendente
-- y luego el first_name ascendentemente también 
SELECT
    u.first_name,
    u.last_name,
    u.country,
    u.last_connection
FROM
    users u
WHERE
    u.country = 'Iceland'
    AND (
        u.last_connection like '112.%'
        OR u.last_connection like '28%'
        OR u.last_connection like '188%'
    )
ORDER BY
    2 ASC,
    1 DESC;

-- 8. Listado de personas cuyo país está en este listado
-- ('Mexico', 'Honduras', 'Costa Rica')
-- Ordenar los resultados de por País asc, Primer nombre asc, apellido asc
-- Tip: Investigar IN
SELECT
    first_name,
    last_name,
    country
FROM
    users
WHERE
    country IN ('Mexico', 'Honduras', 'Costa Rica')
ORDER BY
    1 ASC,
    2 ASC,
    3 ASC;

-- Tip2: Ver Operadores de Comparación en la hoja de atajos (primera página)
-- 9. Del query anterior, cuente cuántas personas hay por país
-- Ordene los resultados por País asc
SELECT
    country,
    COUNT(country) AS total_users_by_country
FROM
    users
WHERE
    country IN ('Mexico', 'Honduras', 'Costa Rica')
GROUP BY
    country
ORDER BY
    1 ASC;