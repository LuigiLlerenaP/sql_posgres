-- Definición de una consulta recursiva para encontrar todos los jefes de un empleado específico
WITH RECURSIVE bosses AS (
    -- Parte inicial: selecciona el empleado con id = 6 (puede ser cualquier id específico)
    SELECT
        id,
        -- Selecciona el id del empleado
        name,
        -- Selecciona el nombre del empleado
        report_to -- Selecciona el id del jefe inmediato de este empleado
    FROM
        employees -- Desde la tabla de empleados
    WHERE
        id = 6 -- Condición inicial: busca el empleado con id = 6
    UNION
    -- Parte recursiva: encuentra los jefes de los empleados seleccionados en la parte inicial o en la iteración previa
    SELECT
        employees.id,
        -- Selecciona el id del empleado actual
        employees.name,
        -- Selecciona el nombre del empleado actual
        employees.report_to -- Selecciona el id del jefe inmediato del empleado actual
    FROM
        employees -- Desde la tabla de empleados
        INNER JOIN bosses ON bosses.id = employees.report_to -- Junta la tabla de empleados con la tabla temporal "bosses" usando el jefe inmediato como clave
) -- Selecciona todos los registros resultantes de la consulta recursiva
SELECT
    *
FROM
    bosses;