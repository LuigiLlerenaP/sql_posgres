CREATE VIEW vw_medication_details AS
SELECT 
    md.IDE_MEDICATION AS [Medication_ID],
    md.MEDICATION_NAME AS [Medication_Name],
    mdCt.CATEGORY_NAME AS [Medication_Category],
    mdUt.UNIT_NAME AS [Unit],
    mdDs.DOSAGE_NAME AS [Dosage],
    mdMf.MANUFACTURER_NAME AS [Manufacturer],
    mdPt.PRESENTATION_NAME AS [Presentation],
    mdARt.ROUTE_NAME AS [Route],
    md.[STATUS] AS [Status] 
FROM 
    T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS AS md
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES AS mdCt
    ON mdCt.IDE_CATEGORY = md.IDE_CATEGORY
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_UNITS AS mdUt 
    ON mdUt.IDE_UNIT = md.IDE_UNIT
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_DOSAGES AS mdDs
    ON mdDs.IDE_DOSAGE = md.IDE_DOSAGE
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS AS mdMf
    ON mdMf.IDE_MANUFACTURER = md.IDE_MANUFACTURER
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS AS mdPt
    ON mdPt.IDE_PRESENTATION = md.IDE_PRESENTATION
INNER JOIN 
    T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES AS mdARt
    ON mdARt.IDE_ROUTE = md.IDE_ROUTE;
GO

DROP VIEW vw_medication_details;



SELECT * 
FROM vw_medication_details 
WHERE [Medication_ID] = '4f2f569c-01e0-4e2b-b98b-f4f18a3d9af4';