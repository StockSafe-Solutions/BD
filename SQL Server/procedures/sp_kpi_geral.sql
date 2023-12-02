CREATE PROCEDURE sp_kpi_geral
    @taxa_atualizacao INT
AS
BEGIN
    DECLARE @limite INT;
    SELECT @limite = COUNT(id_servidor) FROM tb_servidor;

    IF OBJECT_ID('tempdb..#quantidade_registros') IS NOT NULL
        DROP TABLE #quantidade_registros;

    IF OBJECT_ID('tempdb..#kpi_especifica') IS NOT NULL
        DROP TABLE #kpi_especifica;

    IF OBJECT_ID('tempdb..#banda_larga') IS NOT NULL
        DROP TABLE #banda_larga;

    IF OBJECT_ID('tempdb..#kpi_geral') IS NOT NULL
        DROP TABLE #kpi_geral;

    CREATE TABLE #quantidade_registros (
        fk_servidor INT,
        qtd_registros INT
    );

    INSERT INTO #quantidade_registros
    SELECT fk_servidor, COUNT(data_hora) AS qtd_registros
    FROM vw_registro
    GROUP BY fk_servidor;

    CREATE TABLE #kpi_especifica (
        id_servidor INT,
        codigo CHAR(6),
        kpi_uptime DECIMAL(10, 2),
        kpi_taxa DECIMAL(10, 2),
        base_taxa DECIMAL(10, 2),
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
        AVG(opt.taxa_de_transferencia) AS base_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        AVG((s.armazenamento_usado * 100.0) / s.armazenamento_total) AS kpi_armazenamento,
        AVG(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN vw_taxa_de_transferencia taxt ON taxt.fk_servidor = s.id_servidor
    JOIN tb_opcao opt
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    JOIN #quantidade_registros qr ON qr.fk_servidor = s.id_servidor
    GROUP BY s.id_servidor, s.codigo, DAY(pct.data_hora);

    CREATE TABLE #banda_larga (
        uso_banda_larga DECIMAL(10, 2)
    );

    INSERT INTO #banda_larga
    SELECT ROUND(SUM(taxa_de_transferencia), 2) AS uso_banda_larga
    FROM vw_taxa_de_transferencia
    WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= @limite;

    CREATE TABLE #kpi_geral (
        kpi_uptime DECIMAL(10, 2),
        kpi_banda_larga DECIMAL(10, 2),
        base_taxa DECIMAL(10, 2),
        kpi_pacotes_enviados INT,
        kpi_armazenamento DECIMAL(10, 2),
        base_armazenamento DECIMAL(10, 2)
    );

    INSERT INTO #kpi_geral
    SELECT
        AVG(kpi_esp.kpi_uptime) AS kpi_uptime,
        AVG(banda_larga.uso_banda_larga) AS kpi_banda_larga,
        AVG(opt.taxa_de_transferencia) AS base_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        SUM(s.armazenamento_usado) AS kpi_armazenamento,
        SUM(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN #kpi_especifica kpi_esp
    JOIN #banda_larga banda_larga
    JOIN tb_opcao opt
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    GROUP BY DAY(pct.data_hora);

    SELECT * FROM #kpi_geral;
END;
