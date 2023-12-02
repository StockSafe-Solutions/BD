CREATE PROCEDURE sp_kpi_especifica
    @taxa_atualizacao INT,
    @pCodigo CHAR(6)
AS
BEGIN
    IF OBJECT_ID('tempdb..#quantidade_registros') IS NOT NULL
        DROP TABLE #quantidade_registros;

    IF OBJECT_ID('tempdb..#kpi_especifica') IS NOT NULL
        DROP TABLE #kpi_especifica;

    CREATE TABLE #quantidade_registros (
        fk_servidor INT NOT NULL,
        qtd_registros INT NOT NULL,
        PRIMARY KEY (fk_servidor)
    );

    INSERT INTO #quantidade_registros
    SELECT fk_servidor, COUNT(*) AS qtd_registros
    FROM vw_registro
    GROUP BY fk_servidor;

    CREATE TABLE #kpi_especifica (
        id_servidor INT NOT NULL,
        codigo VARCHAR(255) NOT NULL,
        kpi_uptime DECIMAL(10, 2),
        kpi_taxa DECIMAL(10, 2),
        kpi_pacotes_enviados INT,
        kpi_armazenamento DECIMAL(10, 2),
        base_armazenamento DECIMAL(10, 2)
    );

    INSERT INTO #kpi_especifica
    SELECT
        s.id_servidor,
        s.codigo,
        AVG((qr.qtd_registros * 100.0) / (9.0 / @taxa_atualizacao)) AS kpi_uptime,
        AVG(taxt.taxa_de_transferencia) AS kpi_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        AVG((s.armazenamento_usado * 100.0) / s.armazenamento_total) AS kpi_armazenamento,
        AVG(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN vw_taxa_de_transferencia taxt ON taxt.fk_servidor = s.id_servidor
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    JOIN #quantidade_registros qr ON qr.fk_servidor = s.id_servidor
    GROUP BY s.id_servidor, s.codigo, DAY(pct.data_hora);

    SELECT *
    FROM #kpi_especifica
    WHERE codigo = @pCodigo;
END;


