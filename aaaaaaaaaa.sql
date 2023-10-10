-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema stocksafe
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`funcionario` (
  `id_funcionario` INT NOT NULL,
  `nome` VARCHAR(125) NOT NULL,
  `funcao` VARCHAR(75) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `foto` VARCHAR(300) NULL,
  `email` VARCHAR(125) NOT NULL,
  `senha` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id_funcionario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`servidor` (
  `id_servidor` INT NOT NULL,
  `codigo` CHAR(6) NOT NULL,
  `armazenamento_total` DECIMAL(4,1) NULL,
  `armazenamento_usado` DECIMAL(4,1) NULL,
  `id_autenticador` INT NOT NULL,
  PRIMARY KEY (`id_servidor`, `id_autenticador`),
  INDEX `fk_servidor_funcionario1_idx` (`id_autenticador` ASC) VISIBLE,
  CONSTRAINT `fk_servidor_funcionario1`
    FOREIGN KEY (`id_autenticador`)
    REFERENCES `mydb`.`funcionario` (`id_funcionario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tipoComponente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tipoComponente` (
  `id_tipo` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `unidade_medida` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id_tipo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`registro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`registro` (
  `id_registro` INT NOT NULL,
  `fk_servidor` INT NOT NULL,
  `data_hora` DATETIME NOT NULL DEFAULT now(),
  `perda_de_pacotes` TINYINT NULL,
  `uso_cpu` TINYINT NULL,
  `uso_ram` TINYINT NULL,
  `taxa_transferencia` TINYINT NULL,
  `fk_tipo` INT NOT NULL,
  PRIMARY KEY (`id_registro`, `fk_servidor`),
  INDEX `fk_registro_maquina1_idx` (`fk_servidor` ASC) VISIBLE,
  INDEX `fk_registro_componente1_idx` (`fk_tipo` ASC) VISIBLE,
  CONSTRAINT `fk_registro_maquina1`
    FOREIGN KEY (`fk_servidor`)
    REFERENCES `mydb`.`servidor` (`id_servidor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registro_componente1`
    FOREIGN KEY (`fk_tipo`)
    REFERENCES `mydb`.`tipoComponente` (`id_tipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`opcao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`opcao` (
  `id_opcao` INT NOT NULL,
  `banda_larga` SMALLINT NOT NULL,
  `taxa_transferencia` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_opcao`))
ENGINE = InnoDB;

USE `mydb` ;

-- -----------------------------------------------------
-- Placeholder table for view `mydb`.`vw_maquina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vw_maquina` (`idRegistro` INT, `fkMaquina` INT, `dataHora` INT, `'CPU'` INT, `'disco'` INT, `'RAM'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `mydb`.`vw_demanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`vw_demanda` (`hora` INT, `'demanda CPU'` INT, `'demanda Disco'` INT, `'demanda de memoria RAM'` INT);

-- -----------------------------------------------------
-- View `mydb`.`vw_maquina`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vw_maquina`;
USE `mydb`;
CREATE or REPLACE VIEW vw_maquina AS
	SELECT 
		registro.idRegistro,
        registro.fkMaquina,
		registro.dataHora,
		MAX(CASE WHEN registro.fkComponente = 3 THEN registro.valor END) AS 'CPU',
        MAX(CASE WHEN registro.fkComponente = 2 THEN registro.valor END) AS 'disco',
        MAX(CASE WHEN registro.fkComponente = 1 THEN registro.valor END) AS 'RAM'
    FROM registro
    GROUP BY dataHora, fkMaquina, idRegistro;

-- -----------------------------------------------------
-- View `mydb`.`vw_demanda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vw_demanda`;
USE `mydb`;
CREATE OR REPLACE VIEW vw_demanda AS
	SELECT
		DATE_FORMAT(r.dataHora, '%H:%i') AS hora,
        ROUND(AVG(CASE WHEN r.fkComponente = 3 THEN r.valor END), 2) AS 'demanda CPU',
        ROUND(AVG(CASE WHEN r.fkComponente = 2 THEN r.valor END), 2) AS 'demanda Disco',
        ROUND(AVG(CASE WHEN r.fkComponente = 1 THEN r.valor END), 2) AS 'demanda de memoria RAM'
        FROM registro AS r
        GROUP BY hora 
        ORDER BY hora DESC;
SELECT * FROM vw_demanda;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
