INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_MEDICATION_CATEGORIES] (IDE_COMPANY, CATEGORY_NAME, DESCRIPTION)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Analgésicos', 'Medicamentos para aliviar el dolor'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Antiinflamatorios', 'Medicamentos para reducir la inflamación'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Antihistamínicos', 'Medicamentos para aliviar alergias'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Antibióticos', 'Medicamentos para combatir infecciones'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Vitaminas y Minerales', 'Suplementos nutricionales');
GO

INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_UNITS] (IDE_COMPANY, UNIT_NAME, ABBREVIATION)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Miligramo', 'mg'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Gramo', 'g'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Mililitro', 'ml'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Unidad', 'u'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Gotas', 'g');
GO

INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_DOSAGES] (IDE_COMPANY, DOSAGE_NAME, DESCRIPTION)
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Una tableta', 'Una unidad sólida de medicamento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Dos cápsulas', 'Dos unidades sólidas de medicamento recubiertas'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Cinco mililitros', 'Cantidad líquida de medicamento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Una ampolla', 'Envase de vidrio con medicamento inyectable'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Inhalación profunda', 'Forma de administración del medicamento');
GO

INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_MANUFACTURERS] (IDE_COMPANY, MANUFACTURER_NAME)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Pfizer'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Johnson & Johnson'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Moderna'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Bayer'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Novartis'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Roche'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Sanofi');
GO

INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_PRESENTATIONS] (IDE_COMPANY, PRESENTATION_NAME, DESCRIPTION)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Tableta', 'Forma sólida del medicamento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Cápsula', 'Forma sólida de medicamento recubierta'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Jarabe', 'Forma líquida de medicamento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Inyección', 'Forma líquida para administración parenteral'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Crema', 'Preparación semisólida para aplicación tópica');
GO

INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_ADMINISTRATION_ROUTES] (IDE_COMPANY, ROUTE_NAME)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Oral'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Tópica'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Inyectable'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Inhalatoria'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Oftálmica');
GO

--
INSERT INTO [T_RRHH_OCUPATIONAL_HEALTH_LOTS] (IDE_COMPANY, LOT_NUMBER, MANUFACTURE_DATE, EXPIRATION_DATE)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'LOT12345', '2023-01-01', '2025-01-01'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'LOT67890', '2022-06-15', '2024-06-15'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'LOT54321', '2024-02-10', '2026-03-20'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'LOT98765', '2023-03-20', '2026-02-09'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'LOT43210', '2023-12-25', '2026-12-24');
GO

SELECT * FROM T_RRHH_OCUPATIONAL_HEALTH_MEDICATIONS;

