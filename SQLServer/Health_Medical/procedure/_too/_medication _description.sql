-- ======================================================================================================= --
-- ======================================================================================================= --

-- ======================================= Procedimiento: sp_insert_medication ============================================= --
-- Descripción: Inserta un nuevo medicamento , validando los campos 
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_add_medication_information_health
(
    @IDE_MEDICATION UNIQUEIDENTIFIER,
    @MAX_DOSAGE NUMERIC(10, 2),
    @INDICATIONS_RECOMMENDATION VARCHAR(MAX),
    @CONTRAINDICATIONS VARCHAR(MAX),
    @SIDE_EFFECTS VARCHAR(MAX),
    @FREQUENCY VARCHAR(50),
    @DURATION_TREATMENT INT,
    @NewMedicationDetailsID UNIQUEIDENTIFIER = NULL OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar la existencia del medicamento en la tabla de medicamentos
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS WHERE IDE_MEDICATION = @IDE_MEDICATION)
    BEGIN
        RAISERROR('El medicamento con el identificador proporcionado no existe.', 16, 1);
        RETURN;
    END
    
    -- Validar parámetros
    IF @IDE_MEDICATION IS NULL 
    BEGIN
        RAISERROR('El identificador del medicamento no puede ser NULL.', 16, 1);
        RETURN;
    END

    IF @MAX_DOSAGE IS NULL OR @MAX_DOSAGE <= 0 
    BEGIN
        RAISERROR('La dosificación máxima debe ser un valor positivo.', 16, 1);
        RETURN;
    END

    IF @FREQUENCY IS NULL OR LTRIM(RTRIM(@FREQUENCY)) = '' 
    BEGIN
        RAISERROR('La frecuencia no puede estar vacía.', 16, 1);
        RETURN;
    END

    IF @DURATION_TREATMENT IS NULL OR @DURATION_TREATMENT <= 0 
    BEGIN
        RAISERROR('La duración del tratamiento debe ser un valor positivo.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRANSACTION;

        -- Generar nuevo GUID
        DECLARE @GeneratedID UNIQUEIDENTIFIER = NEWID();

        -- Insertar los detalles del medicamento
        INSERT INTO T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS
        (
            IDE_MEDICATION_DETAIL,
            IDE_MEDICATION,
            MAX_DOSAGE,
            INDICATIONS_RECOMMENDATION,
            CONTRAINDICATIONS,
            SIDE_EFFECTS,
            FREQUENCY,
            DURATION_TREATMENT
        )
        VALUES
        (
            @GeneratedID,
            @IDE_MEDICATION,
            @MAX_DOSAGE,
            @INDICATIONS_RECOMMENDATION,
            @CONTRAINDICATIONS,
            @SIDE_EFFECTS,
            @FREQUENCY,
            @DURATION_TREATMENT
        );

        -- Establecer el valor de salida
        SET @NewMedicationDetailsID = @GeneratedID;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Detalles del medicamento creados exitosamente.';
        
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;
        
        -- Manejo del error
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_add_medication_information_health;
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
GO
DECLARE @NewMedicationDetailsID UNIQUEIDENTIFIER;

EXEC dbo.sp_add_medication_information_health
    @IDE_MEDICATION = '4f2f569c-01e0-4e2b-b98b-f4f18a3d9af4',
    @MAX_DOSAGE = 500.00,
    @INDICATIONS_RECOMMENDATION = 'Recomendación para el medicamento.',
    @CONTRAINDICATIONS = 'Contraindicaciones del medicamento.',
    @SIDE_EFFECTS = 'Efectos secundarios conocidos.',
    @FREQUENCY = '2 veces al día',
    @DURATION_TREATMENT = 7,
    @NewMedicationDetailsID = @NewMedicationDetailsID OUTPUT;

SELECT @NewMedicationDetailsID AS ID;

------------------------------------
EXEC dbo.sp_add_medication_information_health
    @IDE_MEDICATION = '',
    @MAX_DOSAGE = 9.00,
    @INDICATIONS_RECOMMENDATION = 'Recomendación para el medicamento.',
    @CONTRAINDICATIONS = 'Contraindicaciones del medicamento.',
    @SIDE_EFFECTS = 'Efectos secundarios conocidos.',
    @FREQUENCY = '2 veces al día',
    @DURATION_TREATMENT = 7;

-- ======================================================================================================= --
-- ======================================== Read Table==================================================== --
SELECT * 
FROM vw_medication_full_details ;

SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS;
-- ======================================================================================================= --


-- ======================================================================================================= --
-- ======================================================================================================= --


-- ======================================= Procedimiento:  ============================================= --
-- DescripcióN :
-- ================================================================================================================================= --
GO
CREATE PROCEDURE dbo.sp_update_medication_information_health
(
    @IDE_MEDICATION_DETAIL UNIQUEIDENTIFIER,
    @MAX_DOSAGE NUMERIC(10, 2),
    @INDICATIONS_RECOMMENDATION VARCHAR(MAX),
    @CONTRAINDICATIONS VARCHAR(MAX),
    @SIDE_EFFECTS VARCHAR(MAX),
    @FREQUENCY VARCHAR(50),
    @DURATION_TREATMENT INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar la existencia del detalle del medicamento en la tabla de detalles
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS WHERE IDE_MEDICATION_DETAIL = @IDE_MEDICATION_DETAIL)
    BEGIN
        RAISERROR('El detalle del medicamento con el identificador proporcionado no existe.', 16, 1);
        RETURN;
    END;
    
    -- Validar parámetros
    IF @MAX_DOSAGE IS NULL OR @MAX_DOSAGE <= 0 
    BEGIN
        RAISERROR('La dosificación máxima debe ser un valor positivo.', 16, 1);
        RETURN;
    END;

    IF @FREQUENCY IS NULL OR LTRIM(RTRIM(@FREQUENCY)) = '' 
    BEGIN
        RAISERROR('La frecuencia no puede estar vacía.', 16, 1);
        RETURN;
    END;

    IF @DURATION_TREATMENT IS NULL OR @DURATION_TREATMENT <= 0 
    BEGIN
        RAISERROR('La duración del tratamiento debe ser un valor positivo.', 16, 1);
        RETURN;
    END;

     BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRANSACTION;

        -- Actualizar los detalles del medicamento
        UPDATE T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS
        SET
            MAX_DOSAGE = @MAX_DOSAGE,
            INDICATIONS_RECOMMENDATION = @INDICATIONS_RECOMMENDATION,
            CONTRAINDICATIONS = @CONTRAINDICATIONS,
            SIDE_EFFECTS = @SIDE_EFFECTS,
            FREQUENCY = @FREQUENCY,
            DURATION_TREATMENT = @DURATION_TREATMENT
        WHERE 
            IDE_MEDICATION_DETAIL = @IDE_MEDICATION_DETAIL;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'Detalles del medicamento actualizados exitosamente.';
     END TRY
     BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK TRANSACTION;
        
        -- Manejo del error
        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
-- ======================================== DROP PROCEDURE =============================================== --
DROP PROCEDURE IF EXISTS dbo.sp_update_medication_information_health;
-- ======================================================================================================= --

-- ======================================== CALL PROCEDURE ============================================== --
------------------------------------
EXEC dbo.sp_update_medication_information_health 
    @IDE_MEDICATION_DETAIL = '5654ed9e-ddaf-4c31-aebe-1f419a06dfab',
    @MAX_DOSAGE = 900.00, 
    @INDICATIONS_RECOMMENDATION = 'Tomar con alimentos para evitar irritación gástrica.',
    @CONTRAINDICATIONS = 'No usar en personas con antecedentes de alergia a penicilina.', 
    @SIDE_EFFECTS = 'Náuseas, mareos, somnolencia.', 
    @FREQUENCY = 'Cada 8 horas',
    @DURATION_TREATMENT = 7; 

-- ======================================================================================================= --


-- ==================================================================================================== --
-- ==================================================================================================== --

-- ================= Procedimiento: sp_delete_medication =========================
-- Descripción: Elimina un medicamento existente
-- ====================================================================================
GO
CREATE PROCEDURE dbo.sp_delete_medication_information_health
(
    @IDE_MEDICATION_DETAIL UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el registro existe
    IF NOT EXISTS (SELECT 1 FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS WHERE IDE_MEDICATION_DETAIL = @IDE_MEDICATION_DETAIL)
    BEGIN
        RAISERROR('No se encontró información del medicamento con el ID especificado', 16, 1);
        RETURN;
    END;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Eliminar el registro
        DELETE FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS 
        WHERE IDE_MEDICATION_DETAIL = @IDE_MEDICATION_DETAIL;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        PRINT 'El detalle del medicamento ha sido eliminado exitosamente.';
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
DROP PROCEDURE IF EXISTS dbo.sp_delete_medication_information;
-- ======================================================================================================= --

EXEC dbo.sp_delete_medication_information 
    @IDE_MEDICATION_DETAIL = '5654ed9e-ddaf-4c31-aebe-1f419a06dfab';  -- Reemplaza con el ID del detalle del medicamento que deseas eliminar
