--Delete 
IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_SCORES', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_SCORES;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_TYPES', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_TYPES;
GO

IF OBJECT_ID('RRHH_PERFORMANCE_QUESTION_SETS', 'U') IS NOT NULL
    DROP TABLE RRHH_PERFORMANCE_QUESTION_SETS;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS;
GO

IF OBJECT_ID('RRHH_PERFORMANCE_EVALUATIONS_RESPONSES', 'U') IS NOT NULL
    DROP TABLE RRHH_PERFORMANCE_EVALUATIONS_RESPONSES;
GO

IF OBJECT_ID('T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS', 'U') IS NOT NULL
    DROP TABLE T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS;
GO

IF OBJECT_ID('RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES', 'U') IS NOT NULL
    DROP TABLE RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES;
GO

IF OBJECT_ID('RRHH_PERFORMANCE_EVALUATIONS', 'U') IS NOT NULL
    DROP TABLE RRHH_PERFORMANCE_EVALUATIONS;
GO

IF OBJECT_ID('RRHH_PERFORMANCE_EVALUATIONS_DETAILS', 'U') IS NOT NULL
    DROP TABLE RRHH_PERFORMANCE_EVALUATIONS_DETAILS;
GO
--CREATE
CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] (
  [IDE_SCORE_SET] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [PARENT_SCORE_SET] uniqueidentifier,
  [SCORE_NAME] varchar(150) NOT NULL CHECK(LEN(SCORE_NAME)>0 AND LEN(SCORE_NAME)< 150),
  [DESCRIPTION] varchar(3000 ) NOT NULL CHECK (LEN([DESCRIPTION]) > 0 AND LEN (DESCRIPTION)<=3000),
  [SCORE_VALUE] int NOT NULL CHECK ([SCORE_VALUE] >= 0 AND [SCORE_VALUE] <= 20)
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] (
  [IDE_RECOMMENDATION_SET] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [PARENT_RECOMMENDATION_SET] uniqueidentifier,
  [RECOMMENDATION_NAME] varchar(3000 ) NOT NULL CHECK(LEN(RECOMMENDATION_NAME)>0 AND LEN(RECOMMENDATION_NAME)<=3000)
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES] (
  [IDE_EVALUATION_TYPE] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [TYPE_EVALUATION] nvarchar(255) NOT NULL CHECK ([TYPE_EVALUATION] IN ('PROBATIONARY', 'ANNUAL')) UNIQUE,
  [DESCRIPTION] varchar(255)
)
GO

CREATE TABLE [RRHH_PERFORMANCE_QUESTION_SETS] (
  [IDE_QUESTION_SET] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_EVALUATION_TYPE] uniqueidentifier NOT NULL,
  [TEMPLATE_NAME] varchar(255) UNIQUE NOT NULL  CHECK(LEN(TEMPLATE_NAME)>0 AND LEN(TEMPLATE_NAME)<= 255),
  [DESCRIPTION] text
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS] (
  [IDE_SECTION] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_QUESTION_SET] uniqueidentifier NOT NULL,
  [SECTION_NAME] varchar(250) UNIQUE NOT NULL CHECK(LEN(SECTION_NAME)>0 AND LEN(SECTION_NAME)<= 250)
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES] (
  [IDE_CATEGORY] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_SECTION] uniqueidentifier NOT NULL,
  [CATEGORY_NAME] varchar(250) NOT NULL CHECK(LEN(CATEGORY_NAME)>0 AND LEN(CATEGORY_NAME)<= 250)
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS] (
  [IDE_QUESTION] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_CATEGORY] uniqueidentifier NOT NULL,
  [QUESTION] varchar(2000 ) UNIQUE NOT NULL  CHECK(LEN(QUESTION)>0 AND LEN(QUESTION)<= 2000 )
)
GO

CREATE TABLE [RRHH_PERFORMANCE_EVALUATIONS_RESPONSES] (
  [IDE_RESPONSE] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_QUESTION] uniqueidentifier NOT NULL,
  [IDE_SCORE_SET] uniqueidentifier NOT NULL,
  [OBSERVATION] varchar(500)
)
GO

CREATE TABLE [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS] (
  [IDE_INFORMATIONAL_QUESTION] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_CATEGORY] uniqueidentifier NOT NULL,
  [QUESTION] varchar(2000 ) UNIQUE NOT NULL CHECK(LEN(QUESTION)>0 AND LEN(QUESTION)<= 2000 )
)
GO

CREATE TABLE [RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES] (
  [IDE_INFORMATIONAL_RESPONSE] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_INFORMATIONAL_QUESTION] uniqueidentifier NOT NULL,
  [RESPONSE_TEXT] varchar(2000 ) NOT NULL  CHECK(LEN(RESPONSE_TEXT)>0 AND LEN(RESPONSE_TEXT)<= 2000 )
)
GO

CREATE TABLE [RRHH_PERFORMANCE_EVALUATIONS] (
  [IDE_EVALUATION] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_CREATED_BY] uniqueidentifier NOT NULL,
  [IDE_EVALUATION_TYPE] uniqueidentifier NOT NULL,
  [IDE_SCORE_SET] uniqueidentifier NOT NULL,
  [IDE_RECOMMENDATION_SET] uniqueidentifier NOT NULL,
  [IDE_EVALUATED] uniqueidentifier NOT NULL,
  [DATE_START] datetime2 NOT NULL DEFAULT (current_timestamp),
  [DATE_END] datetime2 NOT NULL,
  [IS_APPROVED] bit NOT NULL DEFAULT (0),
  [REMINDER_SENT] bit DEFAULT (0),
  [STATUS] nvarchar(255) CHECK ([STATUS] IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'OVERDUE')) NOT NULL DEFAULT ('PENDING'),
  [IS_DELETED] bit DEFAULT (0),
  CHECK ([DATE_START] <= [DATE_END])
)
GO

CREATE TABLE [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] (
  [IDE_EVALUATION_DETAIL] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (newid()),
  [IDE_COMPANY] uniqueidentifier NOT NULL,
  [IDE_EVALUATION] uniqueidentifier NOT NULL,
  [IDE_EVALUATOR] uniqueidentifier NOT NULL,
  [IDE_QUESTION_SET] uniqueidentifier NOT NULL
)
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES_index_0] ON [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ("PARENT_SCORE_SET")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES_index_1] ON [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ("SCORE_NAME")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS_index_2] ON [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] ("PARENT_RECOMMENDATION_SET")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS_index_3] ON [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] ("RECOMMENDATION_NAME")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES_index_4] ON [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES] ("TYPE_EVALUATION")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES_index_5] ON [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES] ("DESCRIPTION")
GO

CREATE UNIQUE INDEX [RRHH_PERFORMANCE_QUESTION_SETS_index_6] ON [RRHH_PERFORMANCE_QUESTION_SETS] ("IDE_EVALUATION_TYPE", "TEMPLATE_NAME")
GO

CREATE UNIQUE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS_index_8] ON [T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS] ("IDE_QUESTION_SET", "SECTION_NAME")
GO

CREATE UNIQUE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES_index_9] ON [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES] ("IDE_SECTION", "CATEGORY_NAME")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS_index_10] ON [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS] ("IDE_CATEGORY")
GO

CREATE UNIQUE INDEX [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS_index_11] ON [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS] ("IDE_CATEGORY", "QUESTION")
GO

CREATE UNIQUE INDEX [RRHH_PERFORMANCE_EVALUATIONS_RESPONSES_index_12] ON [RRHH_PERFORMANCE_EVALUATIONS_RESPONSES] ("IDE_QUESTION", "IDE_SCORE_SET")
GO

CREATE INDEX [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS_index_13] ON [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS] ("IDE_CATEGORY")
GO

CREATE UNIQUE INDEX [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS_index_14] ON [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS] ("IDE_CATEGORY", "QUESTION")
GO

CREATE INDEX [RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES_index_15] ON [RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES] ("IDE_INFORMATIONAL_QUESTION")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_16] ON [RRHH_PERFORMANCE_EVALUATIONS] ("IDE_CREATED_BY")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_17] ON [RRHH_PERFORMANCE_EVALUATIONS] ("IDE_EVALUATION_TYPE")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_18] ON [RRHH_PERFORMANCE_EVALUATIONS] ("DATE_START")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_19] ON [RRHH_PERFORMANCE_EVALUATIONS] ("STATUS")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_20] ON [RRHH_PERFORMANCE_EVALUATIONS] ("IDE_EVALUATED", "STATUS")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_index_21] ON [RRHH_PERFORMANCE_EVALUATIONS] ("IDE_EVALUATION_TYPE", "STATUS", "DATE_START")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_DETAILS_index_22] ON [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ("IDE_EVALUATION")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_DETAILS_index_23] ON [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ("IDE_EVALUATOR")
GO

CREATE UNIQUE INDEX [RRHH_PERFORMANCE_EVALUATIONS_DETAILS_index_24] ON [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ("IDE_EVALUATION", "IDE_EVALUATOR")
GO

CREATE INDEX [RRHH_PERFORMANCE_EVALUATIONS_DETAILS_index_25] ON [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ("IDE_QUESTION_SET")
GO


ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ADD FOREIGN KEY ([PARENT_SCORE_SET]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ([IDE_SCORE_SET])
GO

ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] ADD FOREIGN KEY ([PARENT_RECOMMENDATION_SET]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] ([IDE_RECOMMENDATION_SET])
GO

ALTER TABLE [RRHH_PERFORMANCE_QUESTION_SETS] ADD FOREIGN KEY ([IDE_EVALUATION_TYPE]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES] ([IDE_EVALUATION_TYPE])
GO

ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS] ADD FOREIGN KEY ([IDE_QUESTION_SET]) REFERENCES [RRHH_PERFORMANCE_QUESTION_SETS] ([IDE_QUESTION_SET])
GO

ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES] ADD FOREIGN KEY ([IDE_SECTION]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_SECTIONS] ([IDE_SECTION])
GO

ALTER TABLE [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS] ADD FOREIGN KEY ([IDE_CATEGORY]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES] ([IDE_CATEGORY])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS_RESPONSES] ADD FOREIGN KEY ([IDE_QUESTION]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_QUESTIONS] ([IDE_QUESTION])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS_RESPONSES] ADD FOREIGN KEY ([IDE_SCORE_SET]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ([IDE_SCORE_SET])
GO

ALTER TABLE [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS] ADD FOREIGN KEY ([IDE_CATEGORY]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_CATEGORIES] ([IDE_CATEGORY])
GO

ALTER TABLE [RRHH_PERFORMANCE_INFORMATIONAL_RESPONSES] ADD FOREIGN KEY ([IDE_INFORMATIONAL_QUESTION]) REFERENCES [T_RRHH_PERFORMANCE_INFORMATIONAL_QUESTIONS] ([IDE_INFORMATIONAL_QUESTION])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS] ADD FOREIGN KEY ([IDE_EVALUATION_TYPE]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_TYPES] ([IDE_EVALUATION_TYPE])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS] ADD FOREIGN KEY ([IDE_SCORE_SET]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_SCORES] ([IDE_SCORE_SET])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS] ADD FOREIGN KEY ([IDE_RECOMMENDATION_SET]) REFERENCES [T_RRHH_PERFORMANCE_EVALUATIONS_RECOMMENDATIONS] ([IDE_RECOMMENDATION_SET])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ADD FOREIGN KEY ([IDE_EVALUATION]) REFERENCES [RRHH_PERFORMANCE_EVALUATIONS] ([IDE_EVALUATION])
GO

ALTER TABLE [RRHH_PERFORMANCE_EVALUATIONS_DETAILS] ADD FOREIGN KEY ([IDE_QUESTION_SET]) REFERENCES [RRHH_PERFORMANCE_QUESTION_SETS] ([IDE_QUESTION_SET])
GO