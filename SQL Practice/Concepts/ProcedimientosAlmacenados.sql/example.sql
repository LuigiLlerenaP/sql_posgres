CALL user_login ('janesmith3', 'hashedpassword2');

CREATE
OR REPLACE FUNCTION check_user_credentials(
    user_name VARCHAR,
    user_password VARCHAR
) RETURNS BOOLEAN AS $ $ DECLARE user_exists BOOLEAN;

BEGIN
SELECT
    EXISTS (
        SELECT
            1
        FROM
            "user"
        WHERE
            username = user_name
            AND password = crypt(user_password, password)
    ) INTO user_exists;

RETURN user_exists;

END;

$ $ LANGUAGE plpgsql;

CREATE
OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR) AS $ $ DECLARE user_id INT;

was_found BOOLEAN;

BEGIN -- Check if user credentials are valid
was_found := check_user_credentials(user_name, user_password);

IF NOT was_found THEN -- Log failed login attempt
BEGIN
INSERT INTO
    session_failed(user_id, "when")
SELECT
    id,
    now()
FROM
    "user"
WHERE
    username = user_name;

EXCEPTION
WHEN others THEN RAISE EXCEPTION 'Error al insertar en session_failed: %',
SQLERRM;

END;

-- Return without raising exception for incorrect credentials
RETURN;

END IF;

-- Update last login time
UPDATE
    "user"
SET
    last_login = now()
WHERE
    username = user_name;

-- Commit changes to the database
COMMIT;

-- Notify if user was found (for debugging purposes)
RAISE NOTICE 'Usuario encontrado: %',
was_found;

END;

$ $ LANGUAGE plpgsql;

SELECT
    *
FROM
    session_failed;