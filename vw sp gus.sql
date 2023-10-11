DELIMITER $$
CREATE PROCEDURE sp_cpu_maquina(v_fk_servidor INT)
	BEGIN
		SELECT fk_servidor, uso_cpu FROM tb_registro
			WHERE fk_servidor = v_fk_servidor AND uso_cpu IS NOT NULL;
    END
$$ DELIMITER ;
CALL sp_cpu_maquina(2001);

SELECT AVG(pacotes_enviados) FROM tb_registro GROUP BY fk_servidor