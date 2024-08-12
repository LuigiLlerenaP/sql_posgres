-- Agregar las columnas 'DESCRIPTION' y 'SCORE_VALUE' a la tabla
ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES]
ADD 
    [DESCRIPTION] varchar(MAX) NOT NULL CHECK (
        LEN([DESCRIPTION]) > 0
        AND LEN([DESCRIPTION]) <= 255
    ),
    [SCORE_VALUE] int NOT NULL CHECK (
        [SCORE_VALUE] >= 0
        AND [SCORE_VALUE] <= 20
    );


-- Verificar la estructura de la tabla después de la modificación
EXEC sp_help 'T_RRHH_PERFORMANCE_EVALUATIONS_SCORES';

--MODIFICAR EL TAMANIO DE CARACTERERS
ALTER TABLE T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
ALTER COLUMN DESCRIPTION varchar(500) NOT NULL;

ALTER TABLE T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS
ALTER COLUMN RECOMMENDATION_NAME varchar(500) NOT NULL;

