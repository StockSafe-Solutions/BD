GO
USE StockSafe;

GO
CREATE VIEW vw_kpi_geral AS
	SELECT
        s.id_servidor,
        s.codigo,
        AVG(taxt.taxa_de_transferencia) AS kpi_taxa,
        (SELECT taxa_de_transferencia FROM tb_opcao) AS base_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        AVG((s.armazenamento_usado * 100.0) / s.armazenamento_total) AS kpi_armazenamento,
        AVG(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN vw_taxa_de_transferencia taxt ON taxt.fk_servidor = s.id_servidor
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    GROUP BY s.id_servidor, s.codigo, DAY(pct.data_hora);