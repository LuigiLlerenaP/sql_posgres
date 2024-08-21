CREATE FUNCTION dbo.normalizeAndFormatText (
    @OriginalValue VARCHAR(255)
)
RETURNS VARCHAR(255)
AS 
BEGIN
    DECLARE @CleanedValue VARCHAR(255);

    -- Combinar validación y normalización
    SET @CleanedValue = TRIM(COALESCE(@OriginalValue, ''));

    -- Reemplazar múltiples espacios internos con un solo espacio
    SET @CleanedValue = REPLACE(REPLACE(@CleanedValue, CHAR(9), ' '), CHAR(10), ' ');
    SET @CleanedValue = REPLACE(@CleanedValue, CHAR(13), ' '); -- Manejar retorno de carro

    -- Reemplazo de múltiples espacios con un solo espacio
    WHILE CHARINDEX('  ', @CleanedValue) > 0
    BEGIN
        SET @CleanedValue = REPLACE(@CleanedValue, '  ', ' ');
    END;

    -- Validar si, después de eliminar espacios, la longitud es menor que 2
    IF LEN(@CleanedValue) < 2
    BEGIN
        RETURN NULL;
    END;

    -- Formatear el valor: Primer carácter en mayúscula y el resto en minúscula
    RETURN UPPER(LEFT(@CleanedValue, 1)) + LOWER(SUBSTRING(@CleanedValue, 2, LEN(@CleanedValue) - 1));
END;
GO



-- DROP FUNCTION dbo.normalizeAndFormatText;






CREATE FUNCTION dbo.normalizeAndFormatDownText (
    @OriginalValue VARCHAR(255)
)
RETURNS VARCHAR(255)
AS 
BEGIN
    DECLARE @CleanedValue VARCHAR(255);

    -- Combinar validación y normalización
    SET @CleanedValue = TRIM(COALESCE(@OriginalValue, ''));

    -- Reemplazar múltiples espacios internos con un solo espacio
    SET @CleanedValue = REPLACE(REPLACE(@CleanedValue, CHAR(9), ' '), CHAR(10), ' ');
    SET @CleanedValue = REPLACE(@CleanedValue, CHAR(13), ' '); -- Manejar retorno de carro

    -- Reemplazo de múltiples espacios con un solo espacio
    WHILE CHARINDEX('  ', @CleanedValue) > 0
    BEGIN
        SET @CleanedValue = REPLACE(@CleanedValue, '  ', ' ');
    END;

    -- Validar si, después de eliminar espacios, la longitud es menor que 1
    IF LEN(@CleanedValue) < 1
    BEGIN
        RETURN NULL;
    END;

    -- Formatear el valor: Convertir todo el texto a minúsculas
    RETURN LOWER(@CleanedValue);
END;
GO


--GO
-- CREATE FUNCTION dbo.normalizeAndFormatLongText (
--     @OriginalValue VARCHAR(MAX)
-- )
-- RETURNS VARCHAR(MAX)
-- AS 
-- BEGIN
--     DECLARE @CleanedValue VARCHAR(MAX);

--     -- Combinar validación y normalización
--     SET @CleanedValue = TRIM(COALESCE(@OriginalValue, ''));

--     -- Reemplazar múltiples espacios internos con un solo espacio
--     SET @CleanedValue = REPLACE(REPLACE(REPLACE(@CleanedValue, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' ');

--     -- Reemplazo de múltiples espacios con un solo espacio
--     WHILE CHARINDEX('  ', @CleanedValue) > 0
--     BEGIN
--         SET @CleanedValue = REPLACE(@CleanedValue, '  ', ' ');
--     END;

--     -- Eliminar etiquetas HTML (ejemplo básico)
--     -- Nota: Para una eliminación más completa, considera usar expresiones regulares o funciones específicas
--     SET @CleanedValue = REPLACE(@CleanedValue, '<[^>]*>', '');

--     -- Normalizar caracteres especiales y eliminar caracteres no imprimibles
--     -- Aquí se podrían aplicar otras transformaciones según las necesidades específicas
--     SET @CleanedValue = REPLACE(@CleanedValue, CHAR(0), ''); -- Eliminar caracteres nulos

--     -- Formatear el valor: Primera letra de cada palabra en mayúscula
--     -- Usar una tabla de números para iterar sobre cada carácter es más eficiente en textos largos
--     DECLARE @Position INT = 1;
--     DECLARE @CurrentChar CHAR(1);
--     DECLARE @FormattedValue VARCHAR(MAX) = '';
    
--     WHILE @Position <= LEN(@CleanedValue)
--     BEGIN
--         SET @CurrentChar = SUBSTRING(@CleanedValue, @Position, 1);

--         -- Capitalizar la primera letra de cada palabra
--         IF @Position = 1 OR SUBSTRING(@CleanedValue, @Position - 1, 1) = ' '
--         BEGIN
--             SET @FormattedValue = @FormattedValue + UPPER(@CurrentChar);
--         END
--         ELSE
--         BEGIN
--             SET @FormattedValue = @FormattedValue + LOWER(@CurrentChar);
--         END

--         SET @Position = @Position + 1;
--     END

--     -- Validar si, después de eliminar espacios, la longitud es menor que 3
--     IF LEN(@FormattedValue) < 3
--     BEGIN
--         RETURN NULL;
--     END

--     RETURN @FormattedValue;
-- END;
-- GO


-- -- Ejemplo de uso de la función dbo.normalizeAndFormatLongText
-- SELECT dbo.normalizeAndFormatLongText(
--     '   <p>This is a   sample TEXT. </p> More  <b>HTML</b> and new lines.   '
-- ) AS FormattedText;


--  DROP FUNCTION dbo.normalizeAndFormatLongText;