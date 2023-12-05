-- RAM
select SUM(uso_da_ram <= 30 or uso_da_ram >= 80) as contagem from vw_ram_geral where dataDados - interval 30 day;

-- CPU
select SUM(uso_da_cpu <= 30 or uso_da_cpu >= 80) as contagem from vw_cpu_geral where dataDados - interval 30 day;

-- Disco
SELECT COUNT(*) as contagem FROM tb_servidor WHERE ((armazenamento_usado * 100) / armazenamento_total) <= 15 or ((armazenamento_usado * 100) / armazenamento_total) >= 75;



-- PROCEDURE UPTIME ERRO

DELIMITER //
DROP PROCEDURE IF EXISTS kpi_uptime_erro;
CREATE PROCEDURE kpi_uptime_erro(IN taxa_atualizacao INT)
BEGIN
	DECLARE limite INT;
    SET limite = (select count(id_servidor) from tb_servidor);

    DROP TABLE IF EXISTS quantidade_registros;
    DROP TABLE IF EXISTS kpi_especifica;
    DROP TABLE IF EXISTS erro_uptime;
	
	CREATE TEMPORARY TABLE quantidade_registros (
		select fk_servidor, count(data_hora) as qtd_registros from vw_registro group by fk_servidor
    );
	    
    CREATE TEMPORARY TABLE kpi_especifica(
		
	SELECT
		id_servidor,
        codigo,
		avg((qr.qtd_registros * 100) / (9 / taxa_atualizacao)) as kpi_uptime
		FROM tb_servidor
            JOIN quantidade_registros AS qr ON qr.fk_servidor = id_servidor
			GROUP BY id_servidor, codigo
    );
	
    CREATE TEMPORARY TABLE erro_uptime(
		SELECT COUNT(*) as contagem from kpi_especifica where kpi_uptime <= 98
	);
	
    SELECT * FROM erro_uptime;
          
END //
DELIMITER ;

CALL kpi_uptime_erro(1);

-- PROCEDURE GRAFICO

DELIMITER //
DROP PROCEDURE IF EXISTS dash_geral_erros;
CREATE PROCEDURE dash_geral_erros(IN taxa_atualizacao INT)
BEGIN
	DECLARE limite INT;
    SET limite = (select count(id_servidor) from tb_servidor);

    DROP TABLE IF EXISTS quantidade_registros;
    DROP TABLE IF EXISTS kpi_especifica;
    DROP TABLE IF EXISTS erro_uptime;
	
	CREATE TEMPORARY TABLE quantidade_registros (
		select fk_servidor, count(data_hora) as qtd_registros from vw_registro group by fk_servidor
    );
	    
    CREATE TEMPORARY TABLE kpi_especifica(
		
	SELECT
		id_servidor,
        codigo,
        r.data_hora,
		avg((qr.qtd_registros * 100) / (9 / taxa_atualizacao)) as kpi_uptime
		FROM tb_servidor
			JOIN vw_registro as r on r.data_hora = fk_servidor
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = id_servidor
            JOIN quantidade_registros AS qr ON qr.fk_servidor = id_servidor
			GROUP BY id_servidor, codigo, DAY(pct.data_hora), data_hora
    );

    
      
	SELECT DATE_FORMAT(dia, '%d-%m-%Y') as dia, SUM(contagem) as contagem_total FROM (

		SELECT DATE(dataDados) as dia, COUNT(*) as contagem FROM vw_ram_geral WHERE uso_da_ram <= 30 OR uso_da_ram >= 80 and dataDados - INTERVAL 30 DAY GROUP BY DATE(dataDados)

		UNION ALL

		SELECT DATE(dataDados) as dia, COUNT(*) as contagem FROM vw_cpu_geral WHERE uso_da_cpu <= 30 OR uso_da_cpu >= 80 and dataDados - INTERVAL 30 DAY  GROUP BY DATE(dataDados)

		UNION ALL

		SELECT DATE(data_hora) as dia, COUNT(*) as contagem FROM tb_servidor 
        WHERE ((armazenamento_usado * 100) / armazenamento_total) <= 15 OR ((armazenamento_usado * 100) / armazenamento_total) >= 75 and data_hora - INTERVAL 30 DAY 
        GROUP BY DATE(data_hora)
		
		UNION ALL  
		
		SELECT DATE(data_hora) as dia, COUNT(*) as contagem from kpi_especifica where kpi_uptime <= 98 and data_hora - INTERVAL 30 DAY GROUP BY DATE(data_hora)
        
	) AS subquery group by dia;
          
END //
DELIMITER ;
call dash_geral_erros(1);		



