--! ------------------------------------------
--! Llave Primaria Compuesta en PostgreSQL
--! ------------------------------------------
--* DESCRIPCIÓN DE LA SINTAXIS:
--* Llave primaria compuesta: es una llave primaria que se compone de dos o más columnas. Garantiza la unicidad de los registros en combinación.
--* Las llaves primarias compuestas son útiles cuando se necesita asegurar la unicidad basada en múltiples columnas.
--* VENTAJAS DE LAS LLAVES PRIMARIAS COMPUESTAS:
--* 1. Unicidad: asegura que cada combinación de valores en las columnas especificadas sea única.
--* 2. Integridad referencial: ayuda a mantener la integridad de los datos en tablas relacionadas.
--* 3. Flexibilidad: permite crear relaciones más complejas entre tablas.
--! Ejemplo de creación de una tabla con una llave primaria compuesta:
CREATE TABLE "userDual"(
    "user_id" INT,
    --* Identificador del usuario.
    "user_name" INT,
    --* Nombre del usuario.
    "date_create" DATE,
    --* Fecha de creación del registro.
    PRIMARY KEY ("user_id", "user_name", "date_create") --! Llave primaria compuesta por las columnas user_id, user_name y date_create.
);

--* EXPLICACIÓN DE LA LLAVE PRIMARIA COMPUESTA:
--* 1. La combinación de "user_id", "user_name" y "date_create" debe ser única en toda la tabla.
--* 2. Esto asegura que no puedan existir dos registros con los mismos valores en estas tres columnas.
--* 3. Cada vez que se inserta un registro, se verifica la combinación de estas columnas para garantizar la unicidad.
--! RESUMEN:
--* Las llaves primarias compuestas son útiles para asegurar la unicidad de registros en base a múltiples columnas.
--* Garantizan la integridad de los datos y permiten relaciones más complejas entre tablas.