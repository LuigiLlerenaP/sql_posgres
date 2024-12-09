-- create medication white the  name 
-- ==================================================================================================== --
-- ==================================================================================================== --

-- ======================================= Procedimiento:Tablas de tipos de Datos  ============================================= --
-- Descripción: Se crearan los tipos de tablas que seran utilizados como parametros en el procedimiento almacenado
-- ================================================================================================================================= --

CREATE TYPE dbo.MedicationUnitType AS TABLE
(
    UnitName VARCHAR(50),
    Abbreviation VARCHAR(25)
);

CREATE TYPE dbo.MedicationDosageType AS TABLE
(
    DosageName VARCHAR(50),
    Description VARCHAR(255)
);

CREATE TYPE dbo.MedicationManufacturerType AS TABLE
(
    ManufacturerName VARCHAR(50)
);

CREATE TYPE dbo.MedicationPresentationType AS TABLE
(
    PresentationName VARCHAR(50),
    Description VARCHAR(255)
);

CREATE TYPE dbo.MedicationRouteType AS TABLE
(
    RouteName VARCHAR(50)
);

-- ==================================================================================================== --
-- ==================================================================================================== --



-- ======================================= Procedimiento: sp_create_medication ============================================= --
-- Descripción: Insertar un mediamento pasando los mobres de las tablas fk
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_create_medication 
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MEDICATION_NAME VARCHAR(200),
    @CATEGORY_NAME NVARCHAR(150),
    @UNIT_NAME NVARCHAR(150),
    @DOSAGE_NAME NVARCHAR(150),
    @MANUFACTURER_NAME NVARCHAR(150),
    @PRESENTATION_NAME NVARCHAR(150),
    @ROUTE_NAME NVARCHAR(150),
    @NewMedicationID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar el nombre del medicamento y otros campos
    SET @MEDICATION_NAME = dbo.normalizeAndFormatText(@MEDICATION_NAME);
    SET @CATEGORY_NAME = dbo.normalizeAndFormatText(@CATEGORY_NAME);
    SET @UNIT_NAME = dbo.normalizeAndFormatText(@UNIT_NAME);
    SET @DOSAGE_NAME = dbo.normalizeAndFormatText(@DOSAGE_NAME);
    SET @MANUFACTURER_NAME = dbo.normalizeAndFormatText(@MANUFACTURER_NAME);
    SET @PRESENTATION_NAME = dbo.normalizeAndFormatText(@PRESENTATION_NAME);
    SET @ROUTE_NAME = dbo.normalizeAndFormatText(@ROUTE_NAME);

    -- Validar si los campos son NULL
    IF @IDE_COMPANY IS NULL OR
       @MEDICATION_NAME IS NULL OR 
       @CATEGORY_NAME IS NULL OR 
       @UNIT_NAME IS NULL OR 
       @DOSAGE_NAME IS NULL OR 
       @MANUFACTURER_NAME IS NULL OR  
       @PRESENTATION_NAME IS NULL OR
       @ROUTE_NAME IS NULL 
    BEGIN
        RAISERROR('Los parámetros no pueden ser NULL.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE MEDICATION_NAME = @MEDICATION_NAME)
    BEGIN
        RAISERROR('El medicamento con el nombre proporcionado ya existe.', 16, 1);
        RETURN;
    END;


    DECLARE @NewCategoryID UNIQUEIDENTIFIER;
    SELECT @NewCategoryID = IDE_CATEGORY
    FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES
    WHERE CATEGORY_NAME = @CATEGORY_NAME AND IDE_COMPANY = @IDE_COMPANY;

    IF @NewCategoryID IS NULL 
    BEGIN
        RAISERROR('No existe esa categoría.', 16, 1);
        RETURN;
    END;

    DECLARE @NewUnitID UNIQUEIDENTIFIER;
    SELECT @NewUnitID = IDE_UNIT
    FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND UNIT_NAME = @UNIT_NAME;

    IF @NewUnitID IS NULL 
    BEGIN
        RAISERROR('No existe esa unidad.', 16, 1);
        RETURN;
    END;

    DECLARE @NewDosageID UNIQUEIDENTIFIER;
    SELECT @NewDosageID = IDE_DOSAGE
    FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
    WHERE IDE_COMPANY = @IDE_COMPANY AND DOSAGE_NAME = @DOSAGE_NAME;

    IF @NewDosageID IS NULL 
    BEGIN
        RAISERROR('No existe esa dosis.', 16, 1);
        RETURN;
    END;

    DECLARE @NewManufacturerID UNIQUEIDENTIFIER;
    SELECT @NewManufacturerID = IDE_MANUFACTURER
    FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND MANUFACTURER_NAME = @MANUFACTURER_NAME;

    IF @NewManufacturerID IS NULL 
    BEGIN
        RAISERROR('No existe ese fabricante.', 16, 1);
        RETURN;
    END;

    DECLARE @NewPresentationID UNIQUEIDENTIFIER;
    SELECT @NewPresentationID = IDE_PRESENTATION 
    FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND PRESENTATION_NAME = @PRESENTATION_NAME;

    IF @NewPresentationID IS NULL 
    BEGIN
        RAISERROR('No existe esa presentación.', 16, 1);
        RETURN;
    END;

    DECLARE @NewRouteID UNIQUEIDENTIFIER;
    SELECT @NewRouteID = IDE_ROUTE 
    FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES  
    WHERE IDE_COMPANY = @IDE_COMPANY AND ROUTE_NAME = @ROUTE_NAME;

    IF @NewRouteID IS NULL 
    BEGIN
        RAISERROR('No existe esa ruta.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID y realizar la inserción
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        (IDE_MEDICATION, IDE_COMPANY, IDE_CATEGORY, IDE_UNIT, IDE_DOSAGE, IDE_MANUFACTURER, IDE_PRESENTATION, IDE_ROUTE, MEDICATION_NAME)
        VALUES
        (@GeneratedID, @IDE_COMPANY, @NewCategoryID, @NewUnitID, @NewDosageID, @NewManufacturerID, @NewPresentationID, @NewRouteID, @MEDICATION_NAME);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el ID del nuevo medicamento a la variable de salida
        SET @NewMedicationID = @GeneratedID;

        PRINT 'Medicamento creado exitosamente.';

    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;
        -- Obtener y mostrar el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_create_medication;
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE ============================================== --

------------------------------------
GO
DECLARE @NewMedicationID UNIQUEIDENTIFIER;

EXEC dbo.sp_create_medication
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @MEDICATION_NAME = 'Dimethyltryptamine',
    @CATEGORY_NAME = 'Psychedelic',
    @UNIT_NAME = 'Vial',
    @DOSAGE_NAME = '10mg/mL',
    @MANUFACTURER_NAME = 'Mystical Labs',
    @PRESENTATION_NAME = 'Ampoule',
    @ROUTE_NAME = 'Intramuscular',
    @NewMedicationID = @NewMedicationID OUTPUT;

-- Verifica el valor del ID del nuevo medicamento creado
SELECT @NewMedicationID AS NewMedicationID;


-- ==================================== READ THE PRESENTATION ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS  where IDE_MEDICATION ='35928c13-5dd5-4ab5-88e7-f60fb8b1e24f';
-- ======================================================================================================= --

-- ==================================================================================================== --
-- ==================================================================================================== --

-- ======================================= Procedimiento: sp_update_presentation ============================================= --
-- Descripción: Actualiza una presentación de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication
(
    @IDE_MEDICATION UNIQUEIDENTIFIER,      -- Identificador del medicamento a actualizar
    @IDE_COMPANY UNIQUEIDENTIFIER,         -- Identificador de la compañía
    @MEDICATION_NAME VARCHAR(200),         -- Nombre del medicamento
    @CATEGORY_NAME NVARCHAR(150),          -- Nombre de la categoría
    @UNIT_NAME NVARCHAR(150),              -- Nombre de la unidad
    @DOSAGE_NAME NVARCHAR(150),            -- Nombre de la dosis
    @MANUFACTURER_NAME NVARCHAR(150),      -- Nombre del fabricante
    @PRESENTATION_NAME NVARCHAR(150),      -- Nombre de la presentación
    @ROUTE_NAME NVARCHAR(150)              -- Nombre de la ruta
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el medicamento existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE IDE_MEDICATION = @IDE_MEDICATION)
    BEGIN
        RAISERROR('El medicamento con el ID proporcionado no existe.', 16, 1);
        RETURN;
    END;

    -- Normalizar los valores
    SET @MEDICATION_NAME = dbo.normalizeAndFormatText(@MEDICATION_NAME);
    SET @CATEGORY_NAME = dbo.normalizeAndFormatText(@CATEGORY_NAME);
    SET @UNIT_NAME = dbo.normalizeAndFormatText(@UNIT_NAME);
    SET @DOSAGE_NAME = dbo.normalizeAndFormatText(@DOSAGE_NAME);
    SET @MANUFACTURER_NAME = dbo.normalizeAndFormatText(@MANUFACTURER_NAME);
    SET @PRESENTATION_NAME = dbo.normalizeAndFormatText(@PRESENTATION_NAME);
    SET @ROUTE_NAME = dbo.normalizeAndFormatText(@ROUTE_NAME);

    DECLARE @NewCategoryID UNIQUEIDENTIFIER;
    SELECT @NewCategoryID = IDE_CATEGORY
    FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES
    WHERE CATEGORY_NAME = @CATEGORY_NAME AND IDE_COMPANY = @IDE_COMPANY;

    IF @NewCategoryID IS NULL 
    BEGIN
        RAISERROR('No existe esa categoría.', 16, 1);
        RETURN;
    END;

    DECLARE @NewUnitID UNIQUEIDENTIFIER;
    SELECT @NewUnitID = IDE_UNIT
    FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND UNIT_NAME = @UNIT_NAME;

    IF @NewUnitID IS NULL 
    BEGIN
        RAISERROR('No existe esa unidad.', 16, 1);
        RETURN;
    END;

    DECLARE @NewDosageID UNIQUEIDENTIFIER;
    SELECT @NewDosageID = IDE_DOSAGE
    FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
    WHERE IDE_COMPANY = @IDE_COMPANY AND DOSAGE_NAME = @DOSAGE_NAME;

    IF @NewDosageID IS NULL 
    BEGIN
        RAISERROR('No existe esa dosis.', 16, 1);
        RETURN;
    END;

    DECLARE @NewManufacturerID UNIQUEIDENTIFIER;
    SELECT @NewManufacturerID = IDE_MANUFACTURER
    FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND MANUFACTURER_NAME = @MANUFACTURER_NAME;

    IF @NewManufacturerID IS NULL 
    BEGIN
        RAISERROR('No existe ese fabricante.', 16, 1);
        RETURN;
    END;

    DECLARE @NewPresentationID UNIQUEIDENTIFIER;
    SELECT @NewPresentationID = IDE_PRESENTATION 
    FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    WHERE IDE_COMPANY = @IDE_COMPANY AND PRESENTATION_NAME = @PRESENTATION_NAME;

    IF @NewPresentationID IS NULL 
    BEGIN
        RAISERROR('No existe esa presentación.', 16, 1);
        RETURN;
    END;

    DECLARE @NewRouteID UNIQUEIDENTIFIER;
    SELECT @NewRouteID = IDE_ROUTE 
    FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES  
    WHERE IDE_COMPANY = @IDE_COMPANY AND ROUTE_NAME = @ROUTE_NAME;

    IF @NewRouteID IS NULL 
    BEGIN
        RAISERROR('No existe esa ruta.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el registro del medicamento
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        SET
            IDE_COMPANY = @IDE_COMPANY,
            IDE_CATEGORY = @NewCategoryID,
            IDE_UNIT = @NewUnitID,
            IDE_DOSAGE = @NewDosageID,
            IDE_MANUFACTURER = @NewManufacturerID,
            IDE_PRESENTATION = @NewPresentationID,
            IDE_ROUTE = @NewRouteID,
            MEDICATION_NAME = @MEDICATION_NAME
        WHERE IDE_MEDICATION = @IDE_MEDICATION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Medicamento actualizado exitosamente.';

    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;
        -- Obtener y mostrar el mensaje de error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO

-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
EXEC dbo.sp_update_medication
    @IDE_MEDICATION = '35928c13-5dd5-4ab5-88e7-f60fb8b1e24f',  -- ID del medicamento a actualizar
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',   -- ID de la compañía
    @MEDICATION_NAME = 'Dimethyltryptamine_Test',                   -- Nuevo nombre del medicamento
    @CATEGORY_NAME = 'Psychedelic',                            -- Nombre de la nueva categoría
    @UNIT_NAME = 'Vial',                                      -- Nombre de la nueva unidad
    @DOSAGE_NAME = '10mg/mL',                                 -- Nuevo nombre de la dosis
    @MANUFACTURER_NAME = 'Mystical Labs',                     -- Nombre del nuevo fabricante
    @PRESENTATION_NAME = 'Ampoule',                           -- Nombre de la nueva presentación
    @ROUTE_NAME = 'Intramuscular';        

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_update_medication;
-- ======================================================================================================= -
