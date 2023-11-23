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

SELECT * FROM vw_ram_usada where ram_uso is not null;
SELECT * FROM vw_ram_livre;

CREATE OR REPLACE VIEW ram_uso_livre AS
SELECT vw_ram_usada.ram_uso AS USO, vw_ram_livre.ram_livre AS LIVRE
FROM vw_ram_usada
JOIN vw_ram_livre
WHERE vw_ram_usada.ram_uso IS NOT NULL
AND vw_ram_livre.ram_livre IS NOT NULL;


SELECT data_hora AS dataDados,
       ROUND(AVG(uso_da_ram)) AS avgUsoRam,
       ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
       ROUND(AVG(uso_total_da_ram)) AS avgTotalRam
FROM vw_registro
GROUP BY data_hora
ORDER BY dataDados DESC;

SELECT DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados,
       ROUND(AVG(uso_da_ram)) AS avgUsoRam,
       ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
       ROUND(AVG(uso_total_da_ram)) AS avgUsoTotalRam
FROM vw_registro
WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32')
     and data_hora LIKE '%2023-11-22%'
GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i')
ORDER BY dataDados;


