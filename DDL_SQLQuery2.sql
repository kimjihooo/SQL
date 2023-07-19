-- DDL ½Ç½À
USE DoItSQL
CREATE TABLE doit_dml (
col_1 INT,
col_2 NVARCHAR(50),
col_3 DATETIME
)


INSERT INTO doit_dml (col_1, col_2, col_3)
VALUES (1, 'doitsql', '2023-01-01')

SELECT * FROM doit_dml

DROP TABLE doit_dml