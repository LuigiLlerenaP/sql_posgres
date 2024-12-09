CREATE FUNCTION dbo.fn_normalize_format_text(
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

-- DROP FUNCTION dbo.fn_normalize_format_text;






CREATE FUNCTION dbo.fn_normalize_format_down_text(
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

--DROP FUNCTION dbo.ufn_normalize_format_down_text;



CREATE FUNCTION dbo.fn_normalize_format_description(
    @OriginalDescription VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS 
BEGIN
    DECLARE @CleanedDescription VARCHAR(MAX);

    -- Combinar validación y normalización
    SET @CleanedDescription = TRIM(COALESCE(@OriginalDescription, ''));

    -- Reemplazar múltiples espacios, tabulaciones y retornos de carro con un solo espacio en un solo paso
    SET @CleanedDescription = REPLACE(REPLACE(REPLACE(@CleanedDescription, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' ');

    -- Eliminar múltiples espacios internos
    WHILE PATINDEX('%  %', @CleanedDescription) > 0
    BEGIN
        SET @CleanedDescription = STUFF(@CleanedDescription, PATINDEX('%  %', @CleanedDescription), 2, ' ');
    END;

    -- Validar si, después de eliminar espacios, la longitud es menor que 2
    IF LEN(@CleanedDescription) < 2
    BEGIN
        RETURN NULL;
    END;

    -- Capitalizar cada palabra en la descripción
    SET @CleanedDescription = CONCAT(
        UPPER(LEFT(@CleanedDescription, 1)), 
        LOWER(SUBSTRING(@CleanedDescription, 2, LEN(@CleanedDescription) - 1))
    );

    RETURN @CleanedDescription;
END;
GO

--Probar funcion 
DECLARE @TestDescription VARCHAR(MAX) = '  ESTE ES   un  ejemplo De  DESCRIPCIÓN   que   Incluye VARIOS    Problemas,   como;     múltiples   ESPACIOS,  y,  signos de  puntuación     mal    colocados.  También    incluye comillas dobles "" y simples ''   además de tabulaciones. ';

SELECT dbo.fn_normalize_format_description(@TestDescription) AS NormalizedDescription;
