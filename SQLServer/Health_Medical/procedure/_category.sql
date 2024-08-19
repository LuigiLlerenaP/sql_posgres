-- ======================================= Procedimiento:sp_create_medication_category ============================================= --
-- Descripción: Inserta una nueva categoría de medicamentos 
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_create_medication_category
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @CATEGORY_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(550),
    @NewCategoryID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la categoría
    DECLARE @NormalizedCategoryName VARCHAR(150);
    SET @NormalizedCategoryName = dbo.normalizeAndFormatText(@CATEGORY_NAME);

    -- Validar que los parámetros sean válidos
    IF @IDE_COMPANY IS NULL 
       OR @NormalizedCategoryName IS NULL 
    BEGIN
        RAISERROR('Parámetros inválidos o el nombre de la categoría es inválido.', 16, 1);
        RETURN;
    END;

    -- Verificar si ya existe una categoría con el mismo nombre
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES 
               WHERE IDE_COMPANY = @IDE_COMPANY AND CATEGORY_NAME = @NormalizedCategoryName)
    BEGIN
        RAISERROR('La categoría ya existe.', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Generar un nuevo ID y realizar la inserción
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES 
            (IDE_CATEGORY, IDE_COMPANY, CATEGORY_NAME, DESCRIPTION)
        VALUES 
            (@GeneratedID, @IDE_COMPANY, @NormalizedCategoryName, @DESCRIPTION);
        
        -- Confirmar la transacción
        COMMIT TRANSACTION;

        -- Asignar el nuevo ID al parámetro de salida
        SET @NewCategoryID = @GeneratedID;

        -- Informar que la categoría fue creada exitosamente
        PRINT 'Categoría creada exitosamente.';
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
-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_create_medication_category;
-- ======================================================================================================= --

-- ==================================== READ THE CATEGORY ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = 'FE324EDE-CB70-45DD-AA67-92320796875B';
-- ======================================================================================================= --



-- ======================================== CALL PROCEDURE ============================================== --

------------------------------------
GO 
-- Declarar una variable para capturar el ID de la categoría
DECLARE @NewCategoryID UNIQUEIDENTIFIER;

-- Llamar al procedimiento almacenado
EXEC dbo.sp_create_medication_category 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @CATEGORY_NAME = 'Test 004', 
    @DESCRIPTION = 'LUIGI TEST ;',
    @NewCategoryID = @NewCategoryID OUTPUT;

-- Mostrar el valor del parámetro de salida
SELECT @NewCategoryID AS NewCategoryID;

------------------------------------
EXEC dbo.sp_create_medication_category 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @CATEGORY_NAME = 'Test 004', 
    @DESCRIPTION = 'LUIGI TEST';

-- ==================================================================================================== --
-- ==================================================================================================== --


-- ======================================= Procedimiento: sp_update_medication_category ============================================= --
-- Descripción: Actualiza una categoría de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_category
(
    @IDE_CATEGORY UNIQUEIDENTIFIER,
    @CATEGORY_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(550)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Normalizar y formatear el nombre de la categoría
    DECLARE @NormalizedCategoryName VARCHAR(150);
    SET @NormalizedCategoryName = dbo.normalizeAndFormatText(@CATEGORY_NAME);

    -- Validar los parámetros
    IF @IDE_CATEGORY IS NULL 
       OR @NormalizedCategoryName IS NULL 
    BEGIN
        RAISERROR('Parámetros inválidos.', 16, 1);
        RETURN;
    END;

    -- Verificar si la categoría existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = @IDE_CATEGORY)
    BEGIN
        RAISERROR('La categoría no existe.', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar la categoría con el nombre normalizado
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES
        SET CATEGORY_NAME = @NormalizedCategoryName,
            DESCRIPTION = @DESCRIPTION
        WHERE IDE_CATEGORY = @IDE_CATEGORY;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Categoría actualizada exitosamente.';
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
-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_category;
-- ======================================================================================================= --
-- ==================================== READ THE CATEGORY ================================================ --
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = 'FE324EDE-CB70-45DD-AA67-92320796875B';
-- ======================================================================================================= --


---DROP PROCEDURE dbo.sp_update_medication_category;

EXEC dbo.sp_update_medication_category 
    @IDE_CATEGORY = 'FE324EDE-CB70-45DD-AA67-92320796875B',
    @CATEGORY_NAME = 'TEST009', 
    @DESCRIPTION = 'TEST 11.1.1';



-- ======================================= Procedimiento: sp_delete_medication_category ============================================= --
-- Descripción: Elimina una categoría de medicamentos existente
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_delete_medication_category
(
    @IDE_CATEGORY UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON;

    -- Validar el parámetro
    IF @IDE_CATEGORY IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_CATEGORY inválido.', 16, 1);
        RETURN;
    END

    -- Verificar si la categoría existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = @IDE_CATEGORY)
    BEGIN
        RAISERROR('La categoría no existe.', 16, 1);
        RETURN;
    END

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar la categoría
        DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES 
        WHERE IDE_CATEGORY = @IDE_CATEGORY;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Categoría eliminada exitosamente.';
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
-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_category;
-- ======================================================================================================= --

EXEC dbo.sp_delete_medication_category   
    @IDE_CATEGORY = '8ce6850b-5937-436c-b429-dfc3faeeeafc';


SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES;