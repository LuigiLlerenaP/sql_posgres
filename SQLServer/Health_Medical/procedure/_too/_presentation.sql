-- ======================================= Procedimiento:sp_create_presentation ============================================= --
-- Descripción: Inserta una nueva PRESENTACION para los medicamentos
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp__create_medication_presentation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL,
    @NewPresentationID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Normalizar y formatear el nombre de la presentación
    DECLARE @NormalizedPresentationName VARCHAR(50);
    SET @NormalizedPresentationName = dbo.normalizeAndFormatText(@PRESENTATION_NAME);
    
    -- Validar que los parámetros sean válidos
    IF @IDE_COMPANY IS NULL OR @NormalizedPresentationName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe una presentación con el mismo nombre
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND PRESENTATION_NAME = @NormalizedPresentationName)
    BEGIN
        RAISERROR('La presentación ya existe', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID 
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar la nueva presentación
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS (IDE_PRESENTATION, IDE_COMPANY, PRESENTATION_NAME, DESCRIPTION)
        VALUES (@GeneratedID, @IDE_COMPANY, @NormalizedPresentationName, @DESCRIPTION);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el nuevo ID al parámetro de salida
        SET @NewPresentationID = @GeneratedID;
        
        PRINT 'Presentación creada exitosamente';
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
DECLARE @NewPresentationID UNIQUEIDENTIFIER;
EXEC dbo.sp__create_medication_presentation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PRESENTATION_NAME = 'teste 111',
    @DESCRIPTION = 'LUIGI TEST',
    @NewPresentationID = @NewPresentationID OUTPUT;
SELECT @NewPresentationID AS NewPresentationId;
------------------------------------
EXEC dbo.sp__create_medication_presentation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PRESENTATION_NAME = 'teste 222',
    @DESCRIPTION = 'LUIGI TEST';
-- ==================================== READ THE PRESENTATION ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS WHERE IDE_PRESENTATION = '4865c4ff-41cc-4b07-b86f-828922be9f5b';
-- ======================================================================================================= --

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp__create_medication_presentation ;
-- ======================================================================================================= --



-- ==================================================================================================== --
-- ==================================================================================================== --




-- ======================================= Procedimiento: sp_update_presentation ============================================= --
-- Descripción: Actualiza una presentación de medicamentos existente
-- ================================================================================================================================= --

GO
CREATE PROCEDURE dbo.sp_update_medication_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la presentación
    DECLARE @NormalizedPresentationName VARCHAR(50);
    SET @NormalizedPresentationName = dbo.normalizeAndFormatText(@PRESENTATION_NAME);
   
    -- Validar los parámetros
    IF @IDE_PRESENTATION IS NULL OR @NormalizedPresentationName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END;

    -- Verificar si la presentación existe
    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe otra presentación con el mismo nombre en la misma compañía
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
               WHERE PRESENTATION_NAME = @NormalizedPresentationName AND IDE_PRESENTATION <> @IDE_PRESENTATION)
    BEGIN
        RAISERROR('Ya existe otra presentación con el mismo nombre', 16, 1);
        RETURN;
    END;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar la presentación
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
        SET PRESENTATION_NAME = @NormalizedPresentationName, DESCRIPTION = @DESCRIPTION
        WHERE IDE_PRESENTATION = @IDE_PRESENTATION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Presentación actualizada exitosamente';
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
-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_update_medication_presentation 
    @IDE_PRESENTATION = '4865c4ff-41cc-4b07-b86f-828922be9f5b',
    @PRESENTATION_NAME = 'TEST001', 
    @DESCRIPTION = 'TEST 11.1.11';
-- ======================================================================================================= --
-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS WHERE IDE_PRESENTATION = '4865c4ff-41cc-4b07-b86f-828922be9f5b';
-- ======================================================================================================= --
-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_presentation;
-- ======================================================================================================= --

-- ==================================================================================================== --
-- ==================================================================================================== --


-- ======================================= Procedimiento: sp_delete_presentation ============================================= --
-- Descripción: Elimina una Presentacion
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_medication_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar el parámetro
    IF @IDE_PRESENTATION IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_PRESENTATION inválido', 16, 1);
        RETURN;
    END

    -- Verificar si la dosificación existe
    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END
    
    BEGIN TRANSACTION;
    BEGIN TRY
    -- Eliminar la presnetacion
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS  WHERE IDE_PRESENTATION = @IDE_PRESENTATION;
    -- Confirmar la transacción
    COMMIT TRANSACTION;

    PRINT 'Presentación eliminada exitosamente';
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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_presentation;
-- ======================================================================================================= --

   -- ======================================== CALL PROCEDURE =============================================== --

EXEC dbo.sp_delete_medication_presentation   
    @IDE_PRESENTATION = '26b37bd0-7566-4b1b-a5d7-d89c4b44ac93';
-- ======================================================================================================= --


-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS ;
-- ======================================================================================================= --
