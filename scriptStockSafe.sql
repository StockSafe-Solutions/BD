
DROP DATABASE IF EXISTS StockSafe;
CREATE DATABASE StockSafe;
USE StockSafe;
CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razao VARCHAR(50),
    telefone CHAR(12),
    cnpj CHAR(14)
) AUTO_INCREMENT = 5000;

CREATE TABLE funcionario (
    idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    funcao VARCHAR(45),
    dataNascimento DATE,
    foto VARCHAR(300),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
    fkGerente INT,
    FOREIGN KEY (fkGerente) REFERENCES funcionario(idFuncionario)
) AUTO_INCREMENT = 1000;
CREATE TABLE usuario(
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(45),
    senha VARCHAR(45),
    tipo CHAR(1),
    fkFuncionario INT,
    Foreign Key (fkFuncionario) REFERENCES funcionario(idFuncionario)
);

CREATE TABLE endereco (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    rua VARCHAR(50),
    numero INT,
    bairro VARCHAR(80),
    complemento VARCHAR(30),
    cep CHAR(8),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 10;
CREATE TABLE maquina (
    idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    qtdNucleos INT,
    processadoresLogicos INT,
    qtdMemoriaRam INT,
    armazenamento INT,
    fkEndereco INT,
    FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco)
) AUTO_INCREMENT = 2000;
CREATE TABLE componente (
    idComponente INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(45),
    unidadeMedida VARCHAR(45)
);

CREATE TABLE componentesMonitorados (
    fkMaquina INT,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    fkComponente INT,
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente),
    PRIMARY KEY (fkMaquina, fkComponente)
);
CREATE TABLE registro (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    dataHora DATETIME,
    valor DECIMAL(6,2),
    fkMaquina INT,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina),
    fkComponente INT,
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente)
);

DELIMITER $$
CREATE PROCEDURE stocksafe.inserirEmpresa(
    IN 
    razaoEmpresa varchar(50),
    telefone CHAR(12),
    cnpj CHAR(14),
    nome VARCHAR(50),
    funcao VARCHAR(40),
    email VARCHAR(45),
    senha VARCHAR(45),
    rua VARCHAR(300),
    numero INT,
    bairro VARCHAR(80),
    cep CHAR(8)
)
    BEGIN
        INSERT INTO empresa VALUES(NULL, razaoEmpresa, telefone, cnpj);
        INSERT INTO funcionario(nome, funcao, fkEmpresa) VALUES (nome, funcao, (SELECT 
                                                                                    idEmpresa FROM
                                                                                    empresa WHERE empresa.razao LIKE razaoEmpresa ));
        INSERT INTO usuario VALUES(NULL, email, senha, '1',(SELECT 
															idFuncionario FROM
															funcionario 
															WHERE funcionario.nome = nome
                                                                            ));
		INSERT INTO endereco (idEndereco, rua, numero, bairro, cep, fkEmpresa) VALUES
        (NULL, rua, numero, bairro, cep,(SELECT idEmpresa 
												FROM empresa 
												WHERE razao = razaoEmpresa));
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE stockSafe.inserirFuncionario(
    IN 
    nomeFuncionario VARCHAR(45),
    funcao VARCHAR(45),
    dataNascimento DATE,
    fkEmpresa INT,
    email VARCHAR(45),
    senha VARCHAR(45)
)
    BEGIN
        INSERT INTO funcionario(idFuncionario, nome, funcao, dataNascimento, fkEmpresa) VALUES(NULL,nomeFuncionario, funcao, dataNascimento, fkEmpresa);
        INSERT INTO usuario VALUES(NULL, email, senha,'2', (SELECT
															idFuncionario 
															FROM funcionario
															WHERE funcionario.nome LIKE nomeFuncionario));
END $$

DELIMITER ;

-- VIEW para pegar dados de maquina em tempo real
CREATE or REPLACE VIEW vw_maquina AS
	SELECT 
		r.idRegistro,
        r.fkMaquina,
		r.dataHora,
		MAX(CASE WHEN r.fkComponente = 3 THEN r.valor END) AS 'CPU',
        MAX(CASE WHEN r.fkComponente = 2 THEN r.valor END) AS 'disco',
        MAX(CASE WHEN r.fkComponente = 1 THEN r.valor END) AS 'RAM'
    FROM registro AS r
    GROUP BY dataHora, fkMaquina, idRegistro
    ORDER BY dataHora DESC;

-- view para a criação do gráfico de demanda de servidores
CREATE OR REPLACE VIEW vw_demanda AS
	SELECT
		DATE_FORMAT(r.dataHora, '%H:00') AS hora,
        ROUND(AVG(CASE WHEN r.fkComponente = 3 THEN r.valor END), 2) AS demandaCPU,
        ROUND(AVG(CASE WHEN r.fkComponente = 2 THEN r.valor END), 2) AS demandaDisco,
        ROUND(AVG(CASE WHEN r.fkComponente = 1 THEN r.valor END), 2) AS demandaMemoriaRAM
        FROM registro AS r
        GROUP BY hora 
        ORDER BY hora DESC;
CALL stockSafe.inserirEmpresa('B3 S.A. - BRASIL,BOLSA, BALCAO','551125655061','09346601000125','B3','Empresa','b3@gmail.com','123456','R. Quinze de Novembro',
        275, 'São Paulo', '01010901');

CALL stockSafe.inserirFuncionario('Henrique','Analista','2023-03-24',5000,'henrique@gmail.com','123456');
CALL stockSafe.inserirFuncionario('Gabriel','Analista','2023-03-24',5000,'gabriel@gmail.com','123456');
CALL stockSafe.inserirFuncionario('Gilberto','Analista','2023-03-24',5000,'Gilberto@gmail.com','123456');
CALL stockSafe.inserirFuncionario('Sofhia','Analista','2023-03-24',5000,'sofhia@gmail.com','123456');
CALL stockSafe.inserirFuncionario('Vinicius','Analista','2023-03-24',5000,'vinicius@gmail.com','123456');

INSERT INTO componente VALUES(NULL, 'Memória RAM', 'Porcentagem'),
                            (NULL, 'Disco', 'Porcentagem'),
                             (NULL, 'CPU', 'Porcentagem');
                             
INSERT INTO maquina VALUES(2000, 4, 8, 8, 256, 10),
						  (2001, 4, 8, 8, 256, 10),
                          (2002, 4, 8, 8, 256, 10),
                          (2003, 4, 8, 8, 256, 10),
                          (2004, 4, 8, 8, 256, 10);
	

INSERT INTO componentesMonitorados VALUES(2000, 1),
                                          (2000, 2),
                                          (2000, 3),
                                          (2001,1),
                                          (2001,2),
                                          (2001,3),
                                          (2002,1),
                                          (2002,2),
                                          (2002,3),
                                          (2003,1),
                                          (2003,2),
                                          (2003,3),
                                          (2004,1),
                                          (2004,2),
                                          (2004,3);
select * from registro Order by idRegistro desc;
INSERT INTO registro VALUES
    (NULL, '2023-09-12 10:05', 14.9, 2000, 1),
    (NULL, '2023-09-12 11:15', 75.6, 2000, 2),
    (NULL, '2023-09-12 12:20', 8.7, 2000, 3),
    (NULL, '2023-09-12 13:35', 12.3, 2001, 1),
    (NULL, '2023-09-12 14:55', 57.8, 2001, 2),
    (NULL, '2023-09-12 16:10', 14.5, 2001, 3),
    (NULL, '2023-09-12 09:40', 98.7, 2000, 1),
    (NULL, '2023-09-12 10:55', 51.2, 2000, 2),
    (NULL, '2023-09-12 12:15', 9.4, 2000, 3),
    (NULL, '2023-09-12 13:25', 87.3, 2001, 1),
    (NULL, '2023-09-12 14:40', 52.1, 2001, 2),
    (NULL, '2023-09-12 15:55', 17.8, 2001, 3),
    (NULL, '2023-09-12 17:00', 12.8, 2000, 1),
    (NULL, '2023-09-12 09:10', 95.2, 2000, 2),
    (NULL, '2023-09-12 10:20', 9.3, 2000, 3),
    (NULL, '2023-09-12 11:30', 86.9, 2001, 1),
    (NULL, '2023-09-12 12:45', 50.5, 2001, 2),
    (NULL, '2023-09-12 14:00', 15.3, 2001, 3),
    (NULL, '2023-09-12 15:15', 14.2, 2000, 1),
    (NULL, '2023-09-12 16:30', 59.6, 2000, 2),
    (NULL, '2023-09-12 17:45', 10.9, 2000, 3),
    (NULL, '2023-09-12 09:20', 82.6, 2001, 1),
    (NULL, '2023-09-12 10:35', 77.5, 2001, 2),
    (NULL, '2023-09-12 11:50', 11.8, 2001, 3),
    (NULL, '2023-09-12 13:05', 81.5, 2000, 1),
    (NULL, '2023-09-12 14:20', 56.4, 2000, 2),
    (NULL, '2023-09-12 15:35', 12.7, 2000, 3),
    (NULL, '2023-09-12 17:55', 19.0, 2000, 1),
    (NULL, '2023-09-12 09:35', 94.7, 2000, 2),
    (NULL, '2023-09-12 10:50', 14.0, 2000, 3),
    (NULL, '2023-09-12 12:05', 82.4, 2001, 1),
    (NULL, '2023-09-12 13:20', 59.9, 2001, 2),
    (NULL, '2023-09-12 14:35', 17.3, 2001, 3),
    (NULL, '2023-09-12 15:50', 13.6, 2000, 1),
    (NULL, '2023-09-12 17:05', 79.2, 2000, 2),
    (NULL, '2023-09-12 09:15', 11.7, 2000, 3),
    (NULL, '2023-09-12 10:30', 84.6, 2001, 1),
    (NULL, '2023-09-12 11:45', 56.3, 2001, 2),
    (NULL, '2023-09-12 13:00', 15.1, 2001, 3),
    (NULL, '2023-09-12 14:15', 14.5, 2000, 1),
    (NULL, '2023-09-12 15:30', 58.8, 2000, 2),
    (NULL, '2023-09-12 16:45', 11.4, 2000, 3),
    (NULL, '2023-09-12 09:25', 81.3, 2001, 1),
    (NULL, '2023-09-12 10:40', 58.1, 2001, 2),
    (NULL, '2023-09-12 11:55', 16.7, 2001, 3),
    (NULL, '2023-09-12 13:10', 14.3, 2000, 1),
    (NULL, '2023-09-12 14:25', 59.0, 2000, 2),
    (NULL, '2023-09-12 15:40', 12.2, 2000, 3),
    (NULL, '2023-09-12 16:00', 75.8, 2000, 1),
    (NULL, '2023-09-12 10:10', 52.7, 2000, 2),
    (NULL, '2023-09-12 11:20', 18.2, 2000, 3),
    (NULL, '2023-09-12 12:30', 89.5, 2001, 1),
    (NULL, '2023-09-12 13:45', 55.4, 2001, 2),
    (NULL, '2023-09-12 15:00', 13.4, 2001, 3),
    (NULL, '2023-09-12 16:15', 15.9, 2000, 1),
    (NULL, '2023-09-12 09:50', 74.6, 2000, 2),
    (NULL, '2023-09-12 11:05', 11.2, 2000, 3),
    (NULL, '2023-09-12 12:20', 89.3, 2001, 1),
    (NULL, '2023-09-12 13:35', 54.6, 2001, 2),
    (NULL, '2023-09-12 14:50', 18.1, 2001, 3),
    (NULL, '2023-09-12 16:05', 18.6, 2000, 1),
    (NULL, '2023-09-12 10:00', 71.3, 2000, 2),
    (NULL, '2023-09-12 11:15', 15.2, 2000, 3),
    (NULL, '2023-09-12 12:25', 80.2, 2001, 1),
    (NULL, '2023-09-12 13:40', 52.9, 2001, 2),
    (NULL, '2023-09-12 14:55', 12.7, 2001, 3),
    (NULL, '2023-09-12 16:10', 13.4, 2000, 1),
    (NULL, '2023-09-12 09:40', 75.1, 2000, 2),
    (NULL, '2023-09-12 11:00', 10.6, 2000, 3),
    (NULL, '2023-09-12 12:15', 85.3, 2001, 1),
    (NULL, '2023-09-12 13:30', 56.2, 2001, 2),
    (NULL, '2023-09-12 14:45', 16.8, 2001, 3),
    (NULL, '2023-09-12 16:00', 14.3, 2000, 1),
    (NULL, '2023-09-12 09:25', 73.8, 2000, 2),
    (NULL, '2023-09-12 10:40', 13.2, 2000, 3),
    (NULL, '2023-09-12 11:55', 81.7, 2001, 1),
    (NULL, '2023-09-12 13:10', 58.6, 2001, 2),
    (NULL, '2023-09-12 14:25', 12.5, 2001, 3),
    (NULL, '2023-09-12 15:40', 13.7, 2000, 1),
    (NULL, '2023-09-12 17:00', 79.1, 2000, 2),
    (NULL, '2023-09-12 09:15', 15.5, 2000, 3),
    (NULL, '2023-09-12 10:30', 81.9, 2001, 1),
    (NULL, '2023-09-12 11:45', 52.3, 2001, 2),
    (NULL, '2023-09-12 13:00', 14.9, 2001, 3),
    (NULL, '2023-09-12 14:15', 13.1, 2000, 1),
    (NULL, '2023-09-12 15:30', 59.5, 2000, 2),
    (NULL, '2023-09-12 16:45', 14.8, 2000, 3),
    (NULL, '2023-09-12 09:35', 16.2, 2001, 1),
    (NULL, '2023-09-12 10:50', 53.8, 2001, 2),
    (NULL, '2023-09-12 12:05', 15.6, 2001, 3),
    (NULL, '2023-09-12 13:20', 15.3, 2000, 1),
    (NULL, '2023-09-12 14:35', 54.3, 2000, 2),
    (NULL, '2023-09-12 15:50', 11.7, 2000, 3),
    (NULL, '2023-09-12 17:05', 12.9, 2000, 1),
    (NULL, '2023-09-12 09:30', 75.9, 2000, 2),
    (NULL, '2023-09-12 10:45', 12.4, 2000, 3),
    (NULL, '2023-09-12 12:00', 86.1, 2001, 1),
    (NULL, '2023-09-12 13:15', 53.7, 2001, 2),
    (NULL, '2023-09-12 14:30', 18.5, 2001, 3),
    (NULL, '2023-09-12 15:45', 14.9, 2000, 1),
    (NULL, '2023-09-12 17:00', 57.2, 2000, 2),
    (NULL, '2023-09-12 09:20', 11.3, 2000, 3),
    (NULL, '2023-09-12 10:35', 82.9, 2001, 1),
    (NULL, '2023-09-12 11:50', 55.1, 2001, 2),
    (NULL, '2023-09-12 13:05', 17.6, 2001, 3),
    (NULL, '2023-09-12 14:20', 16.7, 2000, 1),
    (NULL, '2023-09-12 15:35', 58.4, 2000, 2),
    (NULL, '2023-09-12 16:50', 14.1, 2000, 3),
    (NULL, '2023-09-12 09:45', 12.8, 2001, 1),
    (NULL, '2023-09-12 11:00', 84.5, 2001, 2),
    (NULL, '2023-09-12 12:15', 53.2, 2001, 3),
    (NULL, '2023-09-12 18:00', 17.5, 2002, 1),
    (NULL, '2023-09-12 09:30', 56.2, 2002, 2),
    (NULL, '2023-09-12 11:45', 14.9, 2002, 3),
    (NULL, '2023-09-12 13:00', 13.1, 2003, 1),
    (NULL, '2023-09-12 14:15', 59.5, 2003, 2),
    (NULL, '2023-09-12 15:30', 14.8, 2003, 3),
    (NULL, '2023-09-12 17:05', 12.9, 2002, 1),
    (NULL, '2023-09-12 09:30', 75.9, 2002, 2),
    (NULL, '2023-09-12 10:45', 12.4, 2002, 3),
    (NULL, '2023-09-12 12:00', 86.1, 2003, 1),
    (NULL, '2023-09-12 13:15', 53.7, 2003, 2),
    (NULL, '2023-09-12 14:30', 18.5, 2003, 3),
    (NULL, '2023-09-12 15:45', 14.9, 2002, 1),
    (NULL, '2023-09-12 17:00', 57.2, 2002, 2),
    (NULL, '2023-09-12 09:20', 11.3, 2002, 3),
    (NULL, '2023-09-12 10:35', 82.9, 2003, 1),
    (NULL, '2023-09-12 11:50', 55.1, 2003, 2),
    (NULL, '2023-09-12 13:05', 17.6, 2003, 3),
    (NULL, '2023-09-12 14:20', 16.7, 2002, 1),
    (NULL, '2023-09-12 15:35', 58.4, 2002, 2),
    (NULL, '2023-09-12 16:50', 14.1, 2002, 3),
    (NULL, '2023-09-12 09:45', 12.8, 2003, 1),
    (NULL, '2023-09-12 11:00', 84.5, 2003, 2),
    (NULL, '2023-09-12 12:15', 53.2, 2003, 3),
    (NULL, '2023-09-12 13:30', 19.3, 2002, 1),
    (NULL, '2023-09-12 14:45', 56.1, 2002, 2),
    (NULL, '2023-09-12 16:00', 16.4, 2002, 3),
    (NULL, '2023-09-12 17:15', 13.7, 2003, 1),
    (NULL, '2023-09-12 09:10', 72.4, 2003, 2),
    (NULL, '2023-09-12 10:25', 14.2, 2003, 3),
    (NULL, '2023-09-12 11:40', 83.7, 2002, 1),
    (NULL, '2023-09-12 12:55', 57.6, 2002, 2),
    (NULL, '2023-09-12 14:10', 18.9, 2002, 3),
    (NULL, '2023-09-12 15:25', 17.3, 2003, 1),
    (NULL, '2023-09-12 16:40', 55.9, 2003, 2),
    (NULL, '2023-09-12 17:55', 11.8, 2003, 3),
    (NULL, '2023-09-12 09:05', 14.3, 2002, 1),
    (NULL, '2023-09-12 10:20', 89.7, 2002, 2),
    (NULL, '2023-09-12 11:35', 52.4, 2002, 3),
    (NULL, '2023-09-12 12:50', 19.7, 2003, 1),
    (NULL, '2023-09-12 14:05', 57.8, 2003, 2),
    (NULL, '2023-09-12 15:20', 13.2, 2003, 3),
    (NULL, '2023-09-12 16:35', 15.5, 2002, 1),
    (NULL, '2023-09-12 17:50', 55.3, 2002, 2),
    (NULL, '2023-09-12 09:00', 13.7, 2002, 3),
    (NULL, '2023-09-12 10:15', 81.2, 2003, 1),
    (NULL, '2023-09-12 11:30', 58.6, 2003, 2),
    (NULL, '2023-09-12 12:45', 15.1, 2003, 3),
    (NULL, '2023-09-12 14:00', 14.4, 2002, 1),
    (NULL, '2023-09-12 15:15', 55.7, 2002, 2),
    (NULL, '2023-09-12 16:30', 12.6, 2002, 3),
    (NULL, '2023-09-12 17:45', 11.9, 2003, 1),
    (NULL, '2023-09-12 09:55', 79.4, 2003, 2),
    (NULL, '2023-09-12 11:10', 12.3, 2003, 3),
    (NULL, '2023-09-12 12:25', 89.8, 2002, 1),
    (NULL, '2023-09-12 13:40', 54.7, 2002, 2),
    (NULL, '2023-09-12 14:55', 18.7, 2002, 3),
    (NULL, '2023-09-12 16:10', 14.6, 2003, 1),
    (NULL, '2023-09-12 17:25', 57.3, 2003, 2),
    (NULL, '2023-09-12 18:40', 16.2, 2003, 3),
    (NULL, '2023-09-12 18:00', 16.7, 2004, 1),
    (NULL, '2023-09-12 09:30', 55.3, 2004, 2),
    (NULL, '2023-09-12 11:45', 12.9, 2004, 3),
    (NULL, '2023-09-12 13:00', 14.1, 2004, 1),
    (NULL, '2023-09-12 14:15', 53.5, 2004, 2),
    (NULL, '2023-09-12 15:30', 18.8, 2004, 3),
    (NULL, '2023-09-12 17:05', 13.2, 2004, 1),
    (NULL, '2023-09-12 18:30', 52.7, 2004, 2), 
    (NULL, '2023-09-12 09:30', 12.4, 2004, 3),
    (NULL, '2023-09-12 12:00', 86.1, 2004, 1),
    (NULL, '2023-09-12 13:15', 55.7, 2004, 2),
    (NULL, '2023-09-12 14:30', 17.6, 2004, 3),
    (NULL, '2023-09-12 15:45', 14.9, 2004, 1),
    (NULL, '2023-09-12 17:00', 57.2, 2004, 2),
    (NULL, '2023-09-12 09:20', 11.3, 2004, 3),
    (NULL, '2023-09-12 10:35', 82.9, 2004, 1),
    (NULL, '2023-09-12 11:50', 55.1, 2004, 2),
    (NULL, '2023-09-12 13:05', 17.6, 2004, 3),
    (NULL, '2023-09-12 14:20', 16.7, 2004, 1),
    (NULL, '2023-09-12 15:35', 58.4, 2004, 2),
    (NULL, '2023-09-12 16:50', 14.1, 2004, 3),
    (NULL, '2023-09-12 09:45', 12.8, 2004, 1),
    (NULL, '2023-09-12 11:00', 84.5, 2004, 2),
    (NULL, '2023-09-12 12:15', 53.2, 2004, 3),
    (NULL, '2023-09-12 13:30', 19.3, 2004, 1),
    (NULL, '2023-09-12 14:45', 56.1, 2004, 2),
    (NULL, '2023-09-12 16:00', 16.4, 2004, 3),
    (NULL, '2023-09-12 17:15', 13.7, 2004, 1),
    (NULL, '2023-09-12 09:10', 72.4, 2004, 2),
    (NULL, '2023-09-12 10:25', 14.2, 2004, 3),
    (NULL, '2023-09-12 11:40', 83.7, 2004, 1),
    (NULL, '2023-09-12 12:55', 57.6, 2004, 2),
    (NULL, '2023-09-12 14:10', 18.9, 2004, 3),
    (NULL, '2023-09-12 15:25', 17.3, 2004, 1),
    (NULL, '2023-09-12 16:40', 55.9, 2004, 2),
    (NULL, '2023-09-12 17:55', 11.8, 2004, 3),
    (NULL, '2023-09-12 09:05', 14.3, 2004, 1),
    (NULL, '2023-09-12 10:20', 89.7, 2004, 2),
    (NULL, '2023-09-12 11:35', 52.4, 2004, 3),
    (NULL, '2023-09-12 12:50', 19.7, 2004, 1),
    (NULL, '2023-09-12 14:05', 57.8, 2004, 2),
    (NULL, '2023-09-12 15:20', 13.2, 2004, 3),
    (NULL, '2023-09-12 16:35', 11.6, 2004, 1),
    (NULL, '2023-09-12 17:50', 53.1, 2004, 2);
    
    
    
    
    
    
    


