SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS ;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_LOTS;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES;
SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS;
SELECT * FROM  T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS;


-- 1791340728001

SELECT * From SYS_COMPANIES where IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16';


---FUNCTION GET CAMPANY
GO 
CREATE FUNCTION dbo.fnGetCompanyIdByName(
 @CompanyName NVARCHAR(200)
)
RETURNS UNIQUEIDENTIFIER
AS 
BEGIN
  DECLARE @IdeCompany UNIQUEIDENTIFIER;
  IF(@CompanyName IS NULL)
    RETURN NULL;

   SELECT @IdeCompany = IDE_COMPANY  FROM SYS_COMPANIES
   WHERE NAME = @CompanyName;

   IF @IdeCompany IS NULL 
   RETURN NULL;

   RETURN @IdeCompany;
END;
GO 
-- 
GO 
CREATE FUNCTION dbo.fnGetCompanyIdByNif(
  @Nif NVARCHAR(15)
)
RETURNS UNIQUEIDENTIFIER
AS 
BEGIN
  DECLARE @IdeCompany UNIQUEIDENTIFIER;

  IF @Nif IS NULL
    RETURN NULL;

   SELECT @IdeCompany = IDE_COMPANY  FROM SYS_COMPANIES WHERE NIF = @Nif;

   IF @IdeCompany IS NULL 
   RETURN NULL;

   RETURN @IdeCompany;
END;
GO 

SELECT dbo.fnGetCompanyIdByName('FLORES LATITUD CERO CIA. LTDA.') AS "IDE_COMPANY";
SELECT dbo.fnGetCompanyIdByNif('1791340728001') AS "IDE_COMPANY";



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



---//////////////////////////////////////////////////////////////////////
-- Crear procedimiento para crear una unidad
GO
CREATE PROCEDURE dbo.sp_create_occupational_health_unit
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_COMPANY IS NULL OR @UNIT_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    -- Verificar si la unidad ya existe
    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND UNIT_NAME = @UNIT_NAME)
    BEGIN
        RAISERROR('La unidad ya existe', 16, 1);
        RETURN;
    END

    -- Insertar nueva unidad
    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_UNITS (IDE_COMPANY, UNIT_NAME, ABBREVIATION)
    VALUES (@IDE_COMPANY, @UNIT_NAME, @ABBREVIATION);

    PRINT 'Unidad creada exitosamente';
END;
GO

-- Actualizar unidad
GO
CREATE PROCEDURE dbo.sp_update_occupational_health_unit
(
    @IDE_UNIT UNIQUEIDENTIFIER,
    @UNIT_NAME VARCHAR(50),
    @ABBREVIATION VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_UNIT IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_UNIT inválido', 16, 1);
        RETURN;
    END

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad no existe', 16, 1);
        RETURN;
    END

    -- Actualizar la unidad
    UPDATE T_RRHH_OCUPATIONAL_HEALTH_UNITS
    SET UNIT_NAME = @UNIT_NAME, ABBREVIATION = @ABBREVIATION
    WHERE IDE_UNIT = @IDE_UNIT;

    PRINT 'Unidad actualizada exitosamente';
END;
GO

-- Eliminar unidad
GO
CREATE PROCEDURE dbo.sp_delete_occupational_health_unit
(
    @IDE_UNIT UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de parámetros
    IF @IDE_UNIT IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_UNIT inválido', 16, 1);
        RETURN;
    END

    -- Verificar si la unidad existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT)
    BEGIN
        RAISERROR('La unidad no existe', 16, 1);
        RETURN;
    END

    -- Eliminar la unidad
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS WHERE IDE_UNIT = @IDE_UNIT;

    PRINT 'Unidad eliminada exitosamente';
END;
GO

EXEC dbo.sp_update_occupational_health_unit 
    @IDE_UNIT = '1b922b7c-ea43-47fd-86c0-c61aa467751b',
    @UNIT_NAME = 't1',
    @ABBREVIATION = 'g1';

EXEC dbo.sp_delete_occupational_health_unit 
    @IDE_UNIT = '1b922b7c-ea43-47fd-86c0-c61aa467751b';


SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_UNITS;


---//////////////////////////////////////////////////////////////////////
-- Crear procedimiento para crear un fabricante
GO
CREATE PROCEDURE dbo.sp_create_manufacturer
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_COMPANY IS NULL OR @MANUFACTURER_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND MANUFACTURER_NAME = @MANUFACTURER_NAME)
    BEGIN
        RAISERROR('El fabricante ya existe', 16, 1);
        RETURN;
    END


    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS (IDE_COMPANY, MANUFACTURER_NAME)
    VALUES (@IDE_COMPANY, @MANUFACTURER_NAME);

    PRINT 'Fabricante creado exitosamente';
END;
GO
-- Actualizar fabricante
GO
CREATE PROCEDURE dbo.sp_update_manufacturer
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER,
    @MANUFACTURER_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_MANUFACTURER IS NULL OR @MANUFACTURER_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END


    UPDATE T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS
    SET MANUFACTURER_NAME = @MANUFACTURER_NAME
    WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

    PRINT 'Fabricante actualizado exitosamente';
END;
GO

-- Eliminar fabricante
GO
CREATE PROCEDURE dbo.sp_delete_manufacturer
(
    @IDE_MANUFACTURER UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

 
    IF @IDE_MANUFACTURER IS NULL
    BEGIN
        RAISERROR('Parámetro IDE_MANUFACTURER inválido', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER)
    BEGIN
        RAISERROR('El fabricante no existe', 16, 1);
        RETURN;
    END


    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS WHERE IDE_MANUFACTURER = @IDE_MANUFACTURER;

    PRINT 'Fabricante eliminado exitosamente';
END;
GO
---//////////////////////////////////////////////////////////////////////
-- Creacion procedimiento dosis 
GO
CREATE PROCEDURE dbo.sp_create_dosage
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @DOSAGE_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_COMPANY IS NULL OR @DOSAGE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
               WHERE IDE_COMPANY = @IDE_COMPANY AND DOSAGE_NAME = @DOSAGE_NAME)
    BEGIN
        RAISERROR('La dosificación ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_DOSAGES (IDE_COMPANY, DOSAGE_NAME, DESCRIPTION)
    VALUES (@IDE_COMPANY, @DOSAGE_NAME, @DESCRIPTION);

    PRINT 'Dosificación creada exitosamente';
END;
GO

--Actualizar dosis
GO
CREATE PROCEDURE dbo.sp_update_dosage
(
    @IDE_DOSAGE UNIQUEIDENTIFIER,
    @DOSAGE_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_DOSAGE IS NULL OR @DOSAGE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END

    UPDATE T_RRHH_OCUPATIONAL_HEALTH_DOSAGES 
    SET DOSAGE_NAME = @DOSAGE_NAME, DESCRIPTION = @DESCRIPTION
    WHERE IDE_DOSAGE = @IDE_DOSAGE;

    PRINT 'Dosificación actualizada exitosamente';
END;
GO

--Eliminar dosis 
GO
CREATE PROCEDURE dbo.sp_delete_dosage
(
    @IDE_DOSAGE UNIQUEIDENTIFIER
)
AS 
BEGIN
    SET NOCOUNT ON; 

    IF @IDE_DOSAGE IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_DOSAGE inválido', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE)
    BEGIN
        RAISERROR('La dosificación no existe', 16, 1);
        RETURN;
    END

    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_DOSAGES WHERE IDE_DOSAGE = @IDE_DOSAGE;

    PRINT 'Dosificación eliminada exitosamente';
END;
GO

EXEC dbo.sp_create_dosage 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @DOSAGE_NAME = 'Test1', 
    @DESCRIPTION = 'Test 11111';

EXEC dbo.sp_update_dosage
    @IDE_DOSAGE = '1f777f34-241d-4b79-9111-c346b4d7a2f4',
    @DOSAGE_NAME = 'Test update 1';

EXEC dbo.sp_delete_dosage
   @IDE_DOSAGE = 'bc28c39f-56aa-4c74-80ac-665b10770a57';


---//////////////////////////////////////////////////////////////////////
-- Creacion procedimiento presentacion
GO
CREATE PROCEDURE dbo.sp_create_presentation
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_COMPANY IS NULL OR @PRESENTATION_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
               WHERE IDE_COMPANY = @IDE_COMPANY AND PRESENTATION_NAME = @PRESENTATION_NAME)
    BEGIN
        RAISERROR('La presentación ya existe', 16, 1);
        RETURN;
    END

    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS (IDE_COMPANY, PRESENTATION_NAME, DESCRIPTION)
    VALUES (@IDE_COMPANY, @PRESENTATION_NAME, @DESCRIPTION);

    PRINT 'Presentación creada exitosamente';
END;
GO
--- Actualizar 
GO
CREATE PROCEDURE dbo.sp_update_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER,
    @PRESENTATION_NAME VARCHAR(50),
    @DESCRIPTION VARCHAR(550) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_PRESENTATION IS NULL OR @PRESENTATION_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END

    UPDATE T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    SET PRESENTATION_NAME = @PRESENTATION_NAME, DESCRIPTION = @DESCRIPTION
    WHERE IDE_PRESENTATION = @IDE_PRESENTATION;

    PRINT 'Presentación actualizada exitosamente';
END;
GO
-- Eliminar 
GO
CREATE PROCEDURE dbo.sp_delete_presentation
(
    @IDE_PRESENTATION UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @IDE_PRESENTATION IS NULL 
    BEGIN
        RAISERROR('Parámetro IDE_PRESENTATION inválido', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
                   WHERE IDE_PRESENTATION = @IDE_PRESENTATION)
    BEGIN
        RAISERROR('La presentación no existe', 16, 1);
        RETURN;
    END

    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS 
    WHERE IDE_PRESENTATION = @IDE_PRESENTATION;

    PRINT 'Presentación eliminada exitosamente';
END;
GO

-- Crear una presentación con descripción
EXEC dbo.sp_create_presentation 
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
    @PRESENTATION_NAME = 'Test 11', 
    @DESCRIPTION = 'Test 111 ';

EXEC dbo.sp_update_presentation 
    @IDE_PRESENTATION = '4696862c-71eb-41b4-8a4a-5e1c43c9c721',
    @PRESENTATION_NAME = 'Cápsulas Mejoradas', 
    @DESCRIPTION = 'Nueva fórmula para administración en cápsulas';

EXEC dbo.sp_delete_presentation   
    @IDE_PRESENTATION = '4696862c-71eb-41b4-8a4a-5e1c43c9c721';

---//////////////////////////////////////////////////////////////////////
-- Creacion 
GO
CREATE PROCEDURE dbo.sp_create_route
(
    @IDE_COMPANY UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que ambos parámetros no sean NULL
    IF @ROUTE_NAME IS NULL OR @IDE_COMPANY IS NULL
    BEGIN
        RAISERROR('Ambos parámetros deben ser válidos', 16, 1);
        RETURN;
    END

    -- Verificar si la ruta ya existe
    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @ROUTE_NAME AND IDE_COMPANY = @IDE_COMPANY)
    BEGIN
        RAISERROR('La ruta ya existe', 16, 1);
        RETURN;
    END

    -- Insertar la nueva ruta
    INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES (IDE_COMPANY, ROUTE_NAME)
    VALUES (@IDE_COMPANY, @ROUTE_NAME);
    
    PRINT 'Ruta creada exitosamente';
END;
GO



--Update 
GO
CREATE PROCEDURE dbo.sp_update_route
(
    @IDE_ROUTE UNIQUEIDENTIFIER,
    @ROUTE_NAME VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    IF @IDE_ROUTE IS NULL OR @ROUTE_NAME IS NULL
    BEGIN
        RAISERROR('Parámetros inválidos', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 
                   FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
                   WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta no existe', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 
               FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
               WHERE ROUTE_NAME = @ROUTE_NAME AND IDE_ROUTE <> @IDE_ROUTE)
    BEGIN
        RAISERROR('Ya existe una ruta con ese nombre', 16, 1);
        RETURN;
    END


    UPDATE T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES 
    SET ROUTE_NAME = @ROUTE_NAME
    WHERE IDE_ROUTE = @IDE_ROUTE;

    PRINT 'Ruta actualizada exitosamente';
END;
GO
-- Eliminar 
GO
CREATE PROCEDURE dbo.sp_delete_route
(
    @IDE_ROUTE UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el parámetro no sea NULL
    IF @IDE_ROUTE IS NULL
    BEGIN
        RAISERROR('El parámetro IDE_ROUTE no puede ser NULL', 16, 1);
        RETURN;
    END

    -- Verificar si la ruta existe antes de intentar eliminarla
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES WHERE IDE_ROUTE = @IDE_ROUTE)
    BEGIN
        RAISERROR('La ruta no existe', 16, 1);
        RETURN;
    END

    -- Eliminar la ruta
    DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES
    WHERE IDE_ROUTE = @IDE_ROUTE;

    PRINT 'Ruta eliminada exitosamente';
END;
GO
EXEC dbo.sp_create_route
    @IDE_COMPANY = '5b4234e3-5850-4c53-92c6-7dc3d9ce0e16',
    @ROUTE_NAME = 'Test5';

    EXEC dbo.sp_delete_route
    @IDE_ROUTE = '87c9c825-71dc-4868-860e-2114c90f0843';
select * from T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES;


-----/////////////////////
-- Medicamentos --
-- GO
-- CREATE PROCEDURE dbo.sp_create_medication
-- (
--     @Nif NVARCHAR(15),
--     @Categories TABLE (CategoryName VARCHAR(150), Description VARCHAR(255)),
--     @UNIT_NAME VARCHAR(50),
--     @DOSAGE_NAME VARCHAR(50),
--     @MANUFACTURER_NAME VARCHAR(50),
--     @PRESENTATION_NAME VARCHAR(50),
--     @ROUTE_NAME VARCHAR(50),
--     @MEDICATION_NAME VARCHAR(200),
--     @STATUS NVARCHAR(255) = 'ACTIVE'
-- )
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DECLARE @IDE_COMPANY UNIQUEIDENTIFIER;
--     DECLARE @IDE_CATEGORY UNIQUEIDENTIFIER;
--     DECLARE @IDE_UNIT UNIQUEIDENTIFIER;
--     DECLARE @IDE_DOSAGE UNIQUEIDENTIFIER;
--     DECLARE @IDE_MANUFACTURER UNIQUEIDENTIFIER;
--     DECLARE @IDE_PRESENTATION UNIQUEIDENTIFIER;
--     DECLARE @IDE_ROUTE UNIQUEIDENTIFIER;
--     DECLARE @CategoryName VARCHAR(150);
--     DECLARE @Description VARCHAR(255);

--     -- Obtener el ID de la compañía
--     SET @IDE_COMPANY = dbo.fnGetCompanyIdByNif(@Nif);

--     IF @IDE_COMPANY IS NULL
--     BEGIN
--         RAISERROR('No se encontró la compañía para el NIF proporcionado.', 16, 1);
--         RETURN;
--     END

--     -- Recorrer cada fila de la variable de tabla @Categories
--     DECLARE category_cursor CURSOR FOR
--     SELECT CategoryName, Description
--     FROM @Categories;

--     OPEN category_cursor;

--     FETCH NEXT FROM category_cursor INTO @CategoryName, @Description;

--     WHILE @@FETCH_STATUS = 0
--     BEGIN
--         -- Insertar la categoría
--         EXEC dbo.sp_create_medication_category 
--             @IDE_COMPANY = @IDE_COMPANY, 
--             @CATEGORY_NAME = @CategoryName, 
--             @DESCRIPTION = @Description;

--         FETCH NEXT FROM category_cursor INTO @CategoryName, @Description;
--     END

--     CLOSE category_cursor;
--     DEALLOCATE category_cursor;

--     -- Aquí puedes añadir la lógica para insertar el medicamento, usando las IDs obtenidas
--     -- Ejemplo de código omitido para brevidad

--     PRINT 'Medicamento creado exitosamente';
-- END;
-- GO

