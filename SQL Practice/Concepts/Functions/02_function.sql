-- Crear o reemplazar una función que saluda a un empleado
CREATE
OR REPLACE FUNCTION greet_employee (employee_name VARCHAR) RETURNS VARCHAR AS $ $ BEGIN -- Retornar un saludo con el nombre del empleado
RETURN 'Hey ' || employee_name;

END;

$ $ LANGUAGE plpgsql;

SELECT
    greet_employee('Luigi');

SELECT
    first_name,
    greet_employee(first_name)
FROM
    employees;