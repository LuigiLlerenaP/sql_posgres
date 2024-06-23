--! ------------------------------------------
--! Secuencias en PostgreSQL
--! ------------------------------------------
--* DESCRIPCIÓN DE LA SINTAXIS:
--* Las secuencias permiten generar números de forma correlativa, similar a la funcionalidad de IDENTITY.
--* Por defecto, las secuencias comienzan en uno, pero también pueden ser cíclicas.
--* VENTAJAS DE LAS SECUENCIAS:
--* 1. Generación automática de números secuenciales.
--* 2. Flexibilidad para definir el valor inicial, el incremento y si es cíclica o no.
--* 3. Utilización en múltiples tablas y columnas.
--! Crear una secuencia:
CREATE SEQUENCE user_sequence;

--* Crea una secuencia llamada 'user_sequence' que empieza en 1 por defecto.
--! Eliminar una secuencia:
DROP SEQUENCE user_sequence;

--* Elimina la secuencia 'user_sequence'.
--* USO DE SECUENCIAS:
--* NEXTVAL: genera el siguiente valor en la secuencia.
--* CURRVAL: devuelve el valor actual de la secuencia en la sesión.
--* Ejemplo de uso de NEXTVAL y CURRVAL:
SELECT
    NEXTVAL('user_sequence'),
    --* Genera el siguiente valor en la secuencia 'user_sequence'.
    CURRVAL('user_sequence');

--* Devuelve el valor actual de la secuencia 'user_sequence' en la sesión.
--* EXPLICACIÓN DETALLADA:
--* 1. NEXTVAL('user_sequence'): incrementa la secuencia y devuelve el nuevo valor.
--* 2. CURRVAL('user_sequence'): devuelve el último valor generado por NEXTVAL en la sesión. Debe haberse llamado a NEXTVAL al menos una vez antes de usar CURRVAL.
--! Ejemplo de uso de secuencias en una tabla:
CREATE TABLE "users_six"(
    "user_id" INTEGER PRIMARY KEY DEFAULT NEXTVAL('user_sequence'),
    --* Utiliza la secuencia 'user_sequence' para generar IDs únicos.
    "username" VARCHAR(100) --* Nombre de usuario.
);

--* RESUMEN:
--* Las secuencias son útiles para generar valores únicos y secuenciales en columnas.
--* Se pueden personalizar para definir el valor inicial, el incremento y si se deben reiniciar cíclicamente.
--* Las funciones NEXTVAL y CURRVAL permiten interactuar con las secuencias para obtener y visualizar valores.