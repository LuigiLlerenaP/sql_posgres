GO
CREATE FUNCTION normalizeAndFormatText (
    @OriginalValue VARCHAR(255)
)
RETURNS VARCHAR(255)
AS 
BEGIN
    DECLARE @CleanedValue VARCHAR(255);

    -- Combinar validación y normalización
    SET @CleanedValue = TRIM(COALESCE(@OriginalValue, ''));

    -- Reemplazar múltiples espacios internos con un solo espacio usando una expresión regular (si se desea)
    SET @CleanedValue = REPLACE(REPLACE(@CleanedValue, CHAR(9), ' '), CHAR(10), ' '); -- opcionalmente, puedes reemplazar tabulaciones y saltos de línea

    WHILE CHARINDEX('  ', @CleanedValue) > 0
    BEGIN
        SET @CleanedValue = REPLACE(@CleanedValue, '  ', ' ');
    END;

    -- Validar si, después de eliminar espacios, la longitud es menor que 2
    IF LEN(@CleanedValue) < 2
    BEGIN
        RETURN NULL;
    END;

    -- Normalizar el valor
    RETURN UPPER(LEFT(@CleanedValue, 1)) + LOWER(SUBSTRING(@CleanedValue, 2, LEN(@CleanedValue) - 1));
END;
GO



--DROP FUNCTION dbo.normalizeAndFormatText;






