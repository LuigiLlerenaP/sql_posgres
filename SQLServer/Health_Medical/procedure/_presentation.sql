---//////////////////////////////////////////////////////////////////////
-- Creacion procedimiento presentacion
GO
CREATE PROCEDURE dbo.sp_create_presentation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_COMPANY IS NULL OR @PRESENTATION_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND PRESENTATION_NAME = @PRESENTATION_NAME)
    BEGIN
        RAISERROR('La presentación ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS (IDE_COMPANY, PRESENTATION_NAME, DESCRIPTION)
    VALUES (@IDE_COMPANY, @PRESENTATION_NAME, @DESCRIPTION);

    PRINT 'Presentación creada exitosamente';
END;
GO
--- Actualizar 
GO
CREATE PROCEDURE dbo.sp_update_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_PRESENTATION IS NULL OR @PRESENTATION_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END

    UPDATE T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    SET PRESENTATION_NAME = @PRESENTATION_NAME, DESCRIPTION = @DESCRIPTION
    WHERE IDE_PRESENTATION = @IDE_PRESENTATION;

    PRINT 'Presentación actualizada exitosamente';
END;
GO
-- Eliminar 
GO
CREATE PROCEDURE dbo.sp_delete_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_PRESENTATION IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_PRESENTATION inválido', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END

    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    WHERE IDE_PRESENTATION = @IDE_PRESENTATION;

    PRINT 'Presentación eliminada exitosamente';
END;
GO

-- Crear una presentación con descripción
EXEC dbo.sp_create_presentation 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PRESENTATION_NAME = 'Test 11', 
    @DESCRIPTION = 'Test 111 ';

EXEC dbo.sp_update_presentation 
    @IDE_PRESENTATION = '4696862c-71eb-41b4-8a4a-5e1c43c9c721',
    @PRESENTATION_NAME = 'Cápsulas Mejoradas', 
    @DESCRIPTION = 'Nueva fórmula para administración en cápsulas';

EXEC dbo.sp_delete_presentation   
    @IDE_PRESENTATION = '4696862c-71eb-41b4-8a4a-5e1c43c9c721';
