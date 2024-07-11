CREATE
OR REPLACE FUNCTION max_raise_two(empl_id INT) RETURNS NUMERIC(8, 2) AS $ $ DECLARE employee_job_id int;

current_salary NUMERIC(8, 2);

job_max_salary NUMERIC(8, 2);

possible_raise NUMERIC(8, 2);

BEGIN --Tomar el puesto de trabajo y salario
SELECT
    job_id,
    salary into employee_job_id,
    current_salary
FROM
    employees
WHERE
    employee_id = empl_id;

-- Tomar el max salary , acorde a su job
SELECT
    max_salary into job_max_salary
FROM
    jobs
WHERE
    job_id = employee_job_id;

-- calculo
possible_raise = job_max_salary - current_salary;

if (possible_raise < 0) THEN RAISE EXCEPTION 'Persona con salario mayor max_salary: %',
empl_id;

END IF;

RETURN possible_raise;

END;

$ $ LANGUAGE plpgsql;

SELECT
    a.employee_id,
    a.first_name,
    a.salary,
    max_raise_two(employee_id) as possible_raise_two
from
    employees a
WHERE
    employee_id = 206;