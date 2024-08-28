-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_add_type_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_insert_evaluation_type
-- Descripción:   Insertar un nuevo tipo de evaluación en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_add_type_evaluation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @TYPE_EVALUATION NVARCHAR(255),
    @DESCRIPTION VARCHAR(255) = NULL,
    @NewEvaluationTypeID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;
    SET @TYPE_EVALUATION = dbo.fn_normalize_format_text(@TYPE_EVALUATION);
    SET @DESCRIPTION =  dbo.fn_normalize_format_description(@DESCRIPTION);
    
    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @TYPE_EVALUATION IS NULL 
    BEGIN
        RAISERROR('El tipo de evaluación no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    IF EXISTS ( 
        SELECT  1 
        FROM    T_RRHH_PERFORMANCE_EVALUATIONS_TYPES 
        WHERE   TYPE_EVALUATION = @TYPE_EVALUATION 
        AND IDE_COMPANY = @IDE_COMPANY
    )
    BEGIN
        RAISERROR('Ya existe un tipo de evaluación con este nombre.', 16, 1);
        RETURN;
    END;
    BEGIN TRANSACTION;
    BEGIN TRY
      SET @NewEvaluationTypeID = NEWID();

              INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_TYPES 
            (IDE_EVALUATION_TYPE, IDE_COMPANY, TYPE_EVALUATION, DESCRIPTION)
        VALUES 
            (@NewEvaluationTypeID, @IDE_COMPANY, @TYPE_EVALUATION, @DESCRIPTION);
          COMMIT TRANSACTION;
        PRINT 'Tipo de evaluación insertado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
-- Llamada al procedimiento almacenado
DECLARE @NewEvaluationTypeID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_type_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @TYPE_EVALUATION = 'PROBATIONARY_TEST',
    @DESCRIPTION = 'Descripción para evaluación de prueba.',
    @NewEvaluationTypeID = @NewEvaluationTypeID OUTPUT;

-- Mostrar el nuevo ID generado
SELECT @NewEvaluationTypeID AS NewEvaluationTypeID;
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_TYPES 
WHERE  IDE_EVALUATION_TYPE  = '1b05b836-89a6-42ec-b4e1-23126a240880';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_update_type_evaluation;
GO
-- ====================================================================================================
-- Procedimiento: dbo.sp_update_type_evaluation
-- Descripción:   Actualizar un tipo de evaluación basado en su ID
-- ====================================================================================================
GO
CREATE PROCEDURE dbo.sp_update_type_evaluation
(
    @IDE_EVALUATION_TYPE UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @TYPE_EVALUATION NVARCHAR(255),
    @DESCRIPTION VARCHAR(255) = NULL
)
AS 
BEGIN
    SET NOCOUNT ON;
    
    -- Normalizar campos
    SET @TYPE_EVALUATION = dbo.fn_normalize_format_text(@TYPE_EVALUATION);
    SET @DESCRIPTION = dbo.fn_normalize_format_description(@DESCRIPTION);

    -- Validar campos
    IF @IDE_EVALUATION_TYPE IS NULL
    BEGIN
        RAISERROR('El ID del tipo de evaluación no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @TYPE_EVALUATION IS NULL OR LEN(@TYPE_EVALUATION) = 0
    BEGIN
        RAISERROR('El tipo de evaluación no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
    SELECT 1
    FROM T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
    WHERE IDE_EVALUATION_TYPE = @IDE_EVALUATION_TYPE
    )
    BEGIN
        RAISERROR('El tipo de evaluación especificado no existe.', 16, 1);
        RETURN;
    END;


    -- Verificar si existe un tipo de evaluación con el mismo nombre bajo la misma compañía
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
        WHERE TYPE_EVALUATION = @TYPE_EVALUATION
          AND IDE_COMPANY = @IDE_COMPANY
          AND IDE_EVALUATION_TYPE <> @IDE_EVALUATION_TYPE
    )
    BEGIN
        RAISERROR('Ya existe un tipo de evaluación con este nombre bajo la misma compañía.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el tipo de evaluación
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
        SET 
            TYPE_EVALUATION = @TYPE_EVALUATION,
            DESCRIPTION = @DESCRIPTION
        WHERE 
            IDE_EVALUATION_TYPE = @IDE_EVALUATION_TYPE
            AND IDE_COMPANY = @IDE_COMPANY;

        COMMIT TRANSACTION;
        PRINT 'Tipo de evaluación actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
-- ======================================== CALL PROCEDURE ============================================== --

------------------------------------
GO 
EXEC dbo.sp_update_type_evaluation
    @IDE_EVALUATION_TYPE = '1b05b836-89a6-42ec-b4e1-23126a240880', 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @TYPE_EVALUATION = 'UPDATE_RECOMENDACI', 
    @DESCRIPTION = 'Descripción actualizada del conjunto de recomendaciones para evaluaciones anuales.';

-- ==================================================================================================== --
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_TYPES 
WHERE IDE_EVALUATION_TYPE  = '1b05b836-89a6-42ec-b4e1-23126a240880';
-- ======================================================================================================= --





-- ==================================================================================================== --
-- Procedimiento: dbo.sp_delete_type_evaluation
-- Descripción:   Eliminar un tipo de padre
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_type_evaluation
(
    @IDE_EVALUATION_TYPE UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validar campos
    IF @IDE_EVALUATION_TYPE IS NULL
    BEGIN
        RAISERROR('El ID del tipo de evaluación no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar si el tipo de evaluación existe
    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
        WHERE IDE_EVALUATION_TYPE = @IDE_EVALUATION_TYPE
    )
    BEGIN
        RAISERROR('El tipo de evaluación especificado no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el tipo de evaluación
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_TYPES
        WHERE IDE_EVALUATION_TYPE = @IDE_EVALUATION_TYPE;

        COMMIT TRANSACTION;
        PRINT 'Tipo de evaluación eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_delete_type_evaluation
    @IDE_EVALUATION_TYPE = '1b05b836-89a6-42ec-b4e1-23126a240880';