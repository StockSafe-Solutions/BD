-- Transcrição de comandos mysql para sql server
SELECT * FROM vw_registro;
-- kpiRam
SELECT TOP 1 DATEPART(MINUTE, data_hora) AS dataDados,
   ROUND(AVG(uso_da_ram),0) AS avgUsoRam,
   ROUND(AVG(ram_livre),0) AS avgUsoDisponivelRam,
   ROUND(AVG(total_da_ram),0) AS avgTotalRam
	FROM vw_registro
	  WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32' )
	  GROUP BY DATEPART(MINUTE, data_hora)
	  ORDER BY dataDados DESC;

-- ramEspecifico
SELECT * FROM vw_ram 
        WHERE fk_servidor = 
            (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32') ORDER BY dataDados ASC;

GO
-- ramUsadaEspeficico
SELECT TOP 1*
FROM vw_ram
WHERE fk_servidor = (
  SELECT id_servidor
  FROM tb_servidor
  WHERE codigo = 'SVJW32'
) ORDER BY dataDados DESC;
GO
-- ramLivreEspeficico
GO
	SELECT TOP 1* 
	FROM vw_ram_livre 
	WHERE fk_servidor = (
	SELECT id_servidor 
	FROM tb_servidor 
	WHERE codigo = 'SVJW32'
	) ORDER BY dataDados DESC;
GO
-- horaRam
GO
	SELECT dataDados AS Dia, DATEPART(MINUTE, dataDados) AS Minutos
	FROM vw_ram WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32');
GO
--csvRam
SELECT FORMAT(data_hora, 'yyyy-MM-dd hh:mm') AS dataDados,
       ROUND(AVG(uso_da_ram), 0) AS avgUsoRam,
       ROUND(AVG(ram_livre), 0) AS avgUsoDisponivelRam,
       ROUND(AVG(total_da_ram), 0) AS avgUsoTotalRam
FROM vw_registro
WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32')
      AND CONVERT(VARCHAR, data_hora, 120) LIKE '%2023-11-29%'
GROUP BY FORMAT(data_hora, 'yyyy-MM-dd hh:mm')
ORDER BY dataDados;

--listarRegistrosData
SELECT * FROM vw_registro WHERE data_hora LIKE '%2023-11-29%';

 -- listarRegistrosDataEspeficico
 SELECT * FROM vw_registro WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32')
     and data_hora LIKE '%2023-11-29%';

