 /* CREATE TEMPORARY TABLE kpi_especifica_ram(
  
  );*/
SELECT ROUND(AVG(uso_da_ram)) AS 'Dados',
	CASE
	WHEN uso_da_ram >= 90 THEN 'Muito acima do esperado'
    WHEN uso_da_ram <= 20 THEN 'Muito abaixo do esperado'
    WHEN uso_da_ram <= 30 THEN 'Abaixo do esperado'
    WHEN uso_da_ram <= 75 THEN 'Normal'
    WHEN uso_da_ram >= 80 THEN 'Acima do esperado'
    WHEN uso_da_ram <= 78 THEN 'Acima do esperado'
    ELSE 'NULL'
    END AS MetricasUso
FROM vw_registro GROUP BY uso_da_ram;



/*CREATE OR REPLACE VIEW ram_uso_livre AS
SELECT vw_ram_usada.ram_uso AS USO, vw_ram_livre.ram_livre AS LIVRE
FROM vw_ram_usada
JOIN vw_ram_livre
WHERE vw_ram_usada.ram_uso IS NOT NULL
AND vw_ram_livre.ram_livre IS NOT NULL;*/


SELECT data_hora AS dataDados,
       ROUND(AVG(uso_da_ram)) AS avgUsoRam,
       ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
       ROUND(AVG(total_da_ram)) AS avgTotalRam
FROM vw_registro
GROUP BY data_hora
ORDER BY dataDados DESC;

SELECT DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados,
       ROUND(AVG(uso_da_ram)) AS avgUsoRam,
       ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
       ROUND(AVG(total_da_ram)) AS avgUsoTotalRam
FROM vw_registro
WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32')
     and data_hora LIKE '%2023-11-22%'
GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i')
ORDER BY dataDados;

SELECT DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados,
       ROUND(AVG(uso_da_ram)) AS avgUsoRam,
       ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
       ROUND(AVG(total_da_ram)) AS avgUsoTotalRam
FROM vw_registro
GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i')
ORDER BY dataDados;


SELECT  dataDados AS Dia, MINUTE(dataDados) AS Minutos FROM vw_ram WHERE fk_servidor = 
            (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32') ORDER BY dataDados ASC;


-- torta
CREATE OR REPLACE VIEW vw_ram_usada AS
	SELECT fk_servidor,ROUND(AVG(total_da_ram)) AS ram_uso, date_format(data_hora, '%Y-%m-%d %h:%i') AS dataDados
    FROM vw_registro
    GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i'), fk_servidor;
    
    SELECT * FROM vw_ram_usada WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32' ) ORDER BY dataDados asc ;
    
CREATE OR REPLACE VIEW vw_ram_livre AS
SELECT fk_servidor,ROUND(AVG(uso_disponivel_da_ram)) AS ram_livre, date_format(data_hora, '%Y-%m-%d %h:%i') AS dataDados
    FROM vw_registro
    GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i'), fk_servidor;
    
    SELECT * FROM vw_ram_livre WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32' ) ORDER BY dataDados DESC LIMIT 1;
    




