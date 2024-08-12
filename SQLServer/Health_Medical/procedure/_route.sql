---//////////////////////////////////////////////////////////////////////
-- Creacion 
GO
CREATE PROCEDURE dbo.sp_create_route
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que ambos parámetros no sean NULL
    IF @ROUTE_NAME IS NULL OR @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('Ambos parámetros deben ser válidos', 16, 1);
        RETURN;
    END

    -- Verificar si la ruta ya existe
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @ROUTE_NAME AND IDE_COMPANY = @IDE_COMPANY)
    BEGIN
        RAISERROR('La ruta ya existe', 16, 1);
        RETURN;
    END

    -- Insertar la nueva ruta
    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES (IDE_COMPANY, ROUTE_NAME)
    VALUES (@IDE_COMPANY, @ROUTE_NAME);
    
    PRINT 'Ruta creada exitosamente';
END;
GO



--Update 
GO
CREATE PROCEDURE dbo.sp_update_route
(
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_ROUTE IS NULL OR @ROUTE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
                   WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta no existe', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @ROUTE_NAME AND IDE_ROUTE <> @IDE_ROUTE)
    BEGIN
        RAISERROR('Ya existe una ruta con ese nombre', 16, 1);
        RETURN;
    END


    UPDATE T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
    SET ROUTE_NAME = @ROUTE_NAME
    WHERE IDE_ROUTE = @IDE_ROUTE;

    PRINT 'Ruta actualizada exitosamente';
END;
GO
-- Eliminar 
GO
CREATE PROCEDURE dbo.sp_delete_route
(
    @IDE_ROUTE UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el parámetro no sea NULL
    IF @IDE_ROUTE IS NULL
    BEGIN
        RAISERROR('El parámetro IDE_ROUTE no puede ser NULL', 16, 1);
        RETURN;
    END

    -- Verificar si la ruta existe antes de intentar eliminarla
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta no existe', 16, 1);
        RETURN;
    END

    -- Eliminar la ruta
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES
    WHERE IDE_ROUTE = @IDE_ROUTE;

    PRINT 'Ruta eliminada exitosamente';
END;
GO
EXEC dbo.sp_create_route
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @ROUTE_NAME = 'Test5';

    EXEC dbo.sp_delete_route
    @IDE_ROUTE = '87c9c825-71dc-4868-860e-2114c90f0843';
select * from T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES;