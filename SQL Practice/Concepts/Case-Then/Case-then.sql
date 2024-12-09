--! ------------------------------------------
--! SQL CASE - THEN 
--! ------------------------------------------
--* DESCRIPCIÓN DE LA SINTAXIS:
--* SELECT: se usa para especificar las columnas que se desean en el resultado.
--* CASE: se usa para devolver valores condicionales en las filas. Permite realizar comparaciones y devolver valores diferentes según la condición.
--* WHEN: se usa dentro del CASE para especificar una condición.
--* THEN: se usa dentro del CASE para especificar el valor a devolver si la condición es verdadera.
--* ELSE: se usa dentro del CASE para especificar el valor a devolver si ninguna condición WHEN es verdadera.
--* END: se usa para cerrar la estructura CASE.
--* NOW(): función que devuelve la fecha y hora actuales.
--* INTERVAL: se usa para sumar o restar períodos de tiempo.
--* ORDER BY: se usa para ordenar el resultado por una o más columnas.
--! ------------------------------------------
--! EJEMPLO DE USO DE LA CLÁUSULA CASE - THEN
--! ------------------------------------------
--* DESCRIPCIÓN DEL EJEMPLO:
--* En este ejemplo, clasificamos a los empleados según su antigüedad en la empresa.
--* La cláusula CASE se utiliza para evaluar la fecha de contratación y devolver un rango de antigüedad.
--* CÓDIGO:
SELECT
    first_name,
    --* Nombre del empleado
    last_name,
    --* Apellido del empleado
    hire_date,
    --* Fecha de contratación del empleado
    --! CASE - THEN estructura para clasificar la antigüedad de los empleados:
    CASE
        --* La condición WHEN se evalúa en orden. Si es verdadera, se ejecuta THEN.
        WHEN hire_date > NOW() - INTERVAL '1 year' THEN 'RANGE A' --! Contratado hace menos de 1 año
        WHEN hire_date > NOW() - INTERVAL '3 year' THEN 'RANGE B' --! Contratado hace entre 1 y 3 años
        WHEN hire_date > NOW() - INTERVAL '6 year' THEN 'RANGE C' --! Contratado hace entre 3 y 6 años
        ELSE 'RANGE D' --! Contratado hace más de 6 años
    END AS rango_antigüedad --* Alias para la columna generada por CASE
FROM
    employees --* Tabla de empleados
ORDER BY
    4 ASC;

--!RESUMEN:
--* La cláusula CASE - THEN se usa para devolver valores basados en condiciones específicas.
--* Permite clasificar y devolver resultados diferentes según las condiciones establecidas.
--* Es útil para crear columnas calculadas o categorizaciones en consultas SQL.