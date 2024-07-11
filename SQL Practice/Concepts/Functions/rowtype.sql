CREATE
OR REPLACE FUNCTION max_raise_two(empl_id INT) RETURNS NUMERIC(8, 2) AS $ $ DECLARE selected_employee employees % rowtype;

selected_job jobs % rowtype;

possible_raise NUMERIC(8, 2);

BEGIN --Tomar el puesto de trabajo y salario
SELECT
    *
FROM
    employees into selected_employee
WHERE
    employee_id = empl_id;

-- Tomar el max salary , acorde a su job
SELECT
    *
FROM
    jobs into selected_job
WHERE
    job_id = selected_employee.job_id;

-- cálculos
possible_raise = selected_job.max_salary - selected_employee.salary;

IF (possible_raise < 0) THEN RAISE EXCEPTION 'Persona con salario mayor max_salary: id:%, %',
selected_employee.employee_id,
selected_employee.first_name;

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
    employees a;