-- SESSÃO DAS VIEWS

-- VIEWS MESTRAS
CREATE OR REPLACE VIEW vw_base_registros AS
	SELECT 
    r.fk_servidor,
	data_hora,
    tipo_cat,
    avg(valor) as media
		FROM tb_registro AS r
        JOIN tb_categoria AS c on r.fk_cat = c.id_cat
			GROUP BY fk_servidor, data_hora, c.id_cat;
            
SET @executor = NULL;
SELECT
    GROUP_CONCAT(DISTINCT CONCAT('max(case when tipo_cat = \'',
                tipo_cat,'\' then media end) \'',
                LOWER(REPLACE(tipo_cat," ","_")),
                '\'')) -- Listando todas as colunas e criando um case para cada uma
INTO @executor FROM vw_base_registros; -- Aqui vem o nome da sua view!
SET @executor = CONCAT('
	CREATE OR REPLACE VIEW vw_registro AS
	SELECT fk_servidor, data_hora, ', @executor, '
	FROM vw_base_registros
	GROUP BY fk_servidor, data_hora');
PREPARE criarView FROM @executor;
EXECUTE criarView; 

SELECT * FROM vw_registro;
-- VIEW DOS SERVIDORES
CREATE OR REPLACE VIEW vw_servidor AS
	SELECT 
	s.*,
	DATE_FORMAT(d.data_hora,"%d/%m/%Y") as ultimaData,
	DATE_FORMAT(d.data_hora,"%H:%i") as ultimoHorario
		FROM tb_servidor AS s
		LEFT JOIN(SELECT fk_servidor, max(data_hora) as data_hora 
					FROM vw_registro GROUP BY fk_servidor) AS d
		ON s.id_servidor = d.fk_servidor;

SELECT * FROM vw_servidor;

-- -------------------------------------------------------------------- Gráficos
-- VIEW CPU
CREATE OR REPLACE VIEW vw_cpu AS
	SELECT fk_servidor, avg(uso_da_cpu) as uso_da_cpu,  DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados
    FROM vw_registro
	GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i'), fk_servidor;

SELECT * FROM vw_cpu;

CREATE OR REPLACE VIEW vw_cpu_geral AS
	SELECT avg(uso_da_cpu) as uso_da_cpu, DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') as dataDados
    FROM vw_registro
	GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i');

SELECT * FROM vw_cpu_geral;

-- RAM        
CREATE OR REPLACE VIEW vw_ram AS
	SELECT fk_servidor, avg(uso_da_ram) as uso_da_ram, DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados
    FROM vw_registro
	GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i'), fk_servidor;

SELECT * FROM vw_ram;

CREATE OR REPLACE VIEW vw_ram_geral AS
	SELECT avg(uso_da_ram) as uso_da_ram, DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i') AS dataDados FROM vw_registro
		GROUP BY DATE_FORMAT(data_hora, '%Y-%m-%d %h:%i');

SELECT * FROM vw_ram_geral;

-- -------------------------------------------------------------------- KPI
-- Taxa de Transferencia
CREATE OR REPLACE VIEW vw_taxa_de_transferência AS
	SELECT fk_servidor, avg(taxa_de_transferência) as taxa_de_transferência, data_hora FROM vw_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_taxa_de_transferência;

-- PACOTES ENVIADOS POR DATA/HORA
CREATE OR REPLACE VIEW vw_pacotes_enviados 
	AS SELECT
    fk_servidor,
    avg(pacotes_enviados) as 'pacotes_enviados',
    data_hora
    FROM vw_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_pacotes_enviados;


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