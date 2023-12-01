DROP DATABASE StockSafe;
CREATE DATABASE StockSafe;
USE StockSafe;

CREATE TABLE tb_funcionario (
    id_funcionario INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(125),
    funcao VARCHAR(75),
    data_nascimento DATE,
    foto VARCHAR(300) null,
    email VARCHAR(125),
    senha VARCHAR(20),
    PRIMARY KEY (id_funcionario)
  )

  CREATE TABLE tb_servidor (
    id_servidor INT IDENTITY(1, 1) NOT NULL,
    codigo CHAR(6) NOT NULL,
    armazenamento_total DECIMAL(4, 1) null,
    armazenamento_usado DECIMAL(4, 1) null,
    id_autenticador INT,
    PRIMARY KEY (id_servidor),
    FOREIGN KEY (id_autenticador) REFERENCES tb_funcionario (id_funcionario)
  )

  CREATE TABLE tb_categoria (
    id_cat INT NOT NULL,
    tipo_cat VARCHAR(45) NOT NULL,
    unidade_cat VARCHAR(25),
    PRIMARY KEY (id_cat)
  )

  CREATE TABLE tb_monitorar (
    fk_servidor INT NOT NULL,
    fk_cat INT NOT NULL,
    PRIMARY KEY (fk_servidor, fk_cat),
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
    FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
  )

  CREATE TABLE tb_registro (
    id_registro INT IDENTITY(1, 1) NOT NULL,
    fk_servidor INT NOT NULL,
    fk_cat INT NOT NULL,
    data_hora DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (id_registro, fk_servidor, fk_cat),
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
    FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
  )

  CREATE TABLE tb_opcao (
    id_opcao INT IDENTITY(1, 1) NOT NULL,
    banda_larga SMALLINT DEFAULT 155,
    taxa_de_transferencia DECIMAL(10, 2) DEFAULT 1000.00,
    INTervalo_atualizacao INT DEFAULT 60000,
    PRIMARY KEY (id_opcao)
  )
  
  
  CREATE TABLE tb_alerta (
    id_alerta INT IDENTITY(1, 1) NOT NULL,
    data_hora DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    nivel_alerta TINYINT NOT NULL,
    visualizado BIT DEFAULT 0,
    descricao VARCHAR(250) NOT NULL,
    fk_servidor INT NOT NULL,
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
    CHECK (nivel_alerta in (0, 1, 2, 3)),
    PRIMARY KEY (id_alerta)
  )

CREATE TABLE tb_tag (
  id_tag INT IDENTITY(1, 1) NOT NULL,
  nome_tag VARCHAR(75) NOT NULL,
  cor_tag CHAR(6) NOT NULL,
  UNIQUE (nome_tag),
  PRIMARY KEY (id_tag)
);

CREATE TABLE tb_tag_servidor (
  fk_servidor INT NOT NULL,
  fk_tag INT NOT NULL,
  FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
  FOREIGN KEY (fk_tag) REFERENCES tb_tag (id_tag),
  PRIMARY KEY (fk_servidor, fk_tag)
);