CREATE
OR REPLACE PROCEDURE controlled_raise (percentage NUMERIC) AS $ $ DECLARE real_percentage NUMERIC(8, 2);

total_employees INTEGER;

BEGIN RAISE NOTICE 'Percentage = %',
percentage / 100;

real_percentage := percentage / 100;

-- Mantener el historico 
INSERT INTO
    raise_history(
        date,
        employee_id,
        base_salary,
        amount,
        percentage
    )
SELECT
    current_date AS "date",
    employee_id,
    salary,
    max_raise(employee_id) * real_percentage AS "Amount",
    percentage AS "Percentage"
FROM
    employees;

-- Impactar la tabla empleados 
UPDATE
    employees
SET
    salary = (max_raise(employee_id) * real_percentage) + salary;

COMMIT;

SELECT
    COUNT(*) INTO total_employees
FROM
    employees;

RAISE NOTICE 'Afectados % empleados',
total_employees;

END;

$ $ LANGUAGE plpgsql;

CALL controlled_raise (1);

SELECT
    *
from
    employees;