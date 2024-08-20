-- ======================================= Procedimiento:sp_create_dosage ============================================= --
-- Descripción: Inserta una nueva dosis para los medicamentos
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_create_dosage
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @DOSAGE_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL,
    @NewDosageID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la dosis
    DECLARE @NormalizedDosageName VARCHAR(50);
    SET @NormalizedDosageName = dbo.normalizeAndFormatText(@DOSAGE_NAME);

    -- Validar que los parámetros sean válidos
    IF @IDE_COMPANY IS NULL OR @NormalizedDosageName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos. La empresa o el nombre de la dosis es nulo.', 16, 1);
        RETURN;
    END

    -- Verificar si ya existe una dosis con el mismo nombre
    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
               WHERE IDE_COMPANY = @IDE_COMPANY AND DOSAGE_NAME = @NormalizedDosageName)
    BEGIN
        RAISERROR('La dosificación ya existe.', 16, 1);
        RETURN;
    END
        
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID 
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar la nueva dosis
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
            (IDE_DOSAGE, IDE_COMPANY, DOSAGE_NAME, DESCRIPTION)
        VALUES 
            (@GeneratedID, @IDE_COMPANY, @NormalizedDosageName, @DESCRIPTION);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el nuevo ID al parámetro de salida
        SET @NewDosageID = @GeneratedID;

        -- Informar que la dosificación fue creada exitosamente
        PRINT 'Dosificación creada exitosamente.';
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
-- Declarar una variable para capturar el ID de la dosis
DECLARE @NewDosageID UNIQUEIDENTIFIER;

-- Llamar al procedimiento almacenado
EXEC dbo.sp_create_dosage
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @DOSAGE_NAME = 'Test 001', 
    @DESCRIPTION = 'LUIGI TEST ;',
    @NewDosageID = @NewDosageID OUTPUT;

-- Mostrar el valor del parámetro de salida
SELECT @NewDosageID AS NewDosageID;

------------------------------------
EXEC dbo.sp_create_dosage
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @DOSAGE_NAME = 'Test 002', 
    @DESCRIPTION = 'LUIGI TEST';

-- ==================================== READ THE DOSOAGE ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = '187afb18-ce2d-4cb2-8d91-9423853dcdd8';
-- ======================================================================================================= --

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_create_dosage;
-- ======================================================================================================= --



-- ==================================================================================================== --
-- ==================================================================================================== --



-- ======================================= Procedimiento: sp_update_dosage ============================================= --
-- Descripción: Actualiza un dosage de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_dosage
(
    @IDE_DOSAGE UNIQUEIDENTIFIER,
    @DOSAGE_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la dosage
    DECLARE @NormalizedName VARCHAR(50);
    SET @NormalizedName = dbo.normalizeAndFormatText(@DOSAGE_NAME);

    -- Validar los parámetros
    IF @IDE_DOSAGE IS NULL OR @NormalizedName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END;

    -- Verificar si la categoría existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY

    -- Actualizar la dosis con el nombre normalizado
    UPDATE T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
    SET DOSAGE_NAME = @NormalizedName,
        DESCRIPTION = ISNULL(@DESCRIPTION, DESCRIPTION)
    WHERE IDE_DOSAGE = @IDE_DOSAGE;

    -- Confirmar la transacción
    COMMIT TRANSACTION;

    PRINT 'Dosificación actualizada exitosamente';
    
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
DROP PROCEDURE IF EXISTS dbo.sp_update_dosage;
-- ======================================================================================================= --
-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = '187afb18-ce2d-4cb2-8d91-9423853dcdd8';
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_update_dosage 
    @IDE_DOSAGE = '187afb18-ce2d-4cb2-8d91-9423853dcdd8',
    @DOSAGE_NAME = 'TEST001', 
    @DESCRIPTION = 'TEST 11.1.11';
-- ======================================================================================================= --




-- ======================================= Procedimiento: sp_delete_dosage ============================================= --
-- Descripción: Elimina una DOSIS de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_dosage
(
    @IDE_DOSAGE UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON; 

    -- Validar el parámetro
    IF @IDE_DOSAGE IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_DOSAGE inválido', 16, 1);
        RETURN;
    END;

    -- Verificar si la dosificación existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar la DOSIS
        DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
        WHERE IDE_DOSAGE = @IDE_DOSAGE;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Dosificación eliminada exitosamente';
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
DROP PROCEDURE IF EXISTS dbo.sp_delete_dosage;
-- ======================================================================================================= --

   -- ======================================== CALL PROCEDURE =============================================== --

EXEC dbo.sp_delete_dosage
   @IDE_DOSAGE = '187afb18-ce2d-4cb2-8d91-9423853dcdd8';
-- ======================================================================================================= --