CREATE OR REPLACE FUNCTION sayHello(user_name VARCHAR) RETURNS VARCHAR AS $ $ BEGIN RETURN 'Hello World ' || user_name;
END;
$ $ LANGUAGE plpgsql;
-- 
CREATE OR REPLACE FUNCTION comment_replace(id INTEGER) RETURNS VARCHAR AS $$
DECLARE
    result VARCHAR;
BEGIN
    SELECT
        json_agg(
            json_build_object(
                'user', b.user_id,
                'content', b.content
            )
        )::TEXT
    INTO result
    FROM
        comments b
    WHERE
        b.comment_parent_id = id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;
