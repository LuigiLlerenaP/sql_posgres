-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_add_parent_recommendation_set_evaluation;
-- ==================================================================================================== --

-- ==================================================================================================== --
-- Procedimiento: dbo.sp_add_parent_recommendation_set_evaluation
-- Descripción:   Agregar una recomendación padre para la evaluación
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_add_parent_recommendation_set_evaluation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @RECOMMENDATION_NAME VARCHAR(255),
    @RECOMMENDATION_DESCRIPTION VARCHAR(4000),
    @NewRecommendationSetID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar campos
    SET @RECOMMENDATION_NAME = dbo.fn_normalize_format_text(@RECOMMENDATION_NAME);
    SET @RECOMMENDATION_DESCRIPTION = dbo.fn_normalize_format_description(@RECOMMENDATION_DESCRIPTION);

    -- Validar campos
    IF @RECOMMENDATION_NAME IS NULL OR LEN(@RECOMMENDATION_NAME) = 0
    BEGIN
        RAISERROR('El nombre de la recomendación es inválido o está vacío.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_DESCRIPTION IS NULL OR LEN(@RECOMMENDATION_DESCRIPTION) = 0
    BEGIN
        RAISERROR('La descripción de la recomendación es inválida o está vacía.', 16, 1);
        RETURN;
    END;

    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar duplicados
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_COMPANY = @IDE_COMPANY 
          AND RECOMMENDATION_NAME = @RECOMMENDATION_NAME
    )
    BEGIN
        RAISERROR('Ya existe un conjunto de recomendaciones con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        SET @NewRecommendationSetID = NEWID();
        
        -- Insertar nueva recomendación
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
            (IDE_RECOMMENDATION_SET, IDE_COMPANY, RECOMMENDATION_NAME, RECOMMENDATION_DESCRIPTION)
        VALUES 
            (@NewRecommendationSetID, @IDE_COMPANY, @RECOMMENDATION_NAME, @RECOMMENDATION_DESCRIPTION);
        
        COMMIT TRANSACTION;
        PRINT 'Conjunto de recomendaciones creado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO

-- ======================================== CALL PROCEDURE ============================================== --

-- ========================================= Agregar Nueva Recomendación ===================================
GO 
DECLARE @NewRecommendationSetID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_parent_recommendation_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @RECOMMENDATION_NAME = 'Recomendación Principal',
    @RECOMMENDATION_DESCRIPTION = 'Descripción detallada de la recomendación principal.',
    @NewRecommendationSetID = @NewRecommendationSetID OUTPUT;  

-- Mostrar el nuevo ID generado
SELECT @NewRecommendationSetID AS NewRecommendationSetID;

-- ========================================= Agregar Otra Recomendación ===================================
EXEC dbo.sp_add_parent_recommendation_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @RECOMMENDATION_NAME = 'Recomendación Secundaria',
    @RECOMMENDATION_DESCRIPTION = 'Descripción detallada de la recomendación secundaria.';
-- ==================================================================================================== --
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
WHERE  IDE_RECOMMENDATION_SET = '6b09ef7a-91cb-46c3-baf4-f346ba8a5e56';
-- ======================================================================================================= --

-- ==================================================================================================== --
-- ==================================================================================================== --

-- ==================================================================================================== --
-- Procedimiento: dbo.sp_update_parent_recommendation_set_evaluation
-- Descripción:   Actualizar una recomendación existente en la evaluación
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_update_parent_recommendation_set_evaluation
(
    @IDE_RECOMMENDATION_SET UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @RECOMMENDATION_NAME VARCHAR(255),
    @RECOMMENDATION_DESCRIPTION VARCHAR(4000)
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar campos
    SET @RECOMMENDATION_NAME = dbo.fn_normalize_format_text(@RECOMMENDATION_NAME);
    SET @RECOMMENDATION_DESCRIPTION = dbo.fn_normalize_format_description(@RECOMMENDATION_DESCRIPTION);

    -- Validar campos
    IF @RECOMMENDATION_NAME IS NULL OR LEN(@RECOMMENDATION_NAME) = 0
    BEGIN
        RAISERROR('El nombre de la recomendación es inválido o está vacío.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_DESCRIPTION IS NULL OR LEN(@RECOMMENDATION_DESCRIPTION) = 0
    BEGIN
        RAISERROR('La descripción de la recomendación es inválida o está vacía.', 16, 1);
        RETURN;
    END;

    IF @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar existencia del conjunto de recomendaciones
    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET
          AND IDE_COMPANY = @IDE_COMPANY
    )
    BEGIN
        RAISERROR('El conjunto de recomendaciones que intenta actualizar no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar recomendación existente
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        SET RECOMMENDATION_NAME = @RECOMMENDATION_NAME,
            RECOMMENDATION_DESCRIPTION = @RECOMMENDATION_DESCRIPTION
        WHERE IDE_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET
          AND IDE_COMPANY = @IDE_COMPANY;
        
        COMMIT TRANSACTION;
        PRINT 'Conjunto de recomendaciones actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE ============================================== --

------------------------------------
GO 
EXEC dbo.sp_update_parent_recommendation_set_evaluation
    @IDE_RECOMMENDATION_SET = '6b09ef7a-91cb-46c3-baf4-f346ba8a5e56', -- ID del conjunto de recomendaciones a actualizar
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', -- ID de la compañía
    @RECOMMENDATION_NAME = 'Nombre Actualizado de la Recomendación', -- Nuevo nombre de la recomendación
    @RECOMMENDATION_DESCRIPTION = 'Descripción actualizada del conjunto de recomendaciones para evaluaciones anuales.'; -- Nueva descripción

-- ==================================================================================================== --
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
WHERE  IDE_RECOMMENDATION_SET = '6b09ef7a-91cb-46c3-baf4-f346ba8a5e56';
-- ======================================================================================================= --




-- ==================================================================================================== --
-- Procedimiento: dbo.sp_delete_parent_recommendation_set_evaluation
-- Descripción:   Eliminar un conjunto de recomendaciones padre, solo si no tiene recomendaciones hijas.
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_parent_recommendation_set_evaluation
(
    @IDE_RECOMMENDATION_SET UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validar que el ID no es NULL
    IF @IDE_RECOMMENDATION_SET IS NULL
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar si el conjunto de recomendaciones padre tiene recomendaciones hijas
    IF EXISTS (
        SELECT 1
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE PARENT_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET
    )
    BEGIN
        RAISERROR('No se puede eliminar el conjunto de recomendaciones porque tiene recomendaciones hijas.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el conjunto de recomendaciones padre
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET;

        COMMIT TRANSACTION;
        PRINT 'Conjunto de recomendaciones eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO
