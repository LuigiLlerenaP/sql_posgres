--! ------------------------------------------
--! UUIDs en PostgreSQL
--! ------------------------------------------
--* DESCRIPCIÓN DE LA SINTAXIS:
--* UUID (Universally Unique Identifier): es un identificador único globalmente que puede ser generado tanto por el cliente como por el servidor.
--* Los UUIDs son útiles para asegurar la unicidad de registros, incluso en bases de datos distribuidas.
--* VENTAJAS DE LOS UUIDs:
--* 1. Unicidad global: cada UUID es único en todo el mundo.
--* 2. Generación del lado del cliente: permite crear registros con IDs únicos antes de enviarlos al servidor.
--* 3. Seguridad: los UUIDs son difíciles de adivinar, aumentando la seguridad de los identificadores.
--* FUNCIONES PARA GENERAR UUIDs:
--* gen_random_uuid(): genera un UUID aleatorio usando la función nativa de PostgreSQL.
--* uuid_generate_v4(): genera un UUID aleatorio usando la función proporcionada por la extensión "uuid-ossp".
--! Ejemplo de generación de UUIDs:
SELECT
    gen_random_uuid(),
    --* Genera un UUID aleatorio usando la función nativa de PostgreSQL.
    uuid_generate_v4();

--* Genera un UUID aleatorio usando la función de la extensión "uuid-ossp".
--! Instalación de la extensión "uuid-ossp" para generar UUIDs:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--* Instala la extensión "uuid-ossp" si no está instalada.
--! Eliminación de la extensión "uuid-ossp":
DROP EXTENSION "uuid-ossp";

--* Elimina la extensión "uuid-ossp".
--! Creación de una tabla con una columna UUID:
CREATE TABLE "users_five"(
    "user_id" UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    --! ID único generado automáticamente usando UUID versión 4.
    "username" VARCHAR(100) --! Nombre de usuario.
);

--! RESUMEN:
--* Los UUIDs son ideales para garantizar la unicidad de registros en entornos distribuidos.
--* PostgreSQL ofrece funciones nativas y de extensiones para generar UUIDs.
--* La extensión "uuid-ossp" proporciona funciones adicionales para la generación de UUIDs.