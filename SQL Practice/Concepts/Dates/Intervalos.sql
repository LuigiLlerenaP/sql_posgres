--!Intervalos
--* INTERVAL: Se utilizan para realizar operaciones aritméticas con fechas y horas, permitiendo sumar o restar períodos específicos de tiempo a las fechas.
SELECT
    --//Obtiene la fecha de contratación más reciente
    MAX(hire_date) AS max_hire_date,
    --// Suma 1 día a la fecha de contratación más reciente
    MAX(hire_date) + INTERVAL '1 DAY' AS max_hire_date_plus_1_day,
    --// Suma 1 mes a la fecha de contratación más reciente
    MAX(hire_date) + INTERVAL '1 MONTH' AS max_hire_date_plus_1_month,
    --// Suma 1 año a la fecha de contratación más reciente
    MAX(hire_date) + INTERVAL '1 YEAR' AS max_hire_date_plus_1_year,
    --// Suma 1 año y 1 día a la fecha de contratación más reciente
    MAX(hire_date) + INTERVAL '1 YEAR' + INTERVAL '1 DAY' AS max_hire_date_plus_1_year_and_1_day,
    --// Extrae el año actual de la fecha y hora actuales
    DATE_PART('YEAR', NOW()) AS current_year,
    --// Crea un intervalo utilizando el año actual convertido a un entero
    MAKE_INTERVAL(YEARS := DATE_PART('YEAR', NOW()) :: INTEGER) AS interval_of_current_years,
    MAX(hire_date) + MAKE_INTERVAL (YEARS := 23)
FROM
    employees;