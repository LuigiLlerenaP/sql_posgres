-- Crear o reemplazar una función que calcula el máximo aumento salarial que un empleado puede tener
CREATE
OR REPLACE FUNCTION max_raise(empl_id INT) RETURNS NUMERIC(8, 2) AS $ $ DECLARE possible_raise NUMERIC(8, 2);

-- Declarar la variable para almacenar el posible aumento
BEGIN -- Seleccionar la diferencia entre el salario máximo del puesto y el salario actual del empleado
SELECT
    b.max_salary - a.salary INTO possible_raise
FROM
    employees a -- Tabla de empleados con alias 'a'
    INNER JOIN jobs b ON b.job_id = a.job_id -- Unión interna con la tabla de trabajos, unida por job_id
WHERE
    a.employee_id = empl_id;

-- Filtrar por el id del empleado pasado como parámetro
-- Devolver el posible aumento calculado
RETURN possible_raise;

END;

$ $ LANGUAGE plpgsql;

-- Se puede hacer en diferentes pasos
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

-- calculos
possible_raise = job_max_salary - current_salary;

RETURN possible_raise;

END;

$ $ LANGUAGE plpgsql;

SELECT
    a.employee_id,
    a.first_name,
    a.salary,
    max_raise (employee_id) as possible_raise,
    max_raise_two (employee_id) as possible_raise_two
from
    employees a;