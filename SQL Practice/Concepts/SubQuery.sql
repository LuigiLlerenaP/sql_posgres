--! Una subconsulta es una consulta dentro de otra consulta. Se puede utilizar en varias partes de la consulta principal
--* como en las cláusulas SELECT, FROM, WHERE, HAVING, etc.
--// Tipos de Subconsultas:
-- *1. Subconsultas de una sola fila:
-- //Devuelven un solo valor (una fila con una columna).
-- //Se utilizan normalmente en cláusulas WHERE, HAVING, o como parte de una expresión.
-- *2. Subconsultas de múltiples filas:
-- //Devuelven múltiples filas y una columna.
-- //Se utilizan normalmente en cláusulas WHERE con operadores como IN, ANY, ALL.
-- *3. Subconsultas correlacionadas:
-- //La subconsulta depende de la fila de la consulta externa y se ejecuta para cada fila de la consulta externa.
-- //Sintaxis Básica
-- !Subconsulta en la cláusula WHERE:
SELECT
    *
FROM
    users
WHERE
    id IN (
        SELECT
            user_id
        FROM
            orders
        WHERE
            total > 100
    );

-- En este ejemplo, seleccionamos todos los usuarios que han hecho pedidos con un total superior a 100.
-- La subconsulta interna devuelve los user_id de la tabla orders donde el total es mayor que 100.
--! Subconsulta en la cláusula FROM:
SELECT
    avg_order.total_avg
FROM
    (
        SELECT
            user_id,
            AVG(total) AS total_avg
        FROM
            orders
        GROUP BY
            user_id
    ) AS avg_order;

-- En este ejemplo, la subconsulta calcula el promedio de los pedidos por usuario,
-- y la consulta externa selecciona el promedio total de pedidos.
-- !Subconsulta en la cláusula SELECT:
SELECT
    user_id,
    (
        SELECT
            COUNT(*)
        FROM
            orders
        WHERE
            orders.user_id = users.id
    ) AS order_count
FROM
    users;

-- En este ejemplo, la subconsulta cuenta el número de pedidos por usuario
-- y se incluye en la lista de selección de la consulta externa.
-- Ejemplos Sencillos
-- !Subconsulta con IN:
SELECT
    *
FROM
    products
WHERE
    category_id IN (
        SELECT
            id
        FROM
            categories
        WHERE
            name = 'Electronics'
    );

-- En este ejemplo, seleccionamos todos los productos que pertenecen a la categoría "Electronics".
--! Subconsulta con EXISTS:
SELECT
    *
FROM
    users u
WHERE
    EXISTS (
        SELECT
            1
        FROM
            orders o
        WHERE
            o.user_id = u.id
    );

-- En este ejemplo, seleccionamos todos los usuarios que han realizado al menos un pedido.
-- La subconsulta utiliza EXISTS para comprobar la existencia de pedidos correspondientes al usuario.