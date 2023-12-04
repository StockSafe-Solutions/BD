CREATE DATABASE IF NOT EXISTS StockSafe;
USE StockSafe;

-- DROP DATABASE StockSafe;

/*
CREATE USER IF NOT EXISTS 'StockSafe'@'localhost' IDENTIFIED BY 'urubu100';
GRANT ALL PRIVILEGES ON StockSafe.* TO 'StockSafe'@'localhost';
FLUSH PRIVILEGES;
*/

CREATE TABLE IF NOT EXISTS tb_funcionario (
  id_funcionario INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(125),
  funcao VARCHAR(75),
  data_nascimento DATE,
  foto VARCHAR(300) NULL,
  email VARCHAR(125),
  senha VARCHAR(20),
  PRIMARY KEY (id_funcionario)
  );
  
CREATE TABLE IF NOT EXISTS tb_servidor (
  id_servidor INT NOT NULL AUTO_INCREMENT,
  codigo CHAR(6) NOT NULL,
  armazenamento_total DECIMAL(4,1) NULL,
  armazenamento_usado DECIMAL(4,1) NULL,
  id_autenticador INT,
  PRIMARY KEY (id_servidor),
  FOREIGN KEY (id_autenticador) REFERENCES tb_funcionario (id_funcionario)
    );

CREATE TABLE IF NOT EXISTS tb_categoria(
	id_cat INT NOT NULL,
    tipo_cat VARCHAR(45) NOT NULL,
    unidade_cat VARCHAR(25),
    PRIMARY KEY (id_cat)
	);

CREATE TABLE IF NOT EXISTS tb_monitorar(
	fk_servidor INT NOT NULL,
    fk_cat INT NOT NULL,
    PRIMARY KEY (fk_servidor, fk_cat),
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
    FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
	);

CREATE TABLE IF NOT EXISTS tb_registro (
  id_registro INT NOT NULL AUTO_INCREMENT,
  fk_servidor INT NOT NULL,
  fk_cat INT NOT NULL,
  data_hora DATETIME DEFAULT(now()),
  valor DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_registro, fk_servidor,fk_cat),
  FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
  FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
	);
    
CREATE TABLE IF NOT EXISTS tb_opcao (
  id_opcao INT NOT NULL AUTO_INCREMENT,
  banda_larga SMALLINT DEFAULT 155,
  taxa_de_transferência DECIMAL(10,2) DEFAULT 1000.00,
  intervalo_atualizacao INT DEFAULT 60000,
  PRIMARY KEY (id_opcao)
  );
  
CREATE TABLE IF NOT EXISTS tb_alerta (
	id_alerta INT NOT NULL AUTO_INCREMENT,
	data_hora DATETIME DEFAULT(now()),
    nivel_alerta TINYINT NOT NULL,
    visualizado BOOLEAN DEFAULT(0),
	descricao VARCHAR(250) NOT NULL,
    fk_servidor INT NOT NULL,
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor(id_servidor),
    CHECK (nivel_alerta IN (0,1,2,3)),
    PRIMARY KEY (id_alerta)
    );