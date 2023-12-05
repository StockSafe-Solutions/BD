USE StockSafe;
GO
	CREATE OR ALTER VIEW vw_ram_usada AS
	SELECT fk_servidor,
		   ROUND(AVG(total_da_ram),0) AS ram_uso,
		   CONVERT(VARCHAR(23), data_hora, 120) AS dataDados
	FROM vw_registro
	GROUP BY CONVERT(VARCHAR(23), data_hora, 120), fk_servidor;
GO
	CREATE OR ALTER VIEW vw_ram_livre AS
	SELECT fk_servidor,
		   ROUND(AVG(ram_livre),0) AS ram_livre,
		   CONVERT(VARCHAR(23), data_hora, 120) AS dataDados
	FROM vw_registro
	GROUP BY CONVERT(VARCHAR(23), data_hora, 120), fk_servidor;
GO


