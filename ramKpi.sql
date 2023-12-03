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
    
SELECT * FROM vw_ram WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32' ) ORDER BY dataDados DESC LIMIT 1;
    
SELECT  MINUTE(data_hora)  AS dataDados,
	ROUND(AVG(uso_da_ram)) AS avgUsoRam,
	ROUND(AVG(uso_disponivel_da_ram)) AS avgUsoDisponivelRam,
	ROUND(AVG(total_da_ram)) AS avgTotalRam
		FROM vw_registro
			WHERE fk_servidor = (SELECT id_servidor FROM tb_servidor WHERE codigo = 'SVJW32' )
			GROUP BY MINUTE(data_hora)
			ORDER BY dataDados DESC
			LIMIT 1 ;

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







