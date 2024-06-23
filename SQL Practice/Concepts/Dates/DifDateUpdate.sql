---
---
SELECT
    hire_date,
    MAKE_INTERVAL(
        YEARS := 2023 - EXTRACT(
            YEAR
            FROM
                hire_date
        ) :: INTEGER
    ) AS calculated_interval,
    MAKE_INTERVAL(
        YEARS := DATE_PART('YEARS', CURRENT_DATE) :: INTEGER - EXTRACT(
            YEAR
            FROM
                hire_date
        ) :: INTEGER
    ) AS calculated_interval_CALCULATE
FROM
    employees
ORDER BY
    hire_date DESC;

-- !SUMAR EL ANO ACTUAL
UPDATE
    employees
SET
    hire_date = hire_date + INTERVAL '24 years';