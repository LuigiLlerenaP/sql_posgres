-- Active: 1715738880073@@127.0.0.1@5432@playground-db
-- CREATE TABLE
CREATE TABLE USERS_CAR (
    USER_ID SERIAL,
    FIRSTNAME VARCHAR(100) NOT NULL,
    -- Column constraint 
    LASTNAME VARCHAR(100) NOT NULL,
    PRIMARY KEY (USER_ID) -- Table constraint
);

-- INSERT WITH COLUMN NAMES
INSERT INTO
    USERS_CAR (FIRSTNAME, LASTNAME)
VALUES
    ('John', 'Doe');

-- INSERT WITHOUT COLUMN NAMES
INSERT INTO
    USERS_CAR (FIRSTNAME, LASTNAME)
VALUES
    ('An', 'Llerena');

-- INSERT MULTIPLE VALUES
INSERT INTO
    USERS_CAR (FIRSTNAME, LASTNAME)
VALUES
    ('Roberto', 'Pena'),
    ('Gonzalo', 'Silva'),
    ('Fernando', 'Garcia');

--! UPDATE RECORDS
--// If I don't put the WHERE clause, I modify all records.
UPDATE
    USERS_CAR
SET
    FIRSTNAME = 'Pedro',
    LASTNAME = 'Padilla'
WHERE
    USER_ID = 5;

-- !SEE  RECORDS WITHE LIMIT 4 OFFSET 1
--* Muestra registros con un límite de 4 y un desplazamiento de 1
SELECT
    *
FROM
    USERS_CAR
LIMIT
    4 OFFSET 1;

-- !WHERE
--* Filtra registros basados en condiciones específicas
SELECT
    *
FROM
    USERS_CAR u
WHERE
    u.USER_ID = 3;

--! LIKE: QUE COINCIDA CON EL CARÁCTER
--// Busca registros que coincidan con un patrón específico
SELECT
    u.FIRSTNAME,
    u.LASTNAME
FROM
    USERS_CAR u
WHERE
    u.FIRSTNAME LIKE '%ohn'
    AND u.LASTNAME LIKE '_oe';

-- !DELETE RECORDS
--// Elimina registros de la tabla
--* Primero, buscamos qué registros eliminar
SELECT
    *
FROM
    USERS_CAR
WHERE
    USER_ID = 3;

DELETE FROM
    USERS_CAR
WHERE
    USER_ID = 3;

--! DROP TABLE
--// Elimina toda la estructura de la tabla junto con sus datos
DROP TABLE USERS_CAR;

-- !TRUNCATE TABLE
--// Elimina todos los registros de la tabla, pero mantiene la estructura
TRUNCATE TABLE USER_CARS;

--!  Eliminar una fila de la tabla
--* La cláusula DELETE se utiliza para eliminar filas de una tabla.
--* En este ejemplo, eliminamos la fila donde 'code' es 'NLD' y 'code2' es 'NA'.
DELETE FROM
    country
WHERE
    code = 'NLD'
    AND code2 = 'NA';