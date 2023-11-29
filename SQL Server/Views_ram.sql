GO
	CREATE OR ALTER VIEW vw_ram_usada
	AS
	SELECT fk_servidor,
		   AVG(total_da_ram) AS ram_uso,
		   CONVERT(VARCHAR(23), data_hora, 120) AS dataDados
	FROM vw_registro
	GROUP BY CONVERT(VARCHAR(23), data_hora, 120), fk_servidor;
GO
	CREATE OR ALTER VIEW vw_ram_livre
	AS
	SELECT fk_servidor,
		   AVG(ram_livre) AS ram_livre,
		   CONVERT(VARCHAR(23), data_hora, 120) AS dataDados
	FROM vw_registro
	GROUP BY CONVERT(VARCHAR(23), data_hora, 120), fk_servidor;
GO


