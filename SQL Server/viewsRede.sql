USE StockSafe;
GO

-- Create or alter view for average bandwidth usage
IF OBJECT_ID('dbo.vw_kpi_banda_larga', 'V') IS NOT NULL
    DROP VIEW dbo.vw_kpi_banda_larga;
GO

CREATE VIEW dbo.vw_kpi_banda_larga AS
SELECT AVG(r.valor) AS media, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 6
GROUP BY r.fk_servidor, s.codigo;
GO

-- Create or alter view for average packets sent
IF OBJECT_ID('dbo.vw_kpi_pacotes_enviados', 'V') IS NOT NULL
    DROP VIEW dbo.vw_kpi_pacotes_enviados;
GO

CREATE VIEW dbo.vw_kpi_pacotes_enviados AS
SELECT AVG(r.valor) AS media, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 1
GROUP BY r.fk_servidor, s.codigo;
GO

-- Create or alter view for average packets received
IF OBJECT_ID('dbo.vw_kpi_pacotes_recebidos', 'V') IS NOT NULL
    DROP VIEW dbo.vw_kpi_pacotes_recebidos;
GO

CREATE VIEW dbo.vw_kpi_pacotes_recebidos AS
SELECT AVG(r.valor) AS media, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 5
GROUP BY r.fk_servidor, s.codigo;
GO

-- Create or alter view for average transfer rate
IF OBJECT_ID('dbo.vw_kpi_taxa_transferencia', 'V') IS NOT NULL
    DROP VIEW dbo.vw_kpi_taxa_transferencia;
GO

CREATE VIEW dbo.vw_kpi_taxa_transferencia AS
SELECT AVG(r.valor) AS media, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 4
GROUP BY r.fk_servidor, s.codigo;
GO

-- Create or alter view for bandwidth usage graph
IF OBJECT_ID('dbo.vw_grafico_banda_larga', 'V') IS NOT NULL
    DROP VIEW dbo.vw_grafico_banda_larga;
GO

CREATE VIEW dbo.vw_grafico_banda_larga AS
SELECT r.valor, r.data_hora, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 6;
GO

-- Create or alter view for transfer rate graph
IF OBJECT_ID('dbo.vw_grafico_taxa_transferencia', 'V') IS NOT NULL
    DROP VIEW dbo.vw_grafico_taxa_transferencia;
GO

CREATE VIEW dbo.vw_grafico_taxa_transferencia AS
SELECT r.valor, r.data_hora, r.fk_servidor, s.codigo
FROM dbo.tb_registro AS r
JOIN dbo.tb_servidor AS s ON r.fk_servidor = s.id_servidor
WHERE r.fk_cat = 4;
GO
