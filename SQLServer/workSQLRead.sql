--HAS PHOTO 1 OR 0
SELECT a.*, 
       CASE WHEN a.DISPENSER_PHOTO IS NOT NULL THEN 1 ELSE 0 END AS HAS_PHOTO
FROM T_RRHH_OCUPATIONAL_HEALTH_DISPENSERS  a;

--BASIC INFO  DISPENSERS
SELECT 
    CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME) AS CompleteName,
    CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME ,' - ', a.DNI) AS CompleteNameWithDni,
    UPPER(CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME)) AS CompleteNameUppercase,
    CASE WHEN a.DISPENSER_PHOTO IS NOT NULL THEN 1 ELSE 0 END AS HasPhoto
FROM 
   T_RRHH_OCUPATIONAL_HEALTH_DISPENSERS  a;

--BASIC INFO MEDICAL STAFF
SELECT    
    CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME) AS FullName,
    CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME, ' ', a.DNI) AS FullNameWithDni,
    CONCAT(a.FIRST_NAME, ' ', a.LAST_NAME, ' ', a.DNI, ' ', a.MEDICAL_STAFF_CODE) AS FullNameWithDniAndCode,
    CASE WHEN a.MEDICAL_STAFF_PHOTO IS NOT NULL THEN 1 ELSE 0 END AS HasPhoto
FROM 
    T_RRHH_OCUPATIONAL_HEALTH_MEDICAL_STAFF a;


--
SELECT  a.ENTITY_TYPE,    
        CONCAT(b.FIRST_NAME, ' ', b.LAST_NAME ,' - ', b.DNI) AS CompleteNameWithDni
FROM T_RRHH_OCUPATIONAL_HEALTH_ASSIGNMENTS a
INNER JOIN T_RRHH_OCUPATIONAL_HEALTH_DISPENSERS b ON  a.IDE_ENTITY = b.IDE_DISPENSER ;

SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_ASSIGNMENTS a
INNER JOIN T_RRHH_OCUPATIONAL_HEALTH_MEDICAL_STAFF b ON  a.IDE_ENTITY = b.IDE_MEDICAL_STAFF;
