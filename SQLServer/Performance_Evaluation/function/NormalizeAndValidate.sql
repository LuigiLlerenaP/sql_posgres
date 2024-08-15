GO
CREATE FUNCTION normalizeAndValidateValue (
    @OriginalValue VARCHAR(255)
)
RETURNS VARCHAR(255)
AS 
BEGIN
    -- Combinar la validación de NULL y vacío
    DECLARE @CleanedValue VARCHAR(255) = TRIM(COALESCE(@OriginalValue, ''));

    -- Validar si el valor limpio es vacío (es decir, si solo había espacios en blanco)
    IF @CleanedValue = ''
    BEGIN
        RETURN NULL;
    END;

    -- Convertir la primera letra a mayúscula y el resto a minúsculas
    DECLARE @NormalizedValue VARCHAR(255) = UPPER(LEFT(@CleanedValue, 1)) + LOWER(SUBSTRING(@CleanedValue, 2, LEN(@CleanedValue) - 1));

    -- Validar que haya más de 1 carácter (mínimo 2 caracteres) ya que el trim reduce la cadena.
    IF LEN(@NormalizedValue) < 2 
    BEGIN
        RETURN NULL;
    END;

    RETURN @NormalizedValue;
END;
GO
