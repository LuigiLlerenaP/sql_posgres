----
GO
CREATE PROCEDURE dbo.sp_add_performance_evaluation_section
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @IDE_QUESTION_SET UNIQUEIDENTIFIER,
    @SECTION_NAME VARCHAR(250),
    @NewSectionID UNIQUEIDENTIFIER = NULL OUTPUT
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

    IF @IDE_QUESTION_SET IS NULL
    BEGIN
        RAISERROR('El ID del set de preguntas no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @SECTION_NAME IS NULL OR LEN(@SECTION_NAME) = 0
    BEGIN
        RAISERROR('El nombre de la sección no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    -- Normalizar el nombre de la sección
    SET @SECTION_NAME = dbo.fn_normalize_format_text(@SECTION_NAME);

    -- Verificar si ya existe una sección con el mismo nombre
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS 
        WHERE SECTION_NAME = @SECTION_NAME 
        AND IDE_COMPANY = @IDE_COMPANY
    )
    BEGIN
        RAISERROR('Ya existe una sección con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID para la sección
        SET @NewSectionID = NEWID();

        -- Insertar la nueva sección
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS
        (IDE_SECTION, IDE_COMPANY, IDE_QUESTION_SET, SECTION_NAME)
        VALUES 
        (@NewSectionID, @IDE_COMPANY, @IDE_QUESTION_SET, @SECTION_NAME);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Sección de evaluación insertada exitosamente.';
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
-----


GO
CREATE PROCEDURE dbo.sp_update_performance_evaluation_section
(
    @IDE_SECTION UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER = NULL,
    @IDE_QUESTION_SET UNIQUEIDENTIFIER = NULL,
    @SECTION_NAME VARCHAR(250) = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_SECTION IS NULL
    BEGIN
        RAISERROR('El ID de la sección no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Normalizar el nombre de la sección si es proporcionado
    IF @SECTION_NAME IS NOT NULL
    BEGIN
        SET @SECTION_NAME = dbo.fn_normalize_format_text(@SECTION_NAME);

        -- Validación de longitud del nombre de la sección
        IF LEN(@SECTION_NAME) > 250
        BEGIN
            RAISERROR('El nombre de la sección no puede exceder los 250 caracteres.', 16, 1);
            RETURN;
        END;

        -- Verificar si ya existe una sección con el mismo nombre
        IF EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS 
            WHERE SECTION_NAME = @SECTION_NAME 
            AND IDE_SECTION <> @IDE_SECTION
        )
        BEGIN
            RAISERROR('Ya existe una sección con este nombre.', 16, 1);
            RETURN;
        END;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el registro
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS
        SET 
            IDE_COMPANY = ISNULL(@IDE_COMPANY, IDE_COMPANY),
            IDE_QUESTION_SET = ISNULL(@IDE_QUESTION_SET, IDE_QUESTION_SET),
            SECTION_NAME = ISNULL(@SECTION_NAME, SECTION_NAME)
        WHERE 
            IDE_SECTION = @IDE_SECTION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Sección de evaluación actualizada exitosamente.';
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



--
GO
CREATE PROCEDURE dbo.sp_delete_performance_evaluation_section
(
    @IDE_SECTION UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_SECTION IS NULL
    BEGIN
        RAISERROR('El ID de la sección no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Verificar si la sección existe antes de intentar eliminarla
        IF NOT EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS 
            WHERE IDE_SECTION = @IDE_SECTION
        )
        BEGIN
            RAISERROR('No se encontró una sección con el ID proporcionado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Eliminar la sección
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS
        WHERE IDE_SECTION = @IDE_SECTION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Sección de evaluación eliminada exitosamente.';
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
