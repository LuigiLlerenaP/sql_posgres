GO
CREATE PROCEDURE dbo.sp_add_performance_evaluation_question
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @QUESTION VARCHAR(MAX),
    @NewQuestionID UNIQUEIDENTIFIER = NULL OUTPUT
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

    IF @IDE_CATEGORY IS NULL
    BEGIN
        RAISERROR('El ID de la categoría no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @QUESTION IS NULL OR LEN(@QUESTION) = 0
    BEGIN
        RAISERROR('La pregunta no puede ser NULL o vacía.', 16, 1);
        RETURN;
    END;

    -- Normalizar la pregunta
    SET @QUESTION = dbo.fn_normalize_format_text(@QUESTION);

    -- Verificar si ya existe una pregunta con el mismo texto en la misma categoría
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS 
        WHERE QUESTION = @QUESTION 
        AND IDE_CATEGORY = @IDE_CATEGORY
    )
    BEGIN
        RAISERROR('Ya existe una pregunta con este texto en la misma categoría.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID para la pregunta
        SET @NewQuestionID = NEWID();

        -- Insertar la nueva pregunta
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS
        (IDE_QUESTION, IDE_COMPANY, IDE_CATEGORY, QUESTION)
        VALUES 
        (@NewQuestionID, @IDE_COMPANY, @IDE_CATEGORY, @QUESTION);

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Pregunta de evaluación insertada exitosamente.';
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
-----------------------

GO
CREATE PROCEDURE dbo.sp_update_performance_evaluation_question
(
    @IDE_QUESTION UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER = NULL,
    @IDE_CATEGORY UNIQUEIDENTIFIER = NULL,
    @QUESTION VARCHAR(MAX) = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_QUESTION IS NULL
    BEGIN
        RAISERROR('El ID de la pregunta no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Normalizar la pregunta si es proporcionada
    IF @QUESTION IS NOT NULL
    BEGIN
        SET @QUESTION = dbo.fn_normalize_format_text(@QUESTION);

        -- Verificación de longitud de la pregunta
        IF LEN(@QUESTION) = 0
        BEGIN
            RAISERROR('La pregunta no puede estar vacía.', 16, 1);
            RETURN;
        END;

        -- Verificar si ya existe una pregunta con el mismo texto en la misma categoría
        IF EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS 
            WHERE QUESTION = @QUESTION 
            AND IDE_QUESTION <> @IDE_QUESTION
            AND IDE_CATEGORY = ISNULL(@IDE_CATEGORY, IDE_CATEGORY)
        )
        BEGIN
            RAISERROR('Ya existe una pregunta con este texto en la misma categoría.', 16, 1);
            RETURN;
        END;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el registro
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS
        SET 
            IDE_COMPANY = ISNULL(@IDE_COMPANY, IDE_COMPANY),
            IDE_CATEGORY = ISNULL(@IDE_CATEGORY, IDE_CATEGORY),
            QUESTION = ISNULL(@QUESTION, QUESTION)
        WHERE 
            IDE_QUESTION = @IDE_QUESTION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Pregunta de evaluación actualizada exitosamente.';
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
---
GO
CREATE PROCEDURE dbo.sp_delete_performance_evaluation_question
(
    @IDE_QUESTION UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validación de entrada
    IF @IDE_QUESTION IS NULL
    BEGIN
        RAISERROR('El ID de la pregunta no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Iniciar la transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Verificar si la pregunta existe antes de intentar eliminarla
        IF NOT EXISTS (
            SELECT 1 
            FROM T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS 
            WHERE IDE_QUESTION = @IDE_QUESTION
        )
        BEGIN
            RAISERROR('No se encontró una pregunta con el ID proporcionado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Eliminar la pregunta
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS
        WHERE IDE_QUESTION = @IDE_QUESTION;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Pregunta de evaluación eliminada exitosamente.';
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
