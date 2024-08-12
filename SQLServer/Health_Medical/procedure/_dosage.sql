---//////////////////////////////////////////////////////////////////////
-- Creacion procedimiento dosis 
GO
CREATE PROCEDURE dbo.sp_create_dosage
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @DOSAGE_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_COMPANY IS NULL OR @DOSAGE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
               WHERE IDE_COMPANY = @IDE_COMPANY AND DOSAGE_NAME = @DOSAGE_NAME)
    BEGIN
        RAISERROR('La dosificación ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_DOSAGES (IDE_COMPANY, DOSAGE_NAME, DESCRIPTION)
    VALUES (@IDE_COMPANY, @DOSAGE_NAME, @DESCRIPTION);

    PRINT 'Dosificación creada exitosamente';
END;
GO

--Actualizar dosis
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

    IF @IDE_DOSAGE IS NULL OR @DOSAGE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END

    UPDATE T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
    SET DOSAGE_NAME = @DOSAGE_NAME, DESCRIPTION = @DESCRIPTION
    WHERE IDE_DOSAGE = @IDE_DOSAGE;

    PRINT 'Dosificación actualizada exitosamente';
END;
GO

--Eliminar dosis 
GO
CREATE PROCEDURE dbo.sp_delete_dosage
(
    @IDE_DOSAGE UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON; 

    IF @IDE_DOSAGE IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_DOSAGE inválido', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END

    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE;

    PRINT 'Dosificación eliminada exitosamente';
END;
GO

EXEC dbo.sp_create_dosage 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @DOSAGE_NAME = 'Test1', 
    @DESCRIPTION = 'Test 11111';

EXEC dbo.sp_update_dosage
    @IDE_DOSAGE = '1f777f34-241d-4b79-9111-c346b4d7a2f4',
    @DOSAGE_NAME = 'Test update 1';

EXEC dbo.sp_delete_dosage
   @IDE_DOSAGE = 'bc28c39f-56aa-4c74-80ac-665b10770a57';