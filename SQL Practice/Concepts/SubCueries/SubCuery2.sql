SELECT
    (
        -- Subconsulta para contar el total de empleados
        SELECT
            COUNT(*)
        FROM
            employees
    ) as total,
    (
        -- Subconsulta para calcular la suma total de salarios
        SELECT
            SUM(salary)
        FROM
            employees
    ) as totalSalary;