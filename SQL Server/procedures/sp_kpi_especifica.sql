GO
USE StockSafe;

GO
CREATE VIEW vw_kpi_especifica AS
    SELECT
        s.id_servidor,
        s.codigo,
        AVG(taxt.taxa_de_transferencia) AS kpi_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        AVG((s.armazenamento_usado * 100.0) / s.armazenamento_total) AS kpi_armazenamento,
        AVG(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN vw_taxa_de_transferencia taxt ON taxt.fk_servidor = s.id_servidor
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    GROUP BY s.id_servidor, s.codigo;

SELECT * FROM vw_kpi_especifica WHERE codigo = 'SVJW32';