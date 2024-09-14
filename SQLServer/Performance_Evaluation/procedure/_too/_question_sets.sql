CREATE PROCEDURE dbo.sp_add_performance_question_set
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @IDE_EVALUATION_TYPE UNIQUEIDENTIFIER,
    @TEMPLATE_NAME VARCHAR(255),
    @DESCRIPTION TEXT = NULL,
    @NewQuestionSetID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar el nombre del template
    SET @TEMPLATE_NAME = dbo.fn_normalize_format_text(@TEMPLATE_NAME);

    -- Validaciones
    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @IDE_EVALUATION_TYPE IS NULL
    BEGIN
        RAISERROR('El ID del tipo de evaluación no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @TEMPLATE_NAME IS NULL OR LEN(@TEMPLATE_NAME) = 0
    BEGIN
        RAISERROR('El nombre del template no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    IF LEN(@TEMPLATE_NAME) > 255
    BEGIN
        RAISERROR('El nombre del template no puede exceder los 255 caracteres.', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe un template con el mismo nombre
    IF EXISTS ( 
        SELECT 1 
        FROM RRHH_PERFORMANCE_QUESTION_SETS 
        WHERE TEMPLATE_NAME = @TEMPLATE_NAME 
    )
    BEGIN
        RAISERROR('Ya existe un template con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID para el set de preguntas
        SET @NewQuestionSetID = NEWID();

        -- Insertar el nuevo registro en la tabla
        INSERT INTO RRHH_PERFORMANCE_QUESTION_SETS 
        (
            IDE_QUESTION_SET, 
            IDE_COMPANY, 
            IDE_EVALUATION_TYPE, 
            TEMPLATE_NAME, 
            DESCRIPTION
        )
        VALUES 
        (
            @NewQuestionSetID, 
            @IDE_COMPANY, 
            @IDE_EVALUATION_TYPE, 
            @TEMPLATE_NAME, 
            @DESCRIPTION
        );

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Set de preguntas de evaluación insertado exitosamente.';
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


---- update
GO
CREATE PROCEDURE dbo.sp_update_performance_question_set
(
    @IDE_QUESTION_SET UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER = NULL,
    @IDE_EVALUATION_TYPE UNIQUEIDENTIFIER = NULL,
    @TEMPLATE_NAME VARCHAR(255) = NULL,
    @DESCRIPTION TEXT = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Verificar que el ID del set de preguntas no sea NULL
    IF @IDE_QUESTION_SET IS NULL
    BEGIN
        RAISERROR('El ID del set de preguntas no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Normalizar el nombre del template si es proporcionado
    IF @TEMPLATE_NAME IS NOT NULL
    BEGIN
        SET @TEMPLATE_NAME = dbo.fn_normalize_format_text(@TEMPLATE_NAME);

        -- Validación de longitud del template
        IF LEN(@TEMPLATE_NAME) > 255
        BEGIN
            RAISERROR('El nombre del template no puede exceder los 255 caracteres.', 16, 1);
            RETURN;
        END;

        -- Verificar si ya existe un template con el mismo nombre en otra entrada
        IF EXISTS (
            SELECT 1 
            FROM RRHH_PERFORMANCE_QUESTION_SETS 
            WHERE TEMPLATE_NAME = @TEMPLATE_NAME 
            AND IDE_QUESTION_SET <> @IDE_QUESTION_SET
        )
        BEGIN
            RAISERROR('Ya existe un template con este nombre.', 16, 1);
            RETURN;
        END;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el registro
        UPDATE RRHH_PERFORMANCE_QUESTION_SETS
        SET 
            IDE_COMPANY = ISNULL(@IDE_COMPANY, IDE_COMPANY),
            IDE_EVALUATION_TYPE = ISNULL(@IDE_EVALUATION_TYPE, IDE_EVALUATION_TYPE),
            TEMPLATE_NAME = ISNULL(@TEMPLATE_NAME, TEMPLATE_NAME),
            DESCRIPTION = ISNULL(@DESCRIPTION, DESCRIPTION)
        WHERE 
            IDE_QUESTION_SET = @IDE_QUESTION_SET;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Set de preguntas de evaluación actualizado exitosamente.';
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

---------------
GO
CREATE PROCEDURE dbo.sp_delete_performance_question_set
(
    @IDE_QUESTION_SET UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Verificar que el ID del set de preguntas no sea NULL
    IF @IDE_QUESTION_SET IS NULL
    BEGIN
        RAISERROR('El ID del set de preguntas no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Verificar si el set de preguntas existe antes de intentar eliminarlo
        IF NOT EXISTS (
            SELECT 1 
            FROM RRHH_PERFORMANCE_QUESTION_SETS 
            WHERE IDE_QUESTION_SET = @IDE_QUESTION_SET
        )
        BEGIN
            RAISERROR('No se encontró un set de preguntas con el ID proporcionado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Eliminar el registro
        DELETE FROM RRHH_PERFORMANCE_QUESTION_SETS
        WHERE IDE_QUESTION_SET = @IDE_QUESTION_SET;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Set de preguntas de evaluación eliminado exitosamente.';
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
