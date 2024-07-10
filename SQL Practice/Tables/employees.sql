-- Convenciones de Nombres de Tablas
-- Singular vs. Plural:
-- - Singular: Recomendado para consistencia y claridad. Ejemplo: `user` en lugar de `users`.
-- - Convención Existente: Sigue la convención de nombres ya establecida en la base de datos, sea singular o plural.
-- Razones para Usar Nombres en Singular:
-- 1. Claridad: Cada fila representa una entidad única.
-- 2. Consistencia: Facilita la lectura y comprensión del esquema.
-- 3. Estándar: Depende del estándar de la base de datos; lo importante es ser consistente.
-- Ejemplo:
-- - Singular: `user`, `product`
-- - Plural: `users`, `products`
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    report_to INT REFERENCES employees(id)
);

INSERT INTO
    employees (name, report_to)
VALUES
    -- El jefe no reporta a nadie, así que 'report' es NULL
    ('Jefe Carlos', NULL),
    -- Reporta a 'Jefe Carlos'
    ('SubJefe Susana', 1),
    -- Reporta a 'Jefe Carlos'
    ('SubJefe Juan', 1),
    -- Reporta a 'SubJefe Susana'
    ('Gerente Carmen', 2),
    -- Reporta a 'SubJefe Juan'
    ('Gerente Pedro', 3),
    -- Reporta a 'SubJefe Juan'
    ('Gerente Melissa', 3),
    -- Reporta a 'Gerente Melissa'
    ('SubGerente Ramiro', 6),
    -- Reporta a 'SubGerente Ramiro'
    ('Dev Fernando', 7),
    -- Reporta a 'SubGerente Ramiro'
    ('Dev Eduardo', 7);

SELECT
    *
FROM
    employees
WHERE
    report_to = 1
UNION
SELECT
    *
FROM
    employees
WHERE
    report_to = 2;