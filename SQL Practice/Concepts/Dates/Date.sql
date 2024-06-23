SELECT
    -- Obtiene la fecha y hora actual
    NOW() as fecha_hora_actual,
    -- Obtiene la fecha actual
    CURRENT_DATE as fecha_actual,
    -- Obtiene la hora actual
    CURRENT_TIME as hora_actual,
    -- Obtiene la parte de minutos de la fecha y hora actual
    DATE_PART('minutes', NOW()) as minutos_actuales,
    -- Obtiene la parte de segundos de la fecha y hora actual
    DATE_PART('seconds', NOW()) as segundos_actuales,
    -- Obtiene el día del mes de la fecha y hora actual
    DATE_PART('days', NOW()) as dia_actual,
    -- Obtiene el mes de la fecha y hora actual
    DATE_PART('months', NOW()) as mes_actual,
    -- Obtiene el año de la fecha y hora actual
    DATE_PART('years', NOW()) as año_actual;

-- 
-- Consulta para obtener los empleados contratados después del 5 de febrero de 1998
SELECT
    *
FROM
    employees
WHERE
    hire_date > '1998-02-05'
ORDER BY
    hire_date DESC;

-- Consulta para obtener la fecha de contratación más reciente y la más antigua
SELECT
    MAX(hire_date) AS mas_nuevo,
    MIN(hire_date) AS primer_empleado
FROM
    employees;

-- Obtiene una lista de empleados cuya fecha de contratación está entre el 1 de enero de 1999 y el 4 de enero de 2001.
SELECT
    *
FROM
    employees
WHERE
    hire_date BETWEEN '1999-01-01'
    AND '2001-01-04'
ORDER BY
    hire_date DESC;