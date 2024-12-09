-- ======================================================================================================= --
-- ======================================================================================================= --

-- ======================================= Procedimiento: sp_insert_medication ============================================= --
-- Descripción: Inserta un nuevo medicamento , validando los campos 
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_add_medication__health
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MEDICATION_NAME VARCHAR(200),
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @IDE_UNIT UNIQUEIDENTIFIER,
    @IDE_DOSAGE UNIQUEIDENTIFIER,
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @NewMedicationID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar el nombre del medicamento
    SET @MEDICATION_NAME = dbo.fn_normalize_format_text(@MEDICATION_NAME);

    -- Validar si los campos son NULL
    IF @IDE_COMPANY IS NULL OR
       @MEDICATION_NAME IS NULL OR 
       @IDE_CATEGORY IS NULL OR 
       @IDE_UNIT IS NULL OR 
       @IDE_DOSAGE IS NULL OR 
       @IDE_MANUFACTURER IS NULL OR  
       @IDE_PRESENTATION IS NULL OR
       @IDE_ROUTE IS NULL 
    BEGIN
        RAISERROR('Los parámetros no pueden ser NULL.', 16, 1);
        RETURN;
    END;

    -- Llamar a la función de validación
    DECLARE @ErrorMsg NVARCHAR(4000);
    SET @ErrorMsg = dbo.fn_validate_medication(
        @MEDICATION_NAME, 
        @IDE_CATEGORY, 
        @IDE_UNIT, 
        @IDE_DOSAGE, 
        @IDE_MANUFACTURER, 
        @IDE_PRESENTATION, 
        @IDE_ROUTE,
        NULL 
    );

    -- Si hay un error, lanzarlo
    IF @ErrorMsg IS NOT NULL
    BEGIN
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar un nuevo medicamento
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        (IDE_MEDICATION, IDE_COMPANY, IDE_CATEGORY, IDE_UNIT, IDE_DOSAGE, IDE_MANUFACTURER, IDE_PRESENTATION, IDE_ROUTE, MEDICATION_NAME)
        VALUES
        (@GeneratedID, @IDE_COMPANY, @IDE_CATEGORY, @IDE_UNIT, @IDE_DOSAGE, @IDE_MANUFACTURER, @IDE_PRESENTATION, @IDE_ROUTE, @MEDICATION_NAME);

        -- Asignar el ID del nuevo medicamento a la variable de salida
        SET @NewMedicationID = @GeneratedID;

        PRINT 'Medicamento creado exitosamente.';

        -- Confirmar la transacción
        COMMIT TRANSACTION;

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
DROP PROCEDURE IF EXISTS dbo.sp_add_medication__health;
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
GO
DECLARE @NewMedicationID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_medication__health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @MEDICATION_NAME = 'Luigi    lll',
    @IDE_CATEGORY = '8a5a1e7d-4aa1-4f46-868a-2115585cc357',
    @IDE_UNIT = '5b552a74-913b-4a66-b2e2-2903d1eb039d',
    @IDE_DOSAGE = '4cd3c861-603c-489c-abf2-f43cfdf19a2f',
    @IDE_MANUFACTURER = '6449fa0d-0d3f-4550-8095-119cf7b92cf4',
    @IDE_PRESENTATION = '5f86c016-2455-47a6-8b6d-68f1c11a84ad',
    @IDE_ROUTE = '8b1a6841-fdbc-482e-bb1a-e70c092888b9',
    @NewMedicationID = @NewMedicationID OUTPUT;

SELECT @NewMedicationID AS MedicationID;

------------------------------------
EXEC dbo.sp_add_medication__health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @MEDICATION_NAME = 'Luigi 02',
    @IDE_CATEGORY = '8a5a1e7d-4aa1-4f46-868a-2115585cc357',
    @IDE_UNIT = '5b552a74-913b-4a66-b2e2-2903d1eb039d',
    @IDE_DOSAGE = '4cd3c861-603c-489c-abf2-f43cfdf19a2f',
    @IDE_MANUFACTURER = '6449fa0d-0d3f-4550-8095-119cf7b92cf4',
    @IDE_PRESENTATION = '5f86c016-2455-47a6-8b6d-68f1c11a84ad',
    @IDE_ROUTE = '8b1a6841-fdbc-482e-bb1a-e70c092888b9';
-- ======================================================================================================= --
-- ======================================== Read Table==================================================== --
SELECT * 
FROM   vw_medication_details 
WHERE  [Medication_ID] = '4f2f569c-01e0-4e2b-b98b-f4f18a3d9af4';
-- ======================================================================================================= --

-- ======================================================================================================= --
-- ======================================================================================================= --




-- ======================================= Procedimiento: sp_update_medication ============================================= --
-- DescripcióN : Actualizar el medicamento existente 
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_health
(
    @IDE_MEDICATION UNIQUEIDENTIFIER, 
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MEDICATION_NAME VARCHAR(200),
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @IDE_UNIT UNIQUEIDENTIFIER,
    @IDE_DOSAGE UNIQUEIDENTIFIER,
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @STATUS NVARCHAR(255),
    @IS_DELETED BIT 
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el medicamento a actualizar existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE IDE_MEDICATION = @IDE_MEDICATION)
    BEGIN
        RAISERROR('El medicamento con el ID proporcionado no existe.', 16, 1);
        RETURN;
    END;
        
    IF @STATUS NOT IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'DISCONTINUED')
    BEGIN
        RAISERROR('El valor de STATUS no es válido. Debe ser uno de los siguientes: ACTIVE, INACTIVE, SUSPENDED, DISCONTINUED.', 16, 1);
        RETURN;
    END

    -- Normalizar el nombre del medicamento
    SET @MEDICATION_NAME = dbo.fn_normalize_format_text(@MEDICATION_NAME);

    -- Validar si los campos son NULL
    IF @IDE_COMPANY IS NULL OR
       @MEDICATION_NAME IS NULL OR 
       @IDE_CATEGORY IS NULL OR 
       @IDE_UNIT IS NULL OR 
       @IDE_DOSAGE IS NULL OR 
       @IDE_MANUFACTURER IS NULL OR  
       @IDE_PRESENTATION IS NULL OR
       @IDE_ROUTE IS NULL 
    BEGIN
        RAISERROR('Los parámetros no pueden ser NULL.', 16, 1);
        RETURN;
    END;

    -- Validar el parámetro IS_DELETED
    IF @IS_DELETED IS NULL
    BEGIN
        RAISERROR('El parámetro IS_DELETED no puede ser NULL.', 16, 1);
        RETURN;
    END

    -- Llamar a la función de validación
    DECLARE @ErrorMsg NVARCHAR(4000);
    SET @ErrorMsg = dbo.fn_validate_medication(
        @MEDICATION_NAME, 
        @IDE_CATEGORY, 
        @IDE_UNIT, 
        @IDE_DOSAGE, 
        @IDE_MANUFACTURER, 
        @IDE_PRESENTATION, 
        @IDE_ROUTE,
        @IDE_MEDICATION -- Pasar el ID del medicamento para la validación
    );

    -- Si hay un error, lanzarlo
    IF @ErrorMsg IS NOT NULL
    BEGIN
        RAISERROR(@ErrorMsg, 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el medicamento existente
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        SET IDE_COMPANY = @IDE_COMPANY,
            IDE_CATEGORY = @IDE_CATEGORY,
            IDE_UNIT = @IDE_UNIT,
            IDE_DOSAGE = @IDE_DOSAGE,
            IDE_MANUFACTURER = @IDE_MANUFACTURER,
            IDE_PRESENTATION = @IDE_PRESENTATION,
            IDE_ROUTE = @IDE_ROUTE,
            MEDICATION_NAME = @MEDICATION_NAME,
            STATUS = @STATUS,
            IS_DELETED = @IS_DELETED 
        WHERE IDE_MEDICATION = @IDE_MEDICATION;

        PRINT 'Medicamento actualizado exitosamente.';

        -- Confirmar la transacción
        COMMIT TRANSACTION;

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
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_health;
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
EXEC dbo.sp_update_medication_health
   @IDE_MEDICATION = 'a92e76e7-66fe-4988-a70b-cb417d8e4d9c',
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @MEDICATION_NAME = ' Test 002',
    @IDE_CATEGORY = '8a5a1e7d-4aa1-4f46-868a-2115585cc357',
    @IDE_UNIT = '5b552a74-913b-4a66-b2e2-2903d1eb039d',
    @IDE_DOSAGE = '4cd3c861-603c-489c-abf2-f43cfdf19a2f',
    @IDE_MANUFACTURER = '6449fa0d-0d3f-4550-8095-119cf7b92cf4',
    @IDE_PRESENTATION = '5f86c016-2455-47a6-8b6d-68f1c11a84ad',
    @IDE_ROUTE = '8b1a6841-fdbc-482e-bb1a-e70c092888b9',
    @STATUS = 'ACTIVE',
    @IS_DELETED = 0;
-- ==================================================================================================== --
-- ======================================== Read Table==================================================== --
SELECT * 
FROM   vw_medication_details 
WHERE  [Medication_ID] = '4f2f569c-01e0-4e2b-b98b-f4f18a3d9af4';
-- ======================================================================================================= --



-- ==================================================================================================== --
-- ==================================================================================================== --

-- ================= Procedimiento: sp_delete_medication =========================
-- Descripción: Elimina un medicamento existente
-- ==========================================
GO
CREATE PROCEDURE dbo.sp_delete_medication_health
(
    @IDE_MEDICATION UNIQUEIDENTIFIER  -- Identificador del medicamento a eliminar
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el medicamento existe antes de intentar eliminarlo
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE IDE_MEDICATION = @IDE_MEDICATION)
    BEGIN
        RAISERROR('El medicamento con el ID proporcionado no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el registro del medicamento
        DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        WHERE IDE_MEDICATION = @IDE_MEDICATION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Medicamento eliminado exitosamente.';

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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_health;
-- ======================================================================================================= --
-- ======================================== Call Procedure =============================================== --
------------------------------------
EXEC dbo.sp_delete_medication_health 
    @IDE_MEDICATION = '35928c13-5dd5-4ab5-88e7-f60fb8b1e24f';
-- ======================================================================================================= --
-- ======================================== Read Table==================================================== --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
-- ======================================================================================================= --



-- ==================================================================================================== --
-- ==================================================================================================== --

-- ================= Procedimiento: soft delte =========================
-- Descripción: Elimina un medicamento existente de manera logica
-- ==========================================
GO
CREATE PROCEDURE dbo.sp_soft_delete_medication_health
(
    @IDE_MEDICATION UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el medicamento a eliminar existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE IDE_MEDICATION = @IDE_MEDICATION)
    BEGIN
        RAISERROR('El medicamento con el ID proporcionado no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
        SET IS_DELETED = 1, -- Marca el registro como eliminado
            STATUS = 'DISCONTINUED' -- Opcional: Cambia el estado para reflejar la eliminación
        WHERE IDE_MEDICATION = @IDE_MEDICATION;

        PRINT 'Medicamento marcado como eliminado exitosamente.';

        -- Confirmar la transacción
        COMMIT TRANSACTION;

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


-- ======================================== Call Procedure =============================================== --
------------------------------------
EXEC dbo.sp_soft_delete_medication_health 
    @IDE_MEDICATION = 'f20d034e-9826-47d9-80ef-2404d0789771';
-- ======================================================================================================= --


select * from T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS;