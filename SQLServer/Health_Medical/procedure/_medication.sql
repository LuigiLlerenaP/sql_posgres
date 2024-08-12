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

