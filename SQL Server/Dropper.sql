USE StockSafe;

DROP TABLE dbo.tb_registro;
DROP TABLE dbo.tb_monitorar;
DROP TABLE dbo.tb_alerta;
DROP TABLE dbo.tb_processo;
DROP TABLE dbo.tb_opcao;
DROP TABLE dbo.tb_tag_servidor;
DROP TABLE dbo.tb_servidor;
DROP TABLE dbo.tb_funcionario;
DROP TABLE dbo.tb_categoria;
DROP TABLE dbo.tb_tag;


-- Esse é o Dropper, nosso amigo para quando tudo da errado
USE master;
GO

ALTER DATABASE StockSafe SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE StockSafe;