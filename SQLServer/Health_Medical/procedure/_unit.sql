---//////////////////////////////////////////////////////////////////////
-- Crear procedimiento para crear una unidad
GO
CREATE PROCEDURE dbo.sp_create_occupational_health_unit
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_COMPANY IS NULL OR @UNIT_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    -- Verificar si la unidad ya existe
    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND UNIT_NAME = @UNIT_NAME)
    BEGIN
        RAISERROR('La unidad ya existe', 16, 1);
        RETURN;
    END

    -- Insertar nueva unidad
    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_UNITS (IDE_COMPANY, UNIT_NAME, ABBREVIATION)
    VALUES (@IDE_COMPANY, @UNIT_NAME, @ABBREVIATION);

    PRINT 'Unidad creada exitosamente';
END;
GO

-- Actualizar unidad
GO
CREATE PROCEDURE dbo.sp_update_occupational_health_unit
(
    @IDE_UNIT UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_UNIT IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_UNIT inválido', 16, 1);
        RETURN;
    END

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad no existe', 16, 1);
        RETURN;
    END

    -- Actualizar la unidad
    UPDATE T_RRHH_OCUPATIONAL_HEALTH_UNITS
    SET UNIT_NAME = @UNIT_NAME, ABBREVIATION = @ABBREVIATION
    WHERE IDE_UNIT = @IDE_UNIT;

    PRINT 'Unidad actualizada exitosamente';
END;
GO

-- Eliminar unidad
GO
CREATE PROCEDURE dbo.sp_delete_occupational_health_unit
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
    END

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad no existe', 16, 1);
        RETURN;
    END

    -- Eliminar la unidad
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT;

    PRINT 'Unidad eliminada exitosamente';
END;
GO

EXEC dbo.sp_create_occupational_health_unit 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @UNIT_NAME = 'Test_1',
    @ABBREVIATION = 'Test1';

EXEC dbo.sp_update_occupational_health_unit 
    @IDE_UNIT = '4e09c593-23fb-4c88-8932-cbf0cd5bd862',
    @UNIT_NAME = 't1',
    @ABBREVIATION = 'g1';

EXEC dbo.sp_delete_occupational_health_unit 
    @IDE_UNIT = '4e09c593-23fb-4c88-8932-cbf0cd5bd862';


SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS;
