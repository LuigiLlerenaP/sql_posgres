ALTER TABLE [T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES]
ADD [IDE_COMPANY] uniqueidentifier NOT NULL;
GO

-- Agregar la columna IDE_MEDICATION a la tabla T_RRHH_OCUPATIONAL_HEALTH_LOTS
ALTER TABLE T_RRHH_OCUPATIONAL_HEALTH_LOTS
ADD IDE_MEDICATION UNIQUEIDENTIFIER NOT NULL;

-- Crear el índice en la columna IDE_MEDICATION
CREATE INDEX [RRHH_OCUPATIONAL_HEALTH_PERSONNEL_index_26] 
ON [T_RRHH_OCUPATIONAL_HEALTH_LOTS] (IDE_MEDICATION);

-- Crear la clave foránea entre T_RRHH_OCUPATIONAL_HEALTH_LOTS e T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
ALTER TABLE [T_RRHH_OCUPATIONAL_HEALTH_LOTS] 
ADD FOREIGN KEY ([IDE_MEDICATION]) 
REFERENCES [T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS] ([IDE_MEDICATION]);


select * from RRHH_OCUPATIONAL_HEALTH_MEDICATIONS_LOTS;


ALTER TABLE T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS
ADD CONSTRAINT UQ_MEDICATION_NAME UNIQUE (MEDICATION_NAME);



ALTER TABLE [T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS]
ADD CONSTRAINT FK_Medication_Details_Medication
FOREIGN KEY ([IDE_MEDICATION]) REFERENCES [T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS]([IDE_MEDICATION])
ON DELETE CASCADE;



---
--
-- Verifica la existencia de la clave foránea en la tabla
SELECT 
    fk.name AS ForeignKeyName,
    col.name AS ColumnName,
    tab.name AS TableName
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    INNER JOIN sys.columns col ON fkc.parent_column_id = col.column_id AND fkc.parent_object_id = col.object_id
    INNER JOIN sys.tables tab ON fkc.parent_object_id = tab.object_id
WHERE 
    col.name = 'IDE_MEDICATION'
    AND tab.name = 'T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS';


SELECT
    fk.name AS ForeignKeyName,
    fk.object_id AS ForeignKeyID,
    tab.name AS TableName,
    col.name AS ColumnName,
    ref_tab.name AS ReferencedTableName,
    ref_col.name AS ReferencedColumnName
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    INNER JOIN sys.tables tab ON fkc.parent_object_id = tab.object_id
    INNER JOIN sys.columns col ON fkc.parent_column_id = col.column_id AND fkc.parent_object_id = col.object_id
    INNER JOIN sys.tables ref_tab ON fkc.referenced_object_id = ref_tab.object_id
    INNER JOIN sys.columns ref_col ON fkc.referenced_column_id = ref_col.column_id AND fkc.referenced_object_id = ref_col.object_id
WHERE 
    tab.name = 'T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS'
    AND col.name = 'IDE_MEDICATION';


ALTER TABLE [T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_DETAILS]
DROP CONSTRAINT FK__T_RRHH_OC__IDE_M__61DC42C1;
