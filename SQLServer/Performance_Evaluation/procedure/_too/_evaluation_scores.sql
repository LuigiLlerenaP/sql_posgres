-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_add_parent_score_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_add_parent_score_set_evaluation
-- Descripción:   Agregar una nota padre para la evaluacion, con el valor cero  
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_add_parent_score_set_evaluation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @SCORE_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(MAX),
    @NewParentScoreSetID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar Parent Name y Description
    SET @SCORE_NAME = dbo.fn_normalize_format_text(@SCORE_NAME);
    SET @DESCRIPTION = dbo.fn_normalize_format_description(@DESCRIPTION);

    -- Validar campos
    IF @SCORE_NAME IS NULL
    BEGIN
        RAISERROR('El nombre del conjunto de puntajes es inválido.', 16, 1);
        RETURN;
    END;

    IF @DESCRIPTION IS NULL
    BEGIN
        RAISERROR('La descripción es inválida o está vacía.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE SCORE_NAME = @SCORE_NAME
          AND IDE_COMPANY = @IDE_COMPANY
          AND PARENT_SCORE_SET IS NULL
    )
    BEGIN
        RAISERROR('Ya existe un conjunto de puntajes con este nombre.', 16, 1);
        RETURN;
    END

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        SET @NewParentScoreSetID = NEWID();
        
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
            (IDE_SCORE_SET, IDE_COMPANY, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
        VALUES 
            (@NewParentScoreSetID, @IDE_COMPANY, @SCORE_NAME, @DESCRIPTION, 0);

        COMMIT TRANSACTION;
        PRINT 'Score Padre creado exitosamente con ID: ' + CAST(@NewParentScoreSetID AS VARCHAR(36));
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
DECLARE @NewParentScoreSetID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_parent_score_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @SCORE_NAME = 'Test001',    
    @DESCRIPTION = 'Descripción detallada del conjunto de puntajes para evaluaciones anuales.',                                 
    @NewParentScoreSetID = @NewParentScoreSetID OUTPUT;  

-- Mostrar el nuevo ID generado
SELECT @NewParentScoreSetID AS NewParentScoreSetID;

------------------------------------
EXEC dbo.sp_add_parent_score_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @SCORE_NAME = 'Test002',    
    @DESCRIPTION = 'Descripción detallada del conjunto de puntajes para evaluaciones anuales.';  
-- ==================================================================================================== --
-- ==================================================================================================== --
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
WHERE  IDE_SCORE_SET = '6B2C4774-510C-4C51-8183-DB443461BC03';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --

-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_update_parent_score_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_add_parent_score_set_evaluation
-- Descripción:   Agregar una nota padre para la evaluacion, con el valor cero  
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_update_parent_score_set_evaluation
(
    @IDE_SCORE_SET UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @SCORE_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(MAX)
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar Name y Description
    SET @SCORE_NAME = dbo.fn_normalize_format_text(@SCORE_NAME);
    SET @DESCRIPTION = dbo.fn_normalize_format_description(@DESCRIPTION);

    -- Validar campos
    IF @SCORE_NAME IS NULL
    BEGIN
        RAISERROR('El nombre del conjunto de puntajes es inválido.', 16, 1);
        RETURN;
    END;

    IF @DESCRIPTION IS NULL 
    BEGIN
        RAISERROR('La descripción es inválida o está vacía.', 16, 1);
        RETURN;
    END;

    -- Verificar si el conjunto de puntajes existe
    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET
    )
    BEGIN
        RAISERROR('El conjunto de puntajes que se intenta actualizar no existe.', 16, 1);
        RETURN;
    END

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        SET 
            SCORE_NAME = @SCORE_NAME,
            DESCRIPTION = @DESCRIPTION,
            SCORE_VALUE = 0
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET
          AND IDE_COMPANY = @IDE_COMPANY;

        COMMIT TRANSACTION;
        PRINT 'Score Padre actualizado exitosamente con ID: ' + CAST(@IDE_SCORE_SET AS VARCHAR(36));
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
EXEC dbo.sp_update_parent_score_set_evaluation
    @IDE_SCORE_SET = '6B2C4774-510C-4C51-8183-DB443461BC03',
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @SCORE_NAME =  'Test0001',
    @DESCRIPTION = 'Descripción detallada del conjunto de puntajes para evaluaciones anuales.';
-- ==================================================================================================== -
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
WHERE  IDE_SCORE_SET = '6B2C4774-510C-4C51-8183-DB443461BC03';
-- ======================================================================================================= --

-- ==================================================================================================== --
-- ==================================================================================================== --

-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_delete_parent_score_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_delete_parent_score_set_evaluation
-- Descripción:  Eliminar el padre y sus hijos cores
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_parent_score_set_evaluation
(
    @IDE_SCORE_SET UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validar campos
    IF @IDE_SCORE_SET IS NULL
    BEGIN
        RAISERROR('El identificador del conjunto de puntajes es inválido.', 16, 1);
        RETURN;
    END;

    -- Verificar si el conjunto de puntajes padre existe
    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET
          AND PARENT_SCORE_SET IS NULL
    )
    BEGIN
        RAISERROR('No se encontró un conjunto de puntajes con el identificador proporcionado.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar todos los registros hijos asociados al conjunto de puntajes padre
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE PARENT_SCORE_SET = @IDE_SCORE_SET;

        -- Eliminar el conjunto de puntajes padre
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET
          AND PARENT_SCORE_SET IS NULL;

        COMMIT TRANSACTION;
        PRINT 'Score Padre y todos sus hijos eliminados exitosamente.';
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
EXEC dbo.sp_delete_parent_score_set_evaluation
    @IDE_SCORE_SET = 'd36dd6a4-703a-4b9f-a2d7-0b6617844f91';
-- ==================================================================================================== -
-- ==================================================================================================== --
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES;
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --


-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_add_child_score_set_evaluation;
-- ==================================================================================================== --
-- ====================================================================================================
-- Procedimiento: dbo.sp_add_child_score_set_evaluation
-- Descripción:   Agregar un score hijo en base a su padre 
-- ====================================================================================================
GO
CREATE PROCEDURE dbo.sp_add_child_score_set_evaluation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PARENT_SCORE_SET UNIQUEIDENTIFIER,
    @SCORE_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(MAX),
    @SCORE_VALUE INT,
    @NewChildScoreSetID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar Name y Description
    SET @SCORE_NAME = dbo.fn_normalize_format_text(@SCORE_NAME);
    SET @DESCRIPTION = dbo.fn_normalize_format_description(@DESCRIPTION);

    -- Validar campos
    IF @SCORE_NAME IS NULL
    BEGIN
        RAISERROR('El nombre del conjunto de puntajes es inválido.', 16, 1);
        RETURN;
    END;

    IF @DESCRIPTION IS NULL 
    BEGIN
        RAISERROR('La descripción es inválida o está vacía.', 16, 1);
        RETURN;
    END;
 
    IF @SCORE_VALUE IS NULL OR @SCORE_VALUE < 0 OR @SCORE_VALUE > 20
    BEGIN
        RAISERROR('El valor del puntaje es inválido.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE SCORE_NAME = @SCORE_NAME
          AND IDE_COMPANY = @IDE_COMPANY
          AND PARENT_SCORE_SET = @PARENT_SCORE_SET
    )
    BEGIN
        RAISERROR('Ya existe un conjunto de puntaje hijo con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        SET @NewChildScoreSetID = NEWID();

        -- Insertar nuevo score hijo
        INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
            (IDE_SCORE_SET, PARENT_SCORE_SET, IDE_COMPANY, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
        VALUES 
            (@NewChildScoreSetID, @PARENT_SCORE_SET, @IDE_COMPANY, @SCORE_NAME, @DESCRIPTION, @SCORE_VALUE);

        COMMIT TRANSACTION;
        PRINT 'Conjunto de puntajes hijo creado exitosamente.';
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
DECLARE @NewChildScoreSetID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_child_score_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PARENT_SCORE_SET = 'b64b70f3-856a-4bca-be3e-43d63e0cfd17',
    @SCORE_NAME = 'Test006 - child',    
    @DESCRIPTION = 'Descripción detallada del conjunto de puntajes para evaluaciones anuales.',                                 
    @SCORE_VALUE  = 5,
    @NewChildScoreSetID = @NewChildScoreSetID OUTPUT;  

-- Mostrar el nuevo ID generado
SELECT @NewChildScoreSetID AS NewID;

------------------------------------
GO
EXEC dbo.sp_add_child_score_set_evaluation
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @PARENT_SCORE_SET = 'b64b70f3-856a-4bca-be3e-43d63e0cfd17', 
    @SCORE_NAME = 'Test002-child',    
    @DESCRIPTION = 'Descripción detallada del conjunto de puntajes para evaluaciones anuales.', 
    @SCORE_VALUE  = 2;  

-- ==================================================================================================== --
-- ==================================================================================================== --
-- ==================================================================================================== --
GO
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
WHERE  IDE_SCORE_SET = '52d9c04a-cf81-4d8f-a9ab-82bc875dbeb2';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --


-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_update_child_score_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_update_child_score_set_evaluation
-- Descripción:   Actualizar un conjunto de puntajes hijo basado en su ID
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_update_child_score_set_evaluation
(
    @IDE_SCORE_SET UNIQUEIDENTIFIER,
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PARENT_SCORE_SET UNIQUEIDENTIFIER,
    @SCORE_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(MAX),
    @SCORE_VALUE INT
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Normalizar Name y Description
    SET @SCORE_NAME = dbo.fn_normalize_format_text(@SCORE_NAME);
    SET @DESCRIPTION = dbo.fn_normalize_format_description(@DESCRIPTION);

    -- Validar campos
    IF @SCORE_NAME IS NULL
    BEGIN
        RAISERROR('El nombre del conjunto de puntajes es inválido.', 16, 1);
        RETURN;
    END;

    IF @DESCRIPTION IS NULL 
    BEGIN
        RAISERROR('La descripción es inválida o está vacía.', 16, 1);
        RETURN;
    END;
 
    IF @SCORE_VALUE IS NULL OR @SCORE_VALUE < 0 OR @SCORE_VALUE > 20
    BEGIN
        RAISERROR('El valor del puntaje es inválido.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET
          AND IDE_COMPANY = @IDE_COMPANY
    )
    BEGIN
        RAISERROR('No se encontró un conjunto de puntajes con el ID proporcionado.', 16, 1);
        RETURN;
    END;

    -- Verificar si el nombre ya existe en otro registro
    IF EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE SCORE_NAME = @SCORE_NAME
          AND IDE_COMPANY = @IDE_COMPANY
          AND PARENT_SCORE_SET = @PARENT_SCORE_SET
          AND IDE_SCORE_SET <> @IDE_SCORE_SET
    )
    BEGIN
        RAISERROR('Ya existe otro conjunto de puntaje hijo con este nombre.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar score hijo
        UPDATE T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        SET SCORE_NAME = @SCORE_NAME,
            DESCRIPTION = @DESCRIPTION,
            SCORE_VALUE = @SCORE_VALUE,
            PARENT_SCORE_SET = @PARENT_SCORE_SET
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET;

        COMMIT TRANSACTION;
        PRINT 'Conjunto de puntajes hijo actualizado exitosamente.';
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
EXEC dbo.sp_update_child_score_set_evaluation
    @IDE_SCORE_SET = '52d9c04a-cf81-4d8f-a9ab-82bc875dbeb2', 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @PARENT_SCORE_SET = 'b64b70f3-856a-4bca-be3e-43d63e0cfd17', 
    @SCORE_NAME = 'Updated-Test002-child', 
    @DESCRIPTION = 'Descripción actualizada del conjunto de puntajes.',
    @SCORE_VALUE  = 4;

-- ==================================================================================================== --
-- ==================================================================================================== --
GO
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
WHERE  IDE_SCORE_SET = '52d9c04a-cf81-4d8f-a9ab-82bc875dbeb2';
-- ======================================================================================================= --


-- ==================================================================================================== --
-- Drop procedure --
DROP PROCEDURE IF EXISTS dbo.sp_delete_child_score_set_evaluation;
-- ==================================================================================================== --
-- ==================================================================================================== --
-- Procedimiento: dbo.sp_delete_child_score_set_evaluation
-- Descripción:   Borrar un conjunto de puntajes hijo basado en su ID
-- ==================================================================================================== --
GO
CREATE PROCEDURE dbo.sp_delete_child_score_set_evaluation
(
    @IDE_SCORE_SET UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el IDE_SCORE_SET no sea NULL
    IF @IDE_SCORE_SET IS NULL
    BEGIN
        RAISERROR('El ID del conjunto de puntajes no puede ser NULL.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
    SELECT 1 
    FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
    WHERE PARENT_SCORE_SET = @IDE_SCORE_SET
    )
    BEGIN
        RAISERROR('No se puede eliminar el conjunto de puntajes porque tiene hijos asociados.', 16, 1);
        RETURN;
    END;

    -- Verificar si el conjunto de puntajes existe y es un padre 
    IF NOT EXISTS (
        SELECT 1 
        FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET 
    )
    BEGIN
        RAISERROR('El conjunto de puntajes con el ID especificado no existe.', 16, 1);
        RETURN;
    END;

    -- Iniciar transacción
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el conjunto de puntajes
        DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
        WHERE IDE_SCORE_SET = @IDE_SCORE_SET;

        COMMIT TRANSACTION;
        PRINT 'Conjunto de puntajes eliminado exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;

END;
GO

GO
EXEC dbo.sp_delete_child_score_set_evaluation
    @IDE_SCORE_SET = '52d9c04a-cf81-4d8f-a9ab-82bc875dbeb2'; 
GO


GO
SELECT * 
FROM   T_RRHH_PERFORMANCE_EVALUATIONS_SCORES 
WHERE  IDE_SCORE_SET = '52d9c04a-cf81-4d8f-a9ab-82bc875dbeb2';
GO