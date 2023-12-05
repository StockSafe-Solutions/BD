SELECT SUM(CASE WHEN uso_da_ram <= 30 OR uso_da_ram >= 80 THEN 1 ELSE 0 END) AS contagem
FROM vw_ram_geral
WHERE dataDados >= DATEADD(day, -30, GETDATE());

SELECT SUM(CASE WHEN uso_da_cpu <= 30 OR uso_da_cpu >= 80 THEN 1 ELSE 0 END) AS contagem
FROM vw_cpu_geral
WHERE dataDados >= DATEADD(day, -30, GETDATE());

SELECT COUNT(*) as contagem
FROM tb_servidor
WHERE ((armazenamento_usado * 100.0) / armazenamento_total) <= 15 OR ((armazenamento_usado * 100.0) / armazenamento_total) >= 75;



IF OBJECT_ID('kpi_uptime_erro', 'P') IS NOT NULL
    DROP PROCEDURE kpi_uptime_erro;
GO

CREATE PROCEDURE kpi_uptime_erro @taxa_atualizacao INT
AS
BEGIN
    DECLARE @limite INT;
    SELECT @limite = COUNT(id_servidor) FROM tb_servidor;

    IF OBJECT_ID('tempdb..#quantidade_registros') IS NOT NULL
        DROP TABLE #quantidade_registros;

    IF OBJECT_ID('tempdb..#kpi_especifica') IS NOT NULL
        DROP TABLE #kpi_especifica;

    IF OBJECT_ID('tempdb..#erro_uptime') IS NOT NULL
        DROP TABLE #erro_uptime;

    SELECT fk_servidor, COUNT(data_hora) AS qtd_registros
    INTO #quantidade_registros
    FROM vw_registro
    GROUP BY fk_servidor;

    SELECT
        ts.id_servidor,
        ts.codigo,
        AVG((qr.qtd_registros * 100.0) / (9.0 / @taxa_atualizacao)) AS kpi_uptime
    INTO #kpi_especifica
    FROM tb_servidor ts
    JOIN #quantidade_registros qr ON qr.fk_servidor = ts.id_servidor
    GROUP BY ts.id_servidor, ts.codigo;

    SELECT COUNT(*) AS contagem
    INTO #erro_uptime
    FROM #kpi_especifica
    WHERE kpi_uptime <= 98;

    SELECT * FROM #erro_uptime;
END;

EXECUTE kpi_uptime_erro @taxa_atualizacao = 1;



IF OBJECT_ID('dash_geral_erros', 'P') IS NOT NULL
    DROP PROCEDURE dash_geral_erros;
GO

CREATE PROCEDURE dash_geral_erros @taxa_atualizacao INT
AS
BEGIN
    DECLARE @limite INT;
    SELECT @limite = COUNT(id_servidor) FROM tb_servidor;

    IF OBJECT_ID('tempdb..#quantidade_registros') IS NOT NULL
        DROP TABLE #quantidade_registros;

    IF OBJECT_ID('tempdb..#kpi_especifica') IS NOT NULL
        DROP TABLE #kpi_especifica;

    IF OBJECT_ID('tempdb..#erro_uptime') IS NOT NULL
        DROP TABLE #erro_uptime;

    SELECT fk_servidor, COUNT(data_hora) AS qtd_registros
    INTO #quantidade_registros
    FROM vw_registro
    GROUP BY fk_servidor;

    SELECT
        ts.id_servidor,
        ts.codigo,
        r.data_hora,
        AVG((qr.qtd_registros * 100.0) / (9.0 / @taxa_atualizacao)) AS kpi_uptime
    INTO #kpi_especifica
    FROM tb_servidor ts
    JOIN vw_registro r ON r.fk_servidor = ts.id_servidor
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = ts.id_servidor
    JOIN #quantidade_registros qr ON qr.fk_servidor = ts.id_servidor
    GROUP BY ts.id_servidor, ts.codigo, CONVERT(DATE, pct.data_hora), r.data_hora;

    SELECT
        FORMAT(dia, 'dd-MM-yyyy') AS dia,
        SUM(contagem) AS contagem_total
    FROM (
        SELECT
            FORMAT(dataDados, 'dd-MM-yyyy') AS dia,
            COUNT(*) AS contagem
        FROM vw_ram_geral
        WHERE uso_da_ram <= 30 OR uso_da_ram >= 80 AND dataDados >= DATEADD(DAY, -30, GETDATE())
        GROUP BY FORMAT(dataDados, 'dd-MM-yyyy')

        UNION ALL

        SELECT
            FORMAT(dataDados, 'dd-MM-yyyy') AS dia,
            COUNT(*) AS contagem
        FROM vw_cpu_geral
        WHERE uso_da_cpu <= 30 OR uso_da_cpu >= 80 AND dataDados >= DATEADD(DAY, -30, GETDATE())
        GROUP BY FORMAT(dataDados, 'dd-MM-yyyy')

        UNION ALL

        SELECT
            FORMAT(data_hora, 'dd-MM-yyyy') AS dia,
            COUNT(*) AS contagem
        FROM tb_servidor
        WHERE ((armazenamento_usado * 100.0) / armazenamento_total) <= 15 OR ((armazenamento_usado * 100.0) / armazenamento_total) >= 75 AND data_hora >= DATEADD(DAY, -30, GETDATE())
        GROUP BY FORMAT(data_hora, 'dd-MM-yyyy')

        UNION ALL

        SELECT
            FORMAT(data_hora, 'dd-MM-yyyy') AS dia,
            COUNT(*) AS contagem
        FROM #kpi_especifica
        WHERE kpi_uptime <= 98 AND data_hora >= DATEADD(DAY, -30, GETDATE())
        GROUP BY FORMAT(data_hora, 'dd-MM-yyyy')
    ) AS subquery
    GROUP BY dia;
END;
	
EXECUTE dash_geral_erros @taxa_atualizacao = 5;
