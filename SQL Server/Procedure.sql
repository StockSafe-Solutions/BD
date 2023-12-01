-- PARA PORTAR DE MySQL -> SQL Server

DROP PROCEDURE IF EXISTS sp_kpi_especifica;	

DELIMITER //
CREATE PROCEDURE sp_kpi_especifica(IN taxa_atualizacao INT, IN pCodigo CHAR(6))
BEGIN
	DROP TABLE IF EXISTS quantidade_registros;
    DROP TABLE IF EXISTS kpi_especifica;
	
	CREATE TEMPORARY TABLE quantidade_registros (
		select fk_servidor, count(data_hora) as qtd_registros from vw_registro group by fk_servidor
    );
    
    CREATE TEMPORARY TABLE kpi_especifica(
		
	SELECT
		id_servidor,
        codigo,
		avg((qr.qtd_registros * 100) / (9 / taxa_atualizacao)) as kpi_uptime,
		avg(taxt.taxa_de_transferência) AS kpi_taxa,
		avg(opt.taxa_de_transferência) AS base_taxa,
		sum(pct.pacotes_enviados) AS kpi_pacotes_enviados,
		avg((armazenamento_usado * 100) / armazenamento_total) AS kpi_armazenamento,
		avg(armazenamento_total) AS base_armazenamento
		FROM tb_servidor
			JOIN vw_taxa_de_transferência AS taxt ON taxt.fk_servidor = id_servidor
			JOIN tb_opcao AS opt
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = id_servidor
            JOIN quantidade_registros AS qr ON qr.fk_servidor = id_servidor
			GROUP BY id_servidor, codigo, DAY(pct.data_hora)
    );
    
      
	SELECT * FROM kpi_especifica WHERE codigo = pCodigo;
END //
DELIMITER ;

CALL sp_kpi_especifica(1,'SVJW32');

-- USO DE BANDA LARGA TOTAL
DROP PROCEDURE IF EXISTS sp_uso_banda_larga;

DELIMITER //
CREATE PROCEDURE sp_uso_banda_larga()
BEGIN
    DECLARE limite INT;

    SET limite = (select count(id_servidor) from tb_servidor);
    
    DROP TABLE IF EXISTS banda_larga;
    
    CREATE TEMPORARY TABLE banda_larga ( 
    SELECT round(sum(taxa_de_transferência), 2) AS 'uso_banda_larga' from vw_taxa_de_transferência LIMIT limite
    );
    
    select * from banda_larga;
END //
DELIMITER ;

call sp_uso_banda_larga();

DROP PROCEDURE IF EXISTS sp_kpi_geral;	

DELIMITER //
CREATE PROCEDURE sp_kpi_geral(IN taxa_atualizacao INT)
BEGIN
	DECLARE limite INT;
    SET limite = (select count(id_servidor) from tb_servidor);

    DROP TABLE IF EXISTS quantidade_registros;
    DROP TABLE IF EXISTS kpi_especifica;
    DROP TABLE IF EXISTS banda_larga;
	DROP TABLE IF EXISTS kpi_geral;
	
	CREATE TEMPORARY TABLE quantidade_registros (
		select fk_servidor, count(data_hora) as qtd_registros from vw_registro group by fk_servidor
    );
	    
    CREATE TEMPORARY TABLE kpi_especifica(
		
	SELECT
		id_servidor,
        codigo,
		avg((qr.qtd_registros * 100) / (9 / taxa_atualizacao)) as kpi_uptime,
		avg(taxt.taxa_de_transferência) AS kpi_taxa,
		avg(opt.taxa_de_transferência) AS base_taxa,
		sum(pct.pacotes_enviados) AS kpi_pacotes_enviados,
		avg((armazenamento_usado * 100) / armazenamento_total) AS kpi_armazenamento,
		avg(armazenamento_total) AS base_armazenamento
		FROM tb_servidor
			JOIN vw_taxa_de_transferência AS taxt ON taxt.fk_servidor = id_servidor
			JOIN tb_opcao AS opt
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = id_servidor
            JOIN quantidade_registros AS qr ON qr.fk_servidor = id_servidor
			GROUP BY id_servidor, codigo, DAY(pct.data_hora)
    );
	
    CREATE TEMPORARY TABLE banda_larga ( 
    SELECT round(sum(taxa_de_transferência), 2) AS 'uso_banda_larga' from vw_taxa_de_transferência LIMIT limite
    );

    CREATE TEMPORARY TABLE kpi_geral(
		
	SELECT
		avg(kpi_esp.kpi_uptime) as kpi_uptime,
		avg(banda_larga.uso_banda_larga) as kpi_banda_larga,
		avg(opt.taxa_de_transferência) AS base_taxa,
		sum(pct.pacotes_enviados) AS kpi_pacotes_enviados,
		sum(armazenamento_usado) AS kpi_armazenamento,
		sum(armazenamento_total) as base_armazenamento
		FROM tb_servidor
			JOIN kpi_especifica AS kpi_esp
            JOIN banda_larga AS banda_larga
            JOIN tb_opcao AS opt
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = tb_servidor.id_servidor
			GROUP BY DAY(pct.data_hora)
    );
    
    select * from kpi_geral;
END //
DELIMITER ;

CALL sp_kpi_geral(1);
