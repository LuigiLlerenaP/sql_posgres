-- ======================================= Procedimiento: sp_medication_unit ============================================= --
-- Descripción: Inserta una nueva unidad para los medicamentos
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_add_medication_unit_health
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25),
    @NewUnitID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Normalizar y formatear el nombre de la unidad
    DECLARE @NormalizedUnitName VARCHAR(50);
    SET @NormalizedUnitName = dbo.fn_normalize_format_text(@UNIT_NAME);

    -- Normalizar y formatear la abreviación
    DECLARE @NormalizedAbbreviation VARCHAR(25);
    SET @NormalizedAbbreviation = dbo.fn_normalize_format_down_text(@ABBREVIATION);

    -- Validación de parámetros
    IF @IDE_COMPANY IS NULL OR @NormalizedUnitName IS NULL OR @NormalizedAbbreviation IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos: la compañía, el nombre de la unidad y la abreviación son requeridos.', 16, 1);
        RETURN;
    END;

    -- Verificar si la unidad ya existe
    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND UNIT_NAME = @NormalizedUnitName AND ABBREVIATION = @NormalizedAbbreviation)
    BEGIN
        RAISERROR('La unidad ''%s'' ya existe para esta compañía.', 16, 1, @NormalizedUnitName);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID 
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar nueva unidad
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_UNITS (IDE_UNIT, IDE_COMPANY, UNIT_NAME, ABBREVIATION)
        VALUES (@GeneratedID, @IDE_COMPANY, @NormalizedUnitName, @NormalizedAbbreviation);
        
        -- Confirmar la transacción
        COMMIT TRANSACTION;
        
        -- Asignar el nuevo ID al parámetro de salida
        SET @NewUnitID = @GeneratedID; 

        PRINT 'Unidad creada exitosamente';

    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;

        -- Obtener detalles del error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
GO 
-- Declarar una variable para el id que retorna
DECLARE @NewUnitID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_medication_unit_health 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @UNIT_NAME =  'Test-02',
    @ABBREVIATION = 'ABRE',
    @NewUnitID = @NewUnitID OUTPUT ;

SELECT  @NewUnitID AS NewUnit;
------------------------------------
EXEC dbo.sp_add_medication_unit_health 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @UNIT_NAME =  'Test-02',
    @ABBREVIATION = 'ABRE2' ;
-- ==================================== READ THE DOSOAGE ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = '1bfa4032-e8f8-4e83-84ca-8214bb414257';
-- ======================================================================================================= --

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_add_medication_unit_health;
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --


-- ======================================= Procedimiento: sp_update_medication_unit ============================================= --
-- Descripción: Actualiza una unidad de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_unit_health
(
    @IDE_UNIT UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la unidad
    DECLARE @NormalizedUnitName VARCHAR(50);
    SET @NormalizedUnitName = dbo.fn_normalize_format_text(@UNIT_NAME);
    
    -- Normalizar y formatear la abreviación
    DECLARE @NormalizedAbbreviation VARCHAR(25);
    SET @NormalizedAbbreviation = dbo.fn_normalize_format_down_text(@ABBREVIATION);

    -- Validación de parámetros
    IF @IDE_UNIT IS NULL OR @NormalizedUnitName IS NULL OR @NormalizedAbbreviation IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos. IDE_UNIT, nombre de la unidad o abreviación son requeridos.', 16, 1);
        RETURN;
    END;

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad especificada no existe.', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe otra unidad con el mismo nombre y abreviación
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
               WHERE UNIT_NAME = @NormalizedUnitName 
                 AND ABBREVIATION = @NormalizedAbbreviation
                 AND IDE_UNIT <> @IDE_UNIT)
    BEGIN
        RAISERROR('Ya existe una unidad con el nombre ''%s'' y abreviación ''%s''.', 16, 1, @NormalizedUnitName, @NormalizedAbbreviation);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar la unidad
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_UNITS
        SET UNIT_NAME = @NormalizedUnitName, 
            ABBREVIATION = @NormalizedAbbreviation
        WHERE IDE_UNIT = @IDE_UNIT;
        
        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Unidad actualizada exitosamente.';
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
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_unit_health;
-- ======================================================================================================= --
-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = '1bfa4032-e8f8-4e83-84ca-8214bb414257';
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_update_medication_unit_health 
    @IDE_UNIT =  '1bfa4032-e8f8-4e83-84ca-8214bb414257',
    @UNIT_NAME = 'TEST001', 
    @ABBREVIATION = 'TEST 11.1.11';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --

-- ======================================= Procedimiento: sp_delete_occupational_health_unit ============================================= --
-- Descripción: Elimina una DOSIS de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_medication_unit_health 
(
    @IDE_UNIT UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_UNIT IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_UNIT inválido', 16, 1);
        RETURN;
    END;

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad no existe', 16, 1);
        RETURN;
    END;
    BEGIN TRANSACTION;
    BEGIN TRY
    -- Eliminar la unidad
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT;
    -- Confirmar la transacción
    COMMIT TRANSACTION;

    PRINT 'Unidad eliminada exitosamente';
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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_unit_health;
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_delete_medication_unit_health 
    @IDE_UNIT = '480f4527-389c-493e-9688-0231b919d100';
-- ======================================================================================================= --

-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_UNITS;
-- ======================================================================================================= --
