-- Definición de una consulta recursiva para encontrar todos los jefes de un empleado específico con un nivel de profundidad limitado
WITH RECURSIVE bosses AS (
    -- Parte inicial: selecciona el empleado con id = 1 y establece la profundidad inicial a 1
    SELECT
        -- Selecciona el id del empleado
        id,
        -- Selecciona el nombre del empleado
        name,
        -- Selecciona el id del jefe inmediato de este empleado
        report_to,
        1 as depth -- Establece la profundidad inicial a 1
    FROM
        employees -- Desde la tabla de empleados
    WHERE
        id = 1 -- Condición inicial: busca el empleado con id = 1
    UNION
    -- Parte recursiva: encuentra los jefes de los empleados seleccionados en la parte inicial o en la iteración previa
    SELECT
        employees.id,
        -- Selecciona el id del empleado actual
        employees.name,
        -- Selecciona el nombre del empleado actual
        employees.report_to,
        -- Selecciona el id del jefe inmediato del empleado actual
        depth + 1 -- Incrementa la profundidad en 1 en cada nivel de recursión
    FROM
        employees -- Desde la tabla de empleados
        INNER JOIN bosses ON bosses.id = employees.report_to -- Junta la tabla de empleados con la tabla temporal "bosses" usando el jefe inmediato como clave
    WHERE
        depth < 3 -- Limita la profundidad de la recursión a 3 niveles
) -- Selecciona todos los registros resultantes de la consulta recursiva
SELECT
    *
FROM
    bosses;

--MOSTRAR LOS NOMBRES
WITH RECURSIVE bosses As (
    -- Init
    SELECT
        id,
        name,
        report_to,
        1 as depth
    from
        employees
    where
        id = 1
    UNION
    -- recursive
    SELECT
        employees.id,
        employees.name,
        employees.report_to,
        depth + 1
    FROM
        employees
        INNER JOIN bosses on bosses.id = employees.report_to
    WHERE
        DEPTH < 3
)
SELECT
    bosses.*,
    employees."name" as reports_to_name
FROM
    bosses
    LEFT JOIN employees ON employees.id = bosses.report_to
ORDER BY
    DEPTH;