-- Eliminar todas las filas de la tabla
DELETE FROM [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES];

-- Eliminar las columnas 'description' y 'value' en minúsculas
ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES]
DROP COLUMN [description], [value];

-- Eliminar la restricción CHECK de la columna 'description
ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES]
DROP CONSTRAINT CK__T_RRHH_PE__value__17593DD2;

--Eliminar la recomendaciones
DELETE FROM T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS where IDE_RECOMMENDATION_SET = '00a2736b-622f-41ae-964c-59a58715f630' ;