DELIMITER $$
CREATE PROCEDURE sp_cpu_maquina(v_fk_servidor INT)
	BEGIN
		SELECT fk_servidor, uso_cpu FROM tb_registro
			WHERE fk_servidor = 2001 AND uso_cpu IS NOT NULL;
    END
$$ DELIMITER ;
CALL sp_cpu_maquina(1);

SELECT perda_de_pacotes FROM registro;