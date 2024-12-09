-- Active: 1716520831018@@127.0.0.1@5432@M2DB
-- 1. ¿Cuántos Post hay? - 1050
SELECT
    COUNT(*)
FROM
    posts;

-- 2. ¿Cuántos Post publicados hay? - 543
SELECT
    COUNT(a.published)
FROM
    posts a
WHERE
    a.published IS NOT FALSE;

-- 3. ¿Cuál es el Post más reciente?
SELECT
    a.title,
    a.created_at
FROM
    posts a
ORDER BY
    2 DESC
LIMIT
    1;

-- 544 - nisi commodo officia...2024-05-30 00:29:21.277
-- 4. Quiero los 10 usuarios con más posts, cantidad de posts, id y nombre
SELECT
    COUNT(b.created_by),
    a.NAME,
    a.user_id
FROM
    users a
    INNER JOIN posts b ON a.user_id = b.created_by
GROUP BY
    3
ORDER BY
    1 DESC
LIMIT
    10;

/*
 4    1553    Jessie Sexton
 3    1400    Prince Fuentes
 3    1830    Hull George
 3    470     Traci Wood
 3    441     Livingston Davis
 3    1942    Inez Dennis
 3    1665    Maggie Davidson
 3    524     Lidia Sparks
 3    436     Mccoy Boone
 3    2034    Bonita Rowe
 */
-- 5. Quiero los 5 posts con más "Claps" sumando la columna "counter"
/*
 */
SELECT
    SUM(counter),
    b.title
FROM
    claps a
    INNER JOIN posts b ON a.post_id = b.post_id
GROUP BY
    2
ORDER BY
    1 DESC
LIMIT
    5;

-- 6. Top 5 de personas que han dado más claps (voto único no acumulado) *count
/*
 7    Lillian Hodge
 6    Dominguez Carson
 6    Marva Joyner
 6    Lela Cardenas
 6    Rose Owen
 */
SELECT
    COUNT(b.counter),
    a.name
FROM
    users a
    INNER JOIN claps b ON a.user_id = b.user_id
GROUP BY
    2
ORDER BY
    1 DESC
LIMIT
    5;

-- 7. Top 5 personas con votos acumulados (sumar counter)
/*
 437    Rose Owen
 394    Marva Joyner
 386    Marquez Kennedy
 379    Jenna Roth
 364    Lillian Hodge
 */
SELECT
    SUM(b.counter),
    a.name
FROM
    users a
    INNER JOIN claps b ON a.user_id = b.user_id
GROUP BY
    2
ORDER BY
    1 DESC
LIMIT
    5;

-- 8. ¿Cuántos usuarios NO tienen listas de favoritos creadas?
-- 329
SELECT
    COUNT(b)
FROM
    user_lists a FULL
    OUTER JOIN users b ON a.user_id = b.user_id
WHERE
    a.user_id IS NULL
    OR b.user_id IS NULL;

-- 9. Quiero el comentario con id 
-- Y en el mismo resultado, quiero sus respuestas (visibles e invisibles)
-- Tip: union
/*
 1       648    1905    elit id...
 3058    583    1797    tempor mollit...
 4649    51     1842    laborum mollit...
 4768    835    1447    nostrud nulla...
 */
SELECT
    a.comment_id,
    a.post_id,
    a.user_id,
    a.content,
    a.visible
from
    comments a
WHERE
    a.comment_id = 1
UNION
SELECT
    a.comment_id,
    a.post_id,
    a.user_id,
    a.content,
    a.visible
from
    comments a
WHERE
    a.comment_parent_id = 1;

-- ** 10. Avanzado
-- Investigar sobre el json_agg y json_build_object
-- Crear una única línea de respuesta, con las respuestas
-- del comentario con id 1 (comment_parent_id = 1)
-- Mostrar el user_id y el contenido del comentario
-- Salida esperada:
SELECT
    -- json_agg(comment_id)
    -- json_build_object(
    --     'user',
    --     a.user_id,
    --     'content',
    --     a.content
    -- )
    json_agg(
        json_build_object(
            'user',
            a.user_id,
            'content',
            a.content
        )
    )
FROM
    comments a
where
    comment_parent_id = 1;

-- ** 11. Avanzado
-- Listar todos los comentarios principales (no respuestas) 
-- Y crear una columna adicional "replies" con las respuestas en formato JSON
SELECT
    a.*,
    (
        SELECT
            json_agg(
                json_build_object(
                    'user',
                    b.user_id,
                    'content',
                    b.content
                )
            )
        FROM
            comments b
        WHERE
            b.comment_parent_id = a.comment_id
    ) AS replies
FROM
    comments a
WHERE
    a.comment_parent_id IS NULL;