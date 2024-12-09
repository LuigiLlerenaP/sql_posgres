GO
CREATE FUNCTION dbo.fn_validate_medication
(
    @MEDICATION_NAME VARCHAR(200),
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @IDE_UNIT UNIQUEIDENTIFIER,
    @IDE_DOSAGE UNIQUEIDENTIFIER,
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @IDE_MEDICATION UNIQUEIDENTIFIER = NULL
)
RETURNS NVARCHAR(4000)
AS
BEGIN
    DECLARE @ErrorMsg NVARCHAR(4000) = NULL;

    -- Verificar si el medicamento con el nombre proporcionado ya existe, si @IDE_MEDICATION es NULL
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS 
        WHERE MEDICATION_NAME = @MEDICATION_NAME 
          AND (@IDE_MEDICATION IS NULL OR IDE_MEDICATION <> @IDE_MEDICATION)
    )
    BEGIN
        SET @ErrorMsg = 'El medicamento con el nombre proporcionado ya existe.';
    END

    -- Verificar si existe la categoría
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES 
        WHERE IDE_CATEGORY = @IDE_CATEGORY
    )
    BEGIN
        SET @ErrorMsg = 'No existe esta categoría.';
    END

    -- Verificar si existe la unidad
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
        WHERE IDE_UNIT = @IDE_UNIT
    )
    BEGIN
        SET @ErrorMsg = 'No existe esta unidad.';
    END

    -- Verificar si existe la dosis
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
        WHERE IDE_DOSAGE = @IDE_DOSAGE
    )
    BEGIN
        SET @ErrorMsg = 'No existe esta dosis.';
    END

    -- Verificar si existe el fabricante
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
        WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER
    )
    BEGIN
        SET @ErrorMsg = 'No existe este fabricante.';
    END

    -- Verificar si existe la presentación
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
        WHERE IDE_PRESENTATION = @IDE_PRESENTATION
    )
    BEGIN
        SET @ErrorMsg = 'No existe esta presentación.';
    END

    -- Verificar si existe la ruta de administración
    IF @ErrorMsg IS NULL AND NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
        WHERE IDE_ROUTE = @IDE_ROUTE
    )
    BEGIN
        SET @ErrorMsg = 'No existe esta ruta de administración.';
    END

    RETURN @ErrorMsg;
END;
GO


-- ======================================== DROP Function =============================================== --
DROP FUNCTION IF EXISTS dbo.fn_validate_medication;
-- ======================================================================================================= --