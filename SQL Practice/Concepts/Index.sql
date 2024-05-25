-- !índice 
-- //Estructura de datos que se crea en una o más columnas de una tabla.
-- //Facilita la búsqueda rápida y eficiente de datos al crear una referencia ordenada de los valores en esas columnas.
-- //Los índices son especialmente útiles para mejorar el rendimiento de consultas y aplicaciones.
--*
-- Puede haber indices duplicados e indices únicos 
-- Tiene peso el crear indices por que tiene peso ya que se crea una referencia 
-- Aplicar el indice cuando se esta creando si ya hay registros se puede demorar muchos hasta agrupar 
SELECT
    *
FROM
    country;

CREATE UNIQUE INDEX "unique_country_name" on country(name);