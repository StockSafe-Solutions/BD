-- Esse é o Dropper, nosso amigo para quando tudo da errado
USE master;
GO

ALTER DATABASE StockSafe SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE StockSafe;