-- ======================================= Procedimiento: sp_create_medication_route ============================================= --
-- Descripción: Inserta una nueva ruta de administración para los medicamentos
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_add_medication_route_health
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50),
    @NewRouteID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la ruta
    DECLARE @NormalizedRouteName VARCHAR(50);
    SET @NormalizedRouteName = dbo.fn_normalize_format_text(@ROUTE_NAME);

    -- Validar que ambos parámetros no sean NULL
    IF @NormalizedRouteName IS NULL OR @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('Ambos parámetros deben ser válidos: la compañía y el nombre de la ruta.', 16, 1);
        RETURN;
    END;

    -- Verificar si la ruta ya existe
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @NormalizedRouteName AND IDE_COMPANY = @IDE_COMPANY)
    BEGIN
        RAISERROR('La ruta ''%s'' ya existe para la compañía especificada.', 16, 1, @NormalizedRouteName);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID 
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar la nueva ruta
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES (IDE_COMPANY, ROUTE_NAME, IDE_ROUTE)
        VALUES (@IDE_COMPANY, @NormalizedRouteName, @GeneratedID);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el nuevo ID al parámetro de salida
        SET @NewRouteID = @GeneratedID;

        PRINT 'Ruta creada exitosamente';
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
DECLARE @NewRouteID UNIQUEIDENTIFIER;
-- Llamar al procedimiento almacenado
EXEC dbo.sp_add_medication_route_health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @ROUTE_NAME = 'Tes01',
    @NewRouteID = @NewRouteID OUTPUT ;
-- Mostrar el valor del parámetro de salida
SELECT @NewRouteID AS NewRouteID;

------------------------------------
EXEC dbo.sp_add_medication_route_health
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @ROUTE_NAME = 'OOO01';
-- ==================================== READ THE DOSOAGE ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES WHERE IDE_ROUTE = '23ee55d6-59ba-4e47-b6de-cdd3767aafe4';
-- ======================================================================================================= --

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_add_medication_route_health;
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --



-- ======================================= Procedimiento: sp_update_route ============================================= --
-- Descripción: Actualiza un nombre de ruta de administración para medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_route_health
(
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la ruta
    DECLARE @NormalizedRouteName VARCHAR(50);
    SET @NormalizedRouteName = dbo.fn_normalize_format_text(@ROUTE_NAME);

    -- Validar los parámetros
    IF @IDE_ROUTE IS NULL OR @NormalizedRouteName IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos: la ruta y el nombre deben ser válidos.', 16, 1);
        RETURN;
    END;

    -- Verificar si la ruta existe
    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
                   WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta con el ID especificado no existe.', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe otra ruta con el mismo nombre
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @NormalizedRouteName AND IDE_ROUTE <> @IDE_ROUTE)
    BEGIN
        RAISERROR('Ya existe una ruta con el nombre ''%s''.', 16, 1, @NormalizedRouteName);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar la ruta
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
        SET ROUTE_NAME = @NormalizedRouteName
        WHERE IDE_ROUTE = @IDE_ROUTE;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Ruta actualizada exitosamente.';
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
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_route;
-- ======================================================================================================= --
-- ==================================== READ THE DOSAGE ================================================ --
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES WHERE IDE_ROUTE = '23ee55d6-59ba-4e47-b6de-cdd3767aafe4';
-- ======================================================================================================= --
-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_update_medication_route
    @IDE_ROUTE = '23ee55d6-59ba-4e47-b6de-cdd3767aafe4',
    @ROUTE_NAME = 'OOO0111';
-- ======================================================================================================= --

-- ==================================================================================================== --
-- ==================================================================================================== --


-- ======================================= Procedimiento: sp_delete_medication_route ============================================= --
-- Descripción: Elimina una ruta de administración de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_medication_route_health
(
    @IDE_ROUTE UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el parámetro no sea NULL
    IF @IDE_ROUTE IS NULL
    BEGIN
        RAISERROR('El parámetro IDE_ROUTE no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar si la ruta existe antes de intentar eliminarla
    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
                   WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta con el ID especificado no existe.', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar la ruta
        DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES
        WHERE IDE_ROUTE = @IDE_ROUTE;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Ruta eliminada exitosamente.';
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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_route_health;
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE =============================================== --
EXEC dbo.sp_delete_medication_route_health
@IDE_ROUTE = '23ee55d6-59ba-4e47-b6de-cdd3767aafe4';
-- ======================================================================================================= --