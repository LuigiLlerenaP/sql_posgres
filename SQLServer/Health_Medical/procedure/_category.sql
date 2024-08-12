---//////////////////////////////////////////////////////////////////////
-- Crear procedimiento para crear una categoria 
GO
CREATE  PROCEDURE dbo.sp_create_medication_category
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @CATEGORY_NAME VARCHAR(150),
    @DESCRIPTION VARCHAR(550)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_COMPANY IS NULL OR @CATEGORY_NAME IS NULL
        BEGIN
            RAISERROR('Parámetros inválidos', 16, 1);
            RETURN;
        END


    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES 
               WHERE IDE_COMPANY = @IDE_COMPANY AND CATEGORY_NAME = @CATEGORY_NAME)
       BEGIN
            RAISERROR('La categoría ya existe', 16, 1);
            RETURN;
        END

    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES (IDE_COMPANY, CATEGORY_NAME, DESCRIPTION)
    VALUES (@IDE_COMPANY, @CATEGORY_NAME, @DESCRIPTION);

    PRINT 'Categoría creada exitosamente';
END;
GO



EXEC dbo.sp_create_medication_category 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @CATEGORY_NAME = 'Medicamentos Oftálmicos', 
    @DESCRIPTION = 'Medicamentos para el tratamiento de enfermedades oculares';

EXEC dbo.sp_create_medication_category 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @CATEGORY_NAME = 'Medicamentos Dermatológicos', 
    @DESCRIPTION = 'Medicamentos para el tratamiento de enfermedades de la piel';

EXEC dbo.sp_create_medication_category 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @CATEGORY_NAME = 'Test 1', 
    @DESCRIPTION = 'TEST 1';

--DROP PROCEDURE dbo.sp_create_medication_category;


-- Update category
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

    IF @IDE_CATEGORY IS NULL OR @CATEGORY_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = @IDE_CATEGORY)
    BEGIN
        RAISERROR('La categoría no existe', 16, 1);
        RETURN;
    END

    -- Actualizar la categoría
    UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES SET CATEGORY_NAME = @CATEGORY_NAME, DESCRIPTION = @DESCRIPTION
    WHERE IDE_CATEGORY = @IDE_CATEGORY;

    PRINT 'Categoría actualizada exitosamente';
END;
GO

---DROP PROCEDURE dbo.sp_update_medication_category;

EXEC dbo.sp_update_medication_category 
    @IDE_CATEGORY = '0e2ae612-4615-4a8d-9d9f-bb00d390f423',
    @CATEGORY_NAME = 'Test 1.1.1', 
    @DESCRIPTION = 'TEST 11.1.1';



-- Delete category
GO
CREATE PROCEDURE dbo.sp_delete_medication_category
(
    @IDE_CATEGORY UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON; 

    IF @IDE_CATEGORY IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_CATEGORY inválido', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = @IDE_CATEGORY)
    BEGIN
        RAISERROR('La categoría no existe', 16, 1);
        RETURN;
    END

    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES WHERE IDE_CATEGORY = @IDE_CATEGORY;

    PRINT 'Categoría eliminada exitosamente';
END;
GO

EXEC dbo.sp_delete_medication_category   
    @IDE_CATEGORY = '1de6909f-554c-4c3c-8390-9d2fefc2d727';


SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES;