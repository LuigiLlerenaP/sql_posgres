--VIEW CONSTRAIN NAME 
SELECT
    CONSTRAINT_NAME
FROM
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE
    TABLE_NAME = 'RRHH_OCUPATIONAL_HEALTH_DISPENSERS'
    AND COLUMN_NAME = 'PHONE';
-- ADD COLUMNS AND CONSTRAINTS
ALTER TABLE RRHH_OCUPATIONAL_HEALTH_DISPENSERS 
ADD FIRST_NAME VARCHAR(65) NOT NULL,
    LAST_NAME VARCHAR(65) NOT NULL,
    PHONE VARCHAR(35) CHECK (LEN(PHONE) > 9),
    DISPENSER_PHOTO IMAGE,
    EMAIL VARCHAR(255) CHECK (EMAIL LIKE '%@%.%'),
    GENDER VARCHAR(15) NOT NULL;

ALTER TABLE RRHH_OCUPATIONAL_HEALTH_DISPENSERS 
ADD DNI VARCHAR(30) NOT NULL;

--DROP CONSTRAIN
ALTER TABLE RRHH_OCUPATIONAL_HEALTH_DISPENSERS
DROP CONSTRAINT "CK__RRHH_OCUP__PHONE__50DBD3F1";

--ADD CONSTRAIN
ALTER TABLE RRHH_OCUPATIONAL_HEALTH_DISPENSERS
ADD CONSTRAINT CK_RRHH_OCUPATIONAL_HEALTH_DISPENSERS_PHONE
CHECK (LEN(PHONE) >= 10);




-- Cambiar el tipo de datos y agregar la restricción CHECK
ALTER TABLE RRHH_OCUPATIONAL_HEALTH_MEDICAL_CARES
    ALTER COLUMN STATUS CHAR(1) NOT NULL;

ALTER TABLE RRHH_OCUPATIONAL_HEALTH_MEDICAL_CARES
    ADD CONSTRAINT CK_STATUS CHECK (STATUS IN ('X', 'C', 'I'));

-- Establecer el valor predeterminado
ALTER TABLE RRHH_OCUPATIONAL_HEALTH_MEDICAL_CARES
    ADD CONSTRAINT DF_STATUS DEFAULT 'I' FOR STATUS;






