CREATE DATABASE IF NOT EXISTS StockSafe;
USE StockSafe ;

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

CREATE TABLE IF NOT EXISTS tb_categoria (
  id_tipo INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  unidade_medida VARCHAR(15) NOT NULL,
  PRIMARY KEY (id_tipo)
  );
  

CREATE TABLE IF NOT EXISTS tb_registro (
  id_registro INT NOT NULL AUTO_INCREMENT,
  fk_servidor INT NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT now(),
  pacotes_enviados TINYINT NULL,
  pacotes_perdidos TINYINT NULL,
  uso_cpu TINYINT NULL,
  uso_ram TINYINT NULL,
  taxa_transferencia TINYINT NULL,
  fk_tipo INT NOT NULL,
  PRIMARY KEY (id_registro, fk_servidor),
  FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
  FOREIGN KEY (fk_tipo) REFERENCES tb_tipo_componente (id_tipo)
    );
    
    
CREATE TABLE IF NOT EXISTS tb_opcao (
  id_opcao INT NOT NULL AUTO_INCREMENT,
  banda_larga SMALLINT NOT NULL,
  taxa_transferencia DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_opcao)
  );
  
-- CREATE USER 'StockSafe'@'localhost' IDENTIFIED BY 'urubu100';
-- GRANT ALL PRIVILEGES ON StockSafe.* TO 'StockSafe'@'localhost';

-- LISTA DE INSERTS
  
INSERT INTO tb_funcionario VALUES (1, 'Danilo', 'Analista', '2005-07-11', null, 'danilo@gmal.com', 'urubu100');

INSERT INTO tb_servidor (codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUES
		('SRV001', 500.5, 250.2, 1),
		('SRV002', 750.0, 375.5, 1),
        ('SRV003', 300.3, 150.1, 1),
        ('SRV004', 900.0, 500.0, 1),
        ('SRV005', 800.8, 400.4, 1),
        ('SRV006', 600.6, 300.3, 1),
        ('SRV007', 900.9, 450.4, 1),
        ('SRV008', 400.4, 200.2, 1),
        ('SRV009', 700.7, 350.3, 1),
        ('SRV010', 980.0, 600.0, 1),
        ('SRV011', 450.4, 225.2, 1),
        ('SRV012', 850.8, 425.4, 1),
        ('SRV013', 250.2, 125.1, 1),
        ('SRV014', 950.9, 475.5, 1),
        ('SRV015', 550.5, 275.2, 1),
        ('SRV016', 950.0, 550.0, 1),
        ('SRV017', 350.3, 175.1, 1),
        ('SRV018', 650.6, 325.3, 1),
        ('SRV019', 150.1, 75.0, 1),
		('SRV020', 400.4, 200.2, 1);

INSERT INTO tb_categoria (nome, unidade_medida) VALUES ('RAM', '%'),
														  ('Taxa de Transferência', 'Gb/s'),
														  ('CPU', '%');

INSERT INTO tb_registro (fk_servidor, data_hora, uso_ram, fk_tipo) VALUES 
		(2001, NOW(), 30, 1),
		(2001, NOW(), 25, 1),
        (2001, NOW(), 20, 1),
        (2001, NOW(), 28, 1),
        (2001, NOW(), 22, 1),
        (2002, NOW(), 26, 1),
        (2002, NOW(), 24, 1),
        (2002, NOW(), 20, 1),
        (2002, NOW(), 32, 1),
        (2002, NOW(), 22, 1),
        (2003, NOW(), 28, 1),
        (2003, NOW(), 25, 1),
        (2003, NOW(), 20, 1),
        (2003, NOW(), 26, 1),
		(2003, NOW(), 28, 1);

INSERT INTO tb_registro (fk_servidor, data_hora, taxa_transferencia, fk_tipo) VALUES 
		(2001, NOW(), 100, 2),
		(2001, NOW(), 80, 2),
        (2001, NOW(), 60, 2),
        (2001, NOW(), 90, 2),
        (2001, NOW(), 70, 2),
        (2002, NOW(), 85, 2),
        (2002, NOW(), 75, 2),
        (2002, NOW(), 60, 2),
        (2002, NOW(), 105, 2),
        (2002, NOW(), 70, 2),
        (2003, NOW(), 90, 2),
        (2003, NOW(), 80, 2),
        (2003, NOW(), 60, 2),
        (2003, NOW(), 85, 2),
		(2003, NOW(), 90, 2);
        
INSERT INTO tb_registro (fk_servidor, data_hora, uso_cpu, fk_tipo) VALUES 
		(2001, NOW(), 10, 3),
		(2001, NOW(), 15, 3),
        (2001, NOW(), 12, 3),
        (2001, NOW(), 17, 3),
        (2001, NOW(), 20, 3),
        (2002, NOW(), 23, 3),
        (2002, NOW(), 20, 3),
        (2002, NOW(), 19, 3),
        (2002, NOW(), 15, 3),
        (2002, NOW(), 20, 3),
        (2003, NOW(), 21, 3),
        (2003, NOW(), 18, 3),
        (2003, NOW(), 17, 3),
        (2003, NOW(), 15, 3),
		(2003, NOW(), 14, 3);
        
        

