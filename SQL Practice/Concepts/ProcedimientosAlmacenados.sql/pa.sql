CREATE
OR REPLACE FUNCTION country_region() RETURNS TABLE (
    id CHAR(2),
    name VARCHAR(40),
    region VARCHAR(25)
) AS $ $ BEGIN RETURN QUERY
SELECT
    country_id,
    country_name,
    region_name
FROM
    countries
    INNER JOIN regions ON countries.region_id = regions.region_id;

END;

$ $ LANGUAGE plpgsql;

-- Test the function
SELECT
    *
FROM
    country_region();

---
---
--
CREATE
OR REPLACE PROCEDURE insert_region_proc(
    p_region_id INT,
    p_region_name VARCHAR
) LANGUAGE plpgsql AS $ $ BEGIN
INSERT INTO
    regions(region_id, region_name)
VALUES
    (p_region_id, p_region_name);

RAISE NOTICE 'Variables a insertar: %, %',
p_region_id,
p_region_name;

END;

$ $;