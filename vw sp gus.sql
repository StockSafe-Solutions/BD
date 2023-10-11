DELIMITER $$
CREATE PROCEDURE sp_cpu_maquina(v_fk_servidor INT)
	BEGIN
		SELECT fk_servidor, uso_cpu FROM registro
			WHERE fk_servidor = v_fk_servidor;
    END
$$ DELIMITER ;

CALL sp_cpu_maquina(5);

SELECT perda_de_pacotes FROM registro;