-- ========================================== Procedimiento:sp_create_manufacturer ================================================ --
-- Descripción: Inserta un nuevo fabricante para los medicamentos
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_add_medication_manufacturer_health
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50),
    @NewManufacturerID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre del fabricante
    DECLARE @NormalizedManufacturerName VARCHAR(50);
    SET @NormalizedManufacturerName = dbo.fn_normalize_format_text(@MANUFACTURER_NAME);

    -- Validar que los parámetros sean válidos
    IF @IDE_COMPANY IS NULL OR @NormalizedManufacturerName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe un fabricante con el mismo nombre
    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND MANUFACTURER_NAME = @NormalizedManufacturerName)
    BEGIN
        RAISERROR('El fabricante ya existe', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID 
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar el nuevo fabricante    
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS (IDE_MANUFACTURER, IDE_COMPANY, MANUFACTURER_NAME)
        VALUES (@GeneratedID, @IDE_COMPANY, @NormalizedManufacturerName);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el nuevo ID al parámetro de salida
        SET @NewManufacturerID = @GeneratedID;
        PRINT 'Fabricante creado exitosamente';

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
-- Declarar una variable para capturar el ID 
DECLARE @NewManufacturerID UNIQUEIDENTIFIER;
-- Llamar al procedimiento almacenado
EXEC dbo.sp_add_medication_manufacturer_health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @MANUFACTURER_NAME = 'Test 001',
    @NewManufacturerID = @NewManufacturerID OUTPUT;
-- Mostrar el valor del parámetro de salida
SELECT @NewManufacturerID AS NewManufacturerID;

------------------------------------
-- Ejecutar otra inserción
EXEC dbo.sp_add_medication_manufacturer_health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @MANUFACTURER_NAME = 'Test 02';

-- ==================================== READ THE MANUFACTURER ============================================ --
-- Verificar que el fabricante fue creado correctamente utilizando el ID generado
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = 'efa7e671-1f5b-4a51-9069-9428f669052a';

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_add_medication_manufacturer_health;
-- ======================================================================================================= --



-- ==================================================================================================== --
-- ==================================================================================================== --





-- ======================================= Procedimiento: sp_update_manufacturer     ============================================= --
-- Descripción: Actualiza un manufacute de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_manufacturer_health
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre del fabricante
    DECLARE @NormalizedManufacturerName VARCHAR(50);
    SET @NormalizedManufacturerName = dbo.fn_normalize_format_text(@MANUFACTURER_NAME);

    -- Validar los parámetros
    IF @IDE_MANUFACTURER IS NULL OR @NormalizedManufacturerName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END;

    -- Verificar si la categoría existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END;

   -- Verificar si ya existe otro fabricante con el mismo nombre
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
               WHERE MANUFACTURER_NAME = @NormalizedManufacturerName 
                 AND IDE_MANUFACTURER <> @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('Ya existe un fabricante con el nombre ''%s''.', 16, 1, @NormalizedManufacturerName);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
      -- Actualizar la manufacture con el nombre normalizado
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS

        SET MANUFACTURER_NAME = @NormalizedManufacturerName
        WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Fabricante actualizado exitosamente';
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
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_manufacturer_health;
-- ======================================================================================================= --
-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = 'efa7e671-1f5b-4a51-9069-9428f669052a';
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_update_medication_manufacturer_health
     @IDE_MANUFACTURER = 'efa7e671-1f5b-4a51-9069-9428f669052a',
     @MANUFACTURER_NAME = 'Nuevo Nombre del Fabricante';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --



-- ======================================= Procedimiento: sp_delete_manufacturer ============================================= --
-- Descripción: Elimina una manufacture de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_medication_manufacturer_health
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

   -- Validar el parámetro
    IF @IDE_MANUFACTURER IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_MANUFACTURER inválido', 16, 1);
        RETURN;
    END


    -- Verificar si la dosificación existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
     -- Eliminar la manufactura
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
        WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

    -- Confirmar la transacción
    COMMIT TRANSACTION;
    
    PRINT 'Fabricante eliminado exitosamente';

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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_manufacturer_health;
-- ======================================================================================================= --


   -- ======================================== CALL PROCEDURE =============================================== --

EXEC dbo.sp_delete_medication_manufacturer_health
    @IDE_MANUFACTURER = '89de6053-b6fd-4c47-b72d-2c7625d974ae';
-- ======================================================================================================= --

SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS ;