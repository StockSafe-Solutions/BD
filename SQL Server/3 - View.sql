USE StockSafe;

GO
CREATE OR ALTER VIEW vw_base_registros AS
    SELECT 
        r.fk_servidor,
        data_hora,
        c.tipo_cat,
        AVG(valor) as media
    FROM tb_registro AS r
    JOIN tb_categoria AS c ON r.fk_cat = c.id_cat
    GROUP BY r.fk_servidor, data_hora, c.tipo_cat;
GO

CREATE OR ALTER VIEW vw_registro AS 
	SELECT
		fk_servidor,
		data_hora,
		MAX(CASE WHEN tipo_cat = 'Pacotes enviados' THEN media END) AS pacotes_enviados,
		MAX(CASE WHEN tipo_cat = 'Taxa de transferencia' THEN media END) AS taxa_de_transferencia,
		MAX(CASE WHEN tipo_cat = 'Uso da CPU' THEN media END) AS uso_da_cpu,
		MAX(CASE WHEN tipo_cat = 'Uso da RAM' THEN media END) AS uso_da_ram,
		MAX(CASE WHEN tipo_cat = 'Total da RAM' THEN media END) AS total_da_ram,
		MAX(CASE WHEN tipo_cat = 'Uso disponivel da RAM' THEN media END) AS ram_livre
	FROM vw_base_registros
	GROUP BY fk_servidor, data_hora;

GO
CREATE OR ALTER VIEW vw_servidor
	AS
	SELECT
	s.*,
		FORMAT(data_hora, 'dd/MM, yyyy', 'pt-BR') AS 'ultimaData',
		FORMAT(data_hora, 'HH:mm', 'pt-BR') AS 'ultimoHorario'
	FROM tb_servidor s
	LEFT OUTER JOIN (
		SELECT
			fk_servidor,
			MAX(data_hora) AS data_hora
		FROM vw_registro
		GROUP BY fk_servidor
) d ON s.id_servidor = d.fk_servidor;

GO


CREATE OR ALTER VIEW vw_cpu AS
	SELECT
	  fk_servidor,
	  AVG(uso_da_cpu) AS uso_da_cpu,
	  FORMAT(MAX(data_hora), 'HH:mm') AS dataDados
	FROM vw_registro
	GROUP BY
	  fk_servidor,
	  DATEPART(HOUR, data_hora);
GO


CREATE OR ALTER VIEW vw_cpu_geral AS
	SELECT
	  AVG(uso_da_cpu) AS uso_da_cpu,
	  FORMAT(MAX(data_hora), 'HH:mm') AS dataDados
	FROM vw_registro
	GROUP BY
	  DATEPART(HOUR, data_hora);
GO

CREATE OR ALTER VIEW vw_ram AS
	SELECT
		fk_servidor,
		AVG(uso_da_ram) AS uso_da_ram, 
		FORMAT(data_hora, 'HH:mm') AS dataDados
    FROM vw_registro
    WHERE uso_da_ram IS NOT NULL
	GROUP BY fk_servidor, FORMAT(data_hora, 'HH:mm');
GO

CREATE OR ALTER VIEW vw_ram_geral AS
	SELECT
	  AVG(uso_da_ram) AS uso_da_ram,
	  FORMAT(MAX(data_hora), 'HH:mm') AS dataDados
	FROM vw_registro
	WHERE uso_da_ram IS NOT NULL
	GROUP BY
	  DATEPART(HOUR, data_hora);
GO
CREATE OR ALTER VIEW vw_taxa_de_transferencia AS
    SELECT
        fk_servidor,
        AVG(taxa_de_transferencia) AS taxa_de_transferencia,
        data_hora
    FROM vw_registro
    GROUP BY data_hora, fk_servidor;
GO
CREATE OR ALTER VIEW vw_pacotes_enviados AS
	SELECT
		fk_servidor,
		AVG(pacotes_enviados) AS pacotes_enviados,
		data_hora
	FROM vw_registro
	GROUP BY data_hora, fk_servidor;

-- KPI Geral (FORA DE VIEW PARA PODEMOS USAR O WHERE EM UMA COLUNA QUE NÃO É RETORNADA)
	SELECT
        AVG(taxt.taxa_de_transferencia) AS kpi_taxa,
        SUM(pct.pacotes_enviados) AS kpi_pacotes_enviados,
        SUM((s.armazenamento_usado * 100.0) / s.armazenamento_total) AS kpi_armazenamento,
        SUM(s.armazenamento_total) AS base_armazenamento
    FROM tb_servidor s
    JOIN vw_taxa_de_transferencia taxt ON taxt.fk_servidor = s.id_servidor
    JOIN vw_pacotes_enviados pct ON pct.fk_servidor = s.id_servidor
    WHERE s.codigo = 'SVJW32';
   