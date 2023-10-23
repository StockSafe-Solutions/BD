CREATE DATABASE IF NOT EXISTS StockSafe;
USE StockSafe;

-- DROP DATABASE StockSafe;

-- CREATE USER IF NOT EXISTS 'StockSafe'@'localhost' IDENTIFIED BY 'urubu100';
-- GRANT ALL PRIVILEGES ON StockSafe.* TO 'StockSafe'@'localhost';
-- FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS tb_funcionario (
  id_funcionario INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(125) NOT NULL,
  funcao VARCHAR(75) NOT NULL,
  data_nascimento DATE NOT NULL,
  foto VARCHAR(300) NULL,
  email VARCHAR(125) NOT NULL,
  senha VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_funcionario)
  );
  
CREATE TABLE IF NOT EXISTS tb_servidor (
  id_servidor INT NOT NULL AUTO_INCREMENT,
  codigo CHAR(6) NOT NULL,
  armazenamento_total DECIMAL(4,1) NULL,
  armazenamento_usado DECIMAL(4,1) NULL,
  id_autenticador INT NOT NULL,
  PRIMARY KEY (id_servidor, id_autenticador),
  FOREIGN KEY (id_autenticador) REFERENCES tb_funcionario (id_funcionario)
    ) 
    AUTO_INCREMENT = 2000;
  
CREATE TABLE IF NOT EXISTS tb_registro (
  id_registro INT NOT NULL AUTO_INCREMENT,
  fk_servidor INT NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT now(),
  pacotes_enviados INT NULL,
  uso_cpu DOUBLE(5,2) NULL,
  uso_ram DOUBLE(5,2) NULL,
  taxa_transferencia DOUBLE(6,2) NULL,
  PRIMARY KEY (id_registro, fk_servidor),
  FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor)
    );
    
CREATE TABLE IF NOT EXISTS tb_opcao (
  id_opcao INT NOT NULL AUTO_INCREMENT,
  banda_larga SMALLINT DEFAULT(155),
  taxa_transferencia DECIMAL(10,2) DEFAULT(1000.00),
  intervalo_atualizacao INT DEFAULT(60000),
  PRIMARY KEY (id_opcao)
  );
  

-- LISTA DE INSERTS
  
INSERT INTO tb_funcionario VALUES (1, 'Danilo', 'Analista', '2005-07-11', null, 'danilo@gmal.com', 'urubu100');
INSERT INTO tb_funcionario VALUES (2,'Gustavo','Designer','2005-06-13',null,'gustavo@gmail.com','urubu100');

INSERT INTO tb_servidor (codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUES
		('SVJW32', 500.5, 250.2, 1),
		('B7WGPJ', 750.0, 375.5, 1),
        ('RQ8Q28', 300.3, 150.1, 1),
        ('Y5WR5Y', 900.0, 500.0, 1),
        ('TCUHVQ', 800.8, 400.4, 1),
        ('17P51N', 600.6, 300.3, 1);

INSERT INTO tb_registro VALUES 
		(null, 2000, '2023-10-23 10:00:00', 204, 23, 34, 499),
		(null, 2000, '2023-10-23 12:00:00', 84, 5, 21, 487),
        (null, 2000, '2023-10-23 14:00:00', 402, 67, 58, 439),
        (null, 2000, '2023-10-23 16:00:00', 694, 72, 85, 402),
        (null, 2000, '2023-10-23 18:00:00', 960, 86, 94, 414),

        (null, 2001, '2023-10-23 10:00:00', 309, 45, 42, 497),
        (null, 2001, '2023-10-23 12:00:00', 102, 18, 21, 498),
        (null, 2001, '2023-10-23 14:00:00', 492, 56, 48, 427),
        (null, 2001, '2023-10-23 16:00:00', 853, 89, 78, 414),
        (null, 2001, '2023-10-23 18:00:00', 940, 94, 87, 423),

        (null, 2002, '2023-10-23 10:00:00', 294, 28, 39, 498),
        (null, 2002, '2023-10-23 12:00:00', 183, 14, 19, 499),
        (null, 2002, '2023-10-23 14:00:00', 593, 59, 78, 464),
        (null, 2002, '2023-10-23 16:00:00', 869, 85, 89, 421),
		(null, 2002, '2023-10-23 18:00:00', 956, 95, 93, 413);
        
INSERT INTO tb_opcao VALUES
(NULL, 100, 500, 30000);

-- SESSÃO DAS VIEWS
SELECT * FROM tb_registro;

-- VIEW DOS SERVIDORES
CREATE VIEW vw_servidor AS
	SELECT 
	s.*,
	DATE_FORMAT(d.data_hora,"%d/%m/%Y") as ultimaData,
	DATE_FORMAT(d.data_hora,"%H:%i") as ultimoHorario
		FROM tb_servidor AS s
		LEFT JOIN(SELECT fk_servidor, max(data_hora) as data_hora 
					FROM tb_registro GROUP BY fk_servidor) AS d
		ON s.id_servidor = d.fk_servidor;
            
SELECT * FROM vw_servidor;

-- -------------------------------------------------------------------- Gráficos
-- CPU
CREATE OR REPLACE VIEW vw_cpu AS
	SELECT fk_servidor, avg(uso_cpu) as uso_cpu, data_hora FROM tb_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_cpu;

CREATE OR REPLACE VIEW vw_cpu_geral AS
	SELECT fk_servidor, avg(uso_cpu) as uso_cpu, data_hora FROM tb_registro
		GROUP BY DATE_FORMAT(data_hora, '%d');

SELECT * FROM vw_cpu_geral;

-- RAM        
CREATE OR REPLACE VIEW vw_ram AS
	SELECT fk_servidor, avg(uso_ram) as uso_ram, data_hora FROM tb_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_ram;

CREATE OR REPLACE VIEW vw_ram_geral AS
	SELECT fk_servidor, avg(uso_ram) as uso_ram, data_hora FROM tb_registro
		GROUP BY DATE_FORMAT(data_hora, '%d');

SELECT * FROM vw_ram_geral;

-- -------------------------------------------------------------------- //Gráficos


-- -------------------------------------------------------------------- KPI
-- Taxa de Transferencia
CREATE OR REPLACE VIEW vw_taxa_transferencia AS
	SELECT fk_servidor, avg(taxa_transferencia) as taxa_transferencia, data_hora FROM tb_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_taxa_transferencia;

-- PACOTES ENVIADOS POR DATA/HORA
CREATE OR REPLACE VIEW vw_pacotes_enviados 
	AS SELECT
    fk_servidor,
    avg(pacotes_enviados) as 'pacotes_enviados',
    data_hora
    FROM tb_registro
		GROUP BY data_hora, fk_servidor;

SELECT * FROM vw_pacotes_enviados;

DROP PROCEDURE IF EXISTS sp_kpi_especifica;	

DELIMITER //
CREATE PROCEDURE sp_kpi_especifica(IN taxa_atualizacao INT)
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS quantidade_registros (
		select fk_servidor, count(data_hora) as qtd_registros from tb_registro group by fk_servidor
    );
    
	SELECT
		id_servidor,
		avg((qr.qtd_registros * 100) / (9 / taxa_atualizacao)) as uptime,
		avg(taxt.taxa_transferencia) AS kpi_taxa,
		avg(opt.taxa_transferencia) AS base_taxa,
		sum(pct.pacotes_enviados) AS kpi_pacotes_enviados,
		avg(armazenamento_total),
		avg((armazenamento_usado * 100) / armazenamento_total) AS kpi_armazenamento_usado
		FROM tb_servidor
			JOIN vw_taxa_transferencia AS taxt ON taxt.fk_servidor = id_servidor
			JOIN tb_opcao AS opt
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = id_servidor
            JOIN quantidade_registros AS qr ON qr.fk_servidor = id_servidor
			GROUP BY id_servidor, DAY(pct.data_hora);
END //
DELIMITER ;

CALL sp_kpi_especifica(1);

-- USO DE BANDA LARGA TOTAL

DELIMITER //
CREATE PROCEDURE sp_uso_banda_larga()
BEGIN
    DECLARE limite INT;

    SET limite = (select count(id_servidor) from tb_servidor);
    
    SELECT round(sum(taxa_transferencia), 2) from vw_taxa_transferencia LIMIT limite;
END //
DELIMITER ;

call sp_uso_banda_larga();

-- ARMAZENAMENTO USADO
-- CREATE OR REPLACE VIEW vw_kpi_especifica
-- AS SELECT 
-- 	id_servidor,
--     (armazenamento_usado * 100) / armazenamento_total,
--     upt.uptime
--     
--     from tb_servidor;