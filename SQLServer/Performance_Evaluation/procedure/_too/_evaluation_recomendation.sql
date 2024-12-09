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

-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_add_child_recomendation_set_evaluation;
-- ==================================================================================================== --
-- ====================================================================================================
-- Procedimiento: dbo.sp_add_child_recomendation_set_evaluation
-- Descripción:   Agregar una recomendacion hijo en base a su padre 
-- ====================================================================================================
GO
CREATE PROCEDURE dbo.sp_add_child_recomendation_set_evaluation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PARENT_RECOMMENDATION_SET UNIQUEIDENTIFIER,
    @RECOMMENDATION_NAME VARCHAR(255),
    @RECOMMENDATION_DESCRIPTION VARCHAR(4000),
    @NewRecommendationChildSetID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;
    
    -- Normalizar campos
    SET @RECOMMENDATION_NAME = dbo.fn_normalize_format_text(@RECOMMENDATION_NAME);
    SET @RECOMMENDATION_DESCRIPTION = dbo.fn_normalize_format_description(@RECOMMENDATION_DESCRIPTION);

    -- Validaciones
    IF @IDE_COMPANY IS NULL 
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;
    
    IF @PARENT_RECOMMENDATION_SET IS NULL 
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones padre no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_NAME IS NULL 
    BEGIN
        RAISERROR('El nombre de la recomendación no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_DESCRIPTION IS NULL 
    BEGIN
        RAISERROR('La descripción de la recomendación no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar duplicados
    IF EXISTS (
        SELECT 1
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE RECOMMENDATION_NAME = @RECOMMENDATION_NAME 
          AND IDE_COMPANY = @IDE_COMPANY
          AND PARENT_RECOMMENDATION_SET = @PARENT_RECOMMENDATION_SET
    )
    BEGIN
        RAISERROR('Ya existe un conjunto de recomendación hijo con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        SET @NewRecommendationChildSetID = NEWID();

        -- Insertar la recomendación hija
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
            (IDE_RECOMMENDATION_SET, IDE_COMPANY, PARENT_RECOMMENDATION_SET, RECOMMENDATION_NAME, RECOMMENDATION_DESCRIPTION)
        VALUES 
            (@NewRecommendationChildSetID, @IDE_COMPANY, @PARENT_RECOMMENDATION_SET, @RECOMMENDATION_NAME, @RECOMMENDATION_DESCRIPTION);
        
        COMMIT TRANSACTION;
        PRINT 'Conjunto de recomendaciones hijo creado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO
-- ======================================== CALL PROCEDURE ============================================== --

GO
DECLARE @NewRecommendationChildSetID UNIQUEIDENTIFIER;

-- Llamada al procedimiento almacenado
EXEC dbo.sp_add_child_recomendation_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PARENT_RECOMMENDATION_SET = '6b09ef7a-91cb-46c3-baf4-f346ba8a5e56', 
    @RECOMMENDATION_NAME = 'Recomendación Hija Test',  
    @RECOMMENDATION_DESCRIPTION = 'Descripción de la recomendación hija para la evaluación.',  
    @NewRecommendationChildSetID = @NewRecommendationChildSetID OUTPUT;  

-- Mostrar el nuevo ID generado
SELECT @NewRecommendationChildSetID AS NewRecommendationChildSetID;

------------------------------------
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
WHERE  IDE_RECOMMENDATION_SET = '16bca18c-b0a8-4edf-a2d4-daa6d3eeb71f';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_update_child_recommendation_set_evaluation;
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_update_child_score_set_evaluation
-- Descripción:   Actualizar un conjunto de recomendaciones hijo basado en su ID
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_update_child_recommendation_set_evaluation
(
    @IDE_RECOMMENDATION_SET UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PARENT_RECOMMENDATION_SET UNIQUEIDENTIFIER,
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
    IF @IDE_RECOMMENDATION_SET IS NULL
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @IDE_COMPANY IS NULL 
    BEGIN
        RAISERROR('El ID de la compañía no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @PARENT_RECOMMENDATION_SET IS NULL 
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones padre no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_NAME IS NULL OR LEN(@RECOMMENDATION_NAME) = 0
    BEGIN
        RAISERROR('El nombre de la recomendación no puede ser NULL o vacío.', 16, 1);
        RETURN;
    END;

    IF @RECOMMENDATION_DESCRIPTION IS NULL OR LEN(@RECOMMENDATION_DESCRIPTION) = 0
    BEGIN
        RAISERROR('La descripción de la recomendación no puede ser NULL o vacía.', 16, 1);
        RETURN;
    END;

    -- Validar que el conjunto de recomendaciones padre exista
    IF NOT EXISTS (
        SELECT 1
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_RECOMMENDATION_SET = @PARENT_RECOMMENDATION_SET
          AND IDE_COMPANY = @IDE_COMPANY
    )
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones padre no existe.', 16, 1);
        RETURN;
    END;

    -- Verificar si existe un conjunto de recomendaciones con el mismo nombre bajo el mismo padre
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_COMPANY = @IDE_COMPANY 
          AND PARENT_RECOMMENDATION_SET = @PARENT_RECOMMENDATION_SET 
          AND RECOMMENDATION_NAME = @RECOMMENDATION_NAME
          AND IDE_RECOMMENDATION_SET <> @IDE_RECOMMENDATION_SET
    )
    BEGIN
        RAISERROR('Ya existe un conjunto de recomendaciones hijo con este nombre bajo el mismo conjunto padre.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar el conjunto de recomendaciones hijo
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        SET 
            RECOMMENDATION_NAME = @RECOMMENDATION_NAME,
            RECOMMENDATION_DESCRIPTION = @RECOMMENDATION_DESCRIPTION
        WHERE 
            IDE_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET
            AND IDE_COMPANY = @IDE_COMPANY;

        COMMIT TRANSACTION;
        PRINT 'Conjunto de recomendaciones hijo actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

-- ======================================== CALL PROCEDURE ============================================== --

-- Llamada al procedimiento almacenado
EXEC dbo.sp_update_child_recommendation_set_evaluation
    @IDE_RECOMMENDATION_SET  = '16bca18c-b0a8-4edf-a2d4-daa6d3eeb71f', 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PARENT_RECOMMENDATION_SET = '6b09ef7a-91cb-46c3-baf4-f346ba8a5e56', 
    @RECOMMENDATION_NAME = 'Recomendación Hija Test - UPDATE-- ',  
    @RECOMMENDATION_DESCRIPTION = 'Descripción de la recomendación hija para la evaluación.';



------------------------------------
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS 
WHERE  IDE_RECOMMENDATION_SET = '16bca18c-b0a8-4edf-a2d4-daa6d3eeb71f';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_delete_recommendation_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_delete_recommendation_set_evaluation
-- Descripción:   Borrar un conjunto de recomendaciones hijo basado en su ID
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_recommendation_set_evaluation
(
    @IDE_RECOMMENDATION_SET UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validar campos
    IF @IDE_RECOMMENDATION_SET IS NULL
    BEGIN
        RAISERROR('El ID del conjunto de recomendaciones no puede ser NULL.', 16, 1);
        RETURN;
    END;

    -- Verificar si el conjunto de recomendaciones existe
    IF NOT EXISTS (
        SELECT 1
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
        WHERE IDE_RECOMMENDATION_SET = @IDE_RECOMMENDATION_SET
    )
    BEGIN
        RAISERROR('El conjunto de recomendaciones especificado no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el conjunto de recomendaciones
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


-- Llamada al procedimiento almacenado
EXEC dbo.sp_delete_recommendation_set_evaluation
    @IDE_RECOMMENDATION_SET = '16bca18c-b0a8-4edf-a2d4-daa6d3eeb71f';
