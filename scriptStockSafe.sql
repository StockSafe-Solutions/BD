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
  




