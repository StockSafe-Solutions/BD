CREATE DATABASE IF NOT EXISTS StockSafe;
USE StockSafe ;

CREATE TABLE IF NOT EXISTS funcionario (
  id_funcionario INT NOT NULL,
  nome VARCHAR(125) NOT NULL,
  funcao VARCHAR(75) NOT NULL,
  data_nascimento DATE NOT NULL,
  foto VARCHAR(300) NULL,
  email VARCHAR(125) NOT NULL,
  senha VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_funcionario)
  );
  

CREATE TABLE IF NOT EXISTS servidor (
  id_servidor INT NOT NULL,
  codigo CHAR(6) NOT NULL,
  armazenamento_total DECIMAL(4,1) NULL,
  armazenamento_usado DECIMAL(4,1) NULL,
  id_autenticador INT NOT NULL,
  PRIMARY KEY (id_servidor, id_autenticador),
  FOREIGN KEY (id_autenticador) REFERENCES funcionario (id_funcionario)
    );

CREATE TABLE IF NOT EXISTS tipo_componente (
  id_tipo INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  unidade_medida VARCHAR(15) NOT NULL,
  PRIMARY KEY (id_tipo)
  );
  

CREATE TABLE IF NOT EXISTS registro (
  id_registro INT NOT NULL,
  fk_servidor INT NOT NULL,
  data_hora DATETIME NOT NULL DEFAULT now(),
  perda_de_pacotes TINYINT NULL,
  uso_cpu TINYINT NULL,
  uso_ram TINYINT NULL,
  taxa_transferencia TINYINT NULL,
  fk_tipo INT NOT NULL,
  PRIMARY KEY (id_registro, fk_servidor),
  FOREIGN KEY (fk_servidor) REFERENCES servidor (id_servidor),
  FOREIGN KEY (fk_tipo) REFERENCES tipo_componente (id_tipo)
    );
    
    
CREATE TABLE IF NOT EXISTS opcao (
  id_opcao INT NOT NULL,
  banda_larga SMALLINT NOT NULL,
  taxa_transferencia DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_opcao)
  );
  
-- CREATE USER 'StockSafe'@'localhost' IDENTIFIED BY 'urubu100';
-- GRANT ALL PRIVILEGES ON StockSafe.* TO 'StockSafe'@'localhost';

-- LISTA DE INSERTS
  
INSERT INTO funcionario VALUES (1, 'Danilo', 'Analista', '2005-07-11', null, 'danilo@gmal.com', 'urubu100');

INSERT INTO servidor (id_servidor, codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUES
		(1, 'SRV001', 500.5, 250.2, 1),
		(2, 'SRV002', 750.0, 375.5, 1),
        (3, 'SRV003', 300.3, 150.1, 1),
        (4, 'SRV004', 900.0, 500.0, 1),
        (5, 'SRV005', 800.8, 400.4, 1),
        (6, 'SRV006', 600.6, 300.3, 1),
        (7, 'SRV007', 900.9, 450.4, 1),
        (8, 'SRV008', 400.4, 200.2, 1),
        (9, 'SRV009', 700.7, 350.3, 1),
        (10, 'SRV010', 980.0, 600.0, 1),
        (11, 'SRV011', 450.4, 225.2, 1),
        (12, 'SRV012', 850.8, 425.4, 1),
        (13, 'SRV013', 250.2, 125.1, 1),
        (14, 'SRV014', 950.9, 475.5, 1),
        (15, 'SRV015', 550.5, 275.2, 1),
        (16, 'SRV016', 950.0, 550.0, 1),
        (17, 'SRV017', 350.3, 175.1, 1),
        (18, 'SRV018', 650.6, 325.3, 1),
        (19, 'SRV019', 150.1, 75.0, 1),
		(20, 'SRV020', 400.4, 200.2, 1);

INSERT INTO tipo_componente (nome, unidade_medida) VALUES ('RAM', '%'), ('Taxa de Transferência', 'Gb/s'), ('CPU', '%');

INSERT INTO registro (id_registro, fk_servidor, data_hora, perda_de_pacotes, uso_cpu, uso_ram, taxa_transferencia, fk_tipo) VALUES 
		(1, 1, NOW(), 5, 20, 30, 100, 1),
		(2, 2, NOW(), 2, 15, 25, 80, 1),
        (3, 3, NOW(), 0, 10, 20, 60, 1),
        (4, 4, NOW(), 3, 18, 28, 90, 2),
        (5, 5, NOW(), 1, 12, 22, 70, 2),
        (6, 6, NOW(), 4, 16, 26, 85, 2),
        (7, 7, NOW(), 2, 14, 24, 75, 3),
        (8, 8, NOW(), 0, 10, 20, 60, 3),
        (9, 9, NOW(), 5, 22, 32, 105, 3),
        (10, 10, NOW(), 1, 12, 22, 70, 1),
        (11, 11, NOW(), 3, 18, 28, 90, 1),
        (12, 12, NOW(), 2, 15, 25, 80, 2),
        (13, 13, NOW(), 0, 10, 20, 60, 2),
        (14, 14, NOW(), 4, 16, 26, 85, 3),
		(15, 15, NOW(), 3, 18, 28, 90, 3);


 
    

