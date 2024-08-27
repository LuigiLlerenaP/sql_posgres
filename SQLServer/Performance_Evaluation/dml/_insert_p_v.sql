--TOOLS

-- Insertar datos en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (parent Anual)
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (IDE_COMPANY, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
VALUES ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Criterios de Evaluación de Desempeño Anual', 'Conjunto Principal de Puntajes Anuales', 0);


-- Insertar escalas de calificación en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (IDE_COMPANY, PARENT_SCORE_SET, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'a6fdeb26-d637-41c3-88d7-e58c7c4355ce', 'Desempeño Excepcional', 'Desempeño excepcional - Excede ampliamente las expectativas del puesto, es un modelo a seguir.', 4),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'a6fdeb26-d637-41c3-88d7-e58c7c4355ce', 'Desempeño Regular', 'Desempeño cumple con los estándares establecidos para el puesto, realiza las tareas asignadas de manera competente, muestra habilidades y conocimientos adecuados para el puesto.', 3),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'a6fdeb26-d637-41c3-88d7-e58c7c4355ce', 'Necesita Mejorar', 'Desempeña este comportamiento por debajo del promedio o algunas veces no se observa el comportamiento.', 2),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'a6fdeb26-d637-41c3-88d7-e58c7c4355ce', 'Insatisfactorio', 'Desempeño del empleado no cumple con los estándares mínimos requeridos.', 1);

-- Insertar datos en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (conjunto principal para prueba)
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (IDE_COMPANY, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
VALUES ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Criterios de Evaluación del Período de Prueba', 'Conjunto Principal de Puntajes para Evaluaciones de Período de Prueba', 0);

-- Insertar escalas de calificación en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_SCORES
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SCORES (IDE_COMPANY, PARENT_SCORE_SET, SCORE_NAME, DESCRIPTION, SCORE_VALUE)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'c4224f43-b170-4557-9685-bab6bebb83bf', 'Excelente', 'Desempeño sobresaliente, supera todas las expectativas del rol y es un modelo a seguir.', 5),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'c4224f43-b170-4557-9685-bab6bebb83bf', 'Muy Bueno', 'Desempeño muy bueno, excede los requisitos del puesto y aplica conocimientos de manera efectiva.', 4),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'c4224f43-b170-4557-9685-bab6bebb83bf', 'Adecuado', 'Cumple con los requisitos del puesto y realiza sus tareas de manera competente, con oportunidades para mejorar.', 3),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'c4224f43-b170-4557-9685-bab6bebb83bf', 'Requiere Mejorar', 'Presenta deficiencias en algunas áreas y requiere mejoras significativas para cumplir con las expectativas.', 2),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'c4224f43-b170-4557-9685-bab6bebb83bf', 'Deficiente', 'No alcanza los estándares mínimos requeridos, con deficiencias notables que afectan la productividad.', 1);


-- Insertar datos en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (conjunto principal para prueba)
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (IDE_COMPANY, RECOMMENDATION_NAME, RECOMMENDATION_DESCRIPTION)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     'Recomendaciones para Evaluaciones de Desempeño Anual',
     'Descripción general para las recomendaciones de evaluaciones de desempeño anual.');

-- Insertar recomendaciones para la Evaluación Anual de Desempeño
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (IDE_COMPANY, PARENT_RECOMMENDATION_SET, RECOMMENDATION_NAME, RECOMMENDATION_DESCRIPTION)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     '22fbec35-aaad-4855-9556-ababcd09fb70', 
     'Línea de Supervisión Directa', 
     'La línea de supervisión directa debe evaluar el rendimiento del colaborador, los resultados entregados y la vivencia de los valores institucionales.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     '22fbec35-aaad-4855-9556-ababcd09fb70', 
     'Evaluación Basada en Hechos', 
     'Evite calificar basado en rumores o reputación. Evalúe a la persona basándose en su experiencia real con ella. Las observaciones deben estar fundamentadas en hechos y no en apreciaciones personales o prejuicios.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     '22fbec35-aaad-4855-9556-ababcd09fb70', 
     'Retroalimentación Clara', 
     'Proporcione retroalimentación clara y honesta para que los empleados comprendan su impacto en los resultados y en las demás personas.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     '22fbec35-aaad-4855-9556-ababcd09fb70', 
     'Enfoque en Resultados', 
     'Enfóquese en los resultados y comportamientos observados en la gestión del colaborador, evitando asumir motivos o intenciones.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 
     '22fbec35-aaad-4855-9556-ababcd09fb70', 
     'Fortalezas y Áreas de Mejora', 
     'Recuerde que los empleados valoran conocer tanto sus fortalezas como las áreas en las que pueden mejorar.');


--nsertar datos en la tabla T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (Parent)
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (IDE_COMPANY, RECOMMENDATION_NAME)
VALUES ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'Recomendaciones para evaluaciones de desempeño durante el período de prueba');


-- Insertar recomendaciones para la Evaluación de Prueba
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS (IDE_COMPANY, PARENT_RECOMMENDATION_SET, RECOMMENDATION_NAME)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '813f6f81-82c8-4bb8-afc4-c3b2bc0275de', 'Durante el período de prueba, la supervisión directa debe enfocarse en la adaptación del colaborador a las tareas asignadas y a la cultura de la empresa. Asegúrese de proporcionar comentarios claros y útiles sobre cómo el colaborador está ajustándose a su rol y cómo alinea su comportamiento con las expectativas de la empresa.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '813f6f81-82c8-4bb8-afc4-c3b2bc0275de', 'Es fundamental basar la evaluación en el desempeño y comportamiento observado durante el período de prueba, en lugar de influenciarse por información previa o rumores. Utilice ejemplos específicos de las tareas realizadas y la interacción del colaborador con el equipo para fundamentar sus comentarios.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '813f6f81-82c8-4bb8-afc4-c3b2bc0275de', 'Proporcione retroalimentación constructiva y precisa sobre el desempeño del colaborador, enfocándose en áreas donde ha demostrado habilidades y donde puede necesitar más apoyo. La retroalimentación debe ser directa y ayudar al colaborador a entender cómo puede mejorar su rendimiento de manera inmediata.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '813f6f81-82c8-4bb8-afc4-c3b2bc0275de', 'En lugar de interpretar los motivos detrás del comportamiento del colaborador, observe y evalúe únicamente las acciones y resultados tangibles que ha producido. Esta evaluación debe centrarse en hechos y evidencias claras observadas durante el período de prueba.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '813f6f81-82c8-4bb8-afc4-c3b2bc0275de', 'Asegúrese de que el colaborador reciba comentarios específicos sobre las áreas en las que está sobresaliendo y en las que podría mejorar. Ofrezca sugerencias prácticas para ayudar al colaborador a superar cualquier desafío que enfrente durante su período de prueba.');


--Insert evaluacion tipo 
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_TYPES (IDE_COMPANY, TYPE_EVALUATION, [DESCRIPTION])
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'PROBATIONARY', 'Evaluación que se realizará al empleado durante el periodo de prueba.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ANNUAL', 'Evaluación que se realizará al empleado anualmente para revisar su desempeño.');

-- Insert template name for the evaluation
INSERT INTO RRHH_PERFORMANCE_QUESTION_SETS (IDE_COMPANY, IDE_EVALUATION_TYPE, TEMPLATE_NAME, [DESCRIPTION])
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ff23a938-2743-4c84-8b15-b64fcc0b2ef9', 'Modelo de Evaluación Periodo de Prueba', 'Evaluación para revisar el rendimiento del empleado durante el periodo de prueba.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'abbc12a4-f486-4577-b93a-005b75f061c5', 'Modelo de Evaluación Anual', 'Evaluación anual para revisar el rendimiento y los resultados del empleado durante el año.');


--Insert the seccion for the evaluation 
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS (IDE_COMPANY, IDE_QUESTION_SET, SECTION_NAME)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '018cae10-d7c0-4460-a572-5f09509cb0cb', 'Perfil de Competencias'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '018cae10-d7c0-4460-a572-5f09509cb0cb', 'Plan de Desarrollo Individual'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '15ace49c-a3e7-4a1a-a022-d3f768c4cfe3', 'Resultados Clave'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '15ace49c-a3e7-4a1a-a022-d3f768c4cfe3', 'Estilo de Trabajo'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '15ace49c-a3e7-4a1a-a022-d3f768c4cfe3', 'Áreas de Mejora y Fortaleza');


-- Insert the categories for the evaluation periodo de prueba
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES (IDE_COMPANY, IDE_SECTION, CATEGORY_NAME)
VALUES 
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Orientación hacia resultados'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Trabajo en equipo'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Honestidad y claridad'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Eficiencia operativa'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Colaboración'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Iniciativa'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '865b75fa-9257-4d4b-aebd-c942a76149eb', 'Adaptabilidad al cambio'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '6ebbb805-b020-4d46-b4e0-02539e6ec669', 'Fortalezas y Oportunidades');

-- Insert the categories for the evaluation anual
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES (IDE_COMPANY, IDE_SECTION, CATEGORY_NAME)
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '089a8bdd-6059-4cf7-ab4c-ff86c2622ead', 'Planificación y Organización'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '089a8bdd-6059-4cf7-ab4c-ff86c2622ead', 'Gestión de Equipos'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '089a8bdd-6059-4cf7-ab4c-ff86c2622ead', 'Control de Calidad'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '089a8bdd-6059-4cf7-ab4c-ff86c2622ead', 'Producción'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '53d3ff17-b06c-40fa-a7b3-fb3a04458d66', 'Calidad'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '53d3ff17-b06c-40fa-a7b3-fb3a04458d66', 'Eficiencia o rendimiento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '53d3ff17-b06c-40fa-a7b3-fb3a04458d66', 'Responsabilidad'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '53d3ff17-b06c-40fa-a7b3-fb3a04458d66', 'Organización del trabajo'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '69c88c28-5477-4085-853f-8803701e44fd', 'Aspectos positivos y oportunidades de crecimiento'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '69c88c28-5477-4085-853f-8803701e44fd', 'Observaciones del trabajador');


-- Insertar preguntas para el período de evaluación ANUAL
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS (IDE_COMPANY, IDE_CATEGORY, QUESTION)
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ed8c96e4-120f-4fb9-87d8-7d9fc35178df', '¿Asegura el cumplimiento de las labores de campo según el cronograma establecido para alcanzar las metas de producción determinadas por la compañía?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ed8c96e4-120f-4fb9-87d8-7d9fc35178df', '¿Elabora y envía el cronograma de labores de campo con anticipación para garantizar el cumplimiento de las actividades diarias del personal a cargo?'),
    
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '00d3a854-d3e8-4927-a2eb-8995b14d7b50', '¿Supervisa, capacita y brinda seguimiento a las necesidades del personal a cargo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '00d3a854-d3e8-4927-a2eb-8995b14d7b50', '¿Supervisa y capacita al personal de campo en el proceso de sacudido de flor?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '4af0d5bf-e569-40a7-9c39-3199975811cc', '¿Garantiza que la cosecha cumpla con los estándares de calidad establecidos?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '4af0d5bf-e569-40a7-9c39-3199975811cc', '¿Supervisa la selección de los mejores tallos?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '4af0d5bf-e569-40a7-9c39-3199975811cc', '¿Supervisa el deshierbe adecuado de los tallos sin maltratar la planta?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '4af0d5bf-e569-40a7-9c39-3199975811cc', '¿Supervisa la siembra de la planta cumpliendo con los estándares de producción?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '89c2ff29-fa04-4a4c-90d7-553582148099', 'Conocimiento teórico y técnico: ¿Domina los conceptos, métodos y técnicas adquiridas en la preparación académica formal y/o no formal relacionadas con el quehacer o las funciones de su cargo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '89c2ff29-fa04-4a4c-90d7-553582148099', 'Capacidad de análisis y aplicación: ¿Utiliza efectivamente los conocimientos en situaciones prácticas de su trabajo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '89c2ff29-fa04-4a4c-90d7-553582148099', 'Forma de cumplir la función: ¿Ejecuta o desarrolla las responsabilidades o funciones del cargo teniendo en cuenta su contenido y presentación?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'b505e96c-0065-4057-92ed-36cbe520a7b2', 'Cantidad: ¿Entrega resultados de acuerdo con las proyecciones y necesidades inherentes a las responsabilidades y competencias del cargo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'b505e96c-0065-4057-92ed-36cbe520a7b2', 'Iniciativa y recursividad: ¿Inicia y desarrolla alternativas de acción de manera proactiva, dentro de la autonomía de sus funciones y aprovecha los recursos disponibles para la obtención de resultados?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'b505e96c-0065-4057-92ed-36cbe520a7b2', 'Oportunidad: ¿Entrega trabajos o proyectos a su cargo dentro de los tiempos acorde con las fechas establecidas?'),
    
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '3f51774b-687b-4fdb-ba9d-dcc5d377a997', 'Nivel de compromiso: ¿Contribuye activamente al logro de los objetivos de su equipo, brinda seguimiento a las actividades inherentes a su cargo manteniendo una actitud positiva y proactiva en su trabajo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '3f51774b-687b-4fdb-ba9d-dcc5d377a997', 'Exigencia personal: ¿Muestra disposición para realizar todo su trabajo de acuerdo con los objetivos fijados y afán de superación atendiendo sugerencias de mejoramiento?'),
    
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '67d56176-a010-4ccb-9e0a-c1cdd058dd39', 'Atención a prioridades: ¿Identifica y maneja eficientemente las tareas y actividades más importantes y urgentes en su trabajo? ¿Establece prioridades, gestiona el tiempo de manera efectiva y toma decisiones acertadas sobre las actividades que requieren mayor atención y acción inmediata?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '67d56176-a010-4ccb-9e0a-c1cdd058dd39', 'Trabajo en equipo y relaciones interpersonales: ¿Recibe sugerencias, brinda aportes y toma decisiones junto con otros colaboradores o áreas para lograr resultados comunes? ¿Se comunica y relaciona de forma apropiada con sus superiores, compañeros, subordinados y personal externo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '67d56176-a010-4ccb-9e0a-c1cdd058dd39', 'Hábitos de trabajo: ¿Muestra puntualidad y permanencia en el puesto de trabajo? ¿Es organizado con su puesto de trabajo y la documentación a cargo?');


-- Insertar preguntas para el período de evaluación PRUEBA
INSERT INTO T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS (IDE_COMPANY, IDE_CATEGORY, QUESTION)
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ecad05ad-cb39-47b9-a88a-265901ff5b35', '¿Realiza su trabajo buscando cumplir con los objetivos y acciones esperadas?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ecad05ad-cb39-47b9-a88a-265901ff5b35', '¿Cumple su trabajo en el tiempo requerido?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', 'ecad05ad-cb39-47b9-a88a-265901ff5b35', '¿Atiende los requerimientos solicitados?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '029ae0e3-59b3-48c8-8be0-4122c669e8a2', '¿Se compromete con su equipo de trabajo cumpliendo con las metas y expectativas establecidas?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '029ae0e3-59b3-48c8-8be0-4122c669e8a2', '¿Está siempre dispuesto al intercambio de información con los miembros de su equipo?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '029ae0e3-59b3-48c8-8be0-4122c669e8a2', '¿Aporta ideas y recomendaciones fruto de su conocimiento?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '31d85325-42c3-41f2-b78d-28092c35c06a', '¿Es abierto y honesto en sus relaciones laborales?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '31d85325-42c3-41f2-b78d-28092c35c06a', '¿Mantiene una imagen profesional, digna y confiable en todo lo que hace?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '31d85325-42c3-41f2-b78d-28092c35c06a', '¿Acepta su responsabilidad ante sus acciones y decisiones?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '9bc29a9d-12d9-421a-b588-080ee1bf668f', '¿Aborda sus tareas con exigencia y rigurosidad, ofreciendo altos estándares de calidad?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '9bc29a9d-12d9-421a-b588-080ee1bf668f', '¿Siempre está tratando de mejorar la calidad y eficiencia de su desempeño?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '9bc29a9d-12d9-421a-b588-080ee1bf668f', '¿Revisa continuamente sus avances, planteando alternativas de mejora cuando se presentan dificultades?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Genera confianza en los demás por su actitud generosa a la hora de responsabilizarse por los objetivos comunes?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Realiza acciones que contribuyen al cumplimiento de los objetivos de otras personas de la organización?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Apoya al resto de la organización en temas específicos, sin desatender sus propias obligaciones?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Brinda soluciones rápidas y oportunas ante posibles problemas que presente el equipo en su trabajo diario?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Realiza acciones preventivas para evitar crisis futuras con suficiente antelación?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Actúa de manera independiente para solucionar aquello que está a su alcance o propone alternativas de solución en caso de no estar autorizado para tomar la decisión?'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Reacciona positivamente ante cambios imprevistos en los planes y ante la presencia de adversidades y circunstancias que escapan a su control?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Muestra buena disposición para cambiar las formas de trabajo y las actividades rápidamente para responder a elementos exteriores?'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '95c3306c-3e3a-491e-80d8-0875aca1d678', '¿Percibe los cambios como una oportunidad de crecimiento y los acepta de buen agrado?');



INSERT INTO T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS (IDE_COMPANY, IDE_CATEGORY, QUESTION)
VALUES
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '76b8ae68-f9bf-4a9a-ba05-db80c700b8ba', 'Durante este periodo, he observado que su principal fortaleza es:'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '76b8ae68-f9bf-4a9a-ba05-db80c700b8ba', 'Durante este periodo, he notado que su área de mejora es:'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '76b8ae68-f9bf-4a9a-ba05-db80c700b8ba', 'Comentarios sobre el trabajador'),

    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '2fc46c19-f69f-4293-9a60-fb7c50e51da9', 'Capacitación Inicial: El empleado recibió orientación sobre el cargo de parte de su supervisor y/o compañero de equipo.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '2fc46c19-f69f-4293-9a60-fb7c50e51da9', 'Demuestra consistencia en su conducta diaria con los valores y principios de la empresa.'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '2fc46c19-f69f-4293-9a60-fb7c50e51da9', 'Durante este periodo, he detectado que su principal fortaleza es:'),
    ('5b4234e3-5850-4c53-92c6-7dc3d9ce0e16', '2fc46c19-f69f-4293-9a60-fb7c50e51da9', 'Durante este periodo, he detectado que su área de mejora es:')
;



-- Transaccionales
