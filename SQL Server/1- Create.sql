IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'StockSafe')
    CREATE DATABASE StockSafe;
GO
USE StockSafe;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_funcionario')
BEGIN
	CREATE TABLE dbo.tb_funcionario (
		id_funcionario INT IDENTITY(1, 1) NOT NULL,
		nome VARCHAR(125),
		funcao VARCHAR(75),
		data_nascimento DATE,
		foto VARCHAR(300) null,
		email VARCHAR(125),
		senha VARCHAR(20),
		PRIMARY KEY (id_funcionario)
	  )
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_servidor')
BEGIN
	CREATE TABLE dbo.tb_servidor (
		id_servidor INT IDENTITY(1, 1) NOT NULL,
		codigo CHAR(6) NOT NULL,
		armazenamento_total DECIMAL(4, 1) null,
		armazenamento_usado DECIMAL(4, 1) null,
		id_autenticador INT,
		PRIMARY KEY (id_servidor),
		FOREIGN KEY (id_autenticador) REFERENCES tb_funcionario (id_funcionario)
	)
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_categoria')
BEGIN
	CREATE TABLE dbo.tb_categoria (
		id_cat INT NOT NULL,
		tipo_cat VARCHAR(45) NOT NULL,
		unidade_cat VARCHAR(25),
		PRIMARY KEY (id_cat)
	)
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_monitorar')
BEGIN
	CREATE TABLE dbo.tb_monitorar (
		fk_servidor INT NOT NULL,
		fk_cat INT NOT NULL,
		PRIMARY KEY (fk_servidor, fk_cat),
		FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
		FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
	)
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_registro')
BEGIN
	CREATE TABLE dbo.tb_registro (
		id_registro INT IDENTITY(1, 1) NOT NULL,
		fk_servidor INT NOT NULL,
		fk_cat INT NOT NULL,
		data_hora DATETIME2 DEFAULT CURRENT_TIMESTAMP,
		valor DECIMAL(8, 2) NOT NULL,
		PRIMARY KEY (id_registro, fk_servidor, fk_cat),
		FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
		FOREIGN KEY (fk_cat) REFERENCES tb_categoria (id_cat)
	)
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_opcao')
BEGIN
  CREATE TABLE tb_opcao (
    id_opcao INT IDENTITY(1, 1) NOT NULL,
    banda_larga SMALLINT DEFAULT 155,
    taxa_de_transferencia DECIMAL(10, 2) DEFAULT 1000.00,
    intervalo_atualizacao INT DEFAULT 60000,
    PRIMARY KEY (id_opcao)
  )
END
  
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_alerta')
BEGIN
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
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_tag')
BEGIN
	CREATE TABLE dbo.tb_tag (
		id_tag INT IDENTITY(1, 1) NOT NULL,
		nome_tag VARCHAR(75) NOT NULL,
		cor_tag VARCHAR(18) NOT NULL,
		UNIQUE (nome_tag),
		PRIMARY KEY (id_tag)
	);
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_tag_servidor')
BEGIN
	CREATE TABLE dbo.tb_tag_servidor (
		fk_servidor INT NOT NULL,
		fk_tag INT NOT NULL,
		FOREIGN KEY (fk_servidor) REFERENCES tb_servidor (id_servidor),
		FOREIGN KEY (fk_tag) REFERENCES tb_tag (id_tag),
		PRIMARY KEY (fk_servidor, fk_tag)
	);
END


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'tb_processo')
BEGIN
	CREATE TABLE dbo.tb_processo (
    id_proc INT NOT NULL IDENTITY(1,1),
    pid_proc INT NOT NULL,
    nome_proc VARCHAR(100),
    data_hora DATETIME DEFAULT(GETDATE()),
    uso_cpu DECIMAL(5,2) NOT NULL,
    uso_ram DECIMAL(5,2) NOT NULL,
    uso_bytes_mb DECIMAL(6,2) NOT NULL,
    uso_memoria_virtual_mb DECIMAL(6,2) NOT NULL,
    fk_servidor INT NOT NULL,
    FOREIGN KEY (fk_servidor) REFERENCES tb_servidor(id_servidor),
    PRIMARY KEY (id_proc)
);
END