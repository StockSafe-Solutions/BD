CREATE DATABASE StockSafe;
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
    
    INSERT INTO servidor (id_servidor, codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUE(1, 'SRV001', 500.5, 250.2, 1),
		(2, 'SRV002', 750.0, 375.5, 2),
        (3, 'SRV003', 300.3, 150.1, 3),
        (4, 'SRV004', 1000.0, 500.0, 4),
        (5, 'SRV005', 800.8, 400.4, 5),
        (6, 'SRV006', 600.6, 300.3, 6),
        (7, 'SRV007', 900.9, 450.4, 7),
        (8, 'SRV008', 400.4, 200.2, 8),
        (9, 'SRV009', 700.7, 350.3, 9),
        (10, 'SRV010', 1200.0, 600.0, 10),
        (11, 'SRV011', 450.4, 225.2, 11),
        (12, 'SRV012', 850.8, 425.4, 12),
        (13, 'SRV013', 250.2, 125.1, 13),
        (14, 'SRV014', 950.9, 475.5, 14),
        (15, 'SRV015', 550.5, 275.2, 15),
        (16, 'SRV016', 1100.0, 550.0, 16),
        (17, 'SRV017', 350.3, 175.1, 17),
        (18, 'SRV018', 650.6, 325.3, 18),
        (19, 'SRV019', 150.1, 75.0, 19),
		(20, 'SRV020', 400.4, 200.2, 20);

    

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
  




