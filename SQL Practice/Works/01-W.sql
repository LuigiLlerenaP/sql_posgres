-- 1. Ver todos los registros
SELECT * FROM users;

-- 2. Ver el registro cuyo iP sea igual a 253.91.185.145
SELECT
    u.first_name as "FIRST_NAME",
    u.last_name as "LAST_NAME",
    u.IP_ADDRESS AS "IP_ADDRESS"
FROM users u
WHERE
    u.ip_address = '253.91.185.145';
-- 3. Escribe una consulta SQL para seleccionar todos los usuarios cuyos nombres empiezan con 'A' y
--    cuyos apellidos contienen 'an' en cualquier parte de ellos
SELECT u.first_name as "FIRST_NAME", u.last_name as "LAST_NAME"
FROM users u
WHERE
    u.first_name LIKE 'A%'
    AND u.last_name LIKE '%an%';

-- 4. Escribe una consulta SQL para seleccionar todos los usuarios cuyas direcciones de correo electrónico terminen con ".com"
-- y cuya dirección IP comience con "2".
SELECT
    CONCAT_WS(
        ' ',
        u.first_name,
        u.last_name
    ) AS "FULL NAME",
    u.email as "EMAIL",
    u.ip_address as "IP_ADDRESS"
FROM users u
WHERE
    u.email LIKE '%.com'
    AND u.ip_address like '2%';

-- 5. Cambiar el nombre del registro con id = '829820dc-44ea-4a39-8a80-9f6e642782ed', por tu nombre Ej:'Fernando Herrera'
SELECT *
FROM users
WHERE
    user_id = 'f4204e65-6bcd-40ae-8ab4-a08b50b41ca3';

UPDATE users
SET
    first_name = 'Fernando',
    last_name = 'Herrera'
WHERE
    user_id = '9faa6790-6c6b-419f-9b5b-dc63ab8bde75';

-- 6. Borrar el último registro de la tabla Auto incremental
DELETE FROM users WHERE user_id = ( SELECT MAX(user_id) FROM users );