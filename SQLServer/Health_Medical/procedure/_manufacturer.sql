---//////////////////////////////////////////////////////////////////////
-- Crear procedimiento para crear un fabricante
GO
CREATE PROCEDURE dbo.sp_create_manufacturer
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_COMPANY IS NULL OR @MANUFACTURER_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND MANUFACTURER_NAME = @MANUFACTURER_NAME)
    BEGIN
        RAISERROR('El fabricante ya existe', 16, 1);
        RETURN;
    END


    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS (IDE_COMPANY, MANUFACTURER_NAME)
    VALUES (@IDE_COMPANY, @MANUFACTURER_NAME);

    PRINT 'Fabricante creado exitosamente';
END;
GO
-- Actualizar fabricante
GO
CREATE PROCEDURE dbo.sp_update_manufacturer
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_MANUFACTURER IS NULL OR @MANUFACTURER_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END


    UPDATE T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS
    SET MANUFACTURER_NAME = @MANUFACTURER_NAME
    WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

    PRINT 'Fabricante actualizado exitosamente';
END;
GO

-- Eliminar fabricante
GO
CREATE PROCEDURE dbo.sp_delete_manufacturer
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

 
    IF @IDE_MANUFACTURER IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_MANUFACTURER inválido', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END


    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

    PRINT 'Fabricante eliminado exitosamente';
END;
GO