
CREATE OR REPLACE TRIGGER create_session_trigger
AFTER UPDATE ON "user"
FOR EACH ROW
WHEN (OLD.last_login is DISTINCT from NEW.last_login)
EXECUTE PROCEDURE create_session_log();


CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "session" (user_id, last_login)
    VALUES (NEW.id, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CALL user_login ('janesmith', 'hashedpassword2');




