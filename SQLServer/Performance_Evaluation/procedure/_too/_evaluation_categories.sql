-- ==================================================================================================== --
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_add_performance_evaluation_category
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @IDE_SECTION UNIQUEIDENTIFIER,
    @CATEGORY_NAME VARCHAR(250),
    @NewCategoryID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @IDE_SECTION IS NULL
    BEGIN
        RAISERROR('El ID de la sección no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @CATEGORY_NAME IS NULL OR LEN(@CATEGORY_NAME) = 0
    BEGIN
        RAISERROR('El nombre de la categoría no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    -- Normalizar el nombre de la categoría
    SET @CATEGORY_NAME = dbo.fn_normalize_format_text(@CATEGORY_NAME);

    -- Verificar si ya existe una categoría con el mismo nombre en la misma sección
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES 
        WHERE CATEGORY_NAME = @CATEGORY_NAME 
        AND IDE_SECTION = @IDE_SECTION
    )
    BEGIN
        RAISERROR('Ya existe una categoría con este nombre en la misma sección.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID para la categoría
        SET @NewCategoryID = NEWID();

        -- Insertar la nueva categoría
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES
        (IDE_CATEGORY, IDE_COMPANY, IDE_SECTION, CATEGORY_NAME)
        VALUES 
        (@NewCategoryID, @IDE_COMPANY, @IDE_SECTION, @CATEGORY_NAME);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Categoría de evaluación insertada exitosamente.';
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

-- ==================================================================================================== --
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_update_performance_evaluation_category
(
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER = NULL,
    @IDE_SECTION UNIQUEIDENTIFIER = NULL,
    @CATEGORY_NAME VARCHAR(250) = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    
    IF @IDE_CATEGORY IS NULL
    BEGIN
        RAISERROR('El ID de la categoría no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Normalizar el nombre de la categoría si es proporcionado
    IF @CATEGORY_NAME IS NOT NULL
    BEGIN
        SET @CATEGORY_NAME = dbo.fn_normalize_format_text(@CATEGORY_NAME);

        -- Validación de longitud del nombre de la categoría
        IF LEN(@CATEGORY_NAME) > 250
        BEGIN
            RAISERROR('El nombre de la categoría no puede exceder los 250 caracteres.', 16, 1);
            RETURN;
        END;

        -- Verificar si ya existe una categoría con el mismo nombre en la misma sección
        IF EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES 
            WHERE CATEGORY_NAME = @CATEGORY_NAME 
            AND IDE_CATEGORY <> @IDE_CATEGORY
            AND IDE_SECTION = ISNULL(@IDE_SECTION, IDE_SECTION)
        )
        BEGIN
            RAISERROR('Ya existe una categoría con este nombre en la misma sección.', 16, 1);
            RETURN;
        END;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el registro
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES
        SET 
            IDE_COMPANY = ISNULL(@IDE_COMPANY, IDE_COMPANY),
            IDE_SECTION = ISNULL(@IDE_SECTION, IDE_SECTION),
            CATEGORY_NAME = ISNULL(@CATEGORY_NAME, CATEGORY_NAME)
        WHERE 
            IDE_CATEGORY = @IDE_CATEGORY;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Categoría de evaluación actualizada exitosamente.';
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

-- ==================================================================================================== --
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_performance_evaluation_category
(
    @IDE_CATEGORY UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_CATEGORY IS NULL
    BEGIN
        RAISERROR('El ID de la categoría no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Verificar si la categoría existe antes de intentar eliminarla
        IF NOT EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES 
            WHERE IDE_CATEGORY = @IDE_CATEGORY
        )
        BEGIN
            RAISERROR('No se encontró una categoría con el ID proporcionado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Eliminar la categoría
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES
        WHERE IDE_CATEGORY = @IDE_CATEGORY;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Categoría de evaluación eliminada exitosamente.';
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
