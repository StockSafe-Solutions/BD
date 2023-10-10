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
  FOREIGN KEY (id_autenticador) REFERENCES funcionario (id_funcionario)
    ) 
    AUTO_INCREMENT = 2000;

CREATE TABLE IF NOT EXISTS tb_tipo_componente (
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
  FOREIGN KEY (fk_servidor) REFERENCES servidor (id_servidor),
  FOREIGN KEY (fk_tipo) REFERENCES tipo_componente (id_tipo)
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
  
INSERT INTO funcionario VALUES (1, 'Danilo', 'Analista', '2005-07-11', null, 'danilo@gmal.com', 'urubu100');

INSERT INTO servidor (codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUES
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

INSERT INTO tipo_componente (nome, unidade_medida) VALUES ('RAM', '%'), ('Taxa de Transferência', 'Gb/s'), ('CPU', '%');

INSERT INTO registro (fk_servidor, data_hora, uso_ram, fk_tipo) VALUES 
		(2001, NOW(), 30, 1),
		(2002, NOW(), 25, 1),
        (2003, NOW(), 20, 1),
        (2004, NOW(), 28, 2),
        (2005, NOW(), 22, 2),
        (2006, NOW(), 26, 2),
        (2007, NOW(), 24, 3),
        (2008, NOW(), 20, 3),
        (2009, NOW(), 32, 3),
        (2010, NOW(), 22, 1),
        (2011, NOW(), 28, 1),
        (2012, NOW(), 25, 2),
        (2013, NOW(), 20, 2),
        (2014, NOW(), 26, 3),
		(2015, NOW(), 28, 3);

