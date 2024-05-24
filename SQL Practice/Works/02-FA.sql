-- //Nombre, apellido e IP,
--  //donde la última conexión se dió de 221.XXX.XXX.XXX
SELECT
    u.first_name,
    u.last_name,
    u.last_connection
FROM
    users u
WHERE
    u.last_connection LIKE '221.%';

-- //Nombre, apellido y seguidores(followers) de todos 
--  //a los que lo siguen más de 4600 personas
SELECT
    u.first_name,
    u.last_name,
    u.followers,
    u.following
FROM
    users u
WHERE
    u.followers >= 4601;